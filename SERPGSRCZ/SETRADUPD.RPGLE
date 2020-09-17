     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade database update')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRADUPD - SECURITIES TRADES DATABASE UPDATE                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD020922           Date 26Jun13               *
      *                 AR1092084          Date 03Apr13               *
      *                 AR632291           Date 24Aug10               *
      *                 CSW210             Date 04May10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23123           Date 09Mar09               *
      *                 BUG22911           Date 17Feb09               *
      *                 CER048             Date 19May08               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG25979           Date 11Sep09               *
      *                 BUG24775           Date 10Jul09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 240736A            Date 15Jun07               *
      *                 BUG14514           Date 02Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245970             Date 01Mar07               *
      *                 243774A            Date 16Jan07               *
      *                 223022             Date 04Dec06               *
      *                 230335             Date 01Dec06               *
      *                 243774             Date 02Aug06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12938           Date 20Dec06               *
      *                 BUG12372           Date 28Oct06               *
      *                 CPK025             Date 29Aug06               *
      *                 240736             Date 12Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 238859             Date 21Apr06               *
      *                 BUG11114           Date 06Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAP087             Date 09Sep05               *
      *                 BUG7975            Date 20Jul05               *
      *                 CSE075             Date 17Nov05               *
      *                 236679             Date 26Oct05               *
      *                 235453             Date 12Aug05               *
      *                 235112             Date 16Sep05               *
      *                 236073             Date 16Sep05               *
      *                 235546             Date 27Jul05               *
      *                 234440             Date 22Jun05               *
      *                 236705             Date 18Jun05               *
      *                 233615             Date 16May05               *
      *                 233566             Date 17May05               *
      *                 CGL031             Date 05Jul04               *
      *                 BUG8102R           Date 17Aug05               *
      *                 BUG7703            Date 09Sep05               *
      *                 BUG8102            Date 04Aug05               *
      *                 CSE065             Date 08Nov04               *
      *                 BUG8260            Date 26Aug05               *
      *                 CSE071             Date 26May05               *
      *                 BUG7029            Date 10Jun05               *
      *                 223870             Date 18Jan04               *
      *                 215727             Date 12Aug03               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3947            Date 18Aug04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 227015  (BUG2501)  Date 11May04               *
      *                 TDA035             Date 02Apr04               *
      *                 CRE020             Date 20Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 CSE045             Date 24Mar03               *
      *                 CAP084             Date 07Jul03               *
      *                 CDE005             Date 20Aug02               *
      *                 CAS006             Date 21Jan03               *
      *                 CSE039             Date 31Mar03               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 210517             Date 21Nov02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 208195             Date 12Aug02               *
      *                 203470             Date 14May02               *
      *                 196449             Date 19Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      *                 CSC011             Date 18Sep01               *
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028             Date 06Jun01               *
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 191691             Date 02Apr01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      *                 179084             Date 27Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      *                 CDE001             Date 13Apr00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 16Nov99               *
      *                 CPB001             Date 01Jun99               *
      *                 CAP013             Date 07Sep99               *
      *                 168345             Date 14Oct99               *
      *                 168532             Date 04Oct99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP006             Date 18Mar99               *
      *                 154562             Date 01Feb99               *
      *                 149162             Date  7Dec98               *
      *                 CAP003  *CREATE    Date 01Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD020922 - Serious Midas error encountered when authorising  *
      *             trade. Removed the condition of checking Trade &  *
      *             Book Position Reconcilable field (BVTBRC) as this *
      *             applies to Book positions which has a validation  *
      *             in SETSETIVAL.                                    *
      *  AR1092084 - A serious midas error has occurred upon hitting  *
      *           Confirm Authorised Input an Auto Settle TRAD.       *
      *  AR632291 - BULK MT515-518 messages are not generated when    *
      *             Deliver To and Deliver From are not the same      *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG23123 - Report: Does not show Retail Account Number       *
      *                     Date is not Midas Standard Date           *
      *                     Period should be actual int. calc. period *
      *                     Secondary Tax amount is not printed       *
      *                     Added field TSSLID                        *
      *                     (Recompile)                               *
      *  BUG22911 - Changes for Correct Tax Calculation (Recompile)   *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  BUG25979 - Apply fix bug20458                                *
      *  BUG20458 - Remove some validation that limits the population *
      *             of Z#ASTS variable in AMEND/SR                    *
      *  BUG24775 - Apply fix BUG21255                                *
      *  BUG21255 - DB error in MG051N when processing MT51x          *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  240736A -Additional condition to update TRADSDX2 with input  *
      *           details.                                            *
      *  BUG14514 - serious midas error on trade authorisation        *
      *  245970 - Securities trade was amended but there was no MT518 *
      *           message generated. In subroutine SETAMD, always set *
      *           flag TCFR to 'Y' without conditions.                *
      *  243774A- Missing TRADSDX2 record from repair function.       *
      *  223022 - MT2xx not generated as PRPC is already 'Y' during   *
      *           authorisation.  Reset PRPC indicator to 'N'.        *
      *  230335 - Trade deletion not reflected in projected nostro a/c*
      *           movement. Fix is to perform on-line update if trade *
      *           is authorized not on its last change date. Applied  *
      *           fix 218476.                                         *
      *  243774 - Only 1 record is needed on TRADSDX2 if CSW003 is off*
      *  BUG12938 - Update BSPOSD in change mode                      *
      *  BUG12372 - Serious Midas Error in Securities Trade Input     *
      *  CPK025 - MidasPlus 1.3 packaging.  Bug 7975 and SC 240736    *
      *           overlap.                                            *
      *  240736 - Change fix 238859 to still consider CSE045.         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  238859 - Update extension file TRADSDX2 based on the current *
      *           action done to the security than just checking it   *
      *           against feature CSE045.                             *
      * BUG11114- Applied Gems fix 234927                             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  234927 - Do not process SETLED record if action on Trade is  *
      *           deletion and BVAUTH is '10'. Patterned after SE0050.*
      *  CAP087  - Enable API can be used for Buy/Sell back trades.   *
      *  BUG7975- Get the user define entry for TRADSDX2 instead of   *
      *           the default.                                        *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  236679 - For CHANGE action, only invoke SEVTRADTAX once.     *
      *  235453 - Incorrect update of CDEPPD. Incorrect Nominals.     *
      *  235112 - During trade deletion, save initial value of EU Tax *
      *  236073 - Fiscal Price in percentages should be updated on    *
      *           amend                                               *
      *  235546 - EU Tax backvaluations                               *
      *           overwrite of data from SE006680                     *
      *  234440 - Purchase Interest Management                        *
      *           including removing 236758 and most of 236705        *
      *         - Purchase Interest should be maintained during input *
      *           cycle                                               *
      *  236705 - original purchase date should default to average    *
      *           purchase date                                       *
      *  233615 - Takeon programs for CGL031 (Recompile)              *
      *  233566 - Add field to CDEPPD                                 *
      *  CGL031 - Taxation of Savings Income                          *
      *  BUG8102R - Line was missing which sets up PSUser.            *
      *             Fix included by Bug 7703 already, so no codings.  *
      *  BUG7703 - Serious Midas error occurred during INSERT         *
      *            Applied fix as BUG8260.                            *
      *  BUG8102 - Move other processing dependent on ZMUSER.         *
      *  CSE065 - Cost Yield Amort. on Mortgage Backed Assets         *
      *  BUG8260 - Serious Midas Error occurred                       *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  223870 - CPOSNA lock conflict between DBU_TRAD and SEDPMVUPD.*
      *           The fix is to delay the job if locked by another    *
      *           user. Patterned after core fix 213720.              *
      *  215727 - Do not allow authorisation of incomplete trades.    *
      *           Upgrade fix 114713 to API version.                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3947 - Timestamp field in TRADSDX2 not being initiallised *
      *            when CSE045 is OFF.                                *
      *  BUG3122 - Renamed the field SEZONE in SDSECS data structure  *
      *            to avoid compilation error.                        *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  227015 - Remove fix 196449 because it stop the update of     *
      *           value day position for trade value today.           *
      *           This cause incorrect value date position in Client's*
      *           Holding Enquiry.                                    *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
      *  CAP084 - Synchronous calling of APIs                         *
      *           Get user from ZMUSER DTAARA                         *
      *  CDE005 - Data Export - Reservation ID                        *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CSE039 - Auto-settle of trades.                              *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  210517 - Missing TRADSDX2 record from the API                *
      *  208195 - Database Error occured when client number is blank. *
      *  203470 - Reinstate part of fix 179084 which was removed by   *
      *           191691, but instead of '*', move 'C' to RECI.       *
      *  196449 - Position is wrongly calculated in SE0220 when Depot *
      *           and Price changed on value date using action code   *
      *           'C'. in Trades Input Maintenance. Update Sum        *
      *           Nominals (Value Date Basis) only after value date   *
      *           have passed.                                        *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAP067 - Repurchase Agreements API.                          *
      *  CSE028 - Standing Settlement Instructions Enhancement.       *
      *           (Recompiled).                                       *
      *  CSE022 - Depository Definition Enhancement (Recompile)       *
      *  191691 - Deletion of Trade is not updating the record id     *
      *           correctly.  This is caused by fix 179084 which      *
      *           amended SR/SETDEL to move '*' instead of 'C' into   *
      *           RECI.  Remove all the code changes introduced by    *
      *           fix 179084 in SR/SETDEL.                            *
      *  CSE023 - Treaty Withholding Tax.                             *
      *  179084 - Previous RECI not being used to update TRAUTD.      *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
      *  CDE001 - Data Export - CCRM Limits                           *
      *  CAP051 - Automatic Authorisation (SE Trades Part)            *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *         - 'Private Banking' Module                            *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  168345 - Prevent two users from accessing same transaction   *
      *           in repair screen at the same cycle, and converting  *
      *           it into two different Midas Deal No.s  .            *
      *           Second user should not be allowed to repair the tran-
      *           saction and convert it into a  another Midas Deal . *
      *  168532 - DB error 082 in trades input with profit centre     *
      *           defaulting                                          *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP006 - Check for Trade being updated by another workstation*
      *  154562 - Only 1 record is needed on TRADSDX1 if CSW003 is off*
      *  149162 - Int. calc. incorrect at end of Feb for 30 day method*
      *           (core fix 102506 changes ZDAYS and ZDYYR)           *
      *  CAP003 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************

     FSECTY     IF   E           K DISK
     FINVTP     IF   E           K DISK
     FMUSER     IF   E           K DISK
     FSOBTR     IF   E           K DISK
     F                                     RENAME(TRADSDF:SOBTRSO)

     FTRADS     UF A E           K DISK    COMMIT
     FTRADSDY1  UF A E           K DISK    COMMIT
     FTRADSDY2  UF A E           K DISK    COMMIT                                             210517

     FTRAUT     IF A E           K DISK    COMMIT

     FSETLE     UF   E           K DISK    COMMIT

     FBKPOS     UF A E           K DISK    COMMIT
     FBKPHD     IF A E           K DISK    COMMIT
     FCPOSN     UF A E           K DISK    COMMIT
     FUDEPP     UF A E           K DISK    COMMIT
     FCDEPP     UF A E           K DISK    COMMIT
     FBSPOSDL0  UF A E           K DISK    COMMIT                                             CAP067

     FSETLEA    UF   E             DISK    COMMIT
     FTRADSA    UF   E             DISK    COMMIT
     FBKPHDA    UF   E             DISK    COMMIT
     FBKPOSA    UF   E             DISK    COMMIT
     FCPOSNA    UF   E             DISK    COMMIT
     FCDEPPA    UF   E             DISK    COMMIT
     FUDEPPA    UF   E             DISK    COMMIT

     FSEPCBD    IF A E           K DISK    COMMIT
     FSEPCCD    IF A E           K DISK    COMMIT
     FSEPCA     UF   E             DISK    COMMIT
      *                                                                                       CSE039
      ** Security Trade Movments Status                                                       CSE039
     FSEMVTSL6  O  A E           K DISK    RENAME(SEMVTSD0:SEMVTSD06)                         CSE039
     F                                     COMMIT                                             CSE039
      *                                                                                       CSE039
      ** Security Trade Movments Status                                                       CSE039
     FSEMVTSL0  IF   E           K DISK    PREFIX(MV_)                                        CSE039
      *                                                                                       CSE039
     FTRADSDY3  IF   E           K DISK                                                       CSE039
      *                                                                                       CSE039

     FSDCWHTL1  IF   E           K DISK                                                       CSD015
      ** Compliance Watch Hit List by Function                                                CSD015
                                                                                              CSD015
     FREADVCL1  UF A E           K DISK    COMMIT                                             CRE020
     F                                     USROPN                                             CRE020
      ** Midas RE Settled Transaction Index File by Ref No/Pgm Ref                            CRE020
                                                                                              CRE020
     F/COPY WNCPYSRC,SETRADDF01
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
      ** The following /COPY line includes the definitions for error and        CAP006
      ** warning message arrays.                                                CAP006
     D/COPY ZACPYSRC,ERR_ARRAYS                                                 CAP006
      **------------------------------------------------------------------------CAP006--------------
                                                                                CAP006

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************

      ** Timestamp for the transaction                                          CAP006
     D TimeStamp       S               Z                                        CAP006
                                                                                CAP006
     D BYESEL          S              1A   INZ(*BLANK)                                        CAP067
                                                                                              CAP067
     D ChkTradFmt    E DS                  EXTNAME(TRADSD)                      CAP006
      ** Rename fields for Timestamp checking                                   CAP006
     D                                     PREFIX(CH)                           CAP006
      * Current Trade in File Format (Extension File)                           CAP006
     D CT1AFilFmt    E DS                  EXTNAME(TRADSDX1)                    CAP006
     D                                     PREFIX(CA_)                          CAP006
      * Current Trade in File Format (Extension File)                           CAP006
     D CT1BFilFmt    E DS                  EXTNAME(TRADSDX1)                    CAP006
     D                                     PREFIX(CB_)                          CAP006
                                                                                CAP006
      ** Current Trade in File Format Before Update                                           CSC011
     D CT2AFilFmt    E DS                  EXTNAME(TRADSDX1)                                  CSC011
     D                                     PREFIX(SA_)                                        CSC011
      ** Current Trade in File Format Before Update                                           CSC011
     D CT2BFilFmt    E DS                  EXTNAME(TRADSDX1)                                  CSC011
     D                                     PREFIX(SB_)                                        CSC011
                                                                                              CSC011
     D SEETRAD       E DS                  EXTNAME(SEETRPRPD)                   CAP006
      * Error indicators                                                        CAP006
                                                                                CAP006
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID TRADE
     D SEVTRD        E DS                  EXTNAME(SEVTRADPD)
     D                                     PREFIX(A_)

      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID DEPOT MOVEMENT                        234440
     D SEVDPM        E DS                  EXTNAME(SEVDPMVPD)                                 234440
     D                                     PREFIX(D_)                                         234440
                                                                                              234440
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR 'BEFORE UPDATE' TRADE
     D B_TRADS       E DS                  EXTNAME(TRADSD)
     D                                     PREFIX(B_)

      **  TRADES FILE
     D TRADSF        E DS                  EXTNAME(TRADSD)


      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID TRADE EXTENSION 1
     D SEVTRDX1A     E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(AA_)
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID TRADE EXTENSION 1
     D SEVTRDX1B     E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(AB_)

      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID TRADE EXTENSION 1                     CSE045
     D SEVTRDX2A     E DS                  EXTNAME(SEVTRX2PD)                                 CSE045
     D                                     PREFIX(AA_)                                        CSE045
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID TRADE EXTENSION 1                     CSE045
     D SEVTRDX2B     E DS                  EXTNAME(SEVTRX2PD)                                 CSE045
     D                                     PREFIX(AB_)                                        CSE045
                                                                                              CSE045
      **  TRADE EXTENSION 1 FILE
     D TRADSX1F      E DS                  EXTNAME(TRADSDX1)

     D A_TradX2      E DS                  EXTNAME(TRADSDX2)                                  210517
     D                                     PREFIX(A_)                                         210517
                                                                                              210517
     D B_TradX2      E DS                  EXTNAME(TRADSDX2)                                  210517
     D                                     PREFIX(B_)                                         210517
                                                                                              210517
     D TradX2Rec     E DS                  EXTNAME(TRADSDX2)                                  210517

      ** SECURITY FILE
     D SECTYF        E DS                  EXTNAME(SECTYD)
     D SEC_RECI      E                     EXTFLD(RECI)
     D SEC_ZZ005     E                     EXTFLD(ZZ005)
     D SEC_LCD       E                     EXTFLD(LCD)
     D SEC_CHTP      E                     EXTFLD(CHTP)
     D SEC_TNLU      E                     EXTFLD(TNLU)
     D SEC_REPI      E                     EXTFLD(REPI)                         CPB001
     D SEC_FRNT      E                     EXTFLD(FRNT)                                       CAP137
     D SEC_REPA      E                     EXTFLD(REPA)                                       CAP137
     D SEC_TMST      E                     EXTFLD(TMST)                                       CAP137
     D CDArr                 183    230
     D CRArr                 231    242



      **  EXTERNALLY DESCRIBED DATA STRUCTURES FOR TEMPLATE FILES FOR
      **  PROJECTED ACCOUNT MOVEMENTS UPDATES
     D Z#BSTS        E DS                  EXTNAME(Z#BST)
     D Z#ASTS        E DS                  EXTNAME(Z#AST)

     D                 DS                                                       CDE001
     D**W#POSID*               1     20                                                CDE001 CGL029
     D  W#POSID                1     26                                                       CGL029
     D  W#TDSS                 1     10                                         CDE001
     D  W#TDBK                12     13                                         CDE001
     D  W#TDBA                15     17                                         CDE001
     D  W#TDMI                19     19                                         CDE001
     D/COPY WNCPYSRC,SETRADDD01

      * DATA STRUCTURES FOR USE WITH ACCESS PROGRAMS

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * DATA STRUCTURE FOR BANK DETAILS

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      * DATA STRUCTURE FOR BANK DETAILS

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      * DATA STRUCTURE FOR BANK DETAILS

     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      * DATA STRUCTURE FOR SECURITIES TRADING DETAILS

     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      * DATA STRUCTURE FOR PORTOLIO MANAGEMENT DETAILS

     D SDSECS        E DS                  EXTNAME(SDSECSPD)
     D QQACC1        E                     EXTFLD(QQACCD)                                     CGL029
     D BFZONE        E                     EXTFLD(SEZONE)                                    BUG3122
      * DATA STRUCTURE FOR SECURITIES CUSTOMER DETAILS

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      * DATA STRUCTURE FOR CURRENCY DETAILS

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SDSTAT data area                                                                     CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      *                                                                                       CAP084
      ** DS for ZMUSER details                                                                CAP084
     D ZMUSER          DS            17                                                       CAP084
     D  PUSRID                 1     10                                                       CAP084
     D  PDBRN                 11     13                                                       CAP084
     D  PDPPT                 14     16                                                       CAP084
                                                                                              CSC011
      ** Midas API Message Header Format Definition                                           CSC011
     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  CSC011
                                                                                              CSC011
      ** External DS for SAR Details                                                          CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
     D  SCA_LCD      E                     EXTFLD(LCD)                                        CSC011
      *                                                                                       CSC011
      ** Dummy message ID and message file fields for use on the calls to       CAP006
      ** ZAMSGTOOPR                                                             CAP006
     D DummyMsgID      S                   LIKE(#MsgID)                         CAP006
     D DummyMsgF       S             10A                                        CAP006
                                                                                CAP006
     D CSC011          S              1A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D*PDealNo**       S             18A                                               CSC011 CGL029
     D*PADealNo*       S             18A                                               CSC011 CGL029
     D PDealNo         S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D PTimeStamp      S             26A                                                      CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
     D PAction         S              1A                                                      CSC011
     D WTRTP           S             20A                                                      CSC011
                                                                                              CSC011
     D PMODE           S              3A                                                      210517
     D PScreen         S              1A                                                      210517
                                                                                              210517
      ** Array for enhancement CSD015                                                         CSD015
     D***OPTAG**         S             40    DIM(22) CTDATA                            CSD015 CSW210
     D***CLTAG**         S             40    DIM(22) CTDATA                            CSD015 CSW210
     D OPTAG           S             40    DIM(24) CTDATA                                     CSW210
     D CLTAG           S             40    DIM(24) CTDATA                                     CSW210
                                                                                              CSD015
      ** Data Structure for Watch List Details Transactions File                              CSD015
     D SEFirstParm   E DS                  EXTNAME(SDWLTDPD)                                  CSD015
                                                                                              CSD015
      ** Data structure for 2nd parameter of SDCWLCHK                                         CSD015
     D SESecondParm    DS         30000                                                       CSD015
                                                                                              CSD015
      ** Additional entry parameter for Midas Compliance Watch                                CSD015
     D PMCWL           DS          9999                                                       CSD015
                                                                                              CSD015
      ** Temporary Data Structur for Midas Compliance Watch                                   CSD015
     D TEMPDS          DS          3000                                                       CSD015
                                                                                              CSD015
      ** Midas Functions for Watch List Checking Details File                                 CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
                                                                                              CSD015
      ** DS For Watch List Configuration Data File                                            CSD015
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                  CSD015
                                                                                              CSD015
      ** Midas Functions for Watch List Checking Details File                                 CSD015
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSD015
                                                                                              CSD015
      ** Declared Variables                                                                   CSD015
     D PFunc           S              8A                                                      CSD015
     D PKEY            S             10A                                                      CSD015
     D PKYSTS          S              7A                                                      CSD015
     D CSD015          S              1A                                                      CSD015
     D CCF001          S              1A                                                      CSD015
     D PDATE           S              5A                                                      CSD015
     D WFunction       S              8A                                                      CSD015
     D WIdentifier     S             40A                                                      CSD015
     D WBranch         S              3A                                                      CSD015
     D WNotBlank       S              1A                                                      CSD015
     D WChanged        S              1A                                                      CSD015
     D WInsert         S              1A                                                      CSD015
     D WAmend1         S              1A                                                      CSD015
     D WAmend2         S              1A                                                      CSD015
     D WAmend3         S              1A                                                      CSD015
     D WAmend4         S              1A                                                      CSD015
     D WAmend5         S              1A                                                      CSD015
     D WAmend6         S              1A                                                      CSD015
     D WAmend7         S              1A                                                      CSD015
     D WTradeRef       S              6A                                                      CSD015
     D WToFromInd      S              1A                                                      CSD015
     D WByesel         S              1A                                                    BUG12938
     D ConvertedDate   S               D                                                      CSD015
     D ConvertedAmt    S             18P 3                                                    CSD015
     D PDummy10        S             10                                                       CSD015
     D PDummy16        S             16                                                       CSD015
                                                                                              CSD015
      ** Parameters for call to SDWCWLFMT                                                     CSD015
     D PINP1           S             35A                                                      CSD015
     D PINP2           S             35A                                                      CSD015
     D PINP3           S             35A                                                      CSD015
     D PINP4           S             35A                                                      CSD015
     D PINP5           S             35A                                                      CSD015
     D PINP6           S             35A                                                      CSD015
     D PCCY            S              3A                                                      CSD015
     D POUT            S            216A                                                      CSD015
     D PCUST           S              6A                                                      CSD015
                                                                                              CGL029
      ** Define fields used in CRE020                                                         CRE020
     D CRE020          S              1A                                                      CRE020
     D KRefNo          S             30A                                                      CRE020
     D KPrgMn          S             10A   INZ('SETRADUPD ')                                  CRE020
     D PSysVal01       S             20A   INZ('SecuritiesTrades    ')                        CRE020
     D PCurSet01       S            200A                                                      CRE020
     D PSysVal02       S             20A                                                      CRE020
     D PCurSet02       S            200A                                                      CRE020
     D PSysVal03       S             20A                                                      CRE020
     D PCurSet03       S            200A                                                      CRE020
     D PSysVal04       S             20A                                                      CRE020
     D PCurSet04       S            200A                                                      CRE020
     D PSysVal05       S             20A                                                      CRE020
     D PCurSet05       S            200A                                                      CRE020
     D PSysVal06       S             20A                                                      CRE020
     D PCurSet06       S            200A                                                      CRE020
     D PSysVal07       S             20A                                                      CRE020
     D PCurSet07       S            200A                                                      CRE020
     D PSysVal08       S             20A                                                      CRE020
     D PCurSet08       S            200A                                                      CRE020
     D PSysVal09       S             20A                                                      CRE020
     D PCurSet09       S            200A                                                      CRE020
     D PSysVal10       S             20A                                                      CRE020
     D PCurSet10       S            200A                                                      CRE020
     D WSysVal01       S              1A                                                      CRE020
     D WOrgCHTP        S              1A                                                      CRE020
                                                                                              CRE020
     D T#TREF          S             26A                                                      CGL029
                                                                                              CSD015
     D CAS006          S              1                                                       CAS006
                                                                                              CAS006
      ** Array of QCMDEXC command to edit                                                     223870
      *                                                                                       223870
     D CMDDLY          S             80    DIM(1) CTDATA PERRCD(1)                            223870
      *                                                                                       223870
      ** CGL031 flag                                                                          CGL031
     D CGL031          S              1A                                                      CGL031
     D ProcFlag        S              1A                                                      CGL031
     D RetCode         S             10A                                                      CGL031
     D DDEUTX          S             16A                                                      CGL031
     D*WCust****       S              6S 0                                             236705 234440
      *                                                                                       235112
      ** Variables for initial value of EU Tax                                                235112
      *                                                                                       235112
     D XDDEUTX         S             16A                                                      235112
     D XEUTX           S             13P 0                                                    235112
     D XEUTS           S             13P 0                                                    235112
                                                                                              CGL031
     IMUSERDDF
     I              RECI                        MUSR_RECI
     ITRAUTDF
     I              RECI                        TRAU_RECI
     ISEPCCDF
     I              PTFR                        SEPC_PTFR
     I/COPY WNCPYSRC,SETRADDI01
                                                                                CAP006

      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
      *                                                                                      BUG7029
      ** Retrieve ZMUSER details.                                                            BUG7029
      *                                                                                      BUG7029
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C                   IN        ZMUSER                                                    BUG7029
                                                                                             BUG8260
      ** Access Midas User Details                                                           BUG8260
                                                                                             BUG8260
     C                   EVAL      PSUser = PUSRID                                           BUG8260
     C     PSUser        CHAIN     MUSER                              99                     BUG8260
                                                                                             BUG8260
      ** Database error                                                                      BUG8260
                                                                                             BUG8260
     C                   IF        *IN99 = *ON                                               BUG8260
     C                             OR MUSR_RECI <> 'D'                                       BUG8260
     C                   EVAL      DBFILE = 'MUSER   '                                       BUG8260
     C                   EVAL      DBASE  = 905                                              BUG8260
     C                   EVAL      DBKEY  = PSUser                                           BUG8260
     C                   EXSR      SRERR                                                     BUG8260
     C                   ENDIF                                                               BUG8260

      ** INITIALIZE WORK FIELDS

     C                   MOVEL     *BLANK        Z#BSTS
     C                   MOVEL     *BLANK        Z#ASTS
     C                   Z-ADD     0             NMDP                                         208195
     C                   EVAL      ByeSel = *Blanks                                           CSC011
     C/COPY WNCPYSRC,SETRADDC09
      *                                                                         CAP051
     C     CAP051        IFEQ      'Y'                                          CAP051
     C     A_AUTH        ANDEQ     'Y'                                          CAP051
     C                   MOVE      '00'          BVAUTH                         CAP051
     C                   ELSE                                                   CAP051
     C                   MOVE      SAVAUTH       BVAUTH                         CAP051
     C                   ENDIF                                                  CAP051

      ** Get customer and security details

     C                   EXSR      GETCSSED

      ** Ensure transaction has not been updated by another workstation         CAP006
      ** - if so, bypass updating and return to calling program.                CAP006
     C                   EXSR      CHKOTHUPD                                    CAP006
                                                                                CAP006
     C     @@RTCD        IFNE      *BLANKS                                      CAP006
     C                   GOTO      EXIT                                         CAP006
     C                   END                                                    CAP006
                                                                                CAP006
      ** INSERT, AMEND, CHANGE, DELETE, APPROVE OR AUTHORIZE THE TRADE

     C     A_CHTP        CASEQ     'I'           INSERT
     C     A_CHTP        CASEQ     'A'           AMEND
     C     A_CHTP        CASEQ     'C'           CHANGE
     C     A_CHTP        CASEQ     'D'           DELETE
     C     A_CHTP        CASEQ     'P'           APPROV
     C     A_CHTP        CASEQ     'Y'           AUTHOR
     C                   END
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' and                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020

      ** UPDATE TRADE EXTENSION 1 A & B RECORD
      ** (B RECORD ONLY IF PORTFOLIO CUSTOMER)
      ** (         AND IF MT5XX PHASE II IS ON)                                 154562

     C     S01401        IFEQ      'Y'
     C                   EXSR      UTRADSX1A
     C     CustClass     IFEQ      'S'
     C     CustClass     OREQ      'D'
     C     CSW003        IFEQ      'Y'                                          154562
     C                   EXSR      UTRADSX1B
     C                   END                                                    154562
     C                   END
     C                   END
      ** Write a record to the Trade Movement Status File for the                             CSE039
      *  processed trade.                                                                     CSE039
     C     CSE039        IFEQ      'Y'                                                        CSE039
     C                   EXSR      SrMovement                                                 CSE039
     C                   ENDIF                                                                CSE039
      *                                                                                       CSE039

      ** If action is insert, amend, change or delete ...

     C     A_CHTP        IFEQ      'I'
     C     A_CHTP        OREQ      'A'
     C     A_CHTP        OREQ      'C'
     C     A_CHTP        OREQ      'D'
     C     A_CHTP        OREQ      'Y'                                                        230335
     C     B_LCD         ANDNE     BJRDNB                                                     230335

      ** and if trade is now complete ...

     C     A_TINC        IFEQ      'C'

      **  ... update on-line balances

     C                   EXSR      ONLNUP

      *   ... update book positions

     C                   EXSR      WBKPOS

      *   ... update client depot positions if portfolio client

     C     CustClass     IFEQ      'S'
     C     CustClass     OREQ      'D'
     C                   EXSR      WCPOSN
     C                   END

      *   ... update user depot positions

     C                   EXSR      WUDEPP
     C                   END
     C                   END

      *  If action is not insert and settlement data has changed

     C     A_CHTP        IFNE      'I'
     C     TNSN          IFNE      B_TNSN
     C     A_CHTP        ANDEQ     'C'                                                        234927
     C     TNSP          ORNE      B_TNSP
     C     A_CHTP        ANDEQ     'C'                                                        234927
     C     A_CHTP        OREQ      'D'                                                        234927
     C     BVAUTH        ANDEQ     '00'                                                       234927
     C     RECI          OREQ      'A'                                                        234927
     C     BVAUTH        ANDEQ     '00'                                                       234927
     C     RECI          OREQ      'P'                                                        234927
     C     A_CHTP        OREQ      'Y'                                                        234927
     C     B_CHTP        ANDEQ     'D'                                                        234927

      *   ... update Trade settlement details

     C                   EXSR      WSETTL
     C                   END
     C                   END

      *  Write to authorisation file if necessary

     C     BVAUTH        IFNE      '00'
      *                                                                         CAP051
      ** If Authorisation level on SE I.C.D. is > 00,                           CAP051
      ** Then a record must be created in PF/TRAUTD to send a confirmation      CAP051
      ** to Meridian                                                            CAP051
     C     SAVAUTH       ORNE      '00'                                         CAP051
     C     CAP051        ANDEQ     'Y'                                          CAP051
     C     A_AUTH        ANDEQ     'Y'                                          CAP051
                                                                                CAP051
     C                   EXSR      WTRAUT
     C                   END

      *  If Profit Centres are used
      *  Write to Profit Centre position files, if new book or customer
      *  position and trade is now complete

     C     BKPRCU        IFEQ      'Y'
     C     A_TINC        ANDEQ     'C'
     C                   EXSR      WPRFC
     C                   END

      *    Update audit files

     C                   EXSR      WAUDIT

      ** If 24x7 Midas Availability is installed                                              CSC011
      ** and Support System is active                                                         CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (LIBR = S1SUPP)                         CSC011
                                                                                              CSC011
     C                   CALLB     'SETRADLOG'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM      A_CHTP        PAction                                      CSC011
     C                   PARM                    CAS006                                       CAS006
     C                   PARM                    TRADSF                                       CSC011
     C                   PARM                    CT2AFilFmt                                   CSC011
     C                   PARM                    CT2BFilFmt                                   CSC011
     C                   PARM                    TRANSDTL                                     CSC011
                                                                                              CSC011
      ** Write to support database log file                                                   CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut = *Blanks                                       CSC011
                                                                                              CSC011
     C                   IF        ByeSel = *Blanks                                           CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE = 'SETRAD'                                       CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE = 'SEBYSL'                                       CSC011
                                                                                              CSC011
     C                   IF        BYESEL = 'Y'                                               CSC011
     C                   MOVEL     'SEBYS2'      WTRTP                                        CSC011
     C                   EVAL      TRANSDTL = WTRTP + TRANSDTL                                CSC011
     C                   ELSE                                                                 CSC011
     C                   MOVEL     'SEBYS1'      WTRTP                                        CSC011
     C                   EVAL      TRANSDTL = WTRTP + TRANSDTL                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   EVAL      APUSERID = PSUser                                          CSC011
     C                   EVAL      APRPRLOCN = A_REPA                                         CSC011
     C                   MOVEL     A_FRNT        APFOTRANID                                   CSC011
     C                   MOVEL     A_AFRT        APFOASOCID                                   CSC011
     C                   MOVEL     A_TDRF        PDealNo                                      CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    APHEAD                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *BLANKS       PTimeStamp                                   CSC011
     C                   PARM                    PDealNo                                      CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** If error occured,                                                                    CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
     C                   EVAL      @@RTCD = '*ERROR'                                          CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      * EXIT FROM PROGRAM
     C     EXIT          TAG                                                    CAP006

     C/COPY WNCPYSRC,SETRADDC10
     C                   RETURN
     C****************************************************************
      /EJECT
     C*****************************************************************         CAP006
     C*                                                               *         CAP006
     C* CHKOTHUPD - Check for update by another workstation           *         CAP006
     C*                                                               *         CAP006
     C*****************************************************************         CAP006
     C     CHKOTHUPD     BEGSR                                                  CAP006
                                                                                CAP006
      ** Retrieve current Trade details                                         CAP006
                                                                                CAP006
     C                   MOVE      A_TDRF        MidasTrNum        6            CAP006
                                                                                CAP006
      ** Determine whether program is running interactively or in batch         CAP006
      **  ( 0 = batch   1 = interactive)                                        CAP006
      *                                                                         CAP006
     C                   CALLB     'ZARTVJOBA'                                  CAP006
     C                   PARM                    @Return           6            CAP006
     C                   PARM                    @type             1            CAP006
      *                                                                         CAP006
      * Allow access to transaction record by Front-Office ID when in Repair    168345
      * mode for inserts .Set  *RTV module  parameter  @@MODE  to   *FRONT      168345
      * if the pgm is:  a) running in Interactive mode - @Type= 1   ~~~~~~      168345
      * and             b) action code is Insert - 'I'                          168345
      * and             c) Front-Office Id is NOT Blank                         168345
      *                                                                         168345
     C     @Type         IFEQ      '1'                                          168345
     C     A_CHTP        ANDEQ     'I'                                          168345
     C     A_FRNT        ANDNE     *BLANKS                                      168345
      *                                                                         168345
     C                   MOVE      '*FRONT'      @@MODE                         168345
      *                                                                         168345
     C                   ELSE                                                   168345
      *                                                                         168345
      * Otherwise, if running in batch use Front-Office ID                      168345
      *            (if insert)                                                  CAP013
      *            else, use Midas Deal Number                                  168345
      *                                                                         168345
     C     @Type         IFEQ      '0'                                          CAP006
     C     A_CHTP        ANDEQ     'I'                                          CAP013
     C                   MOVE      '*FRONT'      @@MODE                         CAP006
     C                   ELSE                                                   CAP006
     C                   MOVE      *BLANKS       @@MODE                         CAP006
     C                   END                                                    CAP006
      *                                                                         168345
     C                   END                                                    168345
                                                                                CAP006
     C                   CALLB     'SETRADRTV'                                  CAP006
      * INPUTS                                                                  CAP006
      *                                                                         CAP006
      * Return code                                                             CAP006
     C                   PARM      *BLANK        RetCodeOut                     CAP006
      *                                                                         CAP006
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CAP006
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP006
      *                                                                         CAP006
     C                   PARM                    @@MODE            6            CAP006
      *                                                                         CAP006
      * Response mode                                                           CAP006
     C                   PARM      ' '           @@RSMD            1            CAP006
      *                                                                         CAP006
      * Action Code                                                             CAP006
     C                   PARM      A_CHTP        ACTN              1            CAP006
      *                                                                         CAP006
      * Front Office Transaction ID                                             CAP006
     C                   PARM      A_FRNT        FOTRID           20            CAP006
      *                                                                         CAP006
      * (Midas) Trade Reference                                                 CAP006
     C                   PARM                    MidasTrNum                     CAP006
      *                                                                         CAP006
      * (CSW003) MT5XX - Phase 2 Message Generation
     C                   PARM                    CSW003            1
      *                                                                                       CAP067
      * Buy-sell back                                                                         CAP067
     C                   PARM                    PFBYSL            1                          CAP067
      *                                                                                       CAP067
      * Trade Reference                                                                       CAP067
     C                   PARM                    PFTDRF            6                          CAP067
      *
      * OUTPUTS                                                                 CAP006
      *                                                                         CAP006
      * (Current) TRADE in file format
     C                   PARM                    ChkTradFmt                     CAP006
     C                   PARM                    CT1AFilFmt
     C                   PARM                    CT1BFilFmt
      *                                                                         CAP006
      * OK - Action code                                                        CAP006
     C                   PARM      *BLANK        DDACTNOK                          CAP006
      *                                                                         CAP006
      * OK - Trade Reference                                                    CAP006
     C                   PARM      *BLANK        DDTDRFOK                         CAP006
      *                                                                         CAP006
      * Error fields/message IDs/message data (arrays) from/to caller           CAP006
     C                   PARM      *BLANK        FldNameArr                     CAP006
     C                   PARM      *BLANK        MsgIdArr                       CAP006
     C                   PARM      *BLANK        MsgDtaArr                      CAP006
      *                                                                         CAP006
      * Array index (3P0) from/to caller                                        CAP006
     C                   PARM      *ZERO         Idx               3 0          CAP006
      *                                                                         CAP006
      *                                                                         CAP006
      ** Error if Timestamp is not the same (record has been changed            CAP006
      **  by another workstation)                                               CAP006
                                                                                CAP006
      ** Processing varies according to mode program is running in.             CAP006
      ** In interacive mode simply check whether the timestamp field            CAP006
      ** has been updated since the original Trade was fetched by this          CAP006
      ** program.                                                               CAP006
      ** In batch (API input) check return parameters from Retrieve             CAP006
      ** module for errors, and send message to system operator.                CAP006
                                                                                CAP006
      ** Interactive mode:                                                      CAP006
                                                                                CAP006
     C     @TYPE         IFEQ      '1'                                          CAP006
                                                                                CAP006
     C     CHTMST        IFNE      A_TMST                                       CAP006
     C     ACTN          ANDNE     'I'                                                        CAP087
     C                   MOVEL     '*RECUPD'     @@RTCD                         CAP006
     C                   END                                                    CAP006
                                                                                CAP006
      ** Batch mode:                                                            CAP006
     C                   ELSE                                                   CAP006
     C     DDACTNOK      IFEQ      'N'                                             CAP006
     C     DDTDRFOK      OREQ      'N'                                            CAP006
     C                   MOVEL     '*RECUPD'     @@RTCD                         CAP006
     C                   Z-ADD     1             C                 2 0          CAP006
                                                                                CAP006
     C     C             DOWLE     ArrayMax                                     CAP006
     C     FldNameArr(C) ANDNE     *BLANKS                                      CAP006
     C*******************MOVEL     *BLANKS       DBError          28     CAP006 CAP013
     C*******************MOVEL     MsgIDArr(C)   DBError                 CAP006 CAP013
     C                   CLEAR                   DBError         132            CAP013
     C                   EVAL      DBerror = 'Update error: ' + FOTRID          CAP013
     C                   CALLB     'ZAMSGTOOPR'                                 CAP006
     C                   PARM                    MsgSndRtn        10            CAP006
     C                   PARM                    DBError                        CAP006
     C                   PARM                    DummyMsgID                     CAP006
     C                   PARM                    DummyMsgF                      CAP006
     C                   ADD       1             C                              CAP006
     C                   END                                                    CAP006
                                                                                CAP006
     C                   END                                                    CAP006
                                                                                CAP006
     C                   END                                                    CAP006
                                                                                CAP006
     C                   ENDSR                                                  CAP006
     C*****************************************************************         CAP006
      /EJECT                                                                    CAP006
     C****************************************************************
     C*                                                              *
     C* INSERT - INSERT A TRADE                                      *
     C*                                                              *
     C****************************************************************
     C     INSERT        BEGSR

      ** ACCESS TRADE

     C     A_TDRF        CHAIN     TRADSDF                            99

      ** DATABASE ERROR

     C     *IN99         IFEQ      '0'
     C                   MOVEL     A_TDRF        DBKEY
     C                   MOVEL     'TRADSD'      DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 002*
     C                   EXSR      SRERR                                        ************
     C                   END
                                                                                              CAP067
      ** Setup BSPOSD details before update if trade is Buy-Sell                              CAP067
                                                                                              CAP067
     C                   IF        A_LKRF <> *BLANKS                                          CAP067
     C                   EXSR      SHRECK                                                     CAP067
     C                   ENDIF                                                                CAP067

      ** INITIALIZE TRADE

     C                   CLEAR                   TRADSF

      ** UPDATE 'BEFORE' STATUS

     C                   MOVEL     TRADSF        Z#BSTS
     C                   MOVEL     TRADSF        B_TRADS
     C                   MOVEL     RECI          PREVREC           1                          179084
     C     B_RECI        IFNE      'R'                                                        230335
     C     B_LCD         ANDNE     BJRDNB                                                     230335
     C                   MOVEL     *BLANK        Z#BSTS                                       230335
     C                   ENDIF                                                                230335

      ** SET TRADE FIELDS ON INSERT

     C                   EXSR      SETINS
                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        FRNT = *BLANKS                                             CSC011
     C                   EVAL      FRNT = 'MD' + TDRF                                         CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** If compliance watch is installed, and entry watch list checking                      CSD015
      ** is being applied, perform compliance watch processing                                CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y' and W1EWLC = 'Y'                              CSD015
     C                   IF        CSC011 = 'N' or                                            CSD015
     C                             CSC011 = 'Y' and LIBR = S1MAIN                             CSD015
     C                   EXSR      SRCheck                                                    CSD015
     C                   IF        WNotBlank = 'Y'                                            CSD015
     C                   EVAL      WInsert = 'Y'                                              CSD015
     C                   EXSR      SrWatch                                                    CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015

      ** WRITE NEW TRADE

     C                   WRITE     TRADSDF
                                                                                              CAP067
      ** Write Buy-Sell positions file if required                                            CAP067
                                                                                              CAP067
     C                   IF        BYESEL = 'Y'                                               CAP067
     C                   WRITE     BSPOSD0                                                    CAP067
     C                   ENDIF                                                                CAP067

      ** UPDATE 'AFTER' STATUS

     C                   MOVEL     TRADSF        Z#ASTS

     C/COPY WNCPYSRC,SETRADDC11
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* AMEND  - AMEND A TRADE                                       *
     C*                                                              *
     C****************************************************************
     C     AMEND         BEGSR

      ** ACCESS TRADE

     C     A_TDRF        CHAIN     TRADSDF                            99

      ** DATABASE ERROR

     C     *IN99         IFEQ      '1'
     C                   MOVEL     A_TDRF        DBKEY
     C                   MOVEL     'TRADSD'      DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
     C                   EXSR      SRERR                                        ************
     C                   END

      ** UPDATE 'BEFORE' STATUS

     C                   MOVEL     TRADSF        Z#BSTS
     C                   MOVEL     TRADSF        B_TRADS
     C                   MOVEL     RECI          PREVREC           1                          179084

      ** SET TRADE FIELDS ON AMEND

     C                   EXSR      SETAMD

      ** If compliance watch is installed, and entry watch list checking                      CSD015
      ** is being applied, perform compliance watch processing                                CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y' and W1EWLC = 'Y'                              CSD015
     C                   IF        CSC011 = 'N' or                                            CSD015
     C                             CSC011 = 'Y' or LIBR = S1MAIN                              CSD015
                                                                                              CSD015
     C                   EXSR      SRCheck                                                    CSD015
     C                   EVAL      WFunction = 'TRADSD'                                       CSD015
     C                   EVAL      WIdentifier = TDRF                                         CSD015
     C                   EVAL      WBranch = TDBA                                             CSD015
                                                                                              CSD015
     C     KTradChk      CHAIN     SDCWHTL1                                                   CSD015
                                                                                              CSD015
     C                   IF        %FOUND(SDCWHTL1) and W3UNCF = 'Y'                          CSD015
     C                             and WNotBlank = 'Y' or WChanged = 'Y'                      CSD015
     C                   EVAL      WInsert = 'N'                                              CSD015
     C                   EXSR      SRWatch                                                    CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** UPDATE RECORD

     C                   UPDATE    TRADSDF

      ** UPDATE 'AFTER' STATUS

     C*****B_RECI        IFEQ      'L'                                               230335 BUG20458
     C*****B_RECI        OREQ      'P'                                               230335 BUG20458
     C                   MOVEL     TRADSF        Z#ASTS
     C**********         ENDIF                                                       230335 BUG20458
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CHANGE - CHANGE A TRADE                                      *
     C*                                                              *
     C****************************************************************
     C     CHANGE        BEGSR

      ** Access trade using link reference number                                           BUG12938
                                                                                            BUG12938
     C                   EVAL      Wbyesel = 'N'                                            BUG12938
     C                   IF        A_LKRF <> *BLANKS                                        BUG12938
     C     A_LKRF        CHAIN     TRADSDF                                                  BUG12938
     C                   IF        %FOUND(TRADS)                                            BUG12938
     C                   EVAL      Wbyesel = 'Y'                                            BUG12938
     C                   ENDIF                                                              BUG12938
     C                   ENDIF                                                              BUG12938
                                                                                            BUG12938
      ** ACCESS TRADE

     C     A_TDRF        CHAIN     TRADSDF                            99

      ** DATABASE ERROR

     C     *IN99         IFEQ      '1'
     C                   MOVEL     A_TDRF        DBKEY
     C                   MOVEL     'TRADSD'      DBFILE                         ************
     C                   MOVEL     '003'         DBASE                          * DBERR 002*
     C                   EXSR      SRERR                                        ************
     C                   END

      ** Setup BSPOSD details before update if trade is Buy-Sell                            BUG12938
                                                                                            BUG12938
     C                   IF        Wbyesel <> *BLANKS                                       BUG12938
     C                   EXSR      SHRECC                                                   BUG12938
     C                   ENDIF                                                              BUG12938
                                                                                            BUG12938
      ** UPDATE 'BEFORE' STATUS

     C                   MOVEL     TRADSF        Z#BSTS
     C                   MOVEL     TRADSF        B_TRADS
     C                   MOVEL     RECI          PREVREC           1                          179084

      ** SET TRADE FIELDS ON CHANGE

     C                   EXSR      SETCHG

      ** If compliance watch is installed, and entry watch list checking                      CSD015
      ** is being applied, perform compliance watch processing                                CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y' and W1EWLC = 'Y'                              CSD015
     C                   IF        CSC011 = 'N' or                                            CSD015
     C                             CSC011 = 'Y' and LIBR = S1MAIN                             CSD015
                                                                                              CSD015
     C                   EXSR      SRCheck                                                    CSD015
     C                   EVAL      WFunction = 'TRADSD'                                       CSD015
     C                   EVAL      WIdentifier = TDRF                                         CSD015
     C                   EVAL      WBranch = TDBA                                             CSD015
                                                                                              CSD015
     C     KTradChk      CHAIN     SDCWHTL1                                                   CSD015
                                                                                              CSD015
     C                   IF        %FOUND(SDCWHTL1) and W3UNCF = 'Y'                          CSD015
     C                             and WNotBlank = 'Y' or WChanged = 'Y'                      CSD015
     C                   EVAL      WInsert = 'N'                                              CSD015
     C                   EXSR      SRWatch                                                    CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** UPDATE RECORD

     C                   UPDATE    TRADSDF

      ** UPDATE 'AFTER' STATUS

     C                   MOVEL     TRADSF        Z#ASTS
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* DELETE - DELETE A TRADE                                      *
     C*                                                              *
     C****************************************************************
     C     DELETE        BEGSR

      ** Get trade's TACI as it was at the start of the day
      ** (in case trade was changed earlier today)

     C     A_TDRF        CHAIN     SOBTRSO                            99
     C     *IN99         IFEQ      '0'
     C                   MOVE      TACI          S_TACI            1
     C                   ELSE
     C                   BITOFF    '01234567'    S_TACI
     C                   END

      ** ACCESS TRADE

     C     A_TDRF        CHAIN     TRADSDF                            99

      ** DATABASE ERROR

     C     *IN99         IFEQ      '1'
     C                   MOVEL     A_TDRF        DBKEY
     C                   MOVEL     'TRADSD '     DBFILE                         ************
     C                   MOVEL     '004'         DBASE                          * DBERR 003*
     C                   EXSR      SRERR                                        ************
     C                   END

      ** UPDATE 'BEFORE' STATUS

     C                   MOVEL     TRADSF        Z#BSTS
     C                   MOVEL     TRADSF        B_TRADS
     C                   MOVEL     RECI          PREVREC           1                          179084

      ** SET TRADE FIELDS ON DELETE

     C                   EXSR      SETDEL

      ** UPDATE RECORD

     C                   UPDATE    TRADSDF

      ** UPDATE 'AFTER' STATUS

     C                   MOVEL     TRADSF        Z#ASTS
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* AUTHOR - AUTHORIZE A TRADE                                    *
     C*                                                               *
     C*****************************************************************
     C     AUTHOR        BEGSR

      ** ACCESS TRADE

     C     A_TDRF        CHAIN     TRADSDF                            99

      ** DATA BASE ERROR

     C     *IN99         IFEQ      '1'
     C                   MOVEL     A_TDRF        DBKEY
     C                   MOVEL     'TRADSD  '    DBFILE                         ************
     C                   MOVEL     '005'         DBASE                          * DBERR 003*
     C                   EXSR      SRERR                                        ************
     C                   END

      ** UPDATE 'BEFORE' STATUS

     C                   MOVEL     TRADSF        Z#BSTS
     C                   MOVEL     TRADSF        B_TRADS
     C                   MOVEL     RECI          PREVREC           1                          179084

      ** Store original value of CHTP before changing to 'P'                                  CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WOrgCHTP = CHTP                                            CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** SET TRADE FIELDS ON AUTHORIZE

     C                   EXSR      SETAUT

      ** UPDATE RECORD

     C                   UPDATE    TRADSDF

      ** UPDATE 'AFTER' STATUS

     C                   MOVEL     TRADSF        Z#ASTS
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* APPROV - APPROVE A TRADE                                      *
     C*                                                               *
     C*****************************************************************
     C     APPROV        BEGSR

      ** ACCESS TRADE

     C     A_TDRF        CHAIN     TRADSDF                            99

      ** DATA BASE ERROR

     C     *IN99         IFEQ      '1'
     C                   MOVEL     A_TDRF        DBKEY
     C                   MOVEL     'TRADSD  '    DBFILE                         ************
     C                   MOVEL     '006'         DBASE                          * DBERR 003*
     C                   EXSR      SRERR                                        ************
     C                   END

      ** UPDATE 'BEFORE' STATUS

     C                   MOVEL     TRADSF        Z#BSTS
     C                   MOVEL     TRADSF        B_TRADS
     C                   MOVEL     RECI          PREVREC           1                          179084

      ** Store original value of CHTP before changing to 'P'                                  CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WOrgCHTP = CHTP                                            CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** SET TRADE FIELDS ON APPROVAL

     C                   EXSR      SETAPP

      ** UPDATE RECORD

     C                   UPDATE    TRADSDF

      ** UPDATE 'AFTER' STATUS

     C                   MOVEL     TRADSF        Z#ASTS
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SETINS - SET TRADE FIELDS ON INSERT                           *
     C*                                                               *
     C*****************************************************************
     C     SETINS        BEGSR
     C/COPY WNCPYSRC,SETRADDC14

      ** SET TRADE TO CONTENTS OF VALID TRADE RECORD

     C                   MOVEL     SEVTRD        TRADSF
      *
      ** Record ID - if no authorization
      *
     C     BVAUTH        IFEQ      '00'
     C                   MOVE      'D'           RECI
     C                   END
      *
      ** Record ID - if authorization
      *
     C     BVAUTH        IFNE      '00'
      *
      *  Check user's entering threshold to see whether trade
      *  will need authorising
      *  First, convert countervalue to base currency
      *
     C                   EXSR      TRDVLBS
     C                   Z-ADD     ZAMTCO        CTVL_BASE        15 0
      *
      * Compare countervalue to entering limit
      *
     C     CTVL_BASE     IFGT      ENTL
     C     A_TINC        OREQ      'I'                                                        215727
     C     INCS          OREQ      'I'                                                        215727
     C                   MOVE      'L'           RECI
     C                   ELSE
     C                   MOVE      'D'           RECI
     C                   END
     C                   END

      * Nominal currency and nominal decimal places

     C                   MOVEL     NMCY          TNMC
     C                   Z-ADD     NMDP          TNMD

      * interest adjustment

     C     PROT          IFEQ      '6'
     C                   Z-ADD     *ZERO         TINA
     C                   Z-ADD     *ZERO         TINN                                         CAS006
     C                   END

      * Related Trade Reference

     C                   MOVEL     *BLANK        RTRF
      *
      *  If Bulk Agency Trade : set Agency Trade Indicator
      *
     C                   MOVEL     *BLANK        ATRD
     C     BLKR          IFNE      *BLANKS
     C     CustClass     IFEQ      'S'
     C     CustClass     OREQ      'D'
     C                   MOVE      'C'           ATRD
     C                   ELSE
     C                   MOVE      'M'           ATRD
     C                   END
     C                   END
      *
      *  Bulk Confirmations required
      *
     C     BLKR          IFNE      *BLANKS
     C                   MOVE      'Y'           BCON
     C                   ELSE
     C                   MOVE      ' '           BCON
     C                   END

      * Time of input
     C                   TIME                    TIME
      *
      * Initialize accounting inds
      *            message inds
      *            confirmation required indicator
      *            and settlement data
      *
     C                   BITOFF    '01234567'    TACI
     C                   BITOFF    '01234567'    TMSI
     C                   MOVE      'Y'           TCFR

     C                   Z-ADD     NOML          TOSN
     C                   Z-ADD     *ZEROS        TNSN
     C                   Z-ADD     *ZEROS        TNSP

      * calculate trade settlement value

     C                   EXSR      TRDSETV
     C                   Z-ADD     ZAMTCO        TOSV

     C                   Z-ADD     *ZEROS        TVSN
     C                   Z-ADD     *ZEROS        TVSP
     C                   Z-ADD     *ZEROS        TDSN
     C                   Z-ADD     *ZEROS        TDSP
     C                   Z-ADD     *ZEROS        TDFS

      * Settlement Sequence

     C                   Z-ADD     *ZEROS        TSSQ

      * Date Made Complete

     C     TINC          IFEQ      'C'
     C                   Z-ADD     BJRDNB        TDMC
     C                   ELSE
     C                   Z-ADD     *ZEROS        TDMC
     C                   END

      * Original Entry Date
     C                   Z-ADD     BJRDNB        TOED

      * Pay/Receive Process Complete
     C                   MOVE      'N'           PRPC

      * Last change date
     C                   Z-ADD     BJRDNB        LCD

      * Last swift sequence
     C                   Z-ADD     *ZEROS        LSWS
                                                                                              CGL031
      ** Update customer income file (SDCSINPD) if INSERT.                                    CGL031
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   MOVE      A_CHTP        Procflag                                     CGL031
     C                   EXSR      SRGenCustIn                                                CGL031
     C                   ENDIF                                                                CGL031
      *
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      TMST  = TimeStamp                            CAP006
                                                                                CAP006
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************                       CAP067
      *                                                               *                       CAP067
      * SHRECK - Setup BSPOSD field details                           *                       CAP067
      *                                                               *                       CAP067
      *****************************************************************                       CAP067
     C     SHRECK        BEGSR                                                                CAP067
                                                                                              CAP067
     C                   EVAL      BYESEL = 'N'                                               CAP067
                                                                                              CAP067
      ** Access related trade                                                                 CAP067
                                                                                              CAP067
     C     A_LKRF        CHAIN     TRADSDF                            99                      CAP067
                                                                                              CAP067
      ** If related trade found, setup Buy Sell position details for update later             CAP067
                                                                                              CAP067
     C                   IF        *IN99 = '0'                                                CAP067
                                                                                              CAP067
     C                   EVAL      BYESEL = 'Y'                                               CAP067
                                                                                              CAP067
     C                   IF        TDVD < A_TDVD                                              CAP067
     C                   EVAL      BSPRF = TDRF                                               CAP067
     C                   EVAL      BSVD1 = TDVD                                               CAP067
     C                   EVAL      BSVD2 = A_TDVD                                             CAP067
     C                   ELSE                                                                 CAP067
     C                   EVAL      BSPRF = A_TDRF                                             CAP067
     C                   EVAL      BSVD1 = A_TDVD                                             CAP067
     C                   EVAL      BSVD2 = TDVD                                               CAP067
     C                   ENDIF                                                                CAP067
                                                                                              CAP067
     C                   EVAL      BSRECI = 'D'                                               CAP067
     C                   EVAL      BSBCH = A_TDBA                                             CAP067
     C                   EVAL      BSBOK = A_TDBK                                             CAP067
     C                   EVAL      BSSEN = A_TDSS                                             CAP067
     C                   EVAL      BSTD1 = A_TDDT                                             CAP067
     C                   EVAL      BSTD2 = A_TDDT                                             CAP067
                                                                                              CAP067
     C                   Z-ADD     0             BSPL                                         CAP067
     C                   Z-ADD     0             BSOPL                                        CAP067
     C                   Z-ADD     0             BSAPL                                        CAP067
     C                   Z-ADD     0             BSLATD                                       CAP067
                                                                                              CAP067
     C                   ENDIF                                                                CAP067
                                                                                              CAP067
     C                   ENDSR                                                                CAP067
      *****************************************************************                       CAP067
      /EJECT                                                                                  CAP067
      *****************************************************************                     BUG12938
      *                                                               *                     BUG12938
      * SHRECC - Setup BSPOSD field details during change             *                     BUG12938
      *                                                               *                     BUG12938
      *****************************************************************                     BUG12938
     C     SHRECC        BEGSR                                                              BUG12938
                                                                                            BUG12938
      ** Get Buy-Sell details for trade reference/link reference                            BUG12938
                                                                                            BUG12938
     C     KLPOSR        CHAIN     BSPOSDL0                                                 BUG12938
     C                   IF        NOT %FOUND(BSPOSDL0)                                     BUG12938
     C     KLPOSL        CHAIN     BSPOSDL0                                                 BUG12938
     C                   IF        NOT %FOUND(BSPOSDL0)                                     BUG12938
     C                   LEAVESR                                                            BUG12938
     C                   ENDIF                                                              BUG12938
     C                   ENDIF                                                              BUG12938
                                                                                            BUG12938
      ** Setup details                                                                      BUG12938
                                                                                            BUG12938
     C                   EVAL      BSBCH = A_TDBA                                           BUG12938
     C                   EVAL      BSBOK = A_TDBK                                           BUG12938
     C                   EVAL      BSTD1 = A_TDDT                                           BUG12938
     C                   EVAL      BSTD2 = A_TDDT                                           BUG12938
     C                   UPDATE    BSPOSD0                                                  BUG12938
                                                                                            BUG12938
     C                   ENDSR                                                              BUG12938
      *****************************************************************                     BUG12938
      /EJECT                                                                                BUG12938
     C*****************************************************************
     C*                                                               *
     C* SETAMD - SET TRADE FIELDS ON AMEND                            *
     C*                                                               *
     C*****************************************************************
     C     SETAMD        BEGSR

      ** Update Screen Origin Fields on Amend/Change

     C                   EXSR      UPS_AM_CH
      *
      * Check trade date and value date accounting indicators
      *
     C                   TESTB     '1'           TACI                     97
     C                   TESTB     '0'           TACI                     99
      *
      * If settlement details have changed
      * ('after' values different from 'before' values)
      *
     C     A_SMTH        IFNE      B_SMTH
     C     TDTP          OREQ      'TP'
     C     A_PYFM        ANDNE     B_PYFM
     C     TDTP          OREQ      'TS'
     C     A_PAYT        ANDNE     B_PAYT
     C     A_TDMI        ORNE      B_TDMI
     C     A_TDER        ORNE      B_TDER
     C     *IN97         OREQ      '1'
     C     A_DELT        ANDNE     B_DELT
     C     *IN99         OREQ      '1'
     C     A_DELT        ANDNE     B_DELT
     C     *IN97         OREQ      '1'
     C     A_DELF        ANDNE     B_DELF
     C     *IN99         OREQ      '1'
     C     A_DELF        ANDNE     B_DELF
      *
      ** Record ID - if no authorization
      ** Reset Rec id to reverse original accounting
      *
     C     BVAUTH        IFEQ      '00'
     C                   MOVE      'A'           RECI
     C                   END
      *
      ** Record ID - if authorization
      ** Reset Rec Id as long as trade is not previously unauthorised
      *
     C     BVAUTH        IFNE      '00'
     C     RECI          IFNE      'L'
     C                   MOVE      'P'           RECI
     C                   END
     C                   END
      *
      * Reset accounting inds
      *       confirmation required indicator
      *       and settlement data
      *
     C                   BITOFF    '01234567'    TACI
     C**********         MOVE      'Y'           TCFR                                         245970

     C                   Z-ADD     NOML          TOSN
     C                   Z-ADD     *ZEROS        TNSN
     C                   Z-ADD     *ZEROS        TNSP

      * calculate trade settlement value

     C                   EXSR      TRDSETV
     C                   Z-ADD     ZAMTCO        TOSV
      *
     C                   Z-ADD     *ZEROS        TVSN
     C                   Z-ADD     *ZEROS        TVSP
     C                   Z-ADD     *ZEROS        TDSN
     C                   Z-ADD     *ZEROS        TDSP
     C                   Z-ADD     *ZEROS        TDFS

      * Settlement Sequence

     C                   Z-ADD     *ZEROS        TSSQ

      * Pay/Receive Process Complete
     C                   MOVE      'N'           PRPC
     C                   END

     C                   MOVE      'Y'           TCFR                                         245970
      *                                                                                       245970
      * Date Made Complete

     C     B_TINC        IFEQ      'I'
     C     TINC          ANDEQ     'C'
     C                   Z-ADD     BJRDNB        TDMC
     C                   END

      * Last change date
     C                   Z-ADD     BJRDNB        LCD

      * Type of last change
     C                   MOVEL     A_CHTP        CHTP
     C/COPY WNCPYSRC,SETRADDC01
      *                                                                         CAP013
      ** Front office transaction ID                                            CAP013
      *                                                                         CAP013
     C                   MOVEL     A_FRNT        FRNT                           CAP013
      *                                                                         CAP013
      ** Associated front office transaction ID                                 CAP013
      *                                                                         CAP013
     C                   MOVEL     A_AFRT        AFRT                           CAP013
                                                                                              CGL031
      ** Update customer income file (SDCSINPD) if AMEND.                                     CGL031
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   MOVE      A_CHTP        ProcFlag                                     CGL031
     C                   EXSR      SRGenCustIn                                                CGL031
     C                   ENDIF                                                                CGL031
      *
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      TMST = TimeStamp                             CAP006
                                                                                CAP006
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SETCHG - SET TRADE FIELDS ON CHANGE                           *
     C*                                                               *
     C*****************************************************************
     C     SETCHG        BEGSR
      *
      ** Record ID - if no authorization
      ** Reset Rec id to reverse original accounting
      *
     C     BVAUTH        IFEQ      '00'
     C                   MOVE      'A'           RECI
     C                   END
      *
      ** Record ID - if authorization
      ** Reset Rec Id as long as trade is not previously unauthorised
      *
     C     BVAUTH        IFNE      '00'
     C     RECI          IFNE      'L'
     C                   MOVE      'P'           RECI
     C                   END
     C                   END

      ** Update Screen Origin Fields on Amend/Change

     C                   EXSR      UPS_AM_CH
      *
      * Reset accounting inds
      *       confirmation required indicator
      *       and settlement data
      *
     C                   BITOFF    '01234567'    TACI
     C                   MOVE      'Y'           TCFR

     C                   Z-ADD     NOML          TOSN
     C                   Z-ADD     *ZEROS        TNSN
     C                   Z-ADD     *ZEROS        TNSP

      * calculate trade settlement value

     C                   EXSR      TRDSETV
     C                   Z-ADD     ZAMTCO        TOSV

     C                   Z-ADD     *ZEROS        TVSN
     C                   Z-ADD     *ZEROS        TVSP
     C                   Z-ADD     *ZEROS        TDSN
     C                   Z-ADD     *ZEROS        TDSP
     C                   Z-ADD     *ZEROS        TDFS

      * Settlement Sequence
     C                   Z-ADD     *ZEROS        TSSQ

      * Date Made Complete

     C     B_TINC        IFEQ      'I'
     C     TINC          ANDEQ     'C'
     C                   Z-ADD     BJRDNB        TDMC
     C                   END

      * Pay/Receive Process Complete
     C                   MOVE      'N'           PRPC

      * Last change date
     C                   Z-ADD     BJRDNB        LCD

      * Type of last change
     C                   MOVEL     A_CHTP        CHTP
      *                                                                         CAP013
      ** Front office transaction ID                                            CAP013
      *                                                                         CAP013
     C                   MOVEL     A_FRNT        FRNT                           CAP013
      *                                                                         CAP013
      ** Associated front office transaction ID                                 CAP013
      *                                                                         CAP013
     C                   MOVEL     A_AFRT        AFRT                           CAP013

      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      TMST = TimeStamp                             CAP006
                                                                                       CGL031 236679
      ***Update*customer*income*file*(SDCSINPD)*if*CHANGE.******************           CGL031 236679
                                                                                       CGL031 236679
     C**********         IF        CGL031 = 'Y'                                        CGL031 236679
     C**********         MOVE      A_CHTP        ProcFlag                              CGL031 236679
     C**********         EXSR      SRGenCustIn                                         CGL031 236679
     C**********         ENDIF                                                         CGL031 236679
                                                                                CAP006
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SETDEL - SET TRADE FIELDS ON DELETE                           *
     C*                                                               *
     C*****************************************************************
     C     SETDEL        BEGSR
      *
      ** Record ID - if no authorization
      *
     C     BVAUTH        IFEQ      '00'
     C*************      MOVE      'C'           RECI                                         179084
     C**********         MOVE      '*'           RECI                                  179084 191691
     C                   MOVE      'C'           RECI                                         191691
     C                   END
      *
      ** Record ID - if authorization
      *
     C     BVAUTH        IFNE      '00'
      *
      *  If trade is not yet authorised, no authorisation is needed
      *
     C     RECI          IFEQ      'L'
     C************       MOVE      'C'           RECI                                         179084
     C**********         MOVE      '*'           RECI                                  179084 191691
     C                   MOVE      'C'           RECI                                         191691
     C                   ELSE
     C                   MOVE      'R'           RECI
     C                   END
     C                   END
      ***********                                                                      179084 191691
      ***If*trade is incomplete no authorisation is needed                             179084 191691
      ***********                                                                      179084 191691
     C*****TINC**        IFEQ      'I'                                                 179084 191691
     C***********        MOVE      '*'           RECI                                  179084 191691
     C***********        END                                                           179084 191691
     C     TINC          IFEQ      'I'                                                        203470
     C                   MOVE      'C'           RECI                                         203470
     C                   ENDIF                                                                203470

      * Reset TACI to as it was at the start of day

     C                   MOVE      S_TACI        TACI

      * Confirmation required Ind

     C                   TESTB     '0'           TMSI                     99
     C     *IN99         IFEQ      '0'
     C                   MOVE      'N'           TCFR
     C                   ELSE
     C                   MOVE      'Y'           TCFR
     C                   END

      * Reset settlement data

     C                   Z-ADD     NOML          TOSN
     C                   Z-ADD     *ZEROS        TNSN
     C                   Z-ADD     *ZEROS        TNSP

      * calculate trade settlement value

     C                   EXSR      TRDSETV
     C                   Z-ADD     ZAMTCO        TOSV

     C                   Z-ADD     *ZEROS        TVSN
     C                   Z-ADD     *ZEROS        TVSP
     C                   Z-ADD     *ZEROS        TDSN
     C                   Z-ADD     *ZEROS        TDSP
     C                   Z-ADD     *ZEROS        TDFS

      * Reset settlement sequence

     C                   Z-ADD     *ZEROS        TSSQ

      *  If a deletion before pay/receive processing
      *  PRPC is set to Y

     C     PRPC          IFEQ      'Y'
     C                   MOVE      'N'           PRPC
     C                   ELSE
     C                   MOVE      'Y'           PRPC
     C                   END

      * Last change date
     C                   Z-ADD     BJRDNB        LCD

      * Type of last change
     C                   MOVEL     A_CHTP        CHTP
     C/COPY WNCPYSRC,SETRADDC02
      *                                                                         CAP013
      ** Front office transaction ID                                            CAP013
      *                                                                         CAP013
     C                   MOVEL     A_FRNT        FRNT                           CAP013
      *                                                                         CAP013
      ** Associated front office transaction ID                                 CAP013
      *                                                                         CAP013
     C                   MOVEL     A_AFRT        AFRT                           CAP013
      *
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      TMST = TimeStamp                             CAP006
                                                                                CAP006
     C/COPY WNCPYSRC,SETRADDC13
                                                                                CAP051
      ** Automatic Authorization flag                                           CAP051
      *                                                                         CAP051
     C     CAP051        IFEQ      'Y'                                          CAP051
     C                   MOVEL     A_AUTH        AUTH                           CAP051
     C                   ELSE                                                   CAP051
     C                   MOVE      *BLANKS       AUTH                           CAP051
     C                   ENDIF                                                  CAP051
                                                                                              CGL031
      ** Delete from customer income file (SDCSINPD).                                         CGL031
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   MOVE      A_CHTP        ProcFlag                                     CGL031
     C                   EVAL      XDDEUTX = DDEUTX                                           235112
     C                   Z-ADD     EUTX          XEUTX                                        235112
     C                   Z-ADD     EUTS          XEUTS                                        235112
     C                   EXSR      SRGenCustIn                                                CGL031
     C                   EVAL      DDEUTX = XDDEUTX                                           235112
     C                   Z-ADD     XEUTX         EUTX                                         235112
     C                   Z-ADD     XEUTS         EUTS                                         235112
     C                   ENDIF                                                                CGL031
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SETAUT - SET TRADE FIELDS ON AUTHORIZE                        *
     C*                                                               *
     C*****************************************************************
     C     SETAUT        BEGSR
      *
      ** Set record ID according to previous record id
      *
      ** RECI=L : inserted not authorized
      *
     C     B_RECI        IFEQ      'L'
     C                   MOVE      'D'           RECI
     C                   END
      *
      ** RECI=P : changed not authorized
      *
     C     B_RECI        IFEQ      'P'
     C                   MOVE      'A'           RECI
     C                   END
      *
      ** RECI=R : deleted not authorized
      *
     C     B_RECI        IFEQ      'R'
     C                   MOVE      'C'           RECI
     C                   END
      *                                                                                       223022
      ** Pay/Receive Process Complete                                                         223022
      *                                                                                       223022
     C                   MOVE      'N'           PRPC                                         223022

      * Last change date
     C                   Z-ADD     BJRDNB        LCD

      * Type of last change
     C                   MOVEL     A_CHTP        CHTP
      *                                                                         CAP013
      ** Front office transaction ID                                            CAP013
      *                                                                         CAP013
     C                   MOVEL     A_FRNT        FRNT                           CAP013
      *                                                                         CAP013
      ** Associated front office transaction ID                                 CAP013
      *                                                                         CAP013
     C                   MOVEL     A_AFRT        AFRT                           CAP013
      *
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      TMST = TimeStamp                             CAP006
                                                                                CAP006
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SETAPP - SET TRADE FIELDS ON APPROVAL                         *
     C*                                                               *
     C*****************************************************************
     C     SETAPP        BEGSR
      *                                                                                       223022
      ** Pay/Receive Process Complete                                                         223022
      *                                                                                       223022
     C                   MOVE      'N'           PRPC                                         223022

      * Last change date
     C                   Z-ADD     BJRDNB        LCD

      * Type of last change
     C                   MOVEL     A_CHTP        CHTP
      *                                                                         CAP013
      ** Front office transaction ID                                            CAP013
      *                                                                         CAP013
     C                   MOVEL     A_FRNT        FRNT                           CAP013
      *                                                                         CAP013
      ** Associated front office transaction ID                                 CAP013
      *                                                                         CAP013
     C                   MOVEL     A_AFRT        AFRT                           CAP013

      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      TMST = TimeStamp                             CAP006

     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* UPS_AM_CH - Update Screen Origin Fields on Amend/Change       *
     C*                                                               *
     C*****************************************************************
     C     UPS_AM_CH     BEGSR

      ** Incomplete Indicator
      ** Security Shortname
     C                   MOVEL     A_TINC        TINC
     C                   MOVEL     A_TDSS        TDSS

      ** Counterparty Customer Number
      ** Trade Type
      ** Nominal
      ** Price/Discount/Yield
      ** Value Date
     C                   MOVEL     A_TCNR        TCNR
     C                   MOVEL     A_TDTP        TDTP
     C                   MOVEL     A_NOML        NOML
     C                   MOVEL     A_TPDY        TPDY
     C                   MOVEL     A_TDVD        TDVD

      ** Branch code
      ** Originating branch
     C                   MOVEL     A_TDBA        TDBA
     C                   MOVEL     A_ORBR        ORBR

      ** Book
      ** Trade Date
      ** Trade Sub-type
     C                   MOVEL     A_TDBK        TDBK
     C                   MOVEL     A_TDDT        TDDT
     C                   MOVEL     A_TSUB        TSUB

      ** Link Reference
      ** Market Indicator
      ** Narrative
      ** Trader I.D.
      ** AIBD/IPMA
      ** Market Centre
      ** Capacity
     C                   MOVEL     A_LKRF        LKRF
     C                   MOVEL     A_TDMI        TDMI
     C                   MOVEL     A_TDNR        TDNR
     C                   MOVEL     A_TDID        TDID
     C                   MOVEL     A_AIIP        AIIP
     C                   MOVEL     A_TMKC        TMKC
     C                   MOVEL     A_TCAP        TCAP

      ** Accrued Indicator
      ** Days Adjustment
      ** Act/Diff indicator
      ** Interest Amount (Purchased)
      ** Interest Adjustment
      ** Coupon Rate
     C                   MOVEL     A_ACIN        ACIN
     C                   MOVEL     A_DADJ        DADJ
     C                   MOVEL     A_ADIN        ADIN
     C                   MOVEL     A_ITRA        ITRA
     C                   MOVEL     A_TINA        TINA
     C                   MOVEL     A_TDCR        TDCR

      ** Price
      ** Ex Dividend
      ** Reallowance
     C                   MOVEL     A_PRIC        PRIC
     C                   MOVEL     A_EXDV        EXDV
     C                   MOVEL     A_RALL        RALL

      ** Settlement Currency
     C                   MOVEL     A_SETC        SETC

      ** Exchange Rate (Nominal to settle)
      ** Multiply/Divide Ind
      ** Base Currency Rate
     C                   MOVEL     A_TDER        TDER
     C                   MOVEL     A_TMDI        TMDI
     C                   MOVEL     A_TBCR        TBCR

      ** Settlement Method
      ** Pay From
      ** Pay From Branch
      ** Pay To
      ** Pay To Branch
      ** For Account of (Pay to)
      ** Account Sequence Number
      ** Clearance Type
      ** Deliver to
      ** For Account of (Deliver to)
      ** Deliver From
      ** For Account of (Deliver From)
      ** Special Instructions

     C                   MOVEL     A_SMTH        SMTH
     C                   MOVEL     A_PYFM        PYFM
     C                   MOVEL     A_PYFA        PYFA
     C                   MOVEL     A_PAYT        PAYT
     C                   MOVEL     A_PYTA        PYTA
     C                   MOVEL     A_TDFA        TDFA
     C                   MOVEL     A_ASNM        ASNM
     C                   MOVEL     A_CLTY        CLTY
     C                   MOVEL     A_DELT        DELT
     C                   MOVEL     A_DTFA        DTFA
     C                   MOVEL     A_DELF        DELF
     C                   MOVEL     A_DFFA        DFFA
     C                   MOVEL     A_TDSI        TDSI

      ** Priority Code
      ** Pay Code
     C                   MOVEL     A_PRYC        PRYC
     C                   MOVEL     A_PCOD        PCOD

      ** Broker Commission Code
      ** Broker Commission Amount
     C                   MOVEL     A_TBCC        TBCC
     C                   MOVEL     A_TBCA        TBCA

      ** Customer Commission Code
      ** Customer Commission Amt
     C                   MOVEL     A_TCCC        TCCC
     C                   MOVEL     A_TCCA        TCCA

      ** Charges Code 1
      ** Charges Amount 1
     C                   MOVEL     A_TCC1        TCC1
     C                   MOVEL     A_TCA1        TCA1

      ** Charges Code 2
      ** Charges Amount 2
     C                   MOVEL     A_TCC2        TCC2
     C                   MOVEL     A_TCA2        TCA2

      ** Charges Code 3
      ** Charges Amount 3
     C                   MOVEL     A_TCC3        TCC3
     C                   MOVEL     A_TCA3        TCA3

      ** Charges Code 4
      ** Charges Amount 4
     C                   MOVEL     A_TCC4        TCC4
     C                   MOVEL     A_TCA4        TCA4

      ** Charges Code 5
      ** Charges amount 5
     C                   MOVEL     A_TCC5        TCC5
     C                   MOVEL     A_TCA5        TCA5

      ** Charges Code 6
      ** Charges Amount 6
     C                   MOVEL     A_TCC6        TCC6
     C                   MOVEL     A_TCA6        TCA6

      ** Charges Code 7
      ** Charges amount 7
     C                   MOVEL     A_TCC7        TCC7
     C                   MOVEL     A_TCA7        TCA7

      ** Tax amount
      ** Broker Commission Rebate
      ** Customer Commission Rebate
      ** Tax Rebate
     C                   MOVEL     A_TAXA        TAXA
     C                   MOVEL     A_BCMR        BCMR
     C                   MOVEL     A_CCMR        CCMR
     C                   MOVEL     A_TXRB        TXRB

      ** Auto-settle Indicator
     C                   MOVEL     A_AUTS        AUTS

      ** Consideration
      ** Countervalue
     C                   MOVEL     A_TCSR        TCSR
     C                   MOVEL     A_TCTR        TCTR

      ** Profit Centre - non PCA
     C                   MOVEL     A_PRFC        PRFC

      ** Current Factor
     C                   MOVEL     A_TCFC        TCFC

      ** Portfolio reference
      ** Exchange Rate (Settle > Port
      ** Spot rate mult/div ind
     C                   MOVEL     A_PTFR        PTFR
     C                   MOVEL     A_SPXR        SPXR
     C                   MOVEL     A_SPMD        SPMD

      ** Book Profit Centre
      ** Trans Profit Centre
      ** FX Margin Points
      ** FX Margin Rate
      ** Margin Amount
      ** In Currency in Field 72
     C                   MOVEL     A_BPRC        BPRC
     C                   MOVEL     A_TPRC        TPRC
     C                   MOVEL     A_FXMP        FXMP
     C                   MOVEL     A_FXMR        FXMR
     C                   MOVEL     A_MAMT        MAMT
     C                   MOVEL     A_ICCY        ICCY
                                                                                CAP051
      ** Automatic Authorization flag                                           CAP051
      *                                                                         CAP051
     C     CAP051        IFEQ      'Y'                                          CAP051
     C                   MOVEL     A_AUTH        AUTH                           CAP051
     C                   ELSE                                                   CAP051
     C                   MOVE      *BLANKS       AUTH                           CAP051
     C                   ENDIF                                                  CAP051
      *                                                                         CSE023
      ** If enhancement 'Treaty withholding tax' is installed,                  CSE023
      ** amend withholding tax field.                                           CSE023
      *                                                                         CSE023
     C                   IF        CSE023 = 'Y'                                 CSE023
     C                   Z-ADD     A_WHTX        WHTX                           CSE023
     C                   ELSE                                                   CSE023
     C                   Z-ADD     *ZEROS        WHTX                           CSE023
     C                   ENDIF                                                  CSE023
                                                                                              CAS006
      ** If CAS006 is on                                                                      CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EVAL      CRSK = A_CRSK                                              CAS006
     C                   EVAL      LQPR = A_LQPR                                              CAS006
     C                   EVAL      TINN = A_TINN                                              CAS006
     C                   EVAL      ITRN = A_ITRN                                              CAS006
     C                   EVAL      PRICN = A_PRICN                                            CAS006
     C                   ENDIF                                                                CAS006

      * Order Number                                                                          CSE039
     C                   MOVE      A_ORDE        ORDE                                         CSE039
      *                                                                                       CSE039
      ** Fiscal Price                                                                         CGL031
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   MOVEL     A_FSPR        FSPR                                         CGL031
     C                   MOVEL     A_FSPP        FSPP                                         236073
     C                   ELSE                                                                 CGL031
     C                   Z-ADD     *ZEROS        FSPR                                         CGL031
     C                   Z-ADD     *ZEROS        FSPP                                         236073
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* ONLNUP - ON-LINE UPDATES (MEMOS, PRONO, OLPOS, RSACMTPD)      *
     C*                                                               *
     C*****************************************************************
     C     ONLNUP        BEGSR
      *
     C                   CALL      'AOOUTRU0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM                    Z#BSTS
     C                   PARM                    Z#ASTS
     C     @RTCD         IFEQ      '*ERROR*'
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     'AOOUTRU0'    DBFILE                         *************
     C                   MOVEL     '991'         DBASE                          * DBERR 991 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *                                                                         CDE001
      ** Data export for CCRM - Limits                                          CDE001
      *                                                                         CDE001
     C                   IF        CDE001 = 'Y'                                 CDE001
     C                   MOVEL     *BLANK        T#TREF                         CDE001
     C                   MOVEL     A_TDRF        T#TREF                         CDE001
     C                   CALLB     'DEWRTTRIG'                                  CDE001
     C**********         PARM                    T#TREF           20                   CDE001 CGL029
     C                   PARM                    T#TREF                                       CGL029
     C                   PARM      'STRD'        T#TCAT            4            CDE001
     C                   PARM      *BLANKS       T#RSRV           10            CDE005
      *                                                                         CDE001
     C                   MOVEL     A_TDSS        W#TDSS                         CDE001
     C                   MOVEL     A_TDBK        W#TDBK                         CDE001
     C                   MOVEL     A_TDBA        W#TDBA                         CDE001
     C                   MOVEL     A_TDMI        W#TDMI                         CDE001
     C                   MOVEL     W#POSID       T#TREF                         CDE001
     C                   CALLB     'DEWRTTRIG'                                  CDE001
     C**********         PARM                    T#TREF           20                   CDE001 CGL029
     C                   PARM                    T#TREF                                       CGL029
     C                   PARM      'SBPS'        T#TCAT            4            CDE001
     C                   PARM      *BLANKS       T#RSRV           10            CDE005
     C                   ENDIF                                                  CDE001
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  WBKPOS - Subroutine to Update Book Positions.                *
      *                                                               *
      *****************************************************************
     C     WBKPOS        BEGSR
      *
     C                   Z-ADD     TDDT          TLPSD
     C                   Z-ADD     TDVD          VLPSD
      *
      *  If amendment and BKPOS key or countervalue fields not changed,
      *  do not amend BKPOS unless trade made complete.
      *
     C     A_CHTP        IFEQ      'A'
     C     B_TINC        ANDEQ     'C'
     C     A_CHTP        OREQ      'C'
     C     B_TINC        ANDEQ     'C'
      *
     C     TDSS          IFEQ      B_TDSS
     C     TDBA          ANDEQ     B_TDBA
     C     TDBK          ANDEQ     B_TDBK
     C     TDMI          ANDEQ     B_TDMI
     C     TDDT          ANDEQ     B_TDDT
     C     TDVD          ANDEQ     B_TDVD
     C     TCTR          ANDEQ     B_TCTR
     C                   GOTO      WBKEND
     C                   END
      *
     C                   END
     C*
     C*  Access BKPHD trade date position
     C*
     C                   MOVEL     TDSS          BHSC
     C                   MOVEL     TDBA          BHBA
     C                   MOVEL     TDBK          BHBK
     C                   MOVEL     TDMI          BHMK
     C                   MOVEL     'T'           BHTV
     C     KLBKPH        CHAIN     BKPHDDF                            44
     C*
      ***  Write new BKPHD Trade Date record if doesn't already exist.
     C*
     C     *IN44         IFEQ      '1'
     C                   MOVE      'D'           RECI
     C                   Z-ADD     TDDT          FPSD
     C                   Z-ADD     TDDT          LPSD
     C                   Z-ADD     TDDT          LPCD
     C                   Z-ADD     *ZEROS        LAVP
     C                   Z-ADD     *ZEROS        LATD
     C                   Z-ADD     *ZEROS        ARPC
     C                   Z-ADD     TDVD          ICLD
     C                   Z-ADD     *ZEROS        IACR
     C                   Z-ADD     *ZEROS        IACP
     C                   Z-ADD     *ZEROS        INDO
     C                   Z-ADD     *ZEROS        UPPT
     C                   Z-ADD     *ZEROS        DPAP
     C                   Z-ADD     *ZEROS        DPFP
     C                   Z-ADD     *ZEROS        BUDU
     C                   MOVE      SITP          INVT
     C                   MOVE      NMCY          NCRY
     C                   Z-ADD     *ZEROS        LPRC
     C                   Z-ADD     *ZEROS        BHDP
     C                   Z-ADD     *ZEROS        BHCP
     C                   Z-ADD     *ZEROS        BHPP
     C                   Z-ADD     NATN          TNLU
     C                   Z-ADD     *ZERO         LAVN                                         CAS006
     C                   Z-ADD     *ZERO         DPAN                                         CAS006
     C                   Z-ADD     *ZERO         BUDN                                         CAS006
     C                   Z-ADD     *ZERO         INDN                                         CAS006
     C                   Z-ADD     *ZERO         FSEFUP                                       CAS006
     C                   Z-ADD     *ZERO         FSECUP                                       CAS006
     C                   Z-ADD     *ZEROS        NAVP                                         CSE065
     C                   Z-ADD     *ZEROS        BKVAMT                                       CSE065
     C                   Z-ADD     *ZEROS        EQTAMT                                       CSE065
     C                   WRITE     BKPHDDF
     C                   ADD       1             BK_NOR
     C*
     C                   END
     C*
     C* Remember latest position date
     C*
     C                   Z-ADD     LPSD          TLPSD             5 0
     C/COPY WNCPYSRC,SETRADDC04
     C*
     C*
     C*  If value date LE run date :-
     C*  Access BKPHD value date position
     C*
     C     TDVD          IFLE      BJRDNB
     C*
     C                   MOVEL     TDSS          BHSC
     C                   MOVEL     TDBA          BHBA
     C                   MOVEL     TDBK          BHBK
     C                   MOVEL     TDMI          BHMK
     C                   MOVEL     'V'           BHTV
     C     KLBKPH        CHAIN     BKPHDDF                            44
     C*
      ***  Write new BKPHD Value Date record if doesn't already exist.
     C*
     C     *IN44         IFEQ      '1'
     C                   MOVE      'D'           RECI
     C                   Z-ADD     TDVD          FPSD
     C                   Z-ADD     TDVD          LPSD
     C                   Z-ADD     TDVD          LPCD
     C                   Z-ADD     *ZEROS        LAVP
     C                   Z-ADD     *ZEROS        LATD
     C                   Z-ADD     *ZEROS        ARPC
     C                   Z-ADD     TDVD          ICLD
     C                   Z-ADD     *ZEROS        IACR
     C                   Z-ADD     *ZEROS        IACP
     C                   Z-ADD     *ZEROS        INDO
     C                   Z-ADD     *ZEROS        UPPT
     C                   Z-ADD     *ZEROS        DPAP
     C                   Z-ADD     *ZEROS        DPFP
     C                   Z-ADD     *ZEROS        BUDU
     C                   MOVE      SITP          INVT
     C                   MOVE      NMCY          NCRY
     C                   Z-ADD     *ZEROS        LPRC
     C                   Z-ADD     *ZEROS        BHDP
     C                   Z-ADD     *ZEROS        BHCP
     C                   Z-ADD     *ZEROS        BHPP
     C                   Z-ADD     NATN          TNLU
     C                   Z-ADD     *ZEROS        NAVP                                         CSE065
     C                   Z-ADD     *ZEROS        BKVAMT                                       CSE065
     C                   Z-ADD     *ZEROS        EQTAMT                                       CSE065
     C                   WRITE     BKPHDDF
     C                   ADD       1             BK_NOR
     C*
     C                   END
     C*
     C* Remember latest position date
     C*
     C                   Z-ADD     LPSD          VLPSD             5 0
     C                   END
     C*
     C*  Access BKPOS trade date position
     C*
     C                   MOVEL     TDSS          BPSC
     C                   MOVEL     TDBA          BPBA
     C                   MOVEL     TDBK          BPBK
     C                   MOVEL     TDMI          BPMK
     C                   MOVEL     'T'           BPTV
     C                   Z-ADD     TLPSD         BPPD
     C*
     C                   Z-ADD     *ZEROS        SNPI
     C                   Z-ADD     *ZEROS        SANP
     C                   Z-ADD     *ZEROS        SNSI
     C                   Z-ADD     *ZEROS        SANS
     C*
     C     KLBKPS        CHAIN     BKPOSDF                            44
     C*
     C*  Update trade date positions :-
     C*
     C                   Z-ADD     NATN          TNLU
     C*
      ***  Write new BKPOS Trade Date record if doesn't already exist.
      *
     C     *IN44         IFEQ      '1'
     C                   ADD       1             BS_NOR
     C                   Z-ADD     *ZEROS        NPSN
     C                   Z-ADD     *ZEROS        APNC
     C                   Z-ADD     *ZEROS        ECNP
     C                   Z-ADD     *ZEROS        APPB
     C                   Z-ADD     *ZEROS        RPTP
     C                   Z-ADD     *ZEROS        PILP
     C                   Z-ADD     *ZEROS        ANMP
     C                   Z-ADD     *ZEROS        AAPR
     C*
     C                   MOVE      'D'           RECI
     C                   MOVEL     TDSS          BPSC
     C                   MOVEL     TDBA          BPBA
     C                   MOVEL     TDBK          BPBK
     C                   MOVEL     TDMI          BPMK
     C                   MOVEL     'T'           BPTV
     C                   Z-ADD     TDDT          BPPD
     C                   Z-ADD     *ZEROS        SANP
     C                   Z-ADD     *ZEROS        SNPI
     C                   Z-ADD     *ZEROS        SANS
     C                   Z-ADD     *ZEROS        SNSI
     C                   MOVE      *BLANK        ADJI
     C                   Z-ADD     NATN          TNLU
     C                   Z-ADD     *ZEROS        BKCOST                                       CSE065
     C*
     C*  Calculate trade date positions
     C*
     C                   MOVE      A_CHTP        TYP_OF_ACT        1
     C                   EXSR      CBKPOS
     C*
     C                   WRITE     BKPOSDF
     C*
      ***  Else update existing BKPOS Trade Date record.
      *
     C                   ELSE
      *
     C*  Calculate trade date positions
     C*
     C                   MOVE      A_CHTP        TYP_OF_ACT
     C                   EXSR      CBKPOS
     C*
     C                   UPDATE    BKPOSDF
     C*
     C                   END
     C*
     C*  If value date LE run date
     C*  Access BKPOS value date position
     C*
     C     TDVD          IFLE      BJRDNB
     C*
     C                   MOVEL     TDSS          BPSC
     C                   MOVEL     TDBA          BPBA
     C                   MOVEL     TDBK          BPBK
     C                   MOVEL     TDMI          BPMK
     C                   MOVEL     'V'           BPTV
     C                   Z-ADD     VLPSD         BPPD
     C*
     C                   Z-ADD     *ZEROS        SNPI
     C                   Z-ADD     *ZEROS        SANP
     C                   Z-ADD     *ZEROS        SNSI
     C                   Z-ADD     *ZEROS        SANS
     C*
     C     KLBKPS        CHAIN     BKPOSDF                            44
     C*
     C*  Update BKPOS value date positions :-
     C*
     C                   Z-ADD     NATN          TNLU
     C*
      ***  Write new BKPOS Value Date record if doesn't already exist.
      *
     C     *IN44         IFEQ      '1'
     C                   ADD       1             BS_NOR
     C                   Z-ADD     *ZEROS        NPSN
     C                   Z-ADD     *ZEROS        APNC
     C                   Z-ADD     *ZEROS        ECNP
     C                   Z-ADD     *ZEROS        APPB
     C                   Z-ADD     *ZEROS        RPTP
     C                   Z-ADD     *ZEROS        PILP
     C                   Z-ADD     *ZEROS        ANMP
     C                   Z-ADD     *ZEROS        AAPR
     C*
     C                   MOVE      'D'           RECI
     C                   MOVEL     TDSS          BPSC
     C                   MOVEL     TDBA          BPBA
     C                   MOVEL     TDBK          BPBK
     C                   MOVEL     TDMI          BPMK
     C                   MOVEL     'V'           BPTV
     C                   Z-ADD     TDVD          BPPD
     C                   Z-ADD     *ZEROS        SANP
     C                   Z-ADD     *ZEROS        SNPI
     C                   Z-ADD     *ZEROS        SANS
     C                   Z-ADD     *ZEROS        SNSI
     C                   MOVE      *BLANK        ADJI
     C                   Z-ADD     NATN          TNLU
     C                   Z-ADD     *ZERO         APPN                                         CAS006
     C                   Z-ADD     *ZERO         APNN                                         CAS006
     C                   Z-ADD     *ZERO         PILN                                         CAS006
     C                   Z-ADD     *ZEROS        BKCOST                                       CSE065
     C*
     C*  Calculate BKPOS value date positions
     C*
     C                   MOVE      A_CHTP        TYP_OF_ACT
     C                   EXSR      CBKPOS
     C*
     C                   WRITE     BKPOSDF
     C*
      ***  Else update existing BKPOS Value Date record.
      *
     C                   ELSE
     C*
     C*  Calculate BKPOS value date positions
     C*
     C                   MOVE      A_CHTP        TYP_OF_ACT
     C                   EXSR      CBKPOS
     C*
     C                   UPDATE    BKPOSDF
     C*
     C                   END
     C                   END
     C*
     C*  If amendment and BKPOS key or countervalue fields changed,
     C*  and trade was already complete      cancel original details
     C*
     C     A_CHTP        IFEQ      'A'
     C     B_TINC        ANDEQ     'C'
     C     A_CHTP        OREQ      'C'
     C     B_TINC        ANDEQ     'C'
     C*
     C*  Access BKPOS original trade date position
     C*
     C                   MOVEL     B_TDSS        BHSC
     C                   MOVEL     B_TDBA        BHBA
     C                   MOVEL     B_TDBK        BHBK
     C                   MOVEL     B_TDMI        BHMK
     C                   MOVEL     'T'           BHTV
     C     KLBKPH        CHAIN     BKPHDDF                            44
     C*
     C                   MOVEL     B_TDSS        BPSC
     C                   MOVEL     B_TDBA        BPBA
     C                   MOVEL     B_TDBK        BPBK
     C                   MOVEL     B_TDMI        BPMK
     C                   MOVEL     'T'           BPTV
     C                   Z-ADD     LPSD          BPPD
     C     KLBKPS        CHAIN     BKPOSDF                            44
     C*
     C*  Calculate original BKPOS trade date positions
     C*
     C                   Z-ADD     B_NOML        NOML
     C                   Z-ADD     B_PRIC        PRIC
     C                   Z-ADD     B_RALL        RALL
     C                   Z-ADD     B_TCA1        TCA1
     C                   Z-ADD     B_TCA2        TCA2
     C                   Z-ADD     B_TCA3        TCA3
     C                   Z-ADD     B_TCA4        TCA4
     C                   Z-ADD     B_TCA5        TCA5
     C                   Z-ADD     B_TCA6        TCA6
     C                   Z-ADD     B_TCA7        TCA7
     C                   Z-ADD     B_TBCA        TBCA
     C                   Z-ADD     B_TCCA        TCCA
     C                   Z-ADD     B_TDVD        TDVD
     C*
     C                   MOVE      'D'           TYP_OF_ACT
     C                   EXSR      CBKPOS
     C*
     C*  Update original BKPOS trade date positions
     C*
     C     *IN44         IFEQ      '0'
     C*
     C                   UPDATE    BKPOSDF
     C*
     C                   END
     C*
     C*  Access BKPOS original value date position
     C*                   - only if original value date LE run date
     C*
     C     B_TDVD        IFLE      BJRDNB
     C                   MOVEL     B_TDSS        BHSC
     C                   MOVEL     B_TDBA        BHBA
     C                   MOVEL     B_TDBK        BHBK
     C                   MOVEL     B_TDMI        BHMK
     C                   MOVEL     'V'           BHTV
     C     KLBKPH        CHAIN     BKPHDDF                            44
     C*
     C                   MOVEL     B_TDSS        BPSC
     C                   MOVEL     B_TDBA        BPBA
     C                   MOVEL     B_TDBK        BPBK
     C                   MOVEL     B_TDMI        BPMK
     C                   MOVEL     'V'           BPTV
     C                   Z-ADD     LPSD          BPPD
     C     KLBKPS        CHAIN     BKPOSDF                            44
     C*
     C*  Calculate BKPOS original value date positions
     C*
     C                   MOVE      'D'           TYP_OF_ACT
     C                   EXSR      CBKPOS
     C*
     C*  Update BKPOS original value date positions
     C*
     C     *IN44         IFEQ      '0'
     C*
     C                   UPDATE    BKPOSDF
     C*
     C                   END
     C                   END
     C*
     C*  Reset current trade details
     C*
     C                   If        Z#ASTS = *Blanks                                         BUG14514
     C                   Clear                   TRADSF                                     BUG14514
     C                   Else                                                               BUG14514
     C                   MOVEL     Z#ASTS        TRADSF
     C                   EndIf                                                              BUG14514
     C*
     C                   END
     C*
     C     WBKEND        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CBKPOS - Subroutine to calculate the latest Book Positions.  *
      *                                                               *
      *****************************************************************
     C     CBKPOS        BEGSR
      *
      *  Calculate consideration
      *
     C                   Z-ADD     NOML          ZNOML
     C                   Z-ADD     PRIC          ZPRC
     C                   EXSR      ZCNSD
     C                   Z-ADD     ZCONS         W#CONS           15 0
     C     PROT          IFEQ      '8'
     C                   MULT      TCFC          W#CONS
     C                   END
      *
      *  Calculate reallowance
      *
     C                   Z-ADD     *ZEROS        W#RALL           15 0
     C     BVRBAP        IFEQ      'Y'
     C                   EXSR      CALEFRALL
     C                   Z-ADD     NOML          ZNOML
     C                   Z-ADD     EFF_RALL      ZPRC
     C                   EXSR      ZCNSD
     C                   Z-ADD     ZCONS         W#RALL
     C                   END
      *
      *  Calculate charges/commission
      *
     C                   Z-ADD     *ZEROS        W#CHRG           15 0
     C     BVCBAP        IFEQ      'Y'
     C     TCA1          ADD       TCA2          W#CHRG
     C                   ADD       TCA3          W#CHRG
     C                   ADD       TCA4          W#CHRG
     C                   ADD       TCA5          W#CHRG
     C                   ADD       TCA6          W#CHRG
     C                   ADD       TCA7          W#CHRG
     C                   ADD       TAXA          W#CHRG
     C                   END
      *
     C                   Z-ADD     *ZEROS        W#COMM           15 0
     C     BVCMBP        IFEQ      'Y'
     C     TBCA          ADD       TCCA          W#COMM
     C                   END
      *
      ***  Update Sum Nominals (I/C) and Sum A P Numerators
      *
      *   Insert/amendment(purchase)
      *
     C     TDTP          IFEQ      'TP'
     C*
     C     TYP_OF_ACT    IFNE      'D'
     C*
     C                   ADD       NOML          SNPI
     C*
     C                   ADD       W#CONS        SANP
     C                   ADD       W#RALL        SANP
     C*
     C     CustClass     IFEQ      'M'
     C                   ADD       W#CHRG        SANP
     C                   ADD       W#COMM        SANP
     C                   ELSE
     C                   SUB       W#CHRG        SANP
     C                   SUB       W#COMM        SANP
     C                   END
     C*
     C                   ELSE
     C*
     C*  Deletion(purchase)
     C*
     C                   SUB       NOML          SNPI
     C*
     C                   SUB       W#CONS        SANP
     C                   SUB       W#RALL        SANP
     C     CustClass     IFEQ      'M'
     C                   SUB       W#CHRG        SANP
     C                   SUB       W#COMM        SANP
     C                   ELSE
     C                   ADD       W#CHRG        SANP
     C                   ADD       W#COMM        SANP
     C                   END
     C*
     C                   END
     C*
     C                   ELSE
     C*
     C*   Insert/amend(sale)
     C*
     C     TYP_OF_ACT    IFNE      'D'
     C*
     C                   SUB       NOML          SNSI
     C*
     C                   SUB       W#CONS        SANS
     C                   SUB       W#RALL        SANS
     C     CustClass     IFEQ      'M'
     C                   SUB       W#CHRG        SANS
     C                   SUB       W#COMM        SANS
     C                   ELSE
     C                   ADD       W#CHRG        SANS
     C                   ADD       W#COMM        SANS
     C                   END
     C*
     C                   ELSE
     C*
     C*  Deletion(sale)
     C*
     C                   ADD       NOML          SNSI
     C                   ADD       W#CONS        SANS
     C                   ADD       W#RALL        SANS
     C*
     C     CustClass     IFEQ      'M'
     C                   ADD       W#CHRG        SANS
     C                   ADD       W#COMM        SANS
     C                   ELSE
     C                   SUB       W#CHRG        SANS
     C                   SUB       W#COMM        SANS
     C                   END
     C*
     C                   END
     C                   END
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  WCPOSN - Subroutine to Update Client Depot Positions.        *
      *                                                               *
      *****************************************************************
     C     WCPOSN        BEGSR
      *
      *  Action code I is insert new
      *  Action code D is cancel new
      *  Action codes A & C are same as insert new + cancel old
      *
      *  If not deletion :-
      *
     C     A_CHTP        IFNE      'D'
      *
      *  Access CPOSN client position
      *
     C                   MOVEL     TDBA          CSBA
     C                   MOVEL     TDSS          CSSC
     C                   MOVEL     TCNR          CSCN
     C     KLPOSN        CHAIN     CPOSNDF                            44
     C*
     C*  Update CPOSN client position
     C*
     C                   Z-ADD     NATN          TNLU
     C*
     C     *IN44         IFEQ      '1'
     C                   MOVE      'D'           RECI
     C                   Z-ADD     *ZEROS        CSNT
     C                   Z-ADD     *ZEROS        CSNV
     C                   Z-ADD     *ZEROS        CSNS
     C                   Z-ADD     *ZEROS        CSEX
     C                   Z-ADD     *ZEROS        CSPT
     C                   Z-ADD     *ZEROS        CSPV
     C                   Z-ADD     *ZEROS        CSCT
     C                   Z-ADD     *ZEROS        CSCV
     C     CGL031        IFEQ      'Y'                                                        CGL031
     C                   Z-ADD     *ZEROS        CSPI                                         CGL031
     C                   Z-ADD     *ZEROS        CSAT                                         CGL031
     C                   Z-ADD     *ZEROS        CSAV                                         CGL031
     C                   Z-ADD     *ZEROS        AVFP                                         236705
     C     TDTP          IFEQ      'TP'                                                       236705
     C                   Z-ADD     *ZEROS        APDT                                         236705
     c                   ELSE                                                                 236705
     C                   Z-ADD     TDVD          APDT                                         236705
     c                   ENDIF                                                                236705
     C                   ENDIF                                                                CGL031
     C     TDVD          IFLE      BJRDNB
     C                   Z-ADD     TDVD          CSDA
     C                   ELSE
     C                   Z-ADD     TDDT          CSDA
     C                   END
     C                   MOVE      'N'           CSBT
     C                   MOVE      'N'           CSBV
     C                   WRITE     CPOSNDF
     C                   ADD       1             CP_NOR
     C*
     C                   ELSE
     C*
     C     TDDT          IFLE      CSCT
     C                   MOVE      'Y'           CSBT
     C                   END
     C     TDVD          IFLE      CSCV
     C                   MOVE      'Y'           CSBV
     C                   END
      *****************************************************************                236705 234440
     C*****CGL031        IFEQ      'Y'                                                 236705 234440
     C**********         CALLB     'SEVAPDT'                                           236705 234440
     C**********         PARM      TDBA          WBrca                                 236705 234440
     C**********         PARM      TCNR          WCust                                 236705 234440
     C**********         PARM      TDSS          WSesn                                 236705 234440
     C**********         PARM      TDTP          WType                                 236705 234440
     C**********         PARM      NOML          WAmt                                  236705 234440
     C**********         PARM      TDVD          WDate                                 236705 234440
     C**********         PARM                    WrkAPDT                               236705 234440
     C*****TDTP*         IFEQ      'TP'                                                236705 234440
     C*****WrkAPDT       IFEQ      *ZEROS                                              236705 234440
     C**********         Z-ADD     WrkAPDT       APDT                                  236705 234440
     c**********         ENDIF                                                         236705 234440
     c**********         ELSE                                                          236705 234440
     C**********         Z-ADD     WrkAPDT       APDT                                  236705 234440
     c**********         ENDIF                                                         236705 234440
      *****************************************************************                236758 234440
     C**********         CALLB     'SEVCSPI'                                           236758 234440
     C**********         PARM      A_CHTP        WAction           1                   236758 234440
     C**********         PARM      TDBA          WBrca                                 236758 234440
     C**********         PARM      TCNR          WCust                                 236758 234440
     C**********         PARM      TDSS          WSesn                                 236758 234440
     C**********         PARM      TDTP          WType                                 236758 234440
     C**********         PARM      NOML          WAmt                                  236758 234440
     C**********         PARM      ITRA          WPInt            11 0                 236758 234440
     C**********         PARM                    WrkCSPI                               236758 234440
     C**********         Z-ADD     WrkCSPI       CSPI                                  236758 234440
     C**********         ENDIF                                                         236705 234440
     C*
     C                   UPDATE    CPOSNDF
     C                   END
     C*
     C                   END
     C*
     C* If trade changed/amended, only update file if key or countervalue
     C* changed, except if trade made complete
     C*
     C     A_CHTP        IFEQ      'C'
     C     B_TINC        ANDEQ     'C'
     C     A_CHTP        OREQ      'A'
     C     B_TINC        ANDEQ     'C'
     C*
     C* Purchase
     C*
     C     TDTP          IFEQ      'TP'
     C     TDSS          IFEQ      B_TDSS
     C     TDBA          ANDEQ     B_TDBA
     C     TCNR          ANDEQ     B_TCNR
     C     TDMI          ANDEQ     B_TDMI
     C     DELF          ANDEQ     B_DELF
     C     TCTR          ANDEQ     B_TCTR
     C     TDVD          ANDEQ     B_TDVD
     C     TDDT          ANDEQ     B_TDDT
     C     AUTS          ANDEQ     B_AUTS
     C                   GOTO      WCPCHG
     C                   END
     C*
     C                   ELSE
     C*
     C* Sale
     C*
     C     TDSS          IFEQ      B_TDSS
     C     TDBA          ANDEQ     B_TDBA
     C     TCNR          ANDEQ     B_TCNR
     C     TDMI          ANDEQ     B_TDMI
     C     DELT          ANDEQ     B_DELT
     C     TCTR          ANDEQ     B_TCTR
     C     TDVD          ANDEQ     B_TDVD
     C     TDDT          ANDEQ     B_TDDT
     C     AUTS          ANDEQ     B_AUTS
     C                   GOTO      WCPCHG
     C                   END
     C*
     C                   END
     C                   END
     C*
     C*  Access CDEPP client depot positions
     C*
     C                   MOVEL     TDBA          CDPA
     C                   MOVEL     TDSS          CDSN
     C                   MOVEL     TDMI          CDMK
     C                   MOVEL     TCNR          CDCN
     C     TDTP          IFEQ      'TP'
     C                   MOVEL     DELF          CDPT
     C                   ELSE
     C                   MOVEL     DELT          CDPT
     C                   END
     C     KLCDEP        CHAIN     CDEPPDF                            44
     C                   Z-ADD     NATN          TNLU
     C*
     C*  Update CDEPP client depot positions
     C*
     C     *IN44         IFEQ      '1'
     C     TDVD          IFLE      BJRDNB
     C                   Z-ADD     TDVD          DDTE
     C                   ELSE
     C                   Z-ADD     TDDT          DDTE
     C                   END
     C                   MOVE      'D'           RECI
     C                   Z-ADD     *ZEROS        CECN
     C                   Z-ADD     *ZEROS        CDNT
     C                   Z-ADD     *ZEROS        CDNV
     C                   Z-ADD     *ZEROS        CDNS
     C                   Z-ADD     *ZEROS        SNPT
     C                   Z-ADD     *ZEROS        SAPP
     C                   Z-ADD     *ZEROS        CDST
     C                   Z-ADD     *ZEROS        SAPS
     C                   Z-ADD     *ZEROS        CNPV
     C                   Z-ADD     *ZEROS        SAPV
     C                   Z-ADD     *ZEROS        CNSV
     C                   Z-ADD     *ZEROS        SPSV
     C                   Z-ADD     *ZEROS        CNSI                                    S01176
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   Z-ADD     *ZEROS        CPCH                                         CGL031
     C**********         Z-ADD     *ZEROS        AFPT                                  CGL031 233566
     C**********         Z-ADD     *ZEROS        AFPV                                  CGL031 233566
     C                   Z-ADD     *ZEROS        SAFP                                         233566
     C                   Z-ADD     *ZEROS        SAFS                                         233566
     C                   Z-ADD     *ZEROS        SAPD                                         233566
     c                   ENDIF                                                                CGL031
      *                                                                                       235453
      *   Set TYP_OF_ACT to Action Code.                                                      235453
     C                   MOVE      A_CHTP        TYP_OF_ACT                                   235453
     C                   EXSR      CCLPOS
     C                   WRITE     CDEPPDF
     C                   ADD       1             CD_NOR
     C*
     C                   ELSE
     C*
      *   Set TYP_OF_ACT to Action Code.                                                      235453
     C                   MOVE      A_CHTP        TYP_OF_ACT                                   235453
     C                   EXSR      CCLPOS
     C*
     C     A_CHTP        IFEQ      'D'
     C     AUTS          ANDEQ     'N'
     C     TDVD          ANDLE     BJRDNB
     C     TNSN          ADD       TNSP          NOM_SET
     C     TDTP          IFEQ      'TP'
     C                   ADD       NOM_SET       CNSI
     C                   ELSE
     C                   SUB       NOM_SET       CNSI
     C                   END
     C                   END
     C*
     C                   UPDATE    CDEPPDF
     C*
     C                   END
     C*
     C     WCPCHG        TAG                                                    *** WCPCHG ****
     C*
     C*  If amendment and CDEPP key or countervalue details changed,
     C*                                      cancel original details
     C*                - not if trade made complete
     C*
     C     A_CHTP        IFEQ      'A'
     C     B_TINC        ANDEQ     'C'
     C     A_CHTP        OREQ      'C'
     C     B_TINC        ANDEQ     'C'
     C*
     C*  For purchase type:
     C*
     C     TDTP          IFEQ      'TP'
     C     TDSS          IFNE      B_TDSS
     C     TDBA          ORNE      B_TDBA
     C     TCNR          ORNE      B_TCNR
     C     TDMI          ORNE      B_TDMI
     C     DELF          ORNE      B_DELF
     C     TCTR          ORNE      B_TCTR
     C     TDDT          ORNE      B_TDDT
     C     TDVD          ORNE      B_TDVD
     C     AUTS          ORNE      B_AUTS
     C     B_TNSN        ORNE      0
     C     B_TNSP        ORNE      0
     C*
     C*  Access CDEPP client depot positions
     C*
     C                   MOVEL     B_TDBA        CDPA
     C                   MOVEL     B_TDSS        CDSN
     C                   MOVEL     B_TDMI        CDMK
     C                   MOVEL     B_TCNR        CDCN
     C                   MOVEL     B_DELF        CDPT
     C     KLCDEP        CHAIN     CDEPPDF                            44
     C*
     C     TDSS          IFNE      B_TDSS
     C     TDBA          ORNE      B_TDBA
     C     TCNR          ORNE      B_TCNR
     C     TDMI          ORNE      B_TDMI
     C     DELT          ORNE      B_DELT
     C     TCTR          ORNE      B_TCTR
     C     TDDT          ORNE      B_TDDT
     C     TDVD          ORNE      B_TDVD
     C     AUTS          ORNE      B_AUTS
     C                   Z-ADD     B_NOML        NOML
     C                   Z-ADD     B_PRIC        PRIC
     C                   Z-ADD     B_RALL        RALL
     C                   Z-ADD     B_TCA1        TCA1
     C                   Z-ADD     B_TCA2        TCA2
     C                   Z-ADD     B_TCA3        TCA3
     C                   Z-ADD     B_TCA4        TCA4
     C                   Z-ADD     B_TCA5        TCA5
     C                   Z-ADD     B_TCA6        TCA6
     C                   Z-ADD     B_TCA7        TCA7
     C                   Z-ADD     B_TBCA        TBCA
     C                   Z-ADD     B_TCCA        TCCA
     C                   Z-ADD     B_TCFC        TCFC
     C                   MOVE      B_AUTS        AUTS
     C                   Z-ADD     B_TDVD        TDVD
     C*
     C                   MOVE      'D'           TYP_OF_ACT
     C                   EXSR      CCLPOS
     C*
     C                   END
     C*
     C     B_TNSN        IFNE      0
     C     B_TNSP        ORNE      0
     C     B_TNSN        ADD       B_TNSP        NOM_SET
     C                   ADD       NOM_SET       CNSI
     C                   END
     C*
     C*  Update CDEPP client depot positions
     C*
     C     *IN44         IFEQ      '0'
     C                   UPDATE    CDEPPDF
     C                   END
     C                   END
     C*
     C                   ELSE
     C*
     C*  For sale type:
     C*
     C     TDSS          IFNE      B_TDSS
     C     TDBA          ORNE      B_TDBA
     C     TCNR          ORNE      B_TCNR
     C     TDMI          ORNE      B_TDMI
     C     DELT          ORNE      B_DELT
     C     TCTR          ORNE      B_TCTR
     C     TDDT          ORNE      B_TDDT
     C     TDVD          ORNE      B_TDVD
     C     AUTS          ORNE      B_AUTS
     C     B_TNSN        ORNE      0
     C     B_TNSP        ORNE      0
     C*
     C*  Access CDEPP client depot positions
     C*
     C                   MOVEL     B_TDBA        CDPA
     C                   MOVEL     B_TDSS        CDSN
     C                   MOVEL     B_TDMI        CDMK
     C                   MOVEL     B_TCNR        CDCN
     C                   MOVEL     B_DELT        CDPT
     C     KLCDEP        CHAIN     CDEPPDF                            44
     C*
     C     TDSS          IFNE      B_TDSS
     C     TDBA          ORNE      B_TDBA
     C     TCNR          ORNE      B_TCNR
     C     TDMI          ORNE      B_TDMI
     C     DELF          ORNE      B_DELF
     C     TCTR          ORNE      B_TCTR
     C     TDDT          ORNE      B_TDDT
     C     TDVD          ORNE      B_TDVD
     C     AUTS          ORNE      B_AUTS
     C                   Z-ADD     B_NOML        NOML
     C                   Z-ADD     B_PRIC        PRIC
     C                   Z-ADD     B_RALL        RALL
     C                   Z-ADD     B_TCA1        TCA1
     C                   Z-ADD     B_TCA2        TCA2
     C                   Z-ADD     B_TCA3        TCA3
     C                   Z-ADD     B_TCA4        TCA4
     C                   Z-ADD     B_TCA5        TCA5
     C                   Z-ADD     B_TCA6        TCA6
     C                   Z-ADD     B_TCA7        TCA7
     C                   Z-ADD     B_TBCA        TBCA
     C                   Z-ADD     B_TCCA        TCCA
     C                   Z-ADD     B_TCFC        TCFC
     C                   MOVE      B_AUTS        AUTS
     C                   Z-ADD     B_TDVD        TDVD
     C                   MOVE      'D'           TYP_OF_ACT
     C*
     C                   EXSR      CCLPOS
     C*
     C                   END
     C*
     C     B_TNSN        IFNE      0
     C     B_TNSP        ORNE      0
     C     B_TNSN        ADD       B_TNSP        NOM_SET
     C                   SUB       NOM_SET       CNSI
     C                   END
     C*
     C*  Update CDEPP client depot positions
     C*
     C     *IN44         IFEQ      '0'
     C                   UPDATE    CDEPPDF
     C                   END
     C*
     C                   END
     C                   END
     C*
     C*  Reset current trade details
     C*
     C                   If        Z#ASTS = *Blanks                                         BUG14514
     C                   Clear                   TRADSF                                     BUG14514
     C                   Else                                                               BUG14514
     C                   MOVEL     Z#ASTS        TRADSF
     C                   EndIf                                                              BUG14514
      *****************************************************************                236758 234440
     C**********         ELSE                                                          236758 234440
      *****************************************************************                236758 234440
      ***Access*CPOSN*client*position**********************************                236758 234440
      *****************************************************************                236758 234440
     C*****CGL031        IFEQ      'Y'                                                 236758 234440
     C**********         MOVEL     TDBA          CSBA                                  236758 234440
     C**********         MOVEL     TDSS          CSSC                                  236758 234440
     C**********         MOVEL     TCNR          CSCN                                  236758 234440
     C*****KLPOSN        CHAIN     CPOSNDF                            44               236758 234440
     C**********                                                                       236758 234440
     C***Update*CPOSN*client*position**********************************                236758 234440
     C**********                                                                       236758 234440
     C**********         Z-ADD     NATN          TNLU                                  236758 234440
     C**********                                                                       236758 234440
     C******IN44         IFNE      '1'                                                 236758 234440
      **********                                                                       236758 234440
     C**********         CALLB     'SEVCSPI'                                           236758 234440
     C**********         PARM      A_CHTP        WAction           1                   236758 234440
     C**********         PARM      TDBA          WBrca                                 236758 234440
     C**********         PARM      TCNR          WCust                                 236758 234440
     C**********         PARM      TDSS          WSesn                                 236758 234440
     C**********         PARM      TDTP          WType                                 236758 234440
     C**********         PARM      NOML          WAmt                                  236758 234440
     C**********         PARM      ITRA          WPInt            11 0                 236758 234440
     C**********         PARM                    WrkCSPI                               236758 234440
     C**********         Z-ADD     WrkCSPI       CSPI                                  236758 234440
     C**********                                                                       236758 234440
     C**********         UPDATE    CPOSNDF                                             236758 234440
     C**********                                                                       236758 234440
     C**********         ENDIF                                                         236758 234440
     C**********         ENDIF                                                         236758 234440
     C*
     C                   END
                                                                                              234440
     C                   IF        CGL031 = 'Y'                                               234440
     C*                                                                                       235546
     C* check if value date has changed and ensure that earlier value date                    235546
     C* is used                                                                               235546
     C     A_CHTP        IFEQ      'A'                                                        235546
     C     A_CHTP        OREQ      'C'                                                        235546
     C     TDVD          IFLT      B_TDVD                                                     235546
     C                   Z-ADD     TDVD          PTDVD             5 0                        235546
     C                   ELSE                                                                 235546
     C                   Z-ADD     B_TDVD        PTDVD                                        235546
     C                   ENDIF                                                                235546
     C                   ELSE                                                                 235546
     C                   Z-ADD     TDVD          PTDVD                                        235546
     C                   ENDIF                                                                235546
     C*                                                                                       235546
     C* delete all records on ETCPOSND after the date/timestamp            i                  235546
     C*                                                                                       235546
     C                   CALL      'SE006670'                                                 235546
     C                   PARM      A_CHTP        Actn_Code                                    235546
     C                   PARM      'T'           Tr_Type                                      235546
     C                   PARM                    SEVTRD                                       235546
     C                   PARM                    SEVDPM                                       235546
     C                   PARM                    SECTYF                                       235546
     C                   PARM                    PTDVD                                        235546
     C*                                                                                       235546
     C* if value date on trade has not changed to be later, then process                      235546
     C* this trade now                                                                        235546
     C*                                                                                       235546
     C     A_CHTP        IFEQ      'I'                                                        235546
     C     A_CHTP        OREQ      'D'                                                        235546
     C     A_CHTP        OREQ      'A'                                                        235546
     C     TDVD          ANDLE     B_TDVD                                                     235546
     C     A_CHTP        OREQ      'C'                                                        235546
     C     TDVD          ANDLE     B_TDVD                                                     235546
     C                   Z-ADD     0             PTDVD                                        235546
     C                   CALL      'SEETCPUPD'                                                234440
     C                   PARM                    RetCodeIn                                    234440
     C                   PARM      A_CHTP        Actn_Code         1                          234440
     C                   PARM      'T'           Tr_Type           1                          234440
     C                   PARM                    SEVTRD                                       234440
     C                   PARM                    SEVDPM                                       234440
     C                   PARM                    SECTYF                                       234440
     C*                                                                                       235546
     C* Re-process all the other trades/depot movements after this date.                      235546
     C*                                                                                       235546
     C                   CALL      'SE006680'                                                 235546
     C                   PARM      'T'           Tr_Type                                      235546
     C                   PARM                    SECTYF                                       235546
     C                   PARM                    PROT                                         235546
     C                   PARM                    CustClass                                    235546
     C                   PARM                    NomCcyDec                                    235546
     C                   PARM                    CSE023                                       235546
     C                   PARM                    PTDVD                                        235546
     C                   PARM                    PTMST                                        235546
     C                   ELSE                                                                 235546
     C*                                                                                       235546
     C* If trade has changed to make value date later, then re-process                        235546
     C* trades/depot movements up to this date/time                                           235546
     C*                                                                                       235546
     C                   Z-ADD     TDVD          PTDVD                                        235546
     C                   EVAL      PTMST = TMST                                 CAP006        235546
     C                   CALL      'SE006680'                                                 235546
     C                   PARM      'T'           Tr_Type                                      235546
     C                   PARM                    SECTYF                                       235546
     C                   PARM                    PROT                                         235546
     C                   PARM                    CustClass                                    235546
     C                   PARM                    NomCcyDec                                    235546
     C                   PARM                    CSE023                                       235546
     C                   PARM                    PTDVD                                        235546
     C                   PARM                    PTMST                                        235546
     C*                                                                                       235546
     C* Now process changed trade                                                             235546
     C*                                                                                       235546
     C                   CALL      'SEETCPUPD'                                                235546
     C                   PARM                    RetCodeIn                                    235546
     C                   PARM      A_CHTP        Actn_Code         1                          235546
     C                   PARM      'T'           Tr_Type           1                          235546
     C                   PARM                    SEVTRD                                       235546
     C                   PARM                    SEVDPM                                       235546
     C                   PARM                    SECTYF                                       235546
     C*                                                                                       235546
     C* Now re-process all the other trades/depot movements after the date                    235546
     C* of this changed trade                                                                 235546
     C*                                                                                       235546
     C                   Z-ADD     0             PTDVD                                        235546
     C                   CALL      'SE006680'                                                 235546
     C                   PARM      'T'           Tr_Type                                      235546
     C                   PARM                    SECTYF                                       235546
     C                   PARM                    PROT                                         235546
     C                   PARM                    CustClass                                    235546
     C                   PARM                    NomCcyDec                                    235546
     C                   PARM                    CSE023                                       235546
     C                   PARM                    PTDVD                                        235546
     C                   PARM                    PTMST                                        235546
     C                   ENDIF                                                                235546
                                                                                              234440
     C                   ENDIF                                                                234440
     C*
     C     WCPEND        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CCLPOS - Subroutine to calculate the latest Client Positions.*
      *                                                               *
      *****************************************************************
     C     CCLPOS        BEGSR
      *
      *  Calculate consideration
      *
     C                   Z-ADD     NOML          ZNOML
     C                   Z-ADD     PRIC          ZPRC
     C                   EXSR      ZCNSD
     C                   Z-ADD     ZCONS         W#CONS
     C     PROT          IFEQ      '8'
     C                   MULT      TCFC          W#CONS
     C                   END
      *
      *  Calculate reallowance
      *
     C                   Z-ADD     *ZEROS        W#RALL
     C     BVRCAP        IFEQ      'Y'
     C                   EXSR      CALEFRALL
     C                   Z-ADD     NOML          ZNOML
     C                   Z-ADD     EFF_RALL      ZPRC
     C                   EXSR      ZCNSD
     C                   Z-ADD     ZCONS         W#RALL
     C                   END
      *
      *  Calculate charges/commission
      *
     C                   Z-ADD     *ZEROS        W#CHRG
     C     BVCCAP        IFEQ      'Y'
     C     TCA1          ADD       TCA2          W#CHRG
     C                   ADD       TCA3          W#CHRG
     C                   ADD       TCA4          W#CHRG
     C                   ADD       TCA5          W#CHRG
     C                   ADD       TCA6          W#CHRG
     C                   ADD       TCA7          W#CHRG
     C                   END
      *
     C                   Z-ADD     *ZEROS        W#COMM
     C     BVCMCP        IFEQ      'Y'
     C     TBCA          ADD       TCCA          W#COMM
     C                   END
      *
      ***  Update Sum Nominals (I/C) / Sum A P Numerators on Date Basis
      *
      *   Trade date basis :-
      *
      *   Insert/amendment(purchase)
      *
     C     TDTP          IFEQ      'TP'
     C     TYP_OF_ACT    IFNE      'D'                                          I-TP-T
     C*
     C                   SUB       NOML          SNPT
     C*
     C                   ADD       W#CONS        SAPP
     C                   ADD       W#RALL        SAPP
     C                   SUB       W#CHRG        SAPP
     C                   SUB       W#COMM        SAPP
     C*
     C                   ELSE                                                   C-TP-T
     C*
     C*  Deletion(purchase)
     C*
     C                   ADD       NOML          SNPT
     C*
     C                   SUB       W#CONS        SAPP
     C                   SUB       W#RALL        SAPP
     C                   ADD       W#CHRG        SAPP
     C                   ADD       W#COMM        SAPP
     C*
     C                   END
     C*
     C                   ELSE
     C*
     C*   Insert/amend(sale)
     C*
     C     TYP_OF_ACT    IFNE      'D'                                          I-TS-T
     C*
     C                   ADD       NOML          CDST
     C*
     C                   ADD       W#CONS        SAPS
     C                   ADD       W#RALL        SAPS
     C                   ADD       W#CHRG        SAPS
     C                   ADD       W#COMM        SAPS
     C*
     C                   ELSE                                                   C-TS-T
     C*
     C*  Deletion(sale)
     C*
     C                   SUB       NOML          CDST
     C*
     C                   SUB       W#CONS        SAPS
     C                   SUB       W#RALL        SAPS
     C                   SUB       W#CHRG        SAPS
     C                   SUB       W#COMM        SAPS
     C*
     C                   END
     C                   END
     C*
     C*   Value date basis :-
     C*
     C*****TDVD          IFLE      BJRDNB                                                     196449
     C*****TDVD          IFLT      BJRDNB                                              196449 227015
     C     TDVD          IFLE      BJRDNB                                                     227015
     C*
     C*   Insert/amendment(purchase)
     C*
     C     TDTP          IFEQ      'TP'
     C     TYP_OF_ACT    IFNE      'D'                                          I-TP-V
     C*
     C                   SUB       NOML          CNPV
     C*
     C                   ADD       W#CONS        SAPV
     C                   ADD       W#RALL        SAPV
     C                   SUB       W#CHRG        SAPV
     C                   SUB       W#COMM        SAPV
     C*
     C                   ELSE                                                   C-TP-V
     C*
     C*  Deletion(purchase)
     C*
     C                   ADD       NOML          CNPV
     C*
     C                   SUB       W#CONS        SAPV
     C                   SUB       W#RALL        SAPV
     C                   ADD       W#CHRG        SAPV
     C                   ADD       W#COMM        SAPV
     C*
     C                   END
     C*
     C                   ELSE
     C*
     C*   Insert/amend(sale)
     C*
     C     TYP_OF_ACT    IFNE      'D'                                          I-TS-V
     C*
     C                   ADD       NOML          CNSV
     C*
     C                   ADD       W#CONS        SPSV
     C                   ADD       W#RALL        SPSV
     C                   ADD       W#CHRG        SPSV
     C                   ADD       W#COMM        SPSV
     C*
     C                   ELSE                                                   C-TS-V
     C*
     C*  Deletion(sale)
     C*
     C                   SUB       NOML          CNSV
     C*
     C                   SUB       W#CONS        SPSV
     C                   SUB       W#RALL        SPSV
     C                   SUB       W#CHRG        SPSV
     C                   SUB       W#COMM        SPSV
     C*
     C                   END
     C                   END
     C                   END
     C*
      ***  If Auto-Settlement and not Forward Valued, update Nominal
      ***  Settlted (I/C).
      *
     C     AUTS          IFEQ      'Y'
     C     TDVD          ANDLE     BJRDNB
     C*
     C     TYP_OF_ACT    IFNE      'D'
     C     TDTP          IFEQ      'TP'
     C                   SUB       NOML          CNSI
     C                   END
     C     TDTP          IFEQ      'TS'
     C                   ADD       NOML          CNSI
     C                   END
     C                   ELSE
     C     TDTP          IFEQ      'TP'
     C                   ADD       NOML          CNSI
     C                   END
     C     TDTP          IFEQ      'TS'
     C                   SUB       NOML          CNSI
     C                   END
     C                   END
     C                   END
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  WUDEPP - Subroutine to Update User Depot Positions.          *
      *                                                               *
      *****************************************************************
     C     WUDEPP        BEGSR
     C*
     C                   Z-ADD     *ZEROS        UDTP
     C                   Z-ADD     *ZEROS        UDPV
     C                   Z-ADD     *ZEROS        UDTS
     C                   Z-ADD     *ZEROS        UDSV
     C*
     C* If trade changed/amended, only update file if key or nominal
     C* changed, except if trade is complete.
     C*
     C     A_CHTP        IFEQ      'C'
     C     B_TINC        ANDEQ     'C'
     C     A_CHTP        OREQ      'A'
     C     B_TINC        ANDEQ     'C'
     C*
     C* Purchase
     C*
     C     TDTP          IFEQ      'TP'
     C     TDSS          IFEQ      B_TDSS
     C     TDBA          ANDEQ     B_TDBA
     C     TDBK          ANDEQ     B_TDBK
     C     TDMI          ANDEQ     B_TDMI
     C     DELT          ANDEQ     B_DELT
     C     NOML          ANDEQ     B_NOML
     C     TDVD          ANDEQ     B_TDVD
     C     TDDT          ANDEQ     B_TDDT
     C     AUTS          ANDEQ     B_AUTS
     C                   GOTO      WUPCHG
     C                   END
     C*
     C                   ELSE
     C*
     C* Sale
     C*
     C     TDSS          IFEQ      B_TDSS
     C     TDBA          ANDEQ     B_TDBA
     C     TDBK          ANDEQ     B_TDBK
     C     TDMI          ANDEQ     B_TDMI
     C     DELF          ANDEQ     B_DELF
     C     NOML          ANDEQ     B_NOML
     C     TDVD          ANDEQ     B_TDVD
     C     TDDT          ANDEQ     B_TDDT
     C     AUTS          ANDEQ     B_AUTS
     C                   GOTO      WUPCHG
     C                   END
     C*
     C                   END
     C                   END
     C*
     C*  FIRST DO INSERT/CANCEL WITH NEW DETAILS
     C*  Action code I is insert new
     C*  Action code D is Cancel new
     C*  Action codes A & C are same as Insert new + Cancel old
     C*
     C*  For purchase type:
     C*
     C     TDTP          IFEQ      'TP'
     C*
     C*  Access UDEPP User depot positions
     C*
     C                   MOVEL     TDBA          UDBA
     C                   MOVEL     TDSS          UDSN
     C                   MOVEL     TDMI          UDMK
     C                   MOVEL     TDBK          UDBK
     C                   MOVEL     DELT          UDPT
     C     KLUDEP        CHAIN     UDEPPDF                            44
     C*
     C** ZERO NOMINAL FIELDS IF CHAIN HAS FAILED
     C*
     C     *IN44         IFEQ      '1'
     C                   Z-ADD     0             UNSI
     C                   Z-ADD     0             UDTP
     C                   Z-ADD     0             UDPV
     C                   END
     C*
     C*  Update UDEPP User depot positions
     C*
     C                   Z-ADD     NATN          TNLU
     C*
     C*  Trade date basis :-
     C*
     C     A_CHTP        IFNE      'D'
     C                   ADD       NOML          UDTP                           I-TP-T-N
     C                   ELSE
     C                   SUB       NOML          UDTP                           C-TP-T-N
     C                   END
     C*
     C*  Value date basis :-
     C*
     C     TDVD          IFLE      BJRDNB
     C     A_CHTP        IFNE      'D'
     C                   ADD       NOML          UDPV
     C                   ELSE
     C                   SUB       NOML          UDPV
     C                   END
     C                   END
     C*
     C*   Update Nominal Settled, Input Cycle (UNSI)
     C*
     C     AUTS          IFEQ      'Y'
     C     TDVD          ANDLE     BJRDNB
     C*
     C     A_CHTP        IFNE      'D'
     C                   ADD       NOML          UNSI
     C                   ELSE
     C                   SUB       NOML          UNSI
     C                   END
     C*
     C                   END
     C*
     C     A_CHTP        IFEQ      'D'
     C     AUTS          ANDEQ     'N'
     C     TDVD          ANDLE     BJRDNB
     C     TNSN          ADD       TNSP          NOM_SET
     C                   SUB       NOM_SET       UNSI
     C                   END
     C*
     C     *IN44         IFEQ      '1'
     C                   MOVE      'D'           RECI
     C     TDVD          IFLE      BJRDNB
     C                   Z-ADD     TDVD          UDDT
     C                   Z-ADD     TDVD          DDTE
     C                   ELSE
     C                   Z-ADD     TDDT          UDDT
     C                   Z-ADD     TDDT          DDTE
     C                   END
     C                   Z-ADD     *ZEROS        UECN
     C                   Z-ADD     *ZEROS        UDNT
     C                   Z-ADD     *ZEROS        UDNV
     C                   Z-ADD     *ZEROS        UDNS
     C                   Z-ADD     *ZEROS        UDTS
     C                   Z-ADD     *ZEROS        UDSV
     C                   Z-ADD     *ZEROS        UNRT
     C                   Z-ADD     *ZEROS        UNRV
     C                   Z-ADD     *ZEROS        USNT
     C                   Z-ADD     *ZEROS        USNR
     C                   Z-ADD     *ZEROS        USNV
     C                   Z-ADD     *ZEROS        USRV
     C                   WRITE     UDEPPDF
     C                   ADD       1             UD_NOR
     C*
     C                   ELSE
     C*
     C                   UPDATE    UDEPPDF
     C                   END
     C*
     C                   ELSE
     C*
     C*  For sale type:
     C*
     C*  Access UDEPP User depot positions
     C*
     C                   MOVEL     TDBA          UDBA
     C                   MOVEL     TDSS          UDSN
     C                   MOVEL     TDMI          UDMK
     C                   MOVEL     TDBK          UDBK
     C                   MOVEL     DELF          UDPT
     C     KLUDEP        CHAIN     UDEPPDF                            44
     C*
     C** ZERO NOMINAL FIELDS IF CHAIN HAS FAILED
     C*
     C     *IN44         IFEQ      '1'
     C                   Z-ADD     0             UNSI
     C                   Z-ADD     0             UDTS
     C                   Z-ADD     0             UDSV
     C                   END
     C*
     C*  Update UDEPP User depot positions
     C*
     C                   Z-ADD     NATN          TNLU
     C*
     C*  Trade date basis :-
     C*
     C     A_CHTP        IFNE      'D'
     C                   SUB       NOML          UDTS                           I-TS-T-N
     C                   ELSE
     C                   ADD       NOML          UDTS                           C-TS-T-N
     C                   END
     C*
     C*  Value date basis :-
     C*
     C     TDVD          IFLE      BJRDNB
     C     A_CHTP        IFNE      'D'
     C                   SUB       NOML          UDSV
     C                   ELSE
     C                   ADD       NOML          UDSV
     C                   END
     C                   END
     C*
     C*   Update Nominal Settled, Input Cycle (UNSI)
     C*
     C     AUTS          IFEQ      'Y'
     C     TDVD          ANDLE     BJRDNB
     C*
     C     A_CHTP        IFNE      'D'
     C                   SUB       NOML          UNSI
     C                   ELSE
     C                   ADD       NOML          UNSI
     C                   END
     C*
     C                   END
     C*
     C     A_CHTP        IFEQ      'D'
     C     AUTS          ANDEQ     'N'
     C     TDVD          ANDLE     BJRDNB
     C     TNSN          ADD       TNSP          NOM_SET
     C                   ADD       NOM_SET       UNSI
     C                   END
     C*
     C     *IN44         IFEQ      '1'
     C                   MOVE      'D'           RECI
     C     TDVD          IFLE      BJRDNB
     C                   Z-ADD     TDVD          UDDT
     C                   Z-ADD     TDVD          DDTE
     C                   ELSE
     C                   Z-ADD     TDDT          UDDT
     C                   Z-ADD     TDDT          DDTE
     C                   END
     C                   Z-ADD     *ZEROS        UDNT
     C                   Z-ADD     *ZEROS        UDNV
     C                   Z-ADD     *ZEROS        UDNS
     C                   Z-ADD     *ZEROS        UECN
     C                   Z-ADD     *ZEROS        UDTP
     C                   Z-ADD     *ZEROS        UDPV
     C                   Z-ADD     *ZEROS        UNRT
     C                   Z-ADD     *ZEROS        UNRV
     C                   Z-ADD     *ZEROS        USNT
     C                   Z-ADD     *ZEROS        USNR
     C                   Z-ADD     *ZEROS        USNV
     C                   Z-ADD     *ZEROS        USRV
     C                   WRITE     UDEPPDF
     C                   ADD       1             UD_NOR
     C*
     C                   ELSE
     C*
     C                   UPDATE    UDEPPDF
     C                   END
     C                   END
     C*
     C     WUPCHG        TAG                                                    *** WUPCHG ****
     C*
     C*  If amendment and UDEPP key or nominal changed,
     C*  and trade was already settled       cancel original details
     C*
     C     A_CHTP        IFEQ      'A'
     C     B_TINC        ANDEQ     'C'
     C     A_CHTP        OREQ      'C'
     C     B_TINC        ANDEQ     'C'
     C*
     C*  For purchase type:
     C*
     C     TDTP          IFEQ      'TP'
     C     TDSS          IFNE      B_TDSS
     C     TDBA          ORNE      B_TDBA
     C     TDBK          ORNE      B_TDBK
     C     TDMI          ORNE      B_TDMI
     C     DELT          ORNE      B_DELT
     C     NOML          ORNE      B_NOML
     C     TDVD          ORNE      B_TDVD
     C     TDDT          ORNE      B_TDDT
     C     AUTS          ORNE      B_AUTS
     C     B_TNSN        ORNE      0
     C     B_TNSP        ORNE      0
     C*
     C*  Access UDEPP User depot positions
     C*
     C                   MOVEL     B_TDBA        UDBA
     C                   MOVEL     B_TDSS        UDSN
     C                   MOVEL     B_TDMI        UDMK
     C                   MOVEL     B_TDBK        UDBK
     C                   MOVEL     B_DELT        UDPT
     C     KLUDEP        CHAIN     UDEPPDF                            44
     C*
     C     TDSS          IFNE      B_TDSS
     C     TDBA          ORNE      B_TDBA
     C     TDBK          ORNE      B_TDBK
     C     TDMI          ORNE      B_TDMI
     C     DELT          ORNE      B_DELT
     C     NOML          ORNE      B_NOML
     C     TDVD          ORNE      B_TDVD
     C     TDDT          ORNE      B_TDDT
     C     AUTS          ORNE      B_AUTS
     C*
     C                   SUB       B_NOML        UDTP                           C-TP-T-O
     C     B_TDVD        IFLE      BJRDNB
     C                   SUB       B_NOML        UDPV
     C                   END
     C*
     C*   Update Nominal Settled, Input Cycle (UNSI)
     C*
     C     B_AUTS        IFEQ      'Y'
     C     B_TDVD        ANDLE     BJRDNB
     C                   SUB       B_NOML        UNSI
     C                   END
     C*
     C                   END
     C*
     C     B_TNSN        IFNE      0
     C     B_TNSP        ORNE      0
     C     B_TNSN        ADD       B_TNSP        NOM_SET          11 0
     C                   SUB       NOM_SET       UNSI
     C                   END
     C*
     C*  Update UDEPP User depot positions
     C*
     C     *IN44         IFEQ      '0'
     C*
     C                   UPDATE    UDEPPDF
     C*
     C                   END
     C                   END
     C*
     C                   ELSE
     C*  For sale type :
     C*
     C     TDSS          IFNE      B_TDSS
     C     TDBA          ORNE      B_TDBA
     C     TDBK          ORNE      B_TDBK
     C     TDMI          ORNE      B_TDMI
     C     DELF          ORNE      B_DELF
     C     NOML          ORNE      B_NOML
     C     TDVD          ORNE      B_TDVD
     C     TDDT          ORNE      B_TDDT
     C     AUTS          ORNE      B_AUTS
     C     B_TNSN        ORNE      0
     C     B_TNSP        ORNE      0
     C*
     C*  Access UDEPP User depot positions
     C*
     C                   MOVEL     B_TDBA        UDBA
     C                   MOVEL     B_TDSS        UDSN
     C                   MOVEL     B_TDMI        UDMK
     C                   MOVEL     B_TDBK        UDBK
     C                   MOVEL     B_DELF        UDPT
     C     KLUDEP        CHAIN     UDEPPDF                            44
     C*
     C     TDSS          IFNE      B_TDSS
     C     TDBA          ORNE      B_TDBA
     C     TDBK          ORNE      B_TDBK
     C     TDMI          ORNE      B_TDMI
     C     DELF          ORNE      B_DELF
     C     NOML          ORNE      B_NOML
     C     TDVD          ORNE      B_TDVD
     C     TDDT          ORNE      B_TDDT
     C     AUTS          ORNE      B_AUTS
     C*
     C                   ADD       B_NOML        UDTS                           C-TS-T-O
     C     B_TDVD        IFLE      BJRDNB
     C                   ADD       B_NOML        UDSV
     C                   END
     C*
     C*   Update Nominal Settled, Input Cycle (UNSI)
     C*
     C     B_AUTS        IFEQ      'Y'
     C     B_TDVD        ANDLE     BJRDNB
     C                   ADD       B_NOML        UNSI
     C                   END
     C*
     C                   END
     C*
     C     B_TNSN        IFNE      0
     C     B_TNSP        ORNE      0
     C     B_TNSN        ADD       B_TNSP        NOM_SET
     C                   ADD       NOM_SET       UNSI
     C                   END
     C*
     C*  Update UDEPP User depot positions
     C*
     C     *IN44         IFEQ      '0'
     C*
     C                   UPDATE    UDEPPDF
     C*
     C                   END
     C                   END
     C                   END
     C                   END
     C*
     C     WUPEND        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  WSETTL - Subroutine to Update Trade Settlement Details.      *
      *                                                               *
      *****************************************************************
     C     WSETTL        BEGSR
      *
      * Update all settlement records for the trade
      *
     C                   Z-ADD     *ZEROS        W#SCNT            5 0

     C                   MOVE      B_TDBA        SBCA
     C                   MOVE      TDRF          STDR

     C     KLSETT        SETLL     SETLEDF
     C     KLSETT        READE     SETLEDF                                44
      *
      ** Do while records found
      *
     C     *IN44         DOWEQ     '0'
      *
      ** Live settlements only
      *
     C     RECI          IFNE      'C'
     C     RECI          ANDNE     '*'

      ** Distinguish between historic and input today

     C     RECI          IFEQ      'H'
     C                   MOVE      'X'           CHTP
     C                   ELSE
     C                   MOVE      'D'           CHTP
     C                   END

     C     RECI          IFEQ      'D'
     C                   MOVE      '*'           RECI
     C                   ELSE
     C                   MOVE      'C'           RECI
     C                   END

     C                   Z-ADD     BJRDNB        LCD
     C                   ADD       1             W#SCNT
     C                   UPDATE    SETLEDF
     C                   END

     C     KLSETT        READE     SETLEDF                                44

     C                   END
      *
      *  Access SETTL audit record and update
      *
     C     1             CHAIN     SETLEAF                            99
     C     *IN99         IFEQ      '0'
     C                   ADD       W#SCNT        SDEL
     C                   UPDATE    SETLEAF
     C                   ELSE
     C                   MOVEL     'AUDIT'       DBKEY
     C                   MOVEL     'SETLE'       DBFILE
     C                   MOVEL     '800'         DBASE
     C                   EXSR      SRERR
     C                   END
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  WTRAUT - Subroutine to write a record to Trade authorisation file
      *                                                               *
      *****************************************************************
     C     WTRAUT        BEGSR
     C**
     C                   MOVE      'D'           TRAU_RECI
     C** Trade Ref.
     C                   MOVE      TDRF          TRDRF
     C**
     C** Last Action Type
     C     A_CHTP        IFEQ      'I'
     C                   MOVE      'IN'          TATYP
     C                   END
     C     A_CHTP        IFEQ      'A'
     C                   MOVE      'AM'          TATYP
     C                   END
     C     A_CHTP        IFEQ      'C'
     C                   MOVE      'CH'          TATYP
     C                   END
     C     A_CHTP        IFEQ      'D'
     C                   MOVE      'DL'          TATYP
     C                   END
     C     A_CHTP        IFEQ      'P'
     C                   MOVE      'AP'          TATYP
     C                   END
     C     A_CHTP        IFEQ      'Y'
      *                                                                         CAP051
     C     SAVAUTH       ORNE      '00'                                         CAP051
     C     CAP051        ANDEQ     'Y'                                          CAP051
     C     A_AUTH        ANDEQ     'Y'                                          CAP051
      *                                                                         CAP051
     C                   MOVE      'AU'          TATYP
     C                   END
     C** User
     C/COPY WNCPYSRC,SETRADDC15
     C                   MOVE      PSUser        TAUSR
     C/COPY WNCPYSRC,SETRADDC16
     C** Date
     C                   Z-ADD     BJRDNB        TADT
     C** Time
     C                   TIME                    TATM
     C**
     C* File TRAUTD should retain details of the trades previous RECI.                        179084
     C*                                                                                       179084
     C                   MOVE      PREVREC       TDRI                                         179084
     C*                                                                                       179084
     C                   WRITE     TRAUTDF
     C**
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * WPRFC  - Subroutine to update Profit Centre files
      *
      *****************************************************************
     C     WPRFC         BEGSR                                                  ** WPRFC  **
     C*
     C                   Z-ADD     0             PC_REC            1 0
     C*
     C*  find if new book position profit centre
     C*
     C                   MOVEL     TDBK          BOKC
     C                   MOVEL     TDBA          BRCA
     C                   MOVEL     TDSS          SESN
     C                   MOVEL     TDMI          MKTI
     C     KLSPCB        CHAIN     SEPCBD                             44
     C*
     C*  if not found write new record
     C*
     C     *IN44         IFEQ      '1'
     C                   MOVEL     'D'           RECI
     C                   MOVEL     TDBA          BRCA
     C                   MOVEL     TDSS          SESN
     C*
     C     BGN0ST        IFNE      'Y'
     C                   MOVEL     PRFC          PCBK
     C                   ELSE
     C                   MOVE      BPRC          PCBK
     C                   ENDIF
     C*
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVEL     'I'           CHTP
     C                   Z-ADD     NATN          TNLU
     C                   WRITE     SEPCBDF
     C                   ADD       1             PC_REC
     C*
     C*  If found and trade/book position profit centre reconcilable = Y,
     C*  or profit centre accounting, and profit centre is different,
     C*  then DB error
     C*
     C                   ELSE
     C     BVTBRC        IFEQ      'Y'
     C     PRFC          ANDNE     PCBK
     C     BGN0ST        ANDNE     'Y'
     C     BPRC          ORNE      PCBK
     C     BGN0ST        ANDEQ     'Y'
     C                   MOVEL     SESN          DBKEY
     C                   MOVE      BOKC          DBKEY
     C                   MOVEL     'SEPCBD'      DBFILE
     C                   MOVEL     '801'         DBASE
     C                   EXSR      SRERR
     C                   END
     C                   END
     C*
     C*  find if new customer position profit centre, if portfolio
     C*    customer
     C*
     C     CustClass     IFEQ      'S'
     C     CustClass     OREQ      'D'
     C                   MOVEL     TCNR          CNUM
     C                   MOVEL     TDBA          BRCA
     C                   MOVEL     TDSS          SESN
     C     KLSPCC        CHAIN     SEPCCD                             44
     C     *IN44         IFEQ      '1'
     C                   MOVEL     'D'           RECI
     C                   MOVEL     TCNR          CNUM
     C                   MOVEL     TDBA          BRCA
     C                   MOVEL     TDSS          SESN
     C*
     C     BGN0ST        IFNE      'Y'
     C                   MOVEL     PRFC          PCCU
     C                   ELSE
     C                   MOVE      TPRC          PCCU
     C                   ENDIF
     C*
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVEL     'I'           CHTP
     C                   Z-ADD     NATN          TNLU
     C*
     C** Determine value of portfolio reference
     C*
     C     BGN0ST        IFEQ      'Y'
     C     BGPFMG        ANDEQ     'Y'
     C     BGN0ST        OREQ      'Y'                                          CPB001
     C     BGN4ST        ANDEQ     'Y'                                          CPB001
     C*
     C                   MOVE      PTFR          SEPC_PTFR
     C*
     C                   ENDIF
     C*
     C                   WRITE     SEPCCDF
     C                   ADD       1             PC_REC
     C*
     C*  If found and trade/cust position profit centre reconcilable = Y,
     C*  or profit centre accounting, and profit centre is different,
     C*  then DB error
     C*
     C                   ELSE
     C*****BVTBRC        IFEQ      'N'                                          168532
     C*****PRFC          ANDNE     PCBK                                         168532
     C*****BVTBRC        IFEQ      'Y'                                              168532 AR1092084
     C*****BVTBRC        IFEQ      'N'                                            AR1092084 MD020922
     C*****PRFC*         ANDNE     PCCU                                              168532 MD020922
     C*****BGN0ST        ANDNE     'Y'                                                      MD020922
     C*****TPRC*         ORNE      PCCU                                                     MD020922
     C     TPRC          IFNE      PCCU                                                     MD020922
     C     BGN0ST        ANDEQ     'Y'
     C                   MOVEL     SESN          DBKEY
     C                   MOVE      CNUM          DBKEY
     C                   MOVEL     'SEPCCD'      DBFILE
     C                   MOVEL     '802'         DBASE
     C                   EXSR      SRERR
     C                   END
     C                   END
     C                   END
     C*
     C* keep count in audit file
     C*
     C     PC_REC        IFGT      0
     C     1             CHAIN     SEPCA                              44
     C     *IN44         IFEQ      '0'
     C                   ADD       PC_REC        SINS
     C                   ADD       PC_REC        NORE
     C                   UPDATE    SEPCAF
     C                   ELSE
     C                   MOVEL     'AUDIT'       DBKEY
     C                   MOVEL     'SEPCA'       DBFILE
     C                   MOVEL     '803'         DBASE
     C                   EXSR      SRERR
     C                   END
     C                   END
     C*
     C     WPREND        ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  WAUDIT - Subroutine to Update Audit Files.                   *
      *                                                               *
      *****************************************************************
     C     WAUDIT        BEGSR
     C*
     C*  Update Trade audit record
     C*
     C     1             CHAIN     TRADSAF                            99
     C     *IN99         IFEQ      '0'
     C     A_CHTP        IFEQ      'I'
     C                   ADD       1             SINS
     C                   ADD       1             NORE
     C                   ELSE
     C     A_CHTP        IFEQ      'A'
     C                   ADD       1             SAMD
     C                   ELSE
     C     A_CHTP        IFEQ      'C'
     C                   ADD       1             TRDA
     C                   ELSE
     C     A_CHTP        IFEQ      'D'
     C                   ADD       1             SDEL
     C                   END
     C                   END
     C                   END
     C                   END
     C                   UPDATE    TRADSAF
     C                   ELSE
     C                   MOVEL     'AUDIT'       DBKEY
     C                   MOVEL     'TRADS'       DBFILE
     C                   MOVEL     '804'         DBASE
     C                   EXSR      SRERR
     C                   END
     C*
     C*  Update BKPHD audit record
     C*
     C     1             CHAIN     BKPHDAF                            99
     C     *IN99         IFNE      '1'
     C                   ADD       BK_NOR        NORE
     C                   UPDATE    BKPHDAF
     C                   Z-ADD     *ZEROS        BK_NOR            5 0
     C                   ELSE
     C                   MOVEL     'AUDIT'       DBKEY
     C                   MOVEL     'BKPHD'       DBFILE
     C                   MOVEL     '805'         DBASE
     C                   EXSR      SRERR
     C                   END
     C*
     C*  Update BKPOSA audit record
     C*
     C     1             CHAIN     BKPOSAF                            99
     C     *IN99         IFNE      '1'
     C                   ADD       BS_NOR        NORE
     C                   UPDATE    BKPOSAF
     C                   Z-ADD     *ZEROS        BS_NOR            5 0
     C                   ELSE
     C                   MOVEL     'AUDIT'       DBKEY
     C                   MOVEL     'BKPOS'       DBFILE
     C                   MOVEL     '806'         DBASE
     C                   EXSR      SRERR
     C                   END
     C*
     C*  Update CPOSNA audit record
     C*
     C*****1****         CHAIN     CPOSNAF                            99                      223870
     C     1             CHAIN     CPOSNAF                            9956                    223870
      *                                                                                       223870
     C                   Z-ADD     1             COUNT             1 0                        223870
     C     *IN56         DOWEQ     '1'                                                        223870
     C     COUNT         ANDLT     7                                                          223870
      *                                                                                       223870
     C                   MOVEA     CMDDLY(1)     DLYJOB           80                          223870
     C                   Z-ADD     80            CMDLEN                                       223870
     C                   CALL      'QCMDEXC'                              57                  223870
     C                   PARM                    DLYJOB                                       223870
     C                   PARM                    CMDLEN           15 5                        223870
      *                                                                                       223870
     C     *IN57         IFEQ      '1'                                                        223870
     C                   MOVEL     'QCMDEXC'     DBKEY                                        223870
     C                   MOVEL     '*CALL   '    DBFILE                                       223870
     C                   MOVEL     '501'         DBASE                                        223870
      *                                                                                       223870
     C                   EXSR      SRERR                                                      223870
     C                   ENDIF                                                                223870
      *                                                                                       223870
     C     1             CHAIN     CPOSNAF                            9956                    223870
     C                   ADD       1             COUNT                                        223870
      *                                                                                       223870
     C                   ENDDO                                                                223870
      *                                                                                       223870
     C     *IN99         IFNE      '1'
     C     *IN56         ANDNE     '1'                                                        223870
     C                   ADD       CP_NOR        NORE
     C                   UPDATE    CPOSNAF
     C                   Z-ADD     *ZEROS        CP_NOR            5 0
     C                   ELSE
     C                   MOVEL     'AUDIT'       DBKEY
     C                   MOVEL     'CPOSN'       DBFILE
     C                   MOVEL     '807'         DBASE
     C                   EXSR      SRERR
     C                   END
     C*
     C*  Update CDEPPA audit record
     C*
     C*****1****         CHAIN     CDEPPAF                            99                      223870
     C     1             CHAIN     CDEPPAF                            9958                    223870
      *                                                                                       223870
     C                   Z-ADD     1             COUNT                                        223870
     C     *IN58         DOWEQ     '1'                                                        223870
     C     COUNT         ANDLT     7                                                          223870
      *                                                                                       223870
     C                   MOVEA     CMDDLY(1)     DLYJOB                                       223870
     C                   Z-ADD     80            CMDLEN                                       223870
     C                   CALL      'QCMDEXC'                              59                  223870
     C                   PARM                    DLYJOB                                       223870
     C                   PARM                    CMDLEN                                       223870
      *                                                                                       223870
     C     *IN59         IFEQ      '1'                                                        223870
     C                   MOVEL     'QCMDEXC'     DBKEY                                        223870
     C                   MOVEL     '*CALL   '    DBFILE                                       223870
     C                   MOVEL     '502'         DBASE                                        223870
      *                                                                                       223870
     C                   EXSR      SRERR                                                      223870
     C                   ENDIF                                                                223870
      *                                                                                       223870
     C     1             CHAIN     CDEPPAF                            9958                    223870
     C                   ADD       1             COUNT                                        223870
      *                                                                                       223870
     C                   ENDDO                                                                223870
      *                                                                                       223870
     C     *IN99         IFNE      '1'
     C     *IN58         ANDNE     '1'                                                        223870
     C                   ADD       CD_NOR        NORE
     C                   UPDATE    CDEPPAF
     C                   Z-ADD     *ZEROS        CD_NOR            5 0
     C                   ELSE
     C                   MOVEL     'AUDIT'       DBKEY
     C                   MOVEL     'CDEPP'       DBFILE
     C                   MOVEL     '808'         DBASE
     C                   EXSR      SRERR
     C                   END
     C*
     C*  Update UDEPPA audit record
     C*
     C     1             CHAIN     UDEPPAF                            99
     C     *IN99         IFNE      '1'
     C                   ADD       UD_NOR        NORE
     C                   UPDATE    UDEPPAF
     C                   Z-ADD     *ZEROS        UD_NOR            5 0
     C                   ELSE
     C                   MOVEL     'AUDIT'       DBKEY
     C                   MOVEL     'UDEPP'       DBFILE
     C                   MOVEL     '809'         DBASE
     C                   EXSR      SRERR
     C                   END
     C*
     C     WAEND         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CGL031
      ** SRGenCustIn - Write to Customer Income File                                          CGL031
      *****************************************************************                       CGL031
     C     SRGenCustIn   BEGSR                                                                CGL031
                                                                                              CGL031
     C                   CALLB     'SEVTRADTAX'                                               CGL031
                                                                                              CGL031
      ** INPUTS                                                                               CGL031
      ** Response mode                                                                        CGL031
                                                                                              CGL031
     C                   PARM                    RetCode                                      CGL031
                                                                                              CGL031
      ** Valid Trade Details                                                                  CGL031
                                                                                              CGL031
     C                   PARM                    SEVTRD                                       CGL031
                                                                                              CGL031
      ** Security Details                                                                     CGL031
                                                                                              CGL031
     C                   PARM                    SECTYF                                       CGL031
                                                                                              CGL031
      ** Process Flag                                                                         CGL031
                                                                                              CGL031
     C                   PARM                    ProcFlag                                     CGL031
                                                                                              CGL031
      ** OUTPUTS                                                                              CGL031
      ** EU Tax Screen Format                                                                 CGL031
      ** EU Tax in Nominal Currency File Format                                               CGL031
      ** EU Tax in Settlement Currency File Format                                            CGL031
                                                                                              CGL031
     C                   PARM                    DDEUTX                                       CGL031
     C                   PARM                    EUTX                                         CGL031
     C                   PARM                    EUTS                                         CGL031
                                                                                              CGL031
     C                   ENDSR                                                                CGL031
      ****************************************************************                        CGL031
      /EJECT                                                                                  CGL031
     C****************************************************************
     C*                                                              *
     C* UTRADSX1A - UPDATE TRADE EXTENSION 1 - 'A' RECORD            *
     C*                                                              *
     C****************************************************************
     C     UTRADSX1A     BEGSR

     C/COPY WNCPYSRC,SETRADDC03
      ** ACCESS TRADE EXTENSION RECORD

     C     CSW003        IFEQ      'Y'                                          154562
     C                   MOVEL     'A'           T1WHEN
     C                   ELSE                                                   154562
     C                   MOVEL     ' '           T1WHEN                         154562
     C                   END                                                    154562
     C     TRADSY1K      CHAIN     TRADSDD1                           99

      ** DATABASE ERROR
      ** IF INSERT, BUT RECORD PRESENT ALREADY
      ** OR IF NOT INSERT, BUT NO RECORD FOUND

     C     A_CHTP        IFEQ      'I'
     C     *IN99         ANDEQ     '0'
     C     A_CHTP        ORNE      'I'
     C     *IN99         ANDEQ     '1'
     C                   MOVEL     A_TDRF        DBKEY
     C                   MOVEL     'TRADSDX1'    DBFILE                         ************
     C                   MOVEL     '850'         DBASE                          * DBERR 002*
     C                   EXSR      SRERR                                        ************
     C                   END
      *                                                                                     BUG21255
      *** Save Last Swift Sequence                                                          BUG21255
      *                                                                                     BUG21255
     C     A_CHTP        IFNE      'I'                                                      BUG21255
     C                   Z-ADD     T1LSWS        SVLSWS            7 0                      BUG21255
     C                   ENDIF                                                              BUG21255

      ** Update with details from valid trade extension record

     C                   MOVEL     SEVTRDX1A     TRADSX1F
     C     CSE045        IFEQ      'Y'                                                        CSE045
     C     CSW003        IFEQ      'Y'                                                        CSE045
     C                   MOVEL     'A'           T1WHEN                                       CSE045
     C                   ELSE                                                                 CSE045
     C                   MOVEL     ' '           T1WHEN                                       CSE045
     C                   END                                                                  CSE045
     C                   ENDIF                                                                CSE045
      *
      *** Trade reference
      *
     C                   MOVEL     A_TDRF        T1TDRF
      *                                                                                     BUG21255
      *** Last Swift Sequence                                                               BUG21255
      *                                                                                     BUG21255
     C     A_CHTP        IFNE      'I'                                                      BUG21255
     C                   Z-ADD     SVLSWS        T1LSWS                                     BUG21255
     C                   ENDIF                                                              BUG21255
      *
      *** Set S.W.I.F.T. Confirmation generated to 'No'
      *** if trade confirmation not yet generated
      *
     C     TCFR          IFEQ      'N'
     C                   MOVEL     'N'           T1GMEC
     C                   ENDIF
      *
      *** Set Settlement Message Required Flag to 'Y'
      *
     C                   MOVEL     'Y'           T1SCMG

                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        T1FRNT = *BLANKS                                           CSC011
     C                   EVAL      T1FRNT = 'MD' + T1TDRF                                     CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** UPDATE RECORD

     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           T1CONG
     C                   MOVE      'N'           T1RCDG
     C                   WRITE     TRADSDD1
     C                   ELSE
     C                   UPDATE    TRADSDD1
     C                   END
      *                                                                                       CSE045
      ** Default Values for Extended Settlements if CSE045 is NOT installed                   CSE045
      *                                                                                       CSE045
     C**********         IF        CSE045 = 'N'                                        CSE045 238859
     C                   IF        CSE045 = 'N'                                               240736
                                                                                              210517
      ** Update Trade Extenstion 2 record                                                     210517
                                                                                              210517
     C**********         IF        PMode = 'UPC'                                      210517 243774A
     C                   IF        PMode = 'UPC' or                                          243774A
     C                             PMode = 'RPR'                                             243774A
                                                                                              238859
     C**********         IF        A_CHTP = 'I'                                        238859 240736
     C                   EVAL      PScreen = 'A'                                              210517
     C                   EXSR      InsertX2AB                                                 210517
     C**********         ENDIF                                                         238859 240736
                                                                                              238859
     C                   ENDIF                                                                210517
                                                                                              CSE045
     C**********         ELSE                                                          CSE045 238859
     C                   ELSE                                                                 240736
     C                   IF        PMode = 'UPC' or                                           CSE045
     C                             PMode = 'RPR'                                              CSE045
                                                                                              238859
     C**********         IF        A_CHTP = 'A'                                        238859 240736
     C                   EXSR      UTRADSX2A                                                  CSE045
     C                   ENDIF                                                                CSE045
     C                   ENDIF                                                                CSE045

     C                   IF        (CSC011 = 'Y') AND (LIBR = S1SUPP)                         CSC011
     C                   MOVEL     TRADSX1F      CT2AFilFmt                                   CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C/COPY WNCPYSRC,SETRADDC05
     C                   ENDSR
     C****************************************************************
      /EJECT                                                                                  210517
     C****************************************************************                        210517
      *                                                              *                        210517
      * InsertX2AB - Update Trade Extension 2 Records                *                        210517
      *                                                              *                        210517
      ****************************************************************                        210517
     C     InsertX2AB    BEGSR                                                                210517
                                                                                              210517
     C                   MOVE      'N'           DftDet                                      240736A
      *                                                                                      240736A
     C                   IF        SEVTRDX2A = *BLANKS                                        240736
                                                                                              240736
     C                   CALLB     'SETSWX2DFT'                                               210517
     C                   PARM                    PScreen                                      210517
     C                   PARM                    TDRF                                         210517
     C                   PARM                    TDTP                                         210517
     C                   PARM                    TCNR                                         210517
     C                   PARM                    TDSS                                         210517
     C                   PARM                    TDBA                                         210517
     C                   PARM                    DELF                                         210517
     C                   PARM                    DELT                                         210517
     C                   PARM                    TDBK                                         210517
     C                   PARM                    TNMC                                         210517
     C                   PARM                    TMKC                                         210517
                                                                                              210517
      ** OUTPUT PARAMETERS :                                                                  210517
      ** Screen A details                                                                     210517
                                                                                              210517
     C                   PARM                    A_TradX2                                     210517
                                                                                              210517
      ** Screen B details                                                                     210517
                                                                                              210517
     C                   PARM                    B_TradX2                                     210517
      *                                                                                      240736A
     C                   MOVE      'Y'           DftDet            1                         240736A
      *                                                                                      240736A
     C                   ENDIF                                                                240736
                                                                                              210517
      ** Access TRADSDX2 and check if record already exist                                    210517
                                                                                              210517
     C*****KeyTrdX2      CHAIN     TRADSDY2                           89               210517 243774
     C     CSW003        IFEQ      'Y'                                                        243774
     C                   MOVEL     PScreen       T2WHEN                                       243774
     C                   ELSE                                                                 243774
     C                   MOVEL     ' '           T2WHEN                                       243774
     C                   END                                                                  243774
     C     TRADSY2K      CHAIN     TRADSDY2                           89                      243774
      *                                                                                       243774
      ** DATABASE ERROR                                                                       243774
      ** IF NOT INSERT, BUT NO RECORD FOUND                                                   243774
      *                                                                                       243774
     C     A_CHTP        IFNE      'I'                                                        243774
     C     *IN89         ANDEQ     '1'                                                        243774
     C     A_TDRF        CAT       T2WHEN        DBKEY                                        243774
     C                   MOVEL     'TRADSDX2'    DBFILE                         ************  243774
     C                   MOVEL     '858'         DBASE                          * DBERR 858*  243774
     C                   EXSR      SRERR                                        ************  243774
     C                   ENDIF                                                                243774
                                                                                              210517
     C                   IF        *IN89 = *On                                                210517
                                                                                              210517
     C                   IF        DftDet = 'Y'                                              240736A
      *                                                                                      240736A
     C                   IF        PScreen = 'A'                                              210517
     C                   EVAL      TradX2Rec = A_TradX2                                       210517
     C                   EVAL      T2TDRF = TDRF                                              210517
     C                   ELSE                                                                 210517
     C                   EVAL      TradX2Rec = B_TradX2                                       210517
     C                   EVAL      T2TDRF = TDRF                                              210517
     C                   ENDIF                                                                210517
      *                                                                                      240736A
     C                   ELSE                                                                240736A
     C                   MOVEL     SEVTRDX2A     TradX2Rec                                   240736A
     C                   EVAL      T2TDRF = TDRF                                             240736A
     C                   EVAL      T2WHEN = PScreen                                          240736A
     C                   ENDIF                                                               240736A
                                                                                              243774
     C     CSW003        IFEQ      'N'                                                        243774
     C                   MOVEL     ' '           T2WHEN                                       243774
     C                   END                                                                  243774
                                                                                              210517
      ** Get the user define entry for Tradsdx2                                              BUG7975
                                                                                             BUG7975
     C                   EXSR      SRGetUserDefin                                            BUG7975
                                                                                             BUG7975
      *                                                                                     BUG12372
      ** Patterned after CSE045, moving of value to T2WHEN                                  BUG12372
      *                                                                                     BUG12372
     C                   If        PScreen = 'A'                                            BUG12372
     C                   If        CSW003 = 'Y'                                             BUG12372
     C                   Eval      T2WHEN = 'A'                                             BUG12372
     C                   Else                                                               BUG12372
     C                   Eval      T2WHEN = ' '                                             BUG12372
     C                   EndIf                                                              BUG12372
     C                   Else                                                               BUG12372
     C                   Eval      T2WHEN = 'B'                                             BUG12372
     C                   EndIf                                                              BUG12372
      *                                                                                     BUG12372
     C                   IF        TradX2Rec <> *Blanks                                       210517
     C                   EVAL      T2TMST = TimeStamp                                        BUG3947
     C                   WRITE     TRADSDD2                                                   210517
     C                   ENDIF                                                                210517
                                                                                              240736
     C*****              ELSE                                                          240736 CPK025
      *****                                                                            240736 CPK025
     C*****              MOVEL     SEVTRDX2A     TradX2Rec                             240736 CPK025
     C*****              UPDATE    TRADSDD2                                                   240736
                                                                                              210517
     C                   ELSE                                                                BUG7975
      ** Get the user define entry for Tradsdx2 for amend                                    BUG7975
                                                                                             BUG7975
     C                   EXSR      UTRADSX2A                                                 BUG7975
                                                                                             BUG7975
     C                   IF        CustClass = 'S' or                                        BUG7975
     C                             CustClass = 'D'                                           BUG7975
     C                   IF        CSW003 = 'Y'                                              BUG7975
     C                   EXSR      UTRADSX2B                                                 BUG7975
     C                   ENDIF                                                               BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   ENDIF                                                                210517
                                                                                              210517
     C                   ENDSR                                                                210517
      ****************************************************************                       BUG7975
      /EJECT                                                                                 BUG7975
     C****************************************************************                       BUG7975
     C*                                                              *                       BUG7975
     C* SRGetUserDefin - Get the user define entry for Tradsdx2      *                       BUG7975
     C*                                                              *                       BUG7975
     C****************************************************************                       BUG7975
     C     SRGetUserDefinBEGSR                                                               BUG7975
                                                                                             BUG7975
     C                   IF        PScreen = 'A'                                             BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2AFPN <> *Blanks                                      BUG7975
     C                   EVAL      T2AFPN = AA_T2AFPN                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2AFPL <> *Blanks                                      BUG7975
     C                   EVAL      T2AFPL = AA_T2AFPL                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2AWIN <> *Blanks                                      BUG7975
     C                   EVAL      T2AWIN = AA_T2AWIN                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2AWIL <> *Blanks                                      BUG7975
     C                   EVAL      T2AWIL = AA_T2AWIL                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2BOFN <> *Blanks                                      BUG7975
     C                   EVAL      T2BOFN = AA_T2BOFN                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2BOF1 <> *Blanks                                      BUG7975
     C                   EVAL      T2BOF1 = AA_T2BOF1                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2BOF2 <> *Blanks                                      BUG7975
     C                   EVAL      T2BOF2 = AA_T2BOF2                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2SRL1 <> *Blanks                                      BUG7975
     C                   EVAL      T2SRL1 = AA_T2SRL1                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2SRL2 <> *Blanks                                      BUG7975
     C                   EVAL      T2SRL2 = AA_T2SRL2                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2SRL3 <> *Blanks                                      BUG7975
     C                   EVAL      T2SRL3 = AA_T2SRL3                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2FIN1 <> *Blanks                                      BUG7975
     C                   EVAL      T2FIN1 = AA_T2FIN1                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2FIN2 <> *Blanks                                      BUG7975
     C                   EVAL      T2FIN2 = AA_T2FIN2                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2RED1 <> *Blanks                                      BUG7975
     C                   EVAL      T2RED1 = AA_T2RED1                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2RED2 <> *Blanks                                      BUG7975
     C                   EVAL      T2RED2 = AA_T2RED2                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2NAL1 <> *Blanks                                      BUG7975
     C                   EVAL      T2NAL1 = AA_T2NAL1                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2NAL2 <> *Blanks                                      BUG7975
     C                   EVAL      T2NAL2 = AA_T2NAL2                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2CCTN <> *Blanks                                      BUG7975
     C                   EVAL      T2CCTN = AA_T2CCTN                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2BSSN <> *Blanks                                      BUG7975
     C                   EVAL      T2BSSN = AA_T2BSSN                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2BSS1 <> *Blanks                                      BUG7975
     C                   EVAL      T2BSS1 = AA_T2BSS1                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2BSS2 <> *Blanks                                      BUG7975
     C                   EVAL      T2BSS2 = AA_T2BSS2                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2IMD1 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMD1 = AA_T2IMD1                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2IMD2 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMD2 = AA_T2IMD2                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2IMD3 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMD3 = AA_T2IMD3                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2IMD4 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMD4 = AA_T2IMD4                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2IMD5 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMD5 = AA_T2IMD5                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2IMD6 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMD6 = AA_T2IMD6                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2IMD7 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMD7 = AA_T2IMD7                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2IMD8 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMD8 = AA_T2IMD8                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2IMD9 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMD9 = AA_T2IMD9                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2IMS1 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMS1 = AA_T2IMS1                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2IMS2 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMS2 = AA_T2IMS2                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2IMS3 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMS3 = AA_T2IMS3                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2IMS4 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMS4 = AA_T2IMS4                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2IMS5 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMS5 = AA_T2IMS5                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2IMS6 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMS6 = AA_T2IMS6                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2IMS7 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMS7 = AA_T2IMS7                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2IMS8 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMS8 = AA_T2IMS8                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2IMS9 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMS9 = AA_T2IMS9                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2PSET <> *Blanks                                      BUG7975
     C                   EVAL      T2PSET = AA_T2PSET                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2NAC1 <> *Blanks                                      BUG7975
     C                   EVAL      T2NAC1 = AA_T2NAC1                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2NAC2 <> *Blanks                                      BUG7975
     C                   EVAL      T2NAC2 = AA_T2NAC2                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2DSSN <> *Blanks                                      BUG7975
     C                   EVAL      T2DSSN = AA_T2DSSN                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2DSS1 <> *Blanks                                      BUG7975
     C                   EVAL      T2DSS1 = AA_T2DSS1                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2DSS2 <> *Blanks                                      BUG7975
     C                   EVAL      T2DSS2 = AA_T2DSS2                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2DSS3 <> *Blanks                                      BUG7975
     C                   EVAL      T2DSS3 = AA_T2DSS3                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2DSS4 <> *Blanks                                      BUG7975
     C                   EVAL      T2DSS4 = AA_T2DSS4                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2RSSN <> *Blanks                                      BUG7975
     C                   EVAL      T2RSSN = AA_T2RSSN                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2RSS1 <> *Blanks                                      BUG7975
     C                   EVAL      T2RSS1 = AA_T2RSS1                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2RSS2 <> *Blanks                                      BUG7975
     C                   EVAL      T2RSS2 = AA_T2RSS2                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2RSS3 <> *Blanks                                      BUG7975
     C                   EVAL      T2RSS3 = AA_T2RSS3                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2RSS4 <> *Blanks                                      BUG7975
     C                   EVAL      T2RSS4 = AA_T2RSS4                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2SKAN <> *Blanks                                      BUG7975
     C                   EVAL      T2SKAN = AA_T2SKAN                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2SKAL <> *Blanks                                      BUG7975
     C                   EVAL      T2SKAL = AA_T2SKAL                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2SA1N <> *Blanks                                      BUG7975
     C                   EVAL      T2SA1N = AA_T2SA1N                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AA_T2SA1L <> *Blanks                                      BUG7975
     C                   EVAL      T2SA1L = AA_T2SA1L                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                              CSW210
     C                   IF        AA_T2DIDN <> *Blanks                                       CSW210
     C                   EVAL      T2DIDN = AA_T2DIDN                                         CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        AA_T2DLIN <> *Blanks                                       CSW210
     C                   EVAL      T2DLIN = AA_T2DLIN                                         CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        AA_T2DAD1 <> *Blanks                                       CSW210
     C                   EVAL      T2DAD1 = AA_T2DAD1                                         CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        AA_T2DAD2 <> *Blanks                                       CSW210
     C                   EVAL      T2DAD2 = AA_T2DAD2                                         CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        AA_T2DAD3 <> *Blanks                                       CSW210
     C                   EVAL      T2DAD3 = AA_T2DAD3                                         CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        AA_T2DAD4 <> *Blanks                                       CSW210
     C                   EVAL      T2DAD4 = AA_T2DAD4                                         CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        AA_T2QFIN <> *Blanks                                       CSW210
     C                   EVAL      T2QFIN = AA_T2QFIN                                         CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        AA_T2PCLR <> *Blanks                                       CSW210
     C                   EVAL      T2PCLR = AA_T2PCLR                                         CSW210
     C                   ENDIF                                                                CSW210
                                                                                             BUG7975
     C                   ELSE                                                                BUG7975
     C                   IF        AB_T2AFPN <> *Blanks                                      BUG7975
     C                   EVAL      T2AFPN = AB_T2AFPN                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2AFPL <> *Blanks                                      BUG7975
     C                   EVAL      T2AFPL = AB_T2AFPL                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2AWIN <> *Blanks                                      BUG7975
     C                   EVAL      T2AWIN = AB_T2AWIN                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2AWIL <> *Blanks                                      BUG7975
     C                   EVAL      T2AWIL = AB_T2AWIL                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2BOFN <> *Blanks                                      BUG7975
     C                   EVAL      T2BOFN = AB_T2BOFN                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2BOF1 <> *Blanks                                      BUG7975
     C                   EVAL      T2BOF1 = AB_T2BOF1                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2BOF2 <> *Blanks                                      BUG7975
     C                   EVAL      T2BOF2 = AB_T2BOF2                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2SRL1 <> *Blanks                                      BUG7975
     C                   EVAL      T2SRL1 = AB_T2SRL1                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2SRL2 <> *Blanks                                      BUG7975
     C                   EVAL      T2SRL2 = AB_T2SRL2                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2SRL3 <> *Blanks                                      BUG7975
     C                   EVAL      T2SRL3 = AB_T2SRL3                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2FIN1 <> *Blanks                                      BUG7975
     C                   EVAL      T2FIN1 = AB_T2FIN1                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2FIN2 <> *Blanks                                      BUG7975
     C                   EVAL      T2FIN2 = AB_T2FIN2                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2RED1 <> *Blanks                                      BUG7975
     C                   EVAL      T2RED1 = AB_T2RED1                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2RED2 <> *Blanks                                      BUG7975
     C                   EVAL      T2RED2 = AB_T2RED2                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2NAL1 <> *Blanks                                      BUG7975
     C                   EVAL      T2NAL1 = AB_T2NAL1                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2NAL2 <> *Blanks                                      BUG7975
     C                   EVAL      T2NAL2 = AB_T2NAL2                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2CCTN <> *Blanks                                      BUG7975
     C                   EVAL      T2CCTN = AB_T2CCTN                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2BSSN <> *Blanks                                      BUG7975
     C                   EVAL      T2BSSN = AB_T2BSSN                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2BSS1 <> *Blanks                                      BUG7975
     C                   EVAL      T2BSS1 = AB_T2BSS1                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2BSS2 <> *Blanks                                      BUG7975
     C                   EVAL      T2BSS2 = AB_T2BSS2                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2IMD1 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMD1 = AB_T2IMD1                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2IMD2 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMD2 = AB_T2IMD2                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2IMD3 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMD3 = AB_T2IMD3                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2IMD4 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMD4 = AB_T2IMD4                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2IMD5 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMD5 = AB_T2IMD5                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2IMD6 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMD6 = AB_T2IMD6                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2IMD7 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMD7 = AB_T2IMD7                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2IMD8 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMD8 = AB_T2IMD8                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2IMD9 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMD9 = AB_T2IMD9                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2IMS1 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMS1 = AB_T2IMS1                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2IMS2 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMS2 = AB_T2IMS2                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2IMS3 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMS3 = AB_T2IMS3                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2IMS4 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMS4 = AB_T2IMS4                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2IMS5 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMS5 = AB_T2IMS5                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2IMS6 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMS6 = AB_T2IMS6                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2IMS7 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMS7 = AB_T2IMS7                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2IMS8 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMS8 = AB_T2IMS8                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2IMS9 <> *Blanks                                      BUG7975
     C                   EVAL      T2IMS9 = AA_T2IMS9                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2PSET <> *Blanks                                      BUG7975
     C                   EVAL      T2PSET = AB_T2PSET                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2NAC1 <> *Blanks                                      BUG7975
     C                   EVAL      T2NAC1 = AB_T2NAC1                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2NAC2 <> *Blanks                                      BUG7975
     C                   EVAL      T2NAC2 = AB_T2NAC2                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2DSSN <> *Blanks                                      BUG7975
     C                   EVAL      T2DSSN = AB_T2DSSN                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2DSS1 <> *Blanks                                      BUG7975
     C                   EVAL      T2DSS1 = AB_T2DSS1                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2DSS2 <> *Blanks                                      BUG7975
     C                   EVAL      T2DSS2 = AB_T2DSS2                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2DSS3 <> *Blanks                                      BUG7975
     C                   EVAL      T2DSS3 = AB_T2DSS3                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2DSS4 <> *Blanks                                      BUG7975
     C                   EVAL      T2DSS4 = AB_T2DSS4                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2RSSN <> *Blanks                                      BUG7975
     C                   EVAL      T2RSSN = AB_T2RSSN                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2RSS1 <> *Blanks                                      BUG7975
     C                   EVAL      T2RSS1 = AB_T2RSS1                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2RSS2 <> *Blanks                                      BUG7975
     C                   EVAL      T2RSS2 = AB_T2RSS2                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2RSS3 <> *Blanks                                      BUG7975
     C                   EVAL      T2RSS3 = AB_T2RSS3                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2RSS4 <> *Blanks                                      BUG7975
     C                   EVAL      T2RSS4 = AB_T2RSS4                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2SKAN <> *Blanks                                      BUG7975
     C                   EVAL      T2SKAN = AB_T2SKAN                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2SKAL <> *Blanks                                      BUG7975
     C                   EVAL      T2SKAL = AB_T2SKAL                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2SA1N <> *Blanks                                      BUG7975
     C                   EVAL      T2SA1N = AB_T2SA1N                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   IF        AB_T2SA1L <> *Blanks                                      BUG7975
     C                   EVAL      T2SA1L = AB_T2SA1L                                        BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                              CSW210
     C                   IF        AB_T2DIDN <> *Blanks                                       CSW210
     C                   EVAL      T2DIDN = AB_T2DIDN                                         CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        AB_T2DLIN <> *Blanks                                       CSW210
     C                   EVAL      T2DLIN = AB_T2DLIN                                         CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        AB_T2DAD1 <> *Blanks                                       CSW210
     C                   EVAL      T2DAD1 = AB_T2DAD1                                         CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        AB_T2DAD2 <> *Blanks                                       CSW210
     C                   EVAL      T2DAD2 = AB_T2DAD2                                         CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        AB_T2DAD3 <> *Blanks                                       CSW210
     C                   EVAL      T2DAD3 = AB_T2DAD3                                         CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        AB_T2DAD4 <> *Blanks                                       CSW210
     C                   EVAL      T2DAD4 = AB_T2DAD4                                         CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        AB_T2QFIN <> *Blanks                                       CSW210
     C                   EVAL      T2QFIN = AB_T2QFIN                                         CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        AB_T2PCLR <> *Blanks                                       CSW210
     C                   EVAL      T2PCLR = AB_T2PCLR                                         CSW210
     C                   ENDIF                                                                CSW210
                                                                                             BUG7975
     C                   ENDIF                                                               BUG7975
                                                                                             BUG7975
     C                   ENDSR                                                               BUG7975
      ****************************************************************                        210517
      /EJECT
     C****************************************************************
     C*                                                              *
     C* UTRADSX1B - UPDATE TRADE EXTENSION 1 - 'B' RECORD            *
     C*                                                              *
     C****************************************************************
     C     UTRADSX1B     BEGSR

      ** ACCESS TRADE EXTENSION RECORD

     C                   MOVEL     'B'           T1WHEN
     C     TRADSY1K      CHAIN     TRADSDD1                           99

      ** DATABASE ERROR
      ** IF INSERT, BUT RECORD PRESENT ALREADY
      ** OR IF NOT INSERT, BUT NO RECORD FOUND

     C     A_CHTP        IFEQ      'I'
     C     *IN99         ANDEQ     '0'
     C     A_CHTP        ORNE      'I'
     C     *IN99         ANDEQ     '1'
     C                   MOVEL     A_TDRF        DBKEY
     C                   MOVEL     'TRADSDX1'    DBFILE                         ************
     C                   MOVEL     '851'         DBASE                          * DBERR 002*
     C                   EXSR      SRERR                                        ************
     C                   END

      ** If depots are different
      ** Update with details from valid trade extension 'B' record
      ** Else, update with 'A' details

     C     DELF          IFNE      DELT
     C                   MOVEL     SEVTRDX1B     TRADSX1F
     C                   IF        CSE045 = 'Y'                                               CSE045
     C                   MOVEL     'B'           T1WHEN                                       CSE045
     C                   ENDIF                                                                CSE045
     C                   MOVEL     'N'           T1GMEC                                     AR632291
     C                   ELSE
     C                   MOVEL     SEVTRDX1A     TRADSX1F
     C                   MOVEL     'B'           T1WHEN
     C                   MOVEL     'N'           T1GMES
     C                   MOVEL     'N'           T1GMEC
     C                   END
      *
      *** Trade reference
      *
     C                   MOVEL     A_TDRF        T1TDRF
      *
      *** Set S.W.I.F.T. Confirmation generated to 'No'
      *** if trade confirmation not yet generated
      *
     C     TCFR          IFEQ      'N'
     C                   MOVEL     'N'           T1GMEC
     C                   ENDIF
      *
      *** Set Settlement Message Required Flag to 'Y'
      *
     C                   MOVEL     'Y'           T1SCMG

                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        T1FRNT = *BLANKS                                           CSC011
     C                   EVAL      T1FRNT = 'MD' + T1TDRF                                     CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** UPDATE RECORD

     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           T1CONG
     C                   MOVE      'N'           T1RCDG
     C                   WRITE     TRADSDD1
     C                   ELSE
     C                   UPDATE    TRADSDD1
     C                   END
      *                                                                                       CSE045
      ** Default Values of Extended Settlements when CSE045 is NOT installed                  CSE045
      *                                                                                       CSE045
     C**********         IF        CSE045 = 'N'                                        CSE045 238859
     C                   IF        CSE045 = 'N'                                               240736
                                                                                              210517
      ** Update Trade Extenstion 2 record                                                     210517
                                                                                              210517
     C                   IF        PMode = 'UPC'                                              210517
                                                                                              238859
     C**********         IF        A_CHTP = 'I'                                        238859 240736
     C                   EVAL      PScreen = 'B'                                              210517
     C                   EXSR      InsertX2AB                                                 210517
     C**********         ENDIF                                                         238859 240736
                                                                                              238859
     C                   ENDIF                                                                210517
                                                                                              CSE045
     C**********         ELSE                                                          CSE045 238859
     C                   ELSE                                                                 240736
     C                   IF        PMode = 'UPC' or                                           CSE045
     C                             PMode = 'RPR'                                              CSE045
                                                                                              238859
     C**********         IF        A_CHTP = 'A'                                        238859 240736
     C                   EXSR      UTRADSX2B                                                  CSE045
     C                   ENDIF                                                                CSE045
     C                   ENDIF                                                                CSE045

     C                   IF        (CSC011 = 'Y') AND (LIBR = S1SUPP)                         CSC011
     C                   MOVEL     TRADSX1F      CT2BFilFmt                                   CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C/COPY WNCPYSRC,SETRADDC06
     C                   ENDSR
      *****************************************************************                       CSE045
      /EJECT                                                                                  CSE045
     C****************************************************************                        CSE045
     C*                                                              *                        CSE045
     C* UTRADSX2A - UPDATE TRADE SWIFT EXTENDED SETTLEMENT           *                        CSE045
     C*                                                              *                        CSE045
     C****************************************************************                        CSE045
     C     UTRADSX2A     BEGSR                                                                CSE045
      *                                                                                       CSE045
      ** Access Trade Extension Record                                                        CSE045
      *                                                                                       CSE045
     C     CSW003        IFEQ      'Y'                                                        CSE045
     C                   MOVEL     'A'           T2WHEN                                       CSE045
     C                   ELSE                                                                 CSE045
     C                   MOVEL     ' '           T2WHEN                                       CSE045
     C                   END                                                                  CSE045
     C     TRADSY2K      CHAIN     TRADSDD2                           99                      CSE045
      *                                                                                       CSE045
      ** DATABASE ERROR                                                                       CSE045
      ** IF INSERT, BUT RECORD PRESENT ALREADY                                                CSE045
      ** OR IF NOT INSERT, BUT NO RECORD FOUND                                                CSE045
      *                                                                                       CSE045
     C     A_CHTP        IFEQ      'I'                                                        CSE045
     C     *IN99         ANDEQ     '0'                                                        CSE045
     C     A_CHTP        ORNE      'I'                                                        CSE045
     C     *IN99         ANDEQ     '1'                                                        CSE045
     C                   MOVEL     A_TDRF        DBKEY                                        CSE045
     C                   MOVEL     'TRADSDX2'    DBFILE                         ************  CSE045
     C                   MOVEL     '856'         DBASE                          * DBERR 856*  CSE045
     C                   EXSR      SRERR                                        ************  CSE045
     C                   ENDIF                                                                CSE045
      *                                                                                       CSE045
      ** Update with details from valid trade extension record                                CSE045
      *                                                                                       CSE045
     C                   MOVEL     SEVTRDX2A     TradX2Rec                                    CSE045
                                                                                              CSE045
     C     CSW003        IFEQ      'Y'                                                        CSE045
     C                   MOVEL     'A'           T2WHEN                                       CSE045
     C                   ELSE                                                                 CSE045
     C                   MOVEL     ' '           T2WHEN                                       CSE045
     C                   END                                                                  CSE045
      *                                                                                       CSE045
      ** Trade reference                                                                      CSE045
      *                                                                                       CSE045
     C                   MOVEL     A_TDRF        T2TDRF                                       CSE045
      *                                                                                       CSE045
      ** Update Record                                                                        CSE045
      *                                                                                       CSE045
     C                   EVAL      T2TMST = TimeStamp                                        BUG3947
     C     *IN99         IFEQ      '1'                                                        CSE045
     C                   WRITE     TRADSDD2                                                   CSE045
     C                   ELSE                                                                 CSE045
     C                   UPDATE    TRADSDD2                                                   CSE045
     C                   ENDIF                                                                CSE045
                                                                                              CSE045
     C                   ENDSR                                                                CSE045
     C****************************************************************                        CSE045
      /EJECT                                                                                  CSE045
     C****************************************************************                        CSE045
     C*                                                              *                        CSE045
     C* UTRADSX2B - UPDATE TRADE SWIFT EXTENDED SETTLEMENTS          *                        CSE045
     C*                                                              *                        CSE045
     C****************************************************************                        CSE045
     C     UTRADSX2B     BEGSR                                                                CSE045
      *                                                                                       CSE045
      ** Access Trade Extension Record                                                        CSE045
      *                                                                                       CSE045
     C                   MOVEL     'B'           T2WHEN                                       CSE045
     C     TRADSY2K      CHAIN     TRADSDD2                           99                      CSE045
      *                                                                                       CSE045
      ** DATABASE ERROR                                                                       CSE045
      ** IF INSERT, BUT RECORD PRESENT ALREADY                                                CSE045
      ** OR IF NOT INSERT, BUT NO RECORD FOUND                                                CSE045
      *                                                                                       CSE045
     C     A_CHTP        IFEQ      'I'                                                        CSE045
     C     *IN99         ANDEQ     '0'                                                        CSE045
     C     A_CHTP        ORNE      'I'                                                        CSE045
     C     *IN99         ANDEQ     '1'                                                        CSE045
     C                   MOVEL     A_TDRF        DBKEY                                        CSE045
     C                   MOVEL     'TRADSDX1'    DBFILE                         ************  CSE045
     C                   MOVEL     '857'         DBASE                          * DBERR 857*  CSE045
     C                   EXSR      SRERR                                        ************  CSE045
     C                   ENDIF                                                                CSE045
      *                                                                                       CSE045
      ** If depots are different                                                              CSE045
      ** Update with details from valid trade extension 'B' record                            CSE045
      ** Else, update with 'A' details                                                        CSE045
      *                                                                                       CSE045
     C     DELF          IFNE      DELT                                                       CSE045
     C                   MOVEL     SEVTRDX2B     TradX2Rec                                    CSE045
     C                   ELSE                                                                 CSE045
     C                   MOVEL     SEVTRDX2A     TradX2Rec                                    CSE045
     C                   ENDIF                                                                CSE045
      *                                                                                       CSE045
      ** Trade reference                                                                      CSE045
      *                                                                                       CSE045
     C                   MOVEL     A_TDRF        T2TDRF                                       CSE045
     C                   MOVEL     'B'           T2WHEN                                       CSE045
      *                                                                                       CSE045
      ** Update Record                                                                        CSE045
      *                                                                                       CSE045
     C                   EVAL      T2TMST = TimeStamp                                        BUG3947
     C     *IN99         IFEQ      '1'                                                        CSE045
     C                   WRITE     TRADSDD2                                                   CSE045
     C                   ELSE                                                                 CSE045
     C                   UPDATE    TRADSDD2                                                   CSE045
     C                   ENDIF                                                                CSE045
                                                                                              CSE045
     C                   ENDSR                                                                CSE045
     C****************************************************************
     C/COPY WNCPYSRC,SETRADDC07
      ****************************************************************                        CSE039
      /EJECT                                                                                  CSE039
      ****************************************************************                        CSE039
      *                                                              *                        CSE039
      * SrMovement - Update Movement Status File                     *                        CSE039
      *                                                              *                        CSE039
      ****************************************************************                        CSE039
     C     SrMovement    BEGSR                                                                CSE039
      *                                                                                       CSE039
      ** Key list to access Movement Status file                                              CSE039
     C     KeyMove       KLIST                                                                CSE039
     C                   KFLD                    KTRRF             6                          CSE039
     C                   KFLD                    KTRTY             1                          CSE039
     C                   KFLD                    KNTDT             5 0                        CSE039
      *                                                                                       CSE039
      ** Transaction Reference                                                                CSE039
     C                   EVAL      TMTRRF = TDRF                                              CSE039
     C                   EVAL      KTRRF = TDRF                                               CSE039
      *                                                                                       CSE039
      ** Transaction Type                                                                     CSE039
     C                   EVAL      TMTRTY = 'T'                                               CSE039
     C                   EVAL      KTRTY = 'T'                                                CSE039
      *                                                                                       CSE039
      ** Notification Date                                                                    CSE039
     C                   Z-ADD     BJRDNB        TMNTDT                                       CSE039
     C                   Z-Add     BJRDNB        KNTDT                                        CSE039
      *                                                                                       CSE039
      ** Sequence Number                                                                      CSE039
     C     KeyMove       Chain     SEMVTSL0                           80                      CSE039
     C                   If        *IN80 = '1'                                                CSE039
     C                   Z-Add     1             TMSQNR                                       CSE039
     C                   Else                                                                 CSE039
     C     MV_TMSQNR     Add       1             TMSQNR                                       CSE039
     C                   EndIf                                                                CSE039
      *                                                                                       CSE039
      ** SWIFT Status Code                                                                    CSE039
     C                   Select                                                               CSE039
     C                   When      A_CHTP = 'I'                                               CSE039
     C                   Movel     'INS'         TMSWSC                                       CSE039
     C                   When      A_CHTP = 'A'                                               CSE039
     C                   Movel     'AMD'         TMSWSC                                       CSE039
     C                   When      A_CHTP = 'C'                                               CSE039
     C                   Movel     'CHG'         TMSWSC                                       CSE039
     C                   When      A_CHTP = 'D'                                               CSE039
     C                   Movel     'DEL'         TMSWSC                                       CSE039
     C                   When      A_CHTP = 'P'                                               CSE039
     C                   Movel     'APP'         TMSWSC                                       CSE039
     C                   When      A_CHTP = 'Y'                                               CSE039
     C                   Movel     'AUT'         TMSWSC                                       CSE039
     C                   EndSl                                                                CSE039
      *                                                                                       CSE039
      ** SWIFT Reason Code                                                                    CSE039
     C                   EVAL      TMSWRC = *BLANKS                                           CSE039
      *                                                                                       CSE039
      ** Narrative                                                                            CSE039
     C                   EVAL      TMNARR = *BLANKS                                           CSE039
      *                                                                                       CSE039
      ** Input Origin                                                                         CSE039
     C                   EVAL      TMINOR = 'Midas'                                           CSE039
      *                                                                                       CSE039
      ** Transaction Booking Branch                                                           CSE039
     C                   EVAL      TMTRBB = TDBA                                              CSE039
      *                                                                                       CSE039
      ** Settlement Confirmation Required                                                     CSE039
     C                   EVAL      TMSCRQ = *BLANKS                                           CSE039
      *                                                                                       CSE039
      ** Settlement Message Generated                                                         CSE039
     C                   Eval      TMSTMG = *BLANKS                                           CSE039
      *                                                                                       CSE039
      ** Settlement Sequence Number                                                           CSE039
     C                   Z-Add     *Zeros        TMSSQN                                       CSE039
      *                                                                                       CSE039
      ** Front Office Id                                                                      CSE039
     C                   Eval      TMFRNT = A_FRNT                                            CSE039
      ** Associated Front Office Id                                                           CSE039
     C                   Eval      TMAFRT = A_AFRT                                            CSE039
      ** Repair Location                                                                      CSE039
     C                   Eval      TMREPA = A_REPA                                            CSE039
      *                                                                                       CSE039
      ** Time Stamp                                                                           CSE039
     C                   Eval      TMTMST = A_TMST                                            CSE039
      *                                                                                       CSE039
      ** Last Change Type                                                                     CSE039
     C                   Eval      TMLCTP = 'I'                                               CSE039
      ** Last Change Date                                                                     CSE039
     C                   Z-ADD     BJRDNB        TMLCDT                                       CSE039
      ** User                                                                                 CSE039
     C                   EVAL      TMLCUS = PsUser                                            CSE039
      *                                                                                       CSE039
      ** From Interface:                                                                      CSE039
      *   Notification Method                                                                 CSE039
      *   Message Key                                                                         CSE039
     C     A_FRNT        CHAIN     TRADSDY3                           80                      CSE039
     C     *IN80         IFEQ      *OFF                                                       CSE039
     C                   EVAL      TMNTMT = T3NTMT                                            CSE039
     C                   EVAL      TMMSGK = T3MSGK                                            CSE039
     C                   ELSE                                                                 CSE039
     C                   EVAL      TMNTMT = *BLANKS                                           CSE039
     C                   EVAL      TMMSGK = *BLANKS                                           CSE039
     C                   ENDIF                                                                CSE039
      *                                                                                       CSE039
      *                                                                                       CSE039
      ** Output a record to the Trade Movement Status File                                    CSE039
      *                                                                                       CSE039
      *                 *********************                                                 CSE039
     C                   Write     SEMVTSD06                            99                    CSE039
      *                 *********************                                                 CSE039
      *                                                                                       CSE039
     C                   ENDSR                                                                CSE039
      *                                                                                       CSE039
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CALEFRALL - Calculate Effective Reallowance                  *
     C*                                                              *
     C****************************************************************
     C     CALEFRALL     BEGSR
      *
     C                   Z-ADD     RALL          EFF_RALL         15 8
      *
      *   . if Discount
      *
     C     STBS          IFEQ      'D'
     C     RALL          ANDNE     0
     C                   Z-ADD     TDVD          ZSDATE
     C                   Z-ADD     MATY          ZEDATE
     C                   EXSR      ZDAYS
     C     RALL          MULT      ZDDAYS        ADJ_RALL         15 8
     C                   EXSR      ZDYYR

     C     ZINTDD        IFNE      0

     C                   DIV(H)    ZINTDD        ADJ_RALL

     C     ADJ_RALL      IFGE      0
     C     1             SUB       ADJ_RALL      EFF_RALL
     C                   ELSE
     C                   Z-SUB     ADJ_RALL      ADJ_RALL         15 8
     C     1             SUB       ADJ_RALL      EFF_RALL
     C                   Z-SUB     EFF_RALL      EFF_RALL
     C                   END
     C*
     C                   ELSE
     C                   Z-ADD     *ZEROS        EFF_RALL
     C                   END
     C                   END

     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* GETCSSED - GET CUSTOMER & SECURITY DETAILS                   *
     C*                                                              *
     C****************************************************************
     C     GETCSSED      BEGSR
      *
      ** ACCESS COUNTERPARTY DETAILS
      *
     C*****A_TCNR        IFNE      *ZEROS                                              208195 CSD027
     C     A_TCNR        IFNE      *BLANKS                                                    CSD027
     C                   MOVEL     A_TCNR        @SCKY
     C                   CALL      'AOSECSR0'
     C                   PARM                    @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @SCKY             6
     C     SDSECS        PARM      SDSECS        DSSDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     A_TCNR        DBKEY
     C                   MOVEL     'SDSECSPD'    DBFILE                         ************
     C                   MOVEL     '852'         DBASE                          * DBERR 008*
     C                   EXSR      SRERR                                        ************
     C                   END
     C                   ENDIF                                                                208195

     C                   MOVEL     BFCLAS        CustClass         1
      *
      ** ACCESS SECURITY
      *
     C     A_TDSS        CHAIN     SECTYDF                            99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     A_TDSS        DBKEY
     C                   MOVEL     'SECTY   '    DBFILE                         ************
     C                   MOVEL     '853'         DBASE                          * DBERR 008*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      ** GET NOMINAL CURRENCY DECIMAL PLACES
      *
     C                   MOVE      NMCY          @AJCD
     C                   EXSR      AOCURR
     C                   MOVE      A6NBDP        NomCcyDec         1 0
      *
      ** ACCESS INVESTMENT TYPE
      *
     C     KLINVT        CHAIN     INVTPDF                            99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     NMCY          DBKEY
     C                   MOVE      SITP          DBKEY
     C                   MOVEL     'INVTP   '    DBFILE                         ************
     C                   MOVEL     '854'         DBASE                          * DBERR 008*
     C                   EXSR      SRERR                                        ************
     C                   END
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* TRDVLBS - CALCULATE TRADE VALUE IN BASE CURRENCY             *
     C*                                                              *
     C****************************************************************
     C     TRDVLBS       BEGSR
      *
      * Convert countervalue in nominal currency to base currency
      *
     C                   CALLB     'ZCONV'
     C                   PARM      TCTR          ZAMTCI
     C                   PARM      TBCR          ZEXCH
     C                   PARM      BseCcyMDI     ZMD
     C                   PARM      NMCY          ZCCYI
     C                   PARM      BJCYCD        ZCCYO
     C                   PARM      NomCcyDec     ZCDPI
     C                   PARM      BseCcyDec     ZCDPO
     C                   PARM      *ZERO         ZAMTCO

     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* TRDSETV - CALCULATE TRADE SETTLEMENT VALUE                   *
     C*                                                              *
     C****************************************************************
     C     TRDSETV       BEGSR
      *
      * Convert countervalue in nominal currency to settlement currency
      * (get settlement currency dec. places first)
      *
     C                   MOVE      SETC          @AJCD
     C                   EXSR      AOCURR

     C                   CALLB     'ZCONV'
     C                   PARM      TCTR          ZAMTCI           15 0
     C                   PARM      TDER          ZEXCH            13 8
     C                   PARM      TMDI          ZMD               1
     C                   PARM      NMCY          ZCCYI             3
     C                   PARM      SETC          ZCCYO             3
     C                   PARM      NomCcyDec     ZCDPI             1 0
     C                   PARM      A6NBDP        ZCDPO             1 0
     C                   PARM      *ZERO         ZAMTCO           15 0

     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* AOCURR - ACCESS CURRENCY DETAILS                             *
     C*                                                              *
     C****************************************************************
     C     AOCURR        BEGSR
      *
      ** Access currency details using currency.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @AJCD         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '855'         DBASE                          * DBERR 008*
     C                   EXSR      SRERR                                        ************
     C                   END
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* ZCNSD - CONSIDERATION CALCULATION                            *
     C*                                                              *
     C****************************************************************
     C     ZCNSD         BEGSR
     C                   CALLB     'ZCNSD'
     C                   PARM                    ZNOML            15 0
     C                   PARM                    ZPRC             16 9
     C                   PARM                    SPBS
     C                   PARM                    NMDP
     C                   PARM      NomCcyDec     ZCDP              1 0
     C                   PARM                    ZCONS            15 0
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* ZDAYS - CALCULATE NUMBER OF DAYS                             *
     C*                                                              *
     C****************************************************************
     C     ZDAYS         BEGSR
     C                   CALLB     'ZDAYS'
     C                   PARM                    ZSDATE            5 0
     C                   PARM                    ZEDATE            5 0
     C                   PARM                    DYBS
     C                   PARM                    ITLD
     C                   PARM                    LCPN
     C                   PARM                    IADJ
     C                   PARM                    CPNR                           149162
     C                   PARM                    MATY                           149162
     C                   PARM      MATY          NCD                            149162
     C                   PARM                    DADJN
     C                   PARM                    ZIDNAT            2 0          149162
     C                   PARM                    ZACLT             1            149162
     C                   PARM                    ACLD              1            149162
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDDAYS            5 0
     C                   PARM                    ZODNAT            2 0          149162
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* ZDDYR - CALCULATE DAYS IN THE YEAR                           *
     C*                                                              *
     C****************************************************************
     C     ZDYYR         BEGSR
     C                   CALLB     'ZDYYR'
     C                   PARM                    DYBS
     C                   PARM                    DVBS
     C                   PARM                    ISSD
     C                   PARM                    ITLD
     C                   PARM                    LCPN
     C                   PARM                    FCPN
     C                   PARM                    MATY
     C                   PARM                    IADJ
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    CPNR                           149162
     C                   PARM                    DADJN             1
     C                   PARM      MATY          NCD               5 0
     C                   PARM      TDVD          ECD               5 0
     C                   PARM                    BJDFIN
     C                   PARM                    HCY1                                         CSE071
     C                   PARM                    HCY2                                         CSE071
     C                   PARM                    HCY3                                         CSE071
     C                   PARM                    HCY4                                         CSE071
     C                   PARM                    HCY5                                         CSE071
     C                   PARM                    HCY6                                         CSE071
     C                   PARM                    HCY7                                         CSE071
     C                   PARM                    HCY8                                         CSE071
     C                   PARM                    HCY9                                         CSE071
     C                   PARM                    ZINTDD            5 0
     C                   PARM                    LCDD5             5 0
     C                   ENDSR
     C****************************************************************
      /EJECT                                                                                  CSD015
      ****************************************************************                        CSD015
      * SrWatch - Perform Midas Watch List processing.               *                        CSD015
      ****************************************************************                        CSD015
                                                                                              CSD015
     C     SrWatch       BEGSR                                                                CSD015
                                                                                              CSD015
      ** Initialize First Parameter Data Structure to blanks                                  CSD015
                                                                                              CSD015
     C                   EVAL      SEFirstParm = *Blanks                                      CSD015
                                                                                              CSD015
     C                   EVAL      W4ITEM = 'SETRAD'                                          CSD015
     C                   EVAL      W4IDEN = TDRF                                              CSD015
     C                   EVAL      W4BRCH = TDBA                                              CSD015
     C                   EVAL      W4SYSM = LIBR                                              CSD015
     C                   EVAL      W4FUNT = 'TRADSD'                                          CSD015
     C                   MOVEL     TCNR          W4CNUM                                       CSD015
     C                   EVAL      W4DEN1 = TDSS                                              CSD015
     C                   EVAL      W4DEN2 = *BLANKS                                           CSD015
     C                   EVAL      W4AMT2 = *Zeros                                            CSD015
                                                                                              CSD015
      ** Access customer details file for Counter Party (Midas Report                         CSD015
      ** Name + Customer Report Town)                                                         CSD015
      ** Determine Country party type                                                         CSD015
                                                                                              CSD015
     C                   EVAL      PKey = *Blanks                                             CSD015
     C                   MOVE      TCNR          PKey                                         CSD015
                                                                                              CSD015
     C                   CALLB     'AOCUSTR0'                                                 CSD015
     C                   PARM      *BLANKS       PRtcd                                        CSD015
     C                   PARM      '*KEY'        POptn                                        CSD015
     C                   PARM                    PKey                                         CSD015
     C                   PARM      *BLANKS       PKySts                                       CSD015
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSD015
     C                   EVAL      W4CUST = BBCRNM + BBCRTN                                   CSD015
                                                                                              CSD015
      ** If Concord Interface Development (CCF001) is installed                               CSD015
                                                                                              CSD015
     C                   IF        CCF001 = 'Y'                                               CSD015
     C                   IF        BBCRPC = 'Y'                                               CSD015
     C                   EVAL      W4CTYP = 'C'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4CTYP = 'I'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ELSE                                                                 CSD015
                                                                                              CSD015
     C                   IF        BBLICD <> *BLANKS                                          CSD015
     C                             AND BBLICD <> W1IND1                                       CSD015
     C                             AND BBLICD <> W1IND2                                       CSD015
     C                             AND BBLICD <> W1IND3                                       CSD015
     C                             AND BBLICD <> W1IND4                                       CSD015
     C                             AND BBLICD <> W1IND5                                       CSD015
     C                   EVAL      W4CTYP = 'C'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4CTYP = 'I'                                               CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   MOVEL     TDDT          PDATE                                        CSD015
     C                   CALL      'ZACVTDATE'                                                CSD015
     C                   PARM                    PRtCd                                        CSD015
     C                   PARM                    PDATE                                        CSD015
     C                   PARM                    ConvertedDate                                CSD015
     C                   PARM                    PDummy10                                     CSD015
     C                   EVAL      W4DDAT = ConvertedDate                                     CSD015
                                                                                              CSD015
     C                   MOVEL     TDVD          PDATE                                        CSD015
     C                   CALL      'ZACVTDATE'                                                CSD015
     C                   PARM                    PRtCd                                        CSD015
     C                   PARM                    PDATE                                        CSD015
     C                   PARM                    ConvertedDate                                CSD015
     C                   PARM                    PDummy10                                     CSD015
     C                   EVAL      W4VDAT = ConvertedDate                                     CSD015
                                                                                              CSD015
     C                   CALL      'ZACVTDATE'                                                CSD015
     C                   PARM                    PRtCd                                        CSD015
     C                   PARM      *BLANKS       PDATE                                        CSD015
     C                   PARM                    ConvertedDate                                CSD015
     C                   PARM                    PDummy10                                     CSD015
     C                   EVAL      W4MDAT = ConvertedDate                                     CSD015
                                                                                              CSD015
     C                   CALL      'ZACVTAMT'                                                 CSD015
     C                   PARM                    PRtCd                                        CSD015
     C                   PARM                    TNMC                                         CSD015
     C                   PARM                    NOML                                         CSD015
     C                   PARM                    ConvertedAmt                                 CSD015
     C                   PARM                    PDummy16                                     CSD015
                                                                                              CSD015
     C                   EVAL      W4AMT1 = ConvertedAmt                                      CSD015
                                                                                              CSD015
      ** Set-up second parameter for Compliance Engine                                        CSD015
                                                                                              CSD015
     C                   EVAL      SESecondParm = *BLANKS                                     CSD015
                                                                                              CSD015
     C                   IF        PYFM <> *BLANKS                                            CSD015
     C                   IF        W3UNCF = 'Y' or WInsert = 'Y' or                           CSD015
     C                             WAmend1 = 'Y'                                              CSD015
     C                   EVAL      PINP1 = PYFM                                               CSD015
     C                   EVAL      PCCY = SETC                                                CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       OPTAG(1):0    SeSecondParm                                 CSD015
     C                   CAT       POUT:0        SeSecondParm                                 CSD015
     C                   CAT       CLTAG(1):0    SeSecondParm                                 CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PAYT <> *BLANKS                                            CSD015
     C                   IF        W3UNCF = 'Y' or WInsert = 'Y' or                           CSD015
     C                             WAmend2 = 'Y'                                              CSD015
     C                   EVAL      PINP1 = PAYT                                               CSD015
     C                   EVAL      PCCY = SETC                                                CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       OPTAG(2):0    SeSecondParm                                 CSD015
     C                   CAT       POUT:0        SeSecondParm                                 CSD015
     C                   CAT       CLTAG(2):0    SeSecondParm                                 CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        TDFA <> *BLANKS                                            CSD015
     C                   IF        W3UNCF = 'Y' or WInsert = 'Y' or                           CSD015
     C                             WAmend3 = 'Y'                                              CSD015
     C                   EVAL      PINP1 = TDFA                                               CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       OPTAG(3):0    SeSecondParm                                 CSD015
     C                   CAT       POUT:0        SeSecondParm                                 CSD015
     C                   CAT       CLTAG(3):0    SeSecondParm                                 CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C**********         IF        DELT <> *Zeros                                      CSD015 CSD027
     C                   IF        DELT <> *Blanks                                            CSD027
     C                   IF        W3UNCF = 'Y' or WInsert = 'Y' or                           CSD015
     C                             WAmend4 = 'Y'                                              CSD015
     C                   MOVEL     DELT          PINP1                                        CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       OPTAG(4):0    SeSecondParm                                 CSD015
     C                   CAT       POUT:0        SeSecondParm                                 CSD015
     C                   CAT       CLTAG(4):0    SeSecondParm                                 CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        DTFA <> *BLANKS                                            CSD015
     C                   IF        W3UNCF = 'Y' or WInsert = 'Y' or                           CSD015
     C                             WAmend5 = 'Y'                                              CSD015
     C                   EVAL      PINP1 = DTFA                                               CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       OPTAG(5):0    SeSecondParm                                 CSD015
     C                   CAT       POUT:0        SeSecondParm                                 CSD015
     C                   CAT       CLTAG(5):0    SeSecondParm                                 CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C**********         IF        DELF <> *Zeros                                      CSD015 CSD027
     C                   IF        DELF <> *Blanks                                            CSD027
     C                   IF        W3UNCF = 'Y' or WInsert = 'Y' or                           CSD015
     C                             WAmend6 = 'Y'                                              CSD015
     C                   MOVEL     DELT          PINP1                                        CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       OPTAG(6):0    SeSecondParm                                 CSD015
     C                   CAT       POUT:0        SeSecondParm                                 CSD015
     C                   CAT       CLTAG(6):0    SeSecondParm                                 CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        DFFA <> *BLANKS                                            CSD015
     C                   IF        W3UNCF = 'Y' or WInsert = 'Y' or                           CSD015
     C                             WAmend7 = 'Y'                                              CSD015
     C                   EVAL      PINP1 = DFFA                                               CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       OPTAG(7):0    SeSecondParm                                 CSD015
     C                   CAT       POUT:0        SeSecondParm                                 CSD015
     C                   CAT       CLTAG(7):0    SeSecondParm                                 CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        W3UNCF = 'Y' and WInsert = 'N'                             CSD015
     C                   EVAL      WTradeRef = TDRF                                           CSD015
     C                   EVAL      WToFromInd = *Blanks                                       CSD015
                                                                                              CSD015
     C     WTradeRef     CHAIN     TRADSDY2                                                   CSD015
                                                                                              CSD015
     C                   IF        %FOUND(TRADSDY2)                                           CSD015
     C                   EXSR      SRExtDetails                                               CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PMCWL <> *Blanks                                           CSD015
     C                   CAT       PMCWL:0       SeSecondParm                                 CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Send transaction details to Compliance Watch                                         CSD015
                                                                                              CSD015
     C                   CALL      'SDCWLCHK'                                                 CSD015
     C                   PARM                    SEFirstParm                                  CSD015
     C                   PARM                    SESecondParm                                 CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
                                                                                              CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *  SRFormat - Converts watch list field to Customer Name and    *                       CSD015
      *             Address                                           *                       CSD015
      *                                                               *                       CSD015
      *  Called by : SRWatch                                          *                       CSD015
      *  Calls     :                                                  *                       CSD015
      *****************************************************************                       CSD015
                                                                                              CSD015
     C     SRFormat      BEGSR                                                                CSD015
                                                                                              CSD015
     C                   CALL      'SDCWLFMT'                                                 CSD015
     C                   PARM                    PRtcd                                        CSD015
     C                   PARM                    PINP1                                        CSD015
     C                   PARM                    PINP2                                        CSD015
     C                   PARM                    PINP3                                        CSD015
     C                   PARM                    PINP4                                        CSD015
     C                   PARM                    PINP5                                        CSD015
     C                   PARM                    PINP6                                        CSD015
     C                   PARM                    PCCY                                         CSD015
     C                   PARM                    POUT                                         CSD015
     C                   PARM                    PCUST                                        CSD015
                                                                                              CSD015
      ** Initialize to blanks the input parameters.                                           CSD015
                                                                                              CSD015
     C                   EVAL      PINP1 = *Blanks                                            CSD015
     C                   EVAL      PINP2 = *Blanks                                            CSD015
     C                   EVAL      PINP3 = *Blanks                                            CSD015
     C                   EVAL      PINP4 = *Blanks                                            CSD015
     C                   EVAL      PINP5 = *Blanks                                            CSD015
     C                   EVAL      PINP6 = *Blanks                                            CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
                                                                                              CSD015
      ****************************************************************                        CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *  SRCheck - Checks if Watch list has changed or not blanks     *                       CSD015
      *                                                               *                       CSD015
      *  Called by : INSERT, AMEND, CHANGE                            *                       CSD015
      *  Calls     :                                                  *                       CSD015
      *****************************************************************                       CSD015
                                                                                              CSD015
     C     SRCheck       BEGSR                                                                CSD015
                                                                                              CSD015
      ** Check if any of the fields is not blank                                              CSD015
                                                                                              CSD015
     C                   EVAL      WNotBlank = 'N'                                            CSD015
     C                   IF        (PYFM <> *Blanks or PAYT <> *Blanks or                     CSD015
     C**********                   TDFA <> *Blanks or DELT <> *Zeros or                CSD015 CSD027
     C**********                   DTFA <> *Blanks or DELF <> *Zeros or                CSD015 CSD027
     C                             TDFA <> *Blanks or DELT <> *Blanks or                      CSD027
     C                             DTFA <> *Blanks or DELF <> *Blanks or                      CSD027
     C                             DFFA <> *Blanks)                                           CSD015
     C                   EVAL      WNotBlank = 'Y'                                            CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PMCWL <> *Blanks                                           CSD015
     C                   EVAL      WNotBlank = 'Y'                                            CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check if any of the fields have changed                                              CSD015
                                                                                              CSD015
     C                   EVAL      WChanged = 'N'                                             CSD015
     C                   EVAL      WAmend1 = 'N'                                              CSD015
     C                   EVAL      WAmend2 = 'N'                                              CSD015
     C                   EVAL      WAmend3 = 'N'                                              CSD015
     C                   EVAL      WAmend4 = 'N'                                              CSD015
     C                   EVAL      WAmend5 = 'N'                                              CSD015
     C                   EVAL      WAmend6 = 'N'                                              CSD015
     C                   EVAL      WAmend7 = 'N'                                              CSD015
                                                                                              CSD015
     C                   IF        (PYFM <> CHPYFM and PYFM <> *Blanks)                       CSD015
     C                   EVAL      WChanged = 'Y'                                             CSD015
     C                   EVAL      WAmend1 = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        (PAYT <> CHPAYT and PAYT <> *Blanks)                       CSD015
     C                   EVAL      WChanged = 'Y'                                             CSD015
     C                   EVAL      WAmend2 = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        (TDFA <> CHTDFA and TDFA <> *Blanks)                       CSD015
     C                   EVAL      WChanged = 'Y'                                             CSD015
     C                   EVAL      WAmend3 = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C**********         IF        (DELT <> CHDELT and DELT <> *Zeros)                 CSD015 CSD027
     C                   IF        (DELT <> CHDELT and DELT <> *Blanks)                       CSD027
     C                   EVAL      WChanged = 'Y'                                             CSD015
     C                   EVAL      WAmend4 = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        (DTFA <> CHDTFA and DTFA <> *Blanks)                       CSD015
     C                   EVAL      WChanged = 'Y'                                             CSD015
     C                   EVAL      WAmend5 = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C**********         IF        (DELF <> CHDELF and DELF <> *Zeros)                 CSD015 CSD027
     C                   IF        (DELF <> CHDELF and DELF <> *Blanks)                       CSD027
     C                   EVAL      WChanged = 'Y'                                             CSD015
     C                   EVAL      WAmend6 = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        (DFFA <> CHDFFA and DFFA <> *Blanks)                       CSD015
     C                   EVAL      WChanged = 'Y'                                             CSD015
     C                   EVAL      WAmend7 = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PMCWL <> *Blanks                                           CSD015
     C                   EVAL      WChanged  = 'Y'                                            CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
                                                                                              CSD015
                                                                                              CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *  SRExtDetails - Format Extension Details Fields               *                       CSD015
      *                                                               *                       CSD015
      *  Called by : SRWatch                                          *                       CSD015
      *  Calls     :                                                  *                       CSD015
      *****************************************************************                       CSD015
                                                                                              CSD015
     C     SRExtDetails  BEGSR                                                                CSD015
                                                                                              CSD015
     C                   EVAL      PMCWL = *Blanks                                            CSD015
                                                                                              CSD015
     C                   IF        T2AP1N <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2AP1N                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       OPTAG(8):0    PMCWL                                        CSD015
     C                   CAT       POUT:0        PMCWL                                        CSD015
     C                   CAT       CLTAG(8):0    PMCWL                                        CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2AFPN <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2AFPN                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       OPTAG(9):0    PMCWL                                        CSD015
     C                   CAT       POUT:0        PMCWL                                        CSD015
     C                   CAT       CLTAG(9):0    PMCWL                                        CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2AWIN <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2AWIN                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       OPTAG(10):0   PMCWL                                        CSD015
     C                   CAT       POUT:0        PMCWL                                        CSD015
     C                   CAT       CLTAG(10):0   PMCWL                                        CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2BOFN <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2BOFN                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       OPTAG(11):0   PMCWL                                        CSD015
     C                   CAT       POUT:0        PMCWL                                        CSD015
     C                   CAT       CLTAG(11):0   PMCWL                                        CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2IPYN <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2IPYN                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       OPTAG(12):0   PMCWL                                        CSD015
     C                   CAT       POUT:0        PMCWL                                        CSD015
     C                   CAT       CLTAG(12):0   PMCWL                                        CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2CTYN <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2CTYN                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       OPTAG(13):0   PMCWL                                        CSD015
     C                   CAT       POUT:0        PMCWL                                        CSD015
     C                   CAT       CLTAG(13):0   PMCWL                                        CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2SA1N <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2SA1N                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       OPTAG(14):0   PMCWL                                        CSD015
     C                   CAT       POUT:0        PMCWL                                        CSD015
     C                   CAT       CLTAG(14):0   PMCWL                                        CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2SKAN <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2SKAN                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       OPTAG(15):0   PMCWL                                        CSD015
     C                   CAT       POUT:0        PMCWL                                        CSD015
     C                   CAT       CLTAG(15):0   PMCWL                                        CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2DCTL <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2DCTL                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       OPTAG(16):0   PMCWL                                        CSD015
     C                   CAT       POUT:0        PMCWL                                        CSD015
     C                   CAT       CLTAG(16):0   PMCWL                                        CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2RSSN <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2RSSN                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       OPTAG(17):0   PMCWL                                        CSD015
     C                   CAT       POUT:0        PMCWL                                        CSD015
     C                   CAT       CLTAG(17):0   PMCWL                                        CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2DSSN <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2DSSN                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       OPTAG(18):0   PMCWL                                        CSD015
     C                   CAT       POUT:0        PMCWL                                        CSD015
     C                   CAT       CLTAG(18):0   PMCWL                                        CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2BSSN <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2BSSN                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       OPTAG(19):0   PMCWL                                        CSD015
     C                   CAT       POUT:0        PMCWL                                        CSD015
     C                   CAT       CLTAG(19):0   PMCWL                                        CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2INVE <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2INVE                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       OPTAG(20):0   PMCWL                                        CSD015
     C                   CAT       POUT:0        PMCWL                                        CSD015
     C                   CAT       CLTAG(20):0   PMCWL                                        CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **  Settlement Party Intermediary 1-9                                                   CSD015
                                                                                              CSD015
     C                   EVAL      TEMPDS = *Blanks                                           CSD015
                                                                                              CSD015
     C                   IF        T2IMD1 <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2IMD1                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       POUT:0        TEMPDS                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2IMD2 <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2IMD2                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       POUT:0        TEMPDS                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2IMD3 <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2IMD3                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       POUT:0        TEMPDS                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2IMD4 <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2IMD4                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       POUT:0        TEMPDS                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2IMD5 <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2IMD5                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       POUT:0        TEMPDS                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2IMD6 <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2IMD6                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       POUT:0        TEMPDS                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2IMD7 <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2IMD7                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       POUT:0        TEMPDS                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2IMD8 <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2IMD8                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       POUT:0        TEMPDS                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2IMD9 <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2IMD9                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       POUT:0        TEMPDS                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        TEMPDS <> *Blanks                                          CSD015
     C                   CAT       OPTAG(21):0   PMCWL                                        CSD015
     C                   CAT       TEMPDS:0      PMCWL                                        CSD015
     C                   CAT       CLTAG(21):0   PMCWL                                        CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **  Safekeeping Account Intermediary 1-9                                                CSD015
                                                                                              CSD015
     C                   EVAL      TEMPDS = *Blanks                                           CSD015
                                                                                              CSD015
     C                   IF        T2IMS1 <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2IMS1                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       POUT:0        TEMPDS                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2IMS2 <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2IMS2                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       POUT:0        TEMPDS                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2IMS3 <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2IMS3                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       POUT:0        TEMPDS                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2IMS4 <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2IMS4                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       POUT:0        TEMPDS                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2IMS5 <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2IMS5                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       POUT:0        TEMPDS                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2IMS6 <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2IMS6                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       POUT:0        TEMPDS                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2IMS7 <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2IMS7                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       POUT:0        TEMPDS                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2IMS8 <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2IMS8                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       POUT:0        TEMPDS                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2IMS9 <> *Blanks                                          CSD015
     C                   EVAL      PINP1 = T2IMS9                                             CSD015
     C                   EXSR      SRFormat                                                   CSD015
     C                   CAT       POUT:0        TEMPDS                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        TEMPDS <> *Blanks                                          CSD015
     C                   CAT       OPTAG(22):0   PMCWL                                        CSD015
     C                   CAT       TEMPDS:0      PMCWL                                        CSD015
     C                   CAT       CLTAG(22):0   PMCWL                                        CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        T2DIDN <> *Blanks                                          CSW210
     C                   EVAL      PINP1 = T2DIDN                                             CSW210
     C                   EXSR      SRFormat                                                   CSW210
     C                   CAT       OPTAG(23):0   PMCWL                                        CSW210
     C                   CAT       POUT:0        PMCWL                                        CSW210
     C                   CAT       CLTAG(23):0   PMCWL                                        CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        T2QFIN <> *Blanks                                          CSW210
     C                   EVAL      PINP1 = T2QFIN                                             CSW210
     C                   EXSR      SRFormat                                                   CSW210
     C                   CAT       OPTAG(24):0   PMCWL                                        CSW210
     C                   CAT       POUT:0        PMCWL                                        CSW210
     C                   CAT       CLTAG(24):0   PMCWL                                        CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDSR                                                                CSD015
                                                                                              CSD015
      *****************************************************************                       CRE020
      /EJECT                                                                                  CRE020
      *****************************************************************                       CRE020
      *                                                               *                       CRE020
      *  SRIdxTrn - Handles the advice index of the current           *                       CRE020
      *             transaction.                                      *                       CRE020
      *                                                               *                       CRE020
      *****************************************************************                       CRE020
     C     SRIdxTrn      BEGSR                                                                CRE020
                                                                                              CRE020
     C                   EVAL      KRefNo = TDRF                                              CRE020
                                                                                              CRE020
      ** Only process authorised transactions                                                 CRE020
                                                                                              CRE020
     C                   IF        RECI = 'L' or                                              CRE020
     C                             RECI = 'P' or                                              CRE020
     C                             RECI = 'R'                                                 CRE020
                                                                                              CRE020
      ** If not authorised, set authorise indicator to 'N' if record exist                    CRE020
                                                                                              CRE020
     C                   OPEN      READVCL1                                                   CRE020
     C     KADVC         CHAIN     READVCL1                                                   CRE020
     C                   IF        %FOUND                                                     CRE020
     C                   EVAL      RAUTHI = 'N'                                               CRE020
     C                   UPDATE    READVCD0                                                   CRE020
     C                   ENDIF                                                                CRE020
     C                   CLOSE     READVCL1                                                   CRE020
     C                   LEAVESR                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** For amend, process changes only if their is change insettlements                     CRE020
                                                                                              CRE020
     C                   IF        A_CHTP = 'C' or                                            CRE020
     C                             A_CHTP = 'A'                                               CRE020
                                                                                              CRE020
     C     A_SMTH        IFNE      B_SMTH                                                     CRE020
     C     TDTP          OREQ      'TP'                                                       CRE020
     C     A_PYFM        ANDNE     B_PYFM                                                     CRE020
     C     TDTP          OREQ      'TS'                                                       CRE020
     C     A_PAYT        ANDNE     B_PAYT                                                     CRE020
     C     A_TDMI        ORNE      B_TDMI                                                     CRE020
     C     A_TDER        ORNE      B_TDER                                                     CRE020
     C     *IN97         OREQ      '1'                                                        CRE020
     C     A_DELT        ANDNE     B_DELT                                                     CRE020
     C     *IN99         OREQ      '1'                                                        CRE020
     C     A_DELT        ANDNE     B_DELT                                                     CRE020
     C     *IN97         OREQ      '1'                                                        CRE020
     C     A_DELF        ANDNE     B_DELF                                                     CRE020
     C     *IN99         OREQ      '1'                                                        CRE020
     C     A_DELF        ANDNE     B_DELF                                                     CRE020
     C     A_NOML        ORNE      B_NOML                                                     CRE020
     C     A_TDVD        ORNE      B_TDVD                                                     CRE020
     C                   ELSE                                                                 CRE020
     C                   LEAVESR                                                              CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** If all conditions met, continue processing                                           CRE020
                                                                                              CRE020
     C                   OPEN      READVCL1                                                   CRE020
     C     KADVC         CHAIN     READVCL1                                                   CRE020
                                                                                              CRE020
     C                   IF        NOT %FOUND                                                 CRE020
     C                   EXSR      SRChgTyp                                                   CRE020
     C                   EVAL      RREFNO = TDRF                                              CRE020
     C                   EVAL      RPRGMN = 'SETRADUPD'                                       CRE020
     C                   EVAL      RSEQNO = *BLANKS                                           CRE020
     C                   EVAL      RTRTYP = TDTP                                              CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
                                                                                              CRE020
      ** If action is delete and record not existing, set record as not to process            CRE020
                                                                                              CRE020
     C                   IF        A_CHTP = 'D'                                               CRE020
     C                   EVAL      RSAPIN = 'Y'                                               CRE020
     C                   ELSE                                                                 CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   EVAL      RENARR = *Blanks                                           CRE020
     C                   WRITE     READVCD0                                                   CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        RCHTYP = 'I' and                                           CRE020
     C                             RSAPIN = 'N'                                               CRE020
                                                                                              CRE020
     C                   IF        A_CHTP = 'D' or                                            CRE020
     C                             (A_CHTP = 'Y' and                                          CRE020
     C                              WOrgCHTP = 'D')                                           CRE020
     C                   EVAL      RCHTYP = 'D'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'Y'                                               CRE020
     C                   UPDATE    READVCD0                                                   CRE020
     C                   CLOSE     READVCL1                                                   CRE020
     C                   LEAVESR                                                              CRE020
     C                   ELSE                                                                 CRE020
     C                   IF        A_CHTP = 'A' or                                            CRE020
     C                             A_CHTP = 'C' or                                            CRE020
     C                             (A_CHTP = 'Y' and                                          CRE020
     C                              WOrgCHTP = 'A') or                                        CRE020
     C                             (A_CHTP = 'Y' and                                          CRE020
     C                              WOrgCHTP = 'C')                                           CRE020
     C                   EVAL      RCHTYP = 'I'                                               CRE020
     C                   ELSE                                                                 CRE020
     C                   EXSR      SRChgTyp                                                   CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
     C                   EXSR      SRChgTyp                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   UPDATE    READVCD0                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   CLOSE     READVCL1                                                   CRE020
     C                   ENDSR                                                                CRE020
      ****************************************************************                        CRE020
      /EJECT                                                                                  CRE020
      *****************************************************************                       CRE020
      *                                                               *                       CRE020
      *  SRChgTyp - Detemine Change Type                              *                       CRE020
      *                                                               *                       CRE020
      *****************************************************************                       CRE020
     C     SRChgTyp      BEGSR                                                                CRE020
                                                                                              CRE020
      ** Change Type (RCHTYP) should be 'A', 'D' or 'I'                                       CRE020
                                                                                              CRE020
     C                   SELECT                                                               CRE020
     C                   WHEN      CHTP = 'C'                                                 CRE020
     C                   EVAL      RCHTYP = 'A'                                               CRE020
     C                   WHEN      CHTP = 'P' or                                              CRE020
     C                             CHTP = 'Y'                                                 CRE020
     C                   EVAL      RCHTYP = WOrgCHTP                                          CRE020
     C                   OTHER                                                                CRE020
     C                   EVAL      RCHTYP = CHTP                                              CRE020
     C                   ENDSL                                                                CRE020
                                                                                              CRE020
     C                   ENDSR                                                                CRE020
      ****************************************************************                        CRE020
      ****************************************************************                        CSD015
      /EJECT
      *****************************************************************
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
     C                   PARM                    @@RTCD            7
     C                   PARM                    SEVTRD
     C                   PARM                    SEVTRDX1A
     C                   PARM                    SEVTRDX1B
     C                   PARM                    S01401            1
     C                   PARM                    CSW003            1            154562
     C                   PARM                    CAP051            1            CAP051
     C                   PARM                    CAS006                                       CAS006
     C                   PARM                    CGL031                                       CGL031
     C                   PARM                    PMODE                                        210517
     C                   PARM                    PMCWL                                        CSD015
     C                   PARM                    SEVTRDX2A                                    CSE045
     C                   PARM                    SEVTRDX2B                                    CSE045
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *
      ** GET BASE CURRENCY DECIMAL PLACES
      *
     C                   MOVE      BJCYCD        @AJCD
     C                   EXSR      AOCURR
     C                   MOVE      A6NBDP        BseCcyDec         1 0
     C                   MOVE      A6MDIN        BseCcyMDI         1
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      ** ACCESS MIDAS MODULE DETAILS
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      ** ACCESS SECURITIES TRADING DETAILS
      *
     C                   CALLB     'AOSTRDR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDSTRDPD'    DBFILE                         *************
     C                   MOVEL     '903'         DBASE                          * DBERR 900 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *                                                                         CAP051
     C                   MOVE      BVAUTH        SAVAUTH           2            CAP051
      *
      ** ACCESS PORTFOLIO MANAGEMENT DETAILS
      *
     C     BGPFMG        IFEQ      'Y'
     C                   CALLB     'AOPORTR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDPORT        PARM      SDPORT        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE                         *************
     C                   MOVEL     '904'         DBASE                          * DBERR 900 *
     C                   EXSR      SRERR                                        *************
     C                   END
     C                   END
     C/COPY WNCPYSRC,SETRADDC12
      **********                                                                      CAP084 BUG7029
     C******DTAARA       DEFINE                  ZMUSER                               CAP084 BUG7029
     C**********         IN        ZMUSER                                             CAP084 BUG7029
     C**********         EVAL      PSUser = PUSRID                                    CAP084 BUG7029
      **********                                                                      CAP084 BUG7029
      **********                                                                             BUG8260
      *****************************************************************                      BUG8260
      **GET*USER*DETAILS***********************************************                      BUG8260
      *****************************************************************                      BUG8260
     C*****PSUser        CHAIN     MUSER                              99                     BUG8260
      **********                                                                             BUG8260
      **DATABASE*ERROR*************************************************                      BUG8260
      **********                                                                             BUG8260
     C******IN99         IFEQ      '1'                                                       BUG8260
     C*****MUSR_RECI     ORNE      'D'                                                       BUG8260
     C**********         MOVEL     PSUser        DBKEY                                       BUG8260
     C**********         MOVEL     'MUSER'       DBFILE                                      BUG8260
     C**********         MOVEL     '905'         DBASE                                       BUG8260
     C**********         EXSR      SRERR                                                     BUG8260
     C**********         END                                                                 BUG8260
      *                                                                         CDE001
      ** Determine if Data Export for CCRM Limits is active                     CDE001
     C                   CALL      'AOSARDR0'                                   CDE001
     C                   PARM      *BLANKS       @RTCD                          CDE001
     C                   PARM      '*VERIFY'     @OPTN                          CDE001
     C                   PARM      'CDE001'      @SARD             6            CDE001
      *                                                                         CDE001
     C     @RTCD         IFEQ      *BLANK                                       CDE001
     C                   MOVEL     'Y'           CDE001            1            CDE001
     C                   ENDIF                                                  CDE001
      *                                                                         CSE023
      ** Check if enhancement 'Treaty withholding tax' is on.                   CSE023
      *                                                                         CSE023
     C                   CALLB     'AOSARDR0'                                   CSE023
     C                   PARM      *BLANKS       @RTCD                          CSE023
     C                   PARM      '*VERIFY'     @OPTN                          CSE023
     C                   PARM      'CSE023'      @SARD                          CSE023
      *                                                                         CSE023
      ** Check for Database error                                               CSE023
      *                                                                         CSE023
     C     @RTCD         IFNE      *BLANKS                                      CSE023
     C     @RTCD         ANDNE     '*NRF   '                                    CSE023
     C                   MOVEL     'CSE023'      DBKEY                          CSE023
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSE023
     C                   MOVEL     '906'         DBASE                          CSE023
     C                   EXSR      SRERR                                        CSE023
     C                   ENDIF                                                  CSE023
      *                                                                         CSE023
     C     @RTCD         IFEQ      *BLANK                                       CSE023
     C                   MOVE      'Y'           CSE023            1            CSE023
     C                   ELSE                                                   CSE023
     C                   MOVE      'N'           CSE023                         CSE023
     C                   ENDIF                                                  CSE023
      *                                                                                       CSE039
      ** Check if enhancement CSE039 is on.                                                   CSE039
     C                   CALLB     'AOSARDR0'                                                 CSE039
     C                   PARM      *BLANKS       @RTCD                                        CSE039
     C                   PARM      '*VERIFY'     @OPTN                                        CSE039
     C                   PARM      'CSE039'      @SARD                                        CSE039
      *                                                                                       CSE039
      ** Check for Database error                                                             CSE039
      *                                                                                       CSE039
     C     @RTCD         IFNE      *BLANKS                                                    CSE039
     C     @RTCD         ANDNE     '*NRF   '                                                  CSE039
     C                   MOVEL     'CSE039'      DBKEY                                        CSE039
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE039
     C                   MOVEL     '906'         DBASE                                        CSE039
     C                   EXSR      SRERR                                                      CSE039
     C                   ENDIF                                                                CSE039
      *                                                                                       CSE039
     C     @RTCD         IFEQ      *BLANK                                                     CSE039
     C                   MOVE      'Y'           CSE039            1                          CSE039
     C                   ELSE                                                                 CSE039
     C                   MOVE      'N'           CSE039                                       CSE039
     C                   ENDIF                                                                CSE039
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *BLANKS                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C**********         IN        SDSTAT                                              CSC011 CSD015
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 907                                                CSC011
     C                   EXSR      SRERR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** Check if enhancement 'API Extended Settlements' is on.                               CSE045
      *                                                                                       CSE045
     C                   CALLB     'AOSARDR0'                                                 CSE045
     C                   PARM      *BLANKS       @RTCD                                        CSE045
     C                   PARM      '*VERIFY'     @OPTN                                        CSE045
     C                   PARM      'CSE045'      @SARD                                        CSE045
      *                                                                                       CSE045
      ** Check for Database error                                                             CSE045
      *                                                                                       CSE045
     C     @RTCD         IFNE      *BLANKS                                                    CSE045
     C     @RTCD         ANDNE     '*NRF   '                                                  CSE045
     C                   MOVEL     'CSE045'      DBKEY                                        CSE045
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE045
     C                   MOVEL     '912'         DBASE                                        CSE045
     C                   EXSR      SRERR                                                      CSE045
     C                   ENDIF                                                                CSE045
      *                                                                                       CSE045
     C     @RTCD         IFEQ      *BLANK                                                     CSE045
     C                   MOVE      'Y'           CSE045            1                          CSE045
     C                   ELSE                                                                 CSE045
     C                   MOVE      'N'           CSE045                                       CSE045
     C                   ENDIF                                                                CSE045
      *                                                                                       CSE045
     C                   IN        SDSTAT                                                     CSD015
                                                                                              CSD015
      ** Check if Compliance Watch Enhancement (CSD015) is on.                                CSD015
                                                                                              CSD015
     C                   EVAL      CSD015 = 'N'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *Blank        PRtCd                                        CSD015
     C                   PARM      '*VERIFY'     POptn                                        CSD015
     C                   PARM      'CSD015'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
     C                   IF        (PRtCd <> *Blank) and                                      CSD015
     C                             (PRtCd <> '*NRF   ')                                       CSD015
     C                   EVAL      DBKey = 'CSD015'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 908                                                CSD015
     C                   EXSR      SrErr                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRtCd = *Blank                                             CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check if CCF001 is installed                                                         CSD015
                                                                                              CSD015
     C                   EVAL      CCF001 = 'N'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *Blanks       PRtCd                                        CSD015
     C                   PARM      '*VERIFY'     POptn                                        CSD015
     C                   PARM      'CCF001'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRtCd <> *BLANKS) and                                     CSD015
     C                             (PRtCd <> '*NRF   ')                                       CSD015
     C                   EVAL      DBKEY = 'CCF001'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 909                                                CSD015
     C                   EXSR      SrErr                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRtCd = *BLANKS                                            CSD015
     C                   EVAL      CCF001 = 'Y'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Call access program AOCWCDR0 for Private Customer                                    CSD015
      ** Industry Code                                                                        CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
     C                   CALL      'AOCWCDR0'                                                 CSD015
     C                   PARM      *Blanks       PRtCd                                        CSD015
     C                   PARM      '*FIRST '     POptn                                        CSD015
     C     SDCWCD        PARM      SDCWCD        DSFDY                                        CSD015
                                                                                              CSD015
      ** If no record is found on SDCWCDPD                                                    CSD015
                                                                                              CSD015
     C                   IF        PRtCd <> *BLANKS                                           CSD015
     C                   EVAL      DBKEY = '*FIRST'                                           CSD015
     C                   EVAL      DBFILE = 'SDCWCDPD'                                        CSD015
     C                   EVAL      DBase = 910                                                CSD015
     C                   EXSR      SrErr                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check if function code is being monitored by the compliance watch                    CSD015
                                                                                              CSD015
     C                   CALLB     'AOWLCCR0'                                                 CSD015
     C                   PARM      *Blanks       PRtCd                                        CSD015
     C                   PARM      '*KEY   '     POptn                                        CSD015
     C                   PARM      'SECTTRAD'    PFunc                                        CSD015
     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
                                                                                              CSD015
      ** If return code not blank, then issue database errror                                 CSD015
                                                                                              CSD015
     C                   IF        PRtCd <> *Blank and                                        CSD015
     C                             (PRtCd <> '*NRF   ')                                       CSD015
     C                   EVAL      DBKey = 'SECTTRAD'                                         CSD015
     C                   EVAL      DBFile = 'SDWLCCPD'                                        CSD015
     C                   EVAL      DBase = 911                                                CSD015
     C                   EXSR      SrErr                                                      CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check if CRE020 is enabled.                                                          CRE020
                                                                                              CRE020
     C                   CALLB     'AOSARDR0'                                                 CRE020
     C                   PARM      *BLANKS       PRtCd                                        CRE020
     C                   PARM      '*VERIFY'     POptn                                        CRE020
     C                   PARM      'CRE020'      PSARD                                        CRE020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE020
                                                                                              CRE020
     C                   EVAL      CRE020 = 'N'                                               CRE020
                                                                                              CRE020
     C                   IF        PRtCd = *BLANKS                                            CRE020
     C                   EVAL      CRE020 = 'Y'                                               CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        PRtCd <> '*NRF'                                            CRE020
     C     *LOCK         IN        LDA                                                        CRE020
     C                   EVAL      DBFile = 'SCSARDPD'                                        CRE020
     C                   EVAL      DBKey = 'CRE020'                                           CRE020
     C                   EVAL      DBase = 912                                                CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      SRErr                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Check if a System Value exists for this maintenance.                                 CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
                                                                                              CRE020
     C                   CALLB     'AOSVALR0'                                                 CRE020
     C                   PARM      *BLANKS       PRtCd                                        CRE020
     C                   PARM                    PSysVal01                                    CRE020
     C                   PARM                    PCurSet01                                    CRE020
     C                   PARM                    PSysVal02                                    CRE020
     C                   PARM                    PCurSet02                                    CRE020
     C                   PARM                    PSysVal03                                    CRE020
     C                   PARM                    PCurSet03                                    CRE020
     C                   PARM                    PSysVal04                                    CRE020
     C                   PARM                    PCurSet04                                    CRE020
     C                   PARM                    PSysVal05                                    CRE020
     C                   PARM                    PCurSet05                                    CRE020
     C                   PARM                    PSysVal06                                    CRE020
     C                   PARM                    PCurSet06                                    CRE020
     C                   PARM                    PSysVal07                                    CRE020
     C                   PARM                    PCurSet07                                    CRE020
     C                   PARM                    PSysVal08                                    CRE020
     C                   PARM                    PCurSet08                                    CRE020
     C                   PARM                    PSysVal09                                    CRE020
     C                   PARM                    PCurSet09                                    CRE020
     C                   PARM                    PSysVal10                                    CRE020
     C                   PARM                    PCurSet10                                    CRE020
                                                                                              CRE020
     C                   EVAL      WSysVal01 = 'N'                                            CRE020
                                                                                              CRE020
     C                   IF        PRtCd = *BLANKS                                            CRE020
     C                   MOVEL     PCurSet01     WSysVal01                                    CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        PRtCd <> '*NRF'                                            CRE020
     C     *LOCK         IN        LDA                                                        CRE020
     C                   EVAL      DBFile = 'SDSVALPD'                                        CRE020
     C                   EVAL      DBase = 913                                                CRE020
     C                   EVAL      DBKey = PSysVal01                                          CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      SRErr                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CSD083
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALLB     'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRtCd                                        CSD083
     C                   PARM      '*VERIFY'     POptn                                        CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRtCd <> *BLANKS AND                                       CSD083
     C                             PRtCd <> '*NRF'                                            CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBKey = 'CSD083'                                           CSD083
     C                   EVAL      DBase = 914                                                CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      SRErr                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRtCd = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C/COPY WNCPYSRC,SETRADDC08
     C*
     C* Define key list for file INVTP
     C*
     C     KLINVT        KLIST
     C                   KFLD                    NMCY
     C                   KFLD                    SITP
     C*
     C* Define key list for file BKPHD
     C*
     C     KLBKPH        KLIST
     C                   KFLD                    BHSC
     C                   KFLD                    BHBA
     C                   KFLD                    BHBK
     C                   KFLD                    BHMK
     C                   KFLD                    BHTV
     C*
     C* Define key list for file BKPOS
     C*
     C     KLBKPS        KLIST
     C                   KFLD                    BPSC
     C                   KFLD                    BPBA
     C                   KFLD                    BPBK
     C                   KFLD                    BPMK
     C                   KFLD                    BPTV
     C                   KFLD                    BPPD
     C*
     C* Define key list for file CPOSN
     C*
     C     KLPOSN        KLIST
     C                   KFLD                    CSBA
     C                   KFLD                    CSSC
     C                   KFLD                    CSCN
     C*
     C* Define key list for file CDEPP
     C*
     C     KLCDEP        KLIST
     C                   KFLD                    CDPA
     C                   KFLD                    CDCN
     C                   KFLD                    CDSN
     C                   KFLD                    CDPT
     C                   KFLD                    CDMK
     C*
     C* Define key list for file UDEPP
     C*
     C     KLUDEP        KLIST
     C                   KFLD                    UDBA
     C                   KFLD                    UDSN
     C                   KFLD                    UDPT
     C                   KFLD                    UDBK
     C                   KFLD                    UDMK
     C*
     C* Define key list for file SETLE
     C*
     C     KLSETT        KLIST
     C                   KFLD                    SBCA
     C                   KFLD                    STDR
     C*
     C* Define key list for file SEPCBD
     C*
     C     KLSPCB        KLIST
     C                   KFLD                    BOKC
     C                   KFLD                    BRCA
     C                   KFLD                    SESN
     C                   KFLD                    MKTI
     C*
     C* Define key list for file SEPCCD
     C*
     C     KLSPCC        KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    BRCA
     C                   KFLD                    SESN
     C*
     C* Define key list for file TRADSDY1
     C*
     C     TRADSY1K      KLIST
     C                   KFLD                    A_TDRF
     C                   KFLD                    T1WHEN
                                                                                              210517
      ** Define Key list for TRADSDX2 file                                                    210517
                                                                                              210517
     C     KeyTrdX2      KLIST                                                                210517
     C                   KFLD                    TDRF                                         210517
     C                   KFLD                    PScreen                                      210517
      *                                                                                       CSE045
      ** Define key list for file TRADSDY2                                                    CSE045
      *                                                                                       CSE045
     C     TRADSY2K      KLIST                                                                CSE045
     C                   KFLD                    A_TDRF                                       CSE045
     C                   KFLD                    T2WHEN                                       CSE045
     C*
      ** Parameters in chaining SDCWHTPD                                                      CSD015
                                                                                              CSD015
     C     KTradChk      KLIST                                                                CSD015
     C                   KFLD                    WFunction                                    CSD015
     C                   KFLD                    WIdentifier                                  CSD015
     C                   KFLD                    WBranch                                      CSD015
                                                                                              CSD015
     C     KExtDetl      KLIST                                                                CSD015
     C                   KFLD                    WTradeRef                                    CSD015
     C                   KFLD                    WToFromInd                                   CSD015
                                                                                              CSD015
      ** Midas RE Settled Transaction Index File Key List                                     CRE020
                                                                                              CRE020
     C     KADVC         KLIST                                                                CRE020
     C                   KFLD                    KRefNo                                       CRE020
     C                   KFLD                    KPrgMn                                       CRE020
                                                                                              CRE020
      ** Define key list for file BSPOSD (Reference:TDRF)                                   BUG12938
                                                                                            BUG12938
     C     KLPOSR        KLIST                                                              BUG12938
     C                   KFLD                    TDBA                                       BUG12938
     C                   KFLD                    TDBK                                       BUG12938
     C                   KFLD                    TDRF                                       BUG12938
      *                                                                                     BUG12938
      ** Define key list for file BSPOSD (Link:LKRF)                                        BUG12938
                                                                                            BUG12938
     C     KLPOSL        KLIST                                                              BUG12938
     C                   KFLD                    TDBA                                       BUG12938
     C                   KFLD                    TDBK                                       BUG12938
     C                   KFLD                    LKRF                                       BUG12938
      *                                                                                     BUG12938
