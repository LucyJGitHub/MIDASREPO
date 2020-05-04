     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBIA*  OVRDBF FILE(OTPAYOVR) TOFILE(OTPAY) SHARE(*NO)               *                       CAP211
/*XBIB*  OVRDBF FILE(OTXL0) TOFILE(OTPAYXL0) SHARE(*NO)               *                       CAP211
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Incoming payments database update')           *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAYUPD - Incoming Payments Database Update                *
      *                                                               *
      *  Function: This module performs the update of Midas database. *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYRPR                                      *
      *                FTIPAYUPP                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055030           Date 27Apr20               *
      *  Prev Amend No. MD054037           Date 23Sep19               *
      *                 CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD037804           Date 25May16               *
      *                 AR924677           Date 03Nov14               *
      *                 MD030940           Date 08Oct14               *
      *                 CFT157             Date 29Aug14               *
      *                 MD029681           Date 12Aug14               *
      *                 CFT151             Date 21Mar14               *
      *                 AR1084524          Date 13Feb13               *
      *                 CFT120             Date 28Sep12               *
      *                 BUG12944A          Date 28Sep12               *
      *                 CAP211             Date 28Sep12               *
      *                 261468             Date 10Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 AR787620           Date 10Jun11               *
      *                 CRE075             Date 06Dec10               *
      *                 BUG23088           Date 26Feb09               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 03Mar10               *
      *                 CAP204             Date 09Feb10               *
      *                 260326             Date 18Jun09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 257487             Date 04Nov08               *
      *                 256564             Date 17Sep08               *
      *                 238060             Date 25Sep07               *
      *                 BUG14585           Date 15Aug07               *
      *                 247277             Date 24May07               *
      *                 BUG13159           Date 29Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241810A            Date 04Sep06               *
      *                 241810             Date 29Aug06               *
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 219734             Date 06Jun06               *
      *                 CDL049             Date 06Jul06               *
      *                 240663             Date 29Jun06               *
      *                 240008             Date 23May06               *
      *                 208944             Date 18Sep01               *
      *                 237564             Date 21Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4776            Date 15Nov04               *
      *                 BUG4556            Date 19Oct04               *
      *                 CFT115             Date 01Jul04               *
      *                 BUG3854            Date 27Jul04               *
      *                 BUG3821            Date 27Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CRE020             Date 20Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001             Date 09Dec03               *
      *                 CAP084             Date 25Aug03               *
      *                 223687             Date 16Dec03               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 193883             Date 20Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185764             Date 01Nov00               *
      *                 CFT014             Date 25May99               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *  MD055030 - Issue on job names during SSL enabling of JDBC    *
      *              calls (Child: AR1088820)                         *
      *           - Duplicate records in INPAYDQD. Write to INPAYDQD  *
      *             file only if not from Java screen.                *
      *           - Applied for MD055645.                             *
      *  MD054037 - Outward payment routing from incoming (OPIN = Y)  *
      *             via API                                           *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD037804 - Unnecessary DUMP produced by FTIPAYUPD module     *
      *  AR924677 - Amend of an authorized payment should return it   *
      *             to an unauthorized state. (Child: AR924679)       *
      *  MD030940 - (CFT157) Error when inserting new payment.        *
      *  CFT157 - Stop FT Transaction after Authorisation.            *
      *  MD029681 - Serious Midas Error occurreddue to *LDA lock      *
      *             being not granted                                 *
      *  CFT151 - FT IN/OP Alphanumeric sequence                      *
      *  AR1084524 - Performance issue on IPAY & OPAY listview        *
      *              (Recompile)                                      *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  BUG12944A - FTC0510 00001 Failed                             *
      *  CAP211 - FT IN_OP APIs - Auto-Authorization of Payment       *
      *  261468 - Multiple access of the same payment should not be   *
      *           allowed                                             *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,FTH00104                                 *
      *             WNCPYSRC,FTH00102                                 *
      *             WNCPYSRC,FTH00108                                 *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG23088- Transactions using non-retail A/C format did not   *
      *           appear in the postings                              *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *  CAP204 - Teller Related APIs - Account Transfer              *
      *  260326 - Incorrect restoration of canceled ref seq number.   *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  257487 - Write to Incoming Payments extension file INPAYDQD  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  238060 - Update the timestamp field for extension file       *
      *           INPAYXPD with the correct value                     *
      * BUG14585 - Data for Auto is missing in Awaiting for           *
      *            Authorisation Enquiry                              *
      *  247277 - Allow for native JDBC driver as well as toolbox.    *
      * BUG13159 - After a successful update, the latest timestamp    *
      *            is not being passed back to the Java side. This    *
      *            later causes the WIP entry becoming impossible     *
      *            to authorise due to discrepancy between the        *
      *            timestamp initially stored in the WIP (which is    *
      *            incorrect) and the latest timestamp retreived from *
      *            INPAYDD when the amendment is being authorised.    *
      *            The timestamp in INPAYXPD is also not being        *
      *            updated properly.                                  *
      *            This actually is a lacking aspect of the fix done  *
      *            for BUG4196.                                       *
      *  241810A- Reverse fix 241810.                                 *
      *  241810 - Authorise indicator and authorising user are not    *
      *           updated when transaction has been authorised.       *
      *  CFT032 - Account Line in Field 50X in MT103                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *           Include conversion of customer number to alpha.     *
      *  219734 - Authorising User profile should be reset when a     *
      *           payment is amended.                                 *
      *           Applied fix 208944, annotated as 208944.            *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  240663 - Applied fix 229560.                                 *
      *  229560 - Dbase error when Beneficiary = IBAN and Add/Deduct. *
      *  240008 - Proj Ac update for partial a/c nos still wrong      *
      *         - Set-up parameter before calling AOSPOSU0. Patterned *
      *           from BUG3194.                                       *
      *  208944 - Reset authorizing profile on amend.                 *
      *  237564 - Shadow posting is incorrect when IBAN is used as    *
      *           Beneficiary input.                                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4776- Correct skipping of transaction reference.          *
      *  BUG4556- CWLCHECK job fails due to incorrect XML end tag     *
      *           for <A/C with Bank> tag.  Changed tag from          *
      *           </A/C with Bank > to </A/C with Bank>.              *
      *  CFT115 - Core changes for GBO015.                            *
      *           Incoming Payments Beneficiary Validation            *
      *                  - Upgrade to Midasplus                       *
      *           Core hooks amended:FTIPAYDC05,FTIPAYDF02,FTIPAYDC03,*
      *                              FTIPAYDD01,                      *
      *           Core hooks added:FTIPAYDC22,FTIPAYDC23,FTIPAYDC24   *
      *  BUG3854 - Shadow postings to partial accounts incorrect      *
      *  BUG3821 - Shadow postings incorrect due to 10 digit a/c code *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CGP001 - Recompiled due to change in FTV2OPYPD               *
      *  CAP084 - Thin Client API Wrappers                            *
      *           Bypass setting of PModeX to '*FRONT' if module      *
      *           is called from Midas Plus interface.                *
      *  223687 - FTIPAYUPD ends in DBERR in a system without         *
      *           Compliance Watch feature. Ensure CSD015 is ON prior *
      *           to calling Compliance Watch programs.               *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  CSC011 - 24x7 Midas Availability                             *
      *  193883 - To avoid DBerr set-up Front ID correctly.           *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  185764 - Shadow posting for charges are not updated.         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Incoming Payments file
     FINPAY     UF A E           K DISK    COMMIT
      *
      ** Incoming Payments trailer file
     FINPAYZZ   UF   E             DISK    COMMIT
      *
      ** Incoming Payments extension file
     FINPAYXL0  UF A E           K DISK    COMMIT
     FINPAYDQD  O    E             DISK    COMMIT                                             257487
      *                                                                                       CAP211
      ** Outgoing Payments file                                                               CAP211
      *                                                                                       CAP211
     FOTPAYOVR  UF A E           K DISK    COMMIT                                             CAP211
      *                                                                                       CAP211
      ** Outgoing Payments trailer file                                                       CAP211
      *                                                                                       CAP211
     FOTPAYZZ   UF   E             DISK    COMMIT PREFIX(O)                                   CAP211
      *                                                                                       CAP211
      ** Outgoing Payments extension file                                                     CAP211
      *                                                                                       CAP211
     FOTXL0     UF A E           K DISK    COMMIT                                             CAP211
      *                                                                                       CAP211
     FOTPAYDQD  O    E             DISK    COMMIT                                             CAP211
      *                                                                                       CAP211
     F/COPY WNCPYSRC,FTIPAYDF01
      *
      ** Accounts file
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
     F                                     PREFIX(AC)
      *
      ** Retail Accounts file
     FACNUMA    IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACNUMABF)
     F                                     PREFIX(AC)
                                                                                              CSD015
      ** Compliance Watch Hit List File                                                       CSD015
     FSDCWHTL1  IF   E           K DISK    COMMIT                                             CSD015
      *
     F*FTPREFL0**UF*A*E*************DISK*** COMMIT                                    BUG4776 260326
      *****************************************************************               BUG4776 260326
     F/COPY WNCPYSRC,FTIPAYDF02
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
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
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, Prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
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
      *                                                                                       CAP211
      ** System value of flag for Auto-Generation of Outgoing Payment                         CAP211
      *                                                                                       CAP211
     D SysValGOP       C                   CONST('CAP211GenerateOP')                          CAP211
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Incoming Payments for file update - Valid file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *                                                                         CFT014
      ** Incoming Payments Extension for file update - file format              CFT014
     D NwIP2FilFmt   E DS                  EXTNAME(FTVIPY2PD)                   CFT014
     D/COPY WNCPYSRC,FTH00164
      *
      ** Incoming Payments for file update - Midas file format
     D InPayUpdF     E DS                  EXTNAME(INPAYDD)
      *
      ** Incoming Payments retrieved from file - file format
     D CrIPFilFmt    E DS                  EXTNAME(INPAYDD)
     D                                     PREFIX(CH)
      *                                                                         CFT014
      ** Incoming Payments Extension for file update - file format              CFT014
     D CrIP2FilFmt   E DS                  EXTNAME(INPAYXPD)                    CFT014
      *
      ** Incoming Message FT data
     D PINFT         E DS                  EXTNAME(MEINFTPD)
     D/COPY WNCPYSRC,FTIPAYDD02
      *
      ** Incoming Message Log data
     D PINLF         E DS                  EXTNAME(MEINLFPD)
      *
      ** Externally described DS for Nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      *                                                                                       CRE020
     D/COPY WNCPYSRC,FTH00104
      ** Midas Switchable features file accessed via access program                           CRE020
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRE020
     D  SCLCD        E                     EXTFLD(LCD)                                        CRE020
      *                                                                                       CAP211
      ** Externally described DS for Bank details                                             CAP211
      *                                                                                       CAP211
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  CAP211
      *                                                                                       CAP211
      ** Externally described DS for Currency details                                         CAP211
      *                                                                                       CAP211
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  CAP211
      *                                                                                       CAP211
      ** Externally described DS for Branch details                                           CAP211
      *                                                                                       CAP211
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  CAP211
     D  A8QQDFAC     E                     EXTFLD(QQDFAC)                                     CAP211
      *                                                                                       CAP211
      ** Externally described DS for FT ICD details                                           CAP211
      *                                                                                       CAP211
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)                                  CAP211
      *                                                                                       CAP211
      ** Data area                                                                            CAP211
      *                                                                                       CAP211
     D*OTPAYD***     E DS                  EXTNAME(OTPAYDA)                            CAP211 CFT151
     D OTPAYD          DS             4                                                       CFT151
     D  WOTSQ                  1      4  0                                                    CFT151
                                                                                              CFT151
      *                                                                         CFT014
      ** Externally described DS for Nostro details                             CFT014
     D P@ACCN        E DS                  EXTNAME(ACCNTAB)                     CFT014
     D  IBNRECI      E                     EXTFLD(RECI)                         CFT014
     D  IBNBRCA      E                     EXTFLD(BRCA)                         CFT014
     D  IBNPRFC      E                     EXTFLD(PRFC)                         CFT014
     D  IBNLCD       E                     EXTFLD(LCD)                          CFT014
     D  IBNCHTP      E                     EXTFLD(CHTP)                         CFT014
     D  IBNFRNT      E                     EXTFLD(FRNT)                         CFT014
     D  IBNAFRT      E                     EXTFLD(AFRT)                         CFT014
     D  IBNREPA      E                     EXTFLD(REPA)                         CFT014
     D  IBNTMST      E                     EXTFLD(TMST)                         CFT014
     D  IBNREPI      E                     EXTFLD(REPI)                         CFT014
      ** DS for access programs - Short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *                                                                         CFT014
      ** DS for access programs - Second data structure                         CFT014
     D DSSDY         E DS                  EXTNAME(DSSDY)                       CFT014
                                                                                              CSC011
      ** Message Header Data Layout                                                           CSC011
     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  CSC011
                                                                                              CSC011
      ** 24X7 Status DataArea Layout                                                          CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD Status DataArea Layout                                                            CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      *
     D/COPY WNCPYSRC,FTIPAYDD01
      ** FT Control Data
     D PCNTRL          DS           256
     D  WPDTI                  1      1
     D  WCCYI                  2      3
     D  WGLUI                  4      4
     D  WTPCI                  5      5
      *
      ** Calling parameter data structure for AOSPOSU0
     D C_DTA           DS           256
     D  C_ATYP                 1      1
     D**C_ACCT**               2     19                                                       CGL029
     D**C_CNU1**               2      7  0                                                    CSD027
     D  C_CNU1                 2      7A                                                      CSD027
     D  C_CCY1                 8     10
     D**C_ACO1**              11     14  0                                                    CGL029
     D  C_ACS1                15     16  0
     D  C_BRC1                17     19
     D  C_NOSN                 2      3  0
     D  C_NOS                  2      6
     D  C_ACNO                 2     11  0
     D**C_CNUM**               2      7  0                                                    CSD027
     D  C_CNUM                 2      7A                                                      CSD027
     D**C_ACOD**               8     11  0                                                    CGL029
     D  C_ACSQ                12     13  0
     D  C_BRCA                14     16
     D  C_IO                  24     24
     D  C_CCY                 25     27
     D  C_TRYP                28     29
     D  C_NARR                30     59
     D  C_CHQN                60     67  0
     D  C_PRef                68     82
     D  C_TRN                 83     88
     D  C_AMT                 89     96P 0
     D  C_PRON                97     97
     D  C_OLPS                98     98
     D  C_MEMS                99     99
     D  C_RSAC               100    100
     D  C_MOD                101    102
     D  C_OLRC               103    104
     D  C_FTOV               105    105
     D  C_VDAT               106    108P 0
     D  C_PSTD               109    111P 0
     D  C_PSTO               112    112
     D  C_RPST               113    113
     D  C_RPNB               114    116  0
     D  C_RTYP               117    117
     D  C_BBRN               118    120  0                                                    CGL029
     D  C_ACO1               121    130  0                                                    CGL029
     D  C_ACOD               131    140  0                                                    CGL029
     D  C_OTR1               141    160                                                       CAP204
     D  C_MTYP               161    161                                                       CAP205
      *                                                                                       CLE134
      ** Exception Reference Id/Number                                                        CLE134
      *                                                                                       CLE134
     D  C_XRFI               162    164                                                       CLE134
     D  C_XRFN               165    174  0                                                    CLE134
                                                                                              CGL029
      ** Full General Ledger - CNUM/CCY/ACOD/ACSQ                                             CGL029
     D                 DS                                                                     CGL029
     D C_ACCT                  1     24                                                       CGL029
     D W_ACNO                  1     10  0                                                   BUG3821
     D W_NOS                   1      5                                                      BUG3821
     D W_NOSN                  1      2  0                                                   BUG3821
     D*W_CNU1***               1      6  0                                             CGL029 CSD027
     D W_CNU1                  1      6A                                                      CSD027
     D W_CCY1                  7      9                                                       CGL029
     D W_ACOD                  7     16  0                                                   BUG3854
     D W_ACSQ                 17     18  0                                                   BUG3854
     D W_ACO1                 10     19  0                                                    CGL029
     D W_ACS1                 20     21  0                                                    CGL029
     D W_BRC1                 22     24                                                       CGL029
      * Partial Account - CNUM/ACOD/ACSQ/BRCA                                                 240008
     D**P#CNUM**               1      6  0                                             240008 CSD031
     D  P#CNUM                 1      6A                                                      CSD031
     D  P#ACOD                 7     16  0                                                    240008
     D  P#ACSQ                17     18  0                                                    240008
     D  P#BRCA                19     21                                                       240008
                                                                                              CGL029
      *
      ** Define full account to be passed for FT IMM update
     D*WIACNT***       DS            18                                                       CGL029
     D WIACNT          DS            24                                                       CGL029
     D**WICNUM**               1      6  0                                                    CSD027
     D  WICNUM                 1      6A                                                      CSD027
     D  WICCY                  7      9
     D**WIACOD**              10     13  0                                                    CGL029
     D**WIACSQ**              14     15  0                                                    CGL029
     D**WIBRCA**              16     18                                                       CGL029
     D  WIACOD                10     19  0                                                    CGL029
     D  WIACSQ                20     21  0                                                    CGL029
     D  WIBRCA                22     24                                                       CGL029
      *
      ** Full account details
     D                 DS
     D**WSNDDS**               1     18                                                       CGL029
     D**WRCCDS**              19     36                                                       CGL029
     D**WBNCDS**              37     54                                                       CGL029
     D**WACBDS**              55     72                                                       CGL029
     D  WSNDDS                 1     24                                                       CGL029
     D  WRCCDS                25     48                                                       CGL029
     D  WBNCDS                49     72                                                       CGL029
     D  WACBDS                73     96                                                       CGL029
      *
      ** DS for full account
     D WACCNT          DS
     D**WACNUM**               1      6  0                                                    CSD027
     D  WACNUM                 1      6A                                                      CSD027
     D  WACCCY                 7      9
     D**WACCD***              10     13  0                                                    CGL029
     D**WACSQ***              14     15  0                                                    CGL029
     D**WBRCA***              16     18                                                       CGL029
     D  WACCD                 10     19  0                                                    CGL029
     D  WACSQ                 20     21  0                                                    CGL029
     D  WBRCA                 22     24                                                       CGL029
     D/COPY WNCPYSRC,FTH00484
      *
      ** DS for IBANs full account
     D PIBANAcc        DS
     D**IBCNUM**               1      6  0                                                    CSD027
     D  IBCNUM                 1      6A                                                      CSD027
     D  IBCCY                  7      9
     D**IBACOD**              10     13  0                                                    CGL029
     D**IBACSQ**              14     15  0                                                    CGL029
     D**IBBRCA**              16     18                                                       CGL029
     D  IBACOD                10     19  0                                                    CGL029
     D  IBACSQ                20     21  0                                                    CGL029
     D  IBBRCA                22     24                                                       CGL029
      *                                                                                       CAP211
      ** DS for PREF                                                                          CAP211
      *                                                                                       CAP211
     D                 DS                                                                     CAP211
     D  IPREF                  1     15                                                       CAP211
     D  P                      1      1    INZ('P')                                           CAP211
     D  RUNDYY                 2      3  0                                                    CAP211
     D  RUNDMD                 4      7  0                                                    CAP211
     D**PRNUM                  8     11  0                                             CAP211 CFT151
     D  PRNUM                  8     11                                                       CFT151
     D  PmntType              12     13                                                       CAP211
     D  StmtType              14     15  0                                                    CAP211
      *                                                                                       CAP211
     D FTDFAC          DS            18                                                       CAP211
     D  OBCNUM                 1      6                                                       CAP211
     D  OBACOD                 7     16  0                                                    CAP211
     D  OBACSQ                17     18  0                                                    CAP211
     D  OBFTAC                 1     18                                                       CAP211
      *                                                                                       CAP211
      ** Data structure used for FT0010                                                       CAP211
      *                                                                                       CAP211
     D P#0010          DS           256                                                       CAP211
     D  P#NDCY                 1      3                                                       CAP211
     D  P#NDAM                 4     10P 0                                                    CAP211
     D  P#DBCY                11     13                                                       CAP211
     D  P#DBAM                14     20P 0                                                    CAP211
     D  P#DBDT                21     23P 0                                                    CAP211
     D  P#CRCY                24     26                                                       CAP211
     D  P#CRAM                27     33P 0                                                    CAP211
     D  P#PDCY                34     36                                                       CAP211
     D  P#PDAM                37     43P 0                                                    CAP211
     D  P#CRDT                44     46P 0                                                    CAP211
     D  P#RATE                47     53P 8                                                    CAP211
     D  P#MDIN                54     54  0                                                    CAP211
     D  P#OVRT                55     55                                                       CAP211
     D  P#SDIN                56     56                                                       CAP211
     D  P#RTDS                57     59P 4                                                    CAP211
      *                                                                                       CAP211
     D  P#FRCY                11     13                                                       CAP211
     D  P#FRAM                14     20P 0                                                    CAP211
     D  P#FRDT                21     23P 0                                                    CAP211
     D  P#TOCY                24     26                                                       CAP211
     D  P#TOAM                27     33P 0                                                    CAP211
     D  P#TODT                44     46P 0                                                    CAP211
      *                                                                                       CAP211
     D  P#PMSQ                60     69                                                       CAP211
     D  P#INDC                70     74                                                       CAP211
     D  P#RTCD                75     81                                                       CAP211
     D  P#INTC                82     99  3                                                    CAP211
     D  P#INTD               100    117  3                                                    CAP211
     D/COPY WNCPYSRC,FTH00404
      *
      ** Midas Functions for Watch List Checking Details File                                 CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
                                                                                              CSD015
      ** Data Structure for Accessing SDCUSTPD                                                CSD015
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSD015
                                                                                              CSD015
      ** Data structure for 1st parameter of Watchlist Engine (SDCWLCHK)                      CSD015
     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)                                  CSD015
                                                                                              CSD015
      ** External DS for Compliance Watch Configuration Data File                             CSD015
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                  CSD015
                                                                                              CSD015
      ***DS*for*ZMUSER*details*****************************************               241810 241810A
     D*ZMUSER***       DS            17                                               241810 241810A
     D**PUSRID**               1     10                                               241810 241810A
     D/COPY WNCPYSRC,FTH00405
                                                                                      241810 241810A
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D Idx             S              3P 0
      *
      ** Timestamp for the transaction
     D PTimestamp      S               Z
      *
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D PDummyMsgID     S                   LIKE(#MsgID)
     D PDummyMsgF      S             10A
      *
      ** Work variable for accesing full details of account
     D WAXSBY          S              6
                                                                                              CSC011
      ** 24X7 Midas Availability switchable field                                             CSC011
     D CSC011          S              1A                                                      CSC011
                                                                                              CSC011
      ** Transaction Detail Field                                                             CSC011
     D TRANSDTL        S           5800A                                                      CSC011
                                                                                              CSC011
      ** Payment Reference                                                                    CSC011
     D*PREFERENCE      S             18A                                               CSC011 CGL029
     D*PAREFERENCE     S             18A                                               CSC011 CGL029
     D PREFERENCE      S             24A                                                      CGL029
     D PAREFERENCE     S             24A                                                      CGL029
                                                                                              CSC011
      ** Action Code Indicator                                                                CSC011
     D PACTN           S              1A                                                      CSC011
                                                                                              CSC011
      ** Log Time Stamp field                                                                 CSC011
     D PTIMESTMP       S             26A                                                      CSC011
                                                                                              CSC011
      ** Data structure for 2nd parameter of SDCWLCHK                                         CSD015
     D PString         DS         30000                                                       CSD015
                                                                                              CSD015
      ** Switchable features - Watch List Checking                                            CSD015
     D CSD015          S              1A                                                      CSD015
                                                                                              CSD015
      ** Concorde Interface Development feature                                               CSD015
     D CCF001          S              1A                                                      CSD015
                                                                                              CSD015
      ** ZACVTDATE Parameters                                                                 CSD015
     D PZADayNo        S              5                                                       CSD015
     D PZADDT          S               D                                                      CSD015
     D PZACvtDt        S             10                                                       CSD015
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
     D Fld6            S             35                                                       CSD015
     D WCustomer       S             30                                                       CSD015
     D WUNCFL          S              1                                                       CSC011
     D WFUNT           S              8                                                       CSC011
     D WIDEN           S             30                                                       CSC011
     D PFunc           S              8                                                       CSD015
     D WCtrpRpt        S             30                                                       CSD015
     D WCtrpTyp        S              1                                                       CSD015
     D PCustNo         S             10A                                                      CSD015
     D PErrInf         S              7A                                                      CSD015
     D U               S              2  0                                                    CSD015
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D KIDEN           S             40                                                       CSC011
     D WRevAst         S              1                                                       CRE020
     D CRE020          S              1                                                       CRE020
     D PNAccN          S             10A                                                      CGL029
     D WFRWR           S             24A                                                      CGL029
     D WTOWR           S             24A                                                      CGL029
     D CSW209          S              1A                                                      CSW209
     D CAP205          S              1A                                                      CAP205
     D/COPY WNCPYSRC,FTH00556
                                                                                              CSD015
      ** Watch List Description Array                                                         CSD015
     D***WLARR***         S             35    DIM(24) CTDATA PERRCD(1)                 CSD015 CSW209
     DWLARR            S             35    DIM(36) CTDATA PERRCD(1)                           CSW209
      *                                                                                       CAP211
     D POWERS          S              7  3 DIM(7) CTDATA PERRCD(1)                            CAP211
     D @DFT            S             35    DIM(1) CTDATA PERRCD(1)                            CAP211
      *                                                                                       CFT120
      ** CFT120 switchable field                                                              CFT120
      *                                                                                       CFT120
     D CFT120          S              1A                                                      CFT120
      *                                                                                       CFT151
      ** CFT151 switchable field                                                              CFT151
      *                                                                                       CFT151
     D CFT151          S              1A                                                      CFT151

     D/COPY WNCPYSRC,FTH00165
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Check for update by another workstation.
      *
     C                   EXSR      SRChkOthUpd
      *
      ** Continue processing if no errors found.
      *
     C                   IF        RetCodeIn = *BLANKS
      *
      ** Clear all positions in store.
      *
     C/COPY WNCPYSRC,FTH00450
      *                                                                                       CFT157
     C     @CFT157       IFEQ      'Y'                                                        CFT157
     C     IPCHTP        ANDEQ     'S'                                                        CFT157
     C                   ELSE                                                                 CFT157
      *                                                                                       CFT157
     C                   EXSR      SRClr
     C/COPY WNCPYSRC,FTH00451
     C                   ENDIF                                                                CFT157
      *
      ** Blank out temporary variable for Change Type.
      *
     C                   MOVE      *BLANK        WCHTP             1
     C                   EVAL      PACTN = IPCHTP                                             CSC011
     ******************************************************************               241810 241810A
     ***Update*authorising*user*and*authorising*indicator**************               241810 241810A
     ******************************************************************               241810 241810A
     C**********         IF        IPAUP1 = *Blanks                                   241810 241810A
     C**********         EVAL      IPAUP1 = PUSRID                                    241810 241810A
     C**********         EVAL      IPAUIN = 'Y'                                       241810 241810A
     C**********         ELSE                                                         241810 241810A
     C**********         EVAL      IPAUP2 = PUSRID                                    241810 241810A
     C**********         EVAL      IPAUIN = 'Y'                                       241810 241810A
     C**********         ENDIF                                                        241810 241810A
      *
      ** Perform corresponding processing for Insert, Amend and Delete.
      *
     C     IPCHTP        CASEQ     'I'           SRInsert
     C     IPCHTP        CASEQ     'A'           SRAmend
     C     IPCHTP        CASEQ     'D'           SRDelete
     C/COPY WNCPYSRC,FTH00452
     C     IPCHTP        CASEQ     'S'           SRStop                                       CFT157
     C                   ENDCS
                                                                                              CSC011
      ** Log transaction by calling the LOG module                                            CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (LIBR = S1SUPP)                         CSC011
     C                   IF        (PACTN = 'I') OR (PACTN = 'A') OR                          CSC011
     C                             (PACTN = 'D')                                              CSC011
     C                             OR (PACTN = 'S') AND (@CFT157 = 'Y')                       CFT157
     C/COPY WNCPYSRC,FTH00455
     C                   EXSR      SRLOGTRAN                                                  CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
     C/COPY WNCPYSRC,FTIPAYDC04
      *
     C     @CFT157       IFEQ      'Y'                                                        CFT157
     C     IPCHTP        ANDEQ     'S'                                                        CFT157
     C                   ELSE                                                                 CFT157
      *                                                                                       CFT157
      ** Clear all positions in store.
      *
     C                   EXSR      SRClr
     C/COPY WNCPYSRC,FTH00453
     C                   Endif                                                                CFT157
      *
      ** Call CL program to deallocate this reference to a dataarea                           261468
      *                                                                                       261468
     C                   EVAL      C#RTCD = *Blanks                                           261468
     C                   EVAL      @MODLE = 'FT'                                              261468
     C                   EVAL      @TREF  = *Blanks                                           261468
     C                   EVAL      @RTINF = *Blanks                                           261468
      *                                                                                       261468
     C                   CALL      'AOC8000'                                                  261468
     C                   PARM                    C#RTCD            7                          261468
     C                   PARM                    @MODLE            2                          261468
     C                   PARM                    @TREF            15                          261468
     C                   PARM                    @RTINF           80                          261468
      *                                                                                       261468
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkOthUpd - Check for update by another workstation        *
      *                                                               *
      *****************************************************************
      *
     C     SRChkOthUpd   BEGSR
      *
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive).
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    PReturn           6
     C                   PARM                    Ptype             1
      *
      ** If Insert, set retrieve mode to '*FRONT' (Access using Front Office
      ** Id).  Otherwise, set retrieve mode to blank  (Access using Midas
      ** transaction Id).
      *
     C                   MOVE      PType         WType             1
     C*****IPCHTP        IFNE      'I'                                          193883
     C**********         MOVEL     '1'           WType                          193883
     C**********         ENDIF                                                  193883
      *
     C                   IF        WType = '0'
      *                                                                         193883
      ** If Insert, only set up to '*FRONT' if not called from Midas Plus                     CAP084
      ** API wrapper.                                                                         CAP084
                                                                                              CAP084
     C     IPCHTP        IFEQ      'I'                                          193883
     C     PSJobName     ANDNE     'QZDASOINIT'                                               CAP084
     C     PSJobName     ANDNE     'QSQSRVR'                                                  247277
     C     PSJobName     ANDNE     'QZDASSINIT'                                             MD055030
     C                   MOVE      '*FRONT'      PModeX
     C                   ELSE
     C                   MOVE      *BLANKS       PModeX
     C                   END                                                    193883
     C                   ELSE                                                   193883
     C                   MOVE      *BLANKS       PModeX                         193883
      *                                                                         193883
     C                   ENDIF
      *
      ** Set up Action Code.
      *
     C                   IF        POrigACTN = 'I'
     C                   EVAL      PACTN = POrigACTN
     C                   ELSE
     C                   EVAL      PACTN = IPCHTP
     C                   ENDIF
      *
     C                   CALLB     'FTIPAYRTV'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PModeX            6
      *
      ** Response Mode
     C                   PARM      *BLANK        PResponse         1
      *
      ** Action Code
     C                   PARM                    PACTN             1
      *
      ** Front Office Transaction Id
     C                   PARM      IPFRNT        PFRNT            20
      *
      ** Payment Reference
     C                   PARM      IPPREF        PPREF            15
      *
      ** Booking Branch
     C                   PARM      IPBRCA        PBRCH             3
      *
      ** SWIFT Reference
     C                   PARM      *BLANKS       PSWTN            28
      *
      ** Entry Point
     C                   PARM                    PParmLevel
      *
      ** Linked Program
     C                   PARM      *BLANKS       PLinkPgm         10
      *
      ** Validate Payment Reference for Insert
     C                   PARM      *BLANK        PPrefInsert       1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDGELR - Originating Branch/User Vald Req.
     C                   PARM                    BKOBUV
      *
      ** ZMUSER - Default Branch
     C                   PARM                    PDBRN
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** BLI FT Enhancements Feature
     C                   PARM                    S01494
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499
      *                                                                         CFT014
      ** FT Batch Auth and Credit Advices                                       CFT014
     C                   PARM                    CFT003            1            CFT014
      *                                                                         CFT014
      ** STP Phase 2 MT103                                                      CFT014
     C                   PARM                    CFT014            1            CFT014
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009            1            CFT009
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
     C                   PARM                    IDx
      *
      ** OK Action Code
     C                   PARM                    OKACTN            1
      *
      ** OK Payment Reference
     C                   PARM                    OKPREF            1
      *
      ** OK Booking Branch
     C                   PARM                    OKBRCA            1
      *
      ** Incoming Payments retrieved from file - file format
     C                   PARM                    CrIPFilFmt
     C                   PARM                    CrIP2FilFmt                    CFT014
      *
      ** Error if Timestamp is not the same (record has been changed
      ** by another workstation).
      *
      ** Processing varies according to mode program is running in.
      ** In interacive mode, simply check whether the Timestamp field
      ** has been updated since the original Incoming Payment was
      ** fetched by this program.  In batch (API input), check return
      ** parameters from retrieve module for errors, and send
      ** message to system operator.
      *
      ** Interactive mode:
      *
     C**********         DUMP                                                        TEMPPL MD037804
     C                   IF        PType = '1'
      *
     C                   IF        CHTMST <> IPTMST
     C                   MOVEL     '*RECUPD'     RetCodeIn
     C                   ENDIF
      *
      ** Batch mode:
      *
     C                   ELSE
      *
     C                   IF        OKActn = 'N' OR OKPRef = 'N'
     C                   MOVEL     '*RECUPD'     RetCodeIn
     C                   Z-ADD     1             Wc                2 0
      *
     C     Wc            DOWLE     ArrayMax
     C     FldNameArr(Wc)ANDNE     *BLANKS
     C                   MOVEL     *BLANKS       PDBError         28
     C                   MOVEL     MsgIDArr(Wc)  PDBError
      *
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    PMsgSndRtn       10
     C                   PARM                    PDBError
     C                   PARM                    PDummyMsgID
     C                   PARM                    PDummyMsgF
     C                   ADD       1             Wc
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInsert - Insert Incoming Payment record                    *
      *                                                               *
      *****************************************************************
      *
     C     SRInsert      BEGSR
      *
      ** Check if record already exists in Incoming Payments file.
      ** Error if it already exists.
      *
     C     IPPRef        CHAIN     INPAY                              99
      *
     C                   IF        *IN99 = *Off
     C                   MOVEL     IPPRef        DBKey
     C                   MOVEL     'INPAYDD'     DBFile
     C                   Z-ADD     001           DBase
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                         CFT014
      ** Generate Timestamp.                                                    CFT014
      *                                                                         CFT014
     C                   CALLB     'ZAGENTMSTM'                                 CFT014
     C                   PARM                    PTimestamp                     CFT014
     C/COPY WNCPYSRC,FTIPAYDC01
      *
      ** If Batch Authorisation is installed, update/add record.
      ** Or if STP Phase 2 MT103 for FT is installed.                           CFT014
      *
     C***********        IF        CFT003 = 'Y'                                 CFT014
     C                   IF        CFT003 = 'Y' or CFT014 = 'Y'                 CFT014
     C                             OR CFT009 = 'Y'                              CFT009
      *
     C     IPPRef        CHAIN     INPAYXL0                           99
     C/COPY WNCPYSRC,FTIPAYDC02
      *
     C                   IF        *IN99 = *ON
      *
      ** If extension record is not existing, add record.
      *
     C                   EVAL      I2INTMST = PTimestamp                                    BUG13159
     C                   MOVE      NwIP2FilFmt   CrIP2FilFmt                    CFT014
     C**********         EVAL      I2INTMST = PTimestamp                             CFT014 BUG13159
     C                   EVAL      INTMST = PTimestamp                                        238060
     C                   EVAL      INReci = 'D'
     C                   EVAL      INPRef = IPPRef
     C                   EVAL      INAuto = 'N'
     C/COPY WNCPYSRC,FTH00166
                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        INFRNT = *BLANKS                                           CSC011
     C                   EVAL      INFRNT = 'MD' + INPREF                                     CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
      *
     C***********        WRITE     INPAYXDF                                     CFT014
     C                   WRITE     INPAYXDF                             89      CFT014
      *                                                                         CFT014
      ** If record already exist on file or file error.                         CFT014
     C                   IF        *IN89                                        CFT014
     C                   EVAL      DBKey = INPREF                               CFT014
     C                   EVAL      DBFile = 'INPAYXPD'                          CFT014
     C                   Z-ADD     020           DBase                          CFT014
     C                   EXSR      SRERR                                        CFT014
     C                   ENDIF                                                  CFT014
      *
     C                   ELSE
      *
      ** If extension record is existing, update record.
      *
     C                   EVAL      I2INTMST = PTimestamp                                    BUG13159
     C                   MOVE      NwIP2FilFmt   CrIP2FilFmt                    CFT014
     C**********         EVAL      I2INTMST = PTimestamp                             CFT014 BUG13159
     C                   EVAL      INTMST = PTimestamp                                        238060
     C/COPY WNCPYSRC,FTH00406
     C                   EVAL      INAuto = 'N'
     C/COPY WNCPYSRC,FTH00167
     C***********        UPDATE    INPAYXDF                                     CFT014
     C                   UPDATE    INPAYXDF                             89      CFT014
      *                                                                         CFT014
      ** If record already exist on file or file error.                         CFT014
     C                   IF        *IN89                                        CFT014
     C                   EVAL      DBKey = INPREF                               CFT014
     C                   EVAL      DBFile = 'INPAYXPD'                          CFT014
     C                   Z-ADD     021           DBase                          CFT014
     C                   EXSR      SRERR                                        CFT014
     C                   ENDIF                                                  CFT014
      *
     C                   ENDIF
      *
     C                   ENDIF
      ***********                                                               CFT014
      ***Generate*Timestamp.*******************************************         CFT014
      ***********                                                               CFT014
     C***********        CALLB     'ZAGENTMSTM'                                 CFT014
     C***********        PARM                    PTimestamp                     CFT014
      *
     C                   EVAL      IPTMST = PTimestamp
      *
      ** Save Change Type.
      *
     C                   EVAL      WCHTP = IPCHTP
      *
     C                   MOVE      NwIpFilFmt    InPayUpdF
                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        FRNT = *BLANKS                                             CSC011
     C                   EVAL      FRNT = 'MD' + PREF                                         CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSD015
      ** If compliance watch is installed, and entry watch list checking                      CSD015
      ** is being applied, perform compliance watch processing                                CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'  AND  W1EWLC = 'Y'                            CSD015
                                                                                              CSD015
     C                   IF        (CSC011 = 'Y' AND S1MAIN = LIBR)                           CSD015
     C                             OR CSC011 = 'N'                                            CSD015
     C                   EVAL      WUNCFL = ' '                                               CSD015
     C                   EXSR      SRWTCH                                                     CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      INLVL1 = 'Y'                                             BUG14585
      *
      ** Move valid file details to update file details.
      *
     C                   IF        CAP211 = 'Y' And PAuth = 'Y'                               CAP211
      *                                                                                       CAP211
      ** Set the value of Authorised flag ('Y') and the Authorising profile                   CAP211
      ** if CAP211 is ON and PAuth is 'Y'.                                                    CAP211
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
     C/COPY WNCPYSRC,FTH00431
     C                   WRITE     INPAYDDF                             99
      *
     C                   IF        *IN99 = *ON
     C                   MOVEL     IPPRef        DBKey
     C                   MOVEL     'INPAYDD'     DBFile
     C                   Z-ADD     002           DBase
     C                   EXSR      *PSSR
     C                   ENDIF
     C/COPY WNCPYSRC,FTH00407
      *                                                                                       257487
      ** Move valid file details to extension file details                                    257487
      *                                                                                       257487
     C                   IF        PSJobName <> 'QZDASOINIT' AND                            MD020135
     C                             PSJobName <> 'QZDASSINIT' AND                            MD055030
     C                             PSJobName <> 'QSQSRVR'                                   MD020135
     C                   EVAL      IPFRID = IPFRNT                                            257487
     C                   WRITE     INPAYQD0                             99                    257487
      *                                                                                       257487
     C                   IF        *IN99 = *ON                                                257487
     C                   MOVEL     IPPRef        DBKey                                        257487
     C                   MOVEL     'INPAYDQD'    DBFile                                       257487
     C                   Z-ADD     031           DBase                                        257487
     C                   EXSR      *PSSR                                                      257487
     C                   ENDIF                                                                257487
     C                   ENDIF                                                              MD020135
      *****************************************************************               BUG4776 260326
      ****If*new*record*was*successfully*writen*to*INPAYDD,*add*new*record*to         BUG4776 260326
      ****FT*Payment*Reference*Control*file*-*FTPREFPD*****************               BUG4776 260326
      *****************************************************************               BUG4776 260326
     C**********         If        *IN99 = *OFF                                       BUG4776 260326
     C**********         EVAL      MLRECI = INRECI                                    BUG4776 260326
     C**********         MOVEL     IPPREF        MLPREF                               BUG4776 260326
     C**********         EVAL      MLPYTP = IPPYTP                                    BUG4776 260326
     C**********         Write     FTPREFDF                             70            BUG4776 260326
     C**********         If        *IN70 = *ON                                        BUG4776 260326
     C**********         Movel     'FTPREFL0'    DBFILE                               BUG4776 260326
     C**********         Z-add     7             DBASE                                BUG4776 260326
     C**********         Movel     MLPREF        DBKEY                                BUG4776 260326
     C**********         Exsr      *PSSR                                              BUG4776 260326
     C**********         Endif                                                        BUG4776 260326
     C**********         Endif                                                        BUG4776 260326
      *
     C/COPY WNCPYSRC,FTIPAYDC05
      ** Process shadow post.
      *
     C                   EVAL      WVSMAM = SMAM
     C                   EVAL      WVPYAM = PYAM
      *
     C                   EXSR      SRAdd
      *
      ** Add Charges (Charge Amount is always debit) if
      ** Level 2 details have been entered.
      *
     C                   IF        INLVL2 = 'Y'
      *
     C                   EVAL      WVCHGS = TXCH + CQCH + ADCH
     C                                    + TLCH + MSCH + TRCM
      *
     C     S01494        IFEQ      'Y'
     C                   ADD       INCHCM        WVCHGS
     C                   ENDIF
      *
     C     S01499        IFEQ      'Y'
     C     CFT009        ANDEQ     'N'                                          CFT009
     C     CFT010        OREQ      'Y'                                          CFT009
     C                   ADD       INVATT        WVCHGS
     C                   ENDIF
      *                                                                         CFT009
      ** Extra charges                                                          CFT009
      *                                                                         CFT009
     C     CFT009        IFEQ      'Y'                                          CFT009
     C**********         ADD       CMSC01        WVCHGS                                CFT009 CFT120
     C**********         ADD       CMSC02        WVCHGS                                CFT009 CFT120
     C**********         ADD       CMSC03        WVCHGS                                CFT009 CFT120
     C**********         ADD       CMSC04        WVCHGS                                CFT009 CFT120
     C**********         ADD       CMSC05        WVCHGS                                CFT009 CFT120
     C                   ADD       MSC01         WVCHGS                                       CFT120
     C                   ADD       MSC02         WVCHGS                                       CFT120
     C                   ADD       MSC03         WVCHGS                                       CFT120
     C                   ADD       MSC04         WVCHGS                                       CFT120
     C                   ADD       MSC05         WVCHGS                                       CFT120
     C                   ENDIF                                                  CFT009
      *
     C     WVCHGS        IFNE      0
     C                   EXSR      SRSChg
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Perform shadow post update.
      *
     C                   EXSR      SRSHadow
      *
      ** Process Message Unique Reference if not equal to zero.
      *
     C                   IF        INMSGR <> 0
      *
      ** Remove the electronic message from the Outstanding Reserved
      ** Messages file.
      *
     C                   EXSR      SRMsgDel
      *
      ** Update Incoming Message FT Transaction Status File record.
      *
     C/COPY WNCPYSRC,FTH00168
     C                   MOVEL     'MIN0030'     W0Flag            7
     C/COPY WNCPYSRC,FTH00169
     C                   MOVEL     'MIN0027'     W0LMSG            7
      *
     C                   EXSR      SRInFT
      *
      ** If Level 2 details have been entered, update Incoming
      ** Message Log file.
      *
     C                   IF        INLVL2 = 'Y'
     C                   MOVEL     'MIN0034'     W0LMSG
     C                   EXSR      SRLOG
     C                   ENDIF
     C/COPY WNCPYSRC,FTH00396
      *
     C                   ENDIF
      *
      ** Update Incoming Payments trailer with Payment Amount.
      *
     C                   MOVE      SMAM          ZZAMT
     C                   EXSR      SRTrailer
      *
     C                   IF        CAP211 = 'Y' AND PAuth = 'Y' AND                           CAP211
     C                             SVGOP = 'Y' AND OPIN = 'Y'                                 CAP211
      *                                                                                       CAP211
      ** Generate Outgoing Payment if CAP211 is ON, PAuth is 'Y', CAP211GenerateOP system     CAP211
      ** value is 'Y' and OPIN (Outgoing payment generated from incoming payemnt) flag is 'Y' CAP211
      *                                                                                       CAP211
     C                   EXSR      WOTPAY                                                     CAP211
     C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAmend - Amend Incoming Payment record                      *
      *                                                               *
      *****************************************************************
      *
     C     SRAmend       BEGSR
      *
      ** Check if record already exists in Incoming Payments file.
      ** Error if it does not exist.
      *
     C     IPPRef        CHAIN     INPAY                              99
      *
     C                   IF        *IN99 = *On
     C                   MOVEL     IPPRef        DBKey
     C                   MOVEL     'INPAYDD'     DBFile
     C                   MOVEL     003           DBase
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   MOVE      InPayUpdF     CrIPFilFmt
      *                                                                         CFT014
      ** Generate Timestamp.                                                    CFT014
      *                                                                         CFT014
     C                   CALLB     'ZAGENTMSTM'                                 CFT014
     C                   PARM                    PTimestamp                     CFT014
      *
      ** Process shadow post (reverse out original entries).
      *
     C                   Z-SUB     SMAM          WVSMAM
     C                   Z-SUB     PYAM          WVPYAM
      *
      ** Process shadow post if Level 1 maintenance, or Level 2
      ** maintenance, Account with Bank entered and OPIN has
      ** changed from N to Y.
      *
     C     PParmLevel    IFEQ      '1'
     C     PParmLevel    OREQ      '2'
     C     ACBT          ANDNE     *BLANKS
     C     OPIN          ANDNE     'Y'
     C     IPOPIN        ANDEQ     'Y'
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WRevAst = 'Y'                                              CRE020
     C                   ENDIF                                                                CRE020
     C                   EXSR      SRAdd
     C                   ENDIF
      *                                                                         CFT009
      ** Check if record already exists in Incoming Payments extension file     CFT009
      ** Error if it does not exist.                                            CFT009
      *                                                                         CFT009
     C                   IF        CFT009 = 'Y'                                 CFT009
                                                                                CFT009
     C     IPPREF        CHAIN     INPAYXL0                           99        CFT009
      *                                                                         CFT009
     C                   IF        *IN99 = *ON                                  CFT009
     C                   MOVEL     IPPREF        DBKEY                          CFT009
     C                   MOVEL     'INPAYXPD'    DBFILE                         CFT009
     C                   MOVEL     028           DBASE                          CFT009
     C                   EXSR      SRERR                                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
      *
      ** Reverse Charges (Charge Amount is always debit).
      *
     C                   EVAL      WVCHGS = TXCH + CQCH + ADCH
     C                                    + TLCH + MSCH + TRCM
      *
     C     S01494        IFEQ      'Y'
     C                   ADD       INCHCM        WVCHGS
     C                   ENDIF
      *
     C     S01499        IFEQ      'Y'
     C     CFT009        ANDEQ     'N'                                          CFT009
     C     CFT010        OREQ      'Y'                                          CFT009
     C                   ADD       INVATT        WVCHGS
     C                   ENDIF
      *                                                                         CFT009
      ** Extra charges                                                          CFT009
      *                                                                         CFT009
     C     CFT009        IFEQ      'Y'                                          CFT009
     C**********         ADD       CMSC01        WVCHGS                                CFT009 CFT120
     C**********         ADD       CMSC02        WVCHGS                                CFT009 CFT120
     C**********         ADD       CMSC03        WVCHGS                                CFT009 CFT120
     C**********         ADD       CMSC04        WVCHGS                                CFT009 CFT120
     C**********         ADD       CMSC05        WVCHGS                                CFT009 CFT120
     C                   ADD       MSC01         WVCHGS                                       CFT120
     C                   ADD       MSC02         WVCHGS                                       CFT120
     C                   ADD       MSC03         WVCHGS                                       CFT120
     C                   ADD       MSC04         WVCHGS                                       CFT120
     C                   ADD       MSC05         WVCHGS                                       CFT120
     C                   ENDIF                                                  CFT009
      *
     C     WVCHGS        IFNE      0
     C                   Z-SUB     WVCHGS        WVCHGS
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WRevAst = 'Y'                                              CRE020
     C                   ENDIF                                                                CRE020
     C                   EXSR      SRSChg
     C                   ENDIF
     C/COPY WNCPYSRC,FTIPAYDC06
      *
      ***If*Batch*Authorisation*is*installed,*update*extension*********         CFT014
      ***record*to*include*the*Auto-generated*indicator.***************         CFT014
      ** If Batch Authorisation is installed or STP Phase 2 MT103               CFT014
      ** for FT is installed, update extension record to include the            CFT014
      ** Auto-generated indicator and other new fields.                         CFT014
      *
     C***********        IF        CFT003 = 'Y' and                             CFT014
     C*****************  IF        (CFT003 = 'Y' or CFT014 = 'Y') and    CFT014 CFT009
     C                   IF        (CFT003 = 'Y' or CFT014 = 'Y'                CFT009
     C                             OR CFT009 = 'Y') AND                         CFT009
     C                             PParmLevel = '1'
      *
     C     PRef          CHAIN     INPAYXL0                           99
      *
     C                   IF        *IN99 = *ON
      *
      ** If extension record is not existing, add record.
      *
     C                   MOVE      NwIP2FilFmt   CrIP2FilFmt                    CFT014
     C                   EVAL      I2INTMST = PTimestamp                        CFT014
     C                   EVAL      INTMST = PTimestamp                                        238060
     C                   EVAL      INReci = 'D'
     C                   EVAL      INPRef = IPPRef
     C                   EVAL      INAuto = 'N'
     C/COPY WNCPYSRC,FTH00170
                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        INFRNT = *BLANKS                                           CSC011
     C                   EVAL      INFRNT = 'MD' + INPREF                                     CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
      *
     C***********        WRITE     INPAYXDF                                     CFT014
     C                   WRITE     INPAYXDF                             89      CFT014
      *                                                                         CFT014
      ** If record already exist on file or file error.                         CFT014
     C                   IF        *IN89                                        CFT014
     C                   EVAL      DBKey = INPREF                               CFT014
     C                   EVAL      DBFile = 'INPAYXPD'                          CFT014
     C                   Z-ADD     022           DBase                          CFT014
     C                   EXSR      SRERR                                        CFT014
     C                   ENDIF                                                  CFT014
      *
     C                   ELSE
      *
      ** If extension record is existing, update record.
      *
     C                   MOVE      NwIP2FilFmt   CrIP2FilFmt                    CFT014
     C                   EVAL      I2INTMST = PTimestamp                        CFT014
     C                   EVAL      INTMST = PTimestamp                                        238060
     C/COPY WNCPYSRC,FTH00408
     C                   MOVEL     'N'           INAUTO
     C/COPY WNCPYSRC,FTH00171
     C***********        UPDATE    INPAYXDF                                     CFT014
     C                   UPDATE    INPAYXDF                             89      CFT014
      *                                                                         CFT014
      ** If record already exist on file or file error.                         CFT014
     C                   IF        *IN89                                        CFT014
     C                   EVAL      DBKey = INPREF                               CFT014
     C                   EVAL      DBFile = 'INPAYXPD'                          CFT014
     C                   Z-ADD     023           DBase                          CFT014
     C                   EXSR      SRERR                                        CFT014
     C                   ENDIF                                                  CFT014
      *
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                     AR924677
      ** On amend, clear AUTHORISE PROF 1                                                   AR924677
      *                                                                                     AR924677
     C                   MOVE      *BLANK        IPAUP1                                     AR924677
      *
      ** Save Change Type.
      *
     C                   EVAL      WCHTP = IPCHTP
      *
      ** Retain original Last Change Type if original value is 'I'
      ** and original Last Change Date is equal to rundate.
      *
     C     CHTP          IFEQ      'I'
     C     LCD           ANDEQ     BJRDNB
     C                   EVAL      IPCHTP = CHTP
     C                   ENDIF
      *
      ** If Level 2 is newly entered, reset Original Entry
      ** Date to rundate and Last Change Type to 'I'.
      *
     C                   IF        INLVL2 <> 'Y' and
     C                             IPINLVL2 = 'Y'
     C                   EVAL      IPOEDT = BJRDNB
     C                   EVAL      IPCHTP = 'I'
     C                   ENDIF
      ***********                                                               CFT014
      ***Generate*Timestamp.*******************************************         CFT014
      ***********                                                               CFT014
     C***********        CALLB     'ZAGENTMSTM'                                 CFT014
     C***********        PARM                    PTimestamp                     CFT014
      *
     C                   EVAL      IPTMST = PTimestamp
      *
      ** Move valid file details to update file details.
      *
     C                   MOVEL     NwIpFilFmt    InPayUpdF
      *                                                                                       208944
      ** Reset authorizing profile.                                                           208944
      *                                                                                       208944
     C/COPY WNCPYSRC,FTH00557
     C                   MOVE      *Blanks       AUP1                                         208944
     C/COPY WNCPYSRC,FTH00558
      *
      ** If compliance watch is installed, and entry watch list checking                      CSD015
      ** is being applied, perform compliance watch processing for amend mode                 CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'  AND  W1EWLC = 'Y'                            CSD015
                                                                                              CSD015
     C                   IF        (CSC011 = 'Y' AND S1MAIN = LIBR)                           CSD015
     C                             OR CSC011 = 'N'                                            CSD015
                                                                                              CSD015
     C                   EVAL      WUNCFL = ' '                                               CSD015
     C                   EVAL      WFUNT = 'INPAYDD'                                          CSD015
     C                   EVAL      KIDEN = PREF                                               CSD015
     C     KWHTKY        CHAIN     SDCWHTL1                                                   CSD015
     C                   IF        %FOUND(SDCWHTL1) AND W3UNCF = 'Y'                          CSD015
     C                   EVAL      WUNCFL = 'Y'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EXSR      SRWTCH                                                     CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        CAP211 = 'Y' And PAuth = 'Y'                               CAP211
      *                                                                                       CAP211
      ** Set the value of Authorised flag ('Y') and the Authorising profile                   CAP211
      ** if CAP211 is ON and PAuth is 'Y'.                                                    CAP211
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
     C/COPY WNCPYSRC,FTH00432
     C                   UPDATE    INPAYDDF                             99
     C/COPY WNCPYSRC,FTIPAYDC22
      *
     C                   IF        *IN99 = *ON
     C                   MOVEL     IPPREF        DBKey
     C                   MOVEL     'INPAYDD'     DBFile
     C                   MOVEL     004           DBase
     C                   EXSR      *PSSR
     C                   ENDIF
     C/COPY WNCPYSRC,FTIPAYDC23
      *
      ** Process shadow post.
      *
     C                   EVAL      WVSMAM = SMAM
     C                   EVAL      WVPYAM = PYAM
      *
      ** Process shadow post if Level 1 maintenance, or Level 2
      ** maintenance, Account with Bank entered and OPIN has
      ** changed from Y to N.
      *
     C     PParmLevel    IFEQ      '1'
     C     PParmLevel    OREQ      '2'
     C     ACBT          ANDNE     *BLANKS
     C     OPIN          ANDNE     'Y'
     C     CHOPIN        ANDEQ     'Y'
     C                   EXSR      SRAdd
     C                   ENDIF
      *
      ** Add Charges (Charge Amount is always debit).
      *
     C                   EVAL      WVCHGS = TXCH + CQCH + ADCH
     C                                    + TLCH + MSCH + TRCM
      *
     C     S01494        IFEQ      'Y'
     C                   ADD       INCHCM        WVCHGS
     C                   ENDIF
      *
     C     S01499        IFEQ      'Y'
     C     CFT009        ANDEQ     'N'                                          CFT009
     C     CFT010        OREQ      'Y'                                          CFT009
     C                   ADD       INVATT        WVCHGS
     C                   ENDIF
      *                                                                         CFT009
      ** Extra charges                                                          CFT009
      *                                                                         CFT009
     C     CFT009        IFEQ      'Y'                                          CFT009
     C**********         ADD       CMSC01        WVCHGS                                CFT009 CFT120
     C**********         ADD       CMSC02        WVCHGS                                CFT009 CFT120
     C**********         ADD       CMSC03        WVCHGS                                CFT009 CFT120
     C**********         ADD       CMSC04        WVCHGS                                CFT009 CFT120
     C**********         ADD       CMSC05        WVCHGS                                CFT009 CFT120
     C                   ADD       MSC01         WVCHGS                                       CFT120
     C                   ADD       MSC02         WVCHGS                                       CFT120
     C                   ADD       MSC03         WVCHGS                                       CFT120
     C                   ADD       MSC04         WVCHGS                                       CFT120
     C                   ADD       MSC05         WVCHGS                                       CFT120
     C                   ENDIF                                                  CFT009
      *
     C     WVCHGS        IFNE      0
     C                   EXSR      SRSChg
     C                   ENDIF
      *
      ** Perform shadow post update.
      *
     C                   EXSR      SRSHadow
      *
      ** Update Incoming Message FT Transaction Status File record.
      *
     C                   IF        INMSGR <> 0
      *
     C                   IF        PParmLevel = '1'
     C/COPY WNCPYSRC,FTH00172
     C                   MOVEL     'MIN0030'     W0Flag
     C/COPY WNCPYSRC,FTH00173
     C                   MOVEL     'MIN0028'     W0LMSG
     C                   MOVEL     *BLANKS       PNWRK
     C                   EXSR      SRInFT
     C                   ENDIF
      *
      ** If Level 2 is newly entered, update Incoming
      ** Message Log file.
      *
     C                   IF        INLVL2 = 'Y' and
     C                             CHINLVL2 <> 'Y'
     C                   MOVEL     'MIN0034'     W0LMSG
     C                   EXSR      SRLOG
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Update Incoming Payments trailer with new Payment
      ** Amount minus original Payment Amount if Level 1
      ** maintenance.
      *
     C     PParmLevel    IFEQ      '1'
     C     SMAM          SUB       CHSMAM        WN13             13 0
     C                   MOVE      WN13          ZZAMT
     C                   EXSR      SRTrailer
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDelete - Delete Incoming Payment record                    *
      *                                                               *
      *****************************************************************
      *
     C     SRDelete      BEGSR
      *
      ** Check if record already exists in Incoming Payments file.
      ** Error if it does not exist.
      *
     C     IPPRef        CHAIN     INPAY                              99
      *
     C                   IF        *IN99 = *On
     C                   MOVEL     IPPRef        DBKey
     C                   MOVEL     'INPAYDD'     DBFile
     C                   MOVEL     005           DBase
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   MOVE      InPayUpdF     CrIPFilFmt
      *
      ** Process shadow post (reverse out original entries).
      *
     C                   Z-SUB     SMAM          WVSMAM
     C                   Z-SUB     PYAM          WVPYAM
      *                                                                                       CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WRevAst = 'Y'                                              CRE020
     C                   ENDIF                                                                CRE020
      *
     C                   EXSR      SRAdd
      *                                                                         CFT009
      ** Check if record already exists in Incoming Payments extension file     CFT009
      ** Error if it does not exist.                                            CFT009
      *                                                                         CFT009
     C                   IF        CFT009 = 'Y'                                 CFT009
                                                                                CFT009
     C     IPPREF        CHAIN     INPAYXL0                           99        CFT009
      *                                                                         CFT009
     C                   IF        *IN99 = *ON                                  CFT009
     C                   MOVEL     PREF          DBKEY                          CFT009
     C                   MOVEL     'INPAYXPD'    DBFILE                         CFT009
     C                   MOVEL     029           DBASE                          CFT009
     C                   EXSR      SRERR                                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
      *
      ** Reverse Charges (Charge Amount is always debit).
      *
     C                   EVAL      WVCHGS = TXCH + CQCH + ADCH
     C                                    + TLCH + MSCH + TRCM
      *
     C     S01494        IFEQ      'Y'
     C                   ADD       INCHCM        WVCHGS
     C                   ENDIF
      *
     C     S01499        IFEQ      'Y'
     C     CFT009        ANDEQ     'N'                                          CFT009
     C     CFT010        OREQ      'Y'                                          CFT009
     C                   ADD       INVATT        WVCHGS
     C                   ENDIF
      *                                                                         CFT009
      ** Extra charges                                                          CFT009
      *                                                                         CFT009
     C     CFT009        IFEQ      'Y'                                          CFT009
     C**********         ADD       CMSC01        WVCHGS                                CFT009 CFT120
     C**********         ADD       CMSC02        WVCHGS                                CFT009 CFT120
     C**********         ADD       CMSC03        WVCHGS                                CFT009 CFT120
     C**********         ADD       CMSC04        WVCHGS                                CFT009 CFT120
     C**********         ADD       CMSC05        WVCHGS                                CFT009 CFT120
     C                   ADD       MSC01         WVCHGS                                       CFT120
     C                   ADD       MSC02         WVCHGS                                       CFT120
     C                   ADD       MSC03         WVCHGS                                       CFT120
     C                   ADD       MSC04         WVCHGS                                       CFT120
     C                   ADD       MSC05         WVCHGS                                       CFT120
     C                   ENDIF                                                  CFT009
      *
     C     WVCHGS        IFNE      0
     C                   Z-SUB     WVCHGS        WVCHGS
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WRevAst = 'Y'                                              CRE020
     C                   ENDIF                                                                CRE020
     C                   EXSR      SRSChg
     C                   ENDIF
      *
      ** Generate Timestamp.
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimestamp
      *
     C                   EVAL      IPTMST = PTimestamp
      *
      ** Move valid file details to update file details.
      *
     C                   MOVEL     NwIpFilFmt    InPayUpdF
      *
     C                   IF        CAP211 = 'Y' And PAuth = 'Y'                               CAP211
      *                                                                                       CAP211
      ** Set the value of Authorised flag ('Y') and the Authorising profile                   CAP211
      ** if CAP211 is ON and PAuth is 'Y'.                                                    CAP211
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
     C/COPY WNCPYSRC,FTH00433
     C                   UPDATE    INPAYDDF                             99
      *
     C                   IF        *IN99 = *ON
     C                   MOVEL     IPPREF        DBKey
     C                   MOVEL     'INPAYDD'     DBFile
     C                   MOVEL     006           DBase
     C                   EXSR      *PSSR
     C                   ENDIF
     C/COPY WNCPYSRC,FTIPAYDC24
      *
      ** Perform shadow post update.
      *
     C                   EXSR      SRSHadow
      *
      ** Update Incoming Message FT Transaction Status File record.
      *
     C                   IF        INMSGR <> 0
      *
     C                   MOVEL     'MIN0031'     W0Flag
     C                   MOVEL     'MIN0029'     W0LMSG
     C                   MOVEL     *BLANKS       PNWRK
      *
     C                   EXSR      SRInFT
      *
     C                   ENDIF
     C/COPY WNCPYSRC,FTH00102
      *
     C                   ENDSR
      *
     C/COPY WNCPYSRC,FTH00454
      *****************************************************************                       CFT157
      *                                                               *                       CFT157
      *  SRStop   - Stop Incoming Payment transaction                 *                       CFT157
      *                                                               *                       CFT157
      *****************************************************************                       CFT157
      *                                                                                       CFT157
     C     SRStop        BEGSR                                                                CFT157
      *                                                                                       CFT157
      ** Check if record already exists in Incoming Payments file.                            CFT157
      ** Error if it does not exist.                                                          CFT157
      *                                                                                       CFT157
     C     IPPRef        CHAIN     INPAY                              99                      CFT157
      *                                                                                       CFT157
     C                   IF        *IN99 = *On                                                CFT157
     C                   MOVEL     IPPRef        DBKey                                        CFT157
     C                   MOVEL     'INPAYDD'     DBFile                                       CFT157
     C                   MOVEL     435           DBase                                        CFT157
     C                   EXSR      SRERR                                                      CFT157
     C                   ENDIF                                                                CFT157
      *                                                                                       CFT157
     C                   MOVE      InPayUpdF     CrIPFilFmt                                   CFT157
      *                                                                                       CFT157
      ** Process shadow post (reverse out original entries).                                  CFT157
      *                                                                                       CFT157
     C                   Z-SUB     SMAM          WVSMAM                                       CFT157
     C                   Z-SUB     PYAM          WVPYAM                                       CFT157
      *                                                                                       CFT157
     C                   IF        CRE020 = 'Y'                                               CFT157
     C                   EVAL      WRevAst = 'Y'                                              CFT157
     C                   ENDIF                                                                CFT157
      *                                                                                       CFT157
     C                   EXSR      SRAdd                                                      CFT157
      *                                                                                       CFT157
      ** Check if record already exists in Incoming Payments extension file                   CFT157
      ** Error if it does not exist.                                                          CFT157
      *                                                                                       CFT157
     C                   IF        CFT009 = 'Y'                                               CFT157
                                                                                              CFT157
     C     IPPREF        CHAIN     INPAYXL0                           99                      CFT157
      *                                                                                       CFT157
     C                   IF        *IN99 = *ON                                                CFT157
     C                   MOVEL     PREF          DBKEY                                        CFT157
     C                   MOVEL     'INPAYXPD'    DBFILE                                       CFT157
     C                   MOVEL     429           DBASE                                        CFT157
     C                   EXSR      SRERR                                                      CFT157
     C                   ENDIF                                                                CFT157
                                                                                              CFT157
     C                   ENDIF                                                                CFT157
      *                                                                                       CFT157
      ** Reverse Charges (Charge Amount is always debit).                                     CFT157
      *                                                                                       CFT157
     C                   EVAL      WVCHGS = TXCH + CQCH + ADCH                                CFT157
     C                                    + TLCH + MSCH + TRCM                                CFT157
      *                                                                                       CFT157
     C     S01494        IFEQ      'Y'                                                        CFT157
     C                   ADD       INCHCM        WVCHGS                                       CFT157
     C                   ENDIF                                                                CFT157
      *                                                                                       CFT157
     C     S01499        IFEQ      'Y'                                                        CFT157
     C     CFT009        ANDEQ     'N'                                                        CFT157
     C     CFT010        OREQ      'Y'                                                        CFT157
     C                   ADD       INVATT        WVCHGS                                       CFT157
     C                   ENDIF                                                                CFT157
      *                                                                                       CFT157
      ** Extra charges                                                                        CFT157
      *                                                                                       CFT157
     C     CFT009        IFEQ      'Y'                                                        CFT157
     C                   ADD       MSC01         WVCHGS                                       CFT157
     C                   ADD       MSC02         WVCHGS                                       CFT157
     C                   ADD       MSC03         WVCHGS                                       CFT157
     C                   ADD       MSC04         WVCHGS                                       CFT157
     C                   ADD       MSC05         WVCHGS                                       CFT157
     C                   ENDIF                                                                CFT157
      *                                                                                       CFT157
     C     WVCHGS        IFNE      0                                                          CFT157
     C                   Z-SUB     WVCHGS        WVCHGS                                       CFT157
     C                   IF        CRE020 = 'Y'                                               CFT157
     C                   EVAL      WRevAst = 'Y'                                              CFT157
     C                   ENDIF                                                                CFT157
     C                   EXSR      SRSChg                                                     CFT157
     C                   ENDIF                                                                CFT157
      *                                                                                       CFT157
      ** Generate Timestamp.                                                                  CFT157
      *                                                                                       CFT157
     C                   CALLB     'ZAGENTMSTM'                                               CFT157
     C                   PARM                    PTimestamp                                   CFT157
      *                                                                                       CFT157
     C                   EVAL      IPTMST = PTimestamp                                        CFT157
      *                                                                                       CFT157
      ** Move valid file details to update file details.                                      CFT157
      *                                                                                       CFT157
     C                   MOVEL     NwIpFilFmt    InPayUpdF                                    CFT157
      *                                                                                       CFT157
     C                   MOVE      'C'           RECI                                         CFT157
     C                   Z-ADD     BJRDNB        DATE                                         CFT157
      *                                                                                       CFT157
     C                   IF        CAP211 = 'Y' And PAuth = 'Y'                               CFT157
      *                                                                                       CFT157
      ** Set the value of Authorised flag ('Y') and the Authorising profile                   CFT157
      ** if CAP211 is ON and PAuth is 'Y'.                                                    CFT157
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
     C                   UPDATE    INPAYDDF                             99                    CFT157
      *                                                                                       CFT157
     C                   IF        *IN99 = *ON                                                CFT157
     C                   MOVEL     IPPREF        DBKey                                        CFT157
     C                   MOVEL     'INPAYDD'     DBFile                                       CFT157
     C                   MOVEL     438           DBase                                        CFT157
     C                   EXSR      *PSSR                                                      CFT157
     C                   ENDIF                                                                CFT157
      *                                                                                       CFT157
      ** Perform shadow post update.                                                          CFT157
      *                                                                                       CFT157
     C                   EXSR      SRSHadow                                                   CFT157
      *                                                                                       CFT157
      ** Update Incoming Message FT Transaction Status File record.                           CFT157
      *                                                                                       CFT157
     C                   IF        INMSGR <> 0                                                CFT157
      *                                                                                       CFT157
     C                   MOVEL     'MIN0031'     W0Flag                                       CFT157
     C                   MOVEL     'MIN0029'     W0LMSG                                       CFT157
     C                   MOVEL     *BLANKS       PNWRK                                        CFT157
      *                                                                                       CFT157
     C                   EXSR      SRInFT                                                     CFT157
      *                                                                                       CFT157
     C                   ENDIF                                                                CFT157
      *                                                                                       CFT157
     C                   ENDSR                                                                CFT157
      *                                                                                       CFT157
      *****************************************************************
      /Title SR/SRLOGTRAN                                                                     CSC011
      *****************************************************************                       CSC011
      *                                                               *                       CSC011
      * SRLOGTRAN  - Write Transaction to Log file.                   *                       CSC011
      *                                                               *                       CSC011
      * Called By: Main Routine                                       *                       CSC011
      *                                                               *                       CSC011
      * Calls:                                                        *                       CSC011
      * FTIPAYLOG   - Incoming Payment Log Module                     *                       CSC011
      * APLOGTRAN   - AP Log Transactions from the Support Database   *                       CSC011
      *                                                               *                       CSC011
      *****************************************************************                       CSC011
                                                                                              CSC011
     C     SRLOGTRAN     BEGSR                                                                CSC011
                                                                                              CSC011
      ** Call log module.                                                                     CSC011
                                                                                              CSC011
     C                   CALLB     'FTIPAYLOG'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    InPayUpdF                                    CSC011
     C                   PARM                    CrIP2FilFmt                                  CSC011
     C                   PARM                    PACTN                                        CSC011
     C                   PARM                    S01494                                       CSC011
     C                   PARM                    S01499                                       CSC011
     C                   PARM                    CFT014                                       CSC011
     C                   PARM                    CFT009                                       CSC011
     C                   PARM                    CFT010                                       CSC011
     C                   PARM      *BLANKS       TRANSDTL                                     CSC011
                                                                                              CSC011
      ** No error, write the transaction via APLOGTRAN module.                                CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut = *BLANKS                                       CSC011
     C                   EVAL      APTGTTYPE = 'FTIPAY'                                       CSC011
     C                   EVAL      APFOTRANID = IPFRNT                                        CSC011
     C                   EVAL      APRPRLOCN = IPREPA                                         CSC011
     C                   EVAL      APUSERID   = PSUser                                        CSC011
     C                   EVAL      APMIDUSR   = PSUser                                        CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    APHEAD                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *BLANKS       PTIMESTMP                                    CSC011
     C                   PARM      IPPREF        PREFERENCE                                   CSC011
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
      *****************************************************************                       CSC011
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClr - Clear all positions in store                         *
      *                                                               *
      *****************************************************************
      *
     C     SRClr         BEGSR
      *
      ** Clear arrays in AOSPOSU0.
      *
     C                   CLEAR                   C_DTA
      *
     C                   CALLB     'AOSPOSU0'                           9090
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*CLEAR  '    PACT
     C                   PARM      C_DTA         PDTA
      *
     C                   IF        *IN90 = '1' OR PRtcd <> *BLANKS
     C                   MOVEL     '*CALL'       DBKey
     C                   MOVEL     'AOSPOSU0'    DBFile
     C                   MOVEL     007           DBase
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C/COPY WNCPYSRC,FTH00409
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAdd - Add shadow positions to store                        *
      *                                                               *
      *****************************************************************
      *
     C     SRAdd         BEGSR
      *
      ** Define Settle and Pay Amounts.
      *
     C     *LIKE         DEFINE    SMAM          WVSMAM
     C     *LIKE         DEFINE    PYAM          WVPYAM
      *
      ** Execute addition of shadow positions for settlement
      ** instruction only if maintenance was called from Level 1.
      *
     C                   IF        PParmLevel = '1'
      *
      ** SETTLEMENT INSTRUCTIONS.
      *
     C                   CLEAR                   C_DTA
      *
      ** Move fields to C_DTA structure.
      *
     C***********        IF        RCRT <> *BLANKS                              CFT014
     C***********        MOVEL     RCRT          C_ATYP                         CFT014
     C***********        MOVEL     RCCO          C_ACCT                         CFT014
      *                                                                         CFT014
     C                   IF        INTRIT <> *BLANKS and CFT014 = 'Y'           CFT014
     C                   MOVEL     INTRIT        C_ATYP                         CFT014
      *                                                                         CFT014
      ** Determine corresponding Midas account of IBAN account                  CFT014
      ** for Third Reimbursement Institution.                                   CFT014
      *                                                                         CFT014
     C                   IF        INTRIT = 'I' and CFT004 = 'Y'                CFT014
     C                   MOVEL     INTRIB        PIBAN                          CFT014
     C                   MOVE      *BLANKS       DSSDY                          CFT014
     C                   CALLB     'AOIBANR4'                                   CFT014
     C                   PARM      *BLANKS       PNRTCD                         CFT014
     C                   PARM      '*KEY   '     PNOPTN                         CFT014
     C                   PARM                    PIBAN                          CFT014
     C     P@ACCN        PARM      *BLANKS       DSSDY                          CFT014
      *                                                                         CFT014
     C                   IF        PNRTCD <> *BLANKS                            CFT014
     C                   EVAL      DBKey = PIBAN                                CFT014
     C                   EVAL      DBFile = 'ACCNTAB'                           CFT014
     C                   Z-ADD     024           DBase                          CFT014
     C                   EXSR      SRERR                                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C**********         Z-ADD     CNUM          WICNUM                         CFT014        CSD027
     C                   EVAL      WICNUM = CNUM                                CFT014        CSD027
     C                   MOVE      CCY           WICCY                          CFT014
     C                   Z-ADD     ACOD          WIACOD                         CFT014
     C                   Z-ADD     ACSQ          WIACSQ                         CFT014
     C                   MOVE      IBNBRCA       WIBRCA                         CFT014
     C                   MOVEL     WIACNT        C_ACCT                         CFT014
     C                   EXSR      SRFLGL                                                     CGL029
      *                                                                         CFT014
     C                   ELSE                                                   CFT014
     C                   MOVEL     INTRIB        C_ACCT                         CFT014
     C                   EXSR      SRFLGL                                                     CGL029
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ELSE                                                   CFT014
      *                                                                         CFT014
     C                   IF        INRCRT <> *BLANKS                            CFT014
     C                   MOVEL     INRCRT        C_ATYP                         CFT014
      *                                                                         CFT014
      ** Determine corresponding Midas account of IBAN account                  CFT014
      ** for Receiver's Correspondent.                                          CFT014
      *                                                                         CFT014
     C                   IF        INRCRT = 'I' and CFT004 = 'Y'                CFT014
     C                   EVAL      PIBAN = %SUBST(INRCO1:2:34)                  CFT014
     C                   CALLB     'AOIBANR4'                                   CFT014
     C                   PARM      *BLANKS       PNRTCD                         CFT014
     C                   PARM      '*KEY   '     PNOPTN                         CFT014
     C                   PARM                    PIBAN                          CFT014
     C     P@ACCN        PARM      *BLANKS       DSSDY                          CFT014
      *                                                                         CFT014
     C                   IF        PNRTCD <> *BLANKS                            CFT014
     C                   EVAL      DBKey = PIBAN                                CFT014
     C                   EVAL      DBFile = 'ACCNTAB'                           CFT014
     C                   Z-ADD     025           DBase                          CFT014
     C                   EXSR      SRERR                                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C**********         Z-ADD     CNUM          WICNUM                         CFT014        CSD027
     C                   EVAL      WICNUM = CNUM                                CFT014        CSD027
     C                   MOVE      CCY           WICCY                          CFT014
     C                   Z-ADD     ACOD          WIACOD                         CFT014
     C                   Z-ADD     ACSQ          WIACSQ                         CFT014
     C                   MOVE      IBNBRCA       WIBRCA                         CFT014
     C                   MOVEL     WIACNT        C_ACCT                         CFT014
     C                   EXSR      SRFLGL                                                     CGL029
      *                                                                         CFT014
     C                   ELSE                                                   CFT014
     C                   MOVEL     INRCO1        C_ACCT                         CFT014
     C                   EXSR      SRFLGL                                                     CGL029
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ELSE
     C                   MOVEL     SNTP          C_ATYP
     C                   MOVEL     SND1          C_ACCT
     C                   EXSR      SRFLGL                                                     CGL029
     C                   ENDIF
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *
     C                   Z-ADD     SLDT          C_VDAT
      *
      ** Set Posting Date according to FT Control Data.
      *
     C                   IF        WPDTI  = 'I'
     C                   Z-ADD     BJRDNB        C_PSTD
     C                   ELSE
      *
     C                   IF        WPDTI  = 'E'
     C                   Z-ADD     SLDT          C_PSTD
     C                   ELSE
      *
     C                   IF        SLDT < PVDT
     C                   Z-ADD     SLDT          C_PSTD
     C                   ELSE
     C                   Z-ADD     PVDT          C_PSTD
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVEL     'I'           C_IO
     C                   MOVEL     SMCY          C_CCY
     C                   MOVEL     PYTP          C_TRYP
     C                   MOVEL     PREF          C_PRef
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   MOVEL     PREF          C_NARR                                       CRE020
     C                   Z-ADD     1             C_CHQN                                       CRE020
     C                   IF        WRevAst = 'Y'                                              CRE020
     C                   EVAL      %SUBST(C_NARR:30:1) = '*'                                  CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
     C                   Z-ADD     WVSMAM        C_AMT
     C                   MOVEL     'FT'          C_MOD
     C                   MOVEL     '01'          C_OLRC
     C                   MOVEL     PFTOV         C_FTOV
     C                   MOVEL     'Y'           C_RPST
     C                   Z-ADD     10            C_RPNB
     C                   MOVEL     'D'           C_RTYP
     C                   IF        CAP205 = 'Y'                                               CAP205
     C                   MOVEL     'F'           C_MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C/COPY WNCPYSRC,FTH00391
      *
      ** Call AOSPOSU0.
      *
     C                   CALLB     'AOSPOSU0'                           9090
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*ADD    '    PACT
     C                   PARM      C_DTA         PDTA
      *
     C                   IF        *IN90 = '1' OR PRtcd <> *BLANKS
     C                   MOVEL     '*CALL'       DBKey
     C                   MOVEL     'AOSPOSU0'    DBFile
     C                   MOVEL     008           DBase
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C/COPY WNCPYSRC,FTH00410
     C                   ENDIF
      *
      ** PAYMENT INSTRUCTIONS.
      *
     C                   IF        ACBT = *BLANK OR
     C                             OPIN <> 'Y'
      *
      ** Only execute if Outgoing Payment not to be generated.
      *
     C                   CLEAR                   C_DTA
     C/COPY WNCPYSRC,FTH00485
      *
      ** Move fields to C_DTA structure.
      *
     C                   IF        ACBT <> *BLANKS
     C                   MOVEL     ACBT          C_ATYP
     C                   MOVEL     ACBK          C_ACCT
     C                   EXSR      SRFLGL                                                     CGL029
     C                   MOVEL     ACBB          C_BRCA
     C                   ELSE
     C                   MOVEL     BNCT          C_ATYP
      *
      ** If not IBAN
     C                   IF        BNCT <> 'I' AND CFT004 = 'Y' OR
     C                             CFT004 <> 'Y'
     C                   MOVEL     BNC1          C_ACCT
     C                   EXSR      SRFLGL                                                     CGL029
     C                   ELSE
      *                                                                         CFT014
     C                   EVAL      PIBAN = %SUBST(BNC1:2:34)                    CFT014
     C                   CALLB     'AOIBANR4'                                   CFT014
     C                   PARM      *BLANKS       PNRTCD                         CFT014
     C                   PARM      '*KEY   '     PNOPTN                         CFT014
     C                   PARM                    PIBAN                          CFT014
     C     P@ACCN        PARM      *BLANKS       DSSDY                          CFT014
      *                                                                         CFT014
     C                   IF        PNRTCD <> *BLANKS                            CFT014
     C                   EVAL      DBKey = PIBAN                                CFT014
     C                   EVAL      DBFile = 'ACCNTAB'                           CFT014
     C                   Z-ADD     026           DBase                          CFT014
     C                   EXSR      SRERR                                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C**********         Z-ADD     CNUM          WICNUM                         CFT014        CSD027
     C                   EVAL      WICNUM = CNUM                                CFT014        CSD027
     C                   MOVE      CCY           WICCY                          CFT014
     C                   Z-ADD     ACOD          WIACOD                         CFT014
     C                   Z-ADD     ACSQ          WIACSQ                         CFT014
     C                   MOVE      IBNBRCA       WIBRCA                         CFT014
     C                   MOVEL     WIACNT        C_ACCT                         CFT014
     C                   EXSR      SRFLGL                                                     CGL029
     C***********        Z-ADD     IBCNUM        C_CNU1                         CFT014
     C***********        MOVE      IBCCY         C_CCY1                         CFT014
     C***********        Z-ADD     IBACOD        C_ACO1                         CFT014
     C***********        Z-ADD     IBACSQ        C_ACS1                         CFT014
     C***********        MOVE      IBBRCA        C_BRC1                         CFT014
      *                                                                         CFT014
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     PVDT          C_VDAT
      *
      ** Set Posting Date according to FT Control Data.
      *
     C                   IF        WPDTI  = 'I'
     C                   Z-ADD     BJRDNB        C_PSTD
     C                   ELSE
      *
     C                   IF        WPDTI  = 'E'
     C                   Z-ADD     PVDT          C_PSTD
     C                   ELSE
      *
     C                   IF        SLDT < PVDT
     C                   Z-ADD     SLDT          C_PSTD
     C                   ELSE
     C                   Z-ADD     PVDT          C_PSTD
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVEL     'O'           C_IO
     C                   MOVEL     PCCY          C_CCY
     C                   MOVEL     PYTP          C_TRYP
     C                   MOVEL     PREF          C_PRef
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   MOVEL     PREF          C_NARR                                       CRE020
     C                   Z-ADD     2             C_CHQN                                       CRE020
     C                   IF        WRevAst = 'Y'                                              CRE020
     C                   EVAL      WRevAst = ' '                                              CRE020
     C                   EVAL      %SUBST(C_NARR:30:1) = '*'                                  CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
     C                   Z-SUB     WVPYAM        C_AMT
     C                   MOVEL     'FT'          C_MOD
     C                   MOVEL     '01'          C_OLRC
     C                   MOVEL     PFTOV         C_FTOV
     C                   MOVEL     'Y'           C_RPST
     C                   Z-ADD     20            C_RPNB
     C                   MOVEL     'C'           C_RTYP
     C                   IF        CAP205 = 'Y'                                               CAP205
     C                   MOVEL     'F'           C_MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C/COPY WNCPYSRC,FTH00507
      *
      ** Call AOSPOSU0.
      *
     C                   CALLB     'AOSPOSU0'                           9090
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*ADD    '    PACT
     C                   PARM      C_DTA         PDTA
      *
     C                   IF        *IN90 = '1' OR Prtcd <> *BLANKS
     C                   MOVEL     '*CALL'       DBKey
     C                   MOVEL     'AOSPOSU0'    DBFile
     C                   MOVEL     009           DBase
     C                   EXSR      *PSSR
     C                   ENDIF
     C/COPY WNCPYSRC,FTH00486
      *
     C                   ENDIF
      *
     C/COPY WNCPYSRC,FTH00411
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSChg - Amend charges from database                         *
      *                                                               *
      *****************************************************************
      *
     C     SRSChg        BEGSR
      *
     C     *LIKE         DEFINE    C_AMT         WVCHGS
      *
      ** Move fields to C_DTA structure.
      *
     C                   CLEAR                   C_DTA
      *
      ** If add, use Receiver's Correspondent and Sender.
      *
     C                   SELECT
      *
     C     CDRT          WHENNE    *BLANKS
     C                   MOVEL     CDRT          C_ATYP
     C                   MOVEL     CDRO          C_ACCT
     C                   EXSR      SRFLGL                                                     CGL029
     C                   MOVEL     CDBR          C_BRCA
      *                                                                                       CFT120
     C                   IF        CFT120 = 'N'  OR                                           CFT120
     C                             CFT120 = 'Y' AND INCDRC = *BLANKS                          CFT120
     C                   MOVEL     BJCYCD        C_CCY
     C                   ELSE                                                                 CFT120
     C                   MOVEL     INCDRC        C_CCY                                        CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   IF        ADDC = 'A'
     C                   Z-ADD     SLDT          C_VDAT
     C                   ELSE
     C                   Z-ADD     PVDT          C_VDAT
     C                   ENDIF
      *
     C     ADDC          WHENEQ    'A'
     C                   MOVEL     SMCY          C_CCY
     C***********        IF        RCRT <> *BLANKS                              CFT014
     C***********        MOVEL     RCRT          C_ATYP                         CFT014
     C***********        MOVEL     RCCO          C_ACCT                         CFT014
      *                                                                         CFT014
     C                   IF        INTRIT <> *BLANKS and CFT014 = 'Y'           CFT014
     C                   MOVEL     INTRIT        C_ATYP                         CFT014
      *                                                                         CFT014
      ** Determine corresponding Midas account of IBAN account                  CFT014
      ** for Third Reimbursement Institution.                                   CFT014
      *                                                                         CFT014
     C                   IF        INTRIT = 'I' and CFT004 = 'Y'                CFT014
     C                   EVAL      PIBAN = INTRIB                               CFT014
     C                   CALLB     'AOIBANR4'                                   CFT014
     C                   PARM      *BLANKS       PNRTCD                         CFT014
     C                   PARM      '*KEY   '     PNOPTN                         CFT014
     C                   PARM                    PIBAN            34            CFT014
     C     P@ACCN        PARM      *BLANKS       DSSDY                          CFT014
      *                                                                         CFT014
     C                   IF        PNRTCD <> *BLANKS                            CFT014
     C                   EVAL      DBKey = PIBAN                                CFT014
     C                   EVAL      DBFile = 'ACCNTAB'                           CFT014
     C                   Z-ADD     026           DBase                          CFT014
     C                   EXSR      SRERR                                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C**********         Z-ADD     CNUM          WICNUM                         CFT014        CSD027
     C                   EVAL      WICNUM = CNUM                                CFT014        CSD027
     C                   MOVE      CCY           WICCY                          CFT014
     C                   Z-ADD     ACOD          WIACOD                         CFT014
     C                   Z-ADD     ACSQ          WIACSQ                         CFT014
     C                   MOVE      IBNBRCA       WIBRCA                         CFT014
     C                   MOVEL     WIACNT        C_ACCT                         CFT014
     C                   EXSR      SRFLGL                                                     CGL029
      *                                                                         CFT014
     C                   ELSE                                                   CFT014
     C                   MOVEL     INTRIB        C_ACCT                         CFT014
     C                   EXSR      SRFLGL                                                     CGL029
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ELSE                                                   CFT014
      *                                                                         CFT014
     C                   IF        INRCRT <> *BLANKS                            CFT014
     C                   MOVEL     INRCRT        C_ATYP                         CFT014
      *                                                                         CFT014
      ** Determine corresponding Midas account of IBAN account                  CFT014
      ** for Receiver's Correspondent.                                          CFT014
      *                                                                         CFT014
     C                   IF        INRCRT = 'I' and CFT004 = 'Y'                CFT014
     C                   EVAL      PIBAN = %SUBST(INRCO1:2:34)                  CFT014
     C                   CALLB     'AOIBANR4'                                   CFT014
     C                   PARM      *BLANKS       PNRTCD                         CFT014
     C                   PARM      '*KEY   '     PNOPTN                         CFT014
     C                   PARM                    PIBAN                          CFT014
     C     P@ACCN        PARM      *BLANKS       DSSDY                          CFT014
      *                                                                         CFT014
     C                   IF        PNRTCD <> *BLANKS                            CFT014
     C                   EVAL      DBKey = PIBAN                                CFT014
     C                   EVAL      DBFile = 'ACCNTAB'                           CFT014
     C                   Z-ADD     027           DBase                          CFT014
     C                   EXSR      SRERR                                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C**********         Z-ADD     CNUM          WICNUM                         CFT014        CSD027
     C                   EVAL      WICNUM = CNUM                                CFT014        CSD027
     C                   MOVE      CCY           WICCY                          CFT014
     C                   Z-ADD     ACOD          WIACOD                         CFT014
     C                   Z-ADD     ACSQ          WIACSQ                         CFT014
     C                   MOVE      IBNBRCA       WIBRCA                         CFT014
     C                   MOVEL     WIACNT        C_ACCT                         CFT014
     C                   EXSR      SRFLGL                                                     CGL029
      *                                                                         CFT014
     C                   ELSE                                                   CFT014
     C                   MOVEL     INRCO1        C_ACCT                         CFT014
     C                   EXSR      SRFLGL                                                     CGL029
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ELSE
     C                   MOVEL     SNTP          C_ATYP
     C                   MOVEL     SND1          C_ACCT
     C                   EXSR      SRFLGL                                                     CGL029
     C                   ENDIF
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   Z-ADD     SLDT          C_VDAT
      *
      ** If deduct, use Account with Bank and Beneficiary.
      *
     C                   OTHER
     C                   MOVEL     PCCY          C_CCY
     C                   IF        ACBT <> *BLANKS
     C                   MOVEL     ACBT          C_ATYP
     C                   MOVEL     ACBK          C_ACCT
     C                   EXSR      SRFLGL                                                     CGL029
     C                   MOVEL     ACBB          C_BRCA
     C                   ELSE
     C                   MOVEL     BNCT          C_ATYP
      *                                                                                       229560
      ** Extract the a/c name if IBAN before call to AOSPOS                                   229560
b1   C                   IF        BNCT = 'I' AND CFT004 = 'Y'                                229560
      *                                                                                       229560
     C                   EVAL      PIBAN = %SUBST(BNC1:2:34)                                  229560
     C                   CALLB     'AOIBANR4'                                                 229560
     C                   PARM      *BLANKS       PNRTCD                                       229560
     C                   PARM      '*KEY   '     PNOPTN                                       229560
     C                   PARM                    PIBAN                                        229560
     C     P@ACCN        PARM      *BLANKS       DSSDY                                        229560
      *                                                                                       229560
b2   C                   IF        PNRTCD <> *BLANKS                                          229560
     C                   EVAL      DBKey = PIBAN                                              229560
     C                   EVAL      DBFile = 'ACCNTAB'                                         229560
     C                   Z-ADD     926           DBase                                        229560
     C                   EXSR      SRERR                                                      229560
e2   C                   ENDIF                                                                229560
      *                                                                                       229560
     C**********         Z-ADD     CNUM          WICNUM                                229560 CSD031
     C                   EVAL      WICNUM = CNUM                                              CSD031
     C                   MOVE      CCY           WICCY                                        229560
     C                   Z-ADD     ACOD          WIACOD                                       229560
     C                   Z-ADD     ACSQ          WIACSQ                                       229560
     C                   MOVE      IBNBRCA       WIBRCA                                       229560
     C                   MOVEL     WIACNT        C_ACCT                                       229560
x1   C                   ELSE                                                                 229560
     C                   MOVEL     BNC1          C_ACCT
e1   C                   ENDIF                                                                229560
     C                   EXSR      SRFLGL                                                     CGL029
     C                   ENDIF
     C                   Z-ADD     PVDT          C_VDAT
      *
     C                   ENDSL
      *
      ** Set Posting Date according to FT Control Data.
      *
     C                   IF        WPDTI  = 'I'
     C                   Z-ADD     BJRDNB        C_PSTD
     C                   ELSE
      *
     C                   IF        WPDTI  = 'E'
      *
     C                   IF        ADDC = 'A'
     C                   Z-ADD     SLDT          C_PSTD
     C                   ELSE
     C                   Z-ADD     PVDT          C_PSTD
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        SLDT < PVDT
     C                   Z-ADD     SLDT          C_PSTD
     C                   ELSE
     C                   Z-ADD     PVDT          C_PSTD
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVEL     'I'           C_IO
     C                   MOVEL     PYTP          C_TRYP
     C                   MOVEL     PREF          C_PRef
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   MOVEL     PREF          C_NARR                                       CRE020
     C                   Z-ADD     3             C_CHQN                                       CRE020
     C                   IF        WRevAst = 'Y'                                              CRE020
     C                   EVAL      WRevAst = ' '                                              CRE020
     C                   EVAL      %SUBST(C_NARR:30:1) = '*'                                  CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
     C                   MOVEL     'FT'          C_MOD
     C                   MOVEL     '01'          C_OLRC
     C                   MOVEL     PFTOV         C_FTOV
     C                   Z-ADD     WVCHGS        C_AMT
     C                   MOVEL     'Y'           C_RPST
     C                   Z-ADD     30            C_RPNB
     C                   MOVEL     'D'           C_RTYP
     C                   IF        CAP205 = 'Y'                                               CAP205
     C                   MOVEL     'F'           C_MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C/COPY WNCPYSRC,FTIPAYDC07
      *
      ** Call AOSPOSU0.
      *
     C*******************CALL      'AOSPOSU0'                           9090    185764
     C                   CALLB     'AOSPOSU0'                           9090    185764
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*ADD    '    PACT
     C                   PARM      C_DTA         PDTA
      *
     C                   IF        *IN90 = '1' OR PRtcd <> *BLANKS
     C                   MOVEL     '*CALL'       DBKey
     C                   MOVEL     'AOSPOSU0'    DBFile
     C                   MOVEL     010           DBase
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C/COPY WNCPYSRC,FTH00412
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRShadow - Update database with shadow positions             *
      *                                                               *
      *****************************************************************
      *
     C     SRShadow      BEGSR
      *
      ** Call AOSPOSU0 to update database.
      *
     C                   CALLB     'AOSPOSU0'                           9090
     C                   PARM      *BLANKS       PRtcd             7
     C                   PARM      '*UPDATE '    PACT              8
     C                   PARM      C_DTA         PDTA            256
      *
     C                   IF        *IN90 = '1' OR PRtcd <> *BLANKS
     C                   MOVEL     '*CALL'       DBKey
     C                   MOVEL     'AOSPOSU0'    DBFile
     C                   MOVEL     011           DBase
     C                   EXSR      *PSSR
     C                   ENDIF
     C/COPY WNCPYSRC,FTH00415
      *
     C                   ENDSR
     C/COPY WNCPYSRC,FTH00487
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SRMsgDel - Remove electronic message from the Outstanding   *
      *              Reserved Messages file after it has been         *
      *              inserted                                         *
      *                                                               *
      *****************************************************************
      *
     C     SRMsgDel      BEGSR
      *
      ** All electronic messages selected are held on the file FTINMGPD
      ** for reservation purposes.
      *
      ** The electronic message that was just inserted must be removed
      ** from the file.
      *
      ** The COMIT is done on the succesful completion of Insert
      ** processing.
      *
      ** Set up message ref. and part nbr.
      *
     C                   Z-ADD     INMSGR        PMsgr
     C                   Z-ADD     INKPRT        PKprt
      *
     C                   CALL      'ME1070'                             9090
     C                   PARM      '*DEL   '     PActC             7
     C                   PARM                    PMsgr             8 0
     C                   PARM                    PKprt             3 0
     C                   PARM                    PMor             28
     C                   PARM                    PMir             28
     C                   PARM      *BLANKS       PRtn              7
      *
      ** Error occurred.
      *
     C                   IF        *IN90 = '1' OR PRtn = '*ERROR*'
     C                   MOVEL     '*CALL'       DBKey
     C                   MOVEL     'ME1070'      DBFile
     C                   MOVEL     012           DBase
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInFT - Update Incoming Message FT Transaction Status       *
      *           File record                                         *
      *                                                               *
      *****************************************************************
      *
     C     SRInFT        BEGSR
      *
      ** Get full account details.
      *
     C                   EXSR      SRFulAccnt
      *
     C                   CLEAR                   PINFT
      *
      ** Fill record format data structure with available data.
      *
     C***********        IF        RCRT <> *BLANKS                              CFT014
     C                   IF        INRCRT <> *BLANKS                            CFT014
     C**********         MOVEL     WRCCDS        WFRWR            18                          CGL029
     C                   MOVEL     WRCCDS        WFRWR                                        CGL029
     C                   ELSE
     C                   MOVEL     WSNDDS        WFRWR
     C                   ENDIF
      *
     C                   IF        ACBT <> *BLANKS
     C**********         MOVEL     WACBDS        WTOWR            18                          CGL029
     C                   MOVEL     WACBDS        WTOWR                                        CGL029
     C                   ELSE
     C                   MOVEL     WBNCDS        WTOWR
     C                   ENDIF
      *
     C                   Z-ADD     INMSGR        FTMSGR
     C                   Z-ADD     INKPRT        FTKPRT
     C                   MOVEL     BRCA          FTBRCA
     C                   MOVEL     W0Flag        FTINFG
     C                   MOVEL     PREF          FTIPRF
     C                   MOVEL     WFRWR         FTFRGL
     C                   MOVEL     WTOWR         FTTOGL
      *
     C                   MOVEL     W0LMSG        PWLMSG
     C                   MOVEL     PNWRK         PWNWRK
      *
      ** N.B. Audit Stamp details are determined in called program.
      *
      ** Set up data to be passed using the rcd format data structure.
      *
     C                   CALL      'ME1050'                             9090
     C                   PARM      '*FT INC '    PWACT             8
     C                   PARM      PSProcPgm     PWCPGM           10
     C                   PARM                    PWNWRK            6
     C                   PARM                    PWLMSG            7
     C                   PARM                    PINFT
     C                   PARM      *BLANKS       PWRTN             7
      *
      ** Error occurred.
      *
     C                   IF        *IN90 = '1' OR PWRTN = '*ERROR*'
     C                   MOVEL     '*CALL'       DBKey
     C                   MOVEL     'ME1050'      DBFile
     C                   MOVEL     013           DBase
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFulAccnt - Get full account details                        *
      *                                                               *
      *****************************************************************
      *
     C     SRFulAccnt    BEGSR
      *
      ** Sender.
      *
     C                   CLEAR                   WSNDDS
      *
     C     SNTP          IFEQ      'F'
     C     SNTP          OREQ      'R'
     C     SNTP          OREQ      'G'
      *
      ** Setup keys for account details retrieval.
      *
     C                   IF        SNTP = 'F'
     C                   EVAL      WAXSBY = 'NOSTRO'
     C                   MOVEL     SND1          WKEYL5            5
     C                   MOVEL     WKEYL5        WNOCCY            3
     C                   MOVE      WKEYL5        WNOCOD            2
      *
     C                   ELSE
      *
     C                   IF        SNTP = 'R'
     C                   EVAL      WAXSBY = 'RETAIL'
     C                   MOVEL     SND1          WRACNO           10
      *
     C                   ELSE
      *
     C                   EVAL      WAXSBY = 'ACCNTS'
     C                   EVAL      WKEYL18 = SND1
     C                   MOVEL     WKEYL18       WACCNT
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Access Account record.
      *
     C                   EXSR      SRAcnt
      *
      ** Store full account details for FT Transaction Status File
      ** record update.
      *
     C**********         Z-ADD     ACCNUM        WICNUM                                       CSD027
     C                   EVAL      WICNUM = ACCNUM                                            CSD027
     C                   MOVE      ACCCY         WICCY
     C                   Z-ADD     ACACOD        WIACOD
     C                   Z-ADD     ACACSQ        WIACSQ
     C                   MOVE      ACBRCA        WIBRCA
     C                   MOVEL     WIACNT        WSNDDS
      *
     C                   ENDIF
      *
      ** Receiver's Correspondence.
      *
     C                   CLEAR                   WRCCDS
      *
     C*****RCRT**        IFEQ      'N'                                          CFT014
     C*****RCRT**        OREQ      'R'                                          CFT014
     C                   IF        INRCRT = 'N' or INRCRT = 'R'                 CFT014
      *
      ** Setup keys for account details retrieval.
      *
     C***********        IF        RCRT = 'N'                                   CFT014
     C                   IF        INRCRT = 'N'                                 CFT014
     C                   EVAL      WAXSBY = 'NOSTRO'
     C                   EVAL      WNOCCY = SMCY
     C***********        MOVEL     RCCO          WNOCOD                         CFT014
     C                   MOVEL     INRCO1        WNOCOD                         CFT014
      *
     C                   ELSE
      *
     C                   EVAL      WAXSBY = 'RETAIL'
     C***********        MOVEL     RCCO          WRACNO                         CFT014
     C                   MOVEL     INRCO1        WRACNO                         CFT014
     C                   ENDIF
      *
      ** Access Account record.
      *
     C                   EXSR      SRAcnt
      *
      ** Store full account details for FT Transaction Status File
      ** record update.
      *
     C**********         Z-ADD     ACCNUM        WICNUM                                       CSD027
     C                   EVAL      WICNUM = ACCNUM                                            CSD027
     C                   MOVE      ACCCY         WICCY
     C                   Z-ADD     ACACOD        WIACOD
     C                   Z-ADD     ACACSQ        WIACSQ
     C                   MOVE      ACBRCA        WIBRCA
     C                   MOVEL     WIACNT        WRCCDS
      *
     C                   ENDIF
      *
      ** Beneficiary.
      *
     C                   CLEAR                   WBNCDS
      *
     C     BNCT          IFEQ      'R'
     C     BNCT          OREQ      'P'
      *
      ** Setup keys for account details retrieval.
      *
     C                   IF        BNCT = 'R'
     C                   EVAL      WAXSBY = 'RETAIL'
     C                   MOVEL     BNC1          WRACNO
      *
     C                   ELSE
      *
     C**********         MOVEL     BNC1          WKEYL15          15                          CGL029
     C**********         MOVE      WKEYL15       WKEYL18          18                          CGL029
     C                   MOVEL     BNC1          WKEYL15          21                          CGL029
     C                   MOVE      WKEYL15       WKEYL18          24                          CGL029
     C                   MOVEL     BNC1          WKEYL9            9
     C                   MOVE      PCCY          WKEYL9
     C**********         MOVEL     BNC1          WKEYL12          12                          CGL029
     C                   MOVEL     BNC1          WKEYL12          18                          CGL029
     C                   MOVE      WKEYL12       WKEYL15
     C                   MOVEL     WKEYL9        WKEYL15
     C                   MOVEL     WKEYL15       WKEYL18
      *
     C                   EVAL      WAXSBY = 'ACCNTS'
     C                   EVAL      WACCNT = WKEYL18
      *
     C                   ENDIF
      *
      ** Access Account record.
      *
     C                   EXSR      SRAcnt
      *
      ** Store full account details for FT Transaction Status File
      ** record update.
      *
     C**********         Z-ADD     ACCNUM        WICNUM                                       CSD027
     C                   EVAL      WICNUM = ACCNUM                                            CSD027
     C                   MOVE      ACCCY         WICCY
     C                   Z-ADD     ACACOD        WIACOD
     C                   Z-ADD     ACACSQ        WIACSQ
     C                   MOVE      ACBRCA        WIBRCA
     C                   MOVEL     WIACNT        WBNCDS
      *
     C                   ENDIF
      *
      ** Account with Bank.
      *
     C                   CLEAR                   WACBDS
      *
     C     ACBT          IFEQ      'N'
     C     ACBT          OREQ      'R'
     C     ACBT          OREQ      'P'
      *
      ** Setup keys for account details retrieval.
      *
     C                   IF        ACBT = 'N'
     C                   EVAL      WAXSBY = 'NOSTRO'
     C                   EVAL      WNOCCY = PCCY
     C                   EVAL      WNOCOD = ACBK
      *
     C                   ELSE
      *
     C                   IF        ACBT = 'R'
     C                   EVAL      WAXSBY = 'RETAIL'
     C                   MOVEL     ACBK          WRACNO
      *
     C                   ELSE
      *
     C                   MOVEL     ACBK          WKEYL9
     C                   MOVE      PCCY          WKEYL9
     C                   MOVE      ACBK          WKEYL15
     C                   MOVEL     WKEYL9        WKEYL15
     C                   MOVE      ACBB          WKEYL18
     C                   MOVEL     WKEYL15       WKEYL18
      *
     C                   EVAL      WAXSBY = 'ACCNTS'
     C                   EVAL      WACCNT = WKEYL18
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Access Account record.
      *
     C                   EXSR      SRAcnt
      *
      ** Store full account details for FT Transaction Status File
      ** record update.
      *
     C**********         Z-ADD     ACCNUM        WICNUM                                       CSD027
     C                   EVAL      WICNUM = ACCNUM                                            CSD027
     C                   MOVE      ACCCY         WICCY
     C                   Z-ADD     ACACOD        WIACOD
     C                   Z-ADD     ACACSQ        WIACSQ
     C                   MOVE      ACBRCA        WIBRCA
     C                   MOVEL     WIACNT        WACBDS
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcnt - Retrieve account details                            *
      *                                                               *
      *****************************************************************
      *
     C     SRAcnt        BEGSR
      *
     C                   IF        WAXSBY = 'NOSTRO'
      *
     C                   CALLB     'AONOSTR0'
     C                   PARM      *Blanks       PNRtCd            7
     C                   PARM      '*KEY   '     PNOptn            7
     C                   PARM      *Blanks       PNCust            6
     C                   PARM      WNOCCY        PNCyCd            3
     C**********         PARM      *Blanks       PNAccN            4                          CGL029
     C                   PARM      *BLANKS       PNAccN                                       CGL029
     C                   PARM      *Blanks       PNAcSN            2
     C                   PARM      WNOCOD        PNNoNb            2
     C                   PARM      *Blanks       PNBrCd            3
     C                   PARM      *Blanks       PNCsSN           10
     C                   PARM      *Blanks       PNPNOI            1
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C                   IF        PNRTCD <> *BLANKS
     C                   MOVEL     WNOCCY        WNOST             5
     C                   MOVE      WNOCOD        WNOST
     C                   MOVEL     WNOST         DBKey
     C                   MOVEL     'SDNOSTPD'    DBFile
     C                   Z-ADD     014           DBase
     C                   EXSR      SRERR
     C                   ELSE
     C                   MOVE      A7CUST        ACCNUM
     C                   MOVE      A7CYCD        ACCCY
     C                   MOVE      A7ACCD        ACACOD
     C                   MOVE      A7ACSN        ACACSQ
     C                   MOVE      A7BRCD        ACBRCA
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        WAXSBY = 'RETAIL'
      *
     C                   MOVEL     WRACNO        WKACNO           10 0
     C     WKACNO        CHAIN     ACNUMA                             99
      *
     C                   IF        *IN99 = *On
     C                   MOVEL     WKACNO        DBKey
     C                   MOVEL     'ACNUMA'      DBFile
     C                   Z-ADD     015           DBase
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ELSE
      *
     C     KACCNT        CHAIN     ACCNT                              99
      *
     C                   IF        *IN99 = *On
     C                   MOVEL     WACCNT        DBKey
     C                   MOVEL     'ACCNT'       DBFile
     C                   Z-ADD     016           DBase
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLOG - Add Incoming Message Log File record                 *
      *                                                               *
      *****************************************************************
      *
     C     SRLOG         BEGSR
      *
      ** Fill record format data structure with available data.
      *
     C                   CLEAR                   PINLF
      *
     C                   Z-ADD     INMSGR        LFMSGR
     C                   Z-ADD     INKPRT        LFKPRT
     C                   MOVEL     W0LMSG        LFMSID
     C                   MOVEL     PREF          LFMSDT
     C                   MOVEL     *BLANKS       LFARSM
     C                   MOVEL     *BLANKS       LFARSD
     C                   MOVEL     PSProcPgm     LFCPGM
     C                   MOVEL     PSProcPgm     LFRPGM
      *
      ** N.B. Audit Stamp details are determined in called program.
      *
      ** Set up data to be passed using the rcd format data structure.
      *
     C                   CALL      'ME1040'                             9090
     C                   PARM      '*ADD    '    PWACT
     C                   PARM                    PINLF
     C                   PARM      *BLANKS       PWRTN
      *
      ** Error occurred.
      *
     C                   IF        *IN90 = '1' OR PWRTN = '*ERROR*'
     C                   MOVEL     '*CALL'       DBKey
     C                   MOVEL     'ME1040'      DBFile
     C                   MOVEL     017           DBase
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTrailer - Update Incoming Payments trailer record          *
      *                                                               *
      *****************************************************************
      *
     C     SRTrailer     BEGSR
      *
      ** Read trailer record.
      *
     C     1             CHAIN     INPAYZZ                            99
      *
     C                   IF        *IN99 = '1'
     C                   MOVEL     'MISSING'     WDBKey           15
     C                   MOVE      'TRAILER'     WDBKey
     C                   MOVEL     WDBKey        DBKey
     C                   MOVEL     'INPAYZZ'     DBFile
     C                   MOVEL     018           DBase
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Increment record count if Change Type is 'I'.
      *
     C                   IF        WCHTP = 'I'
     C                   ADD       1             NORE1
     C                   ENDIF
      *
      ** Increment hash totals of Payment Amounts.
      *
     C                   Z-ADD     HRWN          ZZTOTI
     C                   Z-ADD     HRDC          ZZTOTD
      *
     C                   EXSR      SRGLZADD
      *
     C                   Z-ADD     ZZTOTI        HRWN
     C                   Z-ADD     ZZTOTD        HRDC
      *
      ** Update trailer record.
      *
     C                   UPDATE    INPAYZZF                             99
      *
     C                   IF        *IN99 = '1'
     C                   MOVEL     'MISSING'     WDBKey
     C                   MOVE      'TRAILER'     WDBKey
     C                   MOVEL     WDBKey        DBKey
     C                   MOVEL     'INPAYZZ'     DBFile
     C                   MOVEL     019           DBase
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGLZADD - Add an amount (ZZAMT) to the total (ZZTOTI,       *
      *             ZZTOTD)                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRGLZADD      BEGSR
      *
     C                   Z-ADD     ZZAMT         ZZAMT            15 3    91
     C                   IF        *IN91 = *ON
     C                   GOTO      EGLZADD
     C                   ENDIF
      *
      ** Split ZZAMT into integer and decimal fields.
      *
     C                   Z-ADD     ZZAMT         ZZAMTI           15 0
     C                   MOVE      ZZAMT         ZZAMTD            3 0
      *
      ** Both ZZAMTI and ZZAMTD contain a 'SIGN' zone now.
      *
     C                   EXSR      SRGLZSUM
      *
     C     EGLZADD       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGLZSUM - Carry out addition                                *
      *                                                               *
      *****************************************************************
      *
     C     SRGLZSUM      BEGSR
      *
     C                   Z-ADD     ZZTOTI        ZZTOTI           15 0
     C                   Z-ADD     ZZTOTD        ZZTOTD            3 0
     C                   SETOFF                                       919293
     C                   SETOFF                                       949599
      *
      ** Determine sign of ZZAMTI/D (92 if negative).
      *
     C     ZZAMTI        COMP      0                                    9293
     C   93ZZAMTD        COMP      0                                    9293
     C   93              GOTO      ZZSEND
      *
      ** Determine sign of ZZTOTI/D (91 if negative).
      *
     C     ZZTOTI        COMP      0                                    9193
     C   93ZZTOTD        COMP      0                                    9193
      *
      **  If ZZTOTAL is zero, return ZZAmount.
      *
     C   93              Z-ADD     ZZAMTI        ZZTOTI
     C   93              Z-ADD     ZZAMTD        ZZTOTD
     C   93              GOTO      ZZSEND
      *
      ** If signs differ, bypass overflow checks.
      *
     C   91
     CANN92
     CORN91
     CAN 92              GOTO      ZZOFPS
      *
     C     ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
     C     ZZWK2         COMP      999                                93
     C  N93ZZWK2         COMP      -999                                 93
      *
     C   93
     CANN92ZZAMTI        ADD       1             ZZWK3            15 0
     C   93
     CAN 92ZZAMTI        SUB       1             ZZWK3
     C   93ZZTOTI        ADD       ZZWK3         ZZWK3
     C  N93ZZTOTI        ADD       ZZAMTI        ZZWK3
      *
      ** If the modulus of ZZWK3 is LT mod. ZZTOTI, then O/F has
      ** occurred.
      *
     C  N92ZZWK3         COMP      ZZTOTI                               99
     C   92ZZWK3         COMP      ZZTOTI                             99
     C  N99              Z-ADD     ZZWK2         ZZTOTD
     C  N99              Z-ADD     ZZWK3         ZZTOTI
      *
      ** If O/F, zeroise ZZAMT, indicator 99 set and ZZTOT
      ** fields left intact.
      *
     C   99              Z-ADD     0             ZZAMT            15 3
     C                   GOTO      ZZSEND
      *
      ** The 'SIGNS' are different.
      *
     C     ZZOFPS        TAG
      *
      ** If ZZAMT was negative, make it positive to compare
      ** with ZZTOT.
      *
     C   92              Z-SUB     ZZAMTI        ZZAMTI           15 0
     C   92              Z-SUB     ZZAMTD        ZZAMTD            3 0
      *
      ** If ZZTOT was negative, make it positive to compare
      ** with ZZAMT.
      *
     C   91              Z-SUB     ZZTOTI        ZZTOTI
     C   91              Z-SUB     ZZTOTD        ZZTOTD
      *
      ** Both ZZAMT and ZZTOT are now positive.
      *
     C     ZZTOTI        COMP      ZZAMTI                             93  95
     C   95ZZTOTD        COMP      ZZAMTD                             93  95
      *
      ** If ZZTOT EQ ZZAMT, return zero.
      *
     C   95              Z-ADD     0             ZZTOTI
     C   95              Z-ADD     0             ZZTOTD
     C   95              GOTO      ZZSEND
      *
      ** If ZZTOT GT ZZAMT.
      *
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
      *
      ** If ZZAMT GT ZZTOT.
      *
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
      *
      ** Reverse sign of ZZTOT if larger I/P fields were negative.
      *
     C                   SETOFF                                       94
     C   93
     CAN 91
     CORN93
     CAN 92              SETON                                        94
     C   94              Z-SUB     ZZTOTI        ZZTOTI
     C   94              Z-SUB     ZZTOTD        ZZTOTD
      *
      ** Restore sign of ZZAMTI and ZZAMTD if it was reversed.
      *
     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD
     C     ZZSEND        TAG
      *
      ** If ZZTOTD is zero and ZZTOTI is negative, set up ZZNEGD.
      *
     C                   SETOFF                                       96
     C     ZZTOTD        COMP      0                                      91
     C   91ZZTOTI        COMP      0                                    96
     C   96              MOVE      '.000-'       ZZNEGD            5
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
     C                   PARM                    NwIP2FilFmt                    CFT014
      *
      ** IBANs full account
     C                   PARM                    PIBANAcc
      *
      ** Originally Insert from Level 2 Entry
     C                   PARM                    POrigACTN         1
      *
      ** FT Override for GL Balances
     C                   PARM                    PFTOV             1
      *
      ** FT Control Data
     C                   PARM                    PCNTRL
      *
      ** Network
     C                   PARM                    PNWRK             6
      *
      ** Entry Point
     C                   PARM                    PParmLevel        1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Base Currency Code
     C**********         PARM                    BJCYCD            3                          CAP211
     C     BJCYCD        PARM                    BJCYCDBJ          3                          CAP211
      *
      ** SDBANK - Midas Run Date
     C**********         PARM                    BJRDNB            5 0                        CAP211
     C     BJRDNB        PARM                    BJRDNBBJ          5 0                        CAP211
      *
      ** SDBANK - Single Branch Code
     C**********         PARM                    BJSBRC            3                          CAP211
     C     BJSBRC        PARM                    BJSBRCBJ          3                          CAP211
      *
      ** SDGELR - Originating Branch/User Vald Req.
     C                   PARM                    BKOBUV            1
      *
      ** ZMUSER - Default Branch
     C                   PARM                    PDBRN             3
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Batch Authorisation
     C                   PARM                    CFT003            1
      *
      ** IBAN numbers
     C                   PARM                    CFT004            1
      *
      ** BLI FT Enhancements Feature
     C                   PARM                    S01494            1
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499            1
      *                                                                         CFT014
      ** STP Phase 2 MT103                                                      CFT014
     C                   PARM                    CFT014                         CFT014
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009            1            CFT009
     C                   PARM                    CFT010            1            CFT009
     C                   PARM                    CSC011                                       CSC011
     C                   PARM                    CSD015                                       CSD015
     C                   PARM                    CCF001                                       CSD015
      *                                                                                       CAP211
     C                   PARM                    PAuth             1                          CAP211
     C                   PARM                    PUser            10                          CAP211
      *                                                                                       CAP211
     C/COPY WNCPYSRC,FTIPAYDC03
      *                                                                                       CFT157
     C                   CALLB     'AOSARDR0'                                                 CFT157
     C                   Parm      *BLANKS       @RTCD             7                          CFT157
     C                   Parm      '*VERIFY'     @OPTN             7                          CFT157
     C                   Parm      'CFT157'      @SARD                                        CFT157
     C     SCSARD        Parm      SCSARD        DSFDY                                        CFT157
                                                                                              CFT157
     C                   If        @RTCD <> *Blanks and                                       CFT157
     C                             @RTCD <> '*NRF   '                                         CFT157
     C     *LOCK         In        LDA                                                        CFT157
     C                   Movel     'SCSARDPD'    DBFILE                                       CFT157
     C                   Movel     '002'         DBASE                                        CFT157
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
                                                                                              CFT157
      *****************************************************************               241810 241810A
      ***Retrieve*ZMUSER*details.**************************************               241810 241810A
      *****************************************************************               241810 241810A
     C******DTAARA       DEFINE                  ZMUSER                               241810 241810A
     C**********         IN        ZMUSER                                             241810 241810A
      *
     C     KACCNT        KLIST
     C                   KFLD                    WACNUM
     C                   KFLD                    WACCCY
     C                   KFLD                    WACCD
     C                   KFLD                    WACSQ
     C                   KFLD                    WBRCA
     C/COPY WNCPYSRC,FTH00413
                                                                                              CSC011
      ** Get support system prefix and current system prefix                                  CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C**********         IN        SDSTAT                                              CSC011 CSD015
     C                   ENDIF                                                                CSC011
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'                                               223687
     C                   IN        SDSTAT                                                     CSD015
                                                                                              CSD015
      ** Check if function code is being monitored by the compliance watch                    CSD015
                                                                                              CSD015
     C                   CALLB     'AOWLCCR0'                                                 CSD015
     C                   PARM      *Blank        PRtCd                                        CSD015
     C                   PARM      '*KEY   '     POptn                                        CSD015
     C                   PARM      'FTIPAY'      PFunc                                        CSD015
     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
                                                                                              CSD015
      ** If return code not blank, then issue database errror                                 CSD015
                                                                                              CSD015
     C                   IF        (PRtCd <> *Blank) AND                                      CSD015
     C                             (PRtCd <> '*NRF   ')                                       CSD015
     C                   EVAL      DBKey = 'FTIPAY'                                           CSD015
     C                   EVAL      DBFile = 'SDWLCCPD'                                        CSD015
     C                   EVAL      DBase = 017                                                CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **  Access Compliance Watch Configuration Data if necessary.                            CSD015
                                                                                              CSD015
     C                   CALL      'AOCWCDR0'                                                 CSD015
     C                   PARM      *BLANKS       PrtCd                                        CSD015
     C                   PARM      '*FIRST'      POptn                                        CSD015
     C     SDCWCD        PARM      SDCWCD        DSSDY                                        CSD015
                                                                                              CSD015
     C                   IF        Prtcd <> *Blanks                                           CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = POptn                                              CSD015
     C                   EVAL      DBFile = 'SDCWCDPD'                                        CSD015
     C                   EVAL      DBase = 11                                                 CSD015
     C                   OUT       LDA                                                      MD029681
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                223687
                                                                                              CRE020
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
     C                   EVAL      DBase = 30                                                 CRE020
     C                   OUT       LDA                                                      MD029681
     C                   EXSR      *PSSR                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   IF        PRTCD = *BLANKS                                            CRE020
     C                   EVAL      CRE020 = 'Y'                                               CRE020
     C                   ENDIF                                                                CRE020
     C/COPY WNCPYSRC,FTH00392
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
                                                                                              CAP205
      ** Determine if SAR CAP205 is installed                                                 CAP205
                                                                                              CAP205
     C                   MOVEL     'N'           CAP205                                       CAP205
     C                   CALL      'AOSARDR0'                                                 CAP205
     C                   PARM      *BLANKS       PRTCD                                        CAP205
     C                   PARM      '*VERIFY'     POPTN                                        CAP205
     C                   PARM      'CAP205'      PSARD                                        CAP205
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP205
                                                                                              CAP205
     C                   IF        PRTCD <> *Blanks  AND                                      CAP205
     C                             PRTCD <> '*NRF'                                            CAP205
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAP205
     C     *LOCK         IN        LDA                                                        CAP205
     C                   EVAL      DBKey = 'CAP205'                                           CAP205
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP205
     C                   EVAL      DBase = 32                                                 CAP205
     C                   OUT       LDA                                                      MD029681
     C                   EXSR      *PSSR                                                      CAP205
     C                   ENDIF                                                                CAP205
                                                                                              CAP205
     C                   IF        PRTCD = *BLANKS                                            CAP205
     C                   MOVEL     'Y'           CAP205                                       CAP205
     C                   ENDIF                                                                CAP205
      *                                                                                       CAP211
      ** Check if CAP211 is switched on                                                       CAP211
      *                                                                                       CAP211
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
     C                   EVAL      DBase = 33                                                 CAP211
     C                   OUT       LDA                                                      MD029681
     C                   EXSR      *PSSR                                                      CAP211
     C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
     C                   IF        PRTCD = *Blanks                                            CAP211
     C                   EVAL      CAP211 = 'Y'                                               CAP211
     C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
     C                   IF        CAP211 = 'Y'                                               CAP211
      *                                                                                       CAP211
      ** Access System value CAP211GenerateOP if CAP211 is ON                                 CAP211
      *                                                                                       CAP211
     C                   CALL      'AOSVALR0'                                                 CAP211
     C                   PARM      *BLANKS       PRetCode          7                          CAP211
     C                   PARM      SysValGOP     P@OP01           20                          CAP211
     C                   PARM      *BLANKS       P@VL01          200                          CAP211
     C                   PARM      *BLANKS       P@OP02           20                          CAP211
     C                   PARM      *BLANKS       P@VL02          200                          CAP211
     C                   PARM      *BLANKS       P@OP03           20                          CAP211
     C                   PARM      *BLANKS       P@VL03          200                          CAP211
     C                   PARM      *BLANKS       P@OP04           20                          CAP211
     C                   PARM      *BLANKS       P@VL04          200                          CAP211
     C                   PARM      *BLANKS       P@OP05           20                          CAP211
     C                   PARM      *BLANKS       P@VL05          200                          CAP211
     C                   PARM      *BLANKS       P@OP06           20                          CAP211
     C                   PARM      *BLANKS       P@VL06          200                          CAP211
     C                   PARM      *BLANKS       P@OP07           20                          CAP211
     C                   PARM      *BLANKS       P@VL07          200                          CAP211
     C                   PARM      *BLANKS       P@OP08           20                          CAP211
     C                   PARM      *BLANKS       P@VL08          200                          CAP211
     C                   PARM      *BLANKS       P@OP09           20                          CAP211
     C                   PARM      *BLANKS       P@VL09          200                          CAP211
     C                   PARM      *BLANKS       P@OP10           20                          CAP211
     C                   PARM      *BLANKS       P@VL10          200                          CAP211
      *                                                                                       CAP211
     C                   IF        PRetCode  <> *BLANKS                                       CAP211
     C     *LOCK         IN        LDA                                                        CAP211
     C                   EVAL      DBKey = SysValGOP                                          CAP211
     C                   EVAL      DBFile = 'SDSVALPD'                                        CAP211
     C                   EVAL      DBase = 34                                                 CAP211
     C                   OUT       LDA                                                      MD029681
     C                   EXSR      *PSSR                                                      CAP211
     C                   ELSE                                                                 CAP211
     C                   MOVEL     P@VL01        SVGOP             1                          CAP211
     C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
      ** Access Midas SD Funds transfer details                                               CAP211
      *                                                                                       CAP211
     C                   CALL      'AOFTFRR0'                                                 CAP211
     C                   PARM      *BLANKS       PRTCD                                        CAP211
     C                   PARM      '*FIRST '     POPTN                                        CAP211
     C     SDFTFR        PARM      SDFTFR        DSFDY                                        CAP211
      *                                                                                       CAP211
     C                   IF        PRTCD <> *BLANKS                                           CAP211
     C     *LOCK         IN        LDA                                                        CAP211
     C                   EVAL      DBKey = POPTN                                              CAP211
     C                   EVAL      DBFile = 'SDFTFRPD'                                        CAP211
     C                   EVAL      DBase = 35                                                 CAP211
     C                   OUT       LDA                                                      MD029681
     C                   EXSR      *PSSR                                                      CAP211
     C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
      ** Check if CEU006 is switched on                                                       CAP211
      *                                                                                       CAP211
     C                   MOVE      'N'           CEU006            1                          CAP211
     C                   CALL      'AOSARDR0'                                                 CAP211
     C                   PARM      *Blanks       PRTCD                                        CAP211
     C                   PARM      '*VERIFY'     POPTN                                        CAP211
     C                   PARM      'CEU006'      PSARD                                        CAP211
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP211
      *                                                                                       CAP211
     C                   IF        PRTCD <> *Blanks  AND                                      CAP211
     C                             PRTCD <> '*NRF'                                            CAP211
     C     *LOCK         IN        LDA                                                        CAP211
     C                   EVAL      DBKey = 'CEU006'                                           CAP211
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP211
     C                   EVAL      DBase = 36                                                 CAP211
     C                   OUT       LDA                                                      MD029681
     C                   EXSR      *PSSR                                                      CAP211
     C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
     C                   IF        PRTCD = *Blanks                                            CAP211
     C                   EVAL      CEU006 = 'Y'                                               CAP211
     C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
      ** Access Midas SD Bank details ICD file                                                CAP211
      *                                                                                       CAP211
     C                   CALL      'AOBANKR0'                                                 CAP211
     C                   PARM      *BLANKS       PRTCD                                        CAP211
     C                   PARM      '*FIRST '     POPTN                                        CAP211
     C     SDBANK        PARM      SDBANK        DSFDY                                        CAP211
      *                                                                                       CAP211
     C                   IF        PRTCD <> *BLANKS                                           CAP211
     C     *LOCK         IN        LDA                                                        CAP211
     C                   EVAL      DBKey = POPTN                                              CAP211
     C                   EVAL      DBFile = 'SDBANKPD'                                        CAP211
     C                   EVAL      DBase = 37                                                 CAP211
     C                   OUT       LDA                                                      MD029681
     C                   EXSR      *PSSR                                                      CAP211
     C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
     C     *DTAARA       DEFINE    OTPAYDA       OTPAYD                                       CAP211
      *                                                                                       CAP211
     C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
      ** Check the switchable feature CFT120 with the corresponding                           CFT120
      ** parameters.                                                                          CFT120
      *                                                                                       CFT120
     C                   CALLB     'AOSARDR0'                                                 CFT120
     C                   PARM      *BLANKS       PRtCd                                        CFT120
     C                   PARM      '*VERIFY'     POptn                                        CFT120
     C                   PARM      'CFT120'      PSard                                        CFT120
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
      *                                                                                       CFT120
     C                   IF        PRtcd = *BLANKS                                            CFT120
     C                   EVAL      CFT120 = 'Y'                                               CFT120
     C                   ELSE                                                                 CFT120
      *                                                                                       CFT120
     C                   IF        PRtcd <> '*NRF'                                            CFT120
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT120
     C                   EVAL      DBASE = 38                                                 CFT120
     C                   EVAL      DBKEY = '*VERIFY'                                          CFT120
     C                   ELSE                                                                 CFT120
     C                   EVAL      CFT120 = 'N'                                               CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
      ** Check the switchable feature CFT151 is on                                            CFT151
      *                                                                                       CFT151
     C                   CALLB     'AOSARDR0'                                                 CFT151
     C                   PARM      *BLANKS       PRtCd                                        CFT151
     C                   PARM      '*VERIFY'     POptn                                        CFT151
     C                   PARM      'CFT151'      PSard                                        CFT151
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT151
      *                                                                                       CFT151
     C                   IF        PRtcd = *BLANKS                                            CFT151
     C                   EVAL      CFT151 = 'Y'                                               CFT151
     C                   ELSE                                                                 CFT151
      *                                                                                       CFT151
     C                   IF        PRtcd <> '*NRF'                                            CFT151
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT151
     C                   EVAL      DBASE = 38                                                 CFT151
     C                   EVAL      DBKEY = '*VERIFY'                                          CFT151
     C                   ELSE                                                                 CFT151
     C                   EVAL      CFT151 = 'N'                                               CFT151
     C                   ENDIF                                                                CFT151
      *                                                                                       CFT151
     C                   ENDIF                                                                CFT151
      *                                                                                       CFT151
     C/COPY WNCPYSRC,FTH00108
                                                                                              223687
      ** Compliance Watch Hit List Key List                                                   CSD015
                                                                                              CSD015
     C     KWHTKY        KLIST                                                                CSD015
     C                   KFLD                    WFUNT                                        CSD015
     C                   KFLD                    KIDEN                                        CSD015
     C                   KFLD                    BRCA                                         CSD015
                                                                                              CSD015

      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRERR - Routine for Exception Errors                         *
      *                                                               *
      *****************************************************************
      *
     C     SRERR         BEGSR
      *
     C                   EVAL      RetCodeIn = '*ERROR '
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   DUMP
      *
      ** Terminate program.
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************                       CAP211
      /EJECT                                                                                  CAP211
      *****************************************************************                       CAP211
      *                                                               *                       CAP211
      *  WOTPAY - Generate Outgoing Payment from Incoming Payment     *                       CAP211
      *                                                               *                       CAP211
      *****************************************************************                       CAP211
      *                                                                                       CAP211
     C     WOTPAY        BEGSR                                                                CAP211
      *                                                                                       CAP211
     C                   MOVE      BRCA          IBRCA             3                          CAP211
      *                                                                                       CAP211
s1   C     ACBT          IFNE      *Blank                                                     CAP211
      *                                                                                       CAP211
s2   C     ACBT          IFEQ      'N'                                                        CAP211
     C                   EVAL      WAXSBY = 'NOSTRO'                                          CAP211
     C                   EVAL      WNOCCY = PCCY                                              CAP211
     C                   EVAL      WNOCOD = ACBK                                              CAP211
e2   C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
s2   C     ACBT          IFEQ      'R'                                                        CAP211
     C                   EVAL      WAXSBY = 'RETAIL'                                          CAP211
     C                   MOVEL     ACBK          WRACNO                                       CAP211
e2   C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
s2   C     ACBT          IFEQ      'P'                                                        CAP211
     C     ACBT          OREQ      'C'                                                        CAP211
     C                   MOVE      *Blanks       WKEYL9                                       CAP211
     C                   MOVE      *Blanks       WKEYL15                                      CAP211
     C                   MOVE      *Blanks       WKEYL18                                      CAP211
     C                   MOVEL     ACBK          WKEYL9                                       CAP211
     C                   MOVE      PCCY          WKEYL9                                       CAP211
     C                   MOVE      ACBK          WKEYL15                                      CAP211
     C                   MOVEL     WKEYL9        WKEYL15                                      CAP211
     C                   MOVE      ACBB          WKEYL18                                      CAP211
     C                   MOVEL     WKEYL15       WKEYL18                                      CAP211
      *                                                                                       CAP211
     C                   EVAL      WAXSBY = 'ACCNTS'                                          CAP211
     C                   EVAL      WACCNT = WKEYL18                                           CAP211
e2   C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
     C                   EXSR      SRAcnt                                                     CAP211
     C                   MOVE      ACCNUM        @ACCNUM           6                          CAP211
      *                                                                                       CAP211
e1   C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
s1   C     ACBT          IFNE      'S'                                                        CAP211
      *                                                                                       CAP211
     C                   CALL      'AOCUSTR0'                                                 CAP211
     C                   PARM      *BLANKS       PRTCD             7                          CAP211
     C                   PARM      '*KEY   '     POPTN             7                          CAP211
     C                   PARM      @ACCNUM       PKEY1            10                          CAP211
     C                   PARM      *BLANK        PKYST             7                          CAP211
     C     SDCUST        PARM      SDCUST        DSSDY                                        CAP211
      *                                                                                       CAP211
s2   C     PRTCD         IFNE      *BLANKS                                                    CAP211
     C     PKYST         ORNE      '*CNUM'                                                    CAP211
     C                   Z-ADD     900           DBASE                                        CAP211
     C                   MOVEL     @ACCNUM       DBKEY                                        CAP211
     C                   MOVEL     'SDCUSTPD'    DBFILE                                       CAP211
     C                   EXSR      *PSSR                                                      CAP211
e2   C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
e1   C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
     C                   MOVE      IPPref        OXPREF                                       CAP211
     C                   MOVE      'D'           RECI                                         CAP211
     C                   EVAL      ZDAYNO = BJRDNB                                            CAP211
      *                                                                                       CAP211
     C                   CALLB     'ZDATE2'                                                   CAP211
     C                   PARM                    ZDAYNO            5 0                        CAP211
     C                   PARM      'M'           ZDATFM            1                          CAP211
     C                   PARM      *ZEROS        ZDATE             6 0                        CAP211
     C                   PARM      *Blanks       ZADATE            7                          CAP211
     C                   MOVE      ZDATE         RUNDYY                                       CAP211
     C                   MOVEL     ZDATE         RUNDMD                                       CAP211
     C                   MOVE      'OP'          PmntType                                     CAP211
     C                   MOVE      'OP'          PYTP                                         CAP211
     C                   Z-ADD     0             StmtType                                     CAP211
     C                   Z-ADD     0             STMT                                         CAP211
      *                                                                                       CAP211
     C                   IF        CFT151 = 'N'                                               CFT151
     C     *LOCK         IN        OTPAYD                                                     CAP211
     C**********         Z-ADD     OSQNM         PRNUM                                 CAP211 CFT151
     C**********         ADD       1             OSQNM                                 CAP211 CFT151
     C                   MOVEL     WOTSQ         PRNUM                                        CFT151
     C                   ADD       1             WOTSQ                                        CFT151
     C                   OUT       OTPAYD                                                     CAP211
     C                   ELSE                                                                 CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD                                        CFT151
     C                   PARM      'OT'          W@OTIN            2                          CFT151
     C                   PARM      'A'           WCALC             1                          CFT151
     C                   PARM      'Y'           WUPD              1                          CFT151
     C                   PARM                    PRNUM                                        CFT151
     C                   PARM                    WNEWSQ            4                          CFT151
     C                   ENDIF                                                                CFT151
     C                   MOVE      IPREF         PREF                                         CAP211
      *                                                                                       CAP211
     C                   MOVE      *Blanks       PYST                                         CAP211
     C                   MOVE      *Blanks       DST1                                         CAP211
     C                   MOVE      *Blanks       DST2                                         CAP211
     C                   MOVE      *Blanks       DST3                                         CAP211
     C                   MOVE      *Blanks       DST4                                         CAP211
     C                   MOVE      *Blanks       ACB1                                         CAP211
     C                   MOVE      *Blanks       ACB2                                         CAP211
     C                   MOVE      *Blanks       ACB3                                         CAP211
     C                   MOVE      *Blanks       ACB4                                         CAP211
     C                   MOVE      *Blanks       ACB5                                         CAP211
      *                                                                                       CAP211
s1   C     INBT          IFEQ      *Blanks                                                    CAP211
      *                                                                                       CAP211
s2   C     ACBT          IFEQ      'N'                                                        CAP211
     C                   EVAL      WNOCOD = ACBK                                              CAP211
     C                   MOVEL     PCCY          WKEYL5                                       CAP211
     C                   MOVE      WNOCOD        WKEYL5                                       CAP211
     C                   MOVE      'F'           DSTT                                         CAP211
     C                   MOVEL     WKEYL5        DST1                                         CAP211
e2   C                   ENDIF                                                                CAP211
s2   C     ACBT          IFEQ      'R'                                                        CAP211
     C                   MOVEL     ACBK          WRACNO                                       CAP211
     C                   MOVE      ACBT          DSTT                                         CAP211
     C                   MOVEL     WRACNO        DST1                                         CAP211
e2   C                   ENDIF                                                                CAP211
s2   C     INACBT        IFNE      *Blanks                                                    CAP211
s3   C     INACBT        IFNE      'S'                                                        CAP211
     C                   MOVEL     'S'           DSTT                                         CAP211
x3   C                   ELSE                                                                 CAP211
     C                   MOVEl     'A'           DSTT                                         CAP211
e3   C                   ENDIF                                                                CAP211
     C                   MOVEL     INACB1        DST1                                         CAP211
     C                   MOVEL     INACB2        DST2                                         CAP211
     C                   MOVEL     INACB3        DST3                                         CAP211
     C                   MOVEL     INACB4        DST4                                         CAP211
e2   C                   ENDIF                                                                CAP211
s2   C     ACBT          IFEQ      'P'                                                        CAP211
     C                   MOVE      *Blanks       WKEYL9                                       CAP211
     C                   MOVE      *Blanks       WKEYL15                                      CAP211
     C                   MOVE      *Blanks       WKEYL18                                      CAP211
     C                   MOVEL     ACBK          WKEYL9                                       CAP211
     C                   MOVE      PCCY          WKEYL9                                       CAP211
     C                   MOVE      ACBK          WKEYL15                                      CAP211
     C                   MOVEL     WKEYL9        WKEYL15                                      CAP211
     C                   MOVE      ACBB          WKEYL18                                      CAP211
     C                   MOVEL     WKEYL15       WKEYL18                                      CAP211
     C                   MOVEL     WKEYL18       DST1                                         CAP211
     C                   MOVEL     'G'           DSTT                                         CAP211
e2   C                   ENDIF                                                                CAP211
s2   C     ACBT          IFEQ      'C'                                                        CAP211
     C                   MOVE      *Blanks       WKEYL6            6                          CAP211
     C                   MOVEL     ACBK          WKEYL6                                       CAP211
     C                   MOVEL     WKEYL6        DST1                                         CAP211
     C                   MOVEL     ACBT          DSTT                                         CAP211
e2   C                   ENDIF                                                                CAP211
s2   C     ACBT          IFEQ      'S'                                                        CAP211
     C                   MOVE      *Blanks       WKEYL12                                      CAP211
     C                   MOVEL     ACBK          WKEYL12                                      CAP211
     C                   MOVEL     WKEYL12       DST1                                         CAP211
     C                   MOVEL     ACBT          DSTT                                         CAP211
e2   C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
     C                   MOVEL     *Blanks       ACBT                                         CAP211
x1   C                   ELSE                                                                 CAP211
s2   C     INBT          IFEQ      'S'                                                        CAP211
     C                   MOVEL     INB1          DST1                                         CAP211
     C                   MOVE      'S'           DSTT                                         CAP211
x2   C                   ELSE                                                                 CAP211
     C                   MOVE      INBT          DSTT                                         CAP211
     C                   MOVE      INB1          DST1                                         CAP211
     C                   MOVE      INB2          DST2                                         CAP211
     C                   MOVE      INB3          DST3                                         CAP211
     C                   MOVE      INB4          DST4                                         CAP211
e2   C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
s2   C     ACBT          IFEQ      'N'                                                        CAP211
     C     ACBT          OREQ      'R'                                                        CAP211
     C     ACBT          OREQ      'P'                                                        CAP211
     C     INACBT        ANDEQ     *Blanks                                                    CAP211
s3   C     BBCSID        IFNE      *Blanks                                                    CAP211
     C                   MOVEL     BBCSID        ACB1                                         CAP211
     C                   MOVE      'S'           ACBT                                         CAP211
x3   C                   ELSE                                                                 CAP211
     C                   MOVEL     BBCNA1        ACB1                                         CAP211
     C                   MOVEL     BBCNA2        ACB2                                         CAP211
     C                   MOVEL     BBCNA3        ACB3                                         CAP211
     C                   MOVEL     BBCNA4        ACB4                                         CAP211
     C                   MOVE      'A'           ACBT                                         CAP211
e3   C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
x2   C                   ELSE                                                                 CAP211
s3   C     INACBT        IFNE      *Blanks                                                    CAP211
s4   C     INACBT        IFEQ      'S'                                                        CAP211
     C                   MOVE      'S'           ACBT                                         CAP211
x4   C                   ELSE                                                                 CAP211
     C                   MOVE      'A'           ACBT                                         CAP211
e4   C                   ENDIF                                                                CAP211
     C                   MOVEL     INACB1        ACB1                                         CAP211
     C                   MOVEL     INACB2        ACB2                                         CAP211
     C                   MOVEL     INACB3        ACB3                                         CAP211
     C                   MOVEL     INACB4        ACB4                                         CAP211
     C                   MOVEL     INACB5        ACB5                                         CAP211
e3   C                   ENDIF                                                                CAP211
e2   C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
e1   C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
     C                   MOVE      *Blank        SNCT                                         CAP211
     C                   MOVE      *Blanks       SNCO                                         CAP211
     C                   Z-ADD     1             RATE                                         CAP211
     C                   z-ADD     1             RATED                                        CAP211
     C                   MOVE      'N'           OVRD                                         CAP211
     C                   Z-ADD     PYAM          SMAM                                         CAP211
s1   C     CDRO          IFEQ      *blanks                                                    CAP211
     C     ADDC          ANDEQ     'D'                                                        CAP211
     C                   SUB       TRCM          SMAM                                         CAP211
     C                   SUB       TXCH          SMAM                                         CAP211
     C                   SUB       CQCH          SMAM                                         CAP211
     C                   SUB       ADCH          SMAM                                         CAP211
     C                   SUB       TLCH          SMAM                                         CAP211
     C                   SUB       MSCH          SMAM                                         CAP211
s2   C     CFT009        IFEQ      'Y'                                                        CAP211
     C                   SUB       MSC01         SMAM                                         CAP211
     C                   SUB       MSC02         SMAM                                         CAP211
     C                   SUB       MSC03         SMAM                                         CAP211
     C                   SUB       MSC04         SMAM                                         CAP211
     C                   SUB       MSC05         SMAM                                         CAP211
e2   C                   ENDIF                                                                CAP211
e1   C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
     C                   Z-ADD     TRCM          WCHGS            13 0                        CAP211
s1   C     S01494        IFEQ      'Y'                                                        CAP211
     C                   ADD       INCHCM        WCHGS                                        CAP211
e1   C                   ENDIF                                                                CAP211
     C                   ADD       TXCH          WCHGS                                        CAP211
     C                   ADD       CQCH          WCHGS                                        CAP211
     C                   ADD       ADCH          WCHGS                                        CAP211
     C                   ADD       TLCH          WCHGS                                        CAP211
     C                   ADD       MSCH          WCHGS                                        CAP211
s1   C     CFT009        IFEQ      'Y'                                                        CAP211
     C                   ADD       MSC01         WCHGS                                        CAP211
     C                   ADD       MSC02         WCHGS                                        CAP211
     C                   ADD       MSC03         WCHGS                                        CAP211
     C                   ADD       MSC04         WCHGS                                        CAP211
     C                   ADD       MSC05         WCHGS                                        CAP211
e1   C                   ENDIF                                                                CAP211
s1   C     S01499        IFEQ      'Y'                                                        CAP211
     C                   ADD       INVATT        WCHGS                                        CAP211
e1   C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
s1   C                   SELECT                                                               CAP211
     C     CDRO          WHENNE    *blanks                                                    CAP211
     C                   MOVEL     BJCYCD        WCCCY             3                          CAP211
     C     ADDC          WHENEQ    'A'                                                        CAP211
     C                   MOVEL     SMCY          WCCCY                                        CAP211
s2   C     SND1          IFEQ      'CASHIER'                                                  CAP211
     C     PCCY          ANDEQ     BJCYCD                                                     CAP211
     C                   MOVEL     PCCY          WCCCY                                        CAP211
e2   C                   ENDIF                                                                CAP211
     C                   OTHER                                                                CAP211
     C                   MOVEL     PCCY          WCCCY                                        CAP211
e1   C                   ENDSL                                                                CAP211
      *                                                                                       CAP211
     C                   MOVE      SMCY          WSMCYX            3                          CAP211
     C                   MOVE      PCCY          SMCY                                         CAP211
     C                   Z-ADD     PVDT          SLDT                                         CAP211
     C                   Z-ADD     PVDTD1        SLDTD1                                       CAP211
     C                   Z-ADD     PVDTD2        SLDTD2                                       CAP211
     C                   Z-ADD     PVDTD3        SLDTD3                                       CAP211
      *                                                                                       CAP211
     C                   CALL      'AOCURRR0'                                                 CAP211
     C                   PARM      *BLANKS       PRTCD                                        CAP211
     C                   PARM      '*KEY   '     POPTN                                        CAP211
     C************       PARM      PCCY          PCCY                               CAP211  MD054037
     C                   PARM      SMCY          P#CCY             3                        MD054037
     C     SDCURR        PARM      SDCURR        DSSDY                                        CAP211
      *                                                                                       CAP211
s1   C     PRTCD         IFNE      *BLANKS                                                    CAP211
     C                   MOVEL     SMCY          DBKEY                                        CAP211
     C                   MOVEL     'SDCURRPD'    DBFILE                                       CAP211
     C                   Z-ADD     901           DBASE                                        CAP211
     C                   EXSR      *PSSR                                                      CAP211
e1   C                   ENDIF                                                                CAP211
     C                   Z-ADD     A6NBDP        RCDP              1 0                        CAP211
     C                   Z-ADD     A6SPRT        RSPOT            13 8                        CAP211
s1   C     A6MDIN        IFEQ      'M'                                                        CAP211
     C                   Z-ADD     1             RMDIN             1 0                        CAP211
x1   C                   ELSE                                                                 CAP211
     C                   Z-ADD     0             RMDIN                                        CAP211
e1   C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
     C     RCDP          ADD       4             N                 1 0                        CAP211
     C                   SELECT                                                               CAP211
     C                   WHEN      RCDP = 0                                                   CAP211
     C                   Z-ADD     SMAM          SMAMD                                        CAP211
     C                   WHEN      RCDP = 1                                                   CAP211
     C                   EVAL      SMAMD = SMAM / 10                                          CAP211
     C                   WHEN      RCDP = 2                                                   CAP211
     C                   EVAL      SMAMD = SMAM / 100                                         CAP211
     C                   OTHER                                                                CAP211
     C                   EVAL      SMAMD = SMAM / 1000                                        CAP211
     C                   ENDSL                                                                CAP211
      *                                                                                       CAP211
     C                   CALL      'AOCURRR0'                                                 CAP211
     C                   PARM      *BLANKS       PRTCD                                        CAP211
     C                   PARM      '*KEY   '     POPTN                                        CAP211
     C************       PARM      BJCYCD        PCCY                                CAP211 MD054037
     C                   PARM      BJCYCD        P#CCY                                      MD054037
     C     SDCURR        PARM      SDCURR        DSSDY                                        CAP211
      *                                                                                       CAP211
s1   C     PRTCD         IFNE      *BLANKS                                                    CAP211
     C                   MOVEL     BJCYCD        DBKEY                                        CAP211
     C                   MOVEL     'SDCURRPD'    DBFILE                                       CAP211
     C                   Z-ADD     902           DBASE                                        CAP211
     C                   EXSR      *PSSR                                                      CAP211
e1   C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
     C                   z-add     A6NBDP        BCDP              1 0                        CAP211
     C     RCDP          SUB       BCDP          N                                            CAP211
     C                   ADD       4             N                                            CAP211
      *                                                                                       CAP211
s1   C     RMDIN         IfEQ      0                                                          CAP211
     C     RSPOT         MULT(H)   POWERS(N)     WK159            15 9                        CAP211
     C     SMAM          DIV(H)    WK159         SBCQ                                         CAP211
x1   C                   ELSE                                                                 CAP211
     C     RSPOT         DIV(H)    POWERS(N)     WK159                                        CAP211
e1   C     SMAM          MULT(H)   WK159         SBCQ                                         CAP211
     C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
     C                   Z-ADD     0             PYAM                                         CAP211
     C                   Z-ADD     0             PYAMD                                        CAP211
     C                   Z-ADD     0             PBCQ                                         CAP211
     C                   MOVE      'D'           ADDC                                         CAP211
     C                   MOVE      'N'           RPAY                                         CAP211
     C                   MOVE      *Blank        PAYF                                         CAP211
     C                   Z-ADD     0             DYIM                                         CAP211
     C                   Z-ADD     0             FDAT                                         CAP211
     C                   Z-ADD     0             FDATD1                                       CAP211
     C                   Z-ADD     0             FDATD2                                       CAP211
     C                   Z-ADD     0             FDATD3                                       CAP211
      *                                                                                       CAP211
s1   C     ACB1          IFEQ      *Blanks                                                    CAP211
     C                   MOVE      *Blanks       ACBT                                         CAP211
e1   C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
     C                   MOVE      *Blanks       SNMT                                         CAP211
     C                   Z-ADD     0             STMT                                         CAP211
     C                   MOVE      *Blanks       RCRT                                         CAP211
     C                   MOVE      *Blanks       RCO1                                         CAP211
     C                   MOVE      *Blanks       RCO2                                         CAP211
     C                   MOVE      *Blanks       RCO3                                         CAP211
     C                   MOVE      *Blanks       RCO4                                         CAP211
     C                   MOVE      *Blanks       RCO5                                         CAP211
     C                   MOVE      *Blanks       BBI1                                         CAP211
     C                   MOVE      *Blanks       ORBB                                         CAP211
      *                                                                                       CAP211
      ** Ordering bank                                                                        CAP211
      *                                                                                       CAP211
     C                   MOVE      *Blanks       OPORBT                                       CAP211
     C                   MOVE      *Blanks       OPORB1                                       CAP211
     C                   MOVE      *Blanks       OPORB2                                       CAP211
     C                   MOVE      *Blanks       OPORB3                                       CAP211
     C                   MOVE      *Blanks       OPORB4                                       CAP211
     C                   MOVE      *Blanks       OPORB5                                       CAP211
      *                                                                                       CAP211
     C                   CALL      'AOBRCHR1'                                                 CAP211
     C                   PARM      *BLANKS       PRTCD                                        CAP211
     C                   PARM      '*KEY   '     POPTN                                        CAP211
     C                   PARM      BRCA          PBRCH             3                          CAP211
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CAP211
      *                                                                                       CAP211
s1   C     PRTCD         IFNE      *BLANKS                                                    CAP211
     C                   MOVEL     BRCA          DBKEY                                        CAP211
     C                   MOVEL     'SDBRCHPD'    DBFILE                                       CAP211
     C                   Z-ADD     903           DBASE                                        CAP211
     C                   EXSR      *PSSR                                                      CAP211
e1   C                   ENDIF                                                                CAP211
     C                   MOVE      A8BICN        OBCNUM                                       CAP211
     C                   MOVE      BTIOSA        OBACOD                                       CAP211
     C                   Z-ADD     1             OBACSQ                                       CAP211
      *                                                                                       CAP211
s1   C     ORBT          IFEQ      *Blank                                                     CAP211
     C                   MOVE      *Blanks       ORBK                                         CAP211
     C                   MOVE      *Blanks       ORBT                                         CAP211
s2   C     SNTP          IFEQ      'F'                                                        CAP211
     C                   MOVEL     SND1          WKEYL5                                       CAP211
     C                   MOVEL     WKEYL5        WNOCCY                                       CAP211
     C                   MOVE      WKEYL5        WNOCOD                                       CAP211
s3   C     WNOCCY        IFEQ      PCCY                                                       CAP211
     C                   MOVEL     WNOCOD        ORBK                                         CAP211
     C                   MOVE      'N'           ORBT                                         CAP211
     C                   MOVEL     @DFT(1)       OPORB1                                       CAP211
e3   C                   ENDIF                                                                CAP211
x2   C                   ELSE                                                                 CAP211
s3   C     SNTP          IFEQ      'G'                                                        CAP211
     C                   EVAL      WKEYL18 = SND1                                             CAP211
     C                   MOVEL     WKEYL18       WACCNT                                       CAP211
s4   C     WACCCY        IFEQ      PCCY                                                       CAP211
     C                   MOVE      OBFTAC        WKEYL12                                      CAP211
     C                   MOVE      WACNUM        OBCNUM                                       CAP211
     C                   Z-ADD     WACCD         OBACOD                                       CAP211
     C                   Z-ADD     WACSQ         OBACSQ                                       CAP211
     C                   MOVEL     FTDFAC        ORBK                                         CAP211
     C                   MOVE      WKEYL12       OBFTAC                                       CAP211
     C                   MOVEL     WBRCA         ORBB                                         CAP211
     C                   MOVEL     'P'           ORBT                                         CAP211
     C                   MOVEL     @DFT(1)       OPORB1                                       CAP211
e4   C                   ENDIF                                                                CAP211
x3   C                   ELSE                                                                 CAP211
s4   C     SNTP          IFEQ      'R'                                                        CAP211
     C                   MOVEL     SND1          WRACNO           10                          CAP211
     C                   MOVEL     WRACNO        WKACNO           10 0                        CAP211
     C     WKACNO        CHAIN     ACNUMA                             99                      CAP211
s5   C     ACCCY         IFEQ      PCCY                                                       CAP211
     C     *IN99         ANDEQ     *Off                                                       CAP211
     C                   MOVE      'R'           ORBT                                         CAP211
     C                   MOVEL     SND1          ORBK                                         CAP211
     C                   MOVEL     @DFT(1)       OPORB1                                       CAP211
e5   C                   ENDIF                                                                CAP211
e4   C                   ENDIF                                                                CAP211
e3   C                   ENDIF                                                                CAP211
e2   C                   ENDIF                                                                CAP211
x1   C                   ELSE                                                                 CAP211
     C                   MOVEL     ORBT          OPORBT                                       CAP211
     C                   MOVEL     ORB1          OPORB1                                       CAP211
     C                   MOVEL     ORB2          OPORB2                                       CAP211
     C                   MOVEL     ORB3          OPORB3                                       CAP211
     C                   MOVEL     ORB4          OPORB4                                       CAP211
     C                   MOVEL     ORB5          OPORB5                                       CAP211
      *                                                                                       CAP211
     C                   MOVE      *Blanks       ORBK                                         CAP211
     C                   MOVE      OBFTAC        ORBK                                         CAP211
     C                   MOVE      'P'           ORBT                                         CAP211
     C                   MOVEL     BRCA          ORBB                                         CAP211
e1   C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
      ** Map Swift message details                                                            CAP211
      *                                                                                       CAP211
s1   C     ORBT          IFEQ      *Blanks                                                    CAP211
     C                   MOVE      OBFTAC        ORBK                                         CAP211
     C                   MOVEL     'P'           ORBT                                         CAP211
     C                   MOVEL     BRCA          ORBB                                         CAP211
s2   C     SNTP          IFEQ      'G'                                                        CAP211
     C     SNTP          OREQ      'F'                                                        CAP211
     C     SNTP          OREQ      'R'                                                        CAP211
     C     SNTP          OREQ      'C'                                                        CAP211
s3   C     SNTP          IFEQ      'G'                                                        CAP211
     C     SNTP          OREQ      'C'                                                        CAP211
     C                   MOVEL     SND1          @ACCNUM                                      CAP211
e3   C                   ENDIF                                                                CAP211
s3   C     SNTP          IFEQ      'R'                                                        CAP211
     C                   EVAL      WAXSBY = 'RETAIL'                                          CAP211
     C                   MOVEL     SND1          WRACNO           10                          CAP211
     C                   EXSR      SrAcnt                                                     CAP211
     C                   MOVE      ACCNUM        @ACCNUM           6                          CAP211
e3   C                   ENDIF                                                                CAP211
s3   C     SNTP          IFEQ      'F'                                                        CAP211
     C                   EVAL      WAXSBY = 'NOSTRO'                                          CAP211
     C                   MOVEL     SND1          WKEYL5            5                          CAP211
     C                   MOVEL     WKEYL5        WNOCCY            3                          CAP211
     C                   MOVE      WKEYL5        WNOCOD            2                          CAP211
     C                   EXSR      SrAcnt                                                     CAP211
     C                   MOVE      ACCNUM        @ACCNUM           6                          CAP211
e3   C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
     C                   CALL      'AOCUSTR0'                                                 CAP211
     C                   PARM      *BLANKS       PRTCD             7                          CAP211
     C                   PARM      '*KEY   '     POPTN             7                          CAP211
     C                   PARM      @ACCNUM       PKEY1            10                          CAP211
     C                   PARM      *BLANK        PKYST             7                          CAP211
     C     SDCUST        PARM      SDCUST        DSSDY                                        CAP211
      *                                                                                       CAP211
s3   C     PRTCD         IFNE      *BLANKS                                                    CAP211
     C     PKYST         ORNE      '*CNUM'                                                    CAP211
     C                   Z-ADD     905           DBASE                                        CAP211
     C                   MOVEL     @ACCNUM       DBKEY                                        CAP211
     C                   MOVEL     'SDCUSTPD'    DBFILE                                       CAP211
     C                   EXSR      *PSSR                                                      CAP211
e3   C                   ENDIF                                                                CAP211
s3   C     BBCSID        IFEQ      *Blanks                                                    CAP211
     C                   MOVE      'A'           OPORBT                                       CAP211
     C                   MOVEL     BBCNA1        OPORB1                                       CAP211
     C                   MOVEL     BBCNA2        OPORB2                                       CAP211
     C                   MOVEL     BBCNA3        OPORB3                                       CAP211
     C                   MOVEL     BBCNA4        OPORB4                                       CAP211
     C                   MOVEL     *Blanks       OPORB5                                       CAP211
x3   C                   ELSE                                                                 CAP211
     C                   MOVE      'S'           OPORBT                                       CAP211
     C                   MOVEL     BBCSID        OPORB1                                       CAP211
e3   C                   ENDIF                                                                CAP211
x2   C                   ELSE                                                                 CAP211
s3   C     SNTP          IFEQ      'A'                                                        CAP211
     C     SNTP          OREQ      'S'                                                        CAP211
     C                   MOVEL     SNTP          OPORBT                                       CAP211
     C                   MOVEL     SND1          OPORB1                                       CAP211
     C                   MOVEL     SND2          OPORB2                                       CAP211
     C                   MOVEL     SND3          OPORB3                                       CAP211
     C                   MOVEL     SND4          OPORB4                                       CAP211
     C                   MOVEL     *Blanks       OPORB5                                       CAP211
e3   C                   ENDIF                                                                CAP211
e2   C                   ENDIF                                                                CAP211
e1   C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
      ** Bank to bank information fields                                                      CAP211
      *                                                                                       CAP211
     C                   MOVEL     *Blanks       BBI1                                         CAP211
     C                   MOVEL     *Blanks       BBI2                                         CAP211
     C                   MOVEL     *Blanks       BBI3                                         CAP211
     C                   MOVEL     *Blanks       BBI4                                         CAP211
     C                   MOVEL     *Blanks       BBI5                                         CAP211
     C                   MOVEL     *Blanks       BBI6                                         CAP211
s1   C     INMTPY        IFEQ      '200'                                                      CAP211
     C     INMTPY        OREQ      '201'                                                      CAP211
     C     INMTPY        OREQ      '202'                                                      CAP211
     C     INMTPY        OREQ      '203'                                                      CAP211
     C     INMTPY        OREQ      '205'                                                      CAP211
s2   C     ORCT          IFEQ      *Blank                                                     CAP211
     C                   MOVE      *Blanks       ORC1                                         CAP211
     C                   MOVE      *Blanks       ORC2                                         CAP211
     C                   MOVE      *Blanks       ORC3                                         CAP211
     C                   MOVE      *Blanks       ORC4                                         CAP211
     C                   MOVEL     'MT202'       ORC1                                         CAP211
     C                   MOVE      'A'           ORCT                                         CAP211
e2   C                   ENDIF                                                                CAP211
e1   C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
      ** Beneficiary                                                                          CAP211
      *                                                                                       CAP211
s1   C     BNCT          IFEQ      'R'                                                        CAP211
     C                   EVAL      WAXSBY = 'RETAIL'                                          CAP211
     C                   MOVEL     BNC1          WRACNO           10                          CAP211
     C                   EXSR      SrAcnt                                                     CAP211
     C                   MOVE      ACCNUM        @ACCNUM           6                          CAP211
e1   C                   ENDIF                                                                CAP211
s1   C     BNCT          IFEQ      'P'                                                        CAP211
     C                   MOVEL     BNC1          @ACCNUM                                      CAP211
     C                   EXSR      SrAcnt                                                     CAP211
     C                   MOVE      ACCNUM        @ACCNUM           6                          CAP211
e1   C                   ENDIF                                                                CAP211
s1   C     BNCT          IFEQ      'R'                                                        CAP211
     C     BNCT          OREQ      'P'                                                        CAP211
     C                   MOVEL     *Blanks       BNC1                                         CAP211
     C                   MOVEL     @ACCNUM       BNC1                                         CAP211
     C                   MOVE      'C'           BNCT                                         CAP211
e1   C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
     C                   Z-ADD     0             DNBC                                         CAP211
     C                   MOVE      *Blanks       TRCT                                         CAP211
     C                   Z-ADD     0             TRCM                                         CAP211
     C                   Z-ADD     0             TRCMD                                        CAP211
     C                   Z-ADD     0             TXCH                                         CAP211
     C                   Z-ADD     0             TXCHD                                        CAP211
     C                   Z-ADD     0             CQCH                                         CAP211
     C                   Z-ADD     0             CQCHD                                        CAP211
     C                   Z-ADD     0             CSTA                                         CAP211
     C                   Z-ADD     0             CSTAD                                        CAP211
     C                   Z-ADD     0             SPCH                                         CAP211
     C                   Z-ADD     0             SPCHD                                        CAP211
     C                   Z-ADD     0             MSCH                                         CAP211
     C                   Z-ADD     0             MSCHD                                        CAP211
     C                   MOVE      *Blank        CDRT                                         CAP211
     C                   MOVE      *blanks       CDRO                                         CAP211
     C                   MOVE      *Blank        CDBR                                         CAP211
     C                   TIME                    LCHT                                         CAP211
     C                   Z-ADD     BJRDNB        LCD                                          CAP211
     C                   MOVE      'I'           CHTP                                         CAP211
     C                   MOVE      *Blanks       AUP1                                         CAP211
     C                   MOVE      *Blanks       AUP2                                         CAP211
     C                   MOVE      *Blanks       AUIN                                         CAP211
     C                   MOVE      *Blanks       IACG                                         CAP211
     C                   MOVE      *Blanks       SACG                                         CAP211
     C                   MOVE      *Blanks       PACG                                         CAP211
     C                   MOVE      *Blanks       SMSG                                         CAP211
     C                   MOVE      *Blanks       PMSG                                         CAP211
     C                   Z-ADD     bjrdnb        OEDT                                         CAP211
     C                   MOVE      BJRDNB        ZDAYNO                                       CAP211
     C                   CALLB     'ZDATE2'                                                   CAP211
     C                   PARM                    ZDAYNO                                       CAP211
     C                   PARM                    BJDFIN                                       CAP211
     C                   PARM      *ZEROS        ZDATE                                        CAP211
     C                   PARM      *Blanks       ZADATE            7                          CAP211
     C                   MOVE      ZADATE        OEDTD1                                       CAP211
     C                   Z-ADD     0             NPDT                                         CAP211
     C                   Z-ADD     0             NPDTD1                                       CAP211
     C                   Z-ADD     0             NPDTD2                                       CAP211
     C                   Z-ADD     0             NPDTD3                                       CAP211
     C                   Z-ADD     0             PRBD                                         CAP211
     C                   Z-ADD     0             DUMA1                                        CAP211
     C                   Z-ADD     0             DUMA2                                        CAP211
     C                   Z-ADD     0             DUMA3                                        CAP211
     C                   Z-ADD     0             DUMA4                                        CAP211
     C                   Z-ADD     0             DUMA5                                        CAP211
     C                   Z-ADD     0             DUMA6                                        CAP211
     C                   MOVE      *Blanks       FAIN                                         CAP211
     C                   MOVE      *Blanks       ADIN                                         CAP211
     C                   MOVE      *Blanks       CQIN                                         CAP211
     C                   MOVE      *Blanks       PRIN                                         CAP211
     C                   MOVE      *Blanks       MT100                                        CAP211
     C                   MOVE      *Blanks       MT202                                        CAP211
     C                   MOVE      *Blanks       TXIN                                         CAP211
     C                   MOVE      *Blanks       BAIN                                         CAP211
     C                   MOVE      *Blanks       ISIN                                         CAP211
     C                   MOVE      *Blanks       MPYI                                         CAP211
     C                   MOVE      *Blanks       INBT                                         CAP211
     C                   MOVE      *Blanks       INB1                                         CAP211
     C                   MOVE      *Blanks       INB2                                         CAP211
     C                   MOVE      *Blanks       INB3                                         CAP211
     C                   MOVE      *Blanks       INB4                                         CAP211
     C                   MOVE      *Blanks       INB5                                         CAP211
     C                   MOVE      *Blanks       CHAP                                         CAP211
     C                   MOVE      'N'           LVL1                                         CAP211
     C                   MOVE      'N'           LVL2                                         CAP211
     C                   MOVE      IBRCA         BRCA                                         CAP211
      *                                                                                       CAP211
s1   C     CFT014        IFEQ      'Y'                                                        CAP211
     C                   MOVE      NDCY          WNDCY             3                          CAP211
     C                   Z-ADD     NDAM          WNDAM            13 0                        CAP211
e1   C                   ENDIF                                                                CAP211
s1   C     CEU006        IFEQ      'Y'                                                        CAP211
     C                   MOVE      *Blanks       NDCY                                         CAP211
     C                   Z-ADD     0             NDAM                                         CAP211
e1   C                   ENDIF                                                                CAP211
s1   C     CEU006        IFEQ      'Y'                                                        CAP211
     C     CFT014        OREQ      'Y'                                                        CAP211
     C                   MOVE      *Blanks       PDCY                                         CAP211
     C                   Z-ADD     0             PDAM                                         CAP211
e1   C                   Endif                                                                CAP211
s1   C     CFT014        Ifeq      'Y'                                                        CAP211
     C                   MOVE      RECI          OPRECI                                       CAP211
     C                   MOVE      PREF          OPPREF                                       CAP211
     C                   MOVE      *Blanks       OPBJPR                                       CAP211
     C                   MOVE      'N'           OPAUTO                                       CAP211
     C                   MOVE      *Blank        OPSTPI                                       CAP211
     C                   MOVE      *Blank        OPBANO                                       CAP211
     C                   MOVE      *Blank        OPRUSR                                       CAP211
     C                   MOVE      *Blank        OPWSID                                       CAP211
     C                   MOVE      *Blank        OPRDAT                                       CAP211
     C                   MOVE      STMT          OPSETM                                       CAP211
     C                   Z-ADD     0             OPOEXR                                       CAP211
     C                   MOVE      *Blanks       OPTRIT                                       CAP211
     C                   MOVE      *Blanks       OPTRI1                                       CAP211
     C                   MOVE      *Blanks       OPTRI2                                       CAP211
     C                   MOVE      *Blanks       OPTRI3                                       CAP211
     C                   MOVE      *Blanks       OPTRI4                                       CAP211
     C                   MOVE      *Blanks       OPTRI5                                       CAP211
     C                   Z-ADD     0             OPRCNW                                       CAP211
     C                   MOVE      *Blanks       OPRCCN                                       CAP211
     C                   MOVE      *Blanks       OPRCUS                                       CAP211
     C                   Z-ADD     0             OPSCLE                                       CAP211
      *                                                                                       CAP211
s2   C     INMTPY        IFEQ      '103'                                                      CAP211
     C                   MOVE      WNDCY         PDCY                                         CAP211
     C                   Z-ADD     WNDAM         PDAM                                         CAP211
     C                   Z-ADD     INOEXR        OPOEXR                                       CAP211
e2   C                   ENDIF                                                                CAP211
     C                   MOVE      INBOCD        OPBOCD                                       CAP211
     C                   MOVE      INTTCD        OPTTCD                                       CAP211
     C                   MOVE      INICD1        OPICD1                                       CAP211
     C                   MOVE      INICD2        OPICD2                                       CAP211
     C                   MOVE      INICD3        OPICD3                                       CAP211
     C                   MOVE      INICD4        OPICD4                                       CAP211
     C                   MOVE      INICD5        OPICD5                                       CAP211
     C                   MOVE      INRRP1        OPRRP1                                       CAP211
     C                   MOVE      INRRP2        OPRRP2                                       CAP211
     C                   MOVE      INRRP3        OPRRP3                                       CAP211
s2   C     WCCCY         IFNE      WSMCYX                                                     CAP211
     C                   CLEAR                   P#0010                                       CAP211
     C                   MOVEL     WCCCY         P#FRCY                                       CAP211
     C                   Z-ADD     WCHGS         P#FRAM                                       CAP211
     C                   MOVEL     WSMCYX        P#TOCY                                       CAP211
     C                   Z-ADD     0             P#TOAM                                       CAP211
     C                   CALL      'FT0010'                                                   CAP211
     C                   PARM                    P#0010                                       CAP211
s3   C     P#RTCD        IFNE      *BLANKS                                                    CAP211
     C                   Z-ADD     906           DBASE                                        CAP211
     C                   MOVEL     'FT0010'      DBFILE                                       CAP211
     C                   MOVEL     '*CALL '      DBKEY                                        CAP211
     C                   EXSR      *PSSR                                                      CAP211
x3   C                   ELSE                                                                 CAP211
     C     INRCRM        SUB       P#TOAM        WRCRM            11 0                        CAP211
e3   C                   ENDIF                                                                CAP211
x2   C                   ELSE                                                                 CAP211
     C     INRCRM        SUB       WCHGS         WRCRM                                        CAP211
e2   C                   ENDIF                                                                CAP211
s2   C     WRCRM         IFLT      0                                                          CAP211
     C                   Z-ADD     0             WRCRM                                        CAP211
e2   C                   ENDIF                                                                CAP211
     C                   Z-ADD     0             OPRCRM                                       CAP211
     C                   Z-ADD     0             OPRBCQ                                       CAP211
     C                   Z-ADD     0             OPRCSC                                       CAP211
     C                   Z-ADD     0             OPRCSQ                                       CAP211
s2   C     WRCRM         IFGT      0                                                          CAP211
s3   C     WSMCYX        IFNE      PCCY                                                       CAP211
     C                   CLEAR                   P#0010                                       CAP211
     C                   MOVEL     WSMCYX        P#FRCY                                       CAP211
     C                   Z-ADD     WRCRM         P#FRAM                                       CAP211
     C                   MOVEL     PCCY          P#TOCY                                       CAP211
     C                   Z-ADD     0             P#TOAM                                       CAP211
     C                   CALL      'FT0010'                                                   CAP211
     C                   PARM                    P#0010                                       CAP211
s4   C     P#RTCD        IFNE      *BLANKS                                                    CAP211
     C                   Z-ADD     907           DBASE                                        CAP211
     C                   MOVEL     'FT0010'      DBFILE                                       CAP211
     C                   MOVEL     '*CALL '      DBKEY                                        CAP211
     C                   EXSR      *PSSR                                                      CAP211
x4   C                   ELSE                                                                 CAP211
     C                   Z-ADD     P#TOAM        OPRCRM                                       CAP211
e4   C                   ENDIF                                                                CAP211
x3   C                   ELSE                                                                 CAP211
     C                   Z-ADD     WRCRM         OPRCRM                                       CAP211
e3   C                   ENDIF                                                                CAP211
     C                   CLEAR                   P#0010                                       CAP211
     C                   MOVEL     PCCY          P#FRCY                                       CAP211
     C                   Z-ADD     OPRCRM        P#FRAM                                       CAP211
     C                   MOVEL     BJCYCD        P#TOCY                                       CAP211
     C                   Z-ADD     0             P#TOAM                                       CAP211
     C                   CALL      'FT0010'                                                   CAP211
     C                   PARM                    P#0010                                       CAP211
s3   C     P#RTCD        IFNE      *BLANKS                                                    CAP211
     C                   Z-ADD     908           DBASE                                        CAP211
     C                   MOVEL     'FT0010'      DBFILE                                       CAP211
     C                   MOVEL     '*CALL '      DBKEY                                        CAP211
     C                   EXSR      *PSSR                                                      CAP211
x3   C                   ElSE                                                                 CAP211
     C                   Z-ADD     P#TOAM        OPRBCQ                                       CAP211
e3   C                   ENDIF                                                                CAP211
     C                   Z-ADD     OPRCRM        OPRCSC                                       CAP211
     C                   Z-ADD     OPRBCQ        OPRCSQ                                       CAP211
e2   C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
     C                   MOVE      INSCY1        OPSCC1                                       CAP211
     C                   MOVE      INSCH1        OPSCH1                                       CAP211
     C                   MOVE      INSCY2        OPSCC2                                       CAP211
     C                   MOVE      INSCH2        OPSCH2                                       CAP211
     C                   MOVE      INSCY3        OPSCC3                                       CAP211
     C                   MOVE      INSCH3        OPSCH3                                       CAP211
     C                   MOVE      INSCY4        OPSCC4                                       CAP211
     C                   MOVE      INSCH4        OPSCH4                                       CAP211
     C                   MOVE      INSCY5        OPSCC5                                       CAP211
     C                   MOVE      INSCH5        OPSCH5                                       CAP211
     C                   Z-ADD     0             WSCHG            11 0                        CAP211
s2   C     DTCH          IFEQ      'BEN'                                                      CAP211
     C     TXCH          ADD       CQCH          WCHGS                                        CAP211
     C                   ADD       MSCH          WCHGS                                        CAP211
     C                   ADD       TRCM          WCHGS                                        CAP211
s3   C     S01494        IFEQ      'Y'                                                        CAP211
     C                   ADD       OPCHCM        WCHGS                                        CAP211
e3   C                   ENDIF                                                                CAP211
s3   C     S01499        IFEQ      'Y'                                                        CAP211
     C                   ADD       OPVATT        WCHGS                                        CAP211
e3   C                   ENDIF                                                                CAP211
s3   C     WCHGS         IFNE      0                                                          CAP211
s4   C                   SELECT                                                               CAP211
     C     CDRT          WHENNE    *Blanks                                                    CAP211
     C                   MOVEL     BJCYCD        WCCCY                                        CAP211
     C     ADDC          WHENEQ    'A'                                                        CAP211
     C                   MOVEL     SMCY          WCCCY                                        CAP211
     C                   OTHER                                                                CAP211
     C                   MOVEL     PCCY          WCCCY                                        CAP211
e4   C                   ENDSL                                                                CAP211
s4   C     WCCCY         IFNE      PCCY                                                       CAP211
     C                   CLEAR                   P#0010                                       CAP211
     C                   MOVEL     WCCCY         P#FRCY                                       CAP211
     C                   Z-ADD     WCHGS         P#FRAM                                       CAP211
     C                   MOVEL     PCCY          P#TOCY                                       CAP211
     C                   Z-ADD     0             P#TOAM                                       CAP211
     C                   CALL      'FT0010'                                                   CAP211
     C                   PARM                    P#0010                                       CAP211
s5   C     P#RTCD        IFNE      *BLANKS                                                    CAP211
     C                   Z-ADD     908           DBASE                                        CAP211
     C                   MOVEL     'FT0010'      DBFILE                                       CAP211
     C                   MOVEL     '*CALL '      DBKEY                                        CAP211
     C                   EXSR      *PSSR                                                      CAP211
x5   C                   ELSE                                                                 CAP211
     C                   Z-ADD     P#TOAM        WCHGS                                        CAP211
e5   C                   ENDIF                                                                CAP211
     C                   ELSE                                                                 CAP211
     C                   Z-ADD     WCHGS         WSCHG                                        CAP211
e4   C                   ENDIF                                                                CAP211
e3   C                   ENDIF                                                                CAP211
s3   C                   SELECT                                                               CAP211
     C     OPSCC1        WHENEQ    *Blanks                                                    CAP211
     C                   MOVEL     PCCY          OPSCC1                                       CAP211
     C                   Z-ADD     WSCHG         OPSCH1                                       CAP211
     C                   Z-ADD     1             OPSCLE                                       CAP211
     C     OPSCC2        WHENEQ    *Blanks                                                    CAP211
     C                   MOVEL     PCCY          OPSCC2                                       CAP211
     C                   Z-ADD     WSCHG         OPSCH2                                       CAP211
     C                   Z-ADD     2             OPSCLE                                       CAP211
     C     OPSCC3        WHENEQ    *Blanks                                                    CAP211
     C                   MOVEL     PCCY          OPSCC3                                       CAP211
     C                   Z-ADD     WSCHG         OPSCH3                                       CAP211
     C                   Z-ADD     3             OPSCLE                                       CAP211
     C     OPSCC4        WHENEQ    *Blanks                                                    CAP211
     C                   MOVEL     PCCY          OPSCC4                                       CAP211
     C                   Z-ADD     WSCHG         OPSCH4                                       CAP211
     C                   Z-ADD     4             OPSCLE                                       CAP211
     C                   OTHER                                                                CAP211
     C                   MOVEL     PCCY          OPSCC5                                       CAP211
     C                   Z-ADD     WSCHG         OPSCH5                                       CAP211
     C                   Z-ADD     5             OPSCLE                                       CAP211
e3   C                   ENDSL                                                                CAP211
e2   C                   ENDIF                                                                CAP211
      *                                                                                    BUG12944A
     C                   SELECT                                                            BUG12944A
     C     BTCHCY        WHENEQ    'C'                                                     BUG12944A
     C     ADDC          IFEQ      'A'                                                     BUG12944A
     C                   MOVEL     SMCY          OPCHGC                                    BUG12944A
     C                   ELSE                                                              BUG12944A
     C                   MOVEL     PCCY          OPCHGC                                    BUG12944A
     C                   ENDIF                                                             BUG12944A
     C     BTCHCY        WHENEQ    'L'                                                     BUG12944A
     C                   MOVEL     BJLCCY        OPCHGC                                    BUG12944A
     C                   OTHER                                                             BUG12944A
     C                   MOVEL     BJCYCD        OPCHGC                                    BUG12944A
     C                   ENDSL                                                             BUG12944A
      *                                                                                       CAP211
     C     PREF          CHAIN     OTXL0                              80                      CAP211
s2   C     *IN80         IFEQ      *Off                                                       CAP211
     C                   Z-ADD     909           DBASE                                        CAP211
     C                   MOVEL     'OTPAYXL0'    DBFILE                                       CAP211
     C                   MOVEL     'PREF  '      DBKEY                                        CAP211
     C                   EXSR      *PSSR                                                      CAP211
x2   C                   ELSE                                                                 CAP211
     C                   MOVEL     TMST          OPTMST                                       CAP211
     C                   WRITE     OTPAYXDF                             80                    CAP211
e2   C                   ENDIF                                                                CAP211
e1   C                   ENDIF                                                                CAP211
s1   C     CFT009        IFEQ      'Y'                                                        CAP211
     C                   MOVEL     FXSPSC        FXSRSC                                       CAP211
     C                   MOVEL     INPDOF        OTPDOF                                       CAP211
     C                   MOVEL     TLCODE        TLXCDE                                       CAP211
     C                   MOVEL     CHCHCD        CHQCHC                                       CAP211
     C                   MOVEL     *Blanks       CACHCD                                       CAP211
     C                   MOVEL     *Blanks       SSTCCD                                       CAP211
     C                   MOVEL     *Blanks       SPRCCD                                       CAP211
     C                   MOVEL     MISCH         MSCHC                                        CAP211
     C                   MOVEL     MSCH1         MSCHC1                                       CAP211
     C                   MOVEL     MSCH2         MSCHC2                                       CAP211
     C                   MOVEL     MSCH3         MSCHC3                                       CAP211
     C                   MOVEL     MSCH4         MSCHC4                                       CAP211
     C                   MOVEL     MSCH5         MSCHC5                                       CAP211
     C                   MOVEL     TFCCCO        TFCCCD                                       CAP211
     C                   MOVEL     FXCHEC        FXCACC                                       CAP211
     C                   MOVEL     *Blanks       VTSWSC                                       CAP211
     C                   MOVEL     VTMIC1        VMIC1                                        CAP211
     C                   MOVEL     VTMIC2        VMIC2                                        CAP211
     C                   MOVEL     VTMIC3        VMIC3                                        CAP211
     C                   MOVEL     VTMIC4        VMIC4                                        CAP211
     C                   MOVEL     VTMIC5        VMIC5                                        CAP211
     C                   Z-ADD     MSC01         MISC01                                       CAP211
     C                   Z-ADD     MSC02         MISC02                                       CAP211
     C                   Z-ADD     MSC03         MISC03                                       CAP211
     C                   Z-ADD     MSC04         MISC04                                       CAP211
     C                   Z-ADD     MSC05         MISC05                                       CAP211
     C                   Z-ADD     0             SWSCHG                                       CAP211
     C                   Z-ADD     0             DATNED                                       CAP211
     C                   Z-ADD     0             DATNAO                                       CAP211
     C                   MOVEL     *Blanks       CUNFLA                                       CAP211
     C                   MOVEL     *Blanks       OPCHRT                                       CAP211
     C                   MOVEL     *Blanks       OPCHGC                                       CAP211
e1   C                   ENDIF                                                                CAP211
     C                   WRITE     OTPAYDDF                             80                    CAP211
      *                                                                                       CAP211
      ** Move valid file details to extension file details                                    CAP211
      *                                                                                       CAP211
     C                   EVAL      OTPREF = PREF                                              CAP211
     C                   EVAL      OTBRCA = BRCA                                              CAP211
     C                   EVAL      OTFRID = FRNT                                              CAP211
     C                   WRITE     OTPAYQD0                             99                    CAP211
      *                                                                                       CAP211
      ** Update trailer                                                                       CAP211
      *                                                                                       CAP211
     C     *IN80         IFEQ      *Off                                                       CAP211
     C     1             CHAIN     OTPAYZZF                           80                      CAP211
     C     *IN80         IFEQ      *Off                                                       CAP211
     C                   Z-ADD     OHRWN         ZZTOTI                                       CAP211
     C                   Z-ADD     OHRDC         ZZTOTD                                       CAP211
     C************       ADD       1             NORE1                               CAP211 MD054037
     C                   ADD       1             ONORE1                                     MD054037
     C     SMAM          DIV       1000          ZZAMT                                        CAP211
     C                   EXSR      SrGLZADD                                                   CAP211
     C                   Z-ADD     ZZTOTI        OHRWN                                        CAP211
     C                   Z-ADD     ZZTOTD        OHRDC                                        CAP211
     C                   UPDATE    OTPAYZZF                                                   CAP211
     C                   ENDIF                                                                CAP211
     C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
     C                   ENDSR                                                                CAP211
      *                                                                                       CAP211
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * SRWTCH - Set-up parameter and send transaction details to     *                       CSD015
      *          Compliance Watch by calling the Engine program       *                       CSD015
      *                                                               *                       CSD015
      * Called by: SR/INSERT, SR/AMEND                                *                       CSD015
      *                                                               *                       CSD015
      * Calls: None                                                   *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRWTCH        BEGSR                                                                CSD015
                                                                                              CSD015
     C                   CLEAR                   SDWLTD                                       CSD015
     C                   CLEAR                   PString                                      CSD015
     C                   EVAL      U = *Zeros                                                 CSD015
     C                   EVAL      Fld1 = *Blanks                                             CSD015
     C                   EVAL      Fld2 = *Blanks                                             CSD015
     C                   EVAL      Fld3 = *Blanks                                             CSD015
     C                   EVAL      Fld4 = *Blanks                                             CSD015
     C                   EVAL      Fld5 = *Blanks                                             CSD015
     C                   EVAL      Fld6 = *Blanks                                             CSD015
     C                   EVAL      PInCcy  = SMCY                                             CSD015
                                                                                              CSD015
      ** Sender                                                                               CSD015
     C                   IF        IPSND1 <> *Blanks  OR IPSND2 <> *Blanks  OR                CSD015
     C                             IPSND3 <> *Blanks  OR IPSND4 <> *Blanks                    CSD015
                                                                                              CSD015
     C                   IF        IPCHTP = 'I'  OR WUNCFL = 'Y' OR                           CSD015
     C                             IPCHTP = 'A'  AND IPSND1 <> CHSND1  OR                     CSD015
     C                             IPCHTP = 'A'  AND IPSND2 <> CHSND2  OR                     CSD015
     C                             IPCHTP = 'A'  AND IPSND3 <> CHSND3  OR                     CSD015
     C                             IPCHTP = 'A'  AND IPSND4 <> CHSND4                         CSD015
     C                   EVAL      Fld1 = IPSND1                                              CSD015
     C                   EVAL      Fld2 = IPSND2                                              CSD015
     C                   EVAL      Fld3 = IPSND3                                              CSD015
     C                   EVAL      Fld4 = IPSND4                                              CSD015
     C                   EVAL      U = 1                                                      CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Receivers Correspondent - FT Version                                                 CSD015
     C***********        IF        IPRCCO <> *ZERO                                     CSD015 CSD027
     C                   IF        IPRCCO <> *BLANKS                                          CSD027
                                                                                              CSD015
     C                   IF        IPCHTP = 'I'  OR WUNCFL = 'Y' OR                           CSD015
     C                             IPCHTP = 'A'  AND  IPRCCO <> CHRCCO                        CSD015
     C                   MOVEL     IPRCCO        WRCCO             6                          CSD015
     C                   MOVEL     WRCCO         Fld1                                         CSD015
     C                   EVAL      U = 3                                                      CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Account with Bank - FT Version                                                       CSD015
     C                   IF        IPACBK <> *Blanks                                          CSD015
                                                                                              CSD015
     C                   IF        IPCHTP = 'I'  OR WUNCFL = 'Y' OR                           CSD015
     C                             IPCHTP = 'A'  AND  IPACBK <> CHACBK                        CSD015
     C                   EVAL      Fld1 = IPACBK                                              CSD015
     C                   EVAL      U = 5                                                      CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Beneficiary                                                                          CSD015
     C                   IF        IPBNC1 <> *Blanks  OR  IPBNC2 <> *Blanks  OR               CSD015
     C                             IPBNC3 <> *Blanks  OR  IPBNC4 <> *BLanks  OR               CSD015
     C                             IPBNC5 <> *Blanks                                          CSD015
                                                                                              CSD015
     C                   IF        IPCHTP = 'I'  OR   WUNCFL = 'Y' OR                         CSD015
     C                             IPCHTP = 'A'  AND  IPBNC1 <> CHBNC1  OR                    CSD015
     C                             IPCHTP = 'A'  AND  IPBNC2 <> CHBNC2  OR                    CSD015
     C                             IPCHTP = 'A'  AND  IPBNC3 <> CHBNC3  OR                    CSD015
     C                             IPCHTP = 'A'  AND  IPBNC4 <> CHBNC4  OR                    CSD015
     C                             IPCHTP = 'A'  AND  IPBNC5 <> CHBNC5                        CSD015
     C                   EVAL      Fld1 = IPBNC1                                              CSD015
     C                   EVAL      Fld2 = IPBNC2                                              CSD015
     C                   EVAL      Fld3 = IPBNC3                                              CSD015
     C                   EVAL      Fld4 = IPBNC4                                              CSD015
     C                   EVAL      Fld5 = IPBNC5                                              CSD015
     C                   EVAL      U = 7                                                      CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Ordering Bank                                                                        CSD015
     C                   IF        IPORB1 <> *Blanks  OR  IPORB2 <> *Blanks  OR               CSD015
     C                             IPORB3 <> *Blanks  OR  IPORB4 <> *Blanks  OR               CSD015
     C                             IPORB5 <> *Blanks                                          CSD015
                                                                                              CSD015
     C                   IF        IPCHTP = 'I'  OR  WUNCFL = 'Y' OR                          CSD015
     C                             IPCHTP = 'A'  AND  IPORB1 <> CHORB1  OR                    CSD015
     C                             IPCHTP = 'A'  AND  IPORB2 <> CHORB2  OR                    CSD015
     C                             IPCHTP = 'A'  AND  IPORB3 <> CHORB3  OR                    CSD015
     C                             IPCHTP = 'A'  AND  IPORB4 <> CHORB4  OR                    CSD015
     C                             IPCHTP = 'A'  AND  IPORB5 <> CHORB5                        CSD015
     C                   EVAL      Fld1 = IPORB1                                              CSD015
     C                   EVAL      Fld2 = IPORB2                                              CSD015
     C                   EVAL      Fld3 = IPORB3                                              CSD015
     C                   EVAL      Fld4 = IPORB4                                              CSD015
     C                   EVAL      Fld5 = IPORB5                                              CSD015
     C                   EVAL      U = 9                                                      CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   EVAL      WCustomer = OutFmt                                         CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Senders Correspondent                                                                CSD015
     C                   IF        IPSNC1 <> *Blanks  OR  IPSNC2 <> *Blanks  OR               CSD015
     C                             IPSNC3 <> *Blanks  OR  IPSNC4 <> *BLanks  OR               CSD015
     C                             IPSNC5 <> *Blanks                                          CSD015
                                                                                              CSD015
     C                   IF        IPCHTP = 'I'  OR WUNCFL = 'Y' OR                           CSD015
     C                             IPCHTP = 'A'  AND  IPSNC1 <> CHSNC1  OR                    CSD015
     C                             IPCHTP = 'A'  AND  IPSNC2 <> CHSNC2  OR                    CSD015
     C                             IPCHTP = 'A'  AND  IPSNC3 <> CHSNC3  OR                    CSD015
     C                             IPCHTP = 'A'  AND  IPSNC4 <> CHSNC4  OR                    CSD015
     C                             IPCHTP = 'A'  AND  IPSNC5 <> CHSNC5                        CSD015
     C                   EVAL      Fld1 = IPSNC1                                              CSD015
     C                   EVAL      Fld2 = IPSNC2                                              CSD015
     C                   EVAL      Fld3 = IPSNC3                                              CSD015
     C                   EVAL      Fld4 = IPSNC4                                              CSD015
     C                   EVAL      Fld5 = IPSNC5                                              CSD015
     C                   EVAL      U = 11                                                     CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Ordering Customer                                                                    CSD015
     C                   IF        IPORC1 <> *Blanks  OR  IPORC2 <> *Blanks  OR               CSD015
     C**********                   IPORC3 <> *Blanks  OR  IPORC4 <> *Blanks            CSD015 CFT032
     C                             IPORC3 <> *Blanks  OR  IPORC4 <> *Blanks  OR               CFT032
     C                             IPORC5 <> *Blanks                                          CFT032
                                                                                              CSD015
     C                   IF        IPCHTP = 'I'  OR WUNCFL = 'Y' OR                           CSD015
     C                             IPCHTP = 'A'  AND  IPORC1 <> CHORC1  OR                    CSD015
     C                             IPCHTP = 'A'  AND  IPORC2 <> CHORC2  OR                    CSD015
     C                             IPCHTP = 'A'  AND  IPORC3 <> CHORC3  OR                    CSD015
     C**********                   IPCHTP = 'A'  AND  IPORC4 <> CHORC4                 CSD015 CFT032
     C                             IPCHTP = 'A'  AND  IPORC4 <> CHORC4  OR                    CFT032
     C                             IPCHTP = 'A'  AND  IPORC5 <> CHORC5                        CFT032
     C                                                                                        CFT032
     C                   EVAL      Fld1 = IPORC1                                              CSD015
     C                   EVAL      Fld2 = IPORC2                                              CSD015
     C                   EVAL      Fld3 = IPORC3                                              CSD015
     C                   EVAL      Fld4 = IPORC4                                              CSD015
     C                   EVAL      Fld5 = IPORC5                                              CFT032
     C                   EVAL      U = 13                                                     CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   EVAL      WCustomer = OutFmt                                         CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Details of Payment                                                                   CSD015
     C                   IF        IPDTP1 <> *Blanks  OR  IPDTP2 <> *Blanks  OR               CSD015
     C                             IPDTP3 <> *Blanks  OR  IPDTP4 <> *BLanks                   CSD015
                                                                                              CSD015
     C                   IF        IPCHTP = 'I'  OR WUNCFL = 'Y' OR                           CSD015
     C                             IPCHTP = 'A'  AND  IPDTP1 <> CHDTP1  OR                    CSD015
     C                             IPCHTP = 'A'  AND  IPDTP2 <> CHDTP2  OR                    CSD015
     C                             IPCHTP = 'A'  AND  IPDTP3 <> CHDTP3  OR                    CSD015
     C                             IPCHTP = 'A'  AND  IPDTP4 <> CHDTP4                        CSD015
     C                   EVAL      Fld1 = IPDTP1                                              CSD015
     C                   EVAL      Fld2 = IPDTP2                                              CSD015
     C                   EVAL      Fld3 = IPDTP3                                              CSD015
     C                   EVAL      Fld4 = IPDTP4                                              CSD015
     C                   EVAL      U = 15                                                     CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Intermediary Bank                                                                    CSD015
     C                   IF        IPINB1 <> *Blanks  OR  IPINB2 <> *Blanks  OR               CSD015
     C                             IPINB3 <> *Blanks  OR  IPINB4 <> *BLanks  OR               CSD015
     C                             IPINB5 <> *Blanks                                          CSD015
                                                                                              CSD015
     C                   IF        IPCHTP = 'I'  OR WUNCFL = 'Y' OR                           CSD015
     C                             IPCHTP = 'A'  AND  IPINB1 <> CHINB1  OR                    CSD015
     C                             IPCHTP = 'A'  AND  IPINB2 <> CHINB2  OR                    CSD015
     C                             IPCHTP = 'A'  AND  IPINB3 <> CHINB3  OR                    CSD015
     C                             IPCHTP = 'A'  AND  IPINB4 <> CHINB4  OR                    CSD015
     C                             IPCHTP = 'A'  AND  IPINB5 <> CHINB5                        CSD015
     C                   EVAL      Fld1 = IPINB1                                              CSD015
     C                   EVAL      Fld2 = IPINB2                                              CSD015
     C                   EVAL      Fld3 = IPINB3                                              CSD015
     C                   EVAL      Fld4 = IPINB4                                              CSD015
     C                   EVAL      Fld5 = IPINB5                                              CSD015
     C                   EVAL      U = 17                                                     CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Receivers Correspondent                                                              CSD015
     C                   IF        INRCO1 <> *Blanks  OR INRCO2 <> *Blanks  OR                CSD015
     C                             INRCO3 <> *Blanks  OR INRCO4 <> *BLanks  OR                CSD015
     C                             INRCO5 <> *Blanks                                          CSD015
                                                                                              CSD015
     C                   IF        IPCHTP = 'I'  OR WUNCFL = 'Y' OR                           CSD015
     C                             IPCHTP = 'A'  AND  INRCO1 <> CHINRCO1 OR                   CSD015
     C                             IPCHTP = 'A'  AND  INRCO2 <> CHINRCO2 OR                   CSD015
     C                             IPCHTP = 'A'  AND  INRCO3 <> CHINRCO3 OR                   CSD015
     C                             IPCHTP = 'A'  AND  INRCO4 <> CHINRCO4 OR                   CSD015
     C                             IPCHTP = 'A'  AND  INRCO5 <> CHINRCO5                      CSD015
     C                   EVAL      Fld1 = INRCO1                                              CSD015
     C                   EVAL      Fld2 = INRCO2                                              CSD015
     C                   EVAL      Fld3 = INRCO3                                              CSD015
     C                   EVAL      Fld4 = INRCO4                                              CSD015
     C                   EVAL      Fld5 = INRCO5                                              CSD015
     C                   EVAL      U = 19                                                     CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Account with Bank                                                                    CSD015
     C                   IF        INACB1 <> *Blanks  OR  INACB2 <> *Blanks  OR               CSD015
     C                             INACB3 <> *Blanks  OR  INACB4 <> *BLanks  OR               CSD015
     C                             INACB5 <> *Blanks                                          CSD015
                                                                                              CSD015
     C                   IF        IPCHTP = 'I'  OR WUNCFL = 'Y' OR                           CSD015
     C                             IPCHTP = 'A'  AND  INACB1 <> CHINACB1  OR                  CSD015
     C                             IPCHTP = 'A'  AND  INACB2 <> CHINACB2  OR                  CSD015
     C                             IPCHTP = 'A'  AND  INACB3 <> CHINACB3  OR                  CSD015
     C                             IPCHTP = 'A'  AND  INACB4 <> CHINACB4  OR                  CSD015
     C                             IPCHTP = 'A'  AND  INACB5 <> CHINACB5                      CSD015
     C                   EVAL      Fld1 = INACB1                                              CSD015
     C                   EVAL      Fld2 = INACB2                                              CSD015
     C                   EVAL      Fld3 = INACB3                                              CSD015
     C                   EVAL      Fld4 = INACB4                                              CSD015
     C                   EVAL      Fld5 = INACB5                                              CSD015
     C                   EVAL      U = 21                                                     CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Third Reimbursement Institution                                                      CSD015
     C                   IF        INTRIB <> *Blanks  OR  INTRI1 <> *Blanks  OR               CSD015
     C                             INTRI2 <> *Blanks  OR  INTRI3 <> *BLanks  OR               CSD015
     C                             INTRI4 <> *Blanks  OR  INTRI5 <> *Blanks                   CSD015
                                                                                              CSD015
     C                   IF        IPCHTP = 'I'  or WUNCFL = 'Y' OR                           CSD015
     C                             IPCHTP = 'A'  AND  INTRIB <> I2INTRIB  OR                  CSD015
     C                             IPCHTP = 'A'  AND  INTRI1 <> I2INTRI1  OR                  CSD015
     C                             IPCHTP = 'A'  AND  INTRI2 <> I2INTRI2  OR                  CSD015
     C                             IPCHTP = 'A'  AND  INTRI3 <> I2INTRI3  OR                  CSD015
     C                             IPCHTP = 'A'  AND  INTRI4 <> I2INTRI4  OR                  CSD015
     C                             IPCHTP = 'A'  AND  INTRI5 <> I2INTRI5                      CSD015
     C                   EVAL      Fld1 = INTRIB                                              CSD015
     C                   EVAL      Fld2 = INTRI1                                              CSD015
     C                   EVAL      Fld3 = INTRI2                                              CSD015
     C                   EVAL      Fld4 = INTRI3                                              CSD015
     C                   EVAL      Fld5 = INTRI4                                              CSD015
     C                   EVAL      Fld6 = INTRI5                                              CSD015
     C                   EVAL      U = 23                                                     CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        CSW209 = 'Y'                                               CSW209
      *                                                                                       CSW209
      ** Ordering Customer Cover                                                              CSW209
      *                                                                                       CSW209
     C                   IF        INCOC1 <> *Blanks  OR                                      CSW209
     C                             INCOC2 <> *Blanks  OR                                      CSW209
     C                             INCOC3 <> *Blanks  OR                                      CSW209
     C                             INCOC4 <> *Blanks  OR                                      CSW209
     C                             INCOC5 <> *Blanks                                          CSW209
      *                                                                                       CSW209
     C                   IF        IPCHTP = 'I' OR                                            CSW209
     C                             WUNCFL = 'Y' OR                                            CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCOC1 <> I2COC1  OR                                       CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCOC2 <> I2COC2  OR                                       CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCOC3 <> I2COC3  OR                                       CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCOC4 <> I2COC4  OR                                       CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCOC5 <> I2COC5                                           CSW209
     C                   EVAL      Fld1 = INCOC1                                              CSW209
     C                   EVAL      Fld2 = INCOC2                                              CSW209
     C                   EVAL      Fld3 = INCOC3                                              CSW209
     C                   EVAL      Fld4 = INCOC4                                              CSW209
     C                   EVAL      Fld5 = INCOC5                                              CSW209
     C                   EVAL      U = 25                                                     CSW209
     C                   EXSR      SRConvert                                                  CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Ordering Bank Cover                                                                  CSW209
      *                                                                                       CSW209
     C                   IF        INCOB1 <> *Blanks  OR                                      CSW209
     C                             INCOB2 <> *Blanks  OR                                      CSW209
     C                             INCOB3 <> *Blanks  OR                                      CSW209
     C                             INCOB4 <> *Blanks  OR                                      CSW209
     C                             INCOB5 <> *Blanks                                          CSW209
      *                                                                                       CSW209
     C                   IF        IPCHTP = 'I' OR                                            CSW209
     C                             WUNCFL = 'Y' OR                                            CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCOB1 <> I2COB1  OR                                       CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCOB2 <> I2COB2  OR                                       CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCOB3 <> I2COB3  OR                                       CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCOB4 <> I2COB4  OR                                       CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCOB5 <> I2COB5                                           CSW209
     C                   EVAL      Fld1 = INCOB1                                              CSW209
     C                   EVAL      Fld2 = INCOB2                                              CSW209
     C                   EVAL      Fld3 = INCOB3                                              CSW209
     C                   EVAL      Fld4 = INCOB4                                              CSW209
     C                   EVAL      Fld5 = INCOB5                                              CSW209
     C                   EVAL      U = 27                                                     CSW209
     C                   EXSR      SRConvert                                                  CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Intermediary Bank Cover                                                              CSW209
      *                                                                                       CSW209
     C                   IF        INCIB1 <> *Blanks  OR                                      CSW209
     C                             INCIB2 <> *Blanks  OR                                      CSW209
     C                             INCIB3 <> *Blanks  OR                                      CSW209
     C                             INCIB4 <> *Blanks  OR                                      CSW209
     C                             INCIB5 <> *Blanks                                          CSW209
      *                                                                                       CSW209
     C                   IF        IPCHTP = 'I' OR                                            CSW209
     C                             WUNCFL = 'Y' OR                                            CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCIB1 <> I2CIB1  OR                                       CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCIB2 <> I2CIB2  OR                                       CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCIB3 <> I2CIB3  OR                                       CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCIB4 <> I2CIB4  OR                                       CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCIB5 <> I2CIB5                                           CSW209
     C                   EVAL      Fld1 = INCIB1                                              CSW209
     C                   EVAL      Fld2 = INCIB2                                              CSW209
     C                   EVAL      Fld3 = INCIB3                                              CSW209
     C                   EVAL      Fld4 = INCIB4                                              CSW209
     C                   EVAL      Fld5 = INCIB5                                              CSW209
     C                   EVAL      U = 29                                                     CSW209
     C                   EXSR      SRConvert                                                  CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Account with Bank Cover                                                              CSW209
      *                                                                                       CSW209
     C                   IF        INCAB1 <> *Blanks  OR                                      CSW209
     C                             INCAB2 <> *Blanks  OR                                      CSW209
     C                             INCAB3 <> *Blanks  OR                                      CSW209
     C                             INCAB4 <> *Blanks  OR                                      CSW209
     C                             INCAB5 <> *Blanks                                          CSW209
      *                                                                                       CSW209
     C                   IF        IPCHTP = 'I' OR                                            CSW209
     C                             WUNCFL = 'Y' OR                                            CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCAB1 <> I2CAB1  OR                                       CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCAB2 <> I2CAB2  OR                                       CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCAB3 <> I2CAB3  OR                                       CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCAB4 <> I2CAB4  OR                                       CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCAB5 <> I2CAB5                                           CSW209
     C                   EVAL      Fld1 = INCAB1                                              CSW209
     C                   EVAL      Fld2 = INCAB2                                              CSW209
     C                   EVAL      Fld3 = INCAB3                                              CSW209
     C                   EVAL      Fld4 = INCAB4                                              CSW209
     C                   EVAL      Fld5 = INCAB5                                              CSW209
     C                   EVAL      U = 31                                                     CSW209
     C                   EXSR      SRConvert                                                  CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Beneficiary Cover                                                                    CSW209
      *                                                                                       CSW209
     C                   IF        INCBC1 <> *Blanks  OR                                      CSW209
     C                             INCBC2 <> *Blanks  OR                                      CSW209
     C                             INCBC3 <> *Blanks  OR                                      CSW209
     C                             INCBC4 <> *Blanks  OR                                      CSW209
     C                             INCBC5 <> *Blanks                                          CSW209
      *                                                                                       CSW209
     C                   IF        IPCHTP = 'I' OR                                            CSW209
     C                             WUNCFL = 'Y' OR                                            CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCBC1 <> I2CBC1  OR                                       CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCBC2 <> I2CBC2  OR                                       CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCBC3 <> I2CBC3  OR                                       CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCBC4 <> I2CBC4  OR                                       CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCBC5 <> I2CBC5                                           CSW209
     C                   EVAL      Fld1 = INCBC1                                              CSW209
     C                   EVAL      Fld2 = INCBC2                                              CSW209
     C                   EVAL      Fld3 = INCBC3                                              CSW209
     C                   EVAL      Fld4 = INCBC4                                              CSW209
     C                   EVAL      Fld5 = INCBC5                                              CSW209
     C                   EVAL      U = 33                                                     CSW209
     C                   EXSR      SRConvert                                                  CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Details of Payment Cover                                                             CSW209
      *                                                                                       CSW209
     C                   IF        INCDP1 <> *Blanks  OR                                      CSW209
     C                             INCDP2 <> *Blanks  OR                                      CSW209
     C                             INCDP3 <> *Blanks  OR                                      CSW209
     C                             INCDP4 <> *Blanks                                          CSW209
      *                                                                                       CSW209
     C                   IF        IPCHTP = 'I' OR                                            CSW209
     C                             WUNCFL = 'Y' OR                                            CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCDP1 <> I2CDP1  OR                                       CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCDP2 <> I2CDP2  OR                                       CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCDP3 <> I2CDP3  OR                                       CSW209
     C                             IPCHTP = 'A'  AND                                          CSW209
     C                             INCDP4 <> I2CDP4                                           CSW209
     C                   EVAL      Fld1 = INCDP1                                              CSW209
     C                   EVAL      Fld2 = INCDP2                                              CSW209
     C                   EVAL      Fld3 = INCDP3                                              CSW209
     C                   EVAL      Fld4 = INCDP4                                              CSW209
     C                   EVAL      U = 35                                                     CSW209
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
     C                   EVAL      W4ITEM = 'FTIPAY'                                          CSD015
                                                                                              CSD015
      ** Identifier                                                                           CSD015
     C                   EVAL      W4IDEN = IPPREF                                            CSD015
                                                                                              CSD015
      ** Branch                                                                               CSD015
     C                   EVAL      W4BRCH = IPBRCA                                            CSD015
                                                                                              CSD015
      ** System                                                                               CSD015
      ** If Midas 24x7 is installed, use Main system prefix otherwise use system prefix       CSD015
     C                   IF        CSC011 = 'Y'                                               CSD015
     C                   EVAL      W4SYSM = S1MAIN                                            CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4SYSM = LIBR                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Function Type                                                                        CSD015
     C                   EVAL      W4FUNT = 'INPAYDD'                                         CSD015
                                                                                              CSD015
      ** Counterparty Details                                                                 CSD015
      ** Counterparty is the sender of the message                                            CSD015
                                                                                              CSD015
     C                   EVAL      W4CNUM = *Blanks                                           CSD015
     C                   EVAL      W4CTYP = *Blanks                                           CSD015
     C                   EVAL      W4CUST = *Blanks                                           CSD015
     C                   MOVEL     IPRCCO        WRecCor           6                          CSD015
                                                                                              CSD015
     C                   IF        IPSND1 <> *Blanks  or  IPSND2 <> *Blanks  or               CSD015
     C                             IPSND3 <> *Blanks  or  IPSND4 <> *Blanks                   CSD015
     C                   EVAL      Fld1 = IPSND1                                              CSD015
     C                   EVAL      Fld2 = IPSND2                                              CSD015
     C                   EVAL      Fld3 = IPSND3                                              CSD015
     C                   EVAL      Fld4 = IPSND4                                              CSD015
     C                   EXSR      SRGetCtrpDet                                               CSD015
     C                   ENDIF                                                                CSD015
     C                   IF        OutFmt2 = '*FREE' or OutFmt2 = '*CPART' or                 CSD015
     C                             (IPSND1 = *Blanks and IPSND2 = *Blanks and                 CSD015
     C                             IPSND3 = *Blanks and IPSND4 = *Blanks)                     CSD015
     C                   MOVEL     WRecCor       Fld1                                         CSD015
     C                   EVAL      Fld2 = *Blanks                                             CSD015
     C                   EVAL      Fld3 = *Blanks                                             CSD015
     C                   EVAL      Fld4 = *Blanks                                             CSD015
     C                   EVAL      PInCcy = IPSMCY                                            CSD015
     C                   EXSR      SRGetCtrpDet                                               CSD015
     C                   ENDIF                                                                CSD015
     C                   IF        OutFmt2 = '*FREE' or OutFmt2 = '*CPART' or                 CSD015
     C                             (IPSND1 = *Blanks and IPSND2 = *Blanks  and                CSD015
     C                             IPSND3 = *Blanks and IPSND4 = *Blanks  and                 CSD015
     C                             WRecCor = *Blanks)                                         CSD015
     C                   EVAL      Fld1 = I2INTRIB                                            CSD015
     C                   EVAL      Fld2 = *Blanks                                             CSD015
     C                   EVAL      Fld3 = *Blanks                                             CSD015
     C                   EVAL      Fld4 = *Blanks                                             CSD015
     C                   ENDIF                                                                CSD015
     C                   IF        OutFmt2 <> '*FREE' and OutFmt2 <> '*CPART'                 CSD015
     C                   EVAL      W4CNUM = OutFmt2                                           CSD015
     C                   EVAL      W4CTYP = WCtrpTyp                                          CSD015
     C                   EVAL      W4CUST = WCtrpRpt                                          CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Deal Date                                                                            CSD015
     C                   MOVE      '00000'       PZADayNo                                     CSD015
     C                   EXSR      SRDateToDDT                                                CSD015
     C                   EVAL      W4DDAT = WDDT                                              CSD015
                                                                                              CSD015
      ** Value Date                                                                           CSD015
     C                   MOVE      IPSLDT        PZADayNo                                     CSD015
     C                   EXSR      SRDateToDDT                                                CSD015
     C                   EVAL      W4VDAT = WDDT                                              CSD015
                                                                                              CSD015
      ** Maturity Date                                                                        CSD015
     C                   MOVE      IPPVDT        PZADayNo                                     CSD015
     C                   EXSR      SRDateToDDT                                                CSD015
     C                   EVAL      W4MDAT = WDDT                                              CSD015
                                                                                              CSD015
      ** Denomination Side 1                                                                  CSD015
     C                   EVAL      W4DEN1  = IPSMCY                                           CSD015
                                                                                              CSD015
      ** Denomination Side 2                                                                  CSD015
     C                   EVAL      W4DEN2  = IPPCCY                                           CSD015
                                                                                              CSD015
      ** Amount Side 1                                                                        CSD015
     C                   EVAL      PZACcy = IPSMCY                                            CSD015
     C                   MOVE      IPSMAM        PZAAmt                                       CSD015
     C                   EXSR      SRAmtToFPDT                                                CSD015
     C                   EVAL      W4AMT1 = WFPDT                                             CSD015
                                                                                              CSD015
      ** Amount Side 2                                                                        CSD015
     C                   EVAL      PZACcy = IPPCCY                                            CSD015
     C                   MOVE      IPPYAM        PZAAmt                                       CSD015
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
     C                   PARM      *BLANKS       PRtCd                                        CSD015
     C                   PARM                    PZADayNo                                     CSD015
     C                   PARM                    PZADDT                                       CSD015
     C                   PARM                    PZACvtDt                                     CSD015
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
     C                   PARM      *Blanks       Prtcd                                        CSD015
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
     C                   IF        Prtcd <> *Blanks  AND                                      CSD015
     C                             Prtcd <> '*NRF  '                                          CSD015
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
     C                   EVAL      Fld6 = *Blanks                                             CSD015
     C                   EVAL      PCustNo = OutFmt2                                          CSD015
                                                                                              CSD015
      ** Get the Customer Detail.                                                             CSD015
                                                                                              CSD015
     C                   CALL      'AOCUSTR0'                                                 CSD015
     C                   PARM      *BLANKS       PrtCd                                        CSD015
     C                   PARM      '*KEY   '     POptn                                        CSD015
     C                   PARM                    PCustNo                                      CSD015
     C                   PARM      *BLANKS       PErrInf                                      CSD015
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSD015
                                                                                              CSD015
     C                   IF        PrtCd = *Blanks                                            CSD015
                                                                                              CSD015
      ** Assemble the Counterparty Report information.                                        CSD015
                                                                                              CSD015
     C     BBCRNM        CAT       BBCRTN        WCtrpRpt                                     CSD015
                                                                                              CSD015
      ** Determine the Counterparty Type.                                                     CSD015
                                                                                              CSD015
     C                   IF        CCF001 = 'Y'                                               CSD015
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
     C                   IF        PrtCd <> '*NRF'                                            CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = POptn                                              CSD015
     C                   EVAL      DBFile = 'SDCUSTPD'                                        CSD015
     C                   EVAL      DBase = 21                                                 CSD015
     C                   OUT       LDA                                                      MD029681
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRConvert - Subroutine to convert accounts, customer no. to   *                       CSD015
      *             customer name and address.                        *                       CSD015
      * Called by: SRWTCH                                             *                       CSD015
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
     C                   PARM      *Blanks       Prtcd                                        CSD015
     C                   PARM      Fld1          PInput                                       CSD015
     C                   PARM      Fld2          PInput1                                      CSD015
     C                   PARM      Fld3          PInput2                                      CSD015
     C                   PARM      Fld4          PInput3                                      CSD015
     C                   PARM      Fld5          PInput4                                      CSD015
     C                   PARM      Fld6          PInput5                                      CSD015
     C                   PARM                    PInCcy                                       CSD015
     C                   PARM                    OutFmt                                       CSD015
     C                   PARM                    OutFmt2                                      CSD015
                                                                                              CSD015
     C                   IF        Prtcd <> *Blanks  and                                      CSD015
     C                             Prtcd <> '*NRF  '                                          CSD015
     C                   EVAL      DBKey = Fld1                                               CSD015
     C                   EVAL      DBFile = 'SDCWLFMT'                                        CSD015
     C                   EVAL      DBase = 10                                                 CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
                                                                                              CSD015
     C                   EVAL      Fld1 = *Blanks                                             CSD015
     C                   EVAL      Fld2 = *Blanks                                             CSD015
     C                   EVAL      Fld3 = *Blanks                                             CSD015
     C                   EVAL      Fld4 = *Blanks                                             CSD015
     C                   EVAL      Fld5 = *Blanks                                             CSD015
     C                   EVAL      Fld6 = *Blanks                                             CSD015
                                                                                              CSD015
     C     PString       CAT       WLARR(U):0    PString                                      CSD015
     C     PString       CAT       OUTFMT:0      PString                                      CSD015
     C                   EVAL      U = U+1                                                    CSD015
     C     PString       CAT       WLARR(U):0    PString                                      CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
                                                                                              CGL029
      *****************************************************************                       CGL029
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
     C     C_ATYP        WHENEQ    'N'                                                       BUG3821
     C                   EVAL      C_NOSN = W_NOSN                                           BUG3821
     C     C_ATYP        WHENEQ    'F'                                                       BUG3821
     C                   EVAL      C_NOS  = W_NOS                                            BUG3821
     C     C_ATYP        WHENEQ    'R'                                                       BUG3821
     C                   EVAL      C_ACNO = W_ACNO                                           BUG3821
     C     C_ATYP        WHENEQ    'G'                                                       BUG3821
     C     C_ATYP        OREQ      'I'                                                      BUG23088
     C                   EVAL      C_CNU1 = W_CNU1                                            CGL029
     C                   EVAL      C_CCY1 = W_CCY1                                            CGL029
     C                   EVAL      C_ACO1 = W_ACO1                                            CGL029
     C                   EVAL      C_ACS1 = W_ACS1                                            CGL029
     C                   EVAL      C_BRC1 = W_BRC1                                            CGL029
     C     C_ATYP        WHENEQ    'P'                                                       BUG3821
     C*******************EVAL      C_CNU1 = W_CNU1                                    BUG3821 240008
     C*******************EVAL      C_ACO1 = W_ACO1                                    BUG3821 240008
     C*******************EVAL      C_ACS1 = W_ACS1                                    BUG3821 240008
     C                   EVAL      C_CNUM = P#CNUM                                            240008
     C                   EVAL      C_ACSQ = P#ACSQ                                            240008
     C                   EVAL      C_BRCA = P#BRCA                                            240008
     C                   EVAL      C_ACOD = P#ACOD                                            240008
     C     C_ATYP        WHENEQ    'I'                                                        237564
     C                   EVAL      C_CNU1 = WICNUM                                            237564
     C                   EVAL      C_CCY1 = WICCY                                             237564
     C                   EVAL      C_ACO1 = WIACOD                                            237564
     C                   EVAL      C_ACS1 = WIACSQ                                            237564
     C                   EVAL      C_BRC1 = WIBRCA                                            237564
     C                   ENDSL                                                               BUG3821
      *
     C*******************EVAL      C_ACOD = W_ACOD                                    BUG3854 240008
     C*******************EVAL      C_ACSQ = W_ACSQ                                    BUG3854 240008
      *                                                                                       240008
     C     C_ATYP        IFEQ      'R'                                                        240008
     C                   MOVEL     C_ACCT        C_ACNO                                       240008
     C                   END                                                                  240008
                                                                                              CGL029
     C                   ENDSR                                                                CGL029
     C/COPY WNCPYSRC,FTH00414
                                                                                              CGL029
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                                                       CSD015
**  CPY@
(c) Finastra International Limited 2001
** WLARR - Watch List Fields                                                                  CSD015
<Sender>                                                                                      CSD015
</Sender>                                                                                     CSD015
<Receiver Corr - FT>                                                                          CSD015
</Receiver Corr - FT>                                                                         CSD015
<A/C with Bank>                                                                               CSD015
</A/C with Bank>                                                                      CSD015 BUG4556
<Beneficiary>                                                                                 CSD015
</Beneficiary>                                                                                CSD015
<Ordering Bank>                                                                               CSD015
</Ordering Bank>                                                                              CSD015
<Sender Corr>                                                                                 CSD015
</Sender Corr>                                                                                CSD015
<Ordering Cust>                                                                               CSD015
</Ordering Cust>                                                                              CSD015
<Details of Payment>                                                                          CSD015
</Details of Payment>                                                                         CSD015
<Intermediary Bank>                                                                           CSD015
</Intermediary Bank>                                                                          CSD015
<Receivers Corr>                                                                              CSD015
</Receivers Corr>                                                                             CSD015
<A/C with Bank>                                                                               CSD015
</A/C with Bank>                                                                              CSD015
<Third Reimbur Inst>                                                                          CSD015
</Third Reimbur Inst>                                                                         CSD015
<Ordering Customer Cover>                                                                     CSW209
</Ordering Customer Cover>                                                                    CSW209
<Ordering Bank Cover>                                                                         CSW209
</Ordering Bank Cover>                                                                        CSW209
<Intermediary Bank Cover>                                                                     CSW209
</Intermediary Bank Cover>                                                                    CSW209
<Account with Bank Cover>                                                                     CSW209
</Account with Bank Cover>                                                                    CSW209
<Beneficiary Cover>                                                                           CSW209
</Beneficiary Cover>                                                                          CSW209
<Details of Payment Cover>                                                                    CSW209
</Details of Payment Cover>                                                                   CSW209
**  POWERS                                                                                    CAP211
0000001                                                                                       CAP211
0000010                                                                                       CAP211
0000100                                                                                       CAP211
0001000                                                                                       CAP211
0010000                                                                                       CAP211
0100000                                                                                       CAP211
1000000                                                                                       CAP211
**  @DFT                                                                                      CAP211
**** FUNDS FROM ****                                                                          CAP211