***********************************************************************                236705 234440
     C******LIKE         DEFINE    TDBA          WBrca                                 236705 234440
     C******LIKE         DEFINE    TDSS          WSesn                                 236705 234440
     C******LIKE         DEFINE    TDTP          WType                                 236705 234440
     C******LIKE         DEFINE    NOML          WAmt                                  236705 234440
     C******LIKE         DEFINE    TDVD          WDate                                 236705 234440
     C******LIKE         DEFINE    TDVD          WrkAPDT                               236705 234440
     C******LIKE         DEFINE    ITRA          WrkCSPI                               236758 234440
     C     *LIKE         DEFINE    TMST          PTMST                                        235546
     C                   Z-ADD     *ZERO         NATN              5 0
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* SRERR - EXCEPTION ERRORS                                     *
     C*                                                              *
     C****************************************************************
     C     SRERR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'SETRADUPD'   DBPGM            10
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C*
     C**  TERMINATE THE PROGRAM
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
      *********************************************************************
      ** FIELD LOG
      *********************************************************************
      **                                      SET IN     SET IN
      **                                    VALIDATION    THIS    AMENDABLE
      **                                     FUNCTION   FUNCTION
      *********************************************************************
      ** Record Id                    RECI                YES       YES
      ** Trade Reference              TDRF     YES
      ** Incomplete Indicator      TR TINC     YES                  YES
      ** Security Shortname        TR TDSS     YES                  YES
      ** Counterparty Customer Number TCNR     YES                  YES
      ** Trade Type                TR TDTP     YES                  YES
      ** Nominal                      NOML     YES                  YES
      ** Nominal Currency             TNMC     YES
      ** Nominal decimal places       TNMD     YES
      ** Price/Discount/Yield         TPDY     YES                  YES
      ** Value Date                   TDVD     YES                  YES
      ** Branch code                  TDBA     YES                  YES
      ** Originating branch           ORBR     YES                  YES
      ** Book                      TR TDBK     YES                  YES
      ** Trade Date                TR TDDT     YES                  YES
      ** Trade Sub-type            TR TSUB     YES                  YES
      ** Link Reference               LKRF     YES                  YES
      ** Market Indicator             TDMI     YES                  YES
      ** Narrative                 TR TDNR     YES                  YES
      ** Trader I.D.               TR TDID     YES                  YES
      ** AIBD/IPMA                    AIIP     YES                  YES
      ** Market Centre                TMKC     YES                  YES
      ** Capacity                     TCAP     YES                  YES
      ** Accrued Indicator         TR ACIN     YES                  YES
      ** Days Adjustment              DADJ     YES                  YES
      ** Act/Diff indicator           ADIN     YES                  YES
      ** Interest Amount (Purchased)  ITRA     YES                  YES
      ** Interest Adjustment          TINA     YES                  YES
      ** Coupon Rate               TR TDCR     YES                  YES
      ** Price                     TR PRIC     YES                  YES
      ** Ex Dividend                  EXDV     YES                  YES
      ** Reallowance               TR RALL     YES                  YES
      ** Settlement Currency       TR SETC     YES                  YES
      ** Exchange Rate (Nominal to Ex TDER     YES                  YES
      ** Multiply/Divide Ind       TR TMDI     YES                  YES
      ** Base Currency Rate        TR TBCR     YES                  YES
      ** Settlement Method         TR SMTH     YES                  YES
      ** Pay From                     PYFM     YES                  YES
      ** Pay From Branch              PYFA     YES                  YES
      ** Pay To                    TR PAYT     YES                  YES
      ** Pay To Branch                PYTA     YES                  YES
      ** For Account of (Pay to)      TDFA     YES                  YES
      ** Account Sequence Number      ASNM     YES                  YES
      ** Clearance Type               CLTY     YES                  YES
      ** Deliver to                TR DELT     YES                  YES
      ** For Account of (Deliver to)  DTFA     YES                  YES
      ** Deliver From              TR DELF     YES                  YES
      ** 'For Account of-Deliver From DFFA     YES                  YES
      ** Special Instructions      TR TDSI     YES                  YES
      ** Priority Code             TR PRYC     YES                  YES
      ** Pay Code                  TR PCOD     YES                  YES
      ** Broker Commission Code       TBCC     YES                  YES
      ** Broker Commission Amount  TR TBCA     YES                  YES
      ** Customer Commission Code     TCCC     YES                  YES
      ** Customer Commission Amt   TR TCCA     YES                  YES
      ** Charges Code 1               TCC1     YES                  YES
      ** Charges Amount 1             TCA1     YES                  YES
      ** Charges Code 2               TCC2     YES                  YES
      ** Charges Amount 2             TCA2     YES                  YES
      ** Charges Code 3               TCC3     YES                  YES
      ** Charges Amount 3             TCA3     YES                  YES
      ** Charges Code 4               TCC4     YES                  YES
      ** Charges Amount 4             TCA4     YES                  YES
      ** Charges Code 5               TCC5     YES                  YES
      ** Charges amount 5             TCA5     YES                  YES
      ** Charges Code 6               TCC6     YES                  YES
      ** Charges Amount 6             TCA6     YES                  YES
      ** Charges Code 7               TCC7     YES                  YES
      ** Charges amount 7             TCA7     YES                  YES
      ** Tax amount                   TAXA     YES                  YES
      ** Broker Commission Rebate     BCMR     YES                  YES
      ** Customer Commission Rebate   CCMR     YES                  YES
      ** Tax Rebate                   TXRB     YES                  YES
      ** Bulk Reference               BLKR     YES
      ** Related Trade Reference      RTRF                YES
      ** Agency Trade Identifier      ATRD                YES
      ** Bulk Confirmation Required   BCON                YES
      ** Time of input                TIME                YES
      ** Auto-settle Indicator        AUTS     YES                  YES
      ** Accounting Indicator         TACI                YES       YES
      ** Message Indicator            TMSI                YES       YES
      ** Confirmation Required        TCFR                YES       YES
      ** Outstanding Nominal          TOSN                YES       YES
      ** Nominal Settled - not posted TNSN                YES       YES
      ** Nominal Settled - posted     TNSP                YES       YES
      ** Outstanding Value            TOSV                YES       YES
      ** Value Settled - not posted   TVSN                YES       YES
      ** Value Settled - posted       TVSP                YES       YES
      ** Discrepancy not posted       TDSN                YES       YES
      ** Discrepancy posted           TDSP                YES       YES
      ** Date Fully Settled           TDFS                YES       YES
      ** Settlement Sequence          TSSQ                YES       YES
      ** Consideration                TCSR     YES                  YES
      ** Countervalue                 TCTR     YES                  YES
      ** Date Made Complete           TDMC                YES
      ** Original Entry Date          TOED                YES
      ** Profit Centre - non PCA      PRFC     YES                  YES
      ** Pay/Receive Process Complete PRPC                YES       YES
      ** Last change date             LCD                 YES
      ** Type of last change          CHTP     YES                  YES
      ** Transact.no of last update   TNLU------------------------------
      ** Last swift sequence          LSWS                YES
      ** Current Factor               TCFC     YES                  YES
      ** Portfolio reference          PTFR     YES                  YES
      ** Exchange Rate (Settle > Port SPXR     YES                  YES
      ** Spot rate mult/div ind       SPMD     YES                  YES
      ** Book Profit Centre           BPRC     YES                  YES
      ** Trans Profit Centre          TPRC     YES                  YES
      ** FX Margin Points             FXMP     YES                  YES
      ** FX Margin Rate               FXMR     YES                  YES
      ** Margin Amount                MAMT     YES                  YES
      ** In Ccy in field 72           ICCY     YES                  YES
      ** Corporate Action Flag        COAF
      ** Withholding tax              WHTX     YES                              CSE023
**  CPY@
(c) Finastra International Limited 2001
** OPTAG - OPEN TAGS for XML                                                                  CSD015
<Pay From>                                                                                    CSD015
<Pay To>                                                                                      CSD015
<For Account of - Pay To>                                                                     CSD015
<Deliver To>                                                                                  CSD015
<For Account of - Deliver To>                                                                 CSD015
<Deliver From>                                                                                CSD015
<For Account of - Deliver From>                                                               CSD015
<MT510 A/C for Payment>                                                                       CSD015
<Account for Payment>                                                                         CSD015
<A/C with Institution>                                                                        CSD015
<Beneficiary>                                                                                 CSD015
<Instructing Party>                                                                           CSD015
<Counterparty>                                                                                CSD015
<MT510 Safekeeping A/C>                                                                       CSD015
<Safekeeping Account>                                                                         CSD015
<Deliverer Instructing Party>                                                                 CSD015
<Receivers of Securties>                                                                      CSD015
<Deliverers of Securities>                                                                    CSD015
<Beneficiary of Securities>                                                                   CSD015
<Investor>                                                                                    CSD015
<Settlement Party Intermediary>                                                               CSD015
<Safekeeping A/C Intermediary>                                                                CSD015
<Debtor>                                                                                      CSW210
<Qualified Foreign Intermediary>                                                              CSW210
** CLTAG - CLOSE TAGS for XML                                                                 CSD015
</Pay From>                                                                                   CSD015
</Pay To>                                                                                     CSD015
</For Account of - Pay To>                                                                    CSD015
</Deliver To>                                                                                 CSD015
</For Account of - Deliver To>                                                                CSD015
</Deliver From>                                                                               CSD015
</For Account of - Deliver From>                                                              CSD015
</MT510 A/C for Payment>                                                                      CSD015
</Account for Payment>                                                                        CSD015
</A/C with Institution>                                                                       CSD015
</Beneficiary>                                                                                CSD015
</Instructing Party>                                                                          CSD015
</Counterparty>                                                                               CSD015
</MT510 Safekeeping A/C>                                                                      CSD015
</Safekeeping Account>                                                                        CSD015
</Deliverer Instructing Party>                                                                CSD015
</Receivers of Securities>                                                                    CSD015
</Deliverers of Securities>                                                                   CSD015
</Beneficiary of Securities>                                                                  CSD015
</Investor>                                                                                   CSD015
</Settlement Party Intermediary>                                                              CSD015
</Safekeeping A/C Intermediary>                                                               CSD015
</Debtor>                                                                                     CSW210
</Qualified Foreign Intermediary>                                                             CSW210
**  CTDATA CMDDLY                                                                             223870
DLYJOB     DLY(10)                                                                            223870
