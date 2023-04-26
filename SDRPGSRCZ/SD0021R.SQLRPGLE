     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*XBIF***OVRDBF*FILE(GPICURL0)*TOFILE(GPICURRL0)***********************               CGP001 BUG5452
/*XBI *  OVRDBF FILE(GPCURL0) TOFILE(GPCURRL0)                        *                      BUG5452
/**** *  RPGBASE                                                      *                     MD058085
/*STD *  RPGSQLBND                                                    *                     MD058085
/*EXI *  TEXT('Midas SD Currency codes maintenance')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0021R - Currency codes maintenance.                        *
      *                                                               *
      *  Function:  This program maintains currency code record.      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD061301           Date 19Apr23               *
      *  Prev Amend No. EML110             Date 20Jan20               *
      *                 MD058085           Date 11May21               *
      *                 MD048483           Date 08Dec17               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL165             Date 23Feb15               *
      *                 MD030956           Date 09Oct14               *
      *                 CTI006             Date 31Mar14               *
      *                 MD025467           Date 12May14               *
      *                 AR982306           Date 06Mar14               *
      *                 MD021493           Date 03Aug13               *
      *                 AR1094963          Date 12Mar13               *
      *                 CMG003             Date 04Oct12               *
      *                 AR849515           Date 19Nov12               *
      *                 CSW212             Date 03May12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG22864           Date 12Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG14620           Date 21Aug07               *
      *                 243480A            Date 18Jan07               *
      *                 243480             Date 06Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CRE026             Date 24May06               *
      *                 BUG11870           Date 10Apr06               *
      *                 BUG11875           Date 11Aug06               *
      *                 237333             Date 23Feb06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG8112            Date 05Aug05               *
      *                 CER001             Date 25Apr05               *
      *                 BUG5452            Date 24Feb05               *
      *                 BUG2853 *Reopen    Date 17Jul04               *
      *                 BUG2853            Date 10Jun04               *
      *                 BUG2811            Date 01Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL014             Date 20Oct03               *
      *                 BUG2544            Date 11May04               *
      *                 BG1683             Date 30Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001             Date 23May03               *
      *                 CSD012             Date 15Oct02               *
      *                 217479             Date 19Nov02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204923             Date 29Apr02               *
      *                 199575             Date 15Jan02               *
      *                 201500             Date 14Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CPK014             Date 04Oct01               *
      *                 CIR007             Date 11May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP059             Date 18May01               *
      *                 CAP058             Date 18May01               *
      *                 CAP057             Date 18May01               *
      *                 CSD006             Date 12Sep00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 179231             Date 15Jun00               *
      *                 179232             Date 25May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 27Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSW097             Date 20May99               *   CSW097
      *                 CSD005             Date 01MAR99               *
      *                 152522             DATE 01FEB99               *
      *                 CTI002             DATE 23SEP98               *
      *                 133812             DATE 20APR98               *
      *                 CEU002             DATE 29OCT97               *
      *                 CSD003             Date 27OCT97               *
      *                 122096             DATE 22AUG97               *
      *                 CRT003             DATE 25FEB97               *
      *                 CSW005             DATE 05DEC96               *
      *                 CAC001             Date 23JAN96               *
      *                 080076             Date 28APR95               *
      *                 CRT001             Date 09MAR95               *
      *                 S01502             DATE 28JUL94               *
      *                 S01505             DATE 22JUL94               *
      *                 S01486             DATE 01JUL94               *
      *                 S01459             DATE 01JUL94               *
      *                 S01433             DATE 15OCT93               *
      *                 S01391             DATE 23SEP92               *
      *                 S01319             DATE 07NOV91               *
      *                 E29569             DATE 15OCT91               *
      *                 E24686             DATE 07OCT91               *
      *                 E24310             DATE 12SEP91               *
      *                 S01319             DATE 02AUG91               *
      *                 S01310             DATE 30MAY91               *
      *                 LN0947             DATE 23JAN91               *
      *                 LN0662             DATE 23JAN91               *
      *                 LN1072             DATE 10DEC90               *
      *                 E21210             DATE 07DEC90               *
      *                 E21685             DATE 07DEC90               *
      *                 LN0333             DATE 07JUN90               *
      *                 S01117             DATE 06APR90               *
      *                 E20222             DATE 19DEC89               *
      *                 E18931             DATE 31NOV89               *
      *                 E18904             DATE 31NOV89               *
      *                 E19697             DATE 28NOV89               *
      *                 E19254             DATE 26NOV89               *
      *                 E18191             DATE 10FEB90               *
      *                 E18248             DATE 10FEB90               *
      *                 E17751             DATE 10FEB90               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD061301 - Recompile due to change of type on EML110 copy    *
      *             sources from RPG to RPGLE.                        *
      *  EML110 - ACCOUNT BALANCE POOLING. UPGRADE TO FBM 2.1         *
      *           Amend hooks WN0481CCP1, SD0021RC01, SD0021RC02      *
      *           Add new hook EML110_004, EML110_005, EML110_006,    *
      *           EML110_007 and EML110_008.                          *
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  MD048483 - Fix duplicate write error on RECCYDXC file.       *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  MD030956 - Additional changes to BFM-TI enhancement          *
      *  CTI006 - Trade Finance BF Midas 2.2 Interface                *
      *  MD025467 - API locking issues Redesign Approach              *
      *  AR982306 - Upon insertion of new currency, record should also*
      *             be inserted in the extension file PF/SDCURRQD.    *
      *             (Child: AR982307) (Applied for: MD025331)         *
      *  MD021493 - The date entered is invalid in effective date     *
      *             field in currency maintenance.                    *
      *  AR1094963 - MT600 clashes to BF2.1                           *
      *  CMG003 - SWIFT MT600 Message Generation                      *
      *  AR849515 - Timestamp Error when doing Spot Rate Maintenance. *
      *             Initialized to zero. (Child: AR928796)            *
      *  CSW212 - SWIFT 2012 Changes                                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22864 - Missing validation specific to base currency,     *
      *             for Exchange Rate Tolerance allowed               *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  BUG14620 - Migration program does not work.                  *
      *  243480A - Check whether CCY exists in SDHOLPD, SDBSRTPD,     *
      *            ACCNTAB, FDINTRPP and DLMMDFPP before allowing     *
      *            CCY deletion.                                      *
      *  243480 - Do not issue error message GPM0013 during DELETION. *
      *           Issue a warning message instead.                    *
      *  CRE026 - Consumer Banking                                    *
      *  BUG11870 - Effective date > run date upon accept             *
      *  BUG11875 - Record reflected in zonal listview upon accept of *
      *             deletion in Acceptance screen                     *
      *  237333 - OIS Settlement Days and OIS Int. Rate Dec. places   *
      *           are displayed on screen even though CIR007 is not   *
      *           installed.  Moved the setting on and off of *IN81.  *
      *           Applied fix 233876.                                 *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *  BUG8112- Update hash totals of RECCYZ when a new record has  *
      *           added to RECCYD or when there is an existing record *
      *           found with a RECI='*'.                              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  BUG5452 - GPCURRPD should be used instead of GPICURRPD.      *
      *  BUG2853 - (Reopen) Do not suppress leading zeroes of Numeric *
      *            ISO Currency field.                                *
      *  BUG2853 - Amend program such that display of Numeric ISO     *
      *            Currency field is based on Cashier Interface OR    *
      *            Midas TI Interface.                                *
      *  BUG2811- Spot rate and its corresponding multiply/divide     *
      *           indicator should be protected when amend mode.      *
      *  CLE025 - Credit Lines                                        *
      *  CGL014 - Collateral Processing                               *
      *  BUG2544 - Problem with write to Shadow File.  Need to set    *
      *            correct currency code before write to SDCUSHL0.    *
      *  BG1683 - ZFIELD not initialised to blanks                    *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Global Processing                                   *
      *  CSD012 - Standing Data Authorisation.                        *
      *  217479 - Spot Trade A/C validation should not count finding  *
      *           the trade account on a currency if the currency on  *
      *           file is the one just being inserted/amended.        *
      *  204923 - Rate Fix Days Adjustment (OIS) - (Recompile)        *
      *  199575 - The 'Swift Number of Decimal Places' and 'Effective *
      *           Date for Decimal Places' fields of the new currency *
      *           being added is defaulted to the field values of the *
      *           base limit currency.  Initialized both fields to    *
      *           zero to fix this problem.                           *
      *  201500 - Update hash totals of RECCYZ when a new record has  *
      *           been added to RECCYD.                               *
      *  CPK014 - Release 4 packaging.  Rename of field which is too  *
      *           long for OPM program.                               *
      *  CIR007 - Overnight Index Swaps                               *
      *  CAP059 - Conversion of Forward Rates into Modular APIs       *
      *  CAP058 - Conversion of MM Interest Rates into Modular APIs   *
      *  CAP057 - Conversion of SPOT Rates into Modular APIs          *
      *  CSD006 - Market data feed.                                   *
      *  CDL008 - Continuous Linked Settlement                        *
      *  179231 - 'Spot Trade Account Equivalent' code must be        *
      *           unique.                                             *
      *  179232 - When new currencies are entered, add a new record   *
      *           to the Retail ICD file RECCYD.                      *
      *  CPB001 - 'Private Banking' Module                            *
      *  CSW097 - SWIFT97 changes for MT34* and MT36*                 *   CSW097
      *           ISDA Financial Centre replaced by new field,        *   CSW097
      *           Default Location Code.                              *   CSW097
      *  CSD005 - Standing Data Account Narrative.  Add new field     *
      *           to SDACODPD.  Recompilation of programs.            *
      *  152522 - Fields OUT/EUR Exchange Rate + M/D indicator added  *
      *           to SDCURRPD (used in Spot Rates Maintenance for     *
      *           OUT currencies with an IN base currency).           *
      *  CTI002 - Recompiled : File SDACODPD changed                  *
      *  133812 - New currencies added should default as 'Out' of EMU.*
      *  CEU002 - Additional Currency Details For EMU                 *
      *  CSD003 - Synon Closedown Project (SD):                       *
      *           - Program removed from SD model.                    *
      *  122096 - Addition of call to SD0520X to save deleted         *
      *           records for audit during COB.                       *
      *  CRT003 - Cashier Interface:                                  *
      *           Condition call to SD0027R (Currency Codes Mnt(RTS)) *
      *           to occur when CRT001 or CRT002 or CRT003 are 'on'.  *
      *           Change validation on Numeric ISO Currency to make   *
      *           field non-mandatory & to appear only when CRT003    *
      *           is 'on'.                                            *
      *  CSW005 - FRA/IRS MT34*, MT36* Message Generation:            *
      *           Regenerated/Recompiled over changed SDCURRPD.       *
      *  CAC001 - Profit Centre Accounting                            *
      *           S01505 changes removed.                             *
      *  080076 - Currency Ranking Sequence should be unique.         *
      *  CRT001 - Retail Teller System development:                   *
      *           Addition of 'Numeric ISO Currency' to the screen.   *
      *  S01502 - Telekurs Interface Development:                     *
      *           Regenerated/compiled over changed SDCURRPD.         *
      *  S01505 - Profit Centre Accounting Development: Addition of   *
      *           - Default Direct Funding Profit Centre.             *
      *           - Default FX Position Profit Centre.                *
      *  S01486 - Private Banking:                                    *
      *           Addition of 'Currency Ranking Sequence'.            *
      *           Replace 'Get Dealing Inds for CCY' by 'Get all      *
      *           Midas Modules'.                                     *
      *  S01459 - Addition of headerbox and PSSR processing.          *
      *  S01433 - ADD 'PRECIOUS METAL INDICATOR' FIELD TO SCREEN.     *
      *  S01391 - ADD 'ROUND DOWN INTEREST' FIELD ON SCREEN           *
      *           FOR JAPANESE SUB-MODULE.                            *
      *  S01319 - RATIONALISE DRS/MIDAS INTERFACE -                   *
      *           REMOVE CALL TO SD0022U                              *
      *           REMOVE CHECKS FOR DEALING MM (=DEALING FX)          *
      *           REPLACE REFERENCES TO DRS WITH DL                   *
      *  E29569 - CLEAR OUT THE CODE FOR A TEMPORARY FIX FROM /COPY   *
      *           MEMBERS SD0021RCPG, SD0021RDAU, SD0021RFPG.         *
      *           RECOMPILE THIS PROGRAM OVER EMPTY /COPY MEMBERS.    *
      *  E24686 - DO NOT ALLOW CHANGE OF DEALING CURRENCY INDICATOR   *
      *           FROM Y TO N IF EXCHANGE OR INTEREST RATES EXIST.    *
      *           IGNORE DELETED INTEREST RATES RECORDS.              *
      *  E24310 - VALIDATE CURRENCY CODE TO BE ALPHABETIC ONLY        *
      *  S01319 - RATIONALISE DRS/MIDAS INTERFACE -                   *
      *           REGENERATE FOR CHANGES TO SDDEALPD                  *
      *  S01310 - SWIFT RATIONALISATION                               *
      *  LN0947 - REGENERATE DUE TO CHANGE IN SDACODPD                *
      *  LN0662 - REGENERATE DUE TO CHANGE IN SDCURRPD                *
      *  LN1072 - DISPLAY RM CASHFLOW MAGNITUDE                       *
      *  E21210 - CORRECT EXCHANGE RATE (LN1018)                      *
      *  E21685 - EXTRA CHECK FOR DELETION (LN1018)                   *
      *  LN0333 - Ensure that RECI=D on the currency file.            *
      *  S01117 - Release 10 Changes                                  *
      *  E20222 - Additional validation                               *
      *  E18931 - MM Spot Date not maintained correctly               *
      *  E18904 - Fwd and Spot Trade Account Equiv. only mandatory    *
      *           for a non-base currency                             *
      *  E19697 - Currency not allowed with more than 5 decimals      *
      *  E19254 - Background file not updated correctly               *
      *  E18191 -                                                     *
      *  E18248 -                                                     *
      *  E17751 -                                                     *
      *                                                               *
      *****************************************************************
     FFDCCYLLL  IF   E           K DISK                                         E21685
     F************FDINTRLLIF  E           K        DISK             E21685E24686
     FFDINTDLL  IF   E           K DISK                                         E24686
      * Move key fields to FDCCYPP0                                       E21685
     F*
     F/COPY WNCPYSRC,SD0021RFPG
     F*
     FSD0021R#  CF   E             WORKSTN USROPN
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD Currency codes maintenance
      *
     FSDCURRL1  IF   E           K DISK    USROPN
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Currency codes retrieval
      *
     FSDACODL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0001)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Account codes retrieval
      *
     FSDMMODL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0002)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Midas module flags retrieval
      *
     FSDBANKL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0003)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Bank details ICD retrieval
      *
     FSDDEALL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0004)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Dealing ICD data retrieval
      *
     FSDCURRL0  UF A E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFDS(ID0005)
     F                                     INFSR(*PSSR)
      * UPD : Midas SD Currency codes update
      *
     F***SDFCTLL0UF  E           K        DISK                           UC                 MD025467
     FSDFCTLL0  IF   E           K DISK    USROPN                                                 MD
     F                                     COMMIT
     F                                     INFDS(ID0006)
     F                                     INFSR(*PSSR)
     FSDFCTZTD  IF A E             DISK    COMMIT                                                 MD
     F                                     INFDS(ID0009)                                          MD
     F                                     INFSR(*PSSR)                                           MD
      * UPD : Midas SD Standing data controls update
      *
     FRECCY     UF A E           K DISK    USROPN                               179232
     F                                     IGNORE(RECCYAF)                      179232
     F                                     IGNORE(RECCYZF)                      179232
      * UPD : Midas RE Installation control data update                   179232
      *                                                                   179232
     FRECCYDXC  UF A E           K DISK    USROPN                               179232
      * UPD : Midas RE Installation control extension file update         179232
      *                                                                   179232
     FRECCYZ    UF   E           K DISK    USROPN                               179232
      * UPD : Midas RE Installation control data trailer update           179232
      *                                                                   179232
     FSDCURRL7  IF   E           K DISK    USROPN                               179231
     F                                     INFDS(ID0007)                        179231
     F                                     INFSR(*PSSR)                         179231
      * RTV : Midas SD Currency codes by Spot Trade A/C Equiv             179231
      *                                                                                       CSD012
     FSDAULGL0  IF   E           K DISK
      * RTV : Authorisation Log - by Key                                                      CSD012
      *                                                                                       CSD012
     FSDAULGL1  UF A E           K DISK
     F                                     COMMIT
     F                                     RENAME(SDAULGD0:SDAULG1)
      * UPD : Authorisation Log                                                               CSD012
      *                                                                                       CSD012
     FSDCUSHL0  UF A E           K DISK
     F                                     COMMIT
      * UPD : Currency Details Shadow file                                                    CSD012
      *                                                                                       CSD012
      *                                                                                       CGP001
     F***GPICURL0IF  E           K       DISK                           UC            CGP001 BUG5452
     F**********  GPICURRD0                         KRENAMEGPICURD0                   CGP001 BUG5452
     FGPCURL0   IF   E           K DISK    USROPN                                                  B
     F                                     RENAME(GPCURRD0:GPCURD0)                                B
     F                                     INFSR(*PSSR)
      ** RTV : Global ISO Currency Codes by Currency Code                                     CGP001
      *                                                                                       CGP001
     FSDACURL0  UF   E           K DISK    USROPN
     F                                     COMMIT
      *                                                                                       CSD031
     FSDCURRLF  IF   E           K DISK    USROPN
     F                                     INFDS(ID0008)
     F                                     INFSR(*PSSR)
     F                                     RENAME(SDCURRD0:SDCURRD@)
      * RTV : Midas SD Currency codes by ISO Number                                           CRE026
      *                                                                                       CRE026
      ** Extension File                                                                     AR982306
     FSDCURQL0  UF A E           K DISK                                                           AR
     F                                     COMMIT                                                 AR
     FSDHOLL0   IF   E           K DISK                                                            2
      * Holidays File                                                                        243480A
     FSDBSRTL1  IF   E           K DISK                                                            2
      * Base Rate Codes File                                                                 243480A
     FSDACNTL0  IF   E           K DISK                                                            2
      * Accounts File                                                                        243480A
     FDLMMDFL1  IF   E           K DISK                                                            2
      * DL MM Discount Factor                                                                243480A
      *                                                                                       CMG003
     FSDCMDTL1  UF   E           K DISK
      ** Commodity Details file                                                               CMG003
      *                                                                                       CMG003
     FSDCMSHL1  UF A E           K DISK
     F                                     RENAME(SDCMDTD0:SDCMSHD0)
      ** Commodity Details shadow file                                                        CMG003
      *                                                                                       CMG003
     F*SDPMRTPD* IF   E           K DISK                                                    MD058085
      ** Precious Metal Currencies File                                                       CMG003
      *                                                                                       CMG003
     D UALPH           S              1    DIM(26) CTDATA PERRCD(26)
     D UCHK            S              1    DIM(3)
     D* Description     : Copyright notice for inclusion in all programs
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright array
     D*
     D********************************************************************
     D*COPY*ZSRSRC,ZDATE2Z1                                               CDL008            MD058085
     D/COPY ZSRSRC,ZDATE2Z1LE                                                               MD058085
     D*COPY*ZSRSRC,ZALIGNZ1                                               CDL008            MD058085
     D/COPY ZSRSRC,ZALIGNZ1LE                                                               MD058085
     D*
     D OVRC            S             80    DIM(1) CTDATA PERRCD(1)
      *                                                                                       CGP001
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure                                   CGP001
      *                                                                                       CGP001
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** Switchable Feature Details                                                           CGP001
      *                                                                                       CGP001
     D GPWEIG        E DS                  EXTNAME(GPWEIGPD)
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D SDPMRT        E DS                  EXTNAME(SDPMRJW0)                                MD058085
     D*****/COPY QWINDSRC,CYE1DTA                                         S01229
     D*COPY*QWINDSRC,SD0020GDTA                                           S01229            MD058085
     D/COPY QWINDSRC,SD0020GDTL                                                             MD058085
     D*
     D/COPY WNCPYSRC,SD0021RIPG
     D*
      /EJECT
      * Data structures:
      *                                                                                       CSD012
     D LDA           E DS           256    EXTNAME(LDA)
     D  SPAREX       E                     EXTFLD(SPARE)
      ** Local data area for database error details                                           CSD012
      *                                                                                       CSD012
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      7  0
     D  ##JCC                  1      1  0
     D  ##JYY                  2      3  0
     D  ##JMM                  4      5  0
     D  ##JDD                  6      7  0
     D  ##JTM                  8     13  0
     D  ##JHH                  8      9  0
     D  ##JNN                 10     11  0
     D  ##JSS                 12     13  0
      * ABO DEFINE LARGE STRING FOR CL CMD
     D YARTCM          DS           512
     D  DUMMY1                 1      1
      *                                                                   179232
     D RECKEY          DS            12                                         179232
      * Key field for call to RECCY                                       179232
     D  W#CYCD                 9     11                                         179232
     D  W#FILL                12     12                                         179232
      *                                                                   179232
     D DNATN           DS             5                                         179232
      * Data structure to update Last Transaction No. data area           179232
     D  FNATN                  1      5  0                                      179232
      *                                                                   179232
     D DNR             DS            15
      * Data structure for array totals in RECCYZ                                             201500
     D  NR                     1     15
     D  NR1                    1      3P 0
     D  NR2                    4      6P 0
     D  NR3                    7      9P 0
     D  NR4                   10     12P 0
     D  NR5                   13     15P 0
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D @1DBRC        E DS                  EXTNAME(SDCURRL0)
     D @1COMM        E DS                  EXTNAME(SDCMDTPD)
      * UPD : Midas SD Currency codes update
      * Current/previous master file format fields for change control
      *
     D**#1DBRC******DS                            344                     CEU002
     D**#1DBRC******DS                            359               CEU002152522
     D**#1DBRC******DS                            367               152522CSW097
     D**#1DBRC******DS                            370               CSW097CPB001
     D***#1DBRC      DS                            391             CPB001 CDL008
     D**#1DBRC******DS                            395              CDL008 CSD006
     D #1DBRC          DS          9999                                         CSD006
      * Stored master file format fields
     D  #1DB1                  1      1
     D #2DBRC          DS          9999
      * Stored shadow file format fields                                                      CSD012
     D @ADBRC          DS          9999
     D #1COMM          DS           115
     D #2COMM          DS           115
      *
     D**YARDCS******DS                            344                     CEU002
     D**YBRDCS******DS                            344                     CEU002
     D**YCRDCS******DS                            344                     CEU002
     D**YARDCS******DS                            359               CEU002152522
     D**YBRDCS******DS                            359               CEU002152522
     D**YCRDCS******DS                            359               CEU002152522
     D**YARDCS******DS                            367               152522CSW097
     D**YBRDCS******DS                            367               152522CSW097
     D**YCRDCS******DS                            367               152522CSW097
     D**YARDCS******DS                            370               CSW097CPB001
     D**YBRDCS******DS                            370               CSW097CPB001
     D**YCRDCS******DS                            370               CSW097CPB001
     D***YARDCS      DS                            391             CPB001 CDL008
     D***YBRDCS      DS                            391             CPB001 CDL008
     D***YCRDCS      DS                            391             CPB001 CDL008
     D***YARDCS      DS                            395             CDL008 CSD006
     D***YBRDCS      DS                            395             CDL008 CSD006
     D***YCRDCS      DS                            395             CDL008 CSD006
     D YARDCS          DS          9999                                         CSD006
     D YBRDCS          DS          9999                                         CSD006
     D YCRDCS          DS          9999                                         CSD006
     D QSDFC1        E DS                  EXTNAME(SDFCTLL0)
      * UPD : Midas SD Standing data controls update
     D YDRDCS          DS            22
     D**YERDCS******DS                            344                     CEU002
     D**YERDCS******DS                            359               CEU002152522
     D**YERDCS******DS                            367               152522CSW097
     D**YERDCS******DS                            370               CSW097CPB001
     D***YERDCS      DS                            391             CPB001 CDL008
     D**YERDCS******DS                            395              CDL008 CSD006
     D YERDCS          DS          9999                                         CSD006
      * Outward parameters
     D PARC            DS             3
      * KEY : Midas SD Currency codes retrieval
      * I : MAP Currency Code
     D  PACYCD                 1      3
      *
      * Outward parameters
     D PBRC            DS             3
      * KEY : Midas SD Currency codes retrieval
      * I : MAP Currency Code
     D  PBCYCD                 1      3
      *
      * Outward parameters
     D PCRC            DS             3
      * KEY : Midas SD Currency codes retrieval
      * I : MAP Currency Code
     D  PCCYCD                 1      3
      *
      * Outward parameters
     D PDRC            DS             3
      * KEY : Midas SD Currency codes retrieval
      * I : MAP Currency Code
     D  PDCYCD                 1      3
      *
      * Outward parameters
     D PERC            DS             3
      * KEY : Midas SD Currency codes retrieval
      * I : MAP Currency Code
     D  PECYCD                 1      3
      *                                                                                       CMG003
     D PGRC            DS             6
     D  PGCYCD                 1      3
     D  PGANCD                 4      4
     D PHRC            DS            10
     D  PHCYCD                 1      3
     D  PHDASH                 4      4
     D  PHSWCY                 5      7
     D WOCURR          DS            12
     D  WOCYCD                 1      3
     D  WOSWCY                 4      6
     D  WNCYCD                 7      9
     D  WNSWCY                10     12
      *
     D YFRDCS          DS            22
     D YGRDCS          DS            22
     D WUDELR          DS
     D  WUDR01                 1    250
     D  WUDR02               251    500
     D  WUDR03               501    750
     D  WUDR04               751   1000
     D  WUDR05              1001   1250
     D  WUDR06              1251   1500
     D  WUDR07              1501   1750
     D  WUDR08              1751   2000
     D  WUDR09              2001   2250
     D  WUDR00              2251   2500
     D  WUDR11              2501   2750
     D  WUDR12              2751   3000
      * Outward parameters
     D PFRC            DS          3064
      * RCD : Midas SD Deleted records file retrieval
      * I :  File name
     D  PFFNME                 1     10
      * I :  Long Key
     D  PFLKEY                11     60
      * I :  Deleted Data Record Pt1
     D  PFDR01                61    310
      * I :  Deleted Data Record Pt2
     D  PFDR02               311    560
      * I :  Deleted Data Record Pt3
     D  PFDR03               561    810
      * I :  Deleted Data Record Pt4
     D  PFDR04               811   1060
      * I :  Deleted Data Record Pt5
     D  PFDR05              1061   1310
      * I :  Deleted Data Record Pt6
     D  PFDR06              1311   1560
      * I :  Deleted Data Record Pt7
     D  PFDR07              1561   1810
      * I :  Deleted Data Record Pt8
     D  PFDR08              1811   2060
      * I :  Deleted Data Record Pt9
     D  PFDR09              2061   2310
      * I :  Deleted Data Record Pt10
     D  PFDR00              2311   2560
      * I :  Deleted Data Record Pt11
     D  PFDR11              2561   2810
      * I :  Deleted Data Record Pt12
     D  PFDR12              2811   3060
      * I :  Last Change Date
     D  PFLCD               3061   3063P 0
      * I :  Type of Last Change
     D  PFTYLC              3064   3064
      *
     D YHRDCS          DS            22
     D YIRDCS          DS           344
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
     D ID0001          DS           528
      * File information data structure
      *
     D ID0002          DS           528
      * File information data structure
      *
     D ID0003          DS           528
      * File information data structure
      *
     D ID0004          DS           528
      * File information data structure
      *
     D ID0005          DS           528
      * File information data structure
      *
     D ID0006          DS           528
      * File information data structure
      *
     D ID0007          DS           528                                         179231
      * File information data structure                                   179231
      *                                                                   179231
     D ID0008          DS           528
      * File information data structure                                                       CRE026
      *                                                                                       CRE026
     D ID0009          DS           528                                                           MD
      * File information data structure                                                     MD025467
      *                                                                                     MD025467
      /EJECT
      * Parameter declarations
     D P1PARM          DS             3
      * KEY: Midas SD Currency codes retrieval
      * I : MAP Currency Code
     D  P1CYCD                 1      3
     D P2PARM          DS
      * I :  Action Code
     D  P2ANCD                 1      1
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Curr Code not alphabetic'
      * Currency Code
     D  ZA0001                 1      3
      * Message data for 'Currency Name required'
      * Currency Name
     D  ZA0002                 1     14
      * Message data for 'No of dec places invalid'
      * No. of Dec. Places alpha
     D  ZA0003                 1      1
      * Message data for 'No of dec places invalid'
      * No. of Dec. Places alpha
     D  ZA0004                 1      1
      * Message data for 'No of dec places invalid'
      * No. of Dec. Places alpha
     D  ZA0005                 1      1
      * Message data for 'SWIFT currency code inval'
      * Swift Currency Code
     D  ZA0006                 1      3
      * Message data for 'SWIFT currency code inval'
      * Swift Currency Code
     D  ZA0007                 1      3
      * Message data for 'Dealing ccy ind. Invalid'
      * Dealing Currency Ind.
     D  ZA0008                 1      1
      * Message data for 'Dealing Curr has X rates'
      * Dealing Currency Ind.
     D  ZA0009                 1      1
      * Message data for 'Dealing Curr has Int rate'
      * Dealing Currency Ind.
     D  ZA0010                 1      1
      * Message data for 'Dealing Curr has X rates'
      * Dealing Currency Ind.
     D  ZA0011                 1      1
      * Message data for 'Dealing Curr has Int rate'
      * Dealing Currency Ind.
     D  ZA0012                 1      1
      * Message data for 'Telex Notice Days Invalid'
      * Telex Notice Days alpha
     D  ZA0013                 1      1
      * Message data for 'Telex Notice Days Invalid'
      * Telex Notice Days alpha
     D  ZA0014                 1      1
      * Message data for 'Field Not Numeric'
      * alpha of last change
     D  ZA0015                 1      6
      * Message data for 'Sort Sequence No. blank'
      * Sort Sequence alpha
     D  ZA0016                 1      2
      * Message data for 'Rate is of wrong form'
      * Spot Rate alpha
     D  ZA0017                 1     14
      * Message data for 'Spot Rate Zero Divide'
      * Spot Rate alpha
     D  ZA0018                 1     14
      * Multiply/Divide Indicator
     D  ZA0019                15     15
      * Message data for 'Spot Rate not within +-10'
      * Spot Rate alpha
     D  ZA0020                 1     14
      * Message data for 'Spot Rate mustnt be blank'
      * Spot Rate alpha
     D  ZA0021                 1     14
      * Message data for 'Sp Rate Mul/Div ind blank'
      * Multiply/Divide Indicator
     D  ZA0022                 1      1
      * Message data for 'Numeric iso curr is numbr'
      * Numeric ISO Currency scr
     D  ZA0023                 1      3
      * Message data for 'Numeric ISO Curr 1 - 999'
      * Numeric ISO Currency scr
     D  ZA0024                 1      3
      * Message data for 'Par Rate or Ind In Error'
      * Par Rate alpha
     D  ZA0025                 1     14
      * Multiply/Divide, Par
     D  ZA0026                15     15
      * Message data for 'Rate is of wrong form'
      * Spot Rate alpha
     D  ZA0027                 1     14
      * Message data for 'Par Rate Zero Divide'
      * Par Rate alpha
     D  ZA0028                 1     14
      * Multiply/Divide, Par
     D  ZA0029                15     15
      * Message data for 'Par Rate or Ind In Error'
      * Par Rate alpha
     D  ZA0030                 1     14
      * Multiply/Divide, Par
     D  ZA0031                15     15
      * Message data for 'Indicator invalid (D/M)'
      * Multiply/Divide, Par
     D  ZA0032                 1      1
      * Message data for 'RM cashflow mag. required'
      * RM cashflow magnitude fun
     D  ZA0033                 1      1
      * Message data for 'RM cashflow mag. invalid'
      * RM cashflow magnitude fun
     D  ZA0034                 1      1
      * Message data for 'Field Not Numeric'
      * alpha of last change
     D  ZA0035                 1      6
      * Message data for 'RM cashflow mag. invalid'
      * RM cashflow magnitude fun
     D  ZA0036                 1      1
      * Message data for 'F.T. Rate or Ind in error'
      * FT Rate alpha
     D  ZA0037                 1     14
      * Multiply/Divide, Hist Bkg
     D  ZA0038                15     15
      * Message data for 'Rate is of wrong form'
      * Spot Rate alpha
     D  ZA0039                 1     14
      * Message data for 'FT Rate Zero Divide'
      * FT Rate alpha
     D  ZA0040                 1     14
      * Multiply/Divide, Hist Bkg
     D  ZA0041                15     15
      * Message data for 'F.T. Rate or Ind in error'
      * FT Rate alpha
     D  ZA0042                 1     14
      * Multiply/Divide, Hist Bkg
     D  ZA0043                15     15
      * Message data for 'Indicator invalid (D/M)'
      * Multiply/Divide, Par
     D  ZA0044                 1      1
      * Message data for 'Spot Trade A/C equiv Mand'
      * Spot Trade Account Equiv.
     D**********                              1   4 ZA0045                                    CGL029
     D  ZA0045                 1     10
      * Message data for 'Account Code not found'
      * Account Code
     D**********                              1   4 ZA0046                                    CGL029
     D  ZA0046                 1     10
      * Message data for 'Spot Trade A/C equiv Mand'
      * Spot Trade Account Equiv.
     D**********                              1   4 ZA0047                                    CGL029
     D  ZA0047                 1     10
      * Message data for 'Fwd Trade A/C equiv mand.'
      * Fwd Trade Account Equiv.
     D**********                              1   4 ZA0048                                    CGL029
     D  ZA0048                 1     10
      * Message data for 'Account Code not found'
      * Account Code
     D**********                              1   4 ZA0049                                    CGL029
     D  ZA0049                 1     10
      * Message data for 'Fwd Trade A/C equiv mand.'
      * Fwd Trade Account Equiv.
     D**********                              1   4 ZA0050                                    CGL029
     D  ZA0050                 1     10
      * Message data for 'Swap Trade A/C Equiv Mand'
      * Swap Trade Account Equiv.
     D**********                              1   4 ZA0051                                    CGL029
     D  ZA0051                 1     10
      * Message data for 'Account Code not found'
      * Account Code
     D**********                              1   4 ZA0052                                    CGL029
     D  ZA0052                 1     10
      * Message data for 'Swap Trade A/C Equiv Mand'
      * Swap Trade Account Equiv.
     D**********                              1   4 ZA0053                                    CGL029
     D  ZA0053                 1     10
      * Message data for 'Account Code not found'
      * Account Code
     D**********                              1   4 ZA0054                                    CGL029
     D  ZA0054                 1     10
      * Message data for 'Title Only Not Allowed 4'
      * Trade Account Code No.4
     D**********                              1   4 ZA0055                                    CGL029
     D  ZA0055                 1     10
      * Message data for 'Account Code not found'
      * Account Code
     D**********                              1   4 ZA0056                                    CGL029
     D  ZA0056                 1     10
      * Message data for 'Title Only Not Allowed 5'
      * Trade Account Code No.5
     D**********                              1   4 ZA0057                                    CGL029
     D  ZA0057                 1     10
      * Message data for 'Inval value - must be Y/N'
      * Originating Branch Used
     D  ZA0058                 1      1
      * Message data for 'Inval value - must be Y/N'
      * Originating Branch Used
     D  ZA0059                 1      1
      * Message data for 'Inval value - must be Y/N'
      * Originating Branch Used
     D  ZA0060                 1      1
      * Message data for 'Statutory Code Invalid'
      * Statutory Returns Code 1a
     D  ZA0061                 1      4
      * Message data for 'Stat Rtn Code 2 Invalid'
      * Statutory Returns Code 1a
     D  ZA0062                 1      4
      * Statutory Returns Code 2a
     D  ZA0063                 5      8
      * Message data for 'Statutory Code Invalid'
      * Statutory Returns Code 1a
     D  ZA0064                 1      4
      * Message data for 'Round down ind invalid'
      * Round Down Interest Ind
     D  ZA0065                 1      1
      * Message data for 'Precious Metal Ind invald'
      * Precious Metal  Ind.
     D  ZA0066                 1      1
      * Message data for 'Currency Ran Seq is reqd'
      * Currency Ranking Seq. scr
     D  ZA0067                 1      3
      * Message data for 'Curr Rank Seq is numeric'
      * Currency Ranking Seq. scr
     D  ZA0068                 1      3
      * Message data for 'Curr Ran seq is unique'
      * Currency Ranking Seq. scr
     D  ZA0069                 1      3
      * Message data for 'Curr Rank Seq 1 - 999'
      * Currency Ranking Seq. scr
     D  ZA0070                 1      3
      * Message data for 'Exchange rate for curr'
      * Currency Code
     D  ZA0071                 1      3
      * Message data for 'Interest Rate for curr'
      * Currency Code
     D  ZA0072                 1      3
      * Message data for 'Exchange rate for curr'
      * Currency Code
     D  ZA0073                 1      3
      * Message data for 'Interest Rate for curr'
      * Currency Code
     D  ZA0074                 1      3
      * Message data for 'Exchange rate for curr'
      * Currency Code
     D  ZA0075                 1      3
      * Message data for 'Interest Rate for curr'
      * Currency Code
     D  ZA0076                 1      3
      * Message data for 'Exchange rate for curr'
      * Currency Code
     D  ZA0077                 1      3
      * Message data for 'Interest Rate for curr'
      * Currency Code
     D  ZA0078                 1      3
      * Message data for 'Database Error (ICD)'
      * Filename
     D  ZA0079                 1     10
      * Message data for 'Database Error (ICD)'
      * Filename
     D  ZA0080                 1     10
      * Message data for 'Spot Rate can't be amended'                     CEU002
      * Spot Rate alpha                                                   CEU002
     D  ZA0081                 1     14                                         CEU002
      * Message data for 'Sp Rate Mul/Div ind. can't be amended'          CEU002
      * Multiply/Divide Indicator                                         CEU002
     D  ZA0082                 1      1                                         CEU002
      * Message data for 'Spot Trade A/C equiv must be unique'            179231
      * Spot Trade Account Equiv.                                         179231
     D  ZA0083                 1      4                                         179231
      * Message data for 'CLS Currency must be Y or N'                    CDL008
      * CLS Currency                                                      CDL008
     D  ZA0084                 1      1                                         CDL008
      * Message data for 'Effective Date must not be entered if           CDL008
      * CLS Currency is not Y'                                            CDL008
      * Effective Date Alpha                                              CDL008
     D  ZA0085                 1      6                                         CDL008
      * Message data for 'Effective Date is invalid'                      CDL008
      * Effective Date Alpha                                              CDL008
     D  ZA0086                 1      6                                         CDL008
      * Message data for 'OIS Settlement Days must be numeric.'                               CIR007
     D  ZA0087                 1      3
      * Message data for 'OIS Int. Rate Dec. Places for Rounding must                         CIR007
      * be numeric.'                                                                          CIR007
     D  ZA0088                 1      1
     D  ZA0089                 1      2
     D  ZA0090                 1      2
      *                                                                                       CSD012
      * Data structure for AOSVALR0 string                                                    CSD012
     D                 DS
     D  SVAL1                  1    200
     D  SVAL11                 1      1
      *                                                                                       CSD012
      * System Value                                                                          CSD012
     D                 DS
     D  SVALK1                 1     20    INZ('AuthReqCurrencyMaint')
      *                                                                                       CSD012
      * Function Description                                                                  CSD012
     D                 DS
     D  FUNCD                  1     21    INZ('CURRENCY DETAILS')
      *                                                                                       CSD012
      ** DATALUX Data Structure                                                               CER001
     D DATALX          DS          1024
     D  #1CYCO                 1      3
     D  #1SPAE                 4     13
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                      BU
      **  Bank details                                                                      BUG11870
      *                                                                                     BUG11870
      *                                                                                       CER043
     D PSYSVL          C                   CONST('ExchRateTolerance')
      ** Override Command Array                                                               CGP001
      *                                                                                       CGP001
     I/COPY WNCPYSRC,SD0021REPG
     I*
      *                                                                                       CPK014
     IFDINTRP0
     I              HWTMESTMP                   HWTMST
     ISDFCTLA0                                                                                    MD
      ** Secondary trailer file                                                             MD025467
     I              AHNORC                      XHNORC                                            MD
     I              AHNOIN                      XHNOIN                                            MD
     I              AHNOAM                      XHNOAM                                            MD
     I              AHNODL                      XHNODL                                            MD
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P1PARM                         KEY: Currency C
     C     P2ANCD        PARM                    WP0001            1            Action Code
     C                   PARM                    PACCPT            1
      *****************************************************************
      * Initialize
     C                   EXSR      ZZINIT
      *
      * Check passed parameters
     C                   EXSR      FACKPM
      * Perform once if all passed, else repeat
     C     W0RPT         DOUEQ     'N'
      * Display and process key screen
     C                   EXSR      BADSKY
     C                   END
      * Terminate program
     C                   EXSR      ZXEXPG
      *****************************************************************
      /EJECT
     CSR   BADSKY        BEGSR
      *================================================================
      * Display and process key screen
      *================================================================
      * Initialize key screen
     C                   EXSR      MDIZ#K
      * Bypass first display of key screen is possible
     C                   MOVEL     'Y'           W0BYP             1
      * Signal start of transaction
     C                   MOVEL     'Y'           W0TRN             1
     C     W0TRN         DOWEQ     'Y'
     C     W0TRN         OREQ      'K'
      * Ensure transaction continues (if reset)
     C                   MOVEL     'Y'           W0TRN             1
      * Conduct screen conversation
     C     W0TRN         DOWEQ     'Y'
      * Is bypass key screen still viable?
     C     W0BYP         IFEQ      'Y'
     C     #1CYCD        IFEQ      *BLANK                                       Currency Code
      * One or more key fields is blank
     C     *IN05         OREQ      '1'
      * HOME: Reset screen fields
     C                   MOVEL     'N'           W0BYP
     C                   END
     C                   END
      * Bypass key screen
     C     W0BYP         IFNE      'Y'
      * Display key screen
     C                   EXSR      BBEXFM
     C                   END
      * Cancel key screen bypass
     C                   MOVEL     'N'           W0BYP
      * Process response to key screen
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * Switch between *ADD/*CHANGE modes
     C   09              CAS                     BCCHMD
      * HOME: Reset screen fields
     C   05              CAS                     BDHMKY
      * Process key screen input
     C                   CAS                     BEPRKY
     C                   END
     C     W0TRN         DOWEQ     'R'
     C                   MOVEL     'Y'           W0TRN
     C                   EXSR      BEPRKY
     C                   END
      *
     C                   END
     C                   END
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBEXFM        BEGSR
      *================================================================
      * Display key screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                   EXSR      GADSAK
      * Update screen time
     C                   TIME                    ##TME
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      BBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         BBIN89            1
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y0SET
     C                   END
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #RCDKEY
      * Test cursor
     C                   EXSR      Y8TST
      * Clear set cursor DDS indicator
     C     WCSRLC        IFEQ      'OFF'
     C                   SETOFF                                       94        *
     C                   END
     C                   MOVE      *BLANK        WCSRLC
      * If help requested, display help text
     C   25              EXSR      ZHHPKY
     C                   END
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1
      * Reset global error indicator
     C                   SETOFF                                           99    *
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y9CLR
     C                   END
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   BCCHMD        BEGSR
      *================================================================
      * Switch between *ADD/*CHANGE modes
      *================================================================
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     'CHG'         W0PMD             3
     C                   ELSE
     C     CSD043        IFEQ      'Y'
     C     P2ANCD        ANDEQ     'X'
     C                   MOVEL     'ACC'         W0PMD
     C                   ELSE
     C                   MOVEL     'ADD'         W0PMD
     C                   ENDIF
     C                   END
      *================================================================
     CSR   BCEXIT        ENDSR
      /EJECT
     CSR   BDHMKY        BEGSR
      *================================================================
      * Process HOME key
      *================================================================
     C                   MOVEL     'N'           W0TRN
      *================================================================
     CSR   BDEXIT        ENDSR
      /EJECT
     CSR   BEPRKY        BEGSR
      *================================================================
      * Process key screen input
      *================================================================
      * Initialise detail screen
     C                   EXSR      MAIZ#1
      * Validate key fields
     C                   EXSR      BFVLKY
      * Initialise error indicator                                                           243480A
     C                   MOVE      *BLANK        @EXIT             1
      *                                                                                      243480A
     C     *IN99         CABEQ     '1'           BEEXIT
      *                                                                                       CGP001
      ** If CGP001 is on, check if the Currency Code exists in the                            CGP001
      ** Global Layer.                                                                        CGP001
      *                                                                                       CCP001
     C     CGP001        IFEQ      'Y'
     C                   MOVE      #1CYCD        KCYCD             3
     C********** KCYCD     CHAINGPICURL0             90                               CGP001 BUG5452
     C     KCYCD         CHAIN     GPCURL0                            90
      *                                                                                       CGP001
     C     *IN90         IFEQ      *ON
      * Don't send error message if action code is DELETE.                                    243480
     C     P2ANCD        IFNE      'D'
     C                   MOVEL     *BLANK        ZAMSGF
     C**********           MOVEL'GPM0010' ZAMSID                                      CGP001 BUG5452
     C                   MOVEL     'GPM0013'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN99
     C                   MOVE      *ON           *IN31
     C                   MOVE      'Y'           @EXIT
     C**********           GOTO BEEXIT                                                CGP001 243480A
     C                   ELSE
     C                   MOVEL     *BLANK        ZAMSGF
     C**********           MOVEL'GPM0013' ZAMSID                                      243480 243480A
     C                   MOVEL     'GPM0016'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN31
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDIF
      *                                                                                      243480A
      * Check if currency has records in files SDHOLPD, SDBSRTPD                             243480A
      * ACCNTAB and FDINTRPP                                                                 243480A
      *                                                                                      243480A
     C     P2ANCD        IFEQ      'D'
     C     KCYCD         CHAIN     SDHOLL0                            72
     C     *IN72         IFEQ      *OFF
     C                   MOVEL     'GPM0017'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN99
     C                   MOVE      *ON           *IN31
     C                   MOVE      'Y'           @EXIT
     C                   ENDIF
      *                                                                                      243480A
     C     KCYCD         CHAIN     SDBSRTL1                           72
     C     *IN72         IFEQ      *OFF
     C                   MOVEL     'GPM0018'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN99
     C                   MOVE      *ON           *IN31
     C                   MOVE      'Y'           @EXIT
     C                   ENDIF
      *                                                                                      243480A
     C     KCYCD         SETLL     SDACNTL0                               72
     C     *IN72         IFEQ      *ON
     C                   MOVEL     'GPM0019'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN99
     C                   MOVE      *ON           *IN31
     C                   MOVE      'Y'           @EXIT
     C                   ENDIF
      *                                                                                      243480A
     C     KCYCD         CHAIN     FDINTDLL                           72
     C     *IN72         IFEQ      *OFF
     C                   MOVEL     'GPM0020'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN99
     C                   MOVE      *ON           *IN31
     C                   MOVE      'Y'           @EXIT
     C                   ENDIF
      *                                                                                      243480A
     C     KCYCD         SETLL     DLMMDFL1                               72
     C     *IN72         IFEQ      *ON
     C                   MOVEL     'GPM0021'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN99
     C                   MOVE      *ON           *IN31
     C                   MOVE      'Y'           @EXIT
     C                   ENDIF
      *                                                                                      243480A
     C                   ENDIF
      * If an error occurred, go to the end of the subroutine                                243480A
     C     @EXIT         IFEQ      'Y'
     C                   GOTO      BEEXIT
     C                   ENDIF
      *                                                                                       CGP001
      * Check for existing record
     C     KRTV          KLIST
     C                   KFLD                    A6CYCD                         Currency Code
      * Setup key
     C                   MOVEL     #1CYCD        A6CYCD                         Currency Code
      *                                                                                       CSD031
      ** If Acceptance mode, access acceptance file SDACURL0                                  CSD031
      *                                                                                       CSD031
     C     CSD043        IFEQ      'Y'
     C     PACCPT        IFEQ      'A'
     C     KRTV          CHAIN     SDCURRD0                           9091
     C                   ELSE
     C     KRTV          CHAIN     @A6REA3                            9091      *
     C                   ENDIF
     C                   ELSE
     C     KRTV          CHAIN     @A6REA3                            9091      *
     C                   ENDIF
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   SETON                                        9931      *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
      *                                                                                       CMG003
      ** Include ULX043 and CMG003 checking for the last screen                               CMG003
      *                                                                                       CMG003
     C                   MOVEL     'N'           WULUXS
     C                   MOVEL     'N'           WCOMMS
      *                                                                                    AR1094963
     C     ULX043        IFEQ      'Y'
     C     WUNWST        ANDEQ     'Y'
     C                   MOVEL     'L'           WUFNSC
     C                   MOVEL     'Y'           WULUXS
     C                   ELSE
     C     CMG003        IFEQ      'Y'
     C     A6PMRT        ANDEQ     'Y'
     C                   MOVEL     'C'           WUFNSC
     C                   MOVEL     'Y'           WCOMMS
     C                   ENDIF
     C                   ENDIF
      *
      * If record does not exist, flip to add mode
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'ADD'         W0PMD
      * USER: Initialize detail screen (new record)
     C                   MOVEL     'I'           WUACWK                         Action Work
      * CASE: WRK.Set Up Complete is Yes
     C     WUSUC         IFEQ      'Y'                                          *IF
     C                   MOVEL     '*AMEND*'     WUNOAL                         No Amend Allowe
     C                   END                                                    *FI
      * Currency DTL footer - Standard Functions  *
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C* If request delete screen when not last in sequence                S01117
     C     WUACWK        IFEQ      'E'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F8=Further Details   F10=Delete   F12=Previous
     C                   MOVEL     'USR3356'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*                                                                   S01117
     C*                                                                   S01117
     C* If request delete screen that is last in sequence                 S01117
     C     WUACWK        IFEQ      'F'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F10=Delete   F12=Previous
     C                   MOVEL     'USR3350'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*                                                                   S01117
     C*                                                                   S01117
     C* If request is not delete                                          S01117
     C     WUACWK        IFEQ      'I'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F12=Previous
     C                   MOVEL     'USR3346'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
     C                   MOVEL     'Y'           #1DLCI                         Dealing Currenc
     C                   MOVEL     'N'           #1FRIH                         FRI. Holiday
     C                   MOVEL     'N'           #1SATH                         SAT. Holiday
     C                   MOVEL     'N'           #1SUNH                         SUN. Holiday
     C                   MOVEL     'M'           #1MDIN                         Multiply/Divide
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RISN - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RISN
     C*
     C                   END                                                    *FI
     C                   ELSE
      * If record does exist, flip to change mode
     C     CSD043        IFEQ      'Y'
     C     P2ANCD        ANDEQ     'X'
     C                   MOVEL     @1DBRC        @ADBRC
     C                   MOVEL     'ACC'         W0PMD
     C                   ELSE
     C                   MOVEL     'CHG'         W0PMD
      *                                                                                       CSD031
     C                   ENDIF
      * Load screen fields from DBF
     C                   EXSR      MBFL#1
      * CALC: Detail screen function fields
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RSFF - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RSFF
     C*
     C                   END                                                    *FI
      * USER: Initialize detail screen (existing record)
     C                   MOVEL     'I'           WUACWK                         Action Work
      * CASE: WRK.Set Up Complete is Yes
     C     WUSUC         IFEQ      'Y'                                          *IF
     C                   MOVEL     '*NOAMD*'     WUNOAL                         No Amend Allowe
     C                   END                                                    *FI
      * CASE: PAR.Action Code is Delete
     C     P2ANCD        IFEQ      'D'                                          *IF
      * CASE: WRK.Final Screen is is this
     C     WUFNSC        IFEQ      'T'                                          *IF
     C                   MOVEL     'F'           WUACWK                         Action Work
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'E'           WUACWK                         Action Work
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Currency DTL footer - Standard Functions  *
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C* If request delete screen when not last in sequence                S01117
     C     WUACWK        IFEQ      'E'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F8=Further Details   F10=Delete   F12=Previous
     C                   MOVEL     'USR3356'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*                                                                   S01117
     C*                                                                   S01117
     C* If request delete screen that is last in sequence                 S01117
     C     WUACWK        IFEQ      'F'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F10=Delete   F12=Previous
     C                   MOVEL     'USR3350'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*                                                                   S01117
     C*                                                                   S01117
     C* If request is not delete                                          S01117
     C     WUACWK        IFEQ      'I'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F12=Previous
     C                   MOVEL     'USR3346'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
     C                   MOVEL     A6MDIN        #DLRMI                         Limit Rate Mult
     C                   MOVEL     A6SPAE        WUOSTE                         Old Spot Trade
     C                   Z-ADD     A6SPRT        WUOSRT                         Old Spot Rate
     C                   MOVEL     A6MDIN        WUOMDI                         Old Mult/Div In
      * Start of change CRT001
      * Numeric ISO Currency
      * CASE: WRK.Display RTS field is Yes
     C     WUDRTS        IFEQ      'Y'                                          *IF
      * CASE: DB1.Numeric ISO Currency is Zero
     C     A6ISON        IFEQ      *ZERO                                        *IF
     C                   MOVEL     *BLANK        #DNICS                         Numeric ISO Cur
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     A6ISON        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0001            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0002           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0003            1 0          ZALIGN No Of De
     C                   PARM      3             WQ0004            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0005           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      **ZEDIT*Screen*Field*-*Standard*Functions*******************************************   BUG2853
     C**********           CALL 'ZEDIT'                90  ZEDIT Screen Fi                   BUG2853
     C********** WUZASF    PARM WUZASF    WQ0006 16        ZALIGN Screen F                   BUG2853
     C**********           PARM *ZERO     WQ0007  10       ZALIGN No Of De                   BUG2853
      **********                                                                             BUG2853
     C********** *IN90     IFEQ '1'                                                          BUG2853
      **Call*to*program*ended*in*error****************************************************   BUG2853
     C**********           MOVEL'Y2U0032' W0RTN                                              BUG2853
     C**********           MOVEL*BLANKS   W0CLPG 10                                          BUG2853
     C**********           MOVEL'ZEDIT'   W0CLPG                                             BUG2853
      **Send*message*'*Error*occured*on*CALL...'******************************************   BUG2853
     C**********           MOVEL'Y2U0032' ZAMSID                                             BUG2853
     C**********           MOVEL'Y2USRMSG'ZAMSGF                                             BUG2853
     C**********           MOVELW0CLPG    ZAMSDA           Message data                      BUG2853
     C**********           EXSR ZASNMS                                                       BUG2853
     C**********           END                                                               BUG2853
      *
     C                   END                                                    *FI
      * Zalign Numeric ISO curr - Currency Codes  *
     C*
     C                   MOVE      WUZASF        #DNICS
     C*
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of change CRT001
     C                   MOVEL     A6TAC4        WUOTE4                         Old Trade A/C E
     C                   MOVEL     A6TAC5        WUOTE5                         Old Trade A/C E
      * Start of SAR S01117
      * Removed functions to change numeric to char for dec places &
      * No. of Telex Days
      * Move file values to screen fields
     C                   MOVEL     A6NBDP        #DNDPA                         No. of Dec. Pla
     C                   MOVEL     A6TXND        #DTNDA                         Telex Notice Da
      * To move Spot Rate value from file to the screen
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
      * Chg Spot Rt to ZALIGN fld - Currency Codes  *
     C*
     C* Move file value (numeric) for Spot Rate to ZALIGN Screen Fun    of
     C* Field
     C                   MOVE      #1SPRT        WUZASF                                     DayS0122
     C*
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0008           16            ZALIGN Screen F
     C                   PARM      8             WQ0009            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Zedit Spot Rate - Currency Codes  *
     C*
     C* Move ZALIGN function field into Spot Rate on the screen
     C*
     C                   MOVE      WUZASF        #DSPRA
     C*
      * To move Par Rate value from file to the screen
      * CASE: DTL.Multiply/Divide, Par is valid value
     C     #1MDPR        IFEQ      'D'                                          *IF
     C     #1MDPR        OREQ      'M'
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
      * Chg Par Rt to Zalign fld - Currency Codes  *
     C*
     C* Move file value (numeric) for Par Rate to ZALIGN Screen Fun     of
     C* Field
     C                   MOVE      #1PRRT        WUZASF                                     DayS0122
     C*
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0010           16            ZALIGN Screen F
     C                   PARM      8             WQ0011            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Zedit Par Rate - Currency Codes  *
     C*
     C* Move ZALIGN function field into Par Rate on the screen
     C*
     C                   MOVE      WUZASF        #DPRTA
     C*
     C                   END                                                    *FI
      * To move FT Rate value from file to the screen
      * CASE: DTL.Multiply/Divide, Hist Bkg is valid value
     C     #1MDHB        IFEQ      'D'                                          *IF
     C     #1MDHB        OREQ      'M'
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
      * Chg FT Rate to Zalign fld - Currency Codes  *
     C*
     C* Move file value (numeric) for FT Rate to ZALIGN Screen Fun      of
     C* Field
     C                   MOVE      #1HBRT        WUZASF                                     DayS0122
     C*
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0012           16            ZALIGN Screen F
     C                   PARM      8             WQ0013            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Zedit FT Rate - Currency Codes  *
     C*
     C* Move ZALIGN function field into FT Rate on the screen
     C*
     C                   MOVE      WUZASF        #DFTRA
     C*
     C                   END                                                    *FI
      * To move file value of Sort Sequence No. to the screen
      * CASE: DTL.Sort Sequence Number is non zero
     C     #1SSNB        IFNE      *ZERO                                        *IF
     C                   MOVEL     A6SSNB        #DSSQA                         Sort Sequence a
     C                   END                                                    *FI
      * Move file values for Statutory Returns to the screen
      * CASE: DTL.Statutory Returns Code 1 is Entered
     C     #1SRC1        IFNE      *ZERO                                        *IF
     C                   MOVEL     A6SRC1        #DSC1S                         Statutory Retur
     C                   END                                                    *FI
      * CASE: DTL.Statutory Returns Code 2 is Entered
     C     #1SRC2        IFNE      *ZERO                                        *IF
     C                   MOVEL     A6SRC2        #DSC2S                         Statutory Retur
     C                   END                                                    *FI
      * End of SAR S01117
      * Start of S01486
      * Currency Ranking Sequence
      * CASE: DB1.Currency Ranking Sequence is Zero
     C     A6RKSQ        IFEQ      *ZERO                                        *IF
     C                   MOVEL     *BLANK        #DCRSQ                         Currency Rankin
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     A6RKSQ        #DCRSQ                         Currency Rankin
     C                   END                                                    *FI
      * Start of fix 080076
     C                   MOVEL     #DCRSQ        WUCRSQ                         Currency Rankin
      * End of fix 080076
      * End of S01486
      *                                                                   CDL008
      ** If CDL008 is on and it is a Dealing Currency, enable 'CLS        CDL008
      ** Currency' and 'Effective Date'. Otherwise, hide both fields.     CDL008
      *                                                                   CDL008
     C     CDL008        IFEQ      'Y'                                                         CDL00
     C     #1DLCI        ANDEQ     'Y'                                                         CDL00
     C                   MOVE      *OFF          *IN80                                         CDL00
     C     #1EFDT        IFEQ      *ZERO                                                       CDL00
     C                   MOVE      *BLANKS       #DEFDT                                        CDL00
     C                   ELSE                                                                  CDL00
     C                   Z-ADD     #1EFDT        ZDAYNO                                        CDL00
     C                   EXSR      ZDATE2                                                      CDL00
     C                   MOVE      ZDATE         #DEFDT                                        CDL00
     C                   ENDIF                                                                 CDL00
     C                   ELSE                                                                  CDL00
     C                   MOVE      *ON           *IN80                                         CDL00
     C                   ENDIF                                                                 CDL00
      *                                                                   CDL008
      ***If*switcheable*feature*CIR007*is*installed,*enable*OIS*******                 CIR007 237333
      ***Settlement*Days*and*OIS*Int.*Rate*Dec.*Places.*Otherwise,****                 CIR007 237333
      ***hide*both*fields.********************************************                 CIR007 237333
      **********                                                                       CIR007 237333
     C********** CIR007    IFEQ 'Y'                                                    CIR007 237333
     C**********           MOVE *OFF      *IN81                                        CIR007 237333
     C**********           ELSE                                                        CIR007 237333
     C**********           MOVE *ON       *IN81                                        CIR007 237333
     C**********           ENDIF                                                       CIR007 237333
      * Start of fix LN1072
      * set up the RM Cashflow Magnitude field
      * CASE: WRK.Risk Management is Yes
     C     WURKMG        IFEQ      'Y'                                          *IF
      * ZALIGN RMCM to ZASF - Currency Codes  *
     C                   MOVE      *BLANKS       WUZASF
     C                   MOVE      A6RMCM        WUZASF
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0014           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0015            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * MOVE ZASF to RMCF - Currency Codes  *
     C                   MOVE      WUZASF        #DRMCF
     C                   END                                                    *FI
      * End of fix LN1072
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RISE - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RISE
     C*
     C                   END                                                    *FI
      *                                                                                       CER043
     C     CER043        IFEQ      'Y'
     C                   MOVE      *BLANKS       WUZASF
     C                   MOVE      #1RETP        WUZASF
     C                   CALL      'ZEDIT'                              90
     C     WUZASF        PARM      WUZASF        WQ0322           16
     C                   PARM      2             WQ0323            1 0
      *                                                                                       CER043
     C     *IN90         IFEQ      *ON
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG
     C                   MOVEL     'ZEDIT'       W0CLPG
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CER043
     C                   MOVE      WUZASF        #DRETP
      *                                                                                       CER043
     C                   ENDIF
      * start E24686
     C                   EXSR      UASUBR                                       start E24686
     C                   END
      *..................................................
     C   99              GOTO      BEEXIT
      * No error: Display and process details
     C                   EXSR      CADSDA
      *
      *================================================================
     CSR   BEEXIT        ENDSR
      /EJECT
     CSR   BFVLKY        BEGSR
      *================================================================
      * Validate key fields
      *================================================================
     C     W0PMD         IFNE      'ADD'
      * Select existing record
     C                   EXSR      VACKRL
     C                   END
      * USER: Validate key screen
      * Start of SAR S01117
      * start E24310
      * validate each position of currency code for alphabetic
      * check currency code-alpha - Currency Codes  *
     C                   MOVE      *IN70         UIN70             1
     C                   MOVEA     #1CYCD        UCHK
     C     UCHK(1)       LOOKUP    UALPH                                  70
     C   70UCHK(2)       LOOKUP    UALPH                                  70
     C   70UCHK(3)       LOOKUP    UALPH                                  70
     C     *IN70         IFEQ      '1'
     C                   MOVE      'N'           WUERCD
     C                   ELSE
     C                   MOVE      'Y'           WUERCD
     C                   END
     C                   MOVE      UIN70         *IN70
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CYCD        ZA0001                         Currency Code
      * Send message 'Curr Code not alphabetic'
     C                   MOVEL     'USR1095'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   END                                                    *FI
      *                                                                                       CSD012
      * Check if unathorised record exists for this Currency                                  CSD012
      * on the Authorisation Log.                                                             CSD012
     C     CSD012        IFEQ      'Y'
     C     SVAL11        ANDEQ     'Y'
      *                                                                                       CSD012
     C                   MOVEL     #1CYCD        K1CYCD
     C     KAULG         CHAIN     SDAULGL0                           90
      *                                                                                       CSD012
      * If record exists then prevent insert                                                  CSD012
     C     *IN90         IFEQ      *OFF
     C                   MOVEL     'USR9265'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9931
     C                   ENDIF
      *                                                                                       CSD012
     C                   ENDIF
      *                                                                                       CSD012
      * end E23410
      * End of SAR S01117
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
      * standard retrieve object - Currency Codes  *
     C                   EXSR      SARVGN
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
      * Send message '*Record already exists'
     C                   MOVEL     'Y2U0003'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RVKS - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RVKS
     C*
     C                   END                                                    *FI
      * Currency Code required
     C     #1CYCD        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *================================================================
     CSR   BFEXIT        ENDSR
      /EJECT
     CSR   CADSDA        BEGSR
      *================================================================
      * Display and process detail screen
      *================================================================
      * Conduct detail screen conversation
      * - repeat until screen control flag is reset:
     C     W0TRN         DOWEQ     'Y'
      * Display detail screen
     C                   EXSR      CBEXFM
      * Process response to detail screen
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * Redisplay previous screen
     C   12              CAS                     CCDSPV
      * HOME: Reset screen fields
     C   05              CAS                     CCDSPV
      * Process detail screen input
     C                   CAS                     CFPRSC
     C                   END
     C     W0TRN         IFEQ      'R'
     C     W0PMD         IFEQ      'ADD'
     C                   EXSR      MAIZ#1
     C                   END
     C                   END
      *
     C                   END
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   CBEXFM        BEGSR
      *================================================================
      * Display screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                   EXSR      GBDSAD
      * Update screen time
     C                   TIME                    ##TME
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      CBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         CBIN89            1
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y1SET
     C                   END
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT2
     C                   EXFMT     #RCDDTL1
      * Test cursor
     C                   EXSR      Y8TST
      * Clear set cursor DDS indicator
     C     WCSRLC        IFEQ      'OFF'
     C                   SETOFF                                       94        *
     C                   END
     C                   MOVE      *BLANK        WCSRLC
      * If help requested, display help text
     C   25              EXSR      ZHHPKY
     C                   END
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1
      * Reset global error indicator
     C                   SETOFF                                           99    *
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y9CLR
     C                   END
      *================================================================
     CSR   CBEXIT        ENDSR
      /EJECT
     CSR   CCDSPV        BEGSR
      *================================================================
      * Redisplay previous screen
      *================================================================
      * USER: Process key screen request
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
      * Set-up KEY Screen Footer - Standard Functions  *
     C*
     C* KEY LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C* Setup footer text:
     C* F3=Previous
     C                   MOVEL     'USR3345'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C*
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      CCEXIT                                       *QUIT
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RPKR - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RPKR
     C*
     C                   END                                                    *FI
     C   05              MOVEL     'R'           W0TRN
     C   12              MOVEL     'K'           W0TRN
      *================================================================
     CSR   CCEXIT        ENDSR
      /EJECT
     CSR   CFPRSC        BEGSR
      *================================================================
      * Validate record
      *================================================================
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      * If delete is not pending....
      * Validate details
     C  N10              CAS                     DCVLDL
     C                   END
      * QUIT if error:
     C   99              GOTO      CFEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           CFEXIT
      *
      * No error: update record
     C                   EXSR      EBPR##
      *================================================================
     CSR   CFEXIT        ENDSR
      /EJECT
     CSR   DCVLDL        BEGSR
      *================================================================
      * Validate details
      *================================================================
      * Validate Dealing Currency Ind.
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1DLCI        W0NSRQ            1            Dealing Currenc
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1136213       Y2LSNO            7 0
     C     #1DLCI        PARM      #1DLCI        W0EXVL           20            Dealing Currenc
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Multiply/Divide Indicator
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MDIN        W0NSRQ            1            Multiply/Divide
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1110088       Y2LSNO            7 0
     C     #1MDIN        PARM      #1MDIN        W0EXVL           20            Multiply/Divide
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Multiply/Divide, Par
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MDPR        W0NSRQ            1            Multiply/Divide
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100825       Y2LSNO            7 0
     C     #1MDPR        PARM      #1MDPR        W0EXVL           20            Multiply/Divide
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Multiply/Divide, Hist Bkg
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MDHB        W0NSRQ            1            Multiply/Divide
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100825       Y2LSNO            7 0
     C     #1MDHB        PARM      #1MDHB        W0EXVL           20            Multiply/Divide
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate FRI. Holiday
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1FRIH        W0NSRQ            1            FRI. Holiday
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1101018       Y2LSNO            7 0
     C     #1FRIH        PARM      #1FRIH        W0EXVL           20            FRI. Holiday
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate SAT. Holiday
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1SATH        W0NSRQ            1            SAT. Holiday
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1101021       Y2LSNO            7 0
     C     #1SATH        PARM      #1SATH        W0EXVL           20            SAT. Holiday
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate SUN. Holiday
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1SUNH        W0NSRQ            1            SUN. Holiday
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1101024       Y2LSNO            7 0
     C     #1SUNH        PARM      #1SUNH        W0EXVL           20            SUN. Holiday
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Round Down Interest Ind
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1RDFC        W0NSRQ            1            Round Down Inte
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1167189       Y2LSNO            7 0
     C     #1RDFC        PARM      #1RDFC        W0EXVL           20            Round Down Inte
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Precious Metal  Ind.
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1PMRT        W0NSRQ            1            Precious Metal
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1174362       Y2LSNO            7 0
     C     #1PMRT        PARM      #1PMRT        W0EXVL           20            Precious Metal
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * USER: Validate detail screen fields
      * Further records key selected.
      * CASE: DTL.*CMD key is Further Records
     C     *IN08         IFEQ      '1'                                          *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * Delete processing.
      * CASE: PAR.Action Code is Delete
     C     P2ANCD        IFEQ      'D'                                          *IF
      * Send message 'F3/F12/F10/F8 only valid'
     C                   MOVEL     'USR0541'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DCEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: PAR.Action Code is Delete
     C     P2ANCD        IFEQ      'D'                                          *IF
      * Further records key selected.
      * CASE: DTL.*CMD key is Further Records
     C     *IN08         IFEQ      '1'                                          *IF
      * Final screen processing.
      * CASE: WRK.Final Screen is is this
     C     WUFNSC        IFEQ      'T'                                          *IF
      * Send message 'Function key not allowed'
     C                   MOVEL     'USR0533'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DCEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Further records key selected.
      * CASE: DTL.*CMD key is Further Records
     C     *IN08         IFEQ      '1'                                          *IF
      * Send message 'Function key not allowed'
     C                   MOVEL     'USR0533'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DCEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RVSF - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RVSF
     C*
     C                   END                                                    *FI
      * Check relations
      * CALC: Detail screen function fields
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RSFF - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RSFF
     C*
     C                   END                                                    *FI
      * USER: Validate detail screen relations
     C                   MOVEL     'Y'           WUWFG3                         Work Flag 3
      * Validate Currency name
     C                   EXSR      UBSUBR                                       Validate Curren
      * Validate No. of Decimal Places
     C                   EXSR      UCSUBR                                       Validate No. of
      * Validate S.W.I.F.T. currency code
     C                   EXSR      UDSUBR                                       Validate S.W.I.
      * Validate Dealing Currency Indicator
     C                   EXSR      UESUBR                                       Validate Dealin
      * Validate Telex Notice Days
     C                   EXSR      UGSUBR                                       Validate Telex
      * Validate Sort Sequence Number
     C                   EXSR      UHSUBR                                       Validate Sort S
      * Validate Spot Rate
     C                   EXSR      UISUBR                                       Validate Spot R
      * Validate Spot Rate Multiply/Divide Indicator
     C                   EXSR      UJSUBR                                       Validate Spot R
      *                                                                                       CGL014
     C     CGL014        IFEQ      'Y'
     C     WUN4ST        OREQ      'Y'
     C     CLE025        OREQ      'Y'
     C                   EXSR      SRWGCD
     C                   ENDIF
      *                                                                                       CGL014
      * Start of change CRT001
      * Retail Teller System : Numeric ISO Currency
      * CASE: WRK.Display RTS field is Yes
     C     WUDRTS        IFEQ      'Y'                                          *IF
      * Validate Numeric ISO Currency
      * CASE: DTL.Numeric ISO Currency scr is Blank
     C     #DNICS        IFEQ      *BLANK                                       *IF
      * Start CRT002
      * End CRT002
     C     WUDRTS        IFEQ      'Y'
     C     CRE026        ANDEQ     'Y'
      * Setup message data for message                                                        CRE026
     C                   MOVEL     #DNICS        ZA0023
      * Send message 'A Valid Numeric ISO required'                                           CRE026
     C                   MOVEL     'USR9826'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *                                                                                       CRE026
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   ENDIF
      *                                                                                       CRE026
     C                   ELSE
     C                   MOVEL     *BLANKS       RETCOD           10
     C     CRE026        IFEQ      'Y'
     C                   CALL      'SD0021EQ'
     C                   PARM                    RETCOD           10
     C                   PARM                    #1CYCD            3
     C                   PARM                    #DNICS            3
     C                   END
     C     RETCOD        IFEQ      *BLANK
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DNICS        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0045            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0046           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0047            1 0          ZALIGN No Of De
     C                   PARM      3             WQ0048            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0049           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      **ZEDIT*Screen*Field*-*Standard*Functions*******************************************   BUG2853
     C**********           CALL 'ZEDIT'                90  ZEDIT Screen Fi                   BUG2853
     C********** WUZASF    PARM WUZASF    WQ0050 16        ZALIGN Screen F                   BUG2853
     C**********           PARM *ZERO     WQ0051  10       ZALIGN No Of De                   BUG2853
      **********                                                                             BUG2853
     C********** *IN90     IFEQ '1'                                                          BUG2853
      **Call*to*program*ended*in*error****************************************************   BUG2853
     C**********           MOVEL'Y2U0032' W0RTN                                              BUG2853
     C**********           MOVEL*BLANKS   W0CLPG 10                                          BUG2853
     C**********           MOVEL'ZEDIT'   W0CLPG                                             BUG2853
      **Send*message*'*Error*occured*on*CALL...'******************************************   BUG2853
     C**********           MOVEL'Y2U0032' ZAMSID                                             BUG2853
     C**********           MOVEL'Y2USRMSG'ZAMSGF                                             BUG2853
     C**********           MOVELW0CLPG    ZAMSDA           Message data                      BUG2853
     C**********           EXSR ZASNMS                                                       BUG2853
     C**********           END                                                               BUG2853
      *
     C                   END                                                    *FI
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DNICS        ZA0023                         Numeric ISO Cur
      * Send message 'Numeric iso curr is numbr'
     C                   MOVEL     'USR2789'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVE      WUZAFF        #1ISON                         Numeric ISO Cur
      * Zalign Numeric ISO curr - Currency Codes  *
     C*
     C                   MOVE      WUZASF        #DNICS
     C*
      * Check for valid range
      * CASE: DTL.Numeric ISO Currency is Valid nrange
     C     #1ISON        IFGE      1                                            *IF
     C     #1ISON        ANDLE     999
      *                                                                                       CRE026
      * Check if Consumer Banking is On then ISO number must be unique                        CRE026
     C     CRE026        IFEQ      'Y'
      *                                                                                       CRE026
     C     #1ISON        SETLL     SDCURRLF
     C     #1ISON        READE     SDCURRLF                               90
      *                                                                                       CRE026
     C     *IN90         DOWEQ     *OFF
      *                                                                                       CRE026
     C     #1CYCD        IFNE      A6CYCD
      * Setup message data for message                                                        CRE026
     C                   MOVEL     #DNICS        ZA0024
      * Send message 'ISO Codes must be Unique'                                               CRE026
     C                   MOVEL     'USR9827'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939
      *                                                                                       CRE026
     C                   MOVEL     'N'           WUWFG3
     C                   ENDIF
      *                                                                                       CRE026
     C     #1ISON        READE     SDCURRLF                               90
      *                                                                                       CRE026
     C                   ENDDO
      *                                                                                       CRE026
     C                   ENDIF
      *                                                                                       CRE026
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DNICS        ZA0024                         Numeric ISO Cur
      * Send message 'Numeric ISO Curr 1 - 999'
     C                   MOVEL     'USR2790'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
     C                   MOVEL     #DNICS        ZA0020
     C                   MOVEL     'USR9991'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
     C                   MOVEL     'N'           WUWFG3                         WORK FLAG 3
     C                   END
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of change CRT001
      * Validate Par Rate
     C                   EXSR      UKSUBR                                       Validate Par Ra
      * Validate Par Rate Indicator
      * CASE: DTL.Multiply/Divide, Par is valid value
     C     #1MDPR        IFEQ      'D'                                          *IF
     C     #1MDPR        OREQ      'M'
     C                   ELSE
      * CASE: DTL.Multiply/Divide, Par is Blank
     C     #1MDPR        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MDPR        ZA0032                         Multiply/Divide
      * Send message 'Indicator invalid (D/M)'
     C                   MOVEL     'USR1166'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9941      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Calculate Limit Rate and M/D indicator
     C                   EXSR      ULSUBR                                       Calculate Limit
      * Start of Fix LN1072
      * Validate RM cashflow magnitude
      * CASE: WRK.Risk Management is Yes
     C     WURKMG        IFEQ      'Y'                                          *IF
      * CASE: DTL.RM cashflow magnitude fun is blank
     C     #DRMCF        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
      * Setup message data for message
     C                   MOVEL     #DRMCF        ZA0033                         RM cashflow mag
      * Send message 'RM cashflow mag. required'
     C                   MOVEL     'USR1521'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9942      *
      *
     C                   ELSE
      * CASE: DTL.RM cashflow magnitude fun is zero
     C     #DRMCF        IFEQ      '0'                                          *IF
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
      * Setup message data for message
     C                   MOVEL     #DRMCF        ZA0034                         RM cashflow mag
      * Send message 'RM cashflow mag. invalid'
     C                   MOVEL     'USR1522'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9942      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
      * MOVE RMCF to ZASF - Currency Codes  *
     C                   MOVE      #DRMCF        WUZASF
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0065            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0066           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0067            1 0          ZALIGN No Of De
     C                   PARM      1             WQ0068            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0069           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0070           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0071            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
      * Setup message data for message
     C                   MOVEL     #DRMCF        ZA0035                         RM cashflow mag
      * Send message 'Field Not Numeric'
     C                   MOVEL     'USR0822'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9942      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * MOVE ZASF to RMCF - Currency Codes  *
     C                   MOVE      WUZASF        #DRMCF
     C                   MOVE      WUZAFF        #1RMCM                         RM Cashflow Mag
      * CASE: DTL.RM Cashflow Magnitude is valid values
     C     #1RMCM        IFGE      1                                            *IF
     C     #1RMCM        ANDLE     9
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
      * Setup message data for message
     C                   MOVEL     #DRMCF        ZA0036                         RM cashflow mag
      * Send message 'RM cashflow mag. invalid'
     C                   MOVEL     'USR1522'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9942      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of Fix LN1072
      * Validate F.T. Rate
     C                   EXSR      UMSUBR                                       Validate F.T. R
      * Validate F.T. Rate Indicator
      * CASE: DTL.Multiply/Divide, Hist Bkg is valid value
     C     #1MDHB        IFEQ      'D'                                          *IF
     C     #1MDHB        OREQ      'M'
     C                   ELSE
      * CASE: DTL.Multiply/Divide, Hist Bkg is Blank
     C     #1MDHB        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MDHB        ZA0044                         Multiply/Divide
      * Send message 'Indicator invalid (D/M)'
     C                   MOVEL     'USR1166'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9944      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Validate Spot Trade Account Equivalent
     C                   EXSR      UNSUBR                                       Validate Spot T
      * Validate Forward Trade Account Equivalent
     C                   EXSR      UOSUBR                                       Validate Forwar
      * Validate Swap Trade Account Equivalent
     C                   EXSR      UPSUBR                                       Validate Swap T
      * Validate Trade Account Code No's 4 & 5
     C                   EXSR      UQSUBR                                       Validate Trade
      * Validate Weekend Days (Fri, Sat, Sun)
     C                   EXSR      URSUBR                                       Validate Weeken
      * Validate Statutory Return Codes 1 & 2
     C                   EXSR      USSUBR                                       Validate Statut
      *                                                                                       CER043
     C     CER043        IFEQ      'Y'
     C                   EXSR      SRRETP
     C                   ENDIF
      * Start of change S01391 - Japanese Sub-module.
      * Validate Round Down Interest Indicator
      * CASE: DTL.Round Down Interest Ind is Valid values
     C     #1RDFC        IFEQ      'N'                                          *IF
     C     #1RDFC        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1RDFC        ZA0065                         Round Down Inte
      * Send message 'Round down ind invalid'
     C                   MOVEL     'USR1833'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9955      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   END                                                    *FI
      * End of change S01391 - Japanese Sub-module.
      * Start of change S01433.
      * 00/Copy member SD0021RC03 - Currency Codes  *
     C/COPY WNCPYSRC,SD0021RC03
      * Precious Metal Indicator.
      * CASE: WRK.SAR S01433 is Present
     C     WUSARF        IFEQ      'Y'                                          *IF
     C     CSW212        OREQ      'Y'
      * 00/Copy member SD0021rc04 - Currency Codes  *
     C/COPY WNCPYSRC,SD0021RC04
      * Check for valid values.
      * CASE: DTL.Precious Metal  Ind. is Valid values
     C     #1PMRT        IFEQ      'N'                                          *IF
     C     #1PMRT        OREQ      'Y'
      *                                                                                       CMG003
     C     CMG003        IFEQ      'Y'
     C     #1PMSC        ANDEQ     'Y'
     C     #1PMRT        ANDEQ     'N'
      *                                                                                       CMG003
      ** Send message 'Precious Metal must be set to Y'                                       CMG003
      *                                                                                       CMG003
     C                   MOVEL     #1PMRT        ZA0066
     C                   MOVEL     'USR4833'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9956
      *                                                                                       CMG003
     C                   MOVEL     'N'           WUWFG3
     C                   ENDIF
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1PMRT        ZA0066                         Precious Metal
      * Send message 'Precious Metal Ind invald'
     C                   MOVEL     'USR2170'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9956      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of change S01433.
      * Start of S01486
      * Validate Currency Ranking Sequence.
      * CASE: WRK.Portfolio Management is No or Blank
     C     WUPFMG        IFEQ      *BLANK                                       *IF
     C     WUPFMG        OREQ      'N'
     C                   ELSE
      * CASE: *OTHERWISE
      * Validate Currency Ranking Sequence
      * CASE: DTL.Currency Ranking Seq. scr is Blank
     C     #DCRSQ        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DCRSQ        ZA0067                         Currency Rankin
      * Send message 'Currency Ran Seq is reqd'
     C                   MOVEL     'USR2365'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9957      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DCRSQ        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0098            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0099           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0100            1 0          ZALIGN No Of De
     C                   PARM      3             WQ0101            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0102           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0103           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0104            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DCRSQ        ZA0068                         Currency Rankin
      * Send message 'Curr Rank Seq is numeric'
     C                   MOVEL     'USR2366'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9957      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVE      WUZAFF        #1RKSQ                         Currency Rankin
      * Zalign Curr Rank Seq. - Currency Codes  *
     C*
     C                   MOVE      WUZASF        #DCRSQ
     C*
      * Check for valid range
      * CASE: DTL.Currency Ranking Sequence is Valid Range
     C     #1RKSQ        IFGE      1                                            *IF
     C     #1RKSQ        ANDLE     999
      * Start of fix 080076
      * Currency Ranking Sequence must be uniqe
      * CASE: WRK.Currency Ranking Seq. scr NE DTL.Currency Ranking Seq.
     C     WUCRSQ        IFNE      #DCRSQ                                       *IF
     C                   MOVEL     *BLANK        WURTN                          *Return code
      * Check Currency Rank Seq - Currency Codes  *
     C                   EXSR      SORVGN
      * CASE: WRK.*Return code is *Record already exists
     C     WURTN         IFEQ      'Y2U0003'                                    *IF
      * Setup message data for message
     C                   MOVEL     #DCRSQ        ZA0069                         Currency Rankin
      * Send message 'Curr Ran seq is unique'
     C                   MOVEL     'USR2836'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9957      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of fix 080076
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DCRSQ        ZA0070                         Currency Rankin
      * Send message 'Curr Rank Seq 1 - 999'
     C                   MOVEL     'USR2367'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9957      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of S01486
      *                                                                   CDL008
      ** If CDL008 is on,                                                 CDL008
      *                                                                   CDL008
     C     CDL008        IFEQ      'Y'                                                         CDL00
      *                                                                   CDL008
      ** Validate CLS Currency                                            CDL008
      *                                                                   CDL008
     C                   SELECT                                                                CDL00
     C     #1CLSC        WHENEQ    'Y'                                                         CDL00
     C     #1CLSC        OREQ      'N'                                                         CDL00
     C     #1CLSC        OREQ      *BLANK                                                      CDL00
     C                   OTHER                                                                 CDL00
     C                   MOVE      *ON           *IN58                                         CDL00
     C                   MOVE      *ON           *IN99                                         CDL00
     C                   MOVEL     #1CLSC        ZA0084                                        CDL00
     C                   MOVEL     'USR4585'     ZAMSID                                        CDL00
     C                   EXSR      ZASNMS                                                      CDL00
     C                   MOVEL     'N'           WUWFG3                                        CDL00
     C                   ENDSL                                                                 CDL00
      *                                                                   CDL008
      ** Validate Effective Date: must be entered if CLS Currency = 'Y'   CDL008
      *                                                                   CDL008
     C     #DEFDT        IFEQ      *BLANKS                                                     CDL00
     C                   SELECT                                                                CDL00
     C     #1CLSC        WHENEQ    'Y'                                                         CDL00
     C                   MOVE      *ON           *IN59                                         CDL00
     C                   MOVE      *ON           *IN99                                         CDL00
     C                   MOVE      #DEFDT        ZA0085                                        CDL00
     C                   MOVEL     'USR4586'     ZAMSID                                        CDL00
     C                   EXSR      ZASNMS                                                      CDL00
     C                   MOVEL     'N'           WUWFG3                                        CDL00
     C     #1CLSC        WHENEQ    'N'                                                         CDL00
     C     #1CLSC        OREQ      *BLANK                                                      CDL00
     C                   Z-ADD     *ZERO         #1EFDT                                        CDL00
     C                   ENDSL                                                                 CDL00
     C                   ENDIF                                                                 CDL00
      *                                                                   CDL008
      ** Must be a valid date if CLS Currency = 'Y'                       CDL008
      *                                                                   CDL008
     C     #DEFDT        IFNE      *BLANKS                                                     CDL00
     C                   SELECT                                                                CDL00
     C     #1CLSC        WHENEQ    'Y'                                                         CDL00
     C                   MOVE      '*BLANKS'     ZRTN
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      #DEFDT        ZFIELD                                        CDL00
     C                   Z-ADD     *ZERO         ZADEC                                         CDL00
     C                   Z-ADD     6             ZADIG                                         CDL00
     C                   MOVE      *IN99         WIN99             1                           CDL00
     C                   EXSR      ZALIGN                                                      CDL00
     C********** *IN99     IFEQ *ON                                                  CDL008 MD021493
     C     ZRTN          IFEQ      '*ERROR*'
     C                   MOVE      *ON           *IN59                                         CDL00
     C                   MOVE      #DEFDT        ZA0086                                        CDL00
     C                   MOVEL     'USR1040'     ZAMSID                                        CDL00
     C                   EXSR      ZASNMS                                                      CDL00
     C                   MOVEL     'N'           WUWFG3                                        CDL00
     C                   ELSE                                                                  CDL00
     C                   MOVE      #DEFDT        ZDATE                                         CDL00
     C                   EXSR      ZDATE1                                                      CDL00
     C     *IN99         IFEQ      *ON                                                         CDL00
     C                   MOVE      *ON           *IN59                                         CDL00
     C                   MOVE      #DEFDT        ZA0086                                        CDL00
     C                   MOVEL     'USR1040'     ZAMSID                                        CDL00
     C                   EXSR      ZASNMS                                                      CDL00
     C                   MOVEL     'N'           WUWFG3                                        CDL00
     C                   ELSE                                                                  CDL00
     C                   MOVE      WIN99         *IN99                                         CDL00
     C                   Z-ADD     ZDAYNO        #1EFDT                                        CDL00
     C                   ENDIF                                                                 CDL00
     C                   ENDIF                                                                 CDL00
      *                                                                   CDL008
      ** Must be blank if CLS Currency <> 'Y'.                            CDL008
      *                                                                   CDL008
     C     #1CLSC        WHENEQ    'N'                                                         CDL00
     C     #1CLSC        OREQ      *BLANK                                                      CDL00
     C                   MOVE      *ON           *IN59                                         CDL00
     C                   MOVE      *ON           *IN99                                         CDL00
     C                   MOVE      #DEFDT        ZA0085                                        CDL00
     C                   MOVEL     'USR4586'     ZAMSID                                        CDL00
     C                   EXSR      ZASNMS                                                      CDL00
     C                   MOVEL     'N'           WUWFG3                                        CDL00
     C                   ENDSL                                                                 CDL00
     C                   ENDIF                                                                 CDL00
      *                                                                   CDL008
      ** If CLS Currency is 'N', default to blank.                        CDL008
      *                                                                   CDL008
     C     #1CLSC        IFEQ      *BLANK                                                      CDL00
     C     #DEFDT        ANDEQ     *BLANKS                                                     CDL00
     C                   MOVE      'N'           #1CLSC                                        CDL00
     C                   ENDIF                                                                 CDL00
     C                   ENDIF                                                                 CDL00
      *                                                                   CDL008
      ** If CIR007 is on,                                                                     CIR007
      *                                                                                       CIR007
     C     CIR007        IFEQ      'Y'
      *                                                                                       CIR007
      ** Validate Overnight Index Swap Settlement Days.                                       CIR007
      *                                                                                       CIR007
     C     #1SETD        IFEQ      *BLANKS
     C                   MOVE      '  0'         #1SETD
     C                   ELSE
      *                                                                                       CIR007
      ** Overnight Index Swap Settlement Days must be numeric.                                CIR007
      *                                                                                       CIR007
     C                   MOVE      *BLANKS       ZRTN              7
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      #1SETD        ZFIELD
     C                   Z-ADD     *ZERO         ZADEC
     C                   Z-ADD     3             ZADIG
     C                   MOVE      *IN99         WIN99
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   MOVE      *ON           *IN60
     C                   MOVE      #1SETD        ZA0087
     C                   MOVEL     'USR9153'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'N'           WUWFG3
     C                   ELSE
     C                   MOVE      WIN99         *IN99
     C                   MOVE      ZFIELD        #1SETD
     C                   ENDIF
      *                                                                                       CIR007
     C                   ENDIF
      *                                                                                       CIR007
      ** Validate Overnight Index Swap Interest Rate Decimal Places.                          CIR007
      *                                                                                       CIR007
     C     #1IRDP        IFEQ      *BLANKS
     C                   MOVE      '  0'         #1IRDP
     C                   ELSE
      *                                                                                       CIR007
      ** Overnight Index Swap Interest Rate Dec.Places must be numeric.                       CIR007
      *                                                                                       CIR007
     C                   MOVE      *BLANKS       ZRTN
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      #1IRDP        ZFIELD
     C                   Z-ADD     *ZERO         ZADEC
     C                   Z-ADD     1             ZADIG
     C                   MOVE      *IN99         WIN99
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   MOVE      *ON           *IN61
     C                   MOVE      #1IRDP        ZA0088
     C                   MOVEL     'USR9154'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'N'           WUWFG3
     C                   ELSE
     C                   MOVE      WIN99         *IN99
     C                   MOVE      ZFIELD        #1IRDP
     C                   ENDIF
      *                                                                                       CIR007
     C                   ENDIF
      *                                                                                       CIR007
     C                   ENDIF
      * Call Edit Programs and Update file
      * CASE: WRK.Work Flag 3 is Correct
     C     WUWFG3        IFEQ      'Y'                                          *IF
      * start S01319
      * Remove test for Dealing MM as always = Dealing FX
      * Change references to 'DRS' to 'DL'
      * Start of SAR S01117
      * CASE: WRK.Dealing: FX is Yes
     C     WUDLFX        IFEQ      'Y'                                          *IF
     C                   MOVEL     'D'           WUWFG1                         Work Flag 1
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'S'           WUWFG1                         Work Flag 1
     C                   END                                                    *FI
      * End of SAR S01117
      * end S01319
     C                   MOVEL     'Y'           WUCNLP                         Continue Loop
      * standard retrieve object - Currency Codes  *
     C                   EXSR      SPRVGN
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Create Currency Codes -LR - Currency Codes  *
     C                   EXSR      SQCRRC
     C/COPY WNCPYSRC,SD0021RC22
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: PAR.Action Code is Delete
     C     P2ANCD        IFEQ      'D'                                          *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
     C                   MOVEL     'CHG'         W0PMD                          *Program mode
     C                   END                                                    *FI
      * Change Currency Codes -LR - Currency Codes  *
     C                   EXSR      SRCHRC
     C     CSD043        IFEQ      'Y'
     C     UPDTOK        IFEQ      'Y'
     C     CUROPN        IFNE      'Y'
     C                   OPEN      SDACURL0
     C                   MOVE      'Y'           CUROPN
     C                   ENDIF
     C     #1CYCD        CHAIN     SDACURL0                           9091
     C     *IN90         IFEQ      '0'
     C     P2ANCD        IFEQ      'X'
     C                   DELETE    SDACURL0
     C                   ENDIF
     C                   GOTO      DCEXIT
     C                   ENDIF
     C                   ELSE
     C                   GOTO      DCEXIT
     C                   ENDIF
     C                   ENDIF
     C/COPY WNCPYSRC,SD0021RC23
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: PGM.*Return code is Returns Not Updated
     C/COPY WNCPYSRC,SD0021RC28
     C     W0RTN         IFEQ      'N'                                          *IF
     C/COPY WNCPYSRC,SD0021RC29
     C                   GOTO      DCEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Create Curr Codes 2 - Currency Codes  *
     C                   EXSR      SSCRRC
     C                   ELSE
      * CASE: *OTHERWISE
      * Change Curr Codes 2 - Currency Codes  *
     C                   EXSR      SUCHRC
     C                   END                                                    *FI
     C                   END                                                    *FI
     C/COPY WNCPYSRC,SD0021RC24
      * DO WHILE: WRK.Continue Loop is Correct
     C     WUCNLP        DOWEQ     'Y'                                          *DOW
      * start S01319
      * Remove test for Dealing MM as always = Dealing FX
      * Change references to 'DRS' to 'DL'
      * CASE: WRK.Work Flag 1 is Do DL
     C     WUWFG1        IFEQ      'D'                                          *IF
      * CASE: WRK.Dealing: FX is Yes
     C     WUDLFX        IFEQ      'Y'                                          *IF
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'S'           WUWFG1                         Work Flag 1
     C                   END                                                    *FI
      * Flag 1 is Do DL
      * CASE: WRK.Work Flag 1 is Do DL
     C     WUWFG1        IFEQ      'D'                                          *IF
      * Currency Codes Maint(DL) - Currency Codes  *
     C                   CLEAR                   PARC
     C                   MOVEL     #1CYCD        PACYCD                         Currency Code
      *
     C                   CALL      'SD0022R'                            90      Currency Codes
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PARC                           KEY: Currency C
     C                   PARM      WUFNSC        WQ0152            1            Final Screen
     C                   PARM      P2ANCD        WQ0153            1            Action Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0022R'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
     C                   MOVEL     'Y2U0004'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PGM.*Return code is &Delete
     C     W0RTN         IFEQ      'DEL'                                        *IF
     C                   MOVEL     'N'           WUCNLP                         Continue Loop
     C                   MOVEL     'D'           WUWFG1                         Work Flag 1
     C                   ELSE
      * CASE: PGM.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   GOTO      DCEXIT                                       *QUIT
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'S'           WUWFG1                         Work Flag 1
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Flag 1 is Do ST
      * CASE: WRK.Work Flag 1 is Do ST
     C     WUWFG1        IFEQ      'S'                                          *IF
      * CASE: WRK.Securities is Yes
     C     WUSECS        IFEQ      'Y'                                          *IF
      * Currency Codes Maint(SE) - Currency Codes  *
     C                   CLEAR                   PBRC
     C                   MOVEL     #1CYCD        PBCYCD                         Currency Code
      *
     C                   CALL      'SD0023R'                            90      Currency Codes
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PBRC                           KEY: Currency C
     C                   PARM      WUFNSC        WQ0154            1            Final Screen
     C                   PARM      P2ANCD        WQ0155            1            Action Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0023R'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
     C                   MOVEL     'Y2U0004'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PGM.*Return code is &Delete
     C     W0RTN         IFEQ      'DEL'                                        *IF
     C                   MOVEL     'N'           WUCNLP                         Continue Loop
     C                   MOVEL     'S'           WUWFG1                         Work Flag 1
     C                   ELSE
      * CASE: PGM.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
      * Start of SAR S01117
      * CASE: WRK.Dealing: FX is Yes
     C     WUDLFX        IFEQ      'Y'                                          *IF
     C                   MOVEL     'D'           WUWFG1                         Work Flag 1
     C                   ELSE
      * CASE: *OTHERWISE
     C                   GOTO      DCEXIT                                       *QUIT
     C                   END                                                    *FI
      * End of SAR S01117
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'F'           WUWFG1                         Work Flag 1
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'F'           WUWFG1                         Work Flag 1
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Flag 1 is Do FT
      * CASE: WRK.Work Flag 1 is Do FT
     C     WUWFG1        IFEQ      'F'                                          *IF
      * CASE: WRK.Funds Transfer is Yes
     C     WUFDTR        IFEQ      'Y'                                          *IF
     C/COPY WNCPYSRC,SD0021RCNB
      * Currency Codes Maint(FT) - Currency Codes  *
     C                   CLEAR                   PCRC
     C                   MOVEL     #1CYCD        PCCYCD                         Currency Code
      *
     C                   CALL      'SD0024R'                            90      Currency Codes
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PCRC                           KEY: Currency C
     C                   PARM      WUFNSC        WQ0156            1            Final Screen
     C                   PARM      P2ANCD        WQ0157            1            Action Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0024R'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
     C                   MOVEL     'Y2U0004'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PGM.*Return code is &Delete
     C     W0RTN         IFEQ      'DEL'                                        *IF
     C                   MOVEL     'N'           WUCNLP                         Continue Loop
     C                   MOVEL     'F'           WUWFG1                         Work Flag 1
     C                   ELSE
      * CASE: PGM.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
      * CASE: WRK.Securities is Yes
     C     WUSECS        IFEQ      'Y'                                          *IF
     C                   MOVEL     'S'           WUWFG1                         Work Flag 1
     C                   ELSE
      * CASE: WRK.Dealing: FX is Yes
     C     WUDLFX        IFEQ      'Y'                                          *IF
     C                   MOVEL     'D'           WUWFG1                         Work Flag 1
     C                   ELSE
      * CASE: *OTHERWISE
     C                   GOTO      DCEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'W'           WUWFG1                         Work Flag 1
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'W'           WUWFG1                         Work Flag 1
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Flag 1 is Do SW
      * CASE: WRK.Work Flag 1 is Do SW
     C     WUWFG1        IFEQ      'W'                                          *IF
      * CASE: WRK.Midas/Swift direct link is Yes
     C     WUMSDL        IFEQ      'Y'                                          *IF
      * Currency Codes Maint(MS) - Currency Codes  *
     C                   CLEAR                   PDRC
     C                   MOVEL     #1CYCD        PDCYCD                         Currency Code
      *
     C                   CALL      'SD0025R'                            90      Currency Codes
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PDRC                           KEY: Currency C
     C                   PARM      WUFNSC        WQ0158            1            Final Screen
     C                   PARM      P2ANCD        WQ0159            1            Action Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0025R'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
     C                   MOVEL     'Y2U0004'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PGM.*Return code is &Delete
     C     W0RTN         IFEQ      'DEL'                                        *IF
     C                   MOVEL     'N'           WUCNLP                         Continue Loop
     C                   MOVEL     'W'           WUWFG1                         Work Flag 1
     C                   ELSE
      * CASE: PGM.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
      * CASE: WRK.Funds Transfer is Yes
     C     WUFDTR        IFEQ      'Y'                                          *IF
     C                   MOVEL     'F'           WUWFG1                         Work Flag 1
     C                   ELSE
      * CASE: WRK.Securities is Yes
     C     WUSECS        IFEQ      'Y'                                          *IF
     C                   MOVEL     'S'           WUWFG1                         Work Flag 1
     C                   ELSE
      * CASE: WRK.Dealing: FX is Yes
     C     WUDLFX        IFEQ      'Y'                                          *IF
     C                   MOVEL     'D'           WUWFG1                         Work Flag 1
      * end S01319
     C                   ELSE
      * CASE: *OTHERWISE
     C                   GOTO      DCEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Start of CRT001
     C                   MOVEL     'R'           WUWFG1                         Work Flag 1
      * End of CRT001
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Start of CRT001
     C                   MOVEL     'R'           WUWFG1                         Work Flag 1
      * End of CRT001
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Start of CRT001
      * Flag 1 is Do RTS
      * CASE: WRK.Work Flag 1 is Do RTS
     C     WUWFG1        IFEQ      'R'                                          *IF
      * CASE: WRK.Call RTS Program is Yes
     C     WUCRTP        IFEQ      'Y'                                          *IF
      * Currency Codes Maint(RTS) - Currency Codes  *
     C                   CLEAR                   PERC
     C                   MOVEL     #1CYCD        PECYCD                         Currency Code
      *
     C                   CALL      'SD0027R'                            90      Currency Codes
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PERC                           KEY: Currency C
     C                   PARM      WUFNSC        WQ0160            1            Final Screen
     C                   PARM      P2ANCD        WQ0161            1            Action Code
     C                   PARM      #1CYNM        WQ0162           14            Currency Name
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0027R'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9931      *
     C                   END
      * CASE: PGM.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
     C                   MOVEL     'Y2U0004'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PGM.*Return code is &Delete
     C     W0RTN         IFEQ      'DEL'                                        *IF
     C                   MOVEL     'N'           WUCNLP                         Continue Loop
     C                   ELSE
      * CASE: PGM.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
      * CASE: WRK.Midas/Swift direct link is Yes
     C     WUMSDL        IFEQ      'Y'                                          *IF
     C                   MOVEL     'W'           WUWFG1                         Work Flag 1
     C                   ELSE
      * CASE: WRK.Funds Transfer is Yes
     C     WUFDTR        IFEQ      'Y'                                          *IF
     C                   MOVEL     'F'           WUWFG1                         Work Flag 1
     C                   ELSE
      * CASE: WRK.Securities is Yes
     C     WUSECS        IFEQ      'Y'                                          *IF
     C                   MOVEL     'S'           WUWFG1                         Work Flag 1
     C                   ELSE
      * CASE: WRK.Dealing: FX is Yes
     C     WUDLFX        IFEQ      'Y'                                          *IF
     C                   MOVEL     'D'           WUWFG1                         Work Flag 1
     C                   ELSE
      * CASE: *OTHERWISE
     C                   GOTO      DCEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C*******              MOVEL'N'       WUCNLP           Continue Loop  CPB001
     C                   MOVEL     'P'           WUWFG1                         Work Flag 1    CPB00
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C*******              MOVEL'N'       WUCNLP           Continue Loop  CPB001
     C                   MOVEL     'P'           WUWFG1                         Work Flag 1    CPB00
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of CRT001
      * Flag 1 is Do PB                                                   CPB001
      * CASE: WRK.Work Flag 1 is Do PB                                    CPB001
     C     WUWFG1        IFEQ      'P'                                          *IF            CPB00
      * CASE: WRK.Call PB Program is Yes                                  CPB001
     C     WUN4ST        IFEQ      'Y'                                          *IF            CPB00
      * Private Banking Currency Maintenance (PB)  *                      CPB001
     C                   CLEAR                   PERC                                          CPB00
     C                   MOVEL     #1CYCD        PECYCD                         Currency Code  CPB00
      *                                                                   CPB001
     C                   CALL      'SD0028R'                            90      Currency Codes CPB00
     C                   PARM      *BLANK        W0RTN             7                           CPB00
     C                   PARM                    PERC                           KEY: Currency CCPB00
     C                   PARM      WUFNSC        WQ0320            1            Final Screen   CPB00
     C                   PARM      P2ANCD        WQ0321            1            Action Code    CPB00
      *                                                                   CPB001
     C     *IN90         IFEQ      '1'                                                         CPB00
      * Call to program ended in error                                    CPB001
     C                   MOVEL     'Y2U0032'     W0RTN                                         CPB00
     C                   MOVEL     *BLANKS       W0CLPG           10                           CPB00
     C                   MOVEL     'SD0028R'     W0CLPG                                        CPB00
      * Send message '*Error occured on CALL...'                          CPB001
     C                   MOVEL     'Y2U0032'     ZAMSID                                        CPB00
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        CPB00
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data   CPB00
     C                   EXSR      ZASNMS                                                      CPB00
     C                   END                                                                   CPB00
      *                                                                   CPB001
      * Error detected?                                                   CPB001
     C     W0RTN         IFNE      *BLANK                                                      CPB00
     C                   SETON                                        9931      *              CPB00
     C                   END                                                                   CPB00
      * CASE: PGM.*Return code is *DBF update error                       CPB001
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF            CPB00
     C                   MOVEL     'Y2U0004'     P0RTN                          *Return code   CPB00
     C                   EXSR      ZYEXPG                                                      CPB00
     C                   ELSE                                                                  CPB00
      * CASE: PGM.*Return code is *User QUIT requested                    CPB001
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF            CPB00
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code   CPB00
     C                   EXSR      ZYEXPG                                                      CPB00
     C                   ELSE                                                                  CPB00
      * CASE: PGM.*Return code is &Delete                                 CPB001
     C     W0RTN         IFEQ      'DEL'                                        *IF            CPB00
     C                   MOVEL     'N'           WUCNLP                         Continue Loop  CPB00
     C                   ELSE                                                                  CPB00
      * CASE: PGM.*Return code is *Previous Screen                        CPB001
     C     W0RTN         IFEQ      'USR0790'                                    *IF            CPB00
      * CASE: WRK.Retails     direct link is Yes                          CPB001
     C     WUCRTP        IFEQ      'Y'                                          *IF            CPB00
     C                   MOVEL     'R'           WUWFG1                         Work Flag 1    CPB00
     C                   ELSE                                                                  CPB00
      * CASE: WRK.Midas/Swift direct link is Yes                          CPB001
     C     WUMSDL        IFEQ      'Y'                                          *IF            CPB00
     C                   MOVEL     'W'           WUWFG1                         Work Flag 1    CPB00
     C                   ELSE                                                                  CPB00
      * CASE: WRK.Funds Transfer is Yes                                   CPB001
     C     WUFDTR        IFEQ      'Y'                                          *IF            CPB00
     C                   MOVEL     'F'           WUWFG1                         Work Flag 1    CPB00
     C                   ELSE                                                                  CPB00
      * CASE: WRK.Securities is Yes                                       CPB001
     C     WUSECS        IFEQ      'Y'                                          *IF            CPB00
     C                   MOVEL     'S'           WUWFG1                         Work Flag 1    CPB00
     C                   ELSE                                                                  CPB00
      * CASE: WRK.Dealing: FX is Yes                                      CPB001
     C     WUDLFX        IFEQ      'Y'                                          *IF            CPB00
     C                   MOVEL     'D'           WUWFG1                         Work Flag 1    CPB00
     C                   ELSE                                                                  CPB00
      * CASE: *OTHERWISE                                                  CPB001
     C                   GOTO      DCEXIT                                       *QUIT          CPB00
     C                   END                                                    *FI            CPB00
     C                   END                                                    *FI            CPB00
     C                   END                                                    *FI            CPB00
     C                   END                                                    *FI            CPB00
     C                   END                                                    *FI            CPB00
     C                   ELSE                                                                  CPB00
      * CASE: *OTHERWISE                                                  CPB001
     C*********************MOVEL'N'       WUCNLP           Continue CPB001CSD006
     C                   MOVEL     'M'           WUWFG1                                        CSD00
     C                   END                                                    *FI            CPB00
     C                   END                                                    *FI            CPB00
     C                   END                                                    *FI            CPB00
     C                   END                                                    *FI            CPB00
     C                   ELSE                                                                  CPB00
      * CASE: *OTHERWISE                                                  CPB001
     C*********************MOVEL'N'       WUCNLP           Continue CPB001CSD006
     C                   MOVEL     'M'           WUWFG1                                        CSD00
     C                   END                                                    *FI            CPB00
     C                   END                                                    *FI            CPB00
      * End of CPB001                                                     CPB001
      *                                                                   CSD006
      ** Market Data Feed Maintenance                                     CSD006
     C     WUWFG1        IFEQ      'M'                                                         CSD00
     C     CSD006        IFEQ      'Y'                                                         CSD00
     C     CAP057        OREQ      'Y'                                                         CAP05
     C     CAP058        OREQ      'Y'                                                         CAP05
     C     CAP059        OREQ      'Y'                                                         CAP05
      *                                                                   CSD006
     C                   CLEAR                   PERC                                          CSD00
     C                   MOVEL     #1CYCD        PECYCD                                        CSD00
     C                   CALL      'SD0021'                             90                     CSD00
     C                   PARM      *BLANK        W0RTN             7                           CSD00
     C                   PARM                    PERC                                          CSD00
     C                   PARM      WUFNSC        P@FISC            1                           CSD00
     C                   PARM      P2ANCD        P@ACTN            1                           CSD00
     C                   PARM      *BLANKS       WP0002            5
     C                   PARM                    WULUXS            1
     C                   PARM                    WCOMMS            1
      *                                                                   CSD006
     C     *IN90         IFEQ      '1'                                                         CSD00
      * Call to program ended in error                                    CSD006
     C                   MOVEL     'Y2U0032'     W0RTN                                         CSD00
     C                   MOVEL     *BLANKS       W0CLPG           10                           CSD00
     C                   MOVEL     'SD0021 '     W0CLPG                                        CSD00
      * Send message '*Error occured on CALL...'                          CSD006
     C                   MOVEL     'Y2U0032'     ZAMSID                                        CSD00
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        CSD00
     C                   MOVEL     W0CLPG        ZAMSDA                                        CSD00
     C                   EXSR      ZASNMS                                                      CSD00
     C                   ENDIF                                                                 CSD00
      *                                                                   CSD006
      * Error detected?                                                   CSD006
     C     W0RTN         IFNE      *BLANK                                                      CSD00
     C                   SETON                                        9931                     CSD00
     C                   ENDIF                                                                 CSD00
      * CASE: PGM.*Return code is *DBF update error                       CSD006
     C     W0RTN         IFEQ      'Y2U0004'                                                   CSD00
     C                   MOVEL     'Y2U0004'     P0RTN                                         CSD00
     C                   EXSR      ZYEXPG                                                      CSD00
     C                   ELSE                                                                  CSD00
      * CASE: PGM.*Return code is *User QUIT requested                    CSD006
     C     W0RTN         IFEQ      'Y2U9999'                                                   CSD00
     C                   MOVEL     'Y2U9999'     P0RTN                                         CSD00
     C                   EXSR      ZYEXPG                                                      CSD00
     C                   ELSE                                                                  CSD00
      * CASE: PGM.*Return code is &Delete                                 CSD006
     C     W0RTN         IFEQ      'DEL'                                                       CSD00
     C                   MOVEL     'N'           WUCNLP                                        CSD00
     C                   ELSE                                                                  CSD00
      * CASE: PGM.*Return code is *Previous Screen                        CSD006
     C     W0RTN         IFEQ      'USR0790'                                                   CSD00
      * CASE: WRK.Private Banking is Yes                                  CSD006
     C     WUN4ST        IFEQ      'Y'                                                         CSD00
     C                   MOVEL     'P'           WUWFG1                                        CSD00
     C                   ELSE                                                                  CSD00
      * CASE: WRK.Retails     direct link is Yes                          CSD006
     C     WUCRTP        IFEQ      'Y'                                                         CSD00
     C                   MOVEL     'R'           WUWFG1                                        CSD00
     C                   ELSE                                                                  CSD00
      * CASE: WRK.Midas/Swift direct link is Yes                          CSD006
     C     WUMSDL        IFEQ      'Y'                                                         CSD00
     C                   MOVEL     'W'           WUWFG1                                        CSD00
     C                   ELSE                                                                  CSD00
      * CASE: WRK.Funds Transfer is Yes                                   CSD006
     C     WUFDTR        IFEQ      'Y'                                                         CSD00
     C                   MOVEL     'F'           WUWFG1                                        CSD00
     C                   ELSE                                                                  CSD00
      * CASE: WRK.Securities is Yes                                       CSD006
     C     WUSECS        IFEQ      'Y'                                                         CSD00
     C                   MOVEL     'S'           WUWFG1                                        CSD00
     C                   ELSE                                                                  CSD00
      * CASE: WRK.Dealing: FX is Yes                                      CSD006
     C     WUDLFX        IFEQ      'Y'                                                         CSD00
     C                   MOVEL     'D'           WUWFG1                                        CSD00
     C                   ELSE                                                                  CSD00
      * CASE: *OTHERWISE                                                  CSD006
     C                   GOTO      DCEXIT                                                      CSD00
     C                   ENDIF                                                                 CSD00
     C                   ENDIF                                                                 CSD00
     C                   ENDIF                                                                 CSD00
     C                   ENDIF                                                                 CSD00
     C                   ENDIF                                                                 CSD00
     C                   ENDIF                                                                 CSD00
     C                   ELSE                                                                  CSD00
      * CASE: *OTHERWISE                                                  CSD006
     C**********           MOVEL'N'       WUCNLP                                       CSD006 CER001
     C                   MOVEL     'L'           WUWFG1
     C                   ENDIF                                                                 CSD00
     C                   ENDIF                                                                 CSD00
     C                   ENDIF                                                                 CSD00
     C                   ENDIF                                                                 CSD00
     C                   ELSE                                                                  CSD00
      * CASE: *OTHERWISE                                                  CSD006
     C**********           MOVEL'N'       WUCNLP                                       CSD006 CER001
     C                   MOVEL     'L'           WUWFG1
     C                   ENDIF                                                                 CSD00
     C                   ENDIF                                                                 CSD00
      * End of CSD006                                                     CSD006
      *                                                                                       CER001
      * Call SD0038 if switchable feature ULX043 is on                                        CER001
     C     WUWFG1        IFEQ      'L'
     C     ULX043        IFEQ      'Y'
     C                   MOVEL     #1CYCD        #1CYCO
     C                   CALL      'SD0038'
     C                   PARM                    RTCODE
     C                   PARM      P2ANCD        ACTION
     C                   PARM                    DATALX
     C                   PARM                    W0RTN
     C                   PARM      *BLANK        WP0003            5
     C                   PARM                    WCOMMS
      *                                                                                       CER001
      * CASE: PGM.*Return code is *DBF update error                                           CER001
     C     W0RTN         IFEQ      'Y2U0004'
     C                   MOVEL     W0RTN         P0RTN
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PGM.*Return code is *User QUIT requested                                        CER001
     C     W0RTN         IFEQ      'Y2U9999'
     C                   MOVEL     W0RTN         P0RTN
     C                   EXSR      ZYEXPG
     C                   ELSE
      *                                                                                       CER001
      * CASE: PGM.*Return code is *Previous Screen                                            CER001
     C     W0RTN         IFEQ      'USR0790'
      *                                                                                       CER001
      * CASE: WRK.Market Data Feed is Yes                                                     CER001
     C     CSD006        IFEQ      'Y'
     C     CAP057        OREQ      'Y'
     C     CAP058        OREQ      'Y'
     C     CAP059        OREQ      'Y'
     C                   MOVEL     'M'           WUWFG1
     C                   ELSE
      * CASE: WRK.Private Banking is Yes                                                      CER001
     C     WUN4ST        IFEQ      'Y'
     C                   MOVEL     'P'           WUWFG1
     C                   ELSE
      * CASE: WRK.Retails     direct link is Yes                                              CER001
     C     WUCRTP        IFEQ      'Y'
     C                   MOVEL     'R'           WUWFG1
     C                   ELSE
      * CASE: WRK.Midas/Swift direct link is Yes                                              CER001
     C     WUMSDL        IFEQ      'Y'
     C                   MOVEL     'W'           WUWFG1
     C                   ELSE
      * CASE: WRK.Funds Transfer is Yes                                                       CER001
     C     WUFDTR        IFEQ      'Y'
     C                   MOVEL     'F'           WUWFG1
     C                   ELSE
      * CASE: WRK.Securities is Yes                                                           CER001
     C     WUSECS        IFEQ      'Y'
     C                   MOVEL     'S'           WUWFG1
     C                   ELSE
      * CASE: WRK.Dealing: FX is Yes                                                          CER001
     C     WUDLFX        IFEQ      'Y'
     C                   MOVEL     'D'           WUWFG1
     C                   ELSE
      * CASE: Otherwise                                                                       CER001
     C                   GOTO      DCEXIT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CER001
     C                   ELSE
     C**********           MOVEL'N'       WUCNLP                                       CER001 CMG003
     C                   MOVEL     'C'           WUWFG1
     C                   ENDIF
      *                                                                                       CER001
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CER001
     C                   ELSE
     C**********           MOVEL'N'       WUCNLP                                       CER001 CMG003
     C                   MOVEL     'C'           WUWFG1
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CER001
      ** Call Commodity Details Maintenance                                                   CMG003
      *                                                                                       CMG003
     C     WUWFG1        IFEQ      'C'
     C     CMG003        IFEQ      'Y'
     C     #1PMRT        ANDEQ     'Y'
     C                   CLEAR                   PGRC
     C                   MOVEL     #1CYCD        PGCYCD
      *                                                                                       CMG003
     C                   CALL      'SD002101'                           90
     C                   PARM      *BLANK        W0RTN
     C                   PARM                    PGRC
     C                   PARM      WUFNSC        WQ0331            1
     C                   PARM      P2ANCD        WQ0332            1
     C                   PARM                    WOCURR
      *                                                                                       CMG003
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG
     C                   MOVEL     'SD002101'    W0CLPG
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   END
      *                                                                                       CMG003
      ** Error detected?                                                                      CMG003
      *                                                                                       CMG003
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99
     C                   END
      *                                                                                       CMG003
      ** CASE: PGM.*Return code is *DBF update error                                          CMG003
      *                                                                                       CMG003
     C     W0RTN         IFEQ      'Y2U0004'
     C                   MOVEL     'Y2U0004'     P0RTN
     C                   EXSR      ZYEXPG
     C                   ELSE
      *                                                                                       CMG003
      ** CASE: PGM.*Return code is *User QUIT requested                                       CMG003
      *                                                                                       CMG003
     C     W0RTN         IFEQ      'Y2U9999'
     C                   MOVEL     'Y2U9999'     P0RTN
     C                   EXSR      ZYEXPG
     C                   ELSE
      *                                                                                       CMG003
      ** CASE: PGM.*Return code is &Delete                                                    CMG003
      *                                                                                       CMG003
     C     W0RTN         IFEQ      'DEL'
     C                   MOVEL     'N'           WUCNLP
     C                   MOVEL     'S'           WUWFG1
     C                   ELSE
      *                                                                                       CMG003
      ** CASE: PGM.*Return code is *Previous Screen                                           CMG003
      *                                                                                       CMG003
     C     W0RTN         IFEQ      'USR0790'
     C                   MOVEL     *BLANKS       WUWFG1
      *                                                                                       CMG003
     C                   SELECT
     C     ULX043        WHENEQ    'Y'
     C     WUNWST        ANDEQ     'Y'
     C                   MOVEL     'L'           WUWFG1
     C     CSD006        WHENEQ    'Y'
     C     CAP057        OREQ      'Y'
     C     CAP058        OREQ      'Y'
     C     CAP059        OREQ      'Y'
     C     WUWFG1        ANDEQ     *BLANKS
     C                   MOVEL     'M'           WUWFG1
     C     WUN4ST        WHENEQ    'Y'
     C     WUWFG1        ANDEQ     *BLANKS
     C                   MOVEL     'P'           WUWFG1
     C     WUCRTP        WHENEQ    'Y'
     C     WUWFG1        ANDEQ     *BLANKS
     C                   MOVEL     'R'           WUWFG1
     C     WUMSDL        WHENEQ    'Y'
     C     WUWFG1        ANDEQ     *BLANKS
     C                   MOVEL     'W'           WUWFG1
     C     WUFDTR        WHENEQ    'Y'
     C     WUWFG1        ANDEQ     *BLANKS
     C                   MOVEL     'F'           WUWFG1
     C     WUSECS        WHENEQ    'Y'
     C     WUWFG1        ANDEQ     *BLANKS
     C                   MOVEL     'S'           WUWFG1
     C     WUDLFX        WHENEQ    'Y'
     C     WUWFG1        ANDEQ     *BLANKS
     C                   MOVEL     'D'           WUWFG1
     C                   OTHER
     C                   GOTO      DCEXIT
     C                   ENDSL
      *                                                                                       CMG003
     C                   ELSE
     C                   MOVEL     'N'           WUCNLP
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     'N'           WUCNLP
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CMG003
     C                   END                                                    *ITR
      * CASE: PGM.*Return code is &Delete
     C     W0RTN         IFEQ      'DEL'                                        *IF
     C                   MOVEL     'Y'           WUDELF                         Delete Flag
     C                   END                                                    *FI
      *                                                                                       CSD012
      * If CSD012 is On and Currency Detail Authorisation is On                               CSD012
      * skip next processing and leave.                                                       CSD012
 B1  C     CSD012        IFEQ      'Y'
     C     SVAL11        ANDEQ     'Y'
      *                                                                                       CSD012
      * If in Amend mode then need to compare the original record                             CSD012
      * on SDCURRPD and the new record on SDCUSHPD. If not changed                            CSD012
      * then delete from SDAULGPD and SDCUSHPD.                                               CSD012
 B2  C     P2ANCD        IFEQ      'A'
      *                                                                                       CSD031
      ** If Acceptance mode, access acceptance file SDACURL0                                  CSD031
     C     CSD043        IFEQ      'Y'
     C     PACCPT        ANDEQ     'A'
     C     #1CYCD        CHAIN     SDCURRD0                           90
     C                   ELSE
     C     #1CYCD        CHAIN     @A6REA3                            90
     C                   ENDIF
      *                                                                                       CSD012
      * Last change date and type of last change to be the                                    CSD012
      * same as on Shadow file.                                                               CSD012
     C                   MOVE      'A'           A6TYLC
     C                   Z-ADD     BJRDNB        A6LCD
     C                   MOVEL     @1DBRC        #1DBRC
     C     #1CYCD        CHAIN     SDCUSHL0                           90
      *                                                                                       CSD012
      * If record found on SDCUSHPD then compare the 2 records                                CSD012
 B3  C     *IN90         IFEQ      *OFF
      *                                                                                       CSD012
      * If no differences then delete from Shadow file SDCUSHPD                               CSD012
     C                   MOVEL     @1DBRC        #2DBRC
      *                                                                                       CMG003
     C     CMG003        IFEQ      'Y'
      *                                                                                       CMG003
     C                   CLEAR                   PHRC
     C                   MOVEL     '-'           PHDASH
     C                   MOVEL     #1CYCD        PHCYCD
     C                   MOVEL     #1SWCY        PHSWCY
      *                                                                                       CMG003
     C     PHRC          CHAIN     SDCMDTD0                           90
      *                                                                                       CMG003
      ** Last change date and type of last change to be the                                   CMG003
      ** same as on Shadow file.                                                              CMG003
      *                                                                                       CMG003
     C                   MOVE      'A'           A6CMLT
     C                   Z-ADD     BJRDNB        A6CMLD
     C                   MOVEL     @1COMM        #1COMM
     C     PHRC          CHAIN     SDCMSHD0                           90
      *                                                                                       CMG003
      ** If record found on SDCMSHPD then compare the 2 records                               CMG003
      *                                                                                       CMG003
     C     *IN90         IFEQ      *OFF
      *                                                                                       CMG003
      ** If no differences then delete from Shadow file SDCMSHPD                              CMG003
      *                                                                                       CMG003
     C                   MOVEL     @1COMM        #2COMM
     C     #1COMM        IFEQ      #2COMM
     C     PGANCD        ANDNE     'D'
     C                   DELETE    SDCMSHD0
     C                   ENDIF
      *                                                                                       CMG003
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CMG003
 B4  C     #1DBRC        IFEQ      #2DBRC
     C     #1COMM        ANDEQ     #2COMM
     C                   DELETE    SDCUSHD0
      *                                                                                       CSD012
      * If differences then write details to Authoristion Log if not found                    CSD012
 X4  C                   ELSE
     C                   MOVEL     #1CYCD        K1CYCD
     C     KAULG         CHAIN     SDAULGL1                           90
 B5  C     *IN90         IFEQ      *ON
     C                   MOVEL     #1CYCD        ALKEY
     C                   MOVEL     FUNCD         ALFUNC
     C                   MOVE      'A'           ALACTN
     C                   MOVE      ##USR         ALUSER
     C                   WRITE     SDAULG1
 E5  C                   ENDIF
      *                                                                                       CSD012
 E4  C                   ENDIF
      *                                                                                       CSD012
 E3  C                   ENDIF
 E2  C                   ENDIF
      *                                                                                       CSD012
      * If Insert mode then write details to Authoristion Log if not found.                   CSD012
 B2  C     P2ANCD        IFEQ      'I'
      *                                                                                       CSD012
     C                   MOVEL     #1CYCD        K1CYCD
     C     KAULG         CHAIN     SDAULGL1                           90
 B3  C     *IN90         IFEQ      *ON
     C                   MOVEL     #1CYCD        ALKEY
     C                   MOVEL     FUNCD         ALFUNC
     C                   MOVE      P2ANCD        ALACTN
     C                   MOVE      ##USR         ALUSER
     C                   WRITE     SDAULG1
 E3  C                   ENDIF
 E2  C                   ENDIF
      *                                                                                       CSD012
      * If Delete requested then write details to Authoristion Log                            CSD012
 B2  C     WUDELF        IFEQ      'Y'
     C                   EXSR      SXDLRC
 E2  C                   ENDIF
      *                                                                                       CSD012
     C                   GOTO      END012
 E1  C                   ENDIF
      *                                                                                       CSD012
      * S01319 - remove call to SD0022U (CMSDULL background update)
      * CASE: WRK.Main Currency Edit Ind. is Yes
     C     WUMCEI        IFEQ      '**YES**'                                    *IF
      * Start of Fix E19254
     C                   MOVEL     P2ANCD        #1TYLC                         Type of Last Ch
      * End of Fix E19254
      * RTV for Chg, Add or Del - Currency Codes  *
     C                   EXSR      SVRVGN
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     '*ERROR*'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.Delete Flag is equal to YES
     C     WUDELF        IFEQ      'Y'                                          *IF
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * Write First Screen - Currency Codes  *
     C*
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT2
     C                   WRITE     #RCDDTL1
     C                   END                                                    *FI
      * Delete Currency Codes - Currency Codes  *
     C                   EXSR      SXDLRC
     C                   END                                                    *FI
      * CASE: PGM.*Return code is *Normal
     C     W0RTN         IFEQ      *BLANK                                       *IF
      * Create new record on PF/RECCYD if Retail Module is on             179232
     C     WURTBN        IFEQ      'Y'                                          *IF            17923
     C                   EXSR      REICD                                                       17923
     C                   ENDIF                                                  *FI            17923
     C     END012        TAG
     C                   COMMIT
     C                   MOVEL     *BLANK        P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   END                                                    *FI
      * /COPY.
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RVSR - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RVSR
     C*
     C                   END                                                    *FI
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   EBPR##        BEGSR
      *================================================================
      * Process record:
      *================================================================
      * Process delete request
     C   10              CAS                     EDDLRQ
      * Process add request
     C     W0PMD         CASEQ     'ADD'         ECADRQ
      * Process update request
     C     W0PMD         CASNE     'ADD'         EECHRQ
     C                   END
     C     W0RTN         IFNE      *BLANK
      * Error: ROLLBACK any DBF changes
     C                   ROLBK
     C                   GOTO      EBEXIT
     C                   ELSE
      * Otherwise COMMIT any DBF changes
     C                   COMMIT
     C                   END
     C     W0RTN         IFEQ      *BLANK
      * USER: Process command keys
      * /COPY.
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RPCK - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RPCK
     C*
     C                   END                                                    *FI
     C     W0PMD         IFEQ      'ADD'
      * Exit after successful add
     C                   MOVEL     'N'           W0RPT
     C                   END
      * Restart program for next record
     C                   MOVEL     'N'           W0TRN
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request
      *================================================================
      * USER: Create DBF record
      * Create Currency Codes -LR - Currency Codes  *
     C                   EXSR      TACRRC
     C     W0RTN         IFEQ      *BLANK
      * Send message '*Record added'
     C                   MOVEL     'Y2U0011'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   ECEXIT        ENDSR
      /EJECT
     CSR   EDDLRQ        BEGSR
      *================================================================
      * Process delete request
      *================================================================
      * USER: Delete DBF record
      * Delete Currency Codes - Currency Codes  *
     C                   EXSR      TBDLRC
     C     W0RTN         IFEQ      *BLANK
      * Send message '*Record deleted'
     C                   MOVEL     'Y2U0013'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   EDEXIT        ENDSR
      /EJECT
     CSR   EECHRQ        BEGSR
      *================================================================
      * Process update request
      *================================================================
      * USER: Change DBF record
      * Change Currency Codes -LR - Currency Codes  *
     C                   EXSR      TECHRC
     C     W0RTN         IFNE      *BLANK
      * Data update error
      * Reset screen fields if changed record
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1
     C                   END
     C                   ELSE
      * Send message '*Record changed'
     C                   MOVEL     'Y2U0012'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   EEEXIT        ENDSR
      /EJECT
     CSR   FACKPM        BEGSR
      *================================================================
      * Check passed parameters
      *================================================================
      * Is full key present?
     C     P1CYCD        IFEQ      *BLANK                                       Currency Code
      * Not every key field passed - loop program
     C                   MOVEL     'Y'           W0RPT             1
     C                   ELSE
      * Full key passed, so single shot program
     C                   MOVEL     'N'           W0RPT
     C                   END
      *================================================================
     CSR   FAEXIT        ENDSR
      /EJECT
     CSR   GADSAK        BEGSR
      *================================================================
      * Set key screen conditioning indicators
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSAD        BEGSR
      *================================================================
      * Set detail screen conditioning indicators
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      * Protect key fields on detail screen
     C                   SETON                                        88        *
     C                   MOVEL     '0'           *IN79
     C                   MOVEL     '0'           *IN62
     C     WUNOAL        IFEQ      '*NOAMD*'                                    *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
      *                                                                                      BUG2811
      ** Protect Spot rate fields on amend mode.                                             BUG2811
      *                                                                                      BUG2811
     C     P2ANCD        IFEQ      'A'
     C                   MOVEL     '1'           *IN62
     C                   ENDIF
      *                                                                                      BUG2811
     C                   MOVEL     '0'           *IN78
     C     WUDRTS        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN78
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN77
     C     WURKMG        IFEQ      *BLANK                                       *IF
     C     WURKMG        OREQ      'N'
     C                   MOVEL     '1'           *IN77
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN76
     C/COPY WNCPYSRC,SD0021RC06
     C     WUSARF        IFEQ      'N'                                          *IF
     C     CSW212        ANDEQ     'N'
     C                   MOVEL     '1'           *IN76
     C                   END                                                    *FI
     C/COPY WNCPYSRC,SD0021RC07
     C                   MOVEL     '0'           *IN75
     C     WUPFMG        IFEQ      *BLANK                                       *IF
     C     WUPFMG        OREQ      'N'
     C                   MOVEL     '1'           *IN75
     C                   END                                                    *FI
      * Enable key screen
     C                   SETON                                        87        *
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise record - except for key fields and "neither" paramete
      *================================================================
     C                   Z-ADD     *ZERO         #1NBDP                         Number of Decim
     C                   Z-ADD     *ZERO         #1TXND                         Telex Notice Da
     C                   Z-ADD     *ZERO         #1SSNB                         Sort Sequence N
     C                   Z-ADD     *ZERO         #1SPRT                         Spot Rate
     C                   Z-ADD     *ZERO         #1PRRT                         Par Rate
     C                   Z-ADD     *ZERO         #1RMCM                         RM Cashflow Mag
     C                   MOVEL     *BLANK        #1MDEX                         Multiply/Divide
     C                   Z-ADD     *ZERO         #1HBRT                         Historic Broker
     C                   MOVEL     *BLANK        #1CDFN                         Cedel Default N
     C                   MOVEL     *BLANK        #1ECDN                         Euroclear Defau
     C                   Z-ADD     *ZERO         #1LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #1TYLC                         Type of Last Ch
     C                   MOVEL     *BLANK        #1NOSN                         Nostro Shortnam
     C                   Z-ADD     *ZERO         #1SPDY                         Spot Days
     C                   Z-ADD     *ZERO         #1SCEX                         Scaling Exponen
     C                   Z-ADD     *ZERO         #1HSRT                         High Spot Rate
     C                   Z-ADD     *ZERO         #1LSPR                         Low Spot Rate
     C                   Z-ADD     *ZERO         #1FXSD                         DRS FX Spot Dat
     C                   Z-ADD     *ZERO         #1MMSD                         DRS MM Spot Dat
     C                   MOVEL     *BLANK        #1DICB                         Default Int. Ca
     C                   Z-ADD     *ZERO         #1NQDP                         Normally Quoted
     C                   MOVEL     *BLANK        #1EBDA                         Eurobond Data
     C                   Z-ADD     *ZERO         #1ENC1                         Euroclear Numer
     C                   Z-ADD     *ZERO         #1ENC2                         Euroclear Numer
     C                   MOVEL     *BLANK        #1CACD                         Cedel Alpha Cod
     C                   Z-ADD     *ZERO         #1CNMC                         Cedel Numeric C
     C                   MOVEL     *BLANK        #1MONH                         MON. Holiday
     C                   MOVEL     *BLANK        #1TUEH                         TUES. Holiday
     C                   MOVEL     *BLANK        #1WEDH                         WED. Holiday
     C                   MOVEL     *BLANK        #1THUH                         THURS. Holiday
     C                   Z-ADD     *ZERO         #1SRC1                         Statutory Retur
     C                   Z-ADD     *ZERO         #1SRC2                         Statutory Retur
     C                   Z-ADD     *ZERO         #1DPBF                         Dec.Places in B
     C                   Z-ADD     *ZERO         #1BYSR                         Buy Spread Rate
     C                   MOVEL     *BLANK        #1BYSS                         Buy Spread Sign
     C                   Z-ADD     *ZERO         #1SLSR                         Sell Spread Rat
     C                   MOVEL     *BLANK        #1SLSS                         Sell Spread Sig
     C                   MOVEL     *BLANK        #1RECI                         Record Id
     C                   MOVEL     *BLANK        #1DPRU                         Default Priorit
     C                   MOVEL     *BLANK        #1DNOR                         Delivery Notifi
     C                   MOVEL     *BLANK        #1NDWR                         Non-Delivery Wa
     C                   MOVEL     *BLANK        #1GMPY                         Generate Multip
     C                   MOVEL     *BLANK        #1DLCD                         Delivery Code
     C                   Z-ADD     *ZERO         #1RKSQ                         Currency Rankin
     C                   MOVEL     *BLANK        #1DDPC                         Dft Dir Fund Pr
     C                   MOVEL     *BLANK        #1DFPC                         Dft Fx Poss Pro
     C                   Z-ADD     *ZERO         #1TKCC                         Telekurs Curren
     C                   Z-ADD     *ZERO         #1CQCD                         Cheque Clearing
     C                   Z-ADD     *ZERO         #1SMLD                         Smallest Denomi
     C                   MOVEL     *BLANK        #1CSCD                         Cash Account Co
     C                   Z-ADD     *ZERO         #1ISON                         Numeric ISO Cur
     C                   MOVEL     *BLANK        #1ISFC                         ISDA Financial
     C                   MOVEL     *BLANK        #1MACD                         Major Currency
     C                   MOVEL     *BLANK        #1FRAC                         Fractions Flag
     C                   MOVEL     *BLANK        #1NUWD                         Numbers and Wor
     C                   MOVEL     *BLANK        #1MICD                         Minor Currency
     C                   MOVEL     *BLANK        #1CYNM                         Currency Name
     C                   MOVEL     *BLANK        #DNDPA                         No. of Dec. Pla
     C                   MOVEL     *BLANK        #1SWCY                         Swift Currency
     C                   MOVEL     *BLANK        #DTNDA                         Telex Notice Da
     C                   MOVEL     *BLANK        #1DLCI                         Dealing Currenc
     C                   MOVEL     *BLANK        #DSSQA                         Sort Sequence a
     C                   MOVEL     *BLANK        #DSPRA                         Spot Rate alpha
     C                   MOVEL     *BLANK        #1MDIN                         Multiply/Divide
     C                   MOVEL     *BLANK        #DNICS                         Numeric ISO Cur
     C                   MOVEL     *BLANK        #DPRTA                         Par Rate alpha
     C                   MOVEL     *BLANK        #1MDPR                         Multiply/Divide
     C                   Z-ADD     *ZERO         #1ERLC                         Exchange Rate -
     C                   MOVEL     *BLANK        #DLRMI                         Limit Rate Mult
     C                   MOVEL     *BLANK        #DRMCF                         RM cashflow mag
     C                   MOVEL     *BLANK        #DFTRA                         FT Rate alpha
     C                   MOVEL     *BLANK        #1MDHB                         Multiply/Divide
     C                   MOVEL     *BLANK        #1SPAE                         Spot Trade Acco
     C                   MOVEL     *BLANK        #1FTAE                         Fwd Trade Accou
     C                   MOVEL     *BLANK        #1TAC4                         Trade Account C
     C                   MOVEL     *BLANK        #1SWAE                         Swap Trade Acco
     C                   MOVEL     *BLANK        #1TAC5                         Trade Account C
     C                   MOVEL     *BLANK        #1FRIH                         FRI. Holiday
     C                   MOVEL     *BLANK        #1SATH                         SAT. Holiday
     C                   MOVEL     *BLANK        #1SUNH                         SUN. Holiday
     C                   MOVEL     *BLANK        #DSC1S                         Statutory Retur
     C                   MOVEL     *BLANK        #DSC2S                         Statutory Retur
     C                   MOVEL     *BLANK        #1RDFC                         Round Down Inte
     C                   MOVEL     *BLANK        #1PMRT                         Precious Metal
     C                   MOVEL     *BLANK        #DCRSQ                         Currency Rankin
     C                   MOVEL     *BLANK        #1DLOC                         Dflt.Loc.Code  CSW09
     C                   MOVEL     *BLANK        #1CLSC                         CLS Currency   CDL00
     C                   Z-ADD     *ZERO         #1EFDT                         Effective Date CDL00
     C                   MOVEL     *BLANK        #DEFDT                         Effective Date CDL00
     C                   MOVEL     *BLANK        #1SETD
     C                   MOVEL     *BLANK        #1IRDP
     C     CSD043        IFEQ      'Y'
     C                   MOVEL     *BLANK        #1CENT
     C                   MOVEL     *BLANK        #1EFDZ
     C                   ENDIF
      *                                                                                       CGL014
     C     CGL014        IFEQ      'Y'
     C     CLE025        OREQ      'Y'
     C     WUN4ST        OREQ      'Y'
     C                   MOVEL     *BLANKS       #1EXWC
     C                   MOVEL     *BLANKS       #1POWC
     C                   ENDIF
      *                                                                                       CGL014
     C     CER043        IFEQ      'Y'
     C                   MOVE      *BLANKS       #DRETP
     C                   ENDIF
      *                                                                                       CER043
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @A6REA3 fields to screen
      *================================================================
     C                   Z-ADD     A6NBDP        #1NBDP                         Number of Decim
     C                   Z-ADD     A6TXND        #1TXND                         Telex Notice Da
     C                   Z-ADD     A6SSNB        #1SSNB                         Sort Sequence N
     C                   Z-ADD     A6SPRT        #1SPRT                         Spot Rate
     C                   Z-ADD     A6PRRT        #1PRRT                         Par Rate
     C                   Z-ADD     A6RMCM        #1RMCM                         RM Cashflow Mag
     C                   MOVEL     A6MDEX        #1MDEX                         Multiply/Divide
     C                   Z-ADD     A6HBRT        #1HBRT                         Historic Broker
     C                   MOVEL     A6CDFN        #1CDFN                         Cedel Default N
     C                   MOVEL     A6ECDN        #1ECDN                         Euroclear Defau
     C                   Z-ADD     A6LCD         #1LCD                          Last Change Dat
     C                   MOVEL     A6TYLC        #1TYLC                         Type of Last Ch
     C                   MOVEL     A6NOSN        #1NOSN                         Nostro Shortnam
     C                   Z-ADD     A6SPDY        #1SPDY                         Spot Days
     C                   Z-ADD     A6SCEX        #1SCEX                         Scaling Exponen
     C                   Z-ADD     A6HSRT        #1HSRT                         High Spot Rate
     C                   Z-ADD     A6LSPR        #1LSPR                         Low Spot Rate
     C                   Z-ADD     A6FXSD        #1FXSD                         DRS FX Spot Dat
     C                   Z-ADD     A6MMSD        #1MMSD                         DRS MM Spot Dat
     C                   MOVEL     A6DICB        #1DICB                         Default Int. Ca
     C                   Z-ADD     A6NQDP        #1NQDP                         Normally Quoted
     C                   MOVEL     A6EBDA        #1EBDA                         Eurobond Data
     C                   Z-ADD     A6ENC1        #1ENC1                         Euroclear Numer
     C                   Z-ADD     A6ENC2        #1ENC2                         Euroclear Numer
     C                   MOVEL     A6CACD        #1CACD                         Cedel Alpha Cod
     C                   Z-ADD     A6CNMC        #1CNMC                         Cedel Numeric C
     C                   MOVEL     A6MONH        #1MONH                         MON. Holiday
     C                   MOVEL     A6TUEH        #1TUEH                         TUES. Holiday
     C                   MOVEL     A6WEDH        #1WEDH                         WED. Holiday
     C                   MOVEL     A6THUH        #1THUH                         THURS. Holiday
     C                   Z-ADD     A6SRC1        #1SRC1                         Statutory Retur
     C                   Z-ADD     A6SRC2        #1SRC2                         Statutory Retur
     C                   Z-ADD     A6DPBF        #1DPBF                         Dec.Places in B
     C                   Z-ADD     A6BYSR        #1BYSR                         Buy Spread Rate
     C                   MOVEL     A6BYSS        #1BYSS                         Buy Spread Sign
     C                   Z-ADD     A6SLSR        #1SLSR                         Sell Spread Rat
     C                   MOVEL     A6SLSS        #1SLSS                         Sell Spread Sig
     C                   MOVEL     A6RECI        #1RECI                         Record Id
     C                   MOVEL     A6DPRU        #1DPRU                         Default Priorit
     C                   MOVEL     A6DNOR        #1DNOR                         Delivery Notifi
     C                   MOVEL     A6NDWR        #1NDWR                         Non-Delivery Wa
     C                   MOVEL     A6GMPY        #1GMPY                         Generate Multip
     C                   MOVEL     A6DLCD        #1DLCD                         Delivery Code
     C                   Z-ADD     A6RKSQ        #1RKSQ                         Currency Rankin
     C                   MOVEL     A6DDPC        #1DDPC                         Dft Dir Fund Pr
     C                   MOVEL     A6DFPC        #1DFPC                         Dft Fx Poss Pro
     C                   Z-ADD     A6TKCC        #1TKCC                         Telekurs Curren
     C                   Z-ADD     A6CQCD        #1CQCD                         Cheque Clearing
     C                   Z-ADD     A6SMLD        #1SMLD                         Smallest Denomi
     C                   MOVEL     A6CSCD        #1CSCD                         Cash Account Co
     C                   Z-ADD     A6ISON        #1ISON                         Numeric ISO Cur
     C                   MOVEL     A6ISFC        #1ISFC                         ISDA Financial
     C                   MOVEL     A6MACD        #1MACD                         Major Currency
     C                   MOVEL     A6FRAC        #1FRAC                         Fractions Flag
     C                   MOVEL     A6NUWD        #1NUWD                         Numbers and Wor
     C                   MOVEL     A6MICD        #1MICD                         Minor Currency
     C                   MOVEL     A6CYCD        #1CYCD                         Currency Code
     C                   MOVEL     A6CYNM        #1CYNM                         Currency Name
     C                   MOVEL     A6SWCY        #1SWCY                         Swift Currency
     C                   MOVEL     A6DLCI        #1DLCI                         Dealing Currenc
     C                   MOVEL     A6MDIN        #1MDIN                         Multiply/Divide
     C                   MOVEL     A6MDPR        #1MDPR                         Multiply/Divide
     C                   Z-ADD     A6ERLC        #1ERLC                         Exchange Rate -
     C                   MOVEL     A6MDHB        #1MDHB                         Multiply/Divide
     C                   MOVEL     A6SPAE        #1SPAE                         Spot Trade Acco
     C                   MOVEL     A6FTAE        #1FTAE                         Fwd Trade Accou
     C                   MOVEL     A6TAC4        #1TAC4                         Trade Account C
     C                   MOVEL     A6SWAE        #1SWAE                         Swap Trade Acco
     C                   MOVEL     A6TAC5        #1TAC5                         Trade Account C
     C                   MOVEL     A6FRIH        #1FRIH                         FRI. Holiday
     C                   MOVEL     A6SATH        #1SATH                         SAT. Holiday
     C                   MOVEL     A6SUNH        #1SUNH                         SUN. Holiday
     C                   MOVEL     A6RDFC        #1RDFC                         Round Down Inte
     C                   MOVEL     A6PMRT        #1PMRT                         Precious Metal
     C                   MOVEL     A6DLOC        #1DLOC                         Dflt Loc code  CSW09
     C                   MOVEL     A6CLSC        #1CLSC                         CLS Currency   CDL00
     C                   Z-ADD     A6EFDT        #1EFDT                         Effectivd Date CDL00
     C                   MOVEL     A6SETD        #1SETD
     C                   MOVEL     A6IRDP        #1IRDP
      *                                                                                       CGL014
     C     CGL014        IFEQ      'Y'
     C     CLE025        OREQ      'Y'
     C     WUN4ST        OREQ      'Y'
      *                                                                                       CGL014
     C     A6EXWC        IFEQ      *ZEROS
     C                   MOVEL     *BLANKS       #1EXWC
     C                   ELSE
     C                   MOVEL     A6EXWC        #1EXWC
     C                   ENDIF
      *                                                                                       CGL014
     C     A6POWC        IFEQ      *ZEROS
     C                   MOVEL     *BLANKS       #1POWC
     C                   ELSE
     C                   MOVEL     A6POWC        #1POWC
     C                   ENDIF
      *                                                                                       CGL014
     C                   ENDIF
      *                                                                                       CGL014
     C     CSD043        IFEQ      'Y'
      *                                                                                       CSD031
      ** Effective Date                                                                       CSD031
      *                                                                                       CSD031
     C     A6EACC        IFEQ      0
     C                   MOVE      *BLANKS       #1EFDZ
     C                   ELSE
      *                                                                                       CSD031
      ** format Effective Date                                                                CSD031
      *                                                                                       CSD031
     C                   MOVE      WUDFF         ZDATFM
     C                   MOVE      A6EACC        ZDAYNO
     C                   EXSR      SRDAT2
     C                   MOVE      ZADATE        #1EFDZ
     C                   ENDIF
     C*          PACCPT    IFEQ 'A'                                                           CSD031
     C                   MOVE      A6GPDT        AAGPDT
     C                   MOVE      ZADATE        #1EFDZ
     C                   MOVE      A6EACC        AAEACC
     C                   MOVE      A6GPDT        #1CENT
     C*                    ENDIF                                                              CSD031
     C                   ENDIF
      *                                                                                       CSD031
     C     PACCPT        IFEQ      'A'
     C                   MOVE      BJDFIN        ZDATFM
     C                   MOVE      BJRDNB        ZDAYNO
     C                   EXSR      SRDAT2
     C                   MOVE      ZADATE        #1EFDZ
     C                   ENDIF
      * Hold existing record image
     C                   MOVEL     @1DBRC        #1DBRC
      *                                                                                       CER043
     C     CER043        IFEQ      'Y'
     C                   MOVE      A6RETP        #1RETP
     C                   ENDIF
      *                                                                                       CER043
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialize key screen
      *================================================================
     C                   MOVEL     P1CYCD        #1CYCD                         Currency Code
      * USER: Initialize key screen
      * Set-up KEY Screen Footer - Standard Functions  *
     C*
     C* KEY LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C* Setup footer text:
     C* F3=Previous
     C                   MOVEL     'USR3345'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C*
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RIKS - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RIKS
     C*
     C                   END                                                    *FI
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   REICD         BEGSR                                                                 17923
      *================================================================   179232
      * Insert a new record on Retail ICD file PF/RECCYD                  179232
      *================================================================   179232
     C                   OPEN      RECCY                                                       17923
     C                   OPEN      RECCYDXC                                                    17923
      *                                                                                       201500
     C     *IN60         IFEQ      '0'
     C                   OPEN      RECCYZ                                                      17923
     C                   MOVE      '1'           *IN60
     C                   ENDIF
      * Setup key for RECCY                                               179232
     C                   MOVEL     *BLANKS       RECKEY                                        17923
     C                   MOVEL     #1CYCD        W#CYCD                                        17923
     C                   MOVEL     'D'           W#FILL                                        17923
      * Check if record already exists                                    179232
     C     RECKEY        CHAIN     RECCY                              90                       17923
     C     *IN90         IFEQ      *ON                                          *IF            17923
     C     *IN90         OREQ      *OFF                                         *              17923
     C     RECI          ANDEQ     '*'                                          *              17923
      * Setup a record on RECCYD with default values                      179232
     C                   MOVEL     'D'           RECI                           Record ID      17923
     C                   MOVEL     RECKEY        KEY                                           17923
     C                   MOVEL     *BLANKS       ZZ017                          Filler         17923
     C                   Z-ADD     WURDNB        ORED                           Orig entry date17923
     C                   Z-ADD     WURDNB        LCD                            Last chg dat   17923
     C                   MOVEL     'I'           CHTP                           Change type    17923
     C                   Z-ADD     0             HASH                           Hash field     17923
     C                   Z-ADD     0             MIDC                           Min dr int     17923
     C                   Z-ADD     *ALL'9'       MADC                           Max dr int     17923
     C                   Z-ADD     0             MICC                           Min cr int     17923
     C                   Z-ADD     *ALL'9'       MACC                           Max cr int     17923
     C                   MOVEL     *BLANKS       ZZ053                          Filler         17923
     C                   Z-ADD     0             HORT                           Highest O/D rat17923
     C                   Z-ADD     0             HOMN                           Highest O/D min17923
     C                   Z-ADD     *ALL'9'       HOMX                           Highest O/D max17923
     C                   Z-ADD     0             ACRT                           Account - rate 17923
     C                   Z-ADD     0             ACMN                           Account - min  17923
     C                   Z-ADD     *ALL'9'       ACMX                           Account - max  17923
     C                   Z-ADD     0             DIRT                           Debit int rate 17923
     C                   Z-ADD     0             DIMN                           Debit int - min17923
     C                   Z-ADD     *ALL'9'       DIMX                           Debit int - max17923
     C                   Z-ADD     0             INFC                           Inactive rate  17923
     C                   Z-ADD     0             MCFC                           Min balance    17923
     C                   Z-ADD     0             AMBC                           Ave min balance17923
     C                   Z-ADD     0             MSFC                           Min balance    17923
     C                   Z-ADD     0             AMBS                           Ave min balance17923
     C                   Z-ADD     0             DSFC                           Daily statement17923
     C                   Z-ADD     0             DSMN                           Daily stmts-min17923
     C                   Z-ADD     0             DSMX                           Daily stmts-max17923
     C                   Z-ADD     0             FCFC                           Fixed commissio17923
     C                   Z-ADD     0             AMO1                           Ccy amt int 1  17923
     C                   Z-ADD     0             AMO2                           Ccy amt int 2  17923
     C                   Z-ADD     0             AMO3                           Ccy amt int 3  17923
     C                   Z-ADD     0             AMO4                           Ccy amt int 4  17923
     C                   Z-ADD     0             AMO5                           Ccy amt int 5  17923
     C                   Z-ADD     0             AMO6                           Ccy amt int 6  17923
     C                   Z-ADD     0             AMO7                           Ccy amt int 7  17923
     C                   Z-ADD     0             AMO8                           Ccy amt int 8  17923
     C                   Z-ADD     0             CMNR                           Main rate      17923
     C                   Z-ADD     0             CMNP                           Main prev rate 17923
     C                   Z-ADD     0             CMNV                           Main Value Date17923
     C                   Z-ADD     0             CADR                           Additional rate17923
     C                   Z-ADD     0             CADP                           Addit prev rate17923
     C                   Z-ADD     0             CADV                           Addit Val Date 17923
     C                   MOVEL     *BLANKS       ZZ175                          Filler         17923
      * Obtain 'Transaction no. of last update'                           179232
     C     *DTAARA       DEFINE    MNATN         DNATN                                         17923
     C     *LOCK         IN        DNATN                                                       17923
     C                   MOVE      FNATN         ZZWK05            5 0                         17923
     C                   ADD       1             ZZWK05                                        17923
     C                   MOVE      ZZWK05        FNATN                                         17923
     C                   OUT       DNATN                                                       17923
     C                   Z-ADD     FNATN         TNLU                                          17923
      * Update file RECCYD if record found, else insert new record        179232
     C     *IN90         IFEQ      *OFF                                         *IF            17923
     C                   UPDATE    RECCYDF                                                     17923
     C                   MOVE      '0'           *IN85
     C                   ELSE                                                                  17923
     C                   WRITE     RECCYDF                                                     17923
     C                   MOVE      '1'           *IN85
     C                   ENDIF                                                  *FI            17923
      * Setup record in extension file RECCYDX with default values        179232
     C                   MOVEL     #1CYCD        RYCCYD                         Currency code  17923
     C                   Z-ADD     0             RYCHGC                         Demand statment17923
     C                   Z-ADD     0             RYCHGD                         Daily statment 17923
     C                   Z-ADD     0             RYCHGW                         Weekly statemen17923
     C                   Z-ADD     0             RYCHGF                         Fortnight stmt 17923
     C                   Z-ADD     0             RYCHGS                         Semi-month stmt17923
     C                   Z-ADD     0             RYCHGM                         Monthly stmt   17923
     C                   Z-ADD     0             RYCHGT                         Bi-monthly stmt17923
     C                   Z-ADD     0             RYCHGB                         Lst working day17923
     C                   Z-ADD     0             RYCHGL                         Lst calender dy17923
     C                   Z-ADD     0             RYCHGA                         Accrual dt stmt17923
     C                   Z-ADD     0             RYCHGQ                         Quarterly stmt 17923
     C                   Z-ADD     0             RYCHGX                         Six-month stmt 17923
     C                   Z-ADD     0             RYCHGY                         Yearly stmt    17923
     C                   Z-ADD     0             RYACCH                         Fixed A/C charg17923
     C                   MOVE      #DNDPA        RYNBDP                         Decimal places 17923
      * Update file RECCYDXC                                              179232
      *                                                                                     MD048483
     C     RYCCYD        CHAIN     RECCYDXC                           68
     C     *IN68         IFEQ      *OFF
     C                   UPDATE    RECCYDD0
     C                   ELSE
     C                   WRITE     RECCYDD0                                                    17923
     C                   ENDIF
      *                                                                                     MD048483
      * Update file trailer file RECCYDZ                                  179232
     C                   READ      RECCYZ                                 90                   17923
     C     *IN90         IFEQ      *ON                                          *IF            17923
      * Record not found                                                  179232
     C                   MOVEL     'Y2U0009'     W0RTN             7                           17923
      * Send message '*Record no longer on file'                          179232
     C                   MOVEL     'Y2U0009'     ZAMSID                                        17923
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        17923
     C                   EXSR      ZASNMS                                                      17923
     C                   GOTO      REEXIT                                                      17923
     C                   ENDIF                                                  *FI            17923
     C                   Z-ADD     FNATN         TNLU                                          17923
     C********** *IN85     IFEQ '1'                                                   201500 BUG8112
     C                   ADD       1             NR1
     C                   ADD       1             NR3
     C**********           ENDIF                                                      201500 BUG8112
     C                   UPDATE    RECCYZF                                                     17923
     C                   ENDIF                                                  *FI            17923
      *================================================================   179232
     CSR   REEXIT        ENDSR                                                                 17923
      /EJECT                                                              179232
     CSR   RXICD         BEGSR                                                                 17923
      *================================================================   179232
      * Delete corresponding record on Retail ICD file PF/RECCYD          179232
      *================================================================   179232
     C                   OPEN      RECCY                                                       17923
     C                   OPEN      RECCYDXC                                                    17923
      *                                                                                       201500
     C     *IN60         IFEQ      '0'
     C                   OPEN      RECCYZ
     C                   MOVE      '1'           *IN60
     C                   ENDIF
      * Setup key for RECCY                                               179232
     C                   MOVEL     *BLANKS       RECKEY                                        17923
     C                   MOVEL     #1CYCD        W#CYCD                                        17923
     C                   MOVEL     'D'           W#FILL                                        17923
      * If record found                                                   179232
     C     RECKEY        CHAIN     RECCY                              90                       17923
     C     *IN90         IFEQ      *OFF                                         *IF            17923
     C                   MOVEL     '*'           RECI                           Record ID      17923
     C                   Z-ADD     WURDNB        LCD                            Last chg dat   17923
     C                   MOVEL     'D'           CHTP                           Change type    17923
      * Update file RECCYD                                                179232
     C                   UPDATE    RECCYDF                                                     17923
      * Remove record from extention file RECCYDXC                        179232
     C     W#CYCD        CHAIN     RECCYDXC                           90                       17923
     C     *IN90         IFEQ      *OFF                                         *IF            17923
     C                   DELETE    RECCYDD0                                                    17923
     C                   ENDIF                                                  *FI            17923
      *                                                                                       201500
     C                   READ      RECCYZ                                 61
     C     *IN61         IFEQ      '0'
     C                   SUB       1             NR1
     C                   ADD       1             NR5
     C                   UPDATE    RECCYZF
     C                   ENDIF
      *                                                                                       201500
     C                   ENDIF                                                  *FI            17923
      *================================================================   179232
     CSR   RXEXIT        ENDSR                                                                 17923
      /EJECT                                                              179232
     CSR   SARVGN        BEGSR
      *================================================================
      * standard retrieve object - Currency Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSA         KLIST
     C                   KFLD                    A6CYCD                         Currency Code
      * Move fields to key list
     C                   MOVEL     #1CYCD        A6CYCD                         Currency Code
      ** If Acceptance mode, access acceptance file SDACURL0                                  CSD031
     C     CSD043        IFEQ      'Y'
     C     PACCPT        IFEQ      'A'
     C     KRSSA         CHAIN     SDCURRD0                           90
     C                   ELSE
     C     KRSSA         CHAIN     @A6REA3                            90
     C                   ENDIF
     C                   ELSE
     C     KRSSA         CHAIN     @A6REA3                            90        *
     C                   ENDIF
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0071'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SAEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBRVGN        BEGSR
      *================================================================
      * Get Base Limits CCY detls - Currency Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSB         KLIST
     C                   KFLD                    A6CYCD                         Currency Code
      * Move fields to key list
     C                   MOVEL     WUBNCD        A6CYCD                         Currency Code
      ** If Acceptance mode, access acceptance file SDACURL0                                  CSD031
     C     CSD043        IFEQ      'Y'
     C     PACCPT        IFEQ      'A'
     C     KRSSB         CHAIN     SDCURRD0                           9091      *
     C                   ELSE
     C     KRSSB         CHAIN     @A6REA3                            90
     C                   ENDIF
     C                   ELSE
     C     KRSSB         CHAIN     @A6REA3                            90        *
     C                   ENDIF
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0071'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     *BLANK        WUBCLF                         Base CCY Limits
     C                   MOVEL     '*NO*'        WUBCLF                         Base CCY Limits
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
      * CASE: DB1.Spot Rate is Blank
     C     A6SPRT        IFEQ      *ZERO                                        *IF
     C                   MOVEL     *BLANK        WUBCLF                         Base CCY Limits
     C                   MOVEL     '*NO*'        WUBCLF                         Base CCY Limits
     C                   ELSE
      * CASE: *OTHERWISE
      * PAR = DB1 By name
     C                   Z-ADD     A6SPRT        WUBRLC                         Spot Rate
     C                   MOVEL     A6MDIN        WUBLCM                         Multiply/Divide
     C                   MOVEL     *BLANK        WUBCLF                         Base CCY Limits
     C                   MOVEL     '*YES*'       WUBCLF                         Base CCY Limits
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCRVGN        BEGSR
      *================================================================
      * Update Limits Rate RTV - Currency Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KPSSC         KLIST
     C                   KFLD                    A6CYCD                         Currency Code
      * Move fields to key list
     C                   MOVEL     'AAA'         A6CYCD                         Currency Code
      *                                                                                       CSD031
      ** If Acceptance mode, access acceptance file SDACURL1                                  CSD031
      *                                                                                       CSD031
     C     CSD043        IFEQ      'Y'
     C     PACCPT        IFEQ      'A'
     C     KPSSC         SETLL     SDCURRD0
     C                   READ      SDCURRD0                               90
     C                   ELSE
     C     KPSSC         SETLL     @A6REA3
     C                   READ      @A6REA3                                90
     C                   ENDIF
     C                   ELSE
     C     KPSSC         SETLL     @A6REA3                                      *
     C                   READ      @A6REA3                                90    *
     C                   ENDIF
      * Data record not found
     C   90              MOVEL     'USR0071'     W0RTN             7
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
      * CASE: PAR.Saved Base Currency NE DB1.Currency Code
     C     WUSVBC        IFNE      A6CYCD                                       *IF
      * CASE: PAR.Saved Base curr for limit NE DB1.Currency Code
     C     WUSVBL        IFNE      A6CYCD                                       *IF
      * CASE: PAR.Saved Multy/Divide Ind EQ DB1.Multiply/Divide Indicator
     C     WUSMDI        IFEQ      A6MDIN                                       *IF
     C     A6SPRT        DIV(H)    WUSSSR        WUERLC                         Exchange Rate -
     C                   ELSE
      * CASE: *OTHERWISE
     C     A6SPRT        MULT(H)   WUSSSR        WUERLC                         Exchange Rate -
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: PAR.Saved Base Currency EQ DB1.Currency Code
     C     WUSVBC        IFEQ      A6CYCD                                       *IF
      * Start of Fix E21210
      * CASE: PAR.Saved Multy/Divide Ind is Multiply amount by rate
     C     WUSMDI        IFEQ      'M'                                          *IF
     C     1             DIV(H)    WUSSSR        WUERLC                         Exchange Rate -
     C                   ELSE
      * CASE: *OTHERWISE
     C     WUSSSR        ADD       *ZERO         WUERLC                         Exchange Rate -
     C                   END                                                    *FI
      * End of Fix E21210
     C                   END                                                    *FI
      * CASE: PAR.Saved Base curr for limit NE DB1.Currency Code
     C     WUSVBL        IFNE      A6CYCD                                       *IF
      * Update Limits Rate CHG - Currency Codes  *
     C                   EXSR      SDCHRC
      * Start of Fix E20297
      * Add processing to check that the update is successful
      * Start of fix S01314
      * call SD0023U with return code parameter
      * UPD Limit Rate Old Files - Currency Codes  *
     C                   CALL      'SD0023U'                            90      UPD Limit Rate
     C     W0RTN         PARM      W0RTN         WQ0059            7            *Return code
     C                   PARM      A6CYCD        WQ0060            3            Currency Code
     C                   PARM      WUERLC        WQ0061           13 8          Exchange Rate -
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0023U'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * End of fix S01314
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
      * Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   END                                                    *FI
      * End of Fix E20297
     C                   END                                                    *FI
      *                                                                                       CSD031
      ** If Acceptance mode, access acceptance file SDACURL1                                  CSD031
      *                                                                                       CSD031
     C     CSD043        IFEQ      'Y'
     C     PACCPT        IFEQ      'A'
     C                   READ      SDCURRD0                               90
     C                   ELSE
     C                   READ      @A6REA3                                90
     C                   ENDIF
     C                   ELSE
     C                   READ      @A6REA3                                90    *
     C                   ENDIF
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDCHRC        BEGSR
      *================================================================
      * Update Limits Rate CHG - Currency Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YARDC             1
      *
      * Move key fields to @A6REA4
      *
     C     KLCHSD        KLIST
     C                   KFLD                    A6CYCD                         Currency Code
     C     KLCHSD        CHAIN     @A6REA4                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SDEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SDEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      @1DBRC        YARDCS
      * Move non-key fields to @A6REA4
     C                   Z-ADD     WUERLC        A6ERLC                         Exchange Rate -
      *
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YARDCS
     C                   MOVE      'Y'           YARDC
     C                   END
      * If changed update record otherwise release record
     C     YARDC         IFEQ      'Y'
      *                                                                                       CSD012
      * If CSD012 is ON and Currencies is ON, output details to Shadow file                   CSD012
     C     CSD012        IFEQ      'Y'
     C     SVAL11        ANDEQ     'Y'
     C     #1CYCD        CHAIN     SDCUSHL0                           90
     C     *IN90         IFEQ      *ON
     C                   MOVEL     #1CYCD        A6CYCD
     C                   WRITE     SDCUSHD0
     C                   ELSE
     C                   MOVEL     #1CYCD        A6CYCD                         Currency Code
     C                   MOVEL     #1SPAE        A6SPAE                         Spot Trade Acco
     C                   MOVEL     #1FTAE        A6FTAE                         Fwd Trade Accou
     C                   MOVEL     #1SWAE        A6SWAE                         Swap Trade Acco
     C                   MOVEL     #1TAC4        A6TAC4                         Trade Account C
     C                   MOVEL     #1TAC5        A6TAC5                         Trade Account C
     C                   MOVEL     #1CDFN        A6CDFN                         Cedel Default N
     C                   MOVEL     #1ECDN        A6ECDN                         Euroclear Defau
     C                   Z-ADD     WURDNB        A6LCD                          Last Change Dat
     C                   MOVEL     'A'           A6TYLC                         Type of Last Ch
     C                   MOVEL     #1CYNM        A6CYNM                         Currency Name
     C                   Z-ADD     #1SPRT        A6SPRT                         Spot Rate
     C                   MOVEL     #1SWCY        A6SWCY                         Swift Currency
     C                   Z-ADD     #1NBDP        A6NBDP                         Number of Decim
     C                   Z-ADD     #1TXND        A6TXND                         Telex Notice Da
     C                   Z-ADD     #1PRRT        A6PRRT                         Par Rate
     C                   Z-ADD     #1SRC1        A6SRC1                         Statutory Retur
     C                   Z-ADD     #1SRC2        A6SRC2                         Statutory Retur
     C                   MOVEL     #1DLCI        A6DLCI                         Dealing Currenc
     C                   Z-ADD     #1SSNB        A6SSNB                         Sort Sequence N
     C                   Z-ADD     #1ERLC        A6ERLC                         Exchange Rate -
     C                   MOVEL     #1MDIN        A6MDIN                         Multiply/Divide
     C                   MOVEL     #1MDPR        A6MDPR                         Multiply/Divide
     C                   MOVEL     #1MDHB        A6MDHB                         Multiply/Divide
     C                   MOVEL     #1MDEX        A6MDEX                         Multiply/Divide
     C                   MOVEL     #1NOSN        A6NOSN                         Nostro Shortnam
     C                   Z-ADD     #1SPDY        A6SPDY                         Spot Days
     C                   Z-ADD     #1HSRT        A6HSRT                         High Spot Rate
     C                   Z-ADD     #1LSPR        A6LSPR                         Low Spot Rate
     C                   Z-ADD     #1FXSD        A6FXSD                         DRS FX Spot Dat
     C                   Z-ADD     #1MMSD        A6MMSD                         DRS MM Spot Dat
     C                   Z-ADD     #1NQDP        A6NQDP                         Normally Quoted
     C                   MOVEL     #1DICB        A6DICB                         Default Int. Ca
     C                   Z-ADD     #1SCEX        A6SCEX                         Scaling Exponen
     C                   MOVEL     #1EBDA        A6EBDA                         Eurobond Data
     C                   Z-ADD     #1HBRT        A6HBRT                         Historic Broker
     C                   Z-ADD     #1ENC1        A6ENC1                         Euroclear Numer
     C                   Z-ADD     #1ENC2        A6ENC2                         Euroclear Numer
     C                   MOVEL     #1CACD        A6CACD                         Cedel Alpha Cod
     C                   Z-ADD     #1CNMC        A6CNMC                         Cedel Numeric C
     C                   MOVEL     #1WEDH        A6WEDH                         WED. Holiday
     C                   MOVEL     #1MONH        A6MONH                         MON. Holiday
     C                   MOVEL     #1TUEH        A6TUEH                         TUES. Holiday
     C                   MOVEL     #1THUH        A6THUH                         THURS. Holiday
     C                   MOVEL     #1FRIH        A6FRIH                         FRI. Holiday
     C                   MOVEL     #1SATH        A6SATH                         SAT. Holiday
     C                   MOVEL     #1SUNH        A6SUNH                         SUN. Holiday
     C                   Z-ADD     #1DPBF        A6DPBF                         Dec.Places in B
     C                   Z-ADD     #1BYSR        A6BYSR                         Buy Spread Rate
     C                   MOVEL     #1BYSS        A6BYSS                         Buy Spread Sign
     C                   Z-ADD     #1SLSR        A6SLSR                         Sell Spread Rat
     C                   MOVEL     #1SLSS        A6SLSS                         Sell Spread Sig
     C                   Z-ADD     #1RMCM        A6RMCM                         RM Cashflow Mag
     C                   MOVEL     'D'           A6RECI                         Record Id
     C                   MOVEL     #1DPRU        A6DPRU                         Default Priorit
     C                   MOVEL     #1DNOR        A6DNOR                         Delivery Notifi
     C                   MOVEL     #1NDWR        A6NDWR                         Non-Delivery Wa
     C                   MOVEL     #1GMPY        A6GMPY                         Generate Multip
     C                   MOVEL     #1DLCD        A6DLCD                         Delivery Code
     C                   MOVEL     #1RDFC        A6RDFC                         Round Down Inte
     C                   MOVEL     #1PMRT        A6PMRT                         Precious Metal
     C                   Z-ADD     #1RKSQ        A6RKSQ                         Currency Rankin
     C                   MOVEL     #1DFPC        A6DFPC                         Dft Fx Poss Pro
     C                   MOVEL     #1DDPC        A6DDPC                         Dft Dir Fund Pr
     C                   Z-ADD     #1TKCC        A6TKCC                         Telekurs Curren
     C                   Z-ADD     #1CQCD        A6CQCD                         Cheque Clearing
     C                   Z-ADD     #1SMLD        A6SMLD                         Smallest Denomi
     C                   MOVEL     #1CSCD        A6CSCD                         Cash Account Co
     C                   Z-ADD     #1ISON        A6ISON                         Numeric ISO Cur
     C                   MOVEL     #1ISFC        A6ISFC                         ISDA Financial
     C                   MOVEL     #1MACD        A6MACD                         Major Currency
     C                   MOVEL     #1FRAC        A6FRAC                         Fractions Flag
     C                   MOVEL     #1NUWD        A6NUWD                         Numbers and Wor
     C                   MOVEL     #1MICD        A6MICD                         Minor Currency
     C                   MOVEL     'N'           A6INCY                         In Ccy Indicat
     C                   Z-ADD     0             A6EUER                         EMU Exchng Rat
     C                   MOVEL     *BLANK        A6EUMD                         EMU Mult/Div
     C                   Z-ADD     0             A6TPSD                         EMU Trans. Str
     C                   Z-ADD     0             A6TPED                         EMU Trans. End
     C                   Z-ADD     0             A6INER                         OUT/EUR Ex.Rat
     C                   MOVEL     *BLANK        A6INMD                         OUT/EUR Mul/Div
     C                   MOVEL     #1DLOC        A6DLOC                         Deflt Loc Code
     C                   MOVEL     *BLANK        A6CYPI                         Portfolio profi
     C                   Z-ADD     0             A6EXWC                         Exposure weight
     C                   Z-ADD     0             A6POWC                         Position weight
     C                   Z-ADD     0             A6CYD1                         Day n1 renewal
     C                   Z-ADD     0             A6CYD2                         Day n2 renewal
     C                   Z-ADD     0             A6CYD3                         Day n3 renewal
     C                   MOVEL     *BLANK        A6CYLD                         Last Day in Mon
     C                   MOVEL     *BLANK        A6CYGR                         Currency Group
     C                   Z-ADD     0             A6RENO                         Renewal notice
     C                   MOVEL     #1CLSC        A6CLSC                         CLS Currency
     C                   Z-ADD     #1EFDT        A6EFDT                         Effective Date
     C                   MOVEL     #1SETD        A6SETD
     C                   MOVEL     #1IRDP        A6IRDP
     C                   Z-ADD     0             A6SWDP
     C                   Z-ADD     0             A6SWDT
     C                   Z-ADD     0             A6DFTS
      *                                                                                       CER043
     C     CER043        IFEQ      'Y'
     C                   MOVE      #1RETP        A6RETP
     C                   ENDIF
      *                                                                                       CGL014
     C     CGL014        IFEQ      'Y'
     C     CLE025        OREQ      'Y'
     C     WUN4ST        OREQ      'Y'
     C                   MOVEL     #1EXWC        A6EXWC
     C                   MOVEL     #1POWC        A6POWC
     C                   ENDIF
      *                                                                                       CGL014
     C                   UPDATE    SDCUSHD0
     C                   ENDIF
      *                                                                                       CSD012
     C                   ELSE
      *                                                                                       CSD012
     C                   UPDATE    @A6REA4                              91      *
     C                   ENDIF
      *                                                                                       CSD012
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDCURRL0                             91      *
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   SERVGN        BEGSR
      *================================================================
      * Update Limits Rate RTV - Currency Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KPSSE         KLIST
     C                   KFLD                    A6CYCD                         Currency Code
      * Move fields to key list
     C                   MOVEL     'AAA'         A6CYCD                         Currency Code
      *                                                                                       CSD031
      ** If Acceptance mode, access acceptance file SDACURL1                                  CSD031
      *                                                                                       CSD031
     C     CSD043        IFEQ      'Y'
     C     PACCPT        IFEQ      'A'
     C     KPSSE         SETLL     SDCURRD0
     C                   READ      SDCURRD0                               90
     C                   ELSE
     C     KPSSE         SETLL     @A6REA3
     C                   READ      @A6REA3                                90
     C                   ENDIF
     C                   ELSE
     C     KPSSE         SETLL     @A6REA3                                      *
     C                   READ      @A6REA3                                90    *
     C                   ENDIF
      * Data record not found
     C   90              MOVEL     'USR0071'     W0RTN             7
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
      * CASE: PAR.Saved Base Currency NE DB1.Currency Code
     C     WUSVBC        IFNE      A6CYCD                                       *IF
      * CASE: PAR.Saved Base curr for limit NE DB1.Currency Code
     C     WUSVBL        IFNE      A6CYCD                                       *IF
      * CASE: PAR.Saved Multy/Divide Ind EQ DB1.Multiply/Divide Indicator
     C     WUSMDI        IFEQ      A6MDIN                                       *IF
     C     A6SPRT        DIV(H)    WUSSSR        WUERLC                         Exchange Rate -
     C                   ELSE
      * CASE: *OTHERWISE
     C     A6SPRT        MULT(H)   WUSSSR        WUERLC                         Exchange Rate -
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: PAR.Saved Base Currency EQ DB1.Currency Code
     C     WUSVBC        IFEQ      A6CYCD                                       *IF
      * Start of Fix E21210
      * CASE: PAR.Saved Multy/Divide Ind is Multiply amount by rate
     C     WUSMDI        IFEQ      'M'                                          *IF
     C     1             DIV(H)    WUSSSR        WUERLC                         Exchange Rate -
     C                   ELSE
      * CASE: *OTHERWISE
     C     WUSSSR        ADD       *ZERO         WUERLC                         Exchange Rate -
     C                   END                                                    *FI
      * End of Fix E21210
     C                   END                                                    *FI
      * CASE: PAR.Saved Base curr for limit NE DB1.Currency Code
     C     WUSVBL        IFNE      A6CYCD                                       *IF
      * Update Limits Rate CHG - Currency Codes  *
     C                   EXSR      SFCHRC
      * Start of Fix E20297
      * Add processing to check that the update is successful
      * Start of fix S01314
      * call SD0023U with return code parameter
      * UPD Limit Rate Old Files - Currency Codes  *
     C                   CALL      'SD0023U'                            90      UPD Limit Rate
     C     W0RTN         PARM      W0RTN         WQ0062            7            *Return code
     C                   PARM      A6CYCD        WQ0063            3            Currency Code
     C                   PARM      WUERLC        WQ0064           13 8          Exchange Rate -
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0023U'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * End of fix S01314
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
      * Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   END                                                    *FI
      * End of Fix E20297
     C                   END                                                    *FI
      *                                                                                       CSD031
      ** If Acceptance mode, access acceptance file SDACURL1                                  CSD031
      *                                                                                       CSD031
     C     CSD043        IFEQ      'Y'
     C********** PACCPT    IFEQ 'Y'                                                  CSD031 BUG11875
     C     PACCPT        IFEQ      'A'
     C                   READ      SDCURRD0                               90
     C                   ELSE
     C                   READ      @A6REA3                                90
     C                   ENDIF
     C                   ELSE
     C                   READ      @A6REA3                                90    *
     C                   ENDIF
     C                   END
      *================================================================
     CSR   SEEXIT        ENDSR
      /EJECT
     CSR   SFCHRC        BEGSR
      *================================================================
      * Update Limits Rate CHG - Currency Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YBRDC             1
      *
      * Move key fields to @A6REA4
      *
     C     KLCHSF        KLIST
     C                   KFLD                    A6CYCD                         Currency Code
     C     KLCHSF        CHAIN     @A6REA4                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SFEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SFEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      @1DBRC        YBRDCS
      * Move non-key fields to @A6REA4
     C                   Z-ADD     WUERLC        A6ERLC                         Exchange Rate -
      *
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YBRDCS
     C                   MOVE      'Y'           YBRDC
     C                   END
      * If changed update record otherwise release record
     C     YBRDC         IFEQ      'Y'
      *                                                                                       CSD012
      * If CSD012 is ON and Currencies is ON, output details to Shadow file                   CSD012
     C     CSD012        IFEQ      'Y'
     C     SVAL11        ANDEQ     'Y'
     C     #1CYCD        CHAIN     SDCUSHL0                           90
     C     *IN90         IFEQ      *ON
     C                   WRITE     SDCUSHD0                             91
     C                   ELSE
     C                   MOVEL     #1CYCD        A6CYCD                         Currency Code
     C                   MOVEL     #1SPAE        A6SPAE                         Spot Trade Acco
     C                   MOVEL     #1FTAE        A6FTAE                         Fwd Trade Accou
     C                   MOVEL     #1SWAE        A6SWAE                         Swap Trade Acco
     C                   MOVEL     #1TAC4        A6TAC4                         Trade Account C
     C                   MOVEL     #1TAC5        A6TAC5                         Trade Account C
     C                   MOVEL     #1CDFN        A6CDFN                         Cedel Default N
     C                   MOVEL     #1ECDN        A6ECDN                         Euroclear Defau
     C                   Z-ADD     WURDNB        A6LCD                          Last Change Dat
     C                   MOVEL     'A'           A6TYLC                         Type of Last Ch
     C                   MOVEL     #1CYNM        A6CYNM                         Currency Name
     C                   Z-ADD     #1SPRT        A6SPRT                         Spot Rate
     C                   MOVEL     #1SWCY        A6SWCY                         Swift Currency
     C                   Z-ADD     #1NBDP        A6NBDP                         Number of Decim
     C                   Z-ADD     #1TXND        A6TXND                         Telex Notice Da
     C                   Z-ADD     #1PRRT        A6PRRT                         Par Rate
     C                   Z-ADD     #1SRC1        A6SRC1                         Statutory Retur
     C                   Z-ADD     #1SRC2        A6SRC2                         Statutory Retur
     C                   MOVEL     #1DLCI        A6DLCI                         Dealing Currenc
     C                   Z-ADD     #1SSNB        A6SSNB                         Sort Sequence N
     C                   Z-ADD     #1ERLC        A6ERLC                         Exchange Rate -
     C                   MOVEL     #1MDIN        A6MDIN                         Multiply/Divide
     C                   MOVEL     #1MDPR        A6MDPR                         Multiply/Divide
     C                   MOVEL     #1MDHB        A6MDHB                         Multiply/Divide
     C                   MOVEL     #1MDEX        A6MDEX                         Multiply/Divide
     C                   MOVEL     #1NOSN        A6NOSN                         Nostro Shortnam
     C                   Z-ADD     #1SPDY        A6SPDY                         Spot Days
     C                   Z-ADD     #1HSRT        A6HSRT                         High Spot Rate
     C                   Z-ADD     #1LSPR        A6LSPR                         Low Spot Rate
     C                   Z-ADD     #1FXSD        A6FXSD                         DRS FX Spot Dat
     C                   Z-ADD     #1MMSD        A6MMSD                         DRS MM Spot Dat
     C                   Z-ADD     #1NQDP        A6NQDP                         Normally Quoted
     C                   MOVEL     #1DICB        A6DICB                         Default Int. Ca
     C                   Z-ADD     #1SCEX        A6SCEX                         Scaling Exponen
     C                   MOVEL     #1EBDA        A6EBDA                         Eurobond Data
     C                   Z-ADD     #1HBRT        A6HBRT                         Historic Broker
     C                   Z-ADD     #1ENC1        A6ENC1                         Euroclear Numer
     C                   Z-ADD     #1ENC2        A6ENC2                         Euroclear Numer
     C                   MOVEL     #1CACD        A6CACD                         Cedel Alpha Cod
     C                   Z-ADD     #1CNMC        A6CNMC                         Cedel Numeric C
     C                   MOVEL     #1WEDH        A6WEDH                         WED. Holiday
     C                   MOVEL     #1MONH        A6MONH                         MON. Holiday
     C                   MOVEL     #1TUEH        A6TUEH                         TUES. Holiday
     C                   MOVEL     #1THUH        A6THUH                         THURS. Holiday
     C                   MOVEL     #1FRIH        A6FRIH                         FRI. Holiday
     C                   MOVEL     #1SATH        A6SATH                         SAT. Holiday
     C                   MOVEL     #1SUNH        A6SUNH                         SUN. Holiday
     C                   Z-ADD     #1DPBF        A6DPBF                         Dec.Places in B
     C                   Z-ADD     #1BYSR        A6BYSR                         Buy Spread Rate
     C                   MOVEL     #1BYSS        A6BYSS                         Buy Spread Sign
     C                   Z-ADD     #1SLSR        A6SLSR                         Sell Spread Rat
     C                   MOVEL     #1SLSS        A6SLSS                         Sell Spread Sig
     C                   Z-ADD     #1RMCM        A6RMCM                         RM Cashflow Mag
     C                   MOVEL     'D'           A6RECI                         Record Id
     C                   MOVEL     #1DPRU        A6DPRU                         Default Priorit
     C                   MOVEL     #1DNOR        A6DNOR                         Delivery Notifi
     C                   MOVEL     #1NDWR        A6NDWR                         Non-Delivery Wa
     C                   MOVEL     #1GMPY        A6GMPY                         Generate Multip
     C                   MOVEL     #1DLCD        A6DLCD                         Delivery Code
     C                   MOVEL     #1RDFC        A6RDFC                         Round Down Inte
     C                   MOVEL     #1PMRT        A6PMRT                         Precious Metal
     C                   Z-ADD     #1RKSQ        A6RKSQ                         Currency Rankin
     C                   MOVEL     #1DFPC        A6DFPC                         Dft Fx Poss Pro
     C                   MOVEL     #1DDPC        A6DDPC                         Dft Dir Fund Pr
     C                   Z-ADD     #1TKCC        A6TKCC                         Telekurs Curren
     C                   Z-ADD     #1CQCD        A6CQCD                         Cheque Clearing
     C                   Z-ADD     #1SMLD        A6SMLD                         Smallest Denomi
     C                   MOVEL     #1CSCD        A6CSCD                         Cash Account Co
     C                   Z-ADD     #1ISON        A6ISON                         Numeric ISO Cur
     C                   MOVEL     #1ISFC        A6ISFC                         ISDA Financial
     C                   MOVEL     #1MACD        A6MACD                         Major Currency
     C                   MOVEL     #1FRAC        A6FRAC                         Fractions Flag
     C                   MOVEL     #1NUWD        A6NUWD                         Numbers and Wor
     C                   MOVEL     #1MICD        A6MICD                         Minor Currency
     C                   MOVEL     'N'           A6INCY                         In Ccy Indicat
     C                   Z-ADD     0             A6EUER                         EMU Exchng Rat
     C                   MOVEL     *BLANK        A6EUMD                         EMU Mult/Div
     C                   Z-ADD     0             A6TPSD                         EMU Trans. Str
     C                   Z-ADD     0             A6TPED                         EMU Trans. End
     C                   Z-ADD     0             A6INER                         OUT/EUR Ex.Rat
     C                   MOVEL     *BLANK        A6INMD                         OUT/EUR Mul/Div
     C                   MOVEL     #1DLOC        A6DLOC                         Deflt Loc Code
     C                   MOVEL     *BLANK        A6CYPI                         Portfolio profi
     C                   Z-ADD     0             A6EXWC                         Exposure weight
     C                   Z-ADD     0             A6POWC                         Position weight
     C                   Z-ADD     0             A6CYD1                         Day n1 renewal
     C                   Z-ADD     0             A6CYD2                         Day n2 renewal
     C                   Z-ADD     0             A6CYD3                         Day n3 renewal
     C                   MOVEL     *BLANK        A6CYLD                         Last Day in Mon
     C                   MOVEL     *BLANK        A6CYGR                         Currency Group
     C                   Z-ADD     0             A6RENO                         Renewal notice
     C                   MOVEL     #1CLSC        A6CLSC                         CLS Currency
     C                   Z-ADD     #1EFDT        A6EFDT                         Effective Date
     C                   MOVEL     #1SETD        A6SETD
     C                   MOVEL     #1IRDP        A6IRDP
     C                   Z-ADD     0             A6SWDP
     C                   Z-ADD     0             A6SWDT
     C                   Z-ADD     0             A6DFTS
      *                                                                                       CER043
     C     CER043        IFEQ      'Y'
     C                   MOVE      #1RETP        A6RETP
     C                   ENDIF
      *                                                                                       CGL014
     C     CGL014        IFEQ      'Y'
     C     CLE025        OREQ      'Y'
     C     WUN4ST        OREQ      'Y'
     C                   MOVEL     #1EXWC        A6EXWC
     C                   MOVEL     #1POWC        A6POWC
     C                   ENDIF
      *                                                                                       CGL014
     C                   UPDATE    SDCUSHD0
     C                   ENDIF
      *                                                                                       CSD012
     C                   ELSE
      *                                                                                       CSD012
     C                   UPDATE    @A6REA4                              91      *
     C                   ENDIF
      *                                                                                       CSD012
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDCURRL0                             91      *
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SFEXIT        ENDSR
      /EJECT
     CSR   SGRVGN        BEGSR
      *================================================================
      * Retrieve Record - Account Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSG         KLIST
     C                   KFLD                    A5ACCD                         Account Code
      * Move fields to key list
     C                   MOVEL     #1SPAE        A5ACCD                         Account Code
     C     KRSSG         CHAIN     @A5REA6                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0069'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SGEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   END
      *================================================================
     CSR   SGEXIT        ENDSR
      /EJECT
     CSR   SHRVGN        BEGSR
      *================================================================
      * Retrieve Record - Account Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSH         KLIST
     C                   KFLD                    A5ACCD                         Account Code
      * Move fields to key list
     C                   MOVEL     #1FTAE        A5ACCD                         Account Code
     C     KRSSH         CHAIN     @A5REA6                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0069'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SHEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   END
      *================================================================
     CSR   SHEXIT        ENDSR
      /EJECT
     CSR   SIRVGN        BEGSR
      *================================================================
      * Retrieve Record - Account Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSI         KLIST
     C                   KFLD                    A5ACCD                         Account Code
      * Move fields to key list
     C                   MOVEL     #1SWAE        A5ACCD                         Account Code
     C     KRSSI         CHAIN     @A5REA6                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0069'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SIEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   END
      *================================================================
     CSR   SIEXIT        ENDSR
      /EJECT
     CSR   SJRVGN        BEGSR
      *================================================================
      * Retrieve Record - Account Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSJ         KLIST
     C                   KFLD                    A5ACCD                         Account Code
      * Move fields to key list
     C                   MOVEL     #1SPAE        A5ACCD                         Account Code
     C     KRSSJ         CHAIN     @A5REA6                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0069'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SJEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   END
      *================================================================
     CSR   SJEXIT        ENDSR
      /EJECT
     CSR   SKRVGN        BEGSR
      *================================================================
      * Retrieve Record - Account Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSK         KLIST
     C                   KFLD                    A5ACCD                         Account Code
      * Move fields to key list
     C                   MOVEL     #1TAC4        A5ACCD                         Account Code
     C     KRSSK         CHAIN     @A5REA6                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0069'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SKEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   END
      *================================================================
     CSR   SKEXIT        ENDSR
      /EJECT
     CSR   SLRVGN        BEGSR
      *================================================================
      * retrieve type as well - Account Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSL         KLIST
     C                   KFLD                    A5ACCD                         Account Code
      * Move fields to key list
     C                   MOVEL     #1TAC4        A5ACCD                         Account Code
     C     KRSSL         CHAIN     @A5REA6                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0069'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SLEXIT
     C                   END
      *
      * USER: Exit processing
      * PAR = DB1 By name
     C                   MOVEL     A5ACTY        WUACTY                         Account type
     C                   MOVEL     A5TOIN        WUTOIN                         Title Only Indi
      *================================================================
     CSR   SLEXIT        ENDSR
      /EJECT
     CSR   SMRVGN        BEGSR
      *================================================================
      * Retrieve Record - Account Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSM         KLIST
     C                   KFLD                    A5ACCD                         Account Code
      * Move fields to key list
     C                   MOVEL     #1TAC5        A5ACCD                         Account Code
     C     KRSSM         CHAIN     @A5REA6                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0069'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SMEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   END
      *================================================================
     CSR   SMEXIT        ENDSR
      /EJECT
     CSR   SNRVGN        BEGSR
      *================================================================
      * retrieve type as well - Account Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSN         KLIST
     C                   KFLD                    A5ACCD                         Account Code
      * Move fields to key list
     C                   MOVEL     #1TAC5        A5ACCD                         Account Code
     C     KRSSN         CHAIN     @A5REA6                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0069'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SNEXIT
     C                   END
      *
      * USER: Exit processing
      * PAR = DB1 By name
     C                   MOVEL     A5ACTY        WUACTY                         Account type
     C                   MOVEL     A5TOIN        WUTOIN                         Title Only Indi
      *================================================================
     CSR   SNEXIT        ENDSR
      /EJECT
     CSR   SORVGN        BEGSR
      *================================================================
      * Check Currency Rank Seq - Currency Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      *                                                                                       CSD031
      ** If Acceptance mode, access acceptance file SDACURL1                                  CSD031
      *                                                                                       CSD031
     C     CSD043        IFEQ      'Y'
     C     PACCPT        IFEQ      'A'
     C     *LOVAL        SETLL     SDCURRD0
     C                   READ      SDCURRD0                               90
     C                   ELSE
     C     *LOVAL        SETLL     @A6REA3
     C                   READ      @A6REA3                                90
     C                   ENDIF
     C                   ELSE
     C     *LOVAL        SETLL     @A6REA3                                      *
     C                   READ      @A6REA3                                90    *
     C                   ENDIF
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0071'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SOEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
      * If the 'Currency Ranking Sequence' already exists for another
      * record on the file set the return code to 'record already exists'
      * CASE: PAR.Currency Ranking Sequence EQ DB1.Currency Ranking Seque
     C     #1RKSQ        IFEQ      A6RKSQ                                       *IF
      * CASE: PAR.Currency Code NE DB1.Currency Code
     C     #1CYCD        IFNE      A6CYCD                                       *IF
     C                   MOVEL     'Y2U0003'     WURTN                          *Return code
     C                   GOTO      SOEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
      *                                                                                       CSD031
      ** If Acceptance mode, access acceptance file SDACURL1                                  CSD031
      *                                                                                       CSD031
     C     CSD043        IFEQ      'Y'
     C     PACCPT        IFEQ      'A'
     C                   READ      SDCURRD0                               90
     C                   ELSE
     C                   READ      @A6REA3                                90
     C                   ENDIF
     C                   ELSE
     C                   READ      @A6REA3                                90    *
     C                   ENDIF
     C                   END
      *================================================================
     CSR   SOEXIT        ENDSR
      /EJECT
     CSR   SPRVGN        BEGSR
      *================================================================
      * standard retrieve object - Currency Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSP         KLIST
     C                   KFLD                    A6CYCD                         Currency Code
      * Move fields to key list
     C                   MOVEL     #1CYCD        A6CYCD                         Currency Code
      *                                                                                       CSD031
      ** If Acceptance mode, access acceptance file SDACURL0                                  CSD031
      *                                                                                       CSD031
     C     CSD043        IFEQ      'Y'
     C     PACCPT        IFEQ      'A'
     C     KRSSP         CHAIN     SDCURRD0                           90
     C     *IN90         IFEQ      '0'
     C                   MOVE      A6AACC        AAAACC            1
     C                   Z-ADD     A6EACC        AAEACC            5 0
     C                   MOVE      A6GPDT        AAGPDT            1
     C                   ENDIF
     C                   ELSE
     C     KRSSP         CHAIN     @A6REA3                            90
     C                   ENDIF
     C                   ELSE
     C     KRSSP         CHAIN     @A6REA3                            90        *
     C                   ENDIF
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0071'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SPEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   END
      *================================================================
     CSR   SPEXIT        ENDSR
      /EJECT
     CSR   SQCRRC        BEGSR
      *================================================================
      * Create Currency Codes -LR - Currency Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @A6REA4
     C                   MOVEL     #1CYCD        A6CYCD                         Currency Code
     C                   MOVEL     #1SPAE        A6SPAE                         Spot Trade Acco
     C                   MOVEL     #1FTAE        A6FTAE                         Fwd Trade Accou
     C                   MOVEL     #1SWAE        A6SWAE                         Swap Trade Acco
     C                   MOVEL     #1TAC4        A6TAC4                         Trade Account C
     C                   MOVEL     #1TAC5        A6TAC5                         Trade Account C
     C                   MOVEL     #1CDFN        A6CDFN                         Cedel Default N
     C                   MOVEL     #1ECDN        A6ECDN                         Euroclear Defau
     C                   Z-ADD     WURDNB        A6LCD                          Last Change Dat
     C                   MOVEL     'I'           A6TYLC                         Type of Last Ch
     C                   MOVEL     #1CYNM        A6CYNM                         Currency Name
     C                   Z-ADD     #1SPRT        A6SPRT                         Spot Rate
     C                   MOVEL     #1SWCY        A6SWCY                         Swift Currency
     C                   Z-ADD     #1NBDP        A6NBDP                         Number of Decim
     C                   Z-ADD     #1TXND        A6TXND                         Telex Notice Da
     C                   Z-ADD     #1PRRT        A6PRRT                         Par Rate
     C                   Z-ADD     #1SRC1        A6SRC1                         Statutory Retur
     C                   Z-ADD     #1SRC2        A6SRC2                         Statutory Retur
     C                   MOVEL     #1DLCI        A6DLCI                         Dealing Currenc
     C                   Z-ADD     #1SSNB        A6SSNB                         Sort Sequence N
     C                   Z-ADD     #1ERLC        A6ERLC                         Exchange Rate -
     C                   MOVEL     #1MDIN        A6MDIN                         Multiply/Divide
     C                   MOVEL     #1MDPR        A6MDPR                         Multiply/Divide
     C                   MOVEL     #1MDHB        A6MDHB                         Multiply/Divide
     C                   MOVEL     #1MDEX        A6MDEX                         Multiply/Divide
     C                   MOVEL     #1NOSN        A6NOSN                         Nostro Shortnam
     C                   Z-ADD     #1SPDY        A6SPDY                         Spot Days
     C                   Z-ADD     #1HSRT        A6HSRT                         High Spot Rate
     C                   Z-ADD     #1LSPR        A6LSPR                         Low Spot Rate
     C                   Z-ADD     #1FXSD        A6FXSD                         DRS FX Spot Dat
     C                   Z-ADD     #1MMSD        A6MMSD                         DRS MM Spot Dat
     C                   Z-ADD     #1NQDP        A6NQDP                         Normally Quoted
     C                   MOVEL     #1DICB        A6DICB                         Default Int. Ca
     C                   Z-ADD     #1SCEX        A6SCEX                         Scaling Exponen
     C                   MOVEL     #1EBDA        A6EBDA                         Eurobond Data
     C                   Z-ADD     #1HBRT        A6HBRT                         Historic Broker
     C                   Z-ADD     #1ENC1        A6ENC1                         Euroclear Numer
     C                   Z-ADD     #1ENC2        A6ENC2                         Euroclear Numer
     C                   MOVEL     #1CACD        A6CACD                         Cedel Alpha Cod
     C                   Z-ADD     #1CNMC        A6CNMC                         Cedel Numeric C
     C                   MOVEL     #1WEDH        A6WEDH                         WED. Holiday
     C                   MOVEL     #1MONH        A6MONH                         MON. Holiday
     C                   MOVEL     #1TUEH        A6TUEH                         TUES. Holiday
     C                   MOVEL     #1THUH        A6THUH                         THURS. Holiday
     C                   MOVEL     #1FRIH        A6FRIH                         FRI. Holiday
     C                   MOVEL     #1SATH        A6SATH                         SAT. Holiday
     C                   MOVEL     #1SUNH        A6SUNH                         SUN. Holiday
     C                   Z-ADD     #1DPBF        A6DPBF                         Dec.Places in B
     C                   Z-ADD     #1BYSR        A6BYSR                         Buy Spread Rate
     C                   MOVEL     #1BYSS        A6BYSS                         Buy Spread Sign
     C                   Z-ADD     #1SLSR        A6SLSR                         Sell Spread Rat
     C                   MOVEL     #1SLSS        A6SLSS                         Sell Spread Sig
     C                   Z-ADD     #1RMCM        A6RMCM                         RM Cashflow Mag
     C                   MOVEL     'D'           A6RECI                         Record Id
     C                   MOVEL     #1DPRU        A6DPRU                         Default Priorit
     C                   MOVEL     #1DNOR        A6DNOR                         Delivery Notifi
     C                   MOVEL     #1NDWR        A6NDWR                         Non-Delivery Wa
     C                   MOVEL     #1GMPY        A6GMPY                         Generate Multip
     C                   MOVEL     #1DLCD        A6DLCD                         Delivery Code
     C                   MOVEL     #1RDFC        A6RDFC                         Round Down Inte
     C                   MOVEL     #1PMRT        A6PMRT                         Precious Metal
     C                   Z-ADD     #1RKSQ        A6RKSQ                         Currency Rankin
     C                   MOVEL     #1DFPC        A6DFPC                         Dft Fx Poss Pro
     C                   MOVEL     #1DDPC        A6DDPC                         Dft Dir Fund Pr
     C                   Z-ADD     #1TKCC        A6TKCC                         Telekurs Curren
     C                   Z-ADD     #1CQCD        A6CQCD                         Cheque Clearing
     C                   Z-ADD     #1SMLD        A6SMLD                         Smallest Denomi
     C                   MOVEL     #1CSCD        A6CSCD                         Cash Account Co
     C                   Z-ADD     #1ISON        A6ISON                         Numeric ISO Cur
     C                   MOVEL     #1ISFC        A6ISFC                         ISDA Financial
     C                   MOVEL     #1MACD        A6MACD                         Major Currency
     C                   MOVEL     #1FRAC        A6FRAC                         Fractions Flag
     C                   MOVEL     #1NUWD        A6NUWD                         Numbers and Wor
     C                   MOVEL     #1MICD        A6MICD                         Minor Currency
     C                   MOVEL     'N'           A6INCY                         In Ccy Indicat 13381
     C                   Z-ADD     0             A6EUER                         EMU Exchng Rat 13381
     C                   MOVEL     *BLANK        A6EUMD                         EMU Mult/Div   13381
     C                   Z-ADD     0             A6TPSD                         EMU Trans. Str 13381
     C                   Z-ADD     0             A6TPED                         EMU Trans. End 13381
     C                   Z-ADD     0             A6INER                         OUT/EUR Ex.Rat 15252
     C                   MOVEL     *BLANK        A6INMD                         OUT/EUR Mul/Div15252
     C                   MOVEL     #1DLOC        A6DLOC                         Deflt Loc Code CSW09
     C                   MOVEL     *BLANK        A6CYPI                         Portfolio profiCPB00
     C                   Z-ADD     0             A6EXWC                         Exposure weightCPB00
     C                   Z-ADD     0             A6POWC                         Position weightCPB00
     C                   Z-ADD     0             A6CYD1                         Day n1 renewal CPB00
     C                   Z-ADD     0             A6CYD2                         Day n2 renewal CPB00
     C                   Z-ADD     0             A6CYD3                         Day n3 renewal CPB00
     C                   MOVEL     *BLANK        A6CYLD                         Last Day in MonCPB00
     C                   MOVEL     *BLANK        A6CYGR                         Currency Group CPB00
     C                   Z-ADD     0             A6RENO                         Renewal notice CPB00
     C                   MOVEL     #1CLSC        A6CLSC                         CLS Currency   CDL00
     C                   Z-ADD     #1EFDT        A6EFDT                         Effective Date CDL00
     C                   MOVEL     #1SETD        A6SETD
     C                   MOVEL     #1IRDP        A6IRDP
     C                   Z-ADD     0             A6SWDP
     C                   Z-ADD     0             A6SWDT
     C                   Z-ADD     0             A6DFTS
      *                                                                                       CER043
     C     CER043        IFEQ      'Y'
     C                   MOVE      #1RETP        A6RETP
     C                   ENDIF
      *                                                                                       CGL014
     C     CGL014        IFEQ      'Y'
     C     CLE025        OREQ      'Y'
     C     WUN4ST        OREQ      'Y'
     C                   MOVEL     #1EXWC        A6EXWC
     C                   MOVEL     #1POWC        A6POWC
     C                   ENDIF
      *
      * USER: Processing before Data update
      * Start of Fix E18248
      * CASE: PAR.FRI. Holiday is Blank
     C     #1FRIH        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           A6FRIH                         FRI. Holiday
     C                   END                                                    *FI
      * CASE: PAR.SAT. Holiday is Blank
     C     #1SATH        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           A6SATH                         SAT. Holiday
     C                   END                                                    *FI
      * CASE: PAR.SUN. Holiday is Blank
     C     #1SUNH        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           A6SUNH                         SUN. Holiday
     C                   END                                                    *FI
      * End of Fix E18248
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
     C/COPY WNCPYSRC,SD0021RC11
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
      * Start of SAR S01117
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,WN0481CCP1                                           S01408
     C***********          CALL 'WIND01'                                  S01212
     C                   CALL      'WN0010'                                                    S0121
     C*********************PARM           ##PGM            Program        S01212
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C*********************PARM *BLANK    FKEY    2        Function Key   S01212
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C*********************PARM           WUMEST           Action  S01212 S01229
     C*********************PARM           WUWMAC           Action  S01212 S01229
     C                   PARM      'I'           UACTCD            1            Action  S01212 S0122
     C                   PARM                    DATA                           Trans Data     S0121
     C                   PARM      *BLANK        W0RTN                          Return Code    S0121
     C                   PARM                    SPARE           256            Spare Field    LN035
      * End of SAR S01117
      * 00/Copy member SD0021RC02 - Currency Codes  *
     C/COPY WNCPYSRC,SD0021RC02
      * WM Check Return
      * CASE: PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      'USR0563'                                    *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SQEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SQEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SQEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RCBW - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RCBW
     C*
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RCBU - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RCBU
     C*
     C                   END                                                    *FI
     C     KLCRSQ        KLIST
     C                   KFLD                    A6CYCD                         Currency Code
      * Check for duplicate primary key
     C     KLCRSQ        SETLL     @A6REA4                                90    *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR0072'     W0RTN             7
      * Send message 'Currency Codes         EX'
     C                   MOVEL     'USR0072'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SQEXIT
     C                   END
      *
      * If CSD012 is ON and Currencies is ON, output details to Shadow file                   CSD012
     C     CSD012        IFEQ      'Y'
     C     SVAL11        ANDEQ     'Y'
     C                   WRITE     SDCUSHD0                             91
      *                                                                                       CSD012
     C                   ELSE
      *                                                                                       CSD012
     C                   WRITE     @A6REA4                              91      *
     C                   MOVEL     A6CYCD        CQCYCD
     C     CQCYCD        CHAIN     SDCURQL0                           90
     C     *IN90         IFEQ      *ON
     C                   WRITE     SDCURQD0                             90
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * USER: Processing after Data update
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RCAU - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RCAU
     C*
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SQEXIT        ENDSR
      /EJECT
     CSR   SRCHRC        BEGSR
      *================================================================
      * Change Currency Codes -LR - Currency Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YCRDC             1
      *
      * Move key fields to @A6REA4
     C                   MOVEL     #1CYCD        A6CYCD                         Currency Code
      *
     C     KLCHSR        KLIST
     C                   KFLD                    A6CYCD                         Currency Code
     C     KLCHSR        CHAIN     @A6REA4                            9091      *
      *
     C                   MOVE      ' '           NEW               1
     C     *IN90         IFEQ      '1'
     C     CSD043        IFEQ      'Y'
     C                   MOVE      'Y'           NEW
     C                   ENDIF
     C     CSD043        IFEQ      'N'
     C     P2ANCD        ORNE      'X'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SREXIT
     C                   ENDIF
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SREXIT
     C                   END
      *
      ** Store original value of Currency and SWIFT Currency Code                             CMG003
      *                                                                                       CMG003
     C                   MOVEL     A6CYCD        WOCYCD            3
     C                   MOVEL     A6SWCY        WOSWCY            3
      *                                                                                       CMG003
      * Store record data for null update check
     C                   MOVE      @1DBRC        YCRDCS
      * Move non-key fields to @A6REA4
     C                   MOVEL     #1SPAE        A6SPAE                         Spot Trade Acco
     C                   MOVEL     #1FTAE        A6FTAE                         Fwd Trade Accou
     C                   MOVEL     #1SWAE        A6SWAE                         Swap Trade Acco
     C                   MOVEL     #1TAC4        A6TAC4                         Trade Account C
     C                   MOVEL     #1TAC5        A6TAC5                         Trade Account C
     C                   MOVEL     #1CDFN        A6CDFN                         Cedel Default N
     C                   MOVEL     #1ECDN        A6ECDN                         Euroclear Defau
     C                   Z-ADD     WURDNB        A6LCD                          Last Change Dat
     C                   MOVEL     'A'           A6TYLC                         Type of Last Ch
     C                   MOVEL     #1CYNM        A6CYNM                         Currency Name
     C                   Z-ADD     #1SPRT        A6SPRT                         Spot Rate
     C                   MOVEL     #1SWCY        A6SWCY                         Swift Currency
     C                   Z-ADD     #1NBDP        A6NBDP                         Number of Decim
     C                   Z-ADD     #1TXND        A6TXND                         Telex Notice Da
     C                   Z-ADD     #1PRRT        A6PRRT                         Par Rate
     C                   Z-ADD     #1SRC1        A6SRC1                         Statutory Retur
     C                   Z-ADD     #1SRC2        A6SRC2                         Statutory Retur
     C                   MOVEL     #1DLCI        A6DLCI                         Dealing Currenc
     C                   Z-ADD     #1SSNB        A6SSNB                         Sort Sequence N
     C                   Z-ADD     #1ERLC        A6ERLC                         Exchange Rate -
     C                   MOVEL     #1MDIN        A6MDIN                         Multiply/Divide
     C                   MOVEL     #1MDPR        A6MDPR                         Multiply/Divide
     C                   MOVEL     #1MDHB        A6MDHB                         Multiply/Divide
     C                   MOVEL     #1MDEX        A6MDEX                         Multiply/Divide
     C                   MOVEL     #1NOSN        A6NOSN                         Nostro Shortnam
     C                   Z-ADD     #1SPDY        A6SPDY                         Spot Days
     C                   Z-ADD     #1HSRT        A6HSRT                         High Spot Rate
     C                   Z-ADD     #1LSPR        A6LSPR                         Low Spot Rate
     C                   Z-ADD     #1FXSD        A6FXSD                         DRS FX Spot Dat
     C                   Z-ADD     #1MMSD        A6MMSD                         DRS MM Spot Dat
     C                   Z-ADD     #1NQDP        A6NQDP                         Normally Quoted
     C                   MOVEL     #1DICB        A6DICB                         Default Int. Ca
     C                   Z-ADD     #1SCEX        A6SCEX                         Scaling Exponen
     C                   MOVEL     #1EBDA        A6EBDA                         Eurobond Data
     C                   Z-ADD     #1HBRT        A6HBRT                         Historic Broker
     C                   Z-ADD     #1ENC1        A6ENC1                         Euroclear Numer
     C                   Z-ADD     #1ENC2        A6ENC2                         Euroclear Numer
     C                   MOVEL     #1CACD        A6CACD                         Cedel Alpha Cod
     C                   Z-ADD     #1CNMC        A6CNMC                         Cedel Numeric C
     C                   MOVEL     #1WEDH        A6WEDH                         WED. Holiday
     C                   MOVEL     #1MONH        A6MONH                         MON. Holiday
     C                   MOVEL     #1TUEH        A6TUEH                         TUES. Holiday
     C                   MOVEL     #1THUH        A6THUH                         THURS. Holiday
     C                   MOVEL     #1FRIH        A6FRIH                         FRI. Holiday
     C                   MOVEL     #1SATH        A6SATH                         SAT. Holiday
     C                   MOVEL     #1SUNH        A6SUNH                         SUN. Holiday
     C                   Z-ADD     #1DPBF        A6DPBF                         Dec.Places in B
     C                   Z-ADD     #1BYSR        A6BYSR                         Buy Spread Rate
     C                   MOVEL     #1BYSS        A6BYSS                         Buy Spread Sign
     C                   Z-ADD     #1SLSR        A6SLSR                         Sell Spread Rat
     C                   MOVEL     #1SLSS        A6SLSS                         Sell Spread Sig
     C                   Z-ADD     #1RMCM        A6RMCM                         RM Cashflow Mag
     C                   MOVEL     #1RECI        A6RECI                         Record Id
     C                   MOVEL     #1DPRU        A6DPRU                         Default Priorit
     C                   MOVEL     #1DNOR        A6DNOR                         Delivery Notifi
     C                   MOVEL     #1NDWR        A6NDWR                         Non-Delivery Wa
     C                   MOVEL     #1GMPY        A6GMPY                         Generate Multip
     C                   MOVEL     #1DLCD        A6DLCD                         Delivery Code
     C                   MOVEL     #1RDFC        A6RDFC                         Round Down Inte
     C                   MOVEL     #1PMRT        A6PMRT                         Precious Metal
     C                   Z-ADD     #1RKSQ        A6RKSQ                         Currency Rankin
     C                   MOVEL     #1DFPC        A6DFPC                         Dft Fx Poss Pro
     C                   MOVEL     #1DDPC        A6DDPC                         Dft Dir Fund Pr
     C                   Z-ADD     #1TKCC        A6TKCC                         Telekurs Curren
     C                   Z-ADD     #1CQCD        A6CQCD                         Cheque Clearing
     C                   Z-ADD     #1SMLD        A6SMLD                         Smallest Denomi
     C                   MOVEL     #1CSCD        A6CSCD                         Cash Account Co
     C                   Z-ADD     #1ISON        A6ISON                         Numeric ISO Cur
     C                   MOVEL     #1ISFC        A6ISFC                         ISDA Financial
     C                   MOVEL     #1MACD        A6MACD                         Major Currency
     C                   MOVEL     #1FRAC        A6FRAC                         Fractions Flag
     C                   MOVEL     #1NUWD        A6NUWD                         Numbers and Wor
     C                   MOVEL     #1MICD        A6MICD                         Minor Currency
     C                   MOVEL     #1DLOC        A6DLOC                         Deflt Loc Code CSW09
     C                   MOVEL     #1CLSC        A6CLSC                         CLS Currency   CDL00
     C                   Z-ADD     #1EFDT        A6EFDT                         Effective Date CDL00
     C                   MOVEL     #1SETD        A6SETD
     C                   MOVEL     #1IRDP        A6IRDP
     C     CSD043        IFEQ      'Y'
     C     PACCPT        ANDEQ     'A'
     C     P2ANCD        ANDEQ     'X'
     C                   MOVE      AAAACC        A6AACC
     C**********           Z-ADDAAEACC    A6EACC                                     CSD031 BUG11870
     C                   Z-ADD     BJRDNB        A6EACC
     C                   MOVE      AAGPDT        A6GPDT
     C                   ENDIF
      *                                                                                       CER043
     C     CER043        IFEQ      'Y'
     C                   MOVE      #1RETP        A6RETP
     C                   ENDIF
      *                                                                                       CGL014
     C     CGL014        IFEQ      'Y'
     C     CLE025        OREQ      'Y'
     C     WUN4ST        OREQ      'Y'
     C                   MOVEL     #1EXWC        A6EXWC
     C                   MOVEL     #1POWC        A6POWC
     C                   ENDIF
      *
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YCRDCS
     C                   MOVE      'Y'           YCRDC
     C                   END
      * USER: Processing before Data update
      * Start of Fix E18248
      * CASE: PAR.FRI. Holiday is Blank
     C     #1FRIH        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           A6FRIH                         FRI. Holiday
     C                   END                                                    *FI
      * CASE: PAR.SAT. Holiday is Blank
     C     #1SATH        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           A6SATH                         SAT. Holiday
     C                   END                                                    *FI
      * CASE: PAR.SUN. Holiday is Blank
     C     #1SUNH        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           A6SUNH                         SUN. Holiday
     C                   END                                                    *FI
      * End of Fix 18248
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
     C/COPY WNCPYSRC,SD0021RC12
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
      * Start of SAR S01117
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,WN0481CCP1                                           S01408
     C***********          CALL 'WIND01'                                  S01212
     C                   CALL      'WN0010'                                                    S0121
     C*********************PARM           ##PGM            Program        S01212
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C*********************PARM *BLANK    FKEY    2        Function Key   S01212
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C*********************PARM           WUMEST           Action  S01212 S01229
     C*********************PARM           WUWMAC           Action  S01212 S01229
     C                   PARM      'A'           UACTCD            1            Action  S01212 S0122
     C                   PARM                    DATA                           Trans Data     S0121
     C                   PARM      *BLANK        W0RTN                          Return Code    S0121
     C                   PARM                    SPARE           256            Spare Field    LN035
      * End of SAR S01117
      * 00/Copy member SD0021RC01 - Currency Codes  *
     C/COPY WNCPYSRC,SD0021RC01
      * WM Check Return
      * CASE: PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      'USR0563'                                    *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SREXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SREXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SREXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RBUW - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RBUW
     C*
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RBDU - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RBDU
     C*
     C                   END                                                    *FI
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YCRDCS
     C                   MOVE      'Y'           YCRDC
     C                   END
      * If changed update record otherwise release record
     C     YCRDC         IFEQ      'Y'
      *                                                                                       CSD012
      * If CSD012 is ON and Currencies is ON, output details to Shadow file                   CSD012
     C     CSD012        IFEQ      'Y'
     C     SVAL11        ANDEQ     'Y'
     C     #1CYCD        CHAIN     SDCUSHL0                           90
     C     *IN90         IFEQ      *ON
     C                   WRITE     SDCUSHD0
     C                   ELSE
     C                   MOVEL     #1CYCD        A6CYCD                         Currency Code
     C                   MOVEL     #1SPAE        A6SPAE                         Spot Trade Acco
     C                   MOVEL     #1FTAE        A6FTAE                         Fwd Trade Accou
     C                   MOVEL     #1SWAE        A6SWAE                         Swap Trade Acco
     C                   MOVEL     #1TAC4        A6TAC4                         Trade Account C
     C                   MOVEL     #1TAC5        A6TAC5                         Trade Account C
     C                   MOVEL     #1CDFN        A6CDFN                         Cedel Default N
     C                   MOVEL     #1ECDN        A6ECDN                         Euroclear Defau
     C                   Z-ADD     WURDNB        A6LCD                          Last Change Dat
     C                   MOVEL     'A'           A6TYLC                         Type of Last Ch
     C                   MOVEL     #1CYNM        A6CYNM                         Currency Name
     C                   Z-ADD     #1SPRT        A6SPRT                         Spot Rate
     C                   MOVEL     #1SWCY        A6SWCY                         Swift Currency
     C                   Z-ADD     #1NBDP        A6NBDP                         Number of Decim
     C                   Z-ADD     #1TXND        A6TXND                         Telex Notice Da
     C                   Z-ADD     #1PRRT        A6PRRT                         Par Rate
     C                   Z-ADD     #1SRC1        A6SRC1                         Statutory Retur
     C                   Z-ADD     #1SRC2        A6SRC2                         Statutory Retur
     C                   MOVEL     #1DLCI        A6DLCI                         Dealing Currenc
     C                   Z-ADD     #1SSNB        A6SSNB                         Sort Sequence N
     C                   Z-ADD     #1ERLC        A6ERLC                         Exchange Rate -
     C                   MOVEL     #1MDIN        A6MDIN                         Multiply/Divide
     C                   MOVEL     #1MDPR        A6MDPR                         Multiply/Divide
     C                   MOVEL     #1MDHB        A6MDHB                         Multiply/Divide
     C                   MOVEL     #1MDEX        A6MDEX                         Multiply/Divide
     C                   MOVEL     #1NOSN        A6NOSN                         Nostro Shortnam
     C                   Z-ADD     #1SPDY        A6SPDY                         Spot Days
     C                   Z-ADD     #1HSRT        A6HSRT                         High Spot Rate
     C                   Z-ADD     #1LSPR        A6LSPR                         Low Spot Rate
     C                   Z-ADD     #1FXSD        A6FXSD                         DRS FX Spot Dat
     C                   Z-ADD     #1MMSD        A6MMSD                         DRS MM Spot Dat
     C                   Z-ADD     #1NQDP        A6NQDP                         Normally Quoted
     C                   MOVEL     #1DICB        A6DICB                         Default Int. Ca
     C                   Z-ADD     #1SCEX        A6SCEX                         Scaling Exponen
     C                   MOVEL     #1EBDA        A6EBDA                         Eurobond Data
     C                   Z-ADD     #1HBRT        A6HBRT                         Historic Broker
     C                   Z-ADD     #1ENC1        A6ENC1                         Euroclear Numer
     C                   Z-ADD     #1ENC2        A6ENC2                         Euroclear Numer
     C                   MOVEL     #1CACD        A6CACD                         Cedel Alpha Cod
     C                   Z-ADD     #1CNMC        A6CNMC                         Cedel Numeric C
     C                   MOVEL     #1WEDH        A6WEDH                         WED. Holiday
     C                   MOVEL     #1MONH        A6MONH                         MON. Holiday
     C                   MOVEL     #1TUEH        A6TUEH                         TUES. Holiday
     C                   MOVEL     #1THUH        A6THUH                         THURS. Holiday
     C                   MOVEL     #1FRIH        A6FRIH                         FRI. Holiday
     C                   MOVEL     #1SATH        A6SATH                         SAT. Holiday
     C                   MOVEL     #1SUNH        A6SUNH                         SUN. Holiday
     C                   Z-ADD     #1DPBF        A6DPBF                         Dec.Places in B
     C                   Z-ADD     #1BYSR        A6BYSR                         Buy Spread Rate
     C                   MOVEL     #1BYSS        A6BYSS                         Buy Spread Sign
     C                   Z-ADD     #1SLSR        A6SLSR                         Sell Spread Rat
     C                   MOVEL     #1SLSS        A6SLSS                         Sell Spread Sig
     C                   Z-ADD     #1RMCM        A6RMCM                         RM Cashflow Mag
     C                   MOVEL     'D'           A6RECI                         Record Id
     C                   MOVEL     #1DPRU        A6DPRU                         Default Priorit
     C                   MOVEL     #1DNOR        A6DNOR                         Delivery Notifi
     C                   MOVEL     #1NDWR        A6NDWR                         Non-Delivery Wa
     C                   MOVEL     #1GMPY        A6GMPY                         Generate Multip
     C                   MOVEL     #1DLCD        A6DLCD                         Delivery Code
     C                   MOVEL     #1RDFC        A6RDFC                         Round Down Inte
     C                   MOVEL     #1PMRT        A6PMRT                         Precious Metal
     C                   Z-ADD     #1RKSQ        A6RKSQ                         Currency Rankin
     C                   MOVEL     #1DFPC        A6DFPC                         Dft Fx Poss Pro
     C                   MOVEL     #1DDPC        A6DDPC                         Dft Dir Fund Pr
     C                   Z-ADD     #1TKCC        A6TKCC                         Telekurs Curren
     C                   Z-ADD     #1CQCD        A6CQCD                         Cheque Clearing
     C                   Z-ADD     #1SMLD        A6SMLD                         Smallest Denomi
     C                   MOVEL     #1CSCD        A6CSCD                         Cash Account Co
     C                   Z-ADD     #1ISON        A6ISON                         Numeric ISO Cur
     C                   MOVEL     #1ISFC        A6ISFC                         ISDA Financial
     C                   MOVEL     #1MACD        A6MACD                         Major Currency
     C                   MOVEL     #1FRAC        A6FRAC                         Fractions Flag
     C                   MOVEL     #1NUWD        A6NUWD                         Numbers and Wor
     C                   MOVEL     #1MICD        A6MICD                         Minor Currency
     C                   MOVEL     'N'           A6INCY                         In Ccy Indicat
     C                   Z-ADD     0             A6EUER                         EMU Exchng Rat
     C                   MOVEL     *BLANK        A6EUMD                         EMU Mult/Div
     C                   Z-ADD     0             A6TPSD                         EMU Trans. Str
     C                   Z-ADD     0             A6TPED                         EMU Trans. End
     C                   Z-ADD     0             A6INER                         OUT/EUR Ex.Rat
     C                   MOVEL     *BLANK        A6INMD                         OUT/EUR Mul/Div
     C                   MOVEL     #1DLOC        A6DLOC                         Deflt Loc Code
     C                   MOVEL     *BLANK        A6CYPI                         Portfolio profi
     C                   Z-ADD     0             A6EXWC                         Exposure weight
     C                   Z-ADD     0             A6POWC                         Position weight
     C                   Z-ADD     0             A6CYD1                         Day n1 renewal
     C                   Z-ADD     0             A6CYD2                         Day n2 renewal
     C                   Z-ADD     0             A6CYD3                         Day n3 renewal
     C                   MOVEL     *BLANK        A6CYLD                         Last Day in Mon
     C                   MOVEL     *BLANK        A6CYGR                         Currency Group
     C                   Z-ADD     0             A6RENO                         Renewal notice
     C                   MOVEL     #1CLSC        A6CLSC                         CLS Currency
     C                   Z-ADD     #1EFDT        A6EFDT                         Effective Date
     C                   MOVEL     #1SETD        A6SETD
     C                   MOVEL     #1IRDP        A6IRDP
     C                   Z-ADD     0             A6SWDP
     C                   Z-ADD     0             A6SWDT
     C                   Z-ADD     0             A6DFTS
      *                                                                                       CER043
     C     CER043        IFEQ      'Y'
     C                   MOVE      #1RETP        A6RETP
     C                   ENDIF
      *                                                                                       CGL014
     C     CGL014        IFEQ      'Y'
     C     CLE025        OREQ      'Y'
     C     WUN4ST        OREQ      'Y'
     C                   MOVEL     #1EXWC        A6EXWC
     C                   MOVEL     #1POWC        A6POWC
     C                   ENDIF
      *                                                                                       CGL014
     C                   UPDATE    SDCUSHD0
     C                   ENDIF
      *                                                                                       CSD012
     C                   ELSE
      *                                                                                       CSD031
     C     CSD043        IFEQ      'Y'
     C     PACCPT        IFEQ      'C'
     C     P2ANCD        ANDEQ     'A'
      *                                                                                       CSD031
     C     CUROPN        IFNE      'Y'
     C                   OPEN      SDACURL0
     C                   MOVE      'Y'           CUROPN
     C                   ENDIF
      *                                                                                       CSD031
     C     #1CYCD        CHAIN     SDACURL0                           9091
     C     *IN90         IFEQ      '0'
     C                   MOVE      'CSD0002'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99
     C                   MOVEL     'N'           UPDTOK
     C     CUROPN        IFEQ      'Y'
     C                   CLOSE     SDACURL0
     C                   MOVE      'N'           CUROPN
     C                   ENDIF
     C                   GOTO      SREXIT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD012
     C                   UPDATE    @A6REA4                              91      *
     C                   MOVE      'Y'           UPDTOK            1
     C                   ENDIF
      *                                                                                       CSD012
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDCURRL0                             91      *
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
      * USER: Processing after Data update
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RADU - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RADU
     C*
     C                   END                                                    *FI
      *                                                                                       CMG003
      ** Store new values of Currency and SWIFT Currency Code                                 CMG003
      *                                                                                       CMG003
     C                   MOVEL     A6CYCD        WNCYCD            3
     C                   MOVEL     A6SWCY        WNSWCY            3
     C     A6PMRT        IFEQ      'N'
     C                   MOVEL     WOCYCD        PHCYCD
     C                   MOVEL     '-'           PHDASH
     C                   MOVEL     WOSWCY        PHSWCY
     C                   MOVEL     'Y'           #1CRDL
     C                   EXSR      SRDEL
     C                   ENDIF
      *                                                                                       CMG003
     C                   END
      *================================================================
     CSR   SREXIT        ENDSR
      /EJECT
     CSR   SSCRRC        BEGSR
      *================================================================
      * Create Curr Codes 2 - Currency Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @A6REA4
     C                   MOVEL     #1CYCD        A6CYCD                         Currency Code
     C                   MOVEL     #1SPAE        A6SPAE                         Spot Trade Acco
     C                   MOVEL     #1FTAE        A6FTAE                         Fwd Trade Accou
     C                   MOVEL     #1SWAE        A6SWAE                         Swap Trade Acco
     C                   MOVEL     #1TAC4        A6TAC4                         Trade Account C
     C                   MOVEL     #1TAC5        A6TAC5                         Trade Account C
     C                   MOVEL     #1CDFN        A6CDFN                         Cedel Default N
     C                   MOVEL     #1ECDN        A6ECDN                         Euroclear Defau
     C                   Z-ADD     #1LCD         A6LCD                          Last Change Dat
     C                   MOVEL     #1TYLC        A6TYLC                         Type of Last Ch
     C                   MOVEL     #1CYNM        A6CYNM                         Currency Name
     C                   Z-ADD     #1SPRT        A6SPRT                         Spot Rate
     C                   MOVEL     #1SWCY        A6SWCY                         Swift Currency
     C                   Z-ADD     #1NBDP        A6NBDP                         Number of Decim
     C                   Z-ADD     #1TXND        A6TXND                         Telex Notice Da
     C                   Z-ADD     #1PRRT        A6PRRT                         Par Rate
     C                   Z-ADD     #1SRC1        A6SRC1                         Statutory Retur
     C                   Z-ADD     #1SRC2        A6SRC2                         Statutory Retur
     C                   MOVEL     #1DLCI        A6DLCI                         Dealing Currenc
     C                   Z-ADD     #1SSNB        A6SSNB                         Sort Sequence N
     C                   Z-ADD     #1ERLC        A6ERLC                         Exchange Rate -
     C                   MOVEL     #1MDIN        A6MDIN                         Multiply/Divide
     C                   MOVEL     #1MDPR        A6MDPR                         Multiply/Divide
     C                   MOVEL     #1MDHB        A6MDHB                         Multiply/Divide
     C                   MOVEL     #1MDEX        A6MDEX                         Multiply/Divide
     C                   MOVEL     #1NOSN        A6NOSN                         Nostro Shortnam
     C                   Z-ADD     #1SPDY        A6SPDY                         Spot Days
     C                   Z-ADD     #1HSRT        A6HSRT                         High Spot Rate
     C                   Z-ADD     #1LSPR        A6LSPR                         Low Spot Rate
     C                   Z-ADD     #1FXSD        A6FXSD                         DRS FX Spot Dat
     C                   Z-ADD     #1MMSD        A6MMSD                         DRS MM Spot Dat
     C                   Z-ADD     #1NQDP        A6NQDP                         Normally Quoted
     C                   MOVEL     #1DICB        A6DICB                         Default Int. Ca
     C                   Z-ADD     #1SCEX        A6SCEX                         Scaling Exponen
     C                   MOVEL     #1EBDA        A6EBDA                         Eurobond Data
     C                   Z-ADD     #1HBRT        A6HBRT                         Historic Broker
     C                   Z-ADD     #1ENC1        A6ENC1                         Euroclear Numer
     C                   Z-ADD     #1ENC2        A6ENC2                         Euroclear Numer
     C                   MOVEL     #1CACD        A6CACD                         Cedel Alpha Cod
     C                   Z-ADD     #1CNMC        A6CNMC                         Cedel Numeric C
     C                   MOVEL     #1WEDH        A6WEDH                         WED. Holiday
     C                   MOVEL     #1MONH        A6MONH                         MON. Holiday
     C                   MOVEL     #1TUEH        A6TUEH                         TUES. Holiday
     C                   MOVEL     #1THUH        A6THUH                         THURS. Holiday
     C                   MOVEL     #1FRIH        A6FRIH                         FRI. Holiday
     C                   MOVEL     #1SATH        A6SATH                         SAT. Holiday
     C                   MOVEL     #1SUNH        A6SUNH                         SUN. Holiday
     C                   Z-ADD     #1DPBF        A6DPBF                         Dec.Places in B
     C                   Z-ADD     #1BYSR        A6BYSR                         Buy Spread Rate
     C                   MOVEL     #1BYSS        A6BYSS                         Buy Spread Sign
     C                   Z-ADD     #1SLSR        A6SLSR                         Sell Spread Rat
     C                   MOVEL     #1SLSS        A6SLSS                         Sell Spread Sig
     C                   Z-ADD     #1RMCM        A6RMCM                         RM Cashflow Mag
     C                   MOVEL     'D'           A6RECI                         Record Id
     C                   MOVEL     #1DPRU        A6DPRU                         Default Priorit
     C                   MOVEL     #1DNOR        A6DNOR                         Delivery Notifi
     C                   MOVEL     #1NDWR        A6NDWR                         Non-Delivery Wa
     C                   MOVEL     #1GMPY        A6GMPY                         Generate Multip
     C                   MOVEL     #1DLCD        A6DLCD                         Delivery Code
     C                   MOVEL     #1RDFC        A6RDFC                         Round Down Inte
     C                   MOVEL     #1PMRT        A6PMRT                         Precious Metal
     C                   Z-ADD     #1RKSQ        A6RKSQ                         Currency Rankin
     C                   MOVEL     #1DFPC        A6DFPC                         Dft Fx Poss Pro
     C                   MOVEL     #1DDPC        A6DDPC                         Dft Dir Fund Pr
     C                   Z-ADD     #1TKCC        A6TKCC                         Telekurs Curren
     C                   Z-ADD     #1CQCD        A6CQCD                         Cheque Clearing
     C                   Z-ADD     #1SMLD        A6SMLD                         Smallest Denomi
     C                   MOVEL     #1CSCD        A6CSCD                         Cash Account Co
     C                   Z-ADD     #1ISON        A6ISON                         Numeric ISO Cur
     C                   MOVEL     #1ISFC        A6ISFC                         ISDA Financial
     C                   MOVEL     #1MACD        A6MACD                         Major Currency
     C                   MOVEL     #1FRAC        A6FRAC                         Fractions Flag
     C                   MOVEL     #1NUWD        A6NUWD                         Numbers and Wor
     C                   MOVEL     #1MICD        A6MICD                         Minor Currency
     C                   MOVEL     #1DLOC        A6DLOC                         Deflt Loc Code CSW09
     C                   MOVEL     #1CLSC        A6CLSC                         CLS Currency   CDL00
     C                   Z-ADD     #1EFDT        A6EFDT                         Effective Date CDL00
     C                   MOVEL     #1SETD        A6SETD
     C                   MOVEL     #1IRDP        A6IRDP
      *                                                                                       CER043
     C     CER043        IFEQ      'Y'
     C                   MOVE      #1RETP        A6RETP
     C                   ENDIF
      *                                                                                       CGL014
     C     CGL014        IFEQ      'Y'
     C     CLE025        OREQ      'Y'
     C     WUN4ST        OREQ      'Y'
     C                   MOVEL     #1EXWC        A6EXWC
     C                   MOVEL     #1POWC        A6POWC
     C                   ENDIF
      *
      * USER: Processing before Data update
      * Start of Fix LN0360
      * Move processing to update the backgroud files to processing
      * after update
      * End of Fix LN0360
      * Start of fix E18248.
      * CASE: PAR.FRI. Holiday is Blank
     C     #1FRIH        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           A6FRIH                         FRI. Holiday
     C                   END                                                    *FI
      * CASE: PAR.SAT. Holiday is Blank
     C     #1SATH        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           A6SATH                         SAT. Holiday
     C                   END                                                    *FI
      * CASE: PAR.SUN. Holiday is Blank
     C     #1SUNH        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           A6SUNH                         SUN. Holiday
     C                   END                                                    *FI
      * End of fix E18248.
     C/COPY WNCPYSRC,SD0021RC13
      * Start S01408
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,WN0481CCP1                                           S01408
     C***********          CALL 'WIND01'                                  S01212
     C                   CALL      'WN0010'                                                    S0121
     C*********************PARM           ##PGM            Program        S01212
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C*********************PARM *BLANK    FKEY    2        Function Key   S01212
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C*********************PARM           WUMEST           Action  S01212 S01229
     C*********************PARM           WUWMAC           Action  S01212 S01229
     C                   PARM      'I'           UACTCD            1            Action  S01212 S0122
     C                   PARM                    DATA                           Trans Data     S0121
     C                   PARM      *BLANK        W0RTN                          Return Code    S0121
     C                   PARM                    SPARE           256            Spare Field    LN035
     C/COPY WNCPYSRC,EML110_004                                                               EML110
      * WM Check Return
      * CASE: PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      'USR0563'                                    *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SSEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SSEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SSEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End S01408
     C     KLCRSS        KLIST
     C                   KFLD                    A6CYCD                         Currency Code
      * Check for duplicate primary key
     C     KLCRSS        SETLL     @A6REA4                                90    *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR0072'     W0RTN             7
      * Send message 'Currency Codes         EX'
     C                   MOVEL     'USR0072'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SSEXIT
     C                   END
      *
      * If CSD012 is ON and Currencies is ON, output details to Shadow file                   CSD012
     C     CSD012        IFEQ      'Y'
     C     SVAL11        ANDEQ     'Y'
     C                   WRITE     SDCUSHD0                             91
      *                                                                                       CSD012
     C                   GOTO      SSEXIT
     C                   ELSE
      *                                                                                       CSD012
     C                   WRITE     @A6REA4                              91      *
     C                   ENDIF
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * USER: Processing after Data update
      * Start of LN0360
     C                   Z-ADD     1             WUNORC                         No. of Records
     C                   Z-ADD     1             WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
      * Change Standing Data Cont - Standing Data Controls  *
     C**********           EXSR STCHRC                                                      MD025467
     C                   EXSR      UPDSDT
      * Background Update CCY - Currency Codes  *
     C                   CALL      'SD0021U'                            90      Background Upda
     C     W0RTN         PARM      *BLANK        WQ0105            7            *Return code
     C                   PARM      A6CYCD        WQ0106            3            Currency Code
     C**********           PARM A6SPAE    WQ0107  4        Spot Trade Acco                    CGL029
     C**********           PARM A6FTAE    WQ0108  4        Fwd Trade Accou                    CGL029
     C**********           PARM A6SWAE    WQ0109  4        Swap Trade Acco                    CGL029
     C**********           PARM A6TAC4    WQ0110  4        Trade Account C                    CGL029
     C**********           PARM A6TAC5    WQ0111  4        Trade Account C                    CGL029
     C                   PARM      A6SPAE        WQ0107           10
     C                   PARM      A6FTAE        WQ0108           10
     C                   PARM      A6SWAE        WQ0109           10
     C                   PARM      A6TAC4        WQ0110           10
     C                   PARM      A6TAC5        WQ0111           10
     C                   PARM      A6CDFN        WQ0112            2            Cedel Default N
     C                   PARM      A6ECDN        WQ0113            2            Euroclear Defau
     C                   PARM      A6LCD         WQ0114            5 0          Last Change Dat
     C                   PARM      A6TYLC        WQ0115            1            Type of Last Ch
     C                   PARM      A6CYNM        WQ0116           14            Currency Name
     C                   PARM      A6SPRT        WQ0117           13 8          Spot Rate
     C                   PARM      A6SWCY        WQ0118            3            Swift Currency
     C                   PARM      A6NBDP        WQ0119            1 0          Number of Decim
     C                   PARM      A6TXND        WQ0120            1 0          Telex Notice Da
     C                   PARM      A6PRRT        WQ0121           13 8          Par Rate
     C                   PARM      A6SRC1        WQ0122            4 0          Statutory Retur
     C                   PARM      A6SRC2        WQ0123            4 0          Statutory Retur
     C                   PARM      A6DLCI        WQ0124            1            Dealing Currenc
     C                   PARM      A6SSNB        WQ0125            2 0          Sort Sequence N
     C                   PARM      A6ERLC        WQ0126           13 8          Exchange Rate -
     C                   PARM      A6MDIN        WQ0127            1            Multiply/Divide
     C                   PARM      A6MDPR        WQ0128            1            Multiply/Divide
     C                   PARM      A6MDHB        WQ0129            1            Multiply/Divide
     C                   PARM      A6MDEX        WQ0130            1            Multiply/Divide
     C                   PARM      A6NOSN        WQ0131           10            Nostro Shortnam
     C                   PARM      A6SPDY        WQ0132            3 0          Spot Days
     C                   PARM      A6FXSD        WQ0133            8 0          DRS FX Spot Dat
     C                   PARM      A6MMSD        WQ0134            8 0          DRS MM Spot Dat
     C                   PARM      A6NQDP        WQ0135            1 0          Normally Quoted
     C                   PARM      A6DICB        WQ0136            1            Default Int. Ca
     C                   PARM      A6SCEX        WQ0137            1 0          Scaling Exponen
     C                   PARM      A6EBDA        WQ0138           29            Eurobond Data
     C                   PARM      A6HBRT        WQ0139           13 8          Historic Broker
     C                   PARM      A6ENC1        WQ0140            2 0          Euroclear Numer
     C                   PARM      A6ENC2        WQ0141            2 0          Euroclear Numer
     C                   PARM      A6CACD        WQ0142            3            Cedel Alpha Cod
     C                   PARM      A6CNMC        WQ0143            2 0          Cedel Numeric C
     C                   PARM      A6FRIH        WQ0144            1            FRI. Holiday
     C                   PARM      A6SATH        WQ0145            1            SAT. Holiday
     C                   PARM      A6SUNH        WQ0146            1            SUN. Holiday
     C                   PARM      A6DPBF        WQ0147            1 0          Dec.Places in B
     C                   PARM      A6BYSR        WQ0148           13 8          Buy Spread Rate
     C                   PARM      A6BYSS        WQ0149            1            Buy Spread Sign
     C                   PARM      A6SLSR        WQ0150           13 8          Sell Spread Rat
     C                   PARM      A6SLSS        WQ0151            1            Sell Spread Sig
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0021U'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
      * Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
      * S01319 - remove call to SD0022U - CMSDULL background update
     C                   END                                                    *FI
      * Fix of LN0360
      * Start S01408
      * End S01408
     C                   END
      *================================================================
     CSR   SSEXIT        ENDSR
      /EJECT
      *****************************************************************                     MD025467
      *                                                               *                     MD025467
      * UPDSDT - Update SDFCTLPA (Standing Data Control)              *                     MD025467
      *                                                               *                     MD025467
      *****************************************************************                     MD025467
     C     UPDSDT        BEGSR
      *                                                                                     MD025467
     C                   MOVEL     *BLANKS       W0RTN             7
      *                                                                                     MD025467
      ** Check if record still exists                                                       MD025467
      ** otherwise, send message and prevent writing a record                               MD025467
      *                                                                                     MD025467
     C                   MOVEL(P)  'SDCURRPD'    AHFLNM
     C     AHFLNM        CHAIN     @AHREAU                            90
     C     *IN90         IFEQ      *ON
     C                   MOVEL     'Y2U0009'     W0RTN
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                     MD025467
      ** Check if there are any changes before write                                        MD025467
      *                                                                                     MD025467
     C     *IN90         IFEQ      *OFF
     C     WUNORC        IFNE      0
     C     WUNOIN        ORNE      0
     C     WUNOAM        ORNE      0
     C     WUNODL        ORNE      0
     C                   Z-ADD     WUNORC        XHNORC
     C                   Z-ADD     WUNOIN        XHNOIN
     C                   Z-ADD     WUNOAM        XHNOAM
     C                   Z-ADD     WUNODL        XHNODL
      *                                                                                     MD025467
     C                   WRITE     SDFCTLA0                             91
     C     *IN91         IFEQ      *ON
     C                   MOVEL     'Y2U0004'     W0RTN
     C                   ENDIF
      *                                                                                     MD025467
     C                   ENDIF
     C                   ENDIF
      *                                                                                     MD025467
     C                   ENDSR
     C***SR*****    STCHRC    BEGSR                                                         MD025467
      *================================================================
      **Change*Standing*Data*Cont*-*Standing*Data*Controls*************                     MD025467
      *================================================================
     C**********           MOVEL*BLANK    W0RTN   7                                         MD025467
      **Set*PGM.*Record*Data*Changed*flag******************************                     MD025467
     C**********           MOVE 'N'       YDRDC   1                                         MD025467
      *****************************************************************                     MD025467
      **Move*key*fields*to*@AHREAU*************************************                     MD025467
     C**********           MOVE *BLANK    AHFLNM           Filename                         MD025467
     C**********           MOVEL'SDCURRPD'AHFLNM           Filename                         MD025467
      *****************************************************************                     MD025467
     C********** KLCHST    KLIST                                                            MD025467
     C**********           KFLD           AHFLNM           Filename                         MD025467
     C********** KLCHST    CHAIN@AHREAU              9091  *                                MD025467
      *****************************************************************                     MD025467
     C********** *IN90     IFEQ '1'                                                         MD025467
      **Record*not*found***********************************************                     MD025467
     C**********           MOVEL'Y2U0009' W0RTN   7                                         MD025467
      **Send*message*'*Record*no*longer*on*file'***********************                     MD025467
     C**********           MOVEL'Y2U0009' ZAMSID                                            MD025467
     C**********           MOVEL'Y2USRMSG'ZAMSGF                                            MD025467
     C**********           EXSR ZASNMS                                                      MD025467
     C**********           GOTO STEXIT                                                      MD025467
     C**********           END                                                              MD025467
      *****************************************************************                     MD025467
     C********** *IN91     IFEQ '1'                                                         MD025467
      **Record*locked**************************************************                     MD025467
     C**********           MOVEL'Y2U0004' W0RTN   7                                         MD025467
     C**********           GOTO STEXIT                                                      MD025467
     C**********           END                                                              MD025467
      *****************************************************************                     MD025467
      **Store*record*data*for*null*update*check************************                     MD025467
     C**********           MOVE QSDFC1    YDRDCS                                            MD025467
      **USER:*Processing*after*Data*read*******************************                     MD025467
     C**********           ADD  AHNORC    WUNORC           No. of Records                   MD025467
     C**********           ADD  AHNOIN    WUNOIN           No. of Inserts                   MD025467
     C**********           ADD  AHNOAM    WUNOAM           No. of Amends                    MD025467
     C**********           ADD  AHNODL    WUNODL           No. of Deletes                   MD025467
      **Move*non-key*fields*to*@AHREAU*********************************                     MD025467
     C**********           Z-ADDWUNORC    AHNORC           No. of Records                   MD025467
     C**********           Z-ADDWUNOIN    AHNOIN           No. of Inserts                   MD025467
     C**********           Z-ADDWUNOAM    AHNOAM           No. of Amends                    MD025467
     C**********           Z-ADDWUNODL    AHNODL           No. of Deletes                   MD025467
      *****************************************************************                     MD025467
      **Set*PGM.*Record*Data*Changed*flag******************************                     MD025467
     C********** QSDFC1    IFNE YDRDCS                                                      MD025467
     C**********           MOVE 'Y'       YDRDC                                             MD025467
     C**********           END                                                              MD025467
      **If*changed*update*record*otherwise*release*record**************                     MD025467
     C********** YDRDC     IFEQ 'Y'                                                         MD025467
     C**********           UPDAT@AHREAU                91  *                                MD025467
     C**********           ELSE                                                             MD025467
      **Release*record*lock********************************************                     MD025467
     C**********           UNLCKSDFCTLL0               91  *                                MD025467
     C**********           END                                                              MD025467
     C********** *IN91     IFEQ '1'                                                         MD025467
      **Change*error*detected******************************************                     MD025467
     C**********           MOVEL'Y2U0004' W0RTN   7                                         MD025467
     C**********           ELSE                                                             MD025467
      *****************************************************************                     MD025467
      **DBF*change*successful******************************************                     MD025467
     C**********           END                                                              MD025467
      *================================================================
     C***SR*****    STEXIT    ENDSR                                                         MD025467
      /EJECT
     CSR   SUCHRC        BEGSR
      *================================================================
      * Change Curr Codes 2 - Currency Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YERDC             1
      *
      * Move key fields to @A6REA4
     C                   MOVEL     #1CYCD        A6CYCD                         Currency Code
      *
     C     KLCHSU        KLIST
     C                   KFLD                    A6CYCD                         Currency Code
     C     KLCHSU        CHAIN     @A6REA4                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SUEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SUEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      @1DBRC        YERDCS
      * Move non-key fields to @A6REA4
     C                   MOVEL     #1SPAE        A6SPAE                         Spot Trade Acco
     C                   MOVEL     #1FTAE        A6FTAE                         Fwd Trade Accou
     C                   MOVEL     #1SWAE        A6SWAE                         Swap Trade Acco
     C                   MOVEL     #1TAC4        A6TAC4                         Trade Account C
     C                   MOVEL     #1TAC5        A6TAC5                         Trade Account C
     C                   MOVEL     #1CDFN        A6CDFN                         Cedel Default N
     C                   MOVEL     #1ECDN        A6ECDN                         Euroclear Defau
     C                   Z-ADD     #1LCD         A6LCD                          Last Change Dat
     C                   MOVEL     #1TYLC        A6TYLC                         Type of Last Ch
     C                   MOVEL     #1CYNM        A6CYNM                         Currency Name
     C                   Z-ADD     #1SPRT        A6SPRT                         Spot Rate
     C                   MOVEL     #1SWCY        A6SWCY                         Swift Currency
     C                   Z-ADD     #1NBDP        A6NBDP                         Number of Decim
     C                   Z-ADD     #1TXND        A6TXND                         Telex Notice Da
     C                   Z-ADD     #1PRRT        A6PRRT                         Par Rate
     C                   Z-ADD     #1SRC1        A6SRC1                         Statutory Retur
     C                   Z-ADD     #1SRC2        A6SRC2                         Statutory Retur
     C                   MOVEL     #1DLCI        A6DLCI                         Dealing Currenc
     C                   Z-ADD     #1SSNB        A6SSNB                         Sort Sequence N
     C                   Z-ADD     #1ERLC        A6ERLC                         Exchange Rate -
     C                   MOVEL     #1MDIN        A6MDIN                         Multiply/Divide
     C                   MOVEL     #1MDPR        A6MDPR                         Multiply/Divide
     C                   MOVEL     #1MDHB        A6MDHB                         Multiply/Divide
     C                   MOVEL     #1MDEX        A6MDEX                         Multiply/Divide
     C                   MOVEL     #1NOSN        A6NOSN                         Nostro Shortnam
     C                   Z-ADD     #1SPDY        A6SPDY                         Spot Days
     C                   Z-ADD     #1HSRT        A6HSRT                         High Spot Rate
     C                   Z-ADD     #1LSPR        A6LSPR                         Low Spot Rate
     C                   Z-ADD     #1FXSD        A6FXSD                         DRS FX Spot Dat
     C                   Z-ADD     #1MMSD        A6MMSD                         DRS MM Spot Dat
     C                   Z-ADD     #1NQDP        A6NQDP                         Normally Quoted
     C                   MOVEL     #1DICB        A6DICB                         Default Int. Ca
     C                   Z-ADD     #1SCEX        A6SCEX                         Scaling Exponen
     C                   MOVEL     #1EBDA        A6EBDA                         Eurobond Data
     C                   Z-ADD     #1HBRT        A6HBRT                         Historic Broker
     C                   Z-ADD     #1ENC1        A6ENC1                         Euroclear Numer
     C                   Z-ADD     #1ENC2        A6ENC2                         Euroclear Numer
     C                   MOVEL     #1CACD        A6CACD                         Cedel Alpha Cod
     C                   Z-ADD     #1CNMC        A6CNMC                         Cedel Numeric C
     C                   MOVEL     #1WEDH        A6WEDH                         WED. Holiday
     C                   MOVEL     #1MONH        A6MONH                         MON. Holiday
     C                   MOVEL     #1TUEH        A6TUEH                         TUES. Holiday
     C                   MOVEL     #1THUH        A6THUH                         THURS. Holiday
     C                   MOVEL     #1FRIH        A6FRIH                         FRI. Holiday
     C                   MOVEL     #1SATH        A6SATH                         SAT. Holiday
     C                   MOVEL     #1SUNH        A6SUNH                         SUN. Holiday
     C                   Z-ADD     #1DPBF        A6DPBF                         Dec.Places in B
     C                   Z-ADD     #1BYSR        A6BYSR                         Buy Spread Rate
     C                   MOVEL     #1BYSS        A6BYSS                         Buy Spread Sign
     C                   Z-ADD     #1SLSR        A6SLSR                         Sell Spread Rat
     C                   MOVEL     #1SLSS        A6SLSS                         Sell Spread Sig
     C                   Z-ADD     #1RMCM        A6RMCM                         RM Cashflow Mag
     C                   MOVEL     #1RECI        A6RECI                         Record Id
     C                   MOVEL     #1DPRU        A6DPRU                         Default Priorit
     C                   MOVEL     #1DNOR        A6DNOR                         Delivery Notifi
     C                   MOVEL     #1NDWR        A6NDWR                         Non-Delivery Wa
     C                   MOVEL     #1GMPY        A6GMPY                         Generate Multip
     C                   MOVEL     #1DLCD        A6DLCD                         Delivery Code
     C                   MOVEL     #1RDFC        A6RDFC                         Round Down Inte
     C                   MOVEL     #1PMRT        A6PMRT                         Precious Metal
     C                   Z-ADD     #1RKSQ        A6RKSQ                         Currency Rankin
     C                   MOVEL     #1DFPC        A6DFPC                         Dft Fx Poss Pro
     C                   MOVEL     #1DDPC        A6DDPC                         Dft Dir Fund Pr
     C                   Z-ADD     #1TKCC        A6TKCC                         Telekurs Curren
     C                   Z-ADD     #1CQCD        A6CQCD                         Cheque Clearing
     C                   Z-ADD     #1SMLD        A6SMLD                         Smallest Denomi
     C                   MOVEL     #1CSCD        A6CSCD                         Cash Account Co
     C                   Z-ADD     #1ISON        A6ISON                         Numeric ISO Cur
     C                   MOVEL     #1ISFC        A6ISFC                         ISDA Financial
     C                   MOVEL     #1MACD        A6MACD                         Major Currency
     C                   MOVEL     #1FRAC        A6FRAC                         Fractions Flag
     C                   MOVEL     #1NUWD        A6NUWD                         Numbers and Wor
     C                   MOVEL     #1MICD        A6MICD                         Minor Currency
     C                   MOVEL     #1DLOC        A6DLOC                         Dflt.Loc.Code  CSW09
     C                   MOVEL     #1CLSC        A6CLSC                         CLS Currency   CDL00
     C                   Z-ADD     #1EFDT        A6EFDT                         Effective Date CDL00
     C                   MOVEL     #1SETD        A6SETD
     C                   MOVEL     #1IRDP        A6IRDP
      *                                                                                       CER043
     C     CER043        IFEQ      'Y'
     C                   MOVE      #1RETP        A6RETP
     C                   ENDIF
      *                                                                                       CGL014
     C     CGL014        IFEQ      'Y'
     C     CLE025        OREQ      'Y'
     C     WUN4ST        OREQ      'Y'
     C                   MOVEL     #1EXWC        A6EXWC
     C                   MOVEL     #1POWC        A6POWC
     C                   ENDIF
      *
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YERDCS
     C                   MOVE      'Y'           YERDC
     C                   END
      * USER: Processing before Data update
      * Start of fix E18248
      * CASE: PAR.FRI. Holiday is Blank
     C     #1FRIH        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           A6FRIH                         FRI. Holiday
     C                   END                                                    *FI
      * CASE: PAR.SAT. Holiday is Blank
     C     #1SATH        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           A6SATH                         SAT. Holiday
     C                   END                                                    *FI
      * CASE: PAR.SUN. Holiday is Blank
     C     #1SUNH        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           A6SUNH                         SUN. Holiday
     C                   END                                                    *FI
      * End of fix E18248
     C/COPY WNCPYSRC,SD0021RC14
      * Start S01408
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,WN0481CCP1                                           S01408
     C***********          CALL 'WIND01'                                  S01212
     C                   CALL      'WN0010'                                                    S0121
     C*********************PARM           ##PGM            Program        S01212
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C*********************PARM *BLANK    FKEY    2        Function Key   S01212
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C*********************PARM           WUMEST           Action  S01212 S01229
     C*********************PARM           WUWMAC           Action  S01212 S01229
     C                   PARM      'A'           UACTCD            1            Action  S01212 S0122
     C                   PARM                    DATA                           Trans Data     S0121
     C                   PARM      *BLANK        W0RTN                          Return Code    S0121
     C                   PARM                    SPARE           256            Spare Field    LN035
     C/COPY WNCPYSRC,EML110_005                                                               EML110
      * WM Check Return
      * CASE: PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      'USR0563'                                    *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SUEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SUEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SUEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End S01408
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YERDCS
     C                   MOVE      'Y'           YERDC
     C                   END
      * If changed update record otherwise release record
     C     YERDC         IFEQ      'Y'
      *                                                                                       CSD012
      * If CSD012 is ON and Currencies is ON, output details to Shadow file                   CSD012
     C     CSD012        IFEQ      'Y'
     C     SVAL11        ANDEQ     'Y'
     C     #1CYCD        CHAIN     SDCUSHL0                           90
     C     *IN90         IFEQ      *ON
     C                   WRITE     SDCUSHD0
     C                   ELSE
     C                   MOVEL     #1CYCD        A6CYCD                         Currency Code
     C                   MOVEL     #1SPAE        A6SPAE                         Spot Trade Acco
     C                   MOVEL     #1FTAE        A6FTAE                         Fwd Trade Accou
     C                   MOVEL     #1SWAE        A6SWAE                         Swap Trade Acco
     C                   MOVEL     #1TAC4        A6TAC4                         Trade Account C
     C                   MOVEL     #1TAC5        A6TAC5                         Trade Account C
     C                   MOVEL     #1CDFN        A6CDFN                         Cedel Default N
     C                   MOVEL     #1ECDN        A6ECDN                         Euroclear Defau
     C                   Z-ADD     WURDNB        A6LCD                          Last Change Dat
     C                   MOVEL     'A'           A6TYLC                         Type of Last Ch
     C                   MOVEL     #1CYNM        A6CYNM                         Currency Name
     C                   Z-ADD     #1SPRT        A6SPRT                         Spot Rate
     C                   MOVEL     #1SWCY        A6SWCY                         Swift Currency
     C                   Z-ADD     #1NBDP        A6NBDP                         Number of Decim
     C                   Z-ADD     #1TXND        A6TXND                         Telex Notice Da
     C                   Z-ADD     #1PRRT        A6PRRT                         Par Rate
     C                   Z-ADD     #1SRC1        A6SRC1                         Statutory Retur
     C                   Z-ADD     #1SRC2        A6SRC2                         Statutory Retur
     C                   MOVEL     #1DLCI        A6DLCI                         Dealing Currenc
     C                   Z-ADD     #1SSNB        A6SSNB                         Sort Sequence N
     C                   Z-ADD     #1ERLC        A6ERLC                         Exchange Rate -
     C                   MOVEL     #1MDIN        A6MDIN                         Multiply/Divide
     C                   MOVEL     #1MDPR        A6MDPR                         Multiply/Divide
     C                   MOVEL     #1MDHB        A6MDHB                         Multiply/Divide
     C                   MOVEL     #1MDEX        A6MDEX                         Multiply/Divide
     C                   MOVEL     #1NOSN        A6NOSN                         Nostro Shortnam
     C                   Z-ADD     #1SPDY        A6SPDY                         Spot Days
     C                   Z-ADD     #1HSRT        A6HSRT                         High Spot Rate
     C                   Z-ADD     #1LSPR        A6LSPR                         Low Spot Rate
     C                   Z-ADD     #1FXSD        A6FXSD                         DRS FX Spot Dat
     C                   Z-ADD     #1MMSD        A6MMSD                         DRS MM Spot Dat
     C                   Z-ADD     #1NQDP        A6NQDP                         Normally Quoted
     C                   MOVEL     #1DICB        A6DICB                         Default Int. Ca
     C                   Z-ADD     #1SCEX        A6SCEX                         Scaling Exponen
     C                   MOVEL     #1EBDA        A6EBDA                         Eurobond Data
     C                   Z-ADD     #1HBRT        A6HBRT                         Historic Broker
     C                   Z-ADD     #1ENC1        A6ENC1                         Euroclear Numer
     C                   Z-ADD     #1ENC2        A6ENC2                         Euroclear Numer
     C                   MOVEL     #1CACD        A6CACD                         Cedel Alpha Cod
     C                   Z-ADD     #1CNMC        A6CNMC                         Cedel Numeric C
     C                   MOVEL     #1WEDH        A6WEDH                         WED. Holiday
     C                   MOVEL     #1MONH        A6MONH                         MON. Holiday
     C                   MOVEL     #1TUEH        A6TUEH                         TUES. Holiday
     C                   MOVEL     #1THUH        A6THUH                         THURS. Holiday
     C                   MOVEL     #1FRIH        A6FRIH                         FRI. Holiday
     C                   MOVEL     #1SATH        A6SATH                         SAT. Holiday
     C                   MOVEL     #1SUNH        A6SUNH                         SUN. Holiday
     C                   Z-ADD     #1DPBF        A6DPBF                         Dec.Places in B
     C                   Z-ADD     #1BYSR        A6BYSR                         Buy Spread Rate
     C                   MOVEL     #1BYSS        A6BYSS                         Buy Spread Sign
     C                   Z-ADD     #1SLSR        A6SLSR                         Sell Spread Rat
     C                   MOVEL     #1SLSS        A6SLSS                         Sell Spread Sig
     C                   Z-ADD     #1RMCM        A6RMCM                         RM Cashflow Mag
     C                   MOVEL     'D'           A6RECI                         Record Id
     C                   MOVEL     #1DPRU        A6DPRU                         Default Priorit
     C                   MOVEL     #1DNOR        A6DNOR                         Delivery Notifi
     C                   MOVEL     #1NDWR        A6NDWR                         Non-Delivery Wa
     C                   MOVEL     #1GMPY        A6GMPY                         Generate Multip
     C                   MOVEL     #1DLCD        A6DLCD                         Delivery Code
     C                   MOVEL     #1RDFC        A6RDFC                         Round Down Inte
     C                   MOVEL     #1PMRT        A6PMRT                         Precious Metal
     C                   Z-ADD     #1RKSQ        A6RKSQ                         Currency Rankin
     C                   MOVEL     #1DFPC        A6DFPC                         Dft Fx Poss Pro
     C                   MOVEL     #1DDPC        A6DDPC                         Dft Dir Fund Pr
     C                   Z-ADD     #1TKCC        A6TKCC                         Telekurs Curren
     C                   Z-ADD     #1CQCD        A6CQCD                         Cheque Clearing
     C                   Z-ADD     #1SMLD        A6SMLD                         Smallest Denomi
     C                   MOVEL     #1CSCD        A6CSCD                         Cash Account Co
     C                   Z-ADD     #1ISON        A6ISON                         Numeric ISO Cur
     C                   MOVEL     #1ISFC        A6ISFC                         ISDA Financial
     C                   MOVEL     #1MACD        A6MACD                         Major Currency
     C                   MOVEL     #1FRAC        A6FRAC                         Fractions Flag
     C                   MOVEL     #1NUWD        A6NUWD                         Numbers and Wor
     C                   MOVEL     #1MICD        A6MICD                         Minor Currency
     C                   MOVEL     'N'           A6INCY                         In Ccy Indicat
     C                   Z-ADD     0             A6EUER                         EMU Exchng Rat
     C                   MOVEL     *BLANK        A6EUMD                         EMU Mult/Div
     C                   Z-ADD     0             A6TPSD                         EMU Trans. Str
     C                   Z-ADD     0             A6TPED                         EMU Trans. End
     C                   Z-ADD     0             A6INER                         OUT/EUR Ex.Rat
     C                   MOVEL     *BLANK        A6INMD                         OUT/EUR Mul/Div
     C                   MOVEL     #1DLOC        A6DLOC                         Deflt Loc Code
     C                   MOVEL     *BLANK        A6CYPI                         Portfolio profi
     C                   Z-ADD     0             A6EXWC                         Exposure weight
     C                   Z-ADD     0             A6POWC                         Position weight
     C                   Z-ADD     0             A6CYD1                         Day n1 renewal
     C                   Z-ADD     0             A6CYD2                         Day n2 renewal
     C                   Z-ADD     0             A6CYD3                         Day n3 renewal
     C                   MOVEL     *BLANK        A6CYLD                         Last Day in Mon
     C                   MOVEL     *BLANK        A6CYGR                         Currency Group
     C                   Z-ADD     0             A6RENO                         Renewal notice
     C                   MOVEL     #1CLSC        A6CLSC                         CLS Currency
     C                   Z-ADD     #1EFDT        A6EFDT                         Effective Date
     C                   MOVEL     #1SETD        A6SETD
     C                   MOVEL     #1IRDP        A6IRDP
     C                   Z-ADD     0             A6SWDP
     C                   Z-ADD     0             A6SWDT
     C                   Z-ADD     0             A6DFTS
      *                                                                                       CER043
     C     CER043        IFEQ      'Y'
     C                   MOVE      #1RETP        A6RETP
     C                   ENDIF
      *                                                                                       CGL014
     C     CGL014        IFEQ      'Y'
     C     CLE025        OREQ      'Y'
     C     WUN4ST        OREQ      'Y'
     C                   MOVEL     #1EXWC        A6EXWC
     C                   MOVEL     #1POWC        A6POWC
     C                   ENDIF
      *                                                                                       CGL014
     C                   UPDATE    SDCUSHD0
     C                   ENDIF
      *                                                                                       CSD012
     C                   ELSE
      *                                                                                       CSD012
     C                   UPDATE    @A6REA4                              91      *
     C                   ENDIF
      *                                                                                       CSD012
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDCURRL0                             91      *
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SUEXIT        ENDSR
      /EJECT
     CSR   SVRVGN        BEGSR
      *================================================================
      * RTV for Chg, Add or Del - Currency Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSV         KLIST
     C                   KFLD                    A6CYCD                         Currency Code
      * Move fields to key list
     C                   MOVEL     #1CYCD        A6CYCD                         Currency Code
      *                                                                                       CSD031
      ** If Acceptance mode, access acceptance file SDACURL0                                  CSD031
      *                                                                                       CSD031
     C     CSD043        IFEQ      'Y'
     C     PACCPT        IFEQ      'A'
     C     KRSSV         CHAIN     SDCURRD0                           90
     C                   ELSE
     C     KRSSV         CHAIN     @A6REA3                            90
     C                   ENDIF
     C                   ELSE
     C     KRSSV         CHAIN     @A6REA3                            90        *
     C                   ENDIF
      * Data record not found
     C   90              MOVEL     'USR0071'     W0RTN             7
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   Z-ADD     *ZERO         WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
      * CASE: PAR.Type of Last Change is Amend
     C     #1TYLC        IFEQ      'A'                                          *IF
     C                   Z-ADD     1             WUNOAM                         No. of Amends
     C                   END                                                    *FI
      * CASE: PAR.Type of Last Change is Delete
     C     #1TYLC        IFEQ      'D'                                          *IF
     C                   Z-ADD     1             WUNODL                         No. of Deletes
     C                   Z-ADD     -1            WUNORC                         No. of Records
     C                   END                                                    *FI
      * CASE: PAR.Type of Last Change is Insert
     C     #1TYLC        IFEQ      'I'                                          *IF
     C                   Z-ADD     1             WUNOIN                         No. of Inserts
     C                   Z-ADD     1             WUNORC                         No. of Records
     C                   END                                                    *FI
      * Start of SAR S01117
      * Change code to filename CCY - SDCURRPD
      * Change Standing Data Cont - Standing Data Controls  *
     C**********           EXSR SWCHRC                                                      MD025467
     C                   EXSR      UPDSDT
      * End of SAR S01117
      * Background Update CCY - Currency Codes  *
     C                   CALL      'SD0021U'                            90      Background Upda
     C     W0RTN         PARM      *BLANK        WQ0163            7            *Return code
     C                   PARM      A6CYCD        WQ0164            3            Currency Code
     C**********           PARM A6SPAE    WQ0165  4        Spot Trade Acco                    CGL029
     C**********           PARM A6FTAE    WQ0166  4        Fwd Trade Accou                    CGL029
     C**********           PARM A6SWAE    WQ0167  4        Swap Trade Acco                    CGL029
     C**********           PARM A6TAC4    WQ0168  4        Trade Account C                    CGL029
     C**********           PARM A6TAC5    WQ0169  4        Trade Account C                    CGL029
     C                   PARM      A6SPAE        WQ0165           10
     C                   PARM      A6FTAE        WQ0166           10
     C                   PARM      A6SWAE        WQ0167           10
     C                   PARM      A6TAC4        WQ0168           10
     C                   PARM      A6TAC5        WQ0169           10
     C                   PARM      A6CDFN        WQ0170            2            Cedel Default N
     C                   PARM      A6ECDN        WQ0171            2            Euroclear Defau
     C                   PARM      A6LCD         WQ0172            5 0          Last Change Dat
     C                   PARM      #1TYLC        WQ0173            1            Type of Last Ch
     C                   PARM      A6CYNM        WQ0174           14            Currency Name
     C                   PARM      A6SPRT        WQ0175           13 8          Spot Rate
     C                   PARM      A6SWCY        WQ0176            3            Swift Currency
     C                   PARM      A6NBDP        WQ0177            1 0          Number of Decim
     C                   PARM      A6TXND        WQ0178            1 0          Telex Notice Da
     C                   PARM      A6PRRT        WQ0179           13 8          Par Rate
     C                   PARM      A6SRC1        WQ0180            4 0          Statutory Retur
     C                   PARM      A6SRC2        WQ0181            4 0          Statutory Retur
     C                   PARM      A6DLCI        WQ0182            1            Dealing Currenc
     C                   PARM      A6SSNB        WQ0183            2 0          Sort Sequence N
     C                   PARM      A6ERLC        WQ0184           13 8          Exchange Rate -
     C                   PARM      A6MDIN        WQ0185            1            Multiply/Divide
     C                   PARM      A6MDPR        WQ0186            1            Multiply/Divide
     C                   PARM      A6MDHB        WQ0187            1            Multiply/Divide
     C                   PARM      A6MDEX        WQ0188            1            Multiply/Divide
     C                   PARM      A6NOSN        WQ0189           10            Nostro Shortnam
     C                   PARM      A6SPDY        WQ0190            3 0          Spot Days
     C                   PARM      A6FXSD        WQ0191            8 0          DRS FX Spot Dat
     C                   PARM      A6MMSD        WQ0192            8 0          DRS MM Spot Dat
     C                   PARM      A6NQDP        WQ0193            1 0          Normally Quoted
     C                   PARM      A6DICB        WQ0194            1            Default Int. Ca
     C                   PARM      A6SCEX        WQ0195            1 0          Scaling Exponen
     C                   PARM      A6EBDA        WQ0196           29            Eurobond Data
     C                   PARM      A6HBRT        WQ0197           13 8          Historic Broker
     C                   PARM      A6ENC1        WQ0198            2 0          Euroclear Numer
     C                   PARM      A6ENC2        WQ0199            2 0          Euroclear Numer
     C                   PARM      A6CACD        WQ0200            3            Cedel Alpha Cod
     C                   PARM      A6CNMC        WQ0201            2 0          Cedel Numeric C
     C                   PARM      A6FRIH        WQ0202            1            FRI. Holiday
     C                   PARM      A6SATH        WQ0203            1            SAT. Holiday
     C                   PARM      A6SUNH        WQ0204            1            SUN. Holiday
     C                   PARM      A6DPBF        WQ0205            1 0          Dec.Places in B
     C                   PARM      A6BYSR        WQ0206           13 8          Buy Spread Rate
     C                   PARM      A6BYSS        WQ0207            1            Buy Spread Sign
     C                   PARM      A6SLSR        WQ0208           13 8          Sell Spread Rat
     C                   PARM      A6SLSS        WQ0209            1            Sell Spread Sig
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0021U'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
     C                   END
      *================================================================
     CSR   SVEXIT        ENDSR
      /EJECT
     C***SR*****    SWCHRC    BEGSR                                                         MD025467
      *================================================================
      **Change*Standing*Data*Cont*-*Standing*Data*Controls*************                     MD025467
      *================================================================
     C**********           MOVEL*BLANK    W0RTN   7                                         MD025467
      **Set*PGM.*Record*Data*Changed*flag******************************                     MD025467
     C**********           MOVE 'N'       YFRDC   1                                         MD025467
      *****************************************************************                     MD025467
      **Move*key*fields*to*@AHREAU*************************************                     MD025467
     C**********           MOVE *BLANK    AHFLNM           Filename                         MD025467
     C**********           MOVEL'SDCURRPD'AHFLNM           Filename                         MD025467
      *****************************************************************                     MD025467
     C********** KLCHSW    KLIST                                                            MD025467
     C**********           KFLD           AHFLNM           Filename                         MD025467
     C********** KLCHSW    CHAIN@AHREAU              9091  *                                MD025467
      *****************************************************************                     MD025467
     C********** *IN90     IFEQ '1'                                                         MD025467
      **Record*not*found***********************************************                     MD025467
     C**********           MOVEL'Y2U0009' W0RTN   7                                         MD025467
      **Send*message*'*Record*no*longer*on*file'***********************                     MD025467
     C**********           MOVEL'Y2U0009' ZAMSID                                            MD025467
     C**********           MOVEL'Y2USRMSG'ZAMSGF                                            MD025467
     C**********           EXSR ZASNMS                                                      MD025467
     C**********           GOTO SWEXIT                                                      MD025467
     C**********           END                                                              MD025467
      *****************************************************************                     MD025467
     C********** *IN91     IFEQ '1'                                                         MD025467
      **Record*locked**************************************************                     MD025467
     C**********           MOVEL'Y2U0004' W0RTN   7                                         MD025467
     C**********           GOTO SWEXIT                                                      MD025467
     C**********           END                                                              MD025467
      *****************************************************************                     MD025467
      **Store*record*data*for*null*update*check************************                     MD025467
     C**********           MOVE QSDFC1    YFRDCS                                            MD025467
      **USER:*Processing*after*Data*read*******************************                     MD025467
     C**********           ADD  AHNORC    WUNORC           No. of Records                   MD025467
     C**********           ADD  AHNOIN    WUNOIN           No. of Inserts                   MD025467
     C**********           ADD  AHNOAM    WUNOAM           No. of Amends                    MD025467
     C**********           ADD  AHNODL    WUNODL           No. of Deletes                   MD025467
      **Move*non-key*fields*to*@AHREAU*********************************                     MD025467
     C**********           Z-ADDWUNORC    AHNORC           No. of Records                   MD025467
     C**********           Z-ADDWUNOIN    AHNOIN           No. of Inserts                   MD025467
     C**********           Z-ADDWUNOAM    AHNOAM           No. of Amends                    MD025467
     C**********           Z-ADDWUNODL    AHNODL           No. of Deletes                   MD025467
      *****************************************************************                     MD025467
      **Set*PGM.*Record*Data*Changed*flag******************************                     MD025467
     C********** QSDFC1    IFNE YFRDCS                                                      MD025467
     C**********           MOVE 'Y'       YFRDC                                             MD025467
     C**********           END                                                              MD025467
      **If*changed*update*record*otherwise*release*record**************                     MD025467
     C********** YFRDC     IFEQ 'Y'                                                         MD025467
     C**********           UPDAT@AHREAU                91  *                                MD025467
     C**********           ELSE                                                             MD025467
      **Release*record*lock********************************************                     MD025467
     C**********           UNLCKSDFCTLL0               91  *                                MD025467
     C**********           END                                                              MD025467
     C********** *IN91     IFEQ '1'                                                         MD025467
      **Change*error*detected******************************************                     MD025467
     C**********           MOVEL'Y2U0004' W0RTN   7                                         MD025467
     C**********           ELSE                                                             MD025467
      *****************************************************************                     MD025467
      **DBF*change*successful******************************************                     MD025467
     C**********           END
      *================================================================
     C***SR*****    SWEXIT    ENDSR                                                         MD025467
      /EJECT
     CSR   SXDLRC        BEGSR
      *================================================================
      * Delete Currency Codes - Currency Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
     C                   CLEAR                   PHRC
     C                   MOVEL     '-'           PHDASH
     C                   MOVEL     #1CYCD        PHCYCD
     C                   MOVEL     #1SWCY        PHSWCY
      * USER: Processing before Data update
      * CASE: PAR.Action Code is Delete
     C     P2ANCD        IFEQ      'D'                                          *IF
     C     CSD043        OREQ      'Y'
     C     PACCPT        ANDEQ     'A'
     C     P2ANCD        ANDEQ     'X'
     C                   ELSE
      * CASE: *OTHERWISE
      * Send message 'Function key not allowed'
     C                   MOVEL     'USR0533'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   MOVEL     'Y2U0004'     W0RTN                          *Return code
     C                   GOTO      SXEXIT                                       *QUIT
     C                   END                                                    *FI
      * CASE: WRK.Set Up Complete is Yes
     C     WUSUC         IFEQ      'Y'                                          *IF
     C                   MOVEL     '*NODEL*'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * RTV for Chg, Add or Del - Currency Codes  *
     C                   EXSR      SYRVGN
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     '*ERROR*'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * Start of Fix E21685
      * Check that the currency has no exchange rates and interest
      * rates.
      * Can Currency be deleted? - Currency Codes  *
     C                   MOVEL     #1CYCD        U1CCY                                         E2168
     C     U1CCYL        CHAIN     FDCCYPP0                           9091                     E2168
     C     *IN91         IFEQ      '1'                                                         E2168
     C* RECORD LOCKED                                                     E21685
     C                   MOVEL     'Y2U0004'     W0RTN             7                           E2168
     C                   END                                                                   E2168
     C*                                                                   E21685
     C** IF A RECORD EXISTS ON THE FILE THEN EXCHANGE RATES ARE PRESENT
     C** FOR THE CURRENCY WHICH CAN NOT BE DELETED.
     C** THE CURRENCY CANNOT CHANGE FROM A DEALING TO A NON-DEALING ONE   E24686
     C*                                                                   E21685
     C     *IN90         IFEQ      '0'                                                         E2168
     C                   MOVE      'E'           WUERST                                        E2168
     C                   END                                                                   E2168
     C                   MOVEL     #1CYCD        U2CCY                                         E2168
     C***********          MOVEL'D'       U2TPRD                    E21685E24686
     C***********          Z-ADD1         U2PRD                     E21685E24686
     C     U2INTR        CHAIN     FDINTRP0                           9091                     E2168
     C     *IN91         IFEQ      '1'                                                         E2168
     C** RECORD LOCKED                                                    E21685
     C                   MOVEL     'Y2U0004'     W0RTN             7                           E2168
     C                   END                                                                   E2168
     C     *IN90         IFEQ      '0'                                                         E2168
     C*
     C** IF A RECORD HAS BEEN FOUND ON THE FILE THEN INTEREST RATES
     C** EXIST FOR THE CURRENCY AND CAN NOT BE DELETED
     C** THE CURRENCY CANNOT CHANGE FROM A DEALING TO A NON-DEALING ONE   E24686
     C*
     C     WUERST        IFEQ      'E'                                                         E2168
     C*
     C** IF THE ERROR STATUS IS 'E' THEN SET THE ERROR STATUS TO 'B' FOR
     C** BOTH
     C*
     C                   MOVE      'B'           WUERST                                        E2168
     C                   ELSE                                                                  E2168
     C                   MOVE      'I'           WUERST                                        E2168
     C                   END                                                                   E2168
     C                   END                                                                   E2168
     C/EJECT                                                              E21685
     C*****************************************************************   E21685
      * CASE: WRK.Error Status is Exchange Rate
     C     WUERST        IFEQ      'E'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CYCD        ZA0071                         Currency Code
      * Send message 'Exchange rate for curr'
     C                   MOVEL     'USR1523'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y2U0004'     W0RTN                          *Return code
     C                   GOTO      SXEXIT                                       *QUIT
     C                   END                                                    *FI
      * CASE: WRK.Error Status is Interest Rate
     C     WUERST        IFEQ      'I'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CYCD        ZA0072                         Currency Code
      * Send message 'Interest Rate for curr'
     C                   MOVEL     'USR1524'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y2U0004'     W0RTN                          *Return code
     C                   GOTO      SXEXIT                                       *QUIT
     C                   END                                                    *FI
      * CASE: WRK.Error Status is Both
     C     WUERST        IFEQ      'B'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CYCD        ZA0073                         Currency Code
      * Send message 'Exchange rate for curr'
     C                   MOVEL     'USR1523'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
      * Setup message data for message
     C                   MOVEL     #1CYCD        ZA0074                         Currency Code
      * Send message 'Interest Rate for curr'
     C                   MOVEL     'USR1524'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y2U0004'     W0RTN                          *Return code
     C                   GOTO      SXEXIT                                       *QUIT
     C                   END                                                    *FI
      * End of Fix E21685
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
     C/COPY WNCPYSRC,SD0021RC15
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
      * Start of SAR S01117
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,WN0481CCP1                                           S01408
     C***********          CALL 'WIND01'                                  S01212
     C                   CALL      'WN0010'                                                    S0121
     C*********************PARM           ##PGM            Program        S01212
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C*********************PARM *BLANK    FKEY    2        Function Key   S01212
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C*********************PARM           WUMEST           Action  S01212 S01229
     C*********************PARM           WUWMAC           Action  S01212 S01229
     C                   PARM      'D'           UACTCD            1            Action  S01212 S0122
     C                   PARM                    DATA                           Trans Data     S0121
     C                   PARM      *BLANK        W0RTN                          Return Code    S0121
     C                   PARM                    SPARE           256            Spare Field    LN035
     C/COPY WNCPYSRC,EML110_006                                                               EML110
      * End of SAR S01117
      * WM Check Return
      * CASE: PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      'USR0563'                                    *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SXEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SXEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SXEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RDBW - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RDBW
     C*
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RDBU - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RDBU
     C*
     C                   END                                                    *FI
      * Move key fields to @A6REA4
     C                   MOVEL     #1CYCD        A6CYCD                         Currency Code
      *
     C     KLDLSX        KLIST
     C                   KFLD                    A6CYCD                         Currency Code
     C     KLDLSX        CHAIN     @A6REA4                            9091      *
     C     *IN90         IFEQ      '1'
      * Record already deleted
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SXEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
      * Send message '*Database operation error'
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SXEXIT
     C                   END
     C                   MOVEL     *BLANKS       #1CRDL            1
      *
      *................................................................
      * If CSD012 is ON and Currencies is ON, output details to Shadow file                   CSD012
      * and Authorisation Log.                                                                CSD012
     C     CSD012        IFEQ      'Y'
     C     SVAL11        ANDEQ     'Y'
     C                   MOVEL     'D'           A6TYLC                         Type of Last Ch
     C                   WRITE     SDCUSHD0                             91
      *                                                                                       CSD012
     C                   MOVEL     #1CYCD        K1CYCD
     C     KAULG         CHAIN     SDAULGL1                           90
      *                                                                                       CSD012
      * If record does not exist write details to Authoristion Log                            CSD012
     C     *IN90         IFEQ      *ON
     C                   MOVEL     #1CYCD        ALKEY
     C                   MOVEL     FUNCD         ALFUNC
     C                   MOVE      P2ANCD        ALACTN
     C                   MOVE      ##USR         ALUSER
     C                   WRITE     SDAULG1
     C                   ENDIF
     C                   MOVEL     'Y'           #1CRDL
     C                   EXSR      SRDEL
      *                                                                                       CMG003
     C                   GOTO      SXEXIT
      *                                                                                       CSD012
     C                   ELSE
      *                                                                                       CSD012
     C                   DELETE    @A6REA4                              91      *
     C                   MOVEL     'Y'           #1CRDL
     C                   ENDIF
      *                                                                                       CSD012
     C     *IN91         IFEQ      '1'
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF delete successful
      * USER: Processing after Data update
      * Start of change 122096
      * WUDELR Data Structure - SD Deleted Records File  *
     C                   MOVEL     @1DBRC        WUDELR
      * Write Deleted Record - SD Deleted Records File  *
     C                   CLEAR                   PFRC
     C                   MOVEL     'SDCURRPD'    PFFNME                         File name
     C                   MOVEL     #1CYCD        PFLKEY                         Long Key
     C                   MOVEL     WUDR01        PFDR01                         Deleted Data Re
     C                   MOVEL     WUDR02        PFDR02                         Deleted Data Re
     C                   MOVEL     WUDR03        PFDR03                         Deleted Data Re
     C                   MOVEL     WUDR04        PFDR04                         Deleted Data Re
     C                   MOVEL     WUDR05        PFDR05                         Deleted Data Re
     C                   MOVEL     WUDR06        PFDR06                         Deleted Data Re
     C                   MOVEL     WUDR07        PFDR07                         Deleted Data Re
     C                   MOVEL     WUDR08        PFDR08                         Deleted Data Re
     C                   MOVEL     WUDR09        PFDR09                         Deleted Data Re
     C                   MOVEL     WUDR00        PFDR00                         Deleted Data Re
     C                   MOVEL     WUDR11        PFDR11                         Deleted Data Re
     C                   MOVEL     WUDR12        PFDR12                         Deleted Data Re
     C                   Z-ADD     WURDNB        PFLCD                          Last Change Dat
     C                   MOVEL     'D'           PFTYLC                         Type of Last Ch
      *
     C                   CALL      'SD0520X'                            90      Write Deleted R
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PFRC                           RCD: SD Deleted
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0520X'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * End of change 122096
      *                                                                                       CMG003
     C                   EXSR      SRDEL
      *                                                                                       CMG003
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RDAU - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RDAU
     C*
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SXEXIT        ENDSR
      /EJECT
     CSR   SYRVGN        BEGSR
      *================================================================
      * RTV for Chg, Add or Del - Currency Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSY         KLIST
     C                   KFLD                    A6CYCD                         Currency Code
      * Move fields to key list
     C                   MOVEL     #1CYCD        A6CYCD                         Currency Code
      *                                                                                       CSD031
      ** If Acceptance mode, access acceptance file SDACURL0                                  CSD031
      *                                                                                       CSD031
     C     CSD043        IFEQ      'Y'
     C     PACCPT        IFEQ      'A'
     C     KRSSY         CHAIN     SDCURRD0                           90
     C                   ELSE
     C     KRSSY         CHAIN     @A6REA3                            90
     C                   ENDIF
     C                   ELSE
     C     KRSSY         CHAIN     @A6REA3                            90        *
     C                   ENDIF
      * Data record not found
     C   90              MOVEL     'USR0071'     W0RTN             7
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   Z-ADD     *ZERO         WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
      * CASE: PAR.Type of Last Change is Amend
      * changed 'D' to Action code field                                                    BUG11875
     C********** 'D'       IFEQ 'A'                        *IF                              BUG11875
     C     P2ANCD        IFEQ      'A'
     C                   Z-ADD     1             WUNOAM                         No. of Amends
     C                   END                                                    *FI
      * CASE: PAR.Type of Last Change is Delete
      * changed 'D' to Action code field                                                    BUG11875
     C********** 'D'       IFEQ 'D'                        *IF                              BUG11875
     C     P2ANCD        IFEQ      'D'
     C                   Z-ADD     1             WUNODL                         No. of Deletes
     C                   Z-ADD     -1            WUNORC                         No. of Records
     C                   END                                                    *FI
      * CASE: PAR.Type of Last Change is Insert
      * changed 'D' to Action code field                                                    BUG11875
     C********** 'D'       IFEQ 'I'                        *IF                              BUG11875
     C     P2ANCD        IFEQ      'I'
     C                   Z-ADD     1             WUNOIN                         No. of Inserts
     C                   Z-ADD     1             WUNORC                         No. of Records
     C                   END                                                    *FI
      * Start of SAR S01117
      * Change code to filename CCY - SDCURRPD
      * Change Standing Data Cont - Standing Data Controls  *
     C**********           EXSR SZCHRC                                                      MD025467
     C                   EXSR      UPDSDT
      * End of SAR S01117
      * Background Update CCY - Currency Codes  *
     C                   CALL      'SD0021U'                            90      Background Upda
     C     W0RTN         PARM      *BLANK        WQ0210            7            *Return code
     C                   PARM      A6CYCD        WQ0211            3            Currency Code
     C**********           PARM A6SPAE    WQ0212  4        Spot Trade Acco                    CGL029
     C**********           PARM A6FTAE    WQ0213  4        Fwd Trade Accou                    CGL029
     C**********           PARM A6SWAE    WQ0214  4        Swap Trade Acco                    CGL029
     C**********           PARM A6TAC4    WQ0215  4        Trade Account C                    CGL029
     C**********           PARM A6TAC5    WQ0216  4        Trade Account C                    CGL029
     C                   PARM      A6SPAE        WQ0212           10
     C                   PARM      A6FTAE        WQ0213           10
     C                   PARM      A6SWAE        WQ0214           10
     C                   PARM      A6TAC4        WQ0215           10
     C                   PARM      A6TAC5        WQ0216           10
     C                   PARM      A6CDFN        WQ0217            2            Cedel Default N
     C                   PARM      A6ECDN        WQ0218            2            Euroclear Defau
     C                   PARM      A6LCD         WQ0219            5 0          Last Change Dat
     C                   PARM      'D'           WQ0220            1            Type of Last Ch
     C                   PARM      A6CYNM        WQ0221           14            Currency Name
     C                   PARM      A6SPRT        WQ0222           13 8          Spot Rate
     C                   PARM      A6SWCY        WQ0223            3            Swift Currency
     C                   PARM      A6NBDP        WQ0224            1 0          Number of Decim
     C                   PARM      A6TXND        WQ0225            1 0          Telex Notice Da
     C                   PARM      A6PRRT        WQ0226           13 8          Par Rate
     C                   PARM      A6SRC1        WQ0227            4 0          Statutory Retur
     C                   PARM      A6SRC2        WQ0228            4 0          Statutory Retur
     C                   PARM      A6DLCI        WQ0229            1            Dealing Currenc
     C                   PARM      A6SSNB        WQ0230            2 0          Sort Sequence N
     C                   PARM      A6ERLC        WQ0231           13 8          Exchange Rate -
     C                   PARM      A6MDIN        WQ0232            1            Multiply/Divide
     C                   PARM      A6MDPR        WQ0233            1            Multiply/Divide
     C                   PARM      A6MDHB        WQ0234            1            Multiply/Divide
     C                   PARM      A6MDEX        WQ0235            1            Multiply/Divide
     C                   PARM      A6NOSN        WQ0236           10            Nostro Shortnam
     C                   PARM      A6SPDY        WQ0237            3 0          Spot Days
     C                   PARM      A6FXSD        WQ0238            8 0          DRS FX Spot Dat
     C                   PARM      A6MMSD        WQ0239            8 0          DRS MM Spot Dat
     C                   PARM      A6NQDP        WQ0240            1 0          Normally Quoted
     C                   PARM      A6DICB        WQ0241            1            Default Int. Ca
     C                   PARM      A6SCEX        WQ0242            1 0          Scaling Exponen
     C                   PARM      A6EBDA        WQ0243           29            Eurobond Data
     C                   PARM      A6HBRT        WQ0244           13 8          Historic Broker
     C                   PARM      A6ENC1        WQ0245            2 0          Euroclear Numer
     C                   PARM      A6ENC2        WQ0246            2 0          Euroclear Numer
     C                   PARM      A6CACD        WQ0247            3            Cedel Alpha Cod
     C                   PARM      A6CNMC        WQ0248            2 0          Cedel Numeric C
     C                   PARM      A6FRIH        WQ0249            1            FRI. Holiday
     C                   PARM      A6SATH        WQ0250            1            SAT. Holiday
     C                   PARM      A6SUNH        WQ0251            1            SUN. Holiday
     C                   PARM      A6DPBF        WQ0252            1 0          Dec.Places in B
     C                   PARM      A6BYSR        WQ0253           13 8          Buy Spread Rate
     C                   PARM      A6BYSS        WQ0254            1            Buy Spread Sign
     C                   PARM      A6SLSR        WQ0255           13 8          Sell Spread Rat
     C                   PARM      A6SLSS        WQ0256            1            Sell Spread Sig
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0021U'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
     C                   END
      *================================================================
     CSR   SYEXIT        ENDSR
      /EJECT
     C***SR*****    SZCHRC    BEGSR                                                         MD025467
      *================================================================
      **Change*Standing*Data*Cont*-*Standing*Data*Controls*************                     MD025467
      *================================================================
     C**********           MOVEL*BLANK    W0RTN   7                                         MD025467
      **Set*PGM.*Record*Data*Changed*flag******************************                     MD025467
     C**********           MOVE 'N'       YGRDC   1                                         MD025467
      *****************************************************************                     MD025467
      **Move*key*fields*to*@AHREAU*************************************                     MD025467
     C**********           MOVE *BLANK    AHFLNM           Filename                         MD025467
     C**********           MOVEL'SDCURRPD'AHFLNM           Filename                         MD025467
      *****************************************************************                     MD025467
     C********** KLCHSZ    KLIST                                                            MD025467
     C**********           KFLD           AHFLNM           Filename                         MD025467
     C********** KLCHSZ    CHAIN@AHREAU              9091  *                                MD025467
      *****************************************************************                     MD025467
     C********** *IN90     IFEQ '1'                                                         MD025467
      **Record*not*found***********************************************                     MD025467
     C**********           MOVEL'Y2U0009' W0RTN   7                                         MD025467
      **Send*message*'*Record*no*longer*on*file'***********************                     MD025467
     C**********           MOVEL'Y2U0009' ZAMSID                                            MD025467
     C**********           MOVEL'Y2USRMSG'ZAMSGF                                            MD025467
     C**********           EXSR ZASNMS                                                      MD025467
     C**********           GOTO SZEXIT                                                      MD025467
     C**********           END                                                              MD025467
      *****************************************************************                     MD025467
     C********** *IN91     IFEQ '1'                                                         MD025467
      **Record*locked**************************************************                     MD025467
     C**********           MOVEL'Y2U0004' W0RTN   7                                         MD025467
     C**********           GOTO SZEXIT                                                      MD025467
     C**********           END                                                              MD025467
      *****************************************************************                     MD025467
      **Store*record*data*for*null*update*check************************                     MD025467
     C**********           MOVE QSDFC1    YGRDCS                                            MD025467
      **USER:*Processing*after*Data*read*******************************                     MD025467
     C**********           ADD  AHNORC    WUNORC           No. of Records                   MD025467
     C**********           ADD  AHNOIN    WUNOIN           No. of Inserts                   MD025467
     C**********           ADD  AHNOAM    WUNOAM           No. of Amends                    MD025467
     C**********           ADD  AHNODL    WUNODL           No. of Deletes                   MD025467
      **Move*non-key*fields*to*@AHREAU*********************************                     MD025467
     C**********           Z-ADDWUNORC    AHNORC           No. of Records                   MD025467
     C**********           Z-ADDWUNOIN    AHNOIN           No. of Inserts                   MD025467
     C**********           Z-ADDWUNOAM    AHNOAM           No. of Amends                    MD025467
     C**********           Z-ADDWUNODL    AHNODL           No. of Deletes                   MD025467
      *****************************************************************                     MD025467
      **Set*PGM.*Record*Data*Changed*flag******************************                     MD025467
     C********** QSDFC1    IFNE YGRDCS                                                      MD025467
     C**********           MOVE 'Y'       YGRDC                                             MD025467
     C**********           END                                                              MD025467
      **If*changed*update*record*otherwise*release*record**************                     MD025467
     C********** YGRDC     IFEQ 'Y'                                                         MD025467
     C**********           UPDAT@AHREAU                91  *                                MD025467
     C**********           ELSE                                                             MD025467
      **Release*record*lock********************************************                     MD025467
     C**********           UNLCKSDFCTLL0               91  *                                MD025467
     C**********           END                                                              MD025467
     C********** *IN91     IFEQ '1'                                                         MD025467
      **Change*error*detected******************************************                     MD025467
     C**********           MOVEL'Y2U0004' W0RTN   7                                         MD025467
     C**********           ELSE                                                             MD025467
      *****************************************************************                     MD025467
      **DBF*change*successful******************************************                     MD025467
     C**********           END                                                              MD025467
      *================================================================
     C***SR*****    SZEXIT    ENDSR                                                         MD025467
      /EJECT
     CSR   TACRRC        BEGSR
      *================================================================
      * Create Currency Codes -LR - Currency Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @A6REA4
     C                   MOVEL     #1CYCD        A6CYCD                         Currency Code
     C                   MOVEL     #1SPAE        A6SPAE                         Spot Trade Acco
     C                   MOVEL     #1FTAE        A6FTAE                         Fwd Trade Accou
     C                   MOVEL     #1SWAE        A6SWAE                         Swap Trade Acco
     C                   MOVEL     #1TAC4        A6TAC4                         Trade Account C
     C                   MOVEL     #1TAC5        A6TAC5                         Trade Account C
     C                   MOVEL     #1CDFN        A6CDFN                         Cedel Default N
     C                   MOVEL     #1ECDN        A6ECDN                         Euroclear Defau
     C                   Z-ADD     WURDNB        A6LCD                          Last Change Dat
     C                   MOVEL     'I'           A6TYLC                         Type of Last Ch
     C                   MOVEL     #1CYNM        A6CYNM                         Currency Name
     C                   Z-ADD     #1SPRT        A6SPRT                         Spot Rate
     C                   MOVEL     #1SWCY        A6SWCY                         Swift Currency
     C                   Z-ADD     #1NBDP        A6NBDP                         Number of Decim
     C                   Z-ADD     #1TXND        A6TXND                         Telex Notice Da
     C                   Z-ADD     #1PRRT        A6PRRT                         Par Rate
     C                   Z-ADD     #1SRC1        A6SRC1                         Statutory Retur
     C                   Z-ADD     #1SRC2        A6SRC2                         Statutory Retur
     C                   MOVEL     #1DLCI        A6DLCI                         Dealing Currenc
     C                   Z-ADD     #1SSNB        A6SSNB                         Sort Sequence N
     C                   Z-ADD     #1ERLC        A6ERLC                         Exchange Rate -
     C                   MOVEL     #1MDIN        A6MDIN                         Multiply/Divide
     C                   MOVEL     #1MDPR        A6MDPR                         Multiply/Divide
     C                   MOVEL     #1MDHB        A6MDHB                         Multiply/Divide
     C                   MOVEL     #1MDEX        A6MDEX                         Multiply/Divide
     C                   MOVEL     #1NOSN        A6NOSN                         Nostro Shortnam
     C                   Z-ADD     #1SPDY        A6SPDY                         Spot Days
     C                   Z-ADD     #1HSRT        A6HSRT                         High Spot Rate
     C                   Z-ADD     #1LSPR        A6LSPR                         Low Spot Rate
     C                   Z-ADD     #1FXSD        A6FXSD                         DRS FX Spot Dat
     C                   Z-ADD     #1MMSD        A6MMSD                         DRS MM Spot Dat
     C                   Z-ADD     #1NQDP        A6NQDP                         Normally Quoted
     C                   MOVEL     #1DICB        A6DICB                         Default Int. Ca
     C                   Z-ADD     #1SCEX        A6SCEX                         Scaling Exponen
     C                   MOVEL     #1EBDA        A6EBDA                         Eurobond Data
     C                   Z-ADD     #1HBRT        A6HBRT                         Historic Broker
     C                   Z-ADD     #1ENC1        A6ENC1                         Euroclear Numer
     C                   Z-ADD     #1ENC2        A6ENC2                         Euroclear Numer
     C                   MOVEL     #1CACD        A6CACD                         Cedel Alpha Cod
     C                   Z-ADD     #1CNMC        A6CNMC                         Cedel Numeric C
     C                   MOVEL     #1WEDH        A6WEDH                         WED. Holiday
     C                   MOVEL     #1MONH        A6MONH                         MON. Holiday
     C                   MOVEL     #1TUEH        A6TUEH                         TUES. Holiday
     C                   MOVEL     #1THUH        A6THUH                         THURS. Holiday
     C                   MOVEL     #1FRIH        A6FRIH                         FRI. Holiday
     C                   MOVEL     #1SATH        A6SATH                         SAT. Holiday
     C                   MOVEL     #1SUNH        A6SUNH                         SUN. Holiday
     C                   Z-ADD     #1DPBF        A6DPBF                         Dec.Places in B
     C                   Z-ADD     #1BYSR        A6BYSR                         Buy Spread Rate
     C                   MOVEL     #1BYSS        A6BYSS                         Buy Spread Sign
     C                   Z-ADD     #1SLSR        A6SLSR                         Sell Spread Rat
     C                   MOVEL     #1SLSS        A6SLSS                         Sell Spread Sig
     C                   Z-ADD     #1RMCM        A6RMCM                         RM Cashflow Mag
     C                   MOVEL     'D'           A6RECI                         Record Id
     C                   MOVEL     #1DPRU        A6DPRU                         Default Priorit
     C                   MOVEL     #1DNOR        A6DNOR                         Delivery Notifi
     C                   MOVEL     #1NDWR        A6NDWR                         Non-Delivery Wa
     C                   MOVEL     #1GMPY        A6GMPY                         Generate Multip
     C                   MOVEL     #1DLCD        A6DLCD                         Delivery Code
     C                   MOVEL     #1RDFC        A6RDFC                         Round Down Inte
     C                   MOVEL     #1PMRT        A6PMRT                         Precious Metal
     C                   Z-ADD     #1RKSQ        A6RKSQ                         Currency Rankin
     C                   MOVEL     #1DFPC        A6DFPC                         Dft Fx Poss Pro
     C                   MOVEL     #1DDPC        A6DDPC                         Dft Dir Fund Pr
     C                   Z-ADD     #1TKCC        A6TKCC                         Telekurs Curren
     C                   Z-ADD     #1CQCD        A6CQCD                         Cheque Clearing
     C                   Z-ADD     #1SMLD        A6SMLD                         Smallest Denomi
     C                   MOVEL     #1CSCD        A6CSCD                         Cash Account Co
     C                   Z-ADD     #1ISON        A6ISON                         Numeric ISO Cur
     C                   MOVEL     #1ISFC        A6ISFC                         ISDA Financial
     C                   MOVEL     #1MACD        A6MACD                         Major Currency
     C                   MOVEL     #1FRAC        A6FRAC                         Fractions Flag
     C                   MOVEL     #1NUWD        A6NUWD                         Numbers and Wor
     C                   MOVEL     #1MICD        A6MICD                         Minor Currency
     C                   MOVEL     #1DLOC        A6DLOC                         Dflt.Loc.Code  CSW09
     C                   MOVEL     #1CLSC        A6CLSC                         CLS Currency   CDL00
     C                   Z-ADD     #1EFDT        A6EFDT                         Effective Date CDL00
     C                   MOVEL     #1SETD        A6SETD
     C                   MOVEL     #1IRDP        A6IRDP
      *                                                                                       CER043
     C     CER043        IFEQ      'Y'
     C                   MOVE      #1RETP        A6RETP
     C                   ENDIF
      *                                                                                       CGL014
     C     CGL014        IFEQ      'Y'
     C     CLE025        OREQ      'Y'
     C     WUN4ST        OREQ      'Y'
     C                   MOVEL     #1EXWC        A6EXWC
     C                   MOVEL     #1POWC        A6POWC
     C                   ENDIF
      *
      * USER: Processing before Data update
      * Start of Fix E18248
      * CASE: PAR.FRI. Holiday is Blank
     C     #1FRIH        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           A6FRIH                         FRI. Holiday
     C                   END                                                    *FI
      * CASE: PAR.SAT. Holiday is Blank
     C     #1SATH        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           A6SATH                         SAT. Holiday
     C                   END                                                    *FI
      * CASE: PAR.SUN. Holiday is Blank
     C     #1SUNH        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           A6SUNH                         SUN. Holiday
     C                   END                                                    *FI
      * End of Fix E18248
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
     C/COPY WNCPYSRC,SD0021RC16
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
      * Start of SAR S01117
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,WN0481CCP1                                           S01408
     C***********          CALL 'WIND01'                                  S01212
     C                   CALL      'WN0010'                                                    S0121
     C*********************PARM           ##PGM            Program        S01212
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C*********************PARM *BLANK    FKEY    2        Function Key   S01212
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C*********************PARM           WUMEST           Action  S01212 S01229
     C*********************PARM           WUWMAC           Action  S01212 S01229
     C                   PARM      'I'           UACTCD            1            Action  S01212 S0122
     C                   PARM                    DATA                           Trans Data     S0121
     C                   PARM      *BLANK        W0RTN                          Return Code    S0121
     C                   PARM                    SPARE           256            Spare Field    LN035
      * End of SAR S01117
      * 00/Copy member SD0021RC02 - Currency Codes  *
     C/COPY WNCPYSRC,SD0021RC02
      * WM Check Return
      * CASE: PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      'USR0563'                                    *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      TAEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      TAEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      TAEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RCBW - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RCBW
     C*
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RCBU - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RCBU
     C*
     C                   END                                                    *FI
     C     KLCRTA        KLIST
     C                   KFLD                    A6CYCD                         Currency Code
      * Check for duplicate primary key
     C     KLCRTA        SETLL     @A6REA4                                90    *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR0072'     W0RTN             7
      * Send message 'Currency Codes         EX'
     C                   MOVEL     'USR0072'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      TAEXIT
     C                   END
      *
      * If CSD012 is ON and Currencies is ON, output details to Shadow file                   CSD012
     C     CSD012        IFEQ      'Y'
     C     SVAL11        ANDEQ     'Y'
     C                   WRITE     SDCUSHD0                             91
      *                                                                                       CSD012
     C                   ELSE
      *                                                                                       CSD012
     C                   WRITE     @A6REA4                              91      *
     C                   ENDIF
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * USER: Processing after Data update
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RCAU - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RCAU
     C*
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   TAEXIT        ENDSR
      /EJECT
     CSR   TBDLRC        BEGSR
      *================================================================
      * Delete Currency Codes - Currency Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
     C                   CLEAR                   PHRC
     C                   MOVEL     '-'           PHDASH
     C                   MOVEL     #1CYCD        PHCYCD
     C                   MOVEL     #1SWCY        PHSWCY
      * USER: Processing before Data update
      * CASE: PAR.Action Code is Delete
     C     P2ANCD        IFEQ      'D'                                          *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * Send message 'Function key not allowed'
     C                   MOVEL     'USR0533'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   MOVEL     'Y2U0004'     W0RTN                          *Return code
     C                   GOTO      TBEXIT                                       *QUIT
     C                   END                                                    *FI
      * CASE: WRK.Set Up Complete is Yes
     C     WUSUC         IFEQ      'Y'                                          *IF
     C                   MOVEL     '*NODEL*'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * RTV for Chg, Add or Del - Currency Codes  *
     C                   EXSR      TCRVGN
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     '*ERROR*'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * Start of Fix E21685
      * Check that the currency has no exchange rates and interest
      * rates.
      * Can Currency be deleted? - Currency Codes  *
     C                   MOVEL     #1CYCD        U1CCY                                         E2168
     C     U1CCYL        CHAIN     FDCCYPP0                           9091                     E2168
     C     *IN91         IFEQ      '1'                                                         E2168
     C* RECORD LOCKED                                                     E21685
     C                   MOVEL     'Y2U0004'     W0RTN             7                           E2168
     C                   END                                                                   E2168
     C*                                                                   E21685
     C** IF A RECORD EXISTS ON THE FILE THEN EXCHANGE RATES ARE PRESENT
     C** FOR THE CURRENCY WHICH CAN NOT BE DELETED.
     C** THE CURRENCY CANNOT CHANGE FROM A DEALING TO A NON-DEALING ONE   E24686
     C*                                                                   E21685
     C     *IN90         IFEQ      '0'                                                         E2168
     C                   MOVE      'E'           WUERST                                        E2168
     C                   END                                                                   E2168
     C                   MOVEL     #1CYCD        U2CCY                                         E2168
     C***********          MOVEL'D'       U2TPRD                    E21685E24686
     C***********          Z-ADD1         U2PRD                     E21685E24686
     C     U2INTR        CHAIN     FDINTRP0                           9091                     E2168
     C     *IN91         IFEQ      '1'                                                         E2168
     C** RECORD LOCKED                                                    E21685
     C                   MOVEL     'Y2U0004'     W0RTN             7                           E2168
     C                   END                                                                   E2168
     C     *IN90         IFEQ      '0'                                                         E2168
     C*
     C** IF A RECORD HAS BEEN FOUND ON THE FILE THEN INTEREST RATES
     C** EXIST FOR THE CURRENCY AND CAN NOT BE DELETED
     C** THE CURRENCY CANNOT CHANGE FROM A DEALING TO A NON-DEALING ONE   E24686
     C*
     C     WUERST        IFEQ      'E'                                                         E2168
     C*
     C** IF THE ERROR STATUS IS 'E' THEN SET THE ERROR STATUS TO 'B' FOR
     C** BOTH
     C*
     C                   MOVE      'B'           WUERST                                        E2168
     C                   ELSE                                                                  E2168
     C                   MOVE      'I'           WUERST                                        E2168
     C                   END                                                                   E2168
     C                   END                                                                   E2168
     C/EJECT                                                              E21685
     C*****************************************************************   E21685
      * CASE: WRK.Error Status is Exchange Rate
     C     WUERST        IFEQ      'E'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CYCD        ZA0075                         Currency Code
      * Send message 'Exchange rate for curr'
     C                   MOVEL     'USR1523'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y2U0004'     W0RTN                          *Return code
     C                   GOTO      TBEXIT                                       *QUIT
     C                   END                                                    *FI
      * CASE: WRK.Error Status is Interest Rate
     C     WUERST        IFEQ      'I'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CYCD        ZA0076                         Currency Code
      * Send message 'Interest Rate for curr'
     C                   MOVEL     'USR1524'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y2U0004'     W0RTN                          *Return code
     C                   GOTO      TBEXIT                                       *QUIT
     C                   END                                                    *FI
      * CASE: WRK.Error Status is Both
     C     WUERST        IFEQ      'B'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CYCD        ZA0077                         Currency Code
      * Send message 'Exchange rate for curr'
     C                   MOVEL     'USR1523'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
      * Setup message data for message
     C                   MOVEL     #1CYCD        ZA0078                         Currency Code
      * Send message 'Interest Rate for curr'
     C                   MOVEL     'USR1524'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y2U0004'     W0RTN                          *Return code
     C                   GOTO      TBEXIT                                       *QUIT
     C                   END                                                    *FI
     C/COPY WNCPYSRC,SD0021RC25
      * End of Fix E21685
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
     C/COPY WNCPYSRC,SD0021RC17
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
      * Start of SAR S01117
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,WN0481CCP1                                           S01408
     C***********          CALL 'WIND01'                                  S01212
     C                   CALL      'WN0010'                                                    S0121
     C*********************PARM           ##PGM            Program        S01212
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C*********************PARM *BLANK    FKEY    2        Function Key   S01212
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C*********************PARM           WUMEST           Action  S01212 S01229
     C*********************PARM           WUWMAC           Action  S01212 S01229
     C                   PARM      'D'           UACTCD            1            Action  S01212 S0122
     C                   PARM                    DATA                           Trans Data     S0121
     C                   PARM      *BLANK        W0RTN                          Return Code    S0121
     C                   PARM                    SPARE           256            Spare Field    LN035
     C/COPY WNCPYSRC,EML110_007                                                               EML110
      * End of SAR S01117
      * WM Check Return
      * CASE: PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      'USR0563'                                    *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      TBEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      TBEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      TBEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RDBW - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RDBW
     C*
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RDBU - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RDBU
     C*
     C                   END                                                    *FI
      * Move key fields to @A6REA4
     C                   MOVEL     #1CYCD        A6CYCD                         Currency Code
      *
     C     KLDLTB        KLIST
     C                   KFLD                    A6CYCD                         Currency Code
      *                                                                                       CSD031
      ** If Acceptance mode, access acceptance file SDACURL0                                  CSD031
      *                                                                                       CSD031
     C     CSD043        IFEQ      'Y'
     C     PACCPT        ANDEQ     'A'
     C     KLDLTB        CHAIN     SDCURRD0                           9091      *
     C                   ELSE
     C     KLDLTB        CHAIN     @A6REA4                            9091      *
     C                   ENDIF
     C     *IN90         IFEQ      '1'
      * Record already deleted
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      TBEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
      * Send message '*Database operation error'
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      TBEXIT
     C                   END
      *
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C     KLDLTB        SETLL     @A6REA4                            9091      *
     C                   GOTO      TBEXIT
     C                   END                                                    FI #1DBRC
      *................................................................
      * If CSD012 is ON and Currencies is ON, output details to Shadow file                   CSD012
      * and Authorisation Log.                                                                CSD012
     C                   MOVEL     *BLANKS       #1CRDL
     C     CSD012        IFEQ      'Y'
     C     SVAL11        ANDEQ     'Y'
     C                   MOVEL     'D'           A6TYLC                         Type of Last Ch
     C                   WRITE     SDCUSHD0                             91
      *                                                                                       CSD012
     C                   MOVEL     #1CYCD        K1CYCD
     C     KAULG         CHAIN     SDAULGL1                           90
      *                                                                                       CSD012
      * If record does not exist write details to Authoristion Log                            CSD012
     C     *IN90         IFEQ      *ON
     C                   MOVEL     #1CYCD        ALKEY
     C                   MOVEL     FUNCD         ALFUNC
     C                   MOVE      P2ANCD        ALACTN
     C                   MOVE      ##USR         ALUSER
     C                   WRITE     SDAULG1
     C                   ENDIF
     C                   MOVEL     'Y'           #1CRDL
     C                   MOVEL     '-'           PHDASH
     C                   MOVEL     #1CYCD        PHCYCD
     C                   MOVEL     #1SWCY        PHSWCY
     C                   EXSR      SRDEL
     C                   GOTO      TBEXIT
      *                                                                                       CSD012
     C                   ELSE
      *                                                                                       CSD012
     C     CSD043        IFEQ      'Y'
     C     PACCPT        IFEQ      'A'
     C                   DELETE    SDACURL0                             91
     C     P2ANCD        IFEQ      'D'
     C     PXANCD        ANDEQ     'X'
     C     KLCHSD        CHAIN     @A6REA4                            90
     C     *IN90         IFEQ      '0'
     C                   DELETE    @A6REA4                              91
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
      ** If normal mode  and action code is A                                                 CSD031
      *                                                                                       CSD031
     C     PACCPT        IFEQ      'C'
     C     P2ANCD        ANDEQ     'A'
      *                                                                                       CSD031
     C     CUROPN        IFNE      'Y'
     C                   OPEN      SDACURL0
     C                   MOVE      'Y'           CUROPN
     C                   ENDIF
      *                                                                                       CSD031
      ** Check if record  exists in acceptance file.                                          CSD031
      *                                                                                       CSD031
     C     #1CYCD        CHAIN     SDACURL0                           9091
     C     *IN90         IFEQ      '0'
      *                                                                                       CSD031
      ** If it exists in acceptance file, do not allow any change.                            CSD031
      *                                                                                       CSD031
     C                   MOVE      'CSD0002'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      TBEXIT
     C                   ENDIF
     C                   ENDIF
     C                   DELETE    @A6REA4                              91
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
     C                   DELETE    @A6REA4                              91      *
     C                   ENDIF
     C                   MOVEL     'Y'           #1CRDL
     C                   ENDIF
      *                                                                                       CSD012
     C     *IN91         IFEQ      '1'
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF delete successful
      * USER: Processing after Data update
      * Start of change 122096
      * WUDELR Data Structure - SD Deleted Records File  *
     C                   MOVEL     @1DBRC        WUDELR
      * Write Deleted Record - SD Deleted Records File  *
     C                   CLEAR                   PFRC
     C                   MOVEL     'SDCURRPD'    PFFNME                         File name
     C                   MOVEL     #1CYCD        PFLKEY                         Long Key
     C                   MOVEL     WUDR01        PFDR01                         Deleted Data Re
     C                   MOVEL     WUDR02        PFDR02                         Deleted Data Re
     C                   MOVEL     WUDR03        PFDR03                         Deleted Data Re
     C                   MOVEL     WUDR04        PFDR04                         Deleted Data Re
     C                   MOVEL     WUDR05        PFDR05                         Deleted Data Re
     C                   MOVEL     WUDR06        PFDR06                         Deleted Data Re
     C                   MOVEL     WUDR07        PFDR07                         Deleted Data Re
     C                   MOVEL     WUDR08        PFDR08                         Deleted Data Re
     C                   MOVEL     WUDR09        PFDR09                         Deleted Data Re
     C                   MOVEL     WUDR00        PFDR00                         Deleted Data Re
     C                   MOVEL     WUDR11        PFDR11                         Deleted Data Re
     C                   MOVEL     WUDR12        PFDR12                         Deleted Data Re
     C                   Z-ADD     WURDNB        PFLCD                          Last Change Dat
     C                   MOVEL     'D'           PFTYLC                         Type of Last Ch
      *
     C                   CALL      'SD0520X'                            90      Write Deleted R
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PFRC                           RCD: SD Deleted
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0520X'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
     C                   EXSR      SRDEL
      * End of change 122096
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RDAU - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RDAU
     C*
     C                   END                                                    *FI
      * Delete record on PF/RECCYD if Retail Module is on                 179232
     C     WURTBN        IFEQ      'Y'                                          *IF            17923
     C                   EXSR      RXICD                                                       17923
     C                   ENDIF                                                  *FI            17923
     C                   END
      *================================================================
     CSR   TBEXIT        ENDSR
      /EJECT
     CSR   TCRVGN        BEGSR
      *================================================================
      * RTV for Chg, Add or Del - Currency Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSTC         KLIST
     C                   KFLD                    A6CYCD                         Currency Code
      * Move fields to key list
     C                   MOVEL     #1CYCD        A6CYCD                         Currency Code
      *                                                                                       CSD031
      ** If Acceptance mode, access acceptance file SDACURL0                                  CSD031
      *                                                                                       CSD031
     C     CSD043        IFEQ      'Y'
     C     PACCPT        IFEQ      'A'
     C********** KRSTC     CHAINSDCURRD0             90                              CSD031 BUG11875
     C**********           ELSE                                                      CSD031 BUG11875
     C     KRSTC         CHAIN     SDCURRD0                           92
     C                   ENDIF
     C     KRSTC         CHAIN     @A6REA3                            90
     C**********           ENDIF                                                     CSD031 BUG11875
     C                   ELSE
     C     KRSTC         CHAIN     @A6REA3                            90        *
     C                   ENDIF
      * Data record not found
     C   90              MOVEL     'USR0071'     W0RTN             7
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   Z-ADD     *ZERO         WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
      * CASE: PAR.Type of Last Change is Amend
      * changed 'D' to Action code field                                                    BUG11875
     C********** 'D'       IFEQ 'A'                        *IF                              BUG11875
     C     P2ANCD        IFEQ      'A'
     C                   Z-ADD     1             WUNOAM                         No. of Amends
     C                   END                                                    *FI
      * CASE: PAR.Type of Last Change is Delete
      * changed 'D' to Action code field                                                    BUG11875
     C********** 'D'       IFEQ 'D'                        *IF                              BUG11875
     C     P2ANCD        IFEQ      'D'
     C                   Z-ADD     1             WUNODL                         No. of Deletes
     C                   Z-ADD     -1            WUNORC                         No. of Records
     C                   END                                                    *FI
      * CASE: PAR.Type of Last Change is Insert
      * changed 'D' to Action code field                                                    BUG11875
     C********** 'D'       IFEQ 'I'                                                         BUG11875
     C     P2ANCD        IFEQ      'I'                                          *IF
     C                   Z-ADD     1             WUNOIN                         No. of Inserts
     C                   Z-ADD     1             WUNORC                         No. of Records
     C                   END                                                    *FI
      * Start of SAR S01117
      * Change code to filename CCY - SDCURRPD
      * Change Standing Data Cont - Standing Data Controls  *
     C**********           EXSR TDCHRC                                                      MD025467
     C                   EXSR      UPDSDT
      * End of SAR S01117
      * Background Update CCY - Currency Codes  *
     C                   CALL      'SD0021U'                            90      Background Upda
     C     W0RTN         PARM      *BLANK        WQ0257            7            *Return code
     C                   PARM      A6CYCD        WQ0258            3            Currency Code
     C**********           PARM A6SPAE    WQ0259  4        Spot Trade Acco                    CGL029
     C**********           PARM A6FTAE    WQ0260  4        Fwd Trade Accou                    CGL029
     C**********           PARM A6SWAE    WQ0261  4        Swap Trade Acco                    CGL029
     C**********           PARM A6TAC4    WQ0262  4        Trade Account C                    CGL029
     C**********           PARM A6TAC5    WQ0263  4        Trade Account C                    CGL029
     C                   PARM      A6SPAE        WQ0259           10
     C                   PARM      A6FTAE        WQ0260           10
     C                   PARM      A6SWAE        WQ0261           10
     C                   PARM      A6TAC4        WQ0262           10
     C                   PARM      A6TAC5        WQ0263           10
     C                   PARM      A6CDFN        WQ0264            2            Cedel Default N
     C                   PARM      A6ECDN        WQ0265            2            Euroclear Defau
     C                   PARM      A6LCD         WQ0266            5 0          Last Change Dat
     C                   PARM      'D'           WQ0267            1            Type of Last Ch
     C                   PARM      A6CYNM        WQ0268           14            Currency Name
     C                   PARM      A6SPRT        WQ0269           13 8          Spot Rate
     C                   PARM      A6SWCY        WQ0270            3            Swift Currency
     C                   PARM      A6NBDP        WQ0271            1 0          Number of Decim
     C                   PARM      A6TXND        WQ0272            1 0          Telex Notice Da
     C                   PARM      A6PRRT        WQ0273           13 8          Par Rate
     C                   PARM      A6SRC1        WQ0274            4 0          Statutory Retur
     C                   PARM      A6SRC2        WQ0275            4 0          Statutory Retur
     C                   PARM      A6DLCI        WQ0276            1            Dealing Currenc
     C                   PARM      A6SSNB        WQ0277            2 0          Sort Sequence N
     C                   PARM      A6ERLC        WQ0278           13 8          Exchange Rate -
     C                   PARM      A6MDIN        WQ0279            1            Multiply/Divide
     C                   PARM      A6MDPR        WQ0280            1            Multiply/Divide
     C                   PARM      A6MDHB        WQ0281            1            Multiply/Divide
     C                   PARM      A6MDEX        WQ0282            1            Multiply/Divide
     C                   PARM      A6NOSN        WQ0283           10            Nostro Shortnam
     C                   PARM      A6SPDY        WQ0284            3 0          Spot Days
     C                   PARM      A6FXSD        WQ0285            8 0          DRS FX Spot Dat
     C                   PARM      A6MMSD        WQ0286            8 0          DRS MM Spot Dat
     C                   PARM      A6NQDP        WQ0287            1 0          Normally Quoted
     C                   PARM      A6DICB        WQ0288            1            Default Int. Ca
     C                   PARM      A6SCEX        WQ0289            1 0          Scaling Exponen
     C                   PARM      A6EBDA        WQ0290           29            Eurobond Data
     C                   PARM      A6HBRT        WQ0291           13 8          Historic Broker
     C                   PARM      A6ENC1        WQ0292            2 0          Euroclear Numer
     C                   PARM      A6ENC2        WQ0293            2 0          Euroclear Numer
     C                   PARM      A6CACD        WQ0294            3            Cedel Alpha Cod
     C                   PARM      A6CNMC        WQ0295            2 0          Cedel Numeric C
     C                   PARM      A6FRIH        WQ0296            1            FRI. Holiday
     C                   PARM      A6SATH        WQ0297            1            SAT. Holiday
     C                   PARM      A6SUNH        WQ0298            1            SUN. Holiday
     C                   PARM      A6DPBF        WQ0299            1 0          Dec.Places in B
     C                   PARM      A6BYSR        WQ0300           13 8          Buy Spread Rate
     C                   PARM      A6BYSS        WQ0301            1            Buy Spread Sign
     C                   PARM      A6SLSR        WQ0302           13 8          Sell Spread Rat
     C                   PARM      A6SLSS        WQ0303            1            Sell Spread Sig
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0021U'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
     C                   END
      *================================================================
     CSR   TCEXIT        ENDSR
      /EJECT
     C***SR*****    TDCHRC    BEGSR                                                         MD025467
      *================================================================
      **Change*Standing*Data*Cont*-*Standing*Data*Controls*************                     MD025467
      *================================================================
     C**********           MOVEL*BLANK    W0RTN   7                                         MD025467
      **Set*PGM.*Record*Data*Changed*flag******************************                     MD025467
     C**********           MOVE 'N'       YHRDC   1                                         MD025467
      *****************************************************************                     MD025467
      **Move*key*fields*to*@AHREAU*************************************                     MD025467
     C**********           MOVE *BLANK    AHFLNM           Filename                         MD025467
     C**********           MOVEL'SDCURRPD'AHFLNM           Filename                         MD025467
      *****************************************************************                     MD025467
     C********** KLCHTD    KLIST                                                            MD025467
     C**********           KFLD           AHFLNM           Filename                         MD025467
     C********** KLCHTD    CHAIN@AHREAU              9091  *                                MD025467
      *****************************************************************                     MD025467
     C********** *IN90     IFEQ '1'                                                         MD025467
      **Record*not*found***********************************************                     MD025467
     C**********           MOVEL'Y2U0009' W0RTN   7                                         MD025467
      **Send*message*'*Record*no*longer*on*file'***********************                     MD025467
     C**********           MOVEL'Y2U0009' ZAMSID                                            MD025467
     C**********           MOVEL'Y2USRMSG'ZAMSGF                                            MD025467
     C**********           EXSR ZASNMS                                                      MD025467
     C**********           GOTO TDEXIT                                                      MD025467
     C**********           END                                                              MD025467
      *****************************************************************                     MD025467
     C********** *IN91     IFEQ '1'                                                         MD025467
      **Record*locked**************************************************                     MD025467
     C**********           MOVEL'Y2U0004' W0RTN   7                                         MD025467
     C**********           GOTO TDEXIT                                                      MD025467
     C**********           END                                                              MD025467
      *****************************************************************                     MD025467
      **Store*record*data*for*null*update*check************************                     MD025467
     C**********           MOVE QSDFC1    YHRDCS                                            MD025467
      **USER:*Processing*after*Data*read*******************************                     MD025467
     C**********           ADD  AHNORC    WUNORC           No. of Records                   MD025467
     C**********           ADD  AHNOIN    WUNOIN           No. of Inserts                   MD025467
     C**********           ADD  AHNOAM    WUNOAM           No. of Amends                    MD025467
     C**********           ADD  AHNODL    WUNODL           No. of Deletes                   MD025467
      **Move*non-key*fields*to*@AHREAU*********************************                     MD025467
     C**********           Z-ADDWUNORC    AHNORC           No. of Records                   MD025467
     C**********           Z-ADDWUNOIN    AHNOIN           No. of Inserts                   MD025467
     C**********           Z-ADDWUNOAM    AHNOAM           No. of Amends                    MD025467
     C**********           Z-ADDWUNODL    AHNODL           No. of Deletes                   MD025467
      *****************************************************************                     MD025467
      **Set*PGM.*Record*Data*Changed*flag******************************                     MD025467
     C********** QSDFC1    IFNE YHRDCS                                                      MD025467
     C**********           MOVE 'Y'       YHRDC                                             MD025467
     C**********           END                                                              MD025467
      **If*changed*update*record*otherwise*release*record**************                     MD025467
     C********** YHRDC     IFEQ 'Y'                                                         MD025467
     C**********           UPDAT@AHREAU                91  *                                MD025467
     C**********           ELSE                                                             MD025467
      **Release*record*lock********************************************                     MD025467
     C**********           UNLCKSDFCTLL0               91  *                                MD025467
     C**********           END                                                              MD025467
     C********** *IN91     IFEQ '1'                                                         MD025467
      **Change*error*detected******************************************                     MD025467
     C**********           MOVEL'Y2U0004' W0RTN   7                                         MD025467
     C**********           ELSE                                                             MD025467
      *****************************************************************                     MD025467
      **DBF*change*successful******************************************                     MD025467
     C**********           END                                                              MD025467
      *================================================================
     C***SR*****    TDEXIT    ENDSR                                                         MD025467
      /EJECT
     CSR   TECHRC        BEGSR
      *================================================================
      * Change Currency Codes -LR - Currency Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YIRDC             1
      *
      * Move key fields to @A6REA4
     C                   MOVEL     #1CYCD        A6CYCD                         Currency Code
      *
     C     KLCHTE        KLIST
     C                   KFLD                    A6CYCD                         Currency Code
     C     KLCHTE        CHAIN     @A6REA4                            9091      *
      *
     C     *IN90         IFEQ      '1'
     C     CSD043        IFEQ      'N'
     C     P2ANCD        ORNE      'X'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      TEEXIT
     C                   ENDIF
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      TEEXIT
     C                   END
      *
      * Check for changed record
     C     CSD043        IFEQ      'Y'
     C     PACCPT        IFEQ      'A'
     C     #1DBRC        IFNE      @ADBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      *                                                                                       CSD031
      * Send message '*Update not accepted'                                                   CSD031
      *                                                                                       CSD031
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      *                                                                                       CSD031
      * Release record lock                                                                   CSD031
      *                                                                                       CSD031
     C                   UNLOCK    SDCURRL0                             91      *
     C                   GOTO      TEEXIT
     C                   ENDIF                                                  FI #1DBRC
     C                   ELSE
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'                                                   CSD031
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock                                                                   CSD031
     C                   UNLOCK    SDCURRL0                             91      *
     C                   GOTO      TEEXIT
     C                   ENDIF                                                  FI #1DBRC
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C                   UNLOCK    SDCURRL0                             91      *
     C                   GOTO      TEEXIT
     C                   END                                                    FI #1DBRC
     C                   ENDIF
      * Store record data for null update check
     C     CSD043        IFEQ      'Y'
     C     PACCPT        IFEQ      'A'
     C                   MOVE      @ADBRC        YIRDCS
     C                   ELSE
     C                   MOVE      @1DBRC        YIRDCS
     C                   ENDIF
     C                   ELSE
     C                   MOVE      @1DBRC        YIRDCS
     C                   ENDIF
      * Move non-key fields to @A6REA4
     C                   MOVEL     #1SPAE        A6SPAE                         Spot Trade Acco
     C                   MOVEL     #1FTAE        A6FTAE                         Fwd Trade Accou
     C                   MOVEL     #1SWAE        A6SWAE                         Swap Trade Acco
     C                   MOVEL     #1TAC4        A6TAC4                         Trade Account C
     C                   MOVEL     #1TAC5        A6TAC5                         Trade Account C
     C                   MOVEL     #1CDFN        A6CDFN                         Cedel Default N
     C                   MOVEL     #1ECDN        A6ECDN                         Euroclear Defau
     C                   Z-ADD     WURDNB        A6LCD                          Last Change Dat
     C                   MOVEL     'A'           A6TYLC                         Type of Last Ch
     C                   MOVEL     #1CYNM        A6CYNM                         Currency Name
     C                   Z-ADD     #1SPRT        A6SPRT                         Spot Rate
     C                   MOVEL     #1SWCY        A6SWCY                         Swift Currency
     C                   Z-ADD     #1NBDP        A6NBDP                         Number of Decim
     C                   Z-ADD     #1TXND        A6TXND                         Telex Notice Da
     C                   Z-ADD     #1PRRT        A6PRRT                         Par Rate
     C                   Z-ADD     #1SRC1        A6SRC1                         Statutory Retur
     C                   Z-ADD     #1SRC2        A6SRC2                         Statutory Retur
     C                   MOVEL     #1DLCI        A6DLCI                         Dealing Currenc
     C                   Z-ADD     #1SSNB        A6SSNB                         Sort Sequence N
     C                   Z-ADD     #1ERLC        A6ERLC                         Exchange Rate -
     C                   MOVEL     #1MDIN        A6MDIN                         Multiply/Divide
     C                   MOVEL     #1MDPR        A6MDPR                         Multiply/Divide
     C                   MOVEL     #1MDHB        A6MDHB                         Multiply/Divide
     C                   MOVEL     #1MDEX        A6MDEX                         Multiply/Divide
     C                   MOVEL     #1NOSN        A6NOSN                         Nostro Shortnam
     C                   Z-ADD     #1SPDY        A6SPDY                         Spot Days
     C                   Z-ADD     #1HSRT        A6HSRT                         High Spot Rate
     C                   Z-ADD     #1LSPR        A6LSPR                         Low Spot Rate
     C                   Z-ADD     #1FXSD        A6FXSD                         DRS FX Spot Dat
     C                   Z-ADD     #1MMSD        A6MMSD                         DRS MM Spot Dat
     C                   Z-ADD     #1NQDP        A6NQDP                         Normally Quoted
     C                   MOVEL     #1DICB        A6DICB                         Default Int. Ca
     C                   Z-ADD     #1SCEX        A6SCEX                         Scaling Exponen
     C                   MOVEL     #1EBDA        A6EBDA                         Eurobond Data
     C                   Z-ADD     #1HBRT        A6HBRT                         Historic Broker
     C                   Z-ADD     #1ENC1        A6ENC1                         Euroclear Numer
     C                   Z-ADD     #1ENC2        A6ENC2                         Euroclear Numer
     C                   MOVEL     #1CACD        A6CACD                         Cedel Alpha Cod
     C                   Z-ADD     #1CNMC        A6CNMC                         Cedel Numeric C
     C                   MOVEL     #1WEDH        A6WEDH                         WED. Holiday
     C                   MOVEL     #1MONH        A6MONH                         MON. Holiday
     C                   MOVEL     #1TUEH        A6TUEH                         TUES. Holiday
     C                   MOVEL     #1THUH        A6THUH                         THURS. Holiday
     C                   MOVEL     #1FRIH        A6FRIH                         FRI. Holiday
     C                   MOVEL     #1SATH        A6SATH                         SAT. Holiday
     C                   MOVEL     #1SUNH        A6SUNH                         SUN. Holiday
     C                   Z-ADD     #1DPBF        A6DPBF                         Dec.Places in B
     C                   Z-ADD     #1BYSR        A6BYSR                         Buy Spread Rate
     C                   MOVEL     #1BYSS        A6BYSS                         Buy Spread Sign
     C                   Z-ADD     #1SLSR        A6SLSR                         Sell Spread Rat
     C                   MOVEL     #1SLSS        A6SLSS                         Sell Spread Sig
     C                   Z-ADD     #1RMCM        A6RMCM                         RM Cashflow Mag
     C                   MOVEL     'D'           A6RECI                         Record Id
     C                   MOVEL     #1DPRU        A6DPRU                         Default Priorit
     C                   MOVEL     #1DNOR        A6DNOR                         Delivery Notifi
     C                   MOVEL     #1NDWR        A6NDWR                         Non-Delivery Wa
     C                   MOVEL     #1GMPY        A6GMPY                         Generate Multip
     C                   MOVEL     #1DLCD        A6DLCD                         Delivery Code
     C                   MOVEL     #1RDFC        A6RDFC                         Round Down Inte
     C                   MOVEL     #1PMRT        A6PMRT                         Precious Metal
     C                   Z-ADD     #1RKSQ        A6RKSQ                         Currency Rankin
     C                   MOVEL     #1DFPC        A6DFPC                         Dft Fx Poss Pro
     C                   MOVEL     #1DDPC        A6DDPC                         Dft Dir Fund Pr
     C                   Z-ADD     #1TKCC        A6TKCC                         Telekurs Curren
     C                   Z-ADD     #1CQCD        A6CQCD                         Cheque Clearing
     C                   Z-ADD     #1SMLD        A6SMLD                         Smallest Denomi
     C                   MOVEL     #1CSCD        A6CSCD                         Cash Account Co
     C                   Z-ADD     #1ISON        A6ISON                         Numeric ISO Cur
     C                   MOVEL     #1ISFC        A6ISFC                         ISDA Financial
     C                   MOVEL     #1MACD        A6MACD                         Major Currency
     C                   MOVEL     #1FRAC        A6FRAC                         Fractions Flag
     C                   MOVEL     #1NUWD        A6NUWD                         Numbers and Wor
     C                   MOVEL     #1MICD        A6MICD                         Minor Currency
     C                   MOVEL     #1DLOC        A6DLOC                         Dflt.Loc.Code  CSW09
     C                   MOVEL     #1CLSC        A6CLSC                         CLS Currency   CDL00
     C                   Z-ADD     #1EFDT        A6EFDT                         Effective Date CDL00
     C                   MOVEL     #1SETD        A6SETD
     C                   MOVEL     #1IRDP        A6IRDP
     C     CSD043        IFEQ      'Y'
     C     P2ANCD        ANDEQ     'X'
     C     #1CYCD        CHAIN     SDACURL0                           9091
     C     *IN90         IFEQ      '0'
     C                   MOVE      A6AACC        AAAACC            1
     C                   Z-ADD     A6EACC        AAEACC            5 0
     C                   MOVE      A6GPDT        AAGPDT            1
     C                   ENDIF
     C                   MOVE      AAAACC        A6AACC
     C**********           Z-ADDAAEACC    A6EACC                                     CSD031 BUG11870
     C                   Z-ADD     BJRDNB        A6EACC
     C                   MOVE      AAGPDT        A6GPDT
     C                   ENDIF
      *                                                                                       CER043
     C     CER043        IFEQ      'Y'
     C                   MOVE      #1RETP        A6RETP
     C                   ENDIF
      *                                                                                       CGL014
     C     CGL014        IFEQ      'Y'
     C     CLE025        OREQ      'Y'
     C     WUN4ST        OREQ      'Y'
     C                   MOVEL     #1EXWC        A6EXWC
     C                   MOVEL     #1POWC        A6POWC
     C                   ENDIF
      *
      * Set PGM.*Record Data Changed flag
     C     CSD043        IFEQ      'Y'
     C     PACCPT        IFEQ      'A'
     C     @ADBRC        IFNE      YIRDCS
     C                   MOVE      'Y'           YIRDC
     C                   ENDIF
     C                   ELSE
     C     @1DBRC        IFNE      YIRDCS
     C                   MOVE      'Y'           YIRDC
     C                   END
     C                   ENDIF
     C                   ELSE
     C     @1DBRC        IFNE      YIRDCS
     C                   MOVE      'Y'           YIRDC
     C                   END
     C                   ENDIF
      * USER: Processing before Data update
      * Start of Fix E18248
      * CASE: PAR.FRI. Holiday is Blank
     C     #1FRIH        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           A6FRIH                         FRI. Holiday
     C                   END                                                    *FI
      * CASE: PAR.SAT. Holiday is Blank
     C     #1SATH        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           A6SATH                         SAT. Holiday
     C                   END                                                    *FI
      * CASE: PAR.SUN. Holiday is Blank
     C     #1SUNH        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           A6SUNH                         SUN. Holiday
     C                   END                                                    *FI
      * End of Fix 18248
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
     C/COPY WNCPYSRC,SD0021RC18
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
      * Start of SAR S01117
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,WN0481CCP1                                           S01408
     C***********          CALL 'WIND01'                                  S01212
     C                   CALL      'WN0010'                                                    S0121
     C*********************PARM           ##PGM            Program        S01212
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C*********************PARM *BLANK    FKEY    2        Function Key   S01212
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C*********************PARM           WUMEST           Action  S01212 S01229
     C*********************PARM           WUWMAC           Action  S01212 S01229
     C                   PARM      'A'           UACTCD            1            Action  S01212 S0122
     C                   PARM                    DATA                           Trans Data     S0121
     C                   PARM      *BLANK        W0RTN                          Return Code    S0121
     C                   PARM                    SPARE           256            Spare Field    LN035
      * End of SAR S01117
      * 00/Copy member SD0021RC01 - Currency Codes  *
     C/COPY WNCPYSRC,SD0021RC01
      * WM Check Return
      * CASE: PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      'USR0563'                                    *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      TEEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      TEEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      TEEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RBUW - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RBUW
     C*
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RBDU - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RBDU
     C*
     C                   END                                                    *FI
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YIRDCS
     C                   MOVE      'Y'           YIRDC
     C                   END
      * If changed update record otherwise release record
     C     YIRDC         IFEQ      'Y'
     C     CSD043        IFEQ      'Y'
     C     P2ANCD        IFEQ      'X'
      *                                                                                       CSD031
      ** If currency record not found in SDCURRPD                                             CSD031
      *                                                                                       CSD031
     C     NEW           IFEQ      'Y'
     C     A6TYLC        IFNE      'D'
      *                                                                                       CSD031
      ** If record to accept does not exist in zonal file and Type of Last Change             CSD031
      ** value is A, change the value of Type of Last Change to I.                            CSD031
      *                                                                                       CSD031
     C     A6TYLC        IFEQ      'A'
     C                   MOVE      'I'           A6TYLC
     C                   ENDIF
     C                   MOVE      WURDNB        A6LCD
     C                   WRITE     @A6REA4                              91
      *                                                                                       CSD031
      ** Update Standing Data Controls                                                        CSD031
      *                                                                                       CSD031
     C                   Z-ADD     1             WUNORC                         No. of Records
     C                   Z-ADD     1             WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C**********           EXSR STCHRC                                               CSD031 MD025467
     C                   EXSR      UPDSDT
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
      ** If currency record found in SDCURRPD                                                 CSD031
      *                                                                                       CSD031
     C     A6TYLC        IFNE      'D'
     C     A6TYLC        IFEQ      'I'
     C                   MOVE      'A'           A6TYLC
     C                   ENDIF
     C                   MOVE      WURDNB        A6LCD
     C                   UPDATE    @A6REA4                              91      *
     C     *IN90         IFEQ      '0'
     C                   DELETE    SDCURRD0
     C                   ENDIF
      *                                                                                       CSD031
      ** Update Standing Data Controls                                                        CSD031
      *                                                                                       CSD031
     C                   Z-ADD     *ZERO         WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     1             WUNOAM                         No. of Amends
     C**********           EXSR SWCHRC                                               CSD031 MD025467
     C                   EXSR      UPDSDT
     C                   ELSE
      *                                                                                       CSD031
      ** Delete from acceptance file                                                          CSD031
      *                                                                                       CSD031
     C     *IN90         IFEQ      '0'
     C                   DELETE    SDCURRD0                             91
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
     C                   CALL      'SD0021U'                            90
     C     W0RTN         PARM      *BLANK        WQ0105            7
     C                   PARM      A6CYCD        WQ0106            3
     C                   PARM      A6SPAE        WQ0107           10
     C                   PARM      A6FTAE        WQ0108           10
     C                   PARM      A6SWAE        WQ0109           10
     C                   PARM      A6TAC4        WQ0110           10
     C                   PARM      A6TAC5        WQ0111           10
     C                   PARM      A6CDFN        WQ0112            2
     C                   PARM      A6ECDN        WQ0113            2
     C                   PARM      A6LCD         WQ0114            5 0
     C                   PARM      A6TYLC        WQ0115            1
     C                   PARM      A6CYNM        WQ0116           14
     C                   PARM      A6SPRT        WQ0117           13 8
     C                   PARM      A6SWCY        WQ0118            3
     C                   PARM      A6NBDP        WQ0119            1 0
     C                   PARM      A6TXND        WQ0120            1 0
     C                   PARM      A6PRRT        WQ0121           13 8
     C                   PARM      A6SRC1        WQ0122            4 0
     C                   PARM      A6SRC2        WQ0123            4 0
     C                   PARM      A6DLCI        WQ0124            1
     C                   PARM      A6SSNB        WQ0125            2 0
     C                   PARM      A6ERLC        WQ0126           13 8
     C                   PARM      A6MDIN        WQ0127            1
     C                   PARM      A6MDPR        WQ0128            1
     C                   PARM      A6MDHB        WQ0129            1
     C                   PARM      A6MDEX        WQ0130            1
     C                   PARM      A6NOSN        WQ0131           10
     C                   PARM      A6SPDY        WQ0132            3 0
     C                   PARM      A6FXSD        WQ0133            8 0
     C                   PARM      A6MMSD        WQ0134            8 0
     C                   PARM      A6NQDP        WQ0135            1 0
     C                   PARM      A6DICB        WQ0136            1
     C                   PARM      A6SCEX        WQ0137            1 0
     C                   PARM      A6EBDA        WQ0138           29
     C                   PARM      A6HBRT        WQ0139           13 8
     C                   PARM      A6ENC1        WQ0140            2 0
     C                   PARM      A6ENC2        WQ0141            2 0
     C                   PARM      A6CACD        WQ0142            3
     C                   PARM      A6CNMC        WQ0143            2 0
     C                   PARM      A6FRIH        WQ0144            1
     C                   PARM      A6SATH        WQ0145            1
     C                   PARM      A6SUNH        WQ0146            1
     C                   PARM      A6DPBF        WQ0147            1 0
     C                   PARM      A6BYSR        WQ0148           13 8
     C                   PARM      A6BYSS        WQ0149            1
     C                   PARM      A6SLSR        WQ0150           13 8
     C                   PARM      A6SLSS        WQ0151            1
      *                                                                                       CSD031
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0021U'     W0CLPG
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   ELSE
     C                   UPDATE    @A6REA4                              91      *
     C                   ENDIF
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDCURRL0                             91      *
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * Update saved record image
     C     CSD043        IFEQ      'Y'
     C     PACCPT        IFEQ      'A'
     C                   MOVEL     @ADBRC        #1DBRC
     C                   ELSE
     C                   MOVEL     @1DBRC        #1DBRC
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     @1DBRC        #1DBRC
     C                   ENDIF
      * DBF change successful
      * USER: Processing after Data update
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021RADU - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RADU
     C*
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   TEEXIT        ENDSR
      /EJECT
     CSR   TFRVGN        BEGSR
      *================================================================
      * Get all Midas Modules - MIDAS Modules  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSTF         KLIST
     C                   KFLD                    BGMODS                         Modules
      * Move fields to key list
     C                   MOVE      *BLANK        BGMODS                         Modules
     C                   MOVEL     'MMOD'        BGMODS                         Modules
     C     KRSTF         CHAIN     @BGREC8                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0096'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
      * Setup message data for message
     C                   MOVEL     'SDMMODPD'    ZA0079                         Filename
      * Send message 'Database Error (ICD)'
     C                   MOVEL     'USR0377'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   GOTO      TFEXIT                                       *QUIT
     C                   GOTO      TFEXIT
     C                   END
      *
      * USER: Exit processing
      * PAR = DB1 By name
     C                   MOVEL     BGMTMI        WUMTMI                         Midas/Telex Mod
     C                   MOVEL     BGSWFT        WUSWFT                         SWIFT Funds Tra
     C                   MOVEL     BGSWST        WUSWST                         SWIFT Securitie
     C                   MOVEL     BGSWCL        WUSWCL                         SWIFT Customer
     C                   MOVEL     BGSWSL        WUSWSL                         SWIFT Synd Loan
     C                   MOVEL     BGSWSM        WUSWSM                         SWIFT Statement
     C                   MOVEL     BGSWDL        WUSWDL                         SWIFT Dealing
     C                   MOVEL     BGSDGL        WUSDGL                         Standing data/G
     C                   MOVEL     BGDLFX        WUDLFX                         Dealing: FX
     C                   MOVEL     BGSYLN        WUSYLN                         Syndicated Loan
     C                   MOVEL     BGEXMG        WUEXMG                         Exposure Manage
     C                   MOVEL     BGFNMO        WUFNMO                         Financial Model
     C                   MOVEL     BGSTRT        WUSTRT                         Statutory Retur
     C                   MOVEL     BGCSLN        WUCSLN                         Customer Lendin
     C                   MOVEL     BGRTBN        WURTBN                         Retail Banking
     C                   MOVEL     BGMSDL        WUMSDL                         Midas/Swift dir
     C                   MOVEL     BGSECS        WUSECS                         Securities
     C                   MOVEL     BGAURC        WUAURC                         Auto-reconcilia
     C                   MOVEL     BGBDLI        WUBDLI                         Bond Dealers In
     C                   MOVEL     BGDRSD        WUDRSD                         DRS Standing Da
     C                   MOVEL     BGDRCM        WUDRCM                         DRS Control mod
     C                   MOVEL     BGDRFE        WUDRFE                         DRS Foreign Exc
     C                   MOVEL     BGDRMM        WUDRMM                         DRS Money Marke
     C                   MOVEL     BGDRAR        WUDRAR                         DRS Arbitrage
     C                   MOVEL     BGFDTR        WUFDTR                         Funds Transfer
     C                   MOVEL     BGDRCA        WUDRCA                         DRS Common Appl
     C                   MOVEL     BGFUOP        WUFUOP                         Futures & Optio
     C                   MOVEL     BGMTSL        WUMTSL                         Midas/Telex Syn
     C                   MOVEL     BGMTDL        WUMTDL                         Midas/Telex Dea
     C                   MOVEL     BGMTGL        WUMTGL                         Midas/Telex Gen
     C                   MOVEL     BGMTCL        WUMTCL                         Midas/Telex Cus
     C                   MOVEL     BGNWMI        WUNWMI                         Message Managem
     C                   MOVEL     BGFIIN        WUFIIN                         FRA/IRS Indicat
     C                   MOVEL     BGDLMM        WUDLMM                         Dealing: MM
     C                   MOVEL     BGINCN        WUINCN                         Internal Contra
     C                   MOVEL     BGTRMG        WUTRMG                         Treasury Manage
     C                   MOVEL     BGRKMG        WURKMG                         Interest Risk M
     C                   MOVEL     BGTSKY        WUTSKY                         Testkey
     C                   MOVEL     BGMIDQ        WUMIDQ                         Midas/Q
     C                   MOVEL     BGMFIC        WUMFIC                         Microfiche
     C                   MOVEL     BGIOAC        WUIOAC                         Interest on acc
     C                   MOVEL     BGWDPR        WUWDPR                         Window processi
     C                   MOVEL     BGSARP        WUSARP                         SAR's processin
     C                   MOVEL     BGFRIN        WUFRIN                         French return i
     C                   MOVEL     BGLRIN        WULRIN                         Lux return indi
     C                   MOVEL     BGDRIN        WUDRIN                         Dutch return in
     C                   MOVEL     BGGRIN        WUGRIN                         German return i
     C                   MOVEL     BGBRIN        WUBRIN                         Belgian return
     C                   MOVEL     BGIRIN        WUIRIN                         Italian return
     C                   MOVEL     BGSWEI        WUSWEI                         Swift External
     C                   MOVEL     BGPFMG        WUPFMG                         Portfolio Manag
     C                   MOVEL     BGCRMG        WUCRMG                         Credit Manageme
     C                   MOVEL     BGHORP        WUHORP                         Head Office Rep
     C                   MOVEL     BGAVBL        WUAVBL                         Average Balance
     C                   MOVEL     BGMARG        WUMARG                         Margins
     C                   MOVEL     BGCFMT        WUCFMT                         Confirmation Ma
     C                   MOVEL     BGMIMX        WUMIMX                         Mimix
     C                   MOVEL     BGRCFI        WURCFI                         Report Control
     C                   MOVEL     BGAMIN        WUAMIN                         Amps Int
     C                   MOVEL     BGSWRT        WUSWRT                         Swiss Returns
     C                   MOVEL     BGFLND        WUFLND                         Fiduciary Loans
     C                   MOVEL     BGLMCR        WULMCR                         Portfolio Lendi
     C                   MOVEL     BGCNTX        WUCNTX                         Cantonal Tax
     C                   MOVEL     BGSTDU        WUSTDU                         Stamp Duty
     C                   MOVEL     BGUDRS        WUUDRS                         Use DRS Shortna
     C                   MOVEL     BGCHDL        WUCHDL                         Chips Dealing
     C                   MOVEL     BGCHLN        WUCHLN                         Chips Lending
     C                   MOVEL     BGCHOB        WUCHOB                         Chips Opening B
     C                   MOVEL     BGCHIP        WUCHIP                         CHIPS
     C                   MOVEL     BGCHDI        WUCHDI                         Chips Direct Li
     C                   MOVEL     BGOPDK        WUOPDK                         Optical Disk
     C                   MOVEL     BGMBIN        WUMBIN                         Multi-branching
     C                   MOVEL     BGNNST        WUNNST                         Leo Data Nucleu
     C                   MOVEL     BGNOST        WUNOST                         Leo Letters of
     C                   MOVEL     BGNPST        WUNPST                         Leo Collections
     C                   MOVEL     BGNQST        WUNQST                         Leo Bills/Finan
     C                   MOVEL     BGNRST        WUNRST                         Leo Bankers Acc
     C                   MOVEL     BGNSST        WUNSST                         Leo Reimburseme
     C                   MOVEL     BGNTST        WUNTST                         Taxes
     C                   MOVEL     BGNUST        WUNUST                         History & Audit
     C                   MOVEL     BGNVST        WUNVST                         Management Acco
     C                   MOVEL     BGNWST        WUNWST                         IBLC Returns
     C                   MOVEL     BGNXST        WUNXST                         Retail 3
     C                   MOVEL     BGNYST        WUNYST                         Interest on Acc
     C                   MOVEL     BGNZST        WUNZST                         Midas Export Da
     C                   MOVEL     BGN0ST        WUN0ST                         Analytical Acco
     C                   MOVEL     BGN1ST        WUN1ST                         User Defined Co
     C                   MOVEL     BGN2ST        WUN2ST                         Midas-Plato Int
     C                   MOVEL     BGN3ST        WUN3ST                         Midas-Trade Inn
     C                   MOVEL     BGN4ST        WUN4ST                         PB Module      CPB00
     C                   MOVEL     BGN5ST        WUN5ST                         Reserved for La
     C                   MOVEL     BGN6ST        WUN6ST                         Reserved for La
     C                   MOVEL     BGN7ST        WUN7ST                         Reserved for La
     C                   MOVEL     BGN8ST        WUN8ST                         Reserved for La
     C                   MOVEL     BGN9ST        WUN9ST                         Reserved for La
     C                   MOVEL     BGOAST        WUOAST                         Reserved for La
     C                   MOVEL     BGOBST        WUOBST                         Reserved for La
     C                   MOVEL     BGOCST        WUOCST                         Reserved for La
     C                   MOVEL     BGODST        WUODST                         Reserved for La
     C                   MOVEL     BGOEST        WUOEST                         Reserved for La
     C                   MOVEL     BGOFST        WUOFST                         Reserved for La
     C                   MOVEL     BGOGST        WUOGST                         Reserved for La
     C                   MOVEL     BGOHST        WUOHST                         Reserved for La
     C                   MOVEL     BGOIST        WUOIST                         Reserved for La
     C                   MOVEL     BGOJST        WUOJST                         Reserved for La
     C                   MOVEL     BGOKST        WUOKST                         Reserved for La
     C                   MOVEL     BGOLST        WUOLST                         Reserved for La
     C                   MOVEL     BGOMST        WUOMST                         Reserved for La
     C                   MOVEL     BGONST        WUONST                         Reserved for La
     C                   MOVEL     BGOOST        WUOOST                         Reserved for La
     C                   MOVEL     BGOPST        WUOPST                         Reserved for La
     C                   MOVEL     BGOQST        WUOQST                         Reserved for La
     C                   MOVEL     BGORST        WUORST                         Reserved for La
     C                   MOVEL     BGOSST        WUOSST                         Reserved for La
      *================================================================
     CSR   TFEXIT        ENDSR
      /EJECT
     CSR   TGRVGN        BEGSR
      *================================================================
      * Get Base Currency - Bank Details  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSTG         KLIST
     C                   KFLD                    BJBANK                         Bank
      * Move fields to key list
     C                   MOVE      *BLANK        BJBANK                         Bank
     C                   MOVEL     'BANK'        BJBANK                         Bank
     C     KRSTG         CHAIN     @BJREEF                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0197'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
      * Setup message data for message
     C                   MOVEL     'SDBANKPD'    ZA0080                         Filename
      * Send message 'Database Error (ICD)'
     C                   MOVEL     'USR0377'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   GOTO      TGEXIT                                       *QUIT
     C                   GOTO      TGEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
      * PAR = DB1 By name
     C                   MOVEL     BJCYCD        WUBCCY                         Currency Code
     C                   END
      *================================================================
     CSR   TGEXIT        ENDSR
      /EJECT
     CSR   THRVGN        BEGSR
      *================================================================
      * Get Base CCY for Limits - Dealing Data  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSTH         KLIST
     C                   KFLD                    BNDLDA                         Dealing Data
      * Move fields to key list
     C                   MOVE      *BLANK        BNDLDA                         Dealing Data
     C                   MOVEL     'DEAL'        BNDLDA                         Dealing Data
     C     KRSTH         CHAIN     @BNREEI                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0205'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     *BLANK        WUBCLF                         Base CCY Limits
     C                   MOVEL     '*NO*'        WUBCLF                         Base CCY Limits
     C                   GOTO      THEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
      * CASE: DB1.Currency Code is blank
     C     BNCYCD        IFEQ      *BLANK                                       *IF
     C                   MOVEL     *BLANK        WUBCLF                         Base CCY Limits
     C                   MOVEL     '*NO*'        WUBCLF                         Base CCY Limits
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     BNCYCD        WUBNCD                         Currency Code
     C                   MOVEL     *BLANK        WUBCLF                         Base CCY Limits
     C                   MOVEL     '*YES*'       WUBCLF                         Base CCY Limits
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   THEXIT        ENDSR
      /EJECT
     CSR   TIRVGN        BEGSR
      *================================================================
      * Get 'Window required' ind - MIDAS Modules  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSTI         KLIST
     C                   KFLD                    BGMODS                         Modules
      * Move fields to key list
     C                   MOVE      *BLANK        BGMODS                         Modules
     C                   MOVEL     'MMOD'        BGMODS                         Modules
     C     KRSTI         CHAIN     @BGREC8                            90        *
      * Data record not found
     C   90              MOVEL     'USR0096'     W0RTN             7
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
      * CASE: DB1.Window processing requir. is Yes
     C     BGWDPR        IFEQ      'Y'                                          *IF
     C                   MOVEL     'Y'           WUWDPR                         Window processi
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   TIEXIT        ENDSR
      /EJECT
     CSR   UASUBR        BEGSR
      *================================================================
      * start E24686
      *================================================================
      * store Dealing Currency Indicator from record
     C                   MOVEL     A6DLCI        WUDLCI                         Dealing Currenc
      * end E24686
      *================================================================
     CSR   UAEXIT        ENDSR
      /EJECT
     CSR   UBSUBR        BEGSR
      *================================================================
      * Validate Currency name
      *================================================================
      * Start of Fix E20222
      * CASE: DTL.Currency Name is Blank
     C     #1CYNM        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1CYNM        ZA0002                         Currency Name
      * Send message 'Currency Name required'
     C                   MOVEL     'USR0777'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
      * Start of SAR S01117
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
      * End of SAR S01117
     C                   END                                                    *FI
      * End of Fix E20222
      *================================================================
     CSR   UBEXIT        ENDSR
      /EJECT
     CSR   UCSUBR        BEGSR
      *================================================================
      * Validate No. of Decimal Places
      *================================================================
      * Start of SAR S01117
      * CASE: DTL.No. of Dec. Places alpha is Not Blank
     C     #DNDPA        IFNE      *BLANK                                       *IF
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DNDPA        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0017            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0018           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0019            1 0          ZALIGN No Of De
     C                   PARM      1             WQ0020            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0021           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0022           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0023            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DNDPA        ZA0003                         No. of Dec. Pla
      * Send message 'No of dec places invalid'
     C                   MOVEL     'USR0778'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.No. of Dec. Places alpha is Valid Values
     C     #DNDPA        IFGE      '0'                                          *IF
     C     #DNDPA        ANDLE     '3'
      * Zedit No. Decimal Places - Currency Codes  *
     C*
     C* Move ZALIGN function field into No Decimal Places on
     C* the screen
     C*
     C                   MOVE      WUZASF        #DNDPA
     C*
     C                   MOVE      WUZAFF        #1NBDP                         Number of Decim
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DNDPA        ZA0004                         No. of Dec. Pla
      * Send message 'No of dec places invalid'
     C                   MOVEL     'USR0778'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Start of Fix E20222
      * Setup message data for message
     C                   MOVEL     #DNDPA        ZA0005                         No. of Dec. Pla
      * Send message 'No of dec places invalid'
     C                   MOVEL     'USR0778'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
      * End of Fix E20222
     C                   END                                                    *FI
      * Removed function to move char value to numeric field (the charact
      * /status field on screen has been replaced by code/alpha field)
      * End of SAR S01117
      *================================================================
     CSR   UCEXIT        ENDSR
      /EJECT
     CSR   UDSUBR        BEGSR
      *================================================================
      * Validate S.W.I.F.T. currency code
      *================================================================
      * Start of Fix E20222
      * CASE: DTL.Swift Currency Code is Blank
     C     #1SWCY        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1SWCY        ZA0006                         Swift Currency
      * Send message 'SWIFT currency code inval'
     C                   MOVEL     'USR0781'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: *OTHERWISE
      * Start of SAR S01117
      * CASE: DTL.Swift Currency Code is Alphabetic
     C     #1SWCY        IFGE      'AAA'                                        *IF
     C     #1SWCY        ANDLE     'ZZZ'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1SWCY        ZA0007                         Swift Currency
      * Send message 'SWIFT currency code inval'
     C                   MOVEL     'USR0781'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
      * End of SAR S01117
      *                                                                                       CMG003
     C     CMG003        IFEQ      'Y'
     C*****#1SWCY        SETLL     SDPMRTPD                           63                    MD058085
     C*****#1SWCY        CHAIN     SDPMRTPD                           63                    MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDPMRT                                                                        MD058085
     C+ from SDPMRJW0                                                                       MD058085
     C+ where A7CURR = :#1SWCY                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C******IN63         IFEQ      *OFF                                                     MD058085
     C     SQLCODE       IFEQ      0                                                        MD058085
     C                   MOVEL     'Y'           #1PMSC            1
     C                   ELSE
     C                   MOVEL     'N'           #1PMSC
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CMG003
     C                   END                                                    *FI
      * End of Fix E20222
      *================================================================
     CSR   UDEXIT        ENDSR
      /EJECT
     CSR   UESUBR        BEGSR
      *================================================================
      * Validate Dealing Currency Indicator
      *================================================================
      * Start of Fix E20222
      * CASE: DTL.Dealing Currency Ind. is Valid Values
     C     #1DLCI        IFEQ      'N'                                          *IF
     C     #1DLCI        OREQ      'Y'
     C                   ELSE
      * CASE: DTL.Dealing Currency Ind. is blank
     C     #1DLCI        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'Y'           #1DLCI                         Dealing Currenc
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1DLCI        ZA0008                         Dealing Currenc
      * Send message 'Dealing ccy ind. Invalid'
     C                   MOVEL     'USR0780'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of Fix E20222
      * start E24686
     C                   EXSR      UFSUBR                                       start E24686
      * end E24686
      *================================================================
     CSR   UEEXIT        ENDSR
      /EJECT
     CSR   UFSUBR        BEGSR
      *================================================================
      * start E24686
      *================================================================
      * Do not allow Dealing Currency Indicator to change from Y to N
      * if Exchange or Interest Rates exist for this Currency.
      * CASE: WRK.Dealing Currency Ind. is Yes
     C     WUDLCI        IFEQ      'Y'                                          *IF
      * CASE: DTL.Dealing Currency Ind. is No
     C     #1DLCI        IFEQ      'N'                                          *IF
      * Can Currency be deleted? - Currency Codes  *
     C                   MOVEL     #1CYCD        U1CCY                                         E2168
     C     U1CCYL        CHAIN     FDCCYPP0                           9091                     E2168
     C     *IN91         IFEQ      '1'                                                         E2168
     C* RECORD LOCKED                                                     E21685
     C                   MOVEL     'Y2U0004'     W0RTN             7                           E2168
     C                   END                                                                   E2168
     C*                                                                   E21685
     C** IF A RECORD EXISTS ON THE FILE THEN EXCHANGE RATES ARE PRESENT
     C** FOR THE CURRENCY WHICH CAN NOT BE DELETED.
     C** THE CURRENCY CANNOT CHANGE FROM A DEALING TO A NON-DEALING ONE   E24686
     C*                                                                   E21685
     C     *IN90         IFEQ      '0'                                                         E2168
     C                   MOVE      'E'           WUERST                                        E2168
     C                   END                                                                   E2168
     C                   MOVEL     #1CYCD        U2CCY                                         E2168
     C***********          MOVEL'D'       U2TPRD                    E21685E24686
     C***********          Z-ADD1         U2PRD                     E21685E24686
     C     U2INTR        CHAIN     FDINTRP0                           9091                     E2168
     C     *IN91         IFEQ      '1'                                                         E2168
     C** RECORD LOCKED                                                    E21685
     C                   MOVEL     'Y2U0004'     W0RTN             7                           E2168
     C                   END                                                                   E2168
      *                                                                   E21685
     C     *IN90         IFEQ      '0'                                                         E2168
     C*
     C** IF A RECORD HAS BEEN FOUND ON THE FILE THEN INTEREST RATES
     C** EXIST FOR THE CURRENCY AND CAN NOT BE DELETED
     C** THE CURRENCY CANNOT CHANGE FROM A DEALING TO A NON-DEALING ONE   E24686
     C*
     C     WUERST        IFEQ      'E'                                                         E2168
     C*
     C** IF THE ERROR STATUS IS 'E' THEN SET THE ERROR STATUS TO 'B' FOR
     C** BOTH
     C*
     C                   MOVE      'B'           WUERST                                        E2168
     C                   ELSE                                                                  E2168
     C                   MOVE      'I'           WUERST                                        E2168
     C                   END                                                                   E2168
     C                   END                                                                   E2168
     C/EJECT                                                              E21685
     C*****************************************************************   E21685
      * CASE: WRK.Error Status is Exchange Rate
     C     WUERST        IFEQ      'E'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1DLCI        ZA0009                         Dealing Currenc
      * Send message 'Dealing Curr has X rates'
     C                   MOVEL     'USR1777'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   END                                                    *FI
      * CASE: WRK.Error Status is Interest Rate
     C     WUERST        IFEQ      'I'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1DLCI        ZA0010                         Dealing Currenc
      * Send message 'Dealing Curr has Int rate'
     C                   MOVEL     'USR1778'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   END                                                    *FI
      * CASE: WRK.Error Status is Both
     C     WUERST        IFEQ      'B'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1DLCI        ZA0011                         Dealing Currenc
      * Send message 'Dealing Curr has X rates'
     C                   MOVEL     'USR1777'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
      * Setup message data for message
     C                   MOVEL     #1DLCI        ZA0012                         Dealing Currenc
      * Send message 'Dealing Curr has Int rate'
     C                   MOVEL     'USR1778'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   UFEXIT        ENDSR
      /EJECT
     CSR   UGSUBR        BEGSR
      *================================================================
      * Validate Telex Notice Days
      *================================================================
      * Start of SAR S01117
      * CASE: DTL.Telex Notice Days alpha is Not Blank
     C     #DTNDA        IFNE      *BLANK                                       *IF
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DTNDA        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0024            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0025           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0026            1 0          ZALIGN No Of De
     C                   PARM      1             WQ0027            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0028           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0029           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0030            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DTNDA        ZA0013                         Telex Notice Da
      * Send message 'Telex Notice Days Invalid'
     C                   MOVEL     'USR1081'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   ELSE
      * CASE: *OTHERWISE
      * Zedit Telex Notice Days - Currency Codes  *
     C*
     C* Move ZALIGN function field into Telex Notice Days on
     C* the screen
     C*
     C                   MOVE      WUZASF        #DTNDA
     C*
     C                   MOVE      WUZAFF        #1TXND                         Telex Notice Da
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Start of Fix E20222
      * Setup message data for message
     C                   MOVEL     #DTNDA        ZA0014                         Telex Notice Da
      * Send message 'Telex Notice Days Invalid'
     C                   MOVEL     'USR1081'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
      * End of Fix E20222
     C                   END                                                    *FI
      * Removed function to move Notice Days from screen to DB1 format
      * End of SAR S01117
      *================================================================
     CSR   UGEXIT        ENDSR
      /EJECT
     CSR   UHSUBR        BEGSR
      *================================================================
      * Validate Sort Sequence Number
      *================================================================
      * Start of SAR S01117
      * Check numeric value is entered
      * CASE: DTL.Sort Sequence alpha is Not Blank
     C     #DSSQA        IFNE      *BLANK                                       *IF
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DSSQA        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0031            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0032           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0033            1 0          ZALIGN No Of De
     C                   PARM      2             WQ0034            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0035           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0036           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0037            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DSSQA        ZA0015                         Sort Sequence a
      * Send message 'Field Not Numeric'
     C                   MOVEL     'USR0822'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   ELSE
      * CASE: *OTHERWISE
      * Zedit Sort Sequence - Currency Codes  *
     C*
     C* Move ZALIGN function field into FT Rate on the screen
     C*
     C                   MOVE      WUZASF        #DSSQA
     C*
     C                   MOVE      WUZAFF        #1SSNB                         Sort Sequence N
      * End of SAR S01117
      * CASE: DTL.Sort Sequence Number is Sequence Range
     C     #1SSNB        IFGE      01                                           *IF
     C     #1SSNB        ANDLE     99
      * Do nothing if in range, otherwise send error message
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DSSQA        ZA0016                         Sort Sequence a
      * Send message 'Sort Sequence No. blank'
     C                   MOVEL     'USR0784'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   END                                                    *FI
     C                   END                                                    *FI
     C/COPY WNCPYSRC,SD0021RC26
     C                   END                                                    *FI
     C/COPY WNCPYSRC,SD0021RC27
      *================================================================
     CSR   UHEXIT        ENDSR
     CSR   UINIT         BEGSR                                                                 E2168
     C* SUBROUTINE TO CONTAIN THE KLISTS SO THAT THEY ARE NOT REPEATED    E21685
     C* IN THE CODE                                                       E21685
     C*****************************************************************   E21685
     C*
     C     U1CCYL        KLIST                                                                 E2168
     C                   KFLD                    U1CCY             3                           E2168
     C*
     C     U2INTR        KLIST                                                                 E2168
     C                   KFLD                    U2CCY             3                           E2168
     C***********          KFLD           U2TPRD  1                 E21685E24686
     C***********          KFLD           U2PRD   20                E21685E24686
     C*
     C                   ENDSR                                                                 E2168
      /EJECT
     CSR   UISUBR        BEGSR
      *================================================================
      * Validate Spot Rate
      *================================================================
      * Start of SAR S01117
      * Check Numeric value entered
      * CASE: DTL.Spot Rate alpha is Not Blank
     C     #DSPRA        IFNE      *BLANK                                       *IF
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DSPRA        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0038            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0039           16            ZALIGN Screen F
     C                   PARM      8             WQ0040            1 0          ZALIGN No Of De
     C                   PARM      5             WQ0041            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0042           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0043           16            ZALIGN Screen F
     C                   PARM      8             WQ0044            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DSPRA        ZA0017                         Spot Rate alpha
      * Send message 'Rate is of wrong form'
     C                   MOVEL     'USR1151'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: *OTHERWISE
      * Zedit Spot Rate - Currency Codes  *
     C*
     C* Move ZALIGN function field into Spot Rate on the screen
     C*
     C                   MOVE      WUZASF        #DSPRA
     C*
     C                   MOVE      WUZAFF        #1SPRT                         Spot Rate
      * CASE: DTL.Multiply/Divide Indicator is Divide Amount by Rate
     C     #1MDIN        IFEQ      'D'                                          *IF
      * CASE: DTL.Spot Rate is Blank
     C     #1SPRT        IFEQ      *ZERO                                        *IF
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
      * Setup message data for message
     C                   MOVEL     #DSPRA        ZA0018                         Spot Rate alpha
     C                   MOVEL     #1MDIN        ZA0019                         Multiply/Divide
      * Send message 'Spot Rate Zero Divide'
     C                   MOVEL     'USR1207'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        993738    *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of SAR S01117
      *                                                                   CEU002
      ** If CUE002 is on then can't Amend the Spot Rate.                  CEU002
      *                                                                   CEU002
     C     CEU002        IFEQ      'N'                                          *IF            CEU00
      * CASE: PGM.*Program mode is *CHANGE
     C     W0PMD         IFEQ      'CHG'                                        *IF
      * CASE: WRK.Old Mult/Div Indicator EQ DTL.Multiply/Divide Indicator
     C     WUOMDI        IFEQ      #1MDIN                                       *IF
     C                   Z-ADD     #1SPRT        WUNSRT                         New Spot Rate
      * Check rate within +/- 10%
      * CASE: PAR.Old Spot Rate is Not Blank
     C     WUOSRT        IFNE      *ZERO                                        *IF
     C     WUNSRT        DIV(H)    WUOSRT        WUTTRF                         10% Test raw fi
      * CASE: WRK.10% Test raw figure is Over 110%
     C     WUTTRF        IFGT      1.1                                          *IF
     C                   MOVEL     '*GTTENP'     WUUVRC                         User Validation
     C                   END                                                    *FI
      * CASE: WRK.10% Test raw figure is Under 90%
     C     WUTTRF        IFLT      0.9                                          *IF
     C                   MOVEL     '*LTNTYP'     WUUVRC                         User Validation
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.User Validation *RTNCDE is Over + or - 10% cha
     C     WUUVRC        IFEQ      '*GTTENP'                                    *IF
     C     WUUVRC        OREQ      '*LTNTYP'
      * Setup message data for message
     C                   MOVEL     #DSPRA        ZA0020                         Spot Rate alpha
      * Send message 'Spot Rate not within +-10'
     C                   MOVEL     'USR1086'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   MOVEL     '*NORMAL'     WUUVRC                         User Validation
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *                                                                   CEU002
     C                   ELSE                                                                  CEU00
     C     WUOSRT        IFNE      #1SPRT                                       *IF            CEU00
     C     W0PMD         ANDNE     'ADD'                                                       CEU00
      * Setup message data for message                                    CEU002
     C                   MOVEL     #DSPRA        ZA0081                         Spot Rate alphaCEU00
      * Send message 'Field not amendable,Use Spot Rates Maint.'          CEU002
     C                   MOVEL     'USR3561'     ZAMSID                                        CEU00
     C                   EXSR      ZASNMS                                                      CEU00
     C                   SETON                                        9937      *              CEU00
      *                                                                   CEU002
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3    CEU00
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm CEU00
     C                   END                                                    *FI            CEU00
     C                   END                                                    *FI            CEU00
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DSPRA        ZA0021                         Spot Rate alpha
      * Send message 'Spot Rate mustnt be blank'
     C                   MOVEL     'USR1144'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
      *================================================================
     CSR   UIEXIT        ENDSR
      /EJECT
     CSR   UJSUBR        BEGSR
      *================================================================
      * Validate Spot Rate Multiply/Divide Indicator
      *================================================================
      *                                                                   CEU002
      ** If CUE002 is on then can't Amend the Mult/Div Ind                CEU002
      *                                                                   CEU002
     C     CEU002        IFEQ      'N'                                          *IF            CEU00
      * Start of Fix E20222
      * CASE: DTL.Multiply/Divide Indicator is valid value
     C     #1MDIN        IFEQ      'D'                                          *IF
     C     #1MDIN        OREQ      'M'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MDIN        ZA0022                         Multiply/Divide
      * Send message 'Sp Rate Mul/Div ind blank'
     C                   MOVEL     'USR0783'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   END                                                    *FI
      * End of Fix E20222
     C                   ELSE                                                                  CEU00
      * If the Mult/Div Ind has been changed and CEU002 is on.            CEU002
     C     WUOMDI        IFNE      #1MDIN                                       *IF            CEU00
     C     W0PMD         ANDNE     'ADD'                                                       CEU00
      * Setup message data for message                                    CEU002
     C                   MOVEL     #1MDIN        ZA0082                         Multiply/DivideCEU00
      * Send message 'Field not amendable,Use Spot Rates Maint.'          CEU002
     C                   MOVEL     'USR3561'     ZAMSID                                        CEU00
     C                   EXSR      ZASNMS                                                      CEU00
     C                   SETON                                        9938      *              CEU00
      *                                                                   CEU002
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3    CEU00
     C                   END                                                    *FI            CEU00
     C                   END                                                    *FI            CEU00
      *================================================================
     CSR   UJEXIT        ENDSR
      *****************************************************************                       CGL014
      /EJECT                                                                                  CGL014
      *****************************************************************                       CGL014
      *                                                               *                       CGL014
      *  SRWGCD - Validate Weighting Code                             *                       CGL014
      *                                                               *                       CGL014
      *****************************************************************                       CGL014
      *                                                                                       CGL014
     C     SRWGCD        BEGSR
      *                                                                                       CGL014
      ** Exposure Weighting Code must an numeric number                                       CGL014
      *                                                                                       CGL014
     C     #1EXWC        IFNE      *BLANKS
      *                                                                                       CGL014
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      #1EXWC        ZFIELD
     C                   MOVEL     #1EXWC        WK1X01            1
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     2             ZADIG
     C                   EXSR      ZALIGN
      *                                                                                       CGL014
     C     *IN99         IFEQ      *ON
     C     WK1X01        ANDNE     '?'
     C                   MOVE      *ON           *IN99
     C                   MOVE      *ON           *IN82
     C                   MOVEL     #1EXWC        ZA0089
     C                   MOVEL     'USR4528'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'N'           WUWFG3
     C                   MOVEL     'Y'           W0DCF
     C                   ELSE
      *                                                                                       CGL014
     C     WK1X01        IFEQ      '?'
     C                   MOVE      '? '          WWEXWC
     C                   ELSE
     C                   MOVE      ZFIELD        WWEXWC            2
     C                   ENDIF
      *                                                                                       CGL014
      ** Exposure Weighting Code must be valid                                                CGL014
      *                                                                                       CGL014
     C                   MOVEL     'GP'          AOPGM            10
     C                   MOVE      'AOWEIGR0'    AOPGM
     C                   CALL      AOPGM
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    WWEXWC
     C     GPWEIG        PARM      GPWEIG        DSFDY
      *                                                                                       CGL014
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      *ON           *IN99
     C                   MOVE      *ON           *IN82
     C                   MOVEL     #1EXWC        ZA0089
     C                   MOVEL     'USR4529'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'N'           WUWFG3
     C                   MOVEL     'Y'           W0DCF
     C                   ELSE
     C                   MOVE      PDWEIG        #1EXWC
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CGL014
     C                   ENDIF
      *                                                                                       CGL014
      ** Position Weighting Code must an numeric number                                       CGL014
      *                                                                                       CGL014
     C     #1POWC        IFNE      *BLANKS
      *                                                                                       CGL014
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      #1POWC        ZFIELD
     C                   MOVEL     #1POWC        WK1X01
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     2             ZADIG
     C                   EXSR      ZALIGN
      *                                                                                       CGL014
     C     *IN99         IFEQ      *ON
     C     WK1X01        ANDNE     '?'
     C                   MOVE      *ON           *IN99
     C                   MOVE      *ON           *IN83
     C                   MOVEL     #1POWC        ZA0090
     C                   MOVEL     'USR4530'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'N'           WUWFG3
     C                   MOVEL     'Y'           W0DCF
      *                                                                                       CGL014
     C                   ELSE
      *                                                                                       CGL014
     C     WK1X01        IFEQ      '?'
     C                   MOVE      '? '          WWPOWC
     C                   ELSE
     C                   MOVE      ZFIELD        WWPOWC            2
     C                   ENDIF
      *                                                                                       CGL014
      ** Position Weighting Code must be valid                                                CGL014
      *                                                                                       CGL014
     C                   MOVEL     'GP'          AOPGM
     C                   MOVE      'AOWEIGR0'    AOPGM
     C                   CALL      AOPGM
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    WWPOWC
     C     GPWEIG        PARM      GPWEIG        DSFDY
      *                                                                                       CGL014
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      *ON           *IN99
     C                   MOVE      *ON           *IN83
     C                   MOVEL     #1POWC        ZA0090
     C                   MOVEL     'USR4531'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'N'           WUWFG3
     C                   MOVEL     'Y'           W0DCF
     C                   ELSE
     C                   MOVE      PDWEIG        #1POWC
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CGL014
     C                   ENDIF
      *                                                                                       CGL014
     C                   ENDSR
      *                                                                                       CGL014
      *****************************************************************                       CGL014
      /EJECT
     CSR   UKSUBR        BEGSR
      *================================================================
      * Validate Par Rate
      *================================================================
     C/COPY WNCPYSRC,SD0021RC10
      * Start of SAR S01117
      * Check Numeric value entered
      * CASE: DTL.Par Rate alpha is Not Blank
     C     #DPRTA        IFNE      *BLANK                                       *IF
      * CASE: DTL.Multiply/Divide, Par is Blank
     C     #1MDPR        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DPRTA        ZA0025                         Par Rate alpha
     C                   MOVEL     #1MDPR        ZA0026                         Multiply/Divide
      * Send message 'Par Rate or Ind In Error'
     C                   MOVEL     'USR0364'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        994041    *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   END                                                    *FI
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DPRTA        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0052            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0053           16            ZALIGN Screen F
     C                   PARM      8             WQ0054            1 0          ZALIGN No Of De
     C                   PARM      5             WQ0055            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0056           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0057           16            ZALIGN Screen F
     C                   PARM      8             WQ0058            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DPRTA        ZA0027                         Par Rate alpha
      * Send message 'Rate is of wrong form'
     C                   MOVEL     'USR1151'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9940      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: *OTHERWISE
      * Zedit Par Rate - Currency Codes  *
     C*
     C* Move ZALIGN function field into Par Rate on the screen
     C*
     C                   MOVE      WUZASF        #DPRTA
     C*
     C                   MOVE      WUZAFF        #1PRRT                         Par Rate
      * CASE: DTL.Multiply/Divide, Par is Divide Amount by Rate
     C     #1MDPR        IFEQ      'D'                                          *IF
      * CASE: DTL.Par Rate is Blank
     C     #1PRRT        IFEQ      *ZERO                                        *IF
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
      * Setup message data for message
     C                   MOVEL     #DPRTA        ZA0028                         Par Rate alpha
     C                   MOVEL     #1MDPR        ZA0029                         Multiply/Divide
      * Send message 'Par Rate Zero Divide'
     C                   MOVEL     'USR1208'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        994041    *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of SAR S01117
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Multiply/Divide, Par is Blank
     C     #1MDPR        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DPRTA        ZA0030                         Par Rate alpha
     C                   MOVEL     #1MDPR        ZA0031                         Multiply/Divide
      * Send message 'Par Rate or Ind In Error'
     C                   MOVEL     'USR0364'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        994041    *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
     C                   END                                                    *FI
     C/COPY WNCPYSRC,SD0021RC20
      *================================================================
     CSR   UKEXIT        ENDSR
      /EJECT
     CSR   ULSUBR        BEGSR
      *================================================================
      * Calculate Limit Rate and M/D indicator
      *================================================================
      * CASE: WRK.Base CCY Limits Found? is Yes
     C     WUBCLF        IFEQ      '*YES*'                                      *IF
      * Get Base Limits CCY detls - Currency Codes  *
     C                   EXSR      SBRVGN
     C                   END                                                    *FI
      * CASE: WRK.Base CCY Limits Found? is Yes
     C     WUBCLF        IFEQ      '*YES*'                                      *IF
      * CASE: WRK.Base Currency NE DTL.Currency Code
     C     WUBCCY        IFNE      #1CYCD                                       *IF
      * CASE: WRK.Base Currency for Limits NE DTL.Currency Code
     C     WUBNCD        IFNE      #1CYCD                                       *IF
      * CASE: DTL.Multiply/Divide Indicator EQ WRK.Base Limits CCY M/D In
     C     #1MDIN        IFEQ      WUBLCM                                       *IF
     C     #1SPRT        DIV(H)    WUBRLC        #1ERLC                         Exchange Rate -
     C                   ELSE
      * CASE: *OTHERWISE
     C     #1SPRT        MULT(H)   WUBRLC        #1ERLC                         Exchange Rate -
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.Base Currency EQ DTL.Currency Code
     C     WUBCCY        IFEQ      #1CYCD                                       *IF
      * Start of Fix E21210
      * CASE: WRK.Base Limits CCY M/D Ind is Multiply Amount by Rate
     C     WUBLCM        IFEQ      'M'                                          *IF
     C     1             DIV(H)    WUBRLC        #1ERLC                         Exchange Rate -
     C                   ELSE
      * CASE: *OTHERWISE
     C     WUBRLC        ADD       *ZERO         #1ERLC                         Exchange Rate -
     C                   END                                                    *FI
      * End of Fix E21210
     C                   END                                                    *FI
      * CASE: WRK.Base Currency for Limits EQ DTL.Currency Code
     C     WUBNCD        IFEQ      #1CYCD                                       *IF
     C                   Z-ADD     1             #1ERLC                         Exchange Rate -
      * CASE: DTL.Spot Rate NE WRK.Old Spot Rate
     C     #1SPRT        IFNE      WUOSRT                                       *IF
      * Update Limits Rate RTV - Currency Codes  *
     C                   EXSR      SCRVGN
     C                   END                                                    *FI
      * CASE: DTL.Spot Rate EQ WRK.Old Spot Rate
     C     #1SPRT        IFEQ      WUOSRT                                       *IF
      * CASE: WRK.Old Mult/Div Indicator NE DTL.Multiply/Divide Indicator
     C     WUOMDI        IFNE      #1MDIN                                       *IF
      * Update Limits Rate RTV - Currency Codes  *
     C                   EXSR      SERVGN
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   ULEXIT        ENDSR
      /EJECT
     CSR   UMSUBR        BEGSR
      *================================================================
      * Validate F.T. Rate
      *================================================================
      * Start of SAR S01117
      * Check value entered is numeric
      * CASE: DTL.FT Rate alpha is Not Blank
     C     #DFTRA        IFNE      *BLANK                                       *IF
      * CASE: DTL.Multiply/Divide, Hist Bkg is Blank
     C     #1MDHB        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
      * Setup message data for message
     C                   MOVEL     #DFTRA        ZA0037                         FT Rate alpha
     C                   MOVEL     #1MDHB        ZA0038                         Multiply/Divide
      * Send message 'F.T. Rate or Ind in error'
     C                   MOVEL     'USR0365'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        994344    *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DFTRA        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0072            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0073           16            ZALIGN Screen F
     C                   PARM      8             WQ0074            1 0          ZALIGN No Of De
     C                   PARM      5             WQ0075            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0076           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0077           16            ZALIGN Screen F
     C                   PARM      8             WQ0078            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DFTRA        ZA0039                         FT Rate alpha
      * Send message 'Rate is of wrong form'
     C                   MOVEL     'USR1151'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9943      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: *OTHERWISE
      * Zedit FT Rate - Currency Codes  *
     C*
     C* Move ZALIGN function field into FT Rate on the screen
     C*
     C                   MOVE      WUZASF        #DFTRA
     C*
     C                   MOVE      WUZAFF        #1HBRT                         Historic Broker
      * CASE: DTL.Multiply/Divide, Hist Bkg is Divide Amount by Rate
     C     #1MDHB        IFEQ      'D'                                          *IF
      * CASE: DTL.Historic Brokerage Rate is Blank
     C     #1HBRT        IFEQ      *ZERO                                        *IF
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
      * Setup message data for message
     C                   MOVEL     #DFTRA        ZA0040                         FT Rate alpha
     C                   MOVEL     #1MDHB        ZA0041                         Multiply/Divide
      * Send message 'FT Rate Zero Divide'
     C                   MOVEL     'USR1209'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        994344    *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of SAR S01117
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Multiply/Divide, Hist Bkg is Blank
     C     #1MDHB        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
      * Setup message data for message
     C                   MOVEL     #DFTRA        ZA0042                         FT Rate alpha
     C                   MOVEL     #1MDHB        ZA0043                         Multiply/Divide
      * Send message 'F.T. Rate or Ind in error'
     C                   MOVEL     'USR0365'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        994344    *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   UMEXIT        ENDSR
      /EJECT
     CSR   UNSUBR        BEGSR
      *================================================================
      * Validate Spot Trade Account Equivalent
      *================================================================
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
     C                   MOVEL     #1SPAE        WUTQKF                         Test ? in Key F
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      '?'                                          *IF
      * Select Account Codes - Account Codes  *
     C                   CALL      'SD0031S'                            90      Select Account
     C                   PARM      *BLANK        W0RTN             7
     C********** #1SPAE    PARM #1SPAE    WQ0079  4        Account Code                       CGL029
     C     #1SPAE        PARM      #1SPAE        WQ0079           10
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0031S'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9945      *
     C                   END
      * Setup key for SDCURRL7                                            179231
     C**********           MOVEL#1SPAE    W#SPAE  4                                    179231 CGL029
     C                   MOVEL     #1SPAE        W#SPAE           10
     C                   Z-ADD     0             W#RECN            3 0                         17923
     C     W#SPAE        SETLL     SDCURRL7                                                    17923
     C     W#SPAE        READE     @CURRL7                                97                   17923
     C     *IN97         DOWEQ     *OFF                                                        17923
      * Count the occurances of the Spot Trade A/C code                   179231
     C     A6CYCD        IFNE      #1CYCD                                                      21747
     C                   ADD       1             W#RECN                                        17923
     C                   ENDIF                                                                 21747
     C     W#SPAE        READE     @CURRL7                                97                   17923
     C                   ENDDO                                                                 17923
      * No other occurances if 'Insert' mode, only one for 'Amend'        179231
     C     P2ANCD        IFEQ      'I'                                                         17923
     C     W#RECN        ANDGT     0                                                           17923
     C     P2ANCD        OREQ      'A'                                                         17923
     C     W#RECN        ANDGT     1                                                           17923
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3    17923
      * Setup message data for message                                    179231
     C                   MOVEL     #1SPAE        ZA0083                         Spot Trade Acco17923
      * Send message 'Spot Trade A/C equiv must be unique'                179231
     C                   MOVEL     'USR8823'     ZAMSID                                        17923
     C                   EXSR      ZASNMS                                                      17923
     C                   SETON                                        9945      *              17923
     C                   ENDIF                                                                 17923
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: DTL.Spot Trade Account Equiv. is blank
     C     #1SPAE        IFEQ      *BLANK                                       *IF
      * CASE: DTL.Currency Code NE WRK.Base Currency
     C     #1CYCD        IFNE      WUBCCY                                       *IF
      * Setup message data for message
     C                   MOVEL     #1SPAE        ZA0045                         Spot Trade Acco
      * Send message 'Spot Trade A/C equiv Mand'
     C                   MOVEL     'USR0366'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9945      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Retrieve Record - Account Codes  *
     C                   EXSR      SGRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
      * Setup message data for message
     C                   MOVEL     #1SPAE        ZA0046                         Spot Trade Acco
      * Send message 'Account Code not found'
     C                   MOVEL     'USR0554'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9945      *
      *
     C                   END                                                    *FI
      * Setup key for SDCURRL7                                            179231
     C                   MOVEL     #1SPAE        W#SPAE                                        17923
     C                   Z-ADD     0             W#RECN                                        17923
     C     W#SPAE        SETLL     SDCURRL7                                                    17923
     C     W#SPAE        READE     @CURRL7                                97                   17923
     C     *IN97         DOWEQ     *OFF                                                        17923
      * Count the occurances of the Spot Trade A/C code                   179231
     C     A6CYCD        IFNE      #1CYCD                                                      21747
     C                   ADD       1             W#RECN                                        17923
     C                   ENDIF                                                                 21747
     C     W#SPAE        READE     @CURRL7                                97                   17923
     C                   ENDDO                                                                 17923
      * No other occurances if 'Insert' mode, only one for 'Amend'        179231
     C     P2ANCD        IFEQ      'I'                                                         17923
     C     W#RECN        ANDGT     0                                                           17923
     C     P2ANCD        OREQ      'A'                                                         17923
     C     W#RECN        ANDGT     1                                                           17923
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3    17923
      * Setup message data for message                                    179231
     C                   MOVEL     #1SPAE        ZA0083                         Spot Trade Acco17923
      * Send message 'Spot Trade A/C equiv must be unique'                179231
     C                   MOVEL     'USR8823'     ZAMSID                                        17923
     C                   EXSR      ZASNMS                                                      17923
     C                   SETON                                        9945      *              17923
     C                   ENDIF                                                                 17923
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Spot Trade Account Equiv. is blank
     C     #1SPAE        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
      * Setup message data for message
     C                   MOVEL     #1SPAE        ZA0047                         Spot Trade Acco
      * Send message 'Spot Trade A/C equiv Mand'
     C                   MOVEL     'USR0366'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9945      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   UNEXIT        ENDSR
      /EJECT
     CSR   UOSUBR        BEGSR
      *================================================================
      * Validate Forward Trade Account Equivalent
      *================================================================
      * Start of Fix E18904
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
     C                   MOVEL     #1FTAE        WUTQKF                         Test ? in Key F
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      '?'                                          *IF
      * Select Account Codes - Account Codes  *
     C                   CALL      'SD0031S'                            90      Select Account
     C                   PARM      *BLANK        W0RTN             7
     C********** #1FTAE    PARM #1FTAE    WQ0080  4        Account Code                       CGL029
     C     #1FTAE        PARM      #1FTAE        WQ0080           10
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0031S'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9946      *
     C                   END
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: DTL.Fwd Trade Account Equiv. is blank
     C     #1FTAE        IFEQ      *BLANK                                       *IF
      * Start of SAR S01117
      * CASE: DTL.Currency Code NE WRK.Base Currency
     C     #1CYCD        IFNE      WUBCCY                                       *IF
      * CASE: DTL.Dealing Currency Ind. is Yes
     C     #1DLCI        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1FTAE        ZA0048                         Fwd Trade Accou
      * Send message 'Fwd Trade A/C equiv mand.'
     C                   MOVEL     'USR0367'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9946      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of SAR S01117
     C                   ELSE
      * CASE: *OTHERWISE
      * Retrieve Record - Account Codes  *
     C                   EXSR      SHRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1FTAE        ZA0049                         Fwd Trade Accou
      * Send message 'Account Code not found'
     C                   MOVEL     'USR0554'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9946      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Fwd Trade Account Equiv. is blank
     C     #1FTAE        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
      * Setup message data for message
     C                   MOVEL     #1FTAE        ZA0050                         Fwd Trade Accou
      * Send message 'Fwd Trade A/C equiv mand.'
     C                   MOVEL     'USR0367'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9946      *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of Fix E18904
      *================================================================
     CSR   UOEXIT        ENDSR
      /EJECT
     CSR   UPSUBR        BEGSR
      *================================================================
      * Validate Swap Trade Account Equivalent
      *================================================================
      * Start of Fix E20222
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
     C                   MOVEL     #1SWAE        WUTQKF                         Test ? in Key F
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      '?'                                          *IF
      * Select Account Codes - Account Codes  *
     C                   CALL      'SD0031S'                            90      Select Account
     C                   PARM      *BLANK        W0RTN             7
     C********** #1SWAE    PARM #1SWAE    WQ0081  4        Account Code                       CGL029
     C     #1SWAE        PARM      #1SWAE        WQ0081           10
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0031S'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9948      *
     C                   END
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: DTL.Swap Trade Account Equiv. is blank
     C     #1SWAE        IFEQ      *BLANK                                       *IF
      * Start of SAR S01117
      * CASE: DTL.Currency Code NE WRK.Base Currency
     C     #1CYCD        IFNE      WUBCCY                                       *IF
      * CASE: DTL.Dealing Currency Ind. is Yes
     C     #1DLCI        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1SWAE        ZA0051                         Swap Trade Acco
      * Send message 'Swap Trade A/C Equiv Mand'
     C                   MOVEL     'USR0368'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9948      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of SAR S01117
     C                   ELSE
      * CASE: *OTHERWISE
      * Retrieve Record - Account Codes  *
     C                   EXSR      SIRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
      * Setup message data for message
     C                   MOVEL     #1SWAE        ZA0052                         Swap Trade Acco
      * Send message 'Account Code not found'
     C                   MOVEL     'USR0554'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9948      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Swap Trade Account Equiv. is blank
     C     #1SWAE        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
      * Setup message data for message
     C                   MOVEL     #1SWAE        ZA0053                         Swap Trade Acco
      * Send message 'Swap Trade A/C Equiv Mand'
     C                   MOVEL     'USR0368'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9948      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of Fix E20222
      *================================================================
     CSR   UPEXIT        ENDSR
      /EJECT
     CSR   UQSUBR        BEGSR
      *================================================================
      * Validate Trade Account Code No's 4 & 5
      *================================================================
      * Retrieve Record - Account Codes  *
     C                   EXSR      SJRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
     C                   MOVEL     'N'           WUDA45                         Default Account
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'Y'           WUDA45                         Default Account
     C                   END                                                    *FI
      * Validation of Trade Account No. 4
      * CASE: DTL.Trade Account Code No.4 is blank
     C     #1TAC4        IFEQ      *BLANK                                       *IF
      * Start of SAR S01117
      * CASE: WRK.Default Accounts 4 + 5 is Yes
     C     WUDA45        IFEQ      'Y'                                          *IF
     C                   MOVEL     #1SPAE        #1TAC4                         Trade Account C
     C                   END                                                    *FI
      * End of SAR S01117
     C                   END                                                    *FI
      * CASE: WRK.Old Trade A/C Equiv. No.4 EQ DTL.Trade Account Code No.
     C     WUOTE4        IFEQ      #1TAC4                                       *IF
      * CASE: WRK.Old Spot Trade A/C Equiv. EQ DTL.Trade Account Code No.
     C     WUOSTE        IFEQ      #1TAC4                                       *IF
      * CASE: WRK.Default Accounts 4 + 5 is Yes
     C     WUDA45        IFEQ      'Y'                                          *IF
     C                   MOVEL     #1SPAE        #1TAC4                         Trade Account C
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
     C                   MOVEL     #1TAC4        WUTQKF                         Test ? in Key F
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      '?'                                          *IF
      * Select Account Codes - Account Codes  *
     C                   CALL      'SD0031S'                            90      Select Account
     C                   PARM      *BLANK        W0RTN             7
     C********** #1TAC4    PARM #1TAC4    WQ0082  4        Account Code                       CGL029
     C     #1TAC4        PARM      #1TAC4        WQ0082           10
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0031S'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9947      *
     C                   END
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: DTL.Trade Account Code No.4 is Non-blank
     C     #1TAC4        IFNE      *BLANK                                       *IF
      * Retrieve Record - Account Codes  *
     C                   EXSR      SKRVGN
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
      * Setup message data for message
     C                   MOVEL     #1TAC4        ZA0054                         Trade Account C
      * Send message 'Account Code not found'
     C                   MOVEL     'USR0554'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9947      *
      *
     C                   END                                                    *FI
      * retrieve type as well - Account Codes  *
     C                   EXSR      SLRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: WRK.Title Only Indicator is YES
     C     WUTOIN        IFEQ      'Y'                                          *IF
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
      * Setup message data for message
     C                   MOVEL     #1TAC4        ZA0055                         Trade Account C
      * Send message 'Title Only Not Allowed 4'
     C                   MOVEL     'USR1205'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9947      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Validation of Trade Account No. 5
      * CASE: DTL.Trade Account Code No.5 is blank
     C     #1TAC5        IFEQ      *BLANK                                       *IF
      * Start of SAR S01117
      * CASE: WRK.Default Accounts 4 + 5 is Yes
     C     WUDA45        IFEQ      'Y'                                          *IF
     C                   MOVEL     #1SPAE        #1TAC5                         Trade Account C
     C                   END                                                    *FI
      * End of SAR S01117
     C                   END                                                    *FI
      * CASE: WRK.Default Accounts 4 + 5 is Yes
     C     WUDA45        IFEQ      'Y'                                          *IF
      * CASE: WRK.Old Spot Trade A/C Equiv. EQ DTL.Trade Account Code No.
     C     WUOSTE        IFEQ      #1TAC5                                       *IF
     C                   MOVEL     #1SPAE        #1TAC5                         Trade Account C
     C                   END                                                    *FI
      * CASE: WRK.Old Trade A/C Equiv. No.5 EQ DTL.Trade Account Code No.
     C     WUOTE5        IFEQ      #1TAC5                                       *IF
      * CASE: WRK.Old Spot Trade A/C Equiv. EQ DTL.Trade Account Code No.
     C     WUOSTE        IFEQ      #1TAC5                                       *IF
     C                   MOVEL     #1SPAE        #1TAC5                         Trade Account C
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
     C                   MOVEL     #1TAC5        WUTQKF                         Test ? in Key F
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      '?'                                          *IF
      * Select Account Codes - Account Codes  *
     C                   CALL      'SD0031S'                            90      Select Account
     C                   PARM      *BLANK        W0RTN             7
     C********** #1TAC5    PARM #1TAC5    WQ0083  4        Account Code                       CGL029
     C     #1TAC5        PARM      #1TAC5        WQ0083           10
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0031S'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9949      *
     C                   END
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: DTL.Trade Account Code No.5 is Non-blank
     C     #1TAC5        IFNE      *BLANK                                       *IF
      * Retrieve Record - Account Codes  *
     C                   EXSR      SMRVGN
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
      * Setup message data for message
     C                   MOVEL     #1TAC5        ZA0056                         Trade Account C
      * Send message 'Account Code not found'
     C                   MOVEL     'USR0554'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9949      *
      *
     C                   END                                                    *FI
      * retrieve type as well - Account Codes  *
     C                   EXSR      SNRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: WRK.Title Only Indicator is YES
     C     WUTOIN        IFEQ      'Y'                                          *IF
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
      * Setup message data for message
     C                   MOVEL     #1TAC5        ZA0057                         Trade Account C
      * Send message 'Title Only Not Allowed 5'
     C                   MOVEL     'USR1206'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9949      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   UQEXIT        ENDSR
      /EJECT
     CSR   URSUBR        BEGSR
      *================================================================
      * Validate Weekend Days (Fri, Sat, Sun)
      *================================================================
      * CASE: DTL.FRI. Holiday is valid
     C     #1FRIH        IFEQ      'N'                                          *IF
     C     #1FRIH        OREQ      'Y'
     C                   ELSE
      * CASE: DTL.FRI. Holiday is Blank
     C     #1FRIH        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           #1FRIH                         FRI. Holiday
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1FRIH        ZA0058                         FRI. Holiday
      * Send message 'Inval value - must be Y/N'
     C                   MOVEL     'USR0805'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9950      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: DTL.SAT. Holiday is valid
     C     #1SATH        IFEQ      'N'                                          *IF
     C     #1SATH        OREQ      'Y'
     C                   ELSE
      * CASE: DTL.SAT. Holiday is Blank
     C     #1SATH        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           #1SATH                         SAT. Holiday
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1SATH        ZA0059                         SAT. Holiday
      * Send message 'Inval value - must be Y/N'
     C                   MOVEL     'USR0805'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9951      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: DTL.SUN. Holiday is valid
     C     #1SUNH        IFEQ      'N'                                          *IF
     C     #1SUNH        OREQ      'Y'
     C                   ELSE
      * CASE: DTL.SUN. Holiday is Blank
     C     #1SUNH        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           #1SUNH                         SUN. Holiday
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1SUNH        ZA0060                         SUN. Holiday
      * Send message 'Inval value - must be Y/N'
     C                   MOVEL     'USR0805'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9952      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   UREXIT        ENDSR
      /EJECT
     CSR   USSUBR        BEGSR
      *================================================================
      * Validate Statutory Return Codes 1 & 2
      *================================================================
      * Start of SAR S01117
      * CASE: DTL.Statutory Returns Code 1a is Not Blank
     C     #DSC1S        IFNE      *BLANK                                       *IF
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DSC1S        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0084            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0085           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0086            1 0          ZALIGN No Of De
     C                   PARM      4             WQ0087            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0088           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0089           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0090            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DSC1S        ZA0061                         Statutory Retur
      * Send message 'Statutory Code Invalid'
     C                   MOVEL     'USR1185'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9953      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   ELSE
      * CASE: *OTHERWISE
      * Zedit Statutory Ret Code1 - Currency Codes  *
     C*
     C* Move ZALIGN function field into Statutory Return Code 1 on
     C* the screen
     C                   MOVE      WUZASF        #DSC1S
     C*
     C                   MOVE      #DSC1S        #1SRC1                         Statutory Retur
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Statutory Returns Code 2a is Not Blank
     C     #DSC2S        IFNE      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DSC1S        ZA0062                         Statutory Retur
     C                   MOVEL     #DSC2S        ZA0063                         Statutory Retur
      * Send message 'Stat Rtn Code 2 Invalid'
     C                   MOVEL     'USR0369'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        995354    *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: DTL.Statutory Returns Code 2a is Not Blank
     C     #DSC2S        IFNE      *BLANK                                       *IF
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DSC2S        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0091            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0092           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0093            1 0          ZALIGN No Of De
     C                   PARM      4             WQ0094            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0095           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0096           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0097            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DSC2S        ZA0064                         Statutory Retur
      * Send message 'Statutory Code Invalid'
     C                   MOVEL     'USR1185'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9954      *
      *
     C                   MOVEL     'N'           WUWFG3                         Work Flag 3
     C                   ELSE
      * CASE: *OTHERWISE
      * Zedit Statutory Ret Code2 - Currency Codes  *
     C*
     C* Move ZALIGN function field into Statutory Return Code 2 on
     C* the screen
     C                   MOVE      WUZASF        #DSC2S
     C*
     C                   MOVE      #DSC2S        #1SRC2                         Statutory Retur
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of SAR S01117
      *================================================================
     CSR   USEXIT        ENDSR
      /EJECT
      *================================================================                       CER043
      * Validate Reciprocal Interest Rate Tolerence Percentage                                CER043
      *================================================================                       CER043
     C     SRRETP        BEGSR
      *                                                                                       CER043
      ** Check for numeric value                                                              CER043
      *                                                                                       CER043
     C     #DRETP        IFNE      *BLANKS
     C                   MOVEL     *BLANKS       WUZASF
     C                   MOVEL     #DRETP        WUZASF
     C                   ENDIF
      *                                                                                       CER043
     C**********           EXSR SRFMTR                                               CER043 BUG22864
     C     #DRETP        IFEQ      *BLANKS
      *                                                                                       CER043
     C     BJCYCD        IFEQ      #1CYCD
     C                   MOVEL     *BLANKS       WUZASF
     C                   MOVEL     '0'           WUZASF
     C                   ELSE
      *                                                                                       CER043
     C                   MOVEL     PSYSVL        PSVLK1
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM                    PSVLK1           20
     C                   PARM                    PSVL1           200
     C                   PARM      *BLANKS       PSVLK2           20
     C                   PARM                    PSVL2           200
     C                   PARM      *BLANKS       PSVLK3           20
     C                   PARM                    PSVL3           200
     C                   PARM      *BLANKS       PSVLK4           20
     C                   PARM                    PSVL4           200
     C                   PARM      *BLANKS       PSVLK5           20
     C                   PARM                    PSVL5           200
     C                   PARM      *BLANKS       PSVLK6           20
     C                   PARM                    PSVL6           200
     C                   PARM      *BLANKS       PSVLK7           20
     C                   PARM                    PSVL7           200
     C                   PARM      *BLANKS       PSVLK8           20
     C                   PARM                    PSVL8           200
     C                   PARM      *BLANKS       PSVLK9           20
     C                   PARM                    PSVL9           200
     C                   PARM      *BLANKS       PSVLK0           20
     C                   PARM                    PSVL0           200
      *                                                                                       CER043
     C     PRTCD         IFNE      *BLANKS
     C     PSVL1         ANDEQ     '*NRF'
     C     *LOCK         IN        LDA
     C                   MOVE      PSVLK1        DBKEY
     C                   Z-ADD     5             DBASE
     C                   MOVE      'SDSVALPD'    DBFILE
     C                   MOVE      'SD0021R'     DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *                                                                                       CER043
     C                   ELSE
      *                                                                                       CER043
     C                   MOVEL     *BLANK        WUZASF
     C                   MOVEL     PSVL1         WUZASF
     C**********           EXSR SRFMTR                                               CER043 BUG22864
      *                                                                                       CER043
     C                   ENDIF
      *                                                                                       CER043
     C                   ENDIF
     C                   ENDIF
      *                                                                                     BUG22864
     C                   EXSR      SRFMTR
      *                                                                                     BUG22864
      *================================================================                       CER043
     C                   ENDSR
      /EJECT                                                                                  CER043
      *================================================================                       CER043
      * SRFMTR - Format Reciprocal Interest Rate Tolerance                                    CER043
      *================================================================                       CER043
     C     SRFMTR        BEGSR
      *                                                                                       CER043
      ** ZALIGN Screen Field - Standard Functions  *                                          CER043
      *                                                                                       CER043
     C                   CALL      'ZALIGN'                             90
     C     W0RTN         PARM      W0RTN         WQ0324            7
     C     WUZASF        PARM      WUZASF        WQ0325           16
     C                   PARM      2             WQ0326            1 0
     C                   PARM      3             WQ0327            2 0
     C     WUZAFF        PARM      *BLANK        WQ0328           16
      *                                                                                       CER043
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG
     C                   MOVEL     'ZALIGN'      W0CLPG
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CER043
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99
     C                   ENDIF
      *                                                                                       CER043
     C     W0RTN         IFEQ      '*ERROR*'
     C                   MOVEL     'Y'           WUERCD
     C                   ELSE
     C                   MOVEL     'N'           WUERCD
     C                   CALL      'ZEDIT'                              90
     C     WUZASF        PARM      WUZASF        WQ0329           16
     C                   PARM      2             WQ0330            1 0
      *                                                                                       CER043
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG
     C                   MOVEL     'ZEDIT'       W0CLPG
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CER043
     C                   ENDIF
      *                                                                                       CER043
     C     WUERCD        IFEQ      'Y'
     C                   MOVEL     #DRETP        ZA0017
     C**********           MOVEL'USR8009' ZAMSID                                     CER043 BUG22864
     C                   MOVEL     'USR8212'     ZAMSID
     C                   EXSR      ZASNMS
     C**********           SETON                     9963                              CER043 CER059
     C                   SETON                                        9965
     C                   MOVEL     'N'           WUWFG3
     C                   MOVEL     'Y'           W0DCF
      *                                                                                       CER043
     C                   ELSE
      *                                                                                       CER043
     C                   MOVE      WUZASF        #DRETP
     C                   MOVE      WUZAFF        #1RETP
     C     #1RETP        IFGT      100
     C                   MOVEL     #DRETP        ZA0017
     C**********           MOVEL'USR8010' ZAMSID                                     CER043 BUG22864
     C                   MOVEL     'USR8213'     ZAMSID
     C                   EXSR      ZASNMS
     C**********           SETON                     9963                              CER043 CER059
     C                   SETON                                        9965
     C                   MOVEL     'N'           WUWFG3
     C                   MOVEL     'Y'           W0DCF
      *                                                                                       CER043
     C                   ELSE
      *                                                                                       CER043
     C**********           MOVE WUZASF    #DRETP                                     CER043 BUG22864
     C**********           MOVE WUZAFF    #1RETP                                     CER043 BUG22864
     C     #1RETP        IFNE      0
     C     BJCYCD        ANDEQ     #1CYCD
     C                   MOVEL     #DRETP        ZA0017
     C                   MOVEL     'USR8010'     ZAMSID
     C                   EXSR      ZASNMS
     C**********           SETON                     9963                            BUG22864 CER059
     C                   SETON                                        9965
     C                   MOVEL     'N'           WUWFG3
     C                   MOVEL     'Y'           W0DCF
      *                                                                                     BUG22864
     C                   ENDIF
      *                                                                                       CER043
     C                   ENDIF
      *                                                                                       CER043
     C                   ENDIF
      *                                                                                       CER043
      *================================================================                       CER043
     C                   ENDSR
      /EJECT                                                                                  CER043
     CSR   VACKRL        BEGSR
      *================================================================
      * Select existing record
      *================================================================
      * Name search required?
     C                   MOVEL     #1CYCD        WK1X01            1
     C     WK1X01        IFEQ      '?'                                          Currency Code
     C                   CALL      'SD0020S'                            90      Select Currency
     C                   PARM      *BLANK        W0RTN             7
     C     #1CYCD        PARM      #1CYCD        WQ0016            3            Currency Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0020S'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'Y2U0016'
     C                   SETON                                        9931      *
     C                   END
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *================================================================
     CSR   VAEXIT        ENDSR
      /EJECT
     CSR   Y0SET         BEGSR
      *================================================================
      * Set cursor by *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y0EXIT        ENDSR
      /EJECT
     CSR   Y1SET         BEGSR
      *================================================================
      * Set cursor by *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y1EXIT        ENDSR
      /EJECT
     CSR   Y8TST         BEGSR
      *================================================================
      * Test cursor
      *================================================================
     C     @#DFMT        IFEQ      '#RCDKEY'
      * KEY Screen
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
     C                   END
     C     @#DFMT        IFEQ      '#RCDDTL1'
      * DETAIL Screen
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
     C                   END
      *================================================================
     CSR   Y8EXIT        ENDSR
      /EJECT
     CSR   Y9CLR         BEGSR
      *================================================================
      * Clear *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y9EXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue
      *================================================================
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      * If no message file specified, use default
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      * Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *================================================================
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZHHPKY        BEGSR
      *================================================================
      * Display HELP text
      *================================================================
      * Signal help request
     C                   MOVEL     'Y'           W0HLP             1
      *
      * Extract cursor row and column
     C     @#RWCL        DIV       256           ZHCSRW            5 0          Row
     C                   MVR                     ZHCSCL            5 0          Column
      *
      * Save cursor position for redisplay
     C                   Z-ADD     ZHCSRW        ZZCSRW            3 0          Row
     C                   Z-ADD     ZHCSCL        ZZCSCL            3 0          Column
      *
      *
     C                   CALL      'YDDSHPR'
     C                   PARM      ##PGM         W0HPMB           10            Help text sourc
     C                   PARM      *BLANK        YYHPFL           10            Help text file
     C                   PARM      *BLANK        YYHPLB           10            Help text libra
     C                   PARM                    W0RTN             7
     C                   PARM      '*START'      YYHLVN           10            Help label
     C                   PARM      '*NORMAL'     YYUSOP           10            Options
     C                   PARM      ZHCSRW        YYRW              5 0          Row
     C                   PARM      ZHCSCL        YYCL              5 0          Column
     C                   PARM      1             YYLGCT            5 0          # of grps
     C                   PARM      W0GRP         YYLGVN           10            Label grps
      *
      * Clear set cursor DDS indicator
     C  N94              MOVEL     'OFF'         WCSRLC
     C  N94              SETON                                        94        *
      *================================================================
     CSR   ZHEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Cancel and exit from key screen
      *================================================================
      * USER: Exit program processing
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0021REPP - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021REPP
     C*
     C                   END                                                    *FI
      * CASE: KEY.*CMD key is *Exit
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * ROLLBACK any uncommitted DBF changes
     C                   ROLBK                                          90
      *                                                                                       CGP001
     C     CGP001        IFEQ      'Y'
     C**********           CLOSEGPICURL0                                              CGP001 BUG5452
     C                   CLOSE     GPCURL0
     C                   ENDIF
     C     CSD043        IFEQ      'Y'
     C                   CLOSE     SDACURL0
     C                   ENDIF
      *
      * Terminate program
     C                   SETON                                        LR
      *
      * Exit program
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation
      *================================================================
     C     *DTAARA       DEFINE                  LDA
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1            *Initial call
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   END
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
     C                   MOVEL     *ZEROS        W0RTW             9 0
     C                   MOVEL     '400'         W0ENV             3
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
      * Set century digit (If YY prior to 1940 treat as 20YY)
     C     ##JYY         IFLT      40
     C                   Z-ADD     1             ##JCC
     C                   ELSE
     C                   Z-ADD     0             ##JCC
     C                   END
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Define work field Action Work
     C                   MOVEL     *BLANK        WUACWK            1
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field No Amend Allowed
     C                   MOVEL     *BLANK        WUNOAL            7
      * Define work field S01212
     C                   MOVEL     *BLANK        WUMFTS            1
      * Define work field Final Screen
     C                   MOVEL     *BLANK        WUFNSC            1
      * Define work field Old Spot Trade A/C Equiv.
     C**********           MOVEL*BLANK    WUOSTE  4                                           CGL029
     C                   MOVEL     *BLANK        WUOSTE           10
      * Define work field Old Spot Rate
     C                   Z-ADD     *ZERO         WUOSRT           13 8
      * Define work field Old Mult/Div Indicator
     C                   MOVEL     *BLANK        WUOMDI            1
      * Define work field Display RTS field
     C                   MOVEL     *BLANK        WUDRTS            1
      * Define work field ZALIGN Screen Fun Field
     C                   MOVEL     *BLANK        WUZASF           16
      * Define work field ZALIGN File Field
     C                   MOVEL     *BLANK        WUZAFF           16
      * Define work field Err Code
     C                   MOVEL     *BLANK        WUERCD            1
      * Define work field Old Trade A/C Equiv. No.4
     C**********           MOVEL*BLANK    WUOTE4  4                                           CGL029
     C                   MOVEL     *BLANK        WUOTE4           10
      * Define work field Old Trade A/C Equiv. No.5
     C**********           MOVEL*BLANK    WUOTE5  4                                           CGL029
     C                   MOVEL     *BLANK        WUOTE5           10
      * Define work field Currency Ranking Seq. scr
     C                   MOVEL     *BLANK        WUCRSQ            3
      * Define work field Interest Risk Management
     C                   MOVEL     *BLANK        WURKMG            1
      * Define work field Dealing Currency Ind.
     C                   MOVEL     *BLANK        WUDLCI            1
      * Obtain default message file
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field Work Flag 3
     C                   MOVEL     *BLANK        WUWFG3            1
      * Define work field Error Status
     C                   MOVEL     *BLANK        WUERST            1
      * Define work field New Spot Rate
     C                   Z-ADD     *ZERO         WUNSRT           13 8
      * Define work field User Validation *RTNCDE
     C                   MOVEL     *BLANK        WUUVRC            7
      * Define work field 10% Test raw figure
     C                   Z-ADD     *ZERO         WUTTRF            7 5
      * Define work field Base CCY Limits Found?
     C                   MOVEL     *BLANK        WUBCLF            7
      * Define work field Base Currency for Limits
     C                   MOVEL     *BLANK        WUBNCD            3
      * Define work field Base Rate for Limits CCY
     C                   Z-ADD     *ZERO         WUBRLC           13 8
      * Define work field Base Limits CCY M/D Ind
     C                   MOVEL     *BLANK        WUBLCM            1
      * Define work field Base Currency
     C                   MOVEL     *BLANK        WUBCCY            3
      * Define work field Saved Spot Rate
     C                   Z-ADD     *ZERO         WUSSSR           13 8
      * Define work field Saved Multy/Divide Ind
     C                   MOVEL     *BLANK        WUSMDI            1
      * Define work field Saved Base Currency
     C                   MOVEL     *BLANK        WUSVBC            3
      * Define work field Saved Base curr for limit
     C                   MOVEL     *BLANK        WUSVBL            3
      * Define work field Saved Base limits M/D ind
     C                   MOVEL     *BLANK        WUSBLI            1
      * Define work field Exchange Rate - Limit ccy
     C                   Z-ADD     *ZERO         WUERLC           13 8
      * Define work field Test ? in Key Field
     C                   MOVEL     *BLANK        WUTQKF            1
      * Define work field Default Accounts 4 + 5
     C                   MOVEL     *BLANK        WUDA45            1
      * Define work field Account type
     C                   MOVEL     *BLANK        WUACTY            1
      * Define work field Title Only Indicator
     C                   MOVEL     *BLANK        WUTOIN            1
      * Define work field SAR S01433
     C                   MOVEL     *BLANK        WUSARF            1
      * Define work field Portfolio Management
     C                   MOVEL     *BLANK        WUPFMG            1
      * Define work field *Return code
     C                   MOVEL     *BLANK        WURTN             7
      * Define work field Dealing: FX
     C                   MOVEL     *BLANK        WUDLFX            1
      * Define work field Work Flag 1
     C                   MOVEL     *BLANK        WUWFG1            1
      * Define work field Continue Loop
     C                   MOVEL     *BLANK        WUCNLP            1
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field Window processing requir.
     C                   MOVEL     *BLANK        WUWDPR            1
      * Define work field No. of Records
     C                   Z-ADD     *ZERO         WUNORC            5 0
      * Define work field No. of Inserts
     C                   Z-ADD     *ZERO         WUNOIN            5 0
      * Define work field No. of Deletes
     C                   Z-ADD     *ZERO         WUNODL            5 0
      * Define work field No. of Amends
     C                   Z-ADD     *ZERO         WUNOAM            5 0
      * Define work field Securities
     C                   MOVEL     *BLANK        WUSECS            1
      * Define work field Funds Transfer
     C                   MOVEL     *BLANK        WUFDTR            1
      * Define work field Midas/Swift direct link
     C                   MOVEL     *BLANK        WUMSDL            1
      * Define work field Call RTS Program
     C                   MOVEL     *BLANK        WUCRTP            1
      * Define work field Delete Flag
     C                   MOVEL     *BLANK        WUDELF            1
      * Define work field Main Currency Edit Ind.
     C                   MOVEL     *BLANK        WUMCEI            7
      * Define work field Deleted Data Record Pt1
     C                   MOVEL     *BLANK        WUDR01          250
      * Define work field Deleted Data Record Pt2
     C                   MOVEL     *BLANK        WUDR02          250
      * Define work field Deleted Data Record Pt3
     C                   MOVEL     *BLANK        WUDR03          250
      * Define work field Deleted Data Record Pt4
     C                   MOVEL     *BLANK        WUDR04          250
      * Define work field Deleted Data Record Pt5
     C                   MOVEL     *BLANK        WUDR05          250
      * Define work field Deleted Data Record Pt6
     C                   MOVEL     *BLANK        WUDR06          250
      * Define work field Deleted Data Record Pt7
     C                   MOVEL     *BLANK        WUDR07          250
      * Define work field Deleted Data Record Pt8
     C                   MOVEL     *BLANK        WUDR08          250
      * Define work field Deleted Data Record Pt9
     C                   MOVEL     *BLANK        WUDR09          250
      * Define work field Deleted Data Record Pt10
     C                   MOVEL     *BLANK        WUDR00          250
      * Define work field Deleted Data Record Pt11
     C                   MOVEL     *BLANK        WUDR11          250
      * Define work field Deleted Data Record Pt12
     C                   MOVEL     *BLANK        WUDR12          250
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Define work field Midas/Telex Module Ind.
     C                   MOVEL     *BLANK        WUMTMI            1
      * Define work field SWIFT Funds Transfer
     C                   MOVEL     *BLANK        WUSWFT            1
      * Define work field SWIFT Securities Trading
     C                   MOVEL     *BLANK        WUSWST            1
      * Define work field SWIFT Customer Lending
     C                   MOVEL     *BLANK        WUSWCL            1
      * Define work field SWIFT Synd Loans (REDUN)
     C                   MOVEL     *BLANK        WUSWSL            1
      * Define work field SWIFT Statements
     C                   MOVEL     *BLANK        WUSWSM            1
      * Define work field SWIFT Dealing
     C                   MOVEL     *BLANK        WUSWDL            1
      * Define work field Standing data/Gen.Ledger
     C                   MOVEL     *BLANK        WUSDGL            1
      * Define work field Syndicated Loans (REDUN)
     C                   MOVEL     *BLANK        WUSYLN            1
      * Define work field Exposure Management
     C                   MOVEL     *BLANK        WUEXMG            1
      * Define work field Financial Modeller
     C                   MOVEL     *BLANK        WUFNMO            1
      * Define work field Statutory Returns
     C                   MOVEL     *BLANK        WUSTRT            1
      * Define work field Customer Lending
     C                   MOVEL     *BLANK        WUCSLN            1
      * Define work field Retail Banking
     C                   MOVEL     *BLANK        WURTBN            1
      * Define work field Auto-reconciliations
     C                   MOVEL     *BLANK        WUAURC            1
      * Define work field Bond Dealers Interface
     C                   MOVEL     *BLANK        WUBDLI            1
      * Define work field DRS Standing Data
     C                   MOVEL     *BLANK        WUDRSD            1
      * Define work field DRS Control module
     C                   MOVEL     *BLANK        WUDRCM            1
      * Define work field DRS Foreign Exchange
     C                   MOVEL     *BLANK        WUDRFE            1
      * Define work field DRS Money Market
     C                   MOVEL     *BLANK        WUDRMM            1
      * Define work field DRS Arbitrage
     C                   MOVEL     *BLANK        WUDRAR            1
      * Define work field DRS Common Applications
     C                   MOVEL     *BLANK        WUDRCA            1
      * Define work field Futures & Options
     C                   MOVEL     *BLANK        WUFUOP            1
      * Define work field Midas/Telex Synd. Loans
     C                   MOVEL     *BLANK        WUMTSL            1
      * Define work field Midas/Telex Dealing
     C                   MOVEL     *BLANK        WUMTDL            1
      * Define work field Midas/Telex Gen. Ledger
     C                   MOVEL     *BLANK        WUMTGL            1
      * Define work field Midas/Telex Cust. Lending
     C                   MOVEL     *BLANK        WUMTCL            1
      * Define work field Message Management
     C                   MOVEL     *BLANK        WUNWMI            1
      * Define work field FRA/IRS Indicator
     C                   MOVEL     *BLANK        WUFIIN            1
      * Define work field Dealing: MM
     C                   MOVEL     *BLANK        WUDLMM            1
      * Define work field Internal Contracts
     C                   MOVEL     *BLANK        WUINCN            1
      * Define work field Treasury Management
     C                   MOVEL     *BLANK        WUTRMG            1
      * Define work field Testkey
     C                   MOVEL     *BLANK        WUTSKY            1
      * Define work field Midas/Q
     C                   MOVEL     *BLANK        WUMIDQ            1
      * Define work field Microfiche
     C                   MOVEL     *BLANK        WUMFIC            1
      * Define work field Interest on accounts
     C                   MOVEL     *BLANK        WUIOAC            1
      * Define work field SAR's processing required
     C                   MOVEL     *BLANK        WUSARP            1
      * Define work field French return indicator
     C                   MOVEL     *BLANK        WUFRIN            1
      * Define work field Lux return indicator
     C                   MOVEL     *BLANK        WULRIN            1
      * Define work field Dutch return indicator
     C                   MOVEL     *BLANK        WUDRIN            1
      * Define work field German return indicator
     C                   MOVEL     *BLANK        WUGRIN            1
      * Define work field Belgian return indicator
     C                   MOVEL     *BLANK        WUBRIN            1
      * Define work field Italian return indicator
     C                   MOVEL     *BLANK        WUIRIN            1
      * Define work field Swift External Interface
     C                   MOVEL     *BLANK        WUSWEI            1
      * Define work field Credit Management.
     C                   MOVEL     *BLANK        WUCRMG            1
      * Define work field Head Office Reporting
     C                   MOVEL     *BLANK        WUHORP            1
      * Define work field Average Balances
     C                   MOVEL     *BLANK        WUAVBL            1
      * Define work field Margins
     C                   MOVEL     *BLANK        WUMARG            1
      * Define work field Confirmation Matching
     C                   MOVEL     *BLANK        WUCFMT            1
      * Define work field Mimix
     C                   MOVEL     *BLANK        WUMIMX            1
      * Define work field Report Control Facility
     C                   MOVEL     *BLANK        WURCFI            1
      * Define work field Amps Int
     C                   MOVEL     *BLANK        WUAMIN            1
      * Define work field Swiss Returns
     C                   MOVEL     *BLANK        WUSWRT            1
      * Define work field Fiduciary Loans & Deposit
     C                   MOVEL     *BLANK        WUFLND            1
      * Define work field Portfolio Lending
     C                   MOVEL     *BLANK        WULMCR            1
      * Define work field Cantonal Tax
     C                   MOVEL     *BLANK        WUCNTX            1
      * Define work field Stamp Duty
     C                   MOVEL     *BLANK        WUSTDU            1
      * Define work field Use DRS Shortnames
     C                   MOVEL     *BLANK        WUUDRS            1
      * Define work field Chips Dealing
     C                   MOVEL     *BLANK        WUCHDL            1
      * Define work field Chips Lending
     C                   MOVEL     *BLANK        WUCHLN            1
      * Define work field Chips Opening Balance
     C                   MOVEL     *BLANK        WUCHOB            1
      * Define work field CHIPS
     C                   MOVEL     *BLANK        WUCHIP            1
      * Define work field Chips Direct Link
     C                   MOVEL     *BLANK        WUCHDI            1
      * Define work field Optical Disk
     C                   MOVEL     *BLANK        WUOPDK            1
      * Define work field Leo Data Nucleus
     C                   MOVEL     *BLANK        WUNNST            1
      * Define work field Leo Letters of Credit
     C                   MOVEL     *BLANK        WUNOST            1
      * Define work field Leo Collections
     C                   MOVEL     *BLANK        WUNPST            1
      * Define work field Leo Bills/Financing
     C                   MOVEL     *BLANK        WUNQST            1
      * Define work field Leo Bankers Acceptances
     C                   MOVEL     *BLANK        WUNRST            1
      * Define work field Leo Reimbursements
     C                   MOVEL     *BLANK        WUNSST            1
      * Define work field Taxes
     C                   MOVEL     *BLANK        WUNTST            1
      * Define work field History & Audit Facility
     C                   MOVEL     *BLANK        WUNUST            1
      * Define work field Management Accounts
     C                   MOVEL     *BLANK        WUNVST            1
      * Define work field IBLC Returns
     C                   MOVEL     *BLANK        WUNWST            1
      * Define work field Retail 3
     C                   MOVEL     *BLANK        WUNXST            1
      * Define work field Interest on Accounts 3
     C                   MOVEL     *BLANK        WUNYST            1
      * Define work field Midas Export Data Module
     C                   MOVEL     *BLANK        WUNZST            1
      * Define work field Analytical Accounting
     C                   MOVEL     *BLANK        WUN0ST            1
      * Define work field User Defined Correspondnc
     C                   MOVEL     *BLANK        WUN1ST            1
      * Define work field Midas-Plato Interface
     C                   MOVEL     *BLANK        WUN2ST            1
      * Define work field Midas-Trade Innovation If
     C                   MOVEL     *BLANK        WUN3ST            1
      * Define work field Private Banking Module                          CPB001
     C                   MOVEL     *BLANK        WUN4ST            1                           CPB00
      * Define work field Reserved for Later Use 42
     C                   MOVEL     *BLANK        WUN5ST            1
      * Define work field Reserved for Later Use 43
     C                   MOVEL     *BLANK        WUN6ST            1
      * Define work field Reserved for Later Use 44
     C                   MOVEL     *BLANK        WUN7ST            1
      * Define work field Reserved for Later Use 45
     C                   MOVEL     *BLANK        WUN8ST            1
      * Define work field Reserved for Later Use 46
     C                   MOVEL     *BLANK        WUN9ST            1
      * Define work field Reserved for Later Use 47
     C                   MOVEL     *BLANK        WUOAST            1
      * Define work field Reserved for Later Use 48
     C                   MOVEL     *BLANK        WUOBST            1
      * Define work field Reserved for Later Use 49
     C                   MOVEL     *BLANK        WUOCST            1
      * Define work field Reserved for Later Use 50
     C                   MOVEL     *BLANK        WUODST            1
      * Define work field Reserved for Later Use 51
     C                   MOVEL     *BLANK        WUOEST            1
      * Define work field Reserved for Later Use 52
     C                   MOVEL     *BLANK        WUOFST            1
      * Define work field Reserved for Later Use 53
     C                   MOVEL     *BLANK        WUOGST            1
      * Define work field Reserved for Later Use 54
     C                   MOVEL     *BLANK        WUOHST            1
      * Define work field Reserved for Later Use 55
     C                   MOVEL     *BLANK        WUOIST            1
      * Define work field Reserved for Later Use 56
     C                   MOVEL     *BLANK        WUOJST            1
      * Define work field Reserved for Later Use 57
     C                   MOVEL     *BLANK        WUOKST            1
      * Define work field Reserved for Later Use 58
     C                   MOVEL     *BLANK        WUOLST            1
      * Define work field Reserved for Later Use 59
     C                   MOVEL     *BLANK        WUOMST            1
      * Define work field Reserved for Later Use 60
     C                   MOVEL     *BLANK        WUONST            1
      * Define work field Reserved for Later Use 61
     C                   MOVEL     *BLANK        WUOOST            1
      * Define work field Reserved for Later Use 62
     C                   MOVEL     *BLANK        WUOPST            1
      * Define work field Reserved for Later Use 63
     C                   MOVEL     *BLANK        WUOQST            1
      * Define work field Reserved for Later Use 64
     C                   MOVEL     *BLANK        WUORST            1
      * Define work field Reserved for Later Use 65
     C                   MOVEL     *BLANK        WUOSST            1
      * Define work field SAR number field
     C                   MOVEL     *BLANK        WUSARN            6
      * Define work field Access Pgm Return Code
     C                   MOVEL     *BLANK        WUAPRC            7
      * Define work field Access obj dummy DS (76)
     C                   MOVEL     *BLANK        WUFDY            76
      * Define work field Switchable feature CRT001
     C                   MOVEL     *BLANK        WURTSS            1
      * Define work field Switchable feature CRT002
     C                   MOVEL     *BLANK        WUCRT2            1
      * Define work field Switchable feature CRT003
     C                   MOVEL     *BLANK        WUCRT3            1
      * Define work field CRT001, CRT002 or CRT003
     C                   MOVEL     *BLANK        WURT13            1
      * Flag no *SET CURSOR in the program
     C                   MOVE      'N'           YSETCS            1
     C                   MOVE      *BLANK        WCSRLC            3
      * Temp Action Code if action is 'X' and Type of Last Change is 'D'                    BUG11875
     C                   MOVE      *BLANK        PXANCD            1
     C                   MOVEL     *BLANKS       PGANCD
      * Open files
      * Begin commit control
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
      * Define *Synon program work fields
     C                   MOVEL     *BLANKS       W0CFL            10            *Cursor field
     C                   Z-ADD     *ZEROS        W0CRW             5 0          *Cursor row
     C                   Z-ADD     *ZEROS        W0CCL             5 0          *Cursor column
      * Move main file information to JOB context
     C                   MOVE      @1FFL         ZZFFL            10            Main file name
     C                   MOVE      @1FLB         ZZFLB            10            Main file lib
     C                   MOVE      @1FMB         ZZFMB            10            Main file mbr
     C                   MOVE      ZZFFL         @1FFL            10
     C                   MOVE      ZZFLB         @1FLB            10
     C                   MOVE      ZZFMB         @1FMB            10
     C                   CALL      'Y2QLVNR'
     C                   PARM                    ZZFFL            10
     C                   PARM                    ZZFLB            10
     C                   PARM                    ZZFQL            21            LIBRARY/FILE
     C                   OPEN      SD0021R#
      *                                                                                       CSD031
      * Check if CSD043 is switched on                                                        CSD031
      *                                                                                       CSD031
     C                   CALL      'AOSARDR0'
     C                   PARM                    PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CSD043'      PSARD             6
      *                                                                                       CSD031
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSD043            1
     C                   MOVE      *ON           *IN63
     C                   ELSE
     C                   MOVE      'N'           CSD043
     C                   MOVE      *OFF          *IN63
     C                   ENDIF
      *                                                                                       CSD031
     C     PACCPT        IFEQ      'A'
     C                   MOVE      *ON           *IN66
     C                   ENDIF
     C     CSD043        IFEQ      'Y'
     C     PACCPT        IFEQ      'A'
     C                   OPEN      SDACURL0
     C                   MOVE      'Y'           CUROPN            1
     C                   ENDIF
     C                   ENDIF
     C                   OPEN      SDCURRL1
     C                   OPEN      SDACODL1
     C                   OPEN      SDMMODL1
     C                   OPEN      SDBANKL1
     C                   OPEN      SDDEALL1
     C                   OPEN      SDCURRL0
     C                   OPEN      SDCURRL7                                                    17923
     C                   OPEN      SDFCTLL0
     C                   MOVEL     'N'           W0PMT             1
     C*****************************************************************   E21685
      * Select initial mode
     C     @1NROP        IFEQ      *ZERO
      * Add mode
     C                   MOVEL     'ADD'         W0PMD             3
     C                   ELSE
      *                                                                                       CSD031
     C     CSD043        IFEQ      'Y'
     C     P2ANCD        ANDEQ     'X'
     C                   MOVEL     'ACC'         W0PMD
     C     P1PARM        CHAIN     SDCURRD0                           90
     C     *IN90         IFEQ      '0'
     C     A6TYLC        ANDEQ     'D'
     C                   MOVEL     'CHG'         W0PMD
     C                   MOVEL     P2ANCD        PXANCD
     C                   MOVEL     'D'           P2ANCD
     C                   ENDIF
     C                   ELSE
      * Change mode
     C                   MOVEL     'CHG'         W0PMD
     C                   ENDIF
     C                   END
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * Start of S01459
      * Remove the creation parameters and last amend box functions.
      * SD0021R precompiler - Currency Codes  *
      * End of S01459
      * Copyright Statement 1988 - Standard Functions  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      *                                                                   CDL008
     C     WUDFF         IFEQ      'M'                                                         CDL00
     C                   MOVE      *ON           *IN98                                         CDL00
     C                   ELSE                                                                  CDL00
     C                   MOVE      *OFF          *IN98                                         CDL00
     C                   ENDIF                                                                 CDL00
      *                                                                   CDL008
      * Start of SAR S01117
      * Start of Fix LN1072
      * Add RM to the modules retrieved
      * Start of S01486
      * Retrieve all Midas modules.
      * Replace 'Get Dealing Inds fore CCY' by 'Get all Midas Modules'
      * Get all Midas Modules - MIDAS Modules  *
     C                   EXSR      TFRVGN
      * End of S01486
      * End of Fix LN1072
      * End of SAR S01117
      * Program mode.
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
     C                   MOVEL     'ADD'         W0PMD                          *Program mode
     C                   ELSE
      * CASE: *OTHERWISE
     C     CSD043        IFEQ      'Y'
     C     P2ANCD        ANDEQ     'X'
     C                   MOVEL     'ACC'         W0PMD
     C     P1PARM        CHAIN     SDCURRD0                           90
     C     *IN90         IFEQ      '0'
     C     A6TYLC        ANDEQ     'D'
     C                   MOVEL     'CHG'         W0PMD
     C                   MOVEL     P2ANCD        PXANCD
     C                   MOVEL     'D'           P2ANCD
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     'CHG'         W0PMD                          *Program mode
     C                   ENDIF
     C                   END                                                    *FI
     C                   MOVEL     'I'           WUACWK                         Action Work
      * Delete processing.
      * CASE: PAR.Action Code is Delete
     C     P2ANCD        IFEQ      'D'                                          *IF
     C                   MOVEL     'E'           WUACWK                         Action Work
     C                   MOVE      *ON           *IN67
     C                   END                                                    *FI
      * Start of change S01433.
     C                   MOVEL     'S01433'      WUSARN                         SAR number fiel
      * SAR switched on check - Standard Functions  *
     C                   CALL      'AOSARDR0'                           90      SAR switched on
     C     WUAPRC        PARM      WUAPRC        WQ0304            7            Access Pgm Retu
     C                   PARM      '*VERIFY'     WQ0305            7            Option for ACCO
     C     WUSARN        PARM      WUSARN        WQ0306            6            SAR number fiel
     C                   PARM      WUFDY         WQ0307           76            Access obj dumm
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'AOSARDR0'    W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Check return code.
      * CASE: WRK.Access Pgm Return Code is *Normal
     C     WUAPRC        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'Y'           WUSARF                         SAR S01433
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUSARF                         SAR S01433
     C                   END                                                    *FI
      * End of change S01433.
      *                                                                   CSD006
      ** Check whether market data feed is installed                      CSD006
     C                   MOVEL     'N'           CSD006            1                           CSD00
     C                   MOVEL     'CSD006'      WUSARN                                        CSD00
     C                   CALL      'AOSARDR0'                           90                     CSD00
     C     WUAPRC        PARM      WUAPRC        WQ0316                                        CSD00
     C                   PARM      '*VERIFY'     WQ0317                                        CSD00
     C     WUSARN        PARM      WUSARN        WQ0318                                        CSD00
     C                   PARM      WUFDY         WQ0319                                        CSD00
      *                                                                   CSD006
     C     *IN90         IFEQ      '1'                                                         CSD00
      * Call to program ended in error                                    CSD006
     C                   MOVEL     'Y2U0032'     W0RTN                                         CSD00
     C                   MOVEL     *BLANKS       W0CLPG           10                           CSD00
     C                   MOVEL     'AOSARDR0'    W0CLPG                                        CSD00
     C                   MOVEL     'Y2U0032'     ZAMSID                                        CSD00
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        CSD00
     C                   MOVEL     W0CLPG        ZAMSDA                                        CSD00
     C                   EXSR      ZASNMS                                                      CSD00
     C                   ENDIF                                                                 CSD00
      *                                                                   CSD006
     C     WUAPRC        IFEQ      *BLANK                                                      CSD00
     C                   MOVEL     'Y'           CSD006                                        CSD00
     C                   ELSE                                                                  CSD00
     C                   MOVEL     'N'           CSD006                                        CSD00
     C                   ENDIF                                                                 CSD00
      *                                                                   CSD006
      ** Check whether CAP057 is switched on                              CAP057
      *                                                                   CAP057
     C                   MOVEL     'N'           CAP057            1                           CAP05
     C                   MOVEL     'CAP057'      WUSARN                                        CAP05
     C                   CALL      'AOSARDR0'                           90                     CAP05
     C     WUAPRC        PARM      WUAPRC        WQ0316                                        CAP05
     C                   PARM      '*VERIFY'     WQ0317                                        CAP05
     C     WUSARN        PARM      WUSARN        WQ0318                                        CAP05
     C                   PARM      WUFDY         WQ0319                                        CAP05
      *                                                                   CAP057
     C     *IN90         IFEQ      '1'                                                         CAP05
      * Call to program ended in error                                    CAP057
     C                   MOVEL     'Y2U0032'     W0RTN                                         CAP05
     C                   MOVEL     *BLANKS       W0CLPG           10                           CAP05
     C                   MOVEL     'AOSARDR0'    W0CLPG                                        CAP05
     C                   MOVEL     'Y2U0032'     ZAMSID                                        CAP05
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        CAP05
     C                   MOVEL     W0CLPG        ZAMSDA                                        CAP05
     C                   EXSR      ZASNMS                                                      CAP05
     C                   ENDIF                                                                 CAP05
      *                                                                   CAP057
     C     WUAPRC        IFEQ      *BLANK                                                      CAP05
     C                   MOVEL     'Y'           CAP057                                        CAP05
     C                   ELSE                                                                  CAP05
     C                   MOVEL     'N'           CAP057                                        CAP05
     C                   ENDIF                                                                 CAP05
      *                                                                   CAP057
      ** Check whether CAP058 is switched on                              CAP058
      *                                                                   CAP058
     C                   MOVEL     'N'           CAP058            1                           CAP05
     C                   MOVEL     'CAP058'      WUSARN                                        CAP05
     C                   CALL      'AOSARDR0'                           90                     CAP05
     C     WUAPRC        PARM      WUAPRC        WQ0316                                        CAP05
     C                   PARM      '*VERIFY'     WQ0317                                        CAP05
     C     WUSARN        PARM      WUSARN        WQ0318                                        CAP05
     C                   PARM      WUFDY         WQ0319                                        CAP05
      *                                                                   CAP058
     C     *IN90         IFEQ      '1'                                                         CAP05
      * Call to program ended in error                                    CAP058
     C                   MOVEL     'Y2U0032'     W0RTN                                         CAP05
     C                   MOVEL     *BLANKS       W0CLPG           10                           CAP05
     C                   MOVEL     'AOSARDR0'    W0CLPG                                        CAP05
     C                   MOVEL     'Y2U0032'     ZAMSID                                        CAP05
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        CAP05
     C                   MOVEL     W0CLPG        ZAMSDA                                        CAP05
     C                   EXSR      ZASNMS                                                      CAP05
     C                   ENDIF                                                                 CAP05
      *                                                                   CAP058
     C     WUAPRC        IFEQ      *BLANK                                                      CAP05
     C                   MOVEL     'Y'           CAP058                                        CAP05
     C                   ELSE                                                                  CAP05
     C                   MOVEL     'N'           CAP058                                        CAP05
     C                   ENDIF                                                                 CAP05
      *                                                                   CAP058
      ** Check whether CAP059 is switched on                              CAP059
      *                                                                   CAP059
     C                   MOVEL     'N'           CAP059            1                           CAP05
     C                   MOVEL     'CAP059'      WUSARN                                        CAP05
     C                   CALL      'AOSARDR0'                           90                     CAP05
     C     WUAPRC        PARM      WUAPRC        WQ0316                                        CAP05
     C                   PARM      '*VERIFY'     WQ0317                                        CAP05
     C     WUSARN        PARM      WUSARN        WQ0318                                        CAP05
     C                   PARM      WUFDY         WQ0319                                        CAP05
      *                                                                   CAP059
     C     *IN90         IFEQ      '1'                                                         CAP05
      * Call to program ended in error                                    CAP059
     C                   MOVEL     'Y2U0032'     W0RTN                                         CAP05
     C                   MOVEL     *BLANKS       W0CLPG           10                           CAP05
     C                   MOVEL     'AOSARDR0'    W0CLPG                                        CAP05
     C                   MOVEL     'Y2U0032'     ZAMSID                                        CAP05
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        CAP05
     C                   MOVEL     W0CLPG        ZAMSDA                                        CAP05
     C                   EXSR      ZASNMS                                                      CAP05
     C                   ENDIF                                                                 CAP05
      *                                                                   CAP059
     C     WUAPRC        IFEQ      *BLANK                                                      CAP05
     C                   MOVEL     'Y'           CAP059                                        CAP05
     C                   ELSE                                                                  CAP05
     C                   MOVEL     'N'           CAP059                                        CAP05
     C                   ENDIF                                                                 CAP05
      *                                                                   CAP059
      ** Check whether CTI006 is switched on                                                  CTI006
      *                                                                                       CTI006
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CTI006'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CTI006
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CTI006            1
     C                   ELSE
     C                   MOVE      'N'           CTI006
     C                   ENDIF
      *                                                                                       CTI006
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD0021R'     DBPGM
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CTI006'      DBKEY
     C                   Z-ADD     006           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CTI006
      * 00/Copy member SD0021RC05 - Currency Codes  *
     C/COPY WNCPYSRC,SD0021RC05
      * Currency DTL footer - Standard Functions  *
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C* If request delete screen when not last in sequence                S01117
     C     WUACWK        IFEQ      'E'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F8=Further Details   F10=Delete   F12=Previous
     C                   MOVEL     'USR3356'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*                                                                   S01117
     C*                                                                   S01117
     C* If request delete screen that is last in sequence                 S01117
     C     WUACWK        IFEQ      'F'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F10=Delete   F12=Previous
     C                   MOVEL     'USR3350'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*                                                                   S01117
     C*                                                                   S01117
     C* If request is not delete                                          S01117
     C     WUACWK        IFEQ      'I'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F12=Previous
     C                   MOVEL     'USR3346'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
      * Check for Final Screen
      *                                                                   CPB001
      * CASE: WRK.Market Data Feed                                        CSD006
     C     CSD006        IFEQ      'Y'                                          *IF            CSD00
     C                   MOVEL     'M'           WUFNSC                         Final Screen   CSD00
     C                   ELSE                                                                  CSD00
      * CASE: WRK.Private Banking Module is ON                            CPB001
     C     WUN4ST        IFEQ      'Y'                                          *IF            CPB00
     C                   MOVEL     'P'           WUFNSC                         Final Screen   CPB00
     C                   ELSE                                                                  CPB00
      * CASE: WRK.Midas/Swift direct link is Yes
     C     WUMSDL        IFEQ      'Y'                                          *IF
     C                   MOVEL     'W'           WUFNSC                         Final Screen
     C                   ELSE
      * CASE: WRK.Funds Transfer is Yes
     C     WUFDTR        IFEQ      'Y'                                          *IF
     C                   MOVEL     'F'           WUFNSC                         Final Screen
     C                   ELSE
      * CASE: WRK.Securities is Yes
     C     WUSECS        IFEQ      'Y'                                          *IF
     C                   MOVEL     'S'           WUFNSC                         Final Screen
      * Start of SAR S01117
     C                   ELSE
      * CASE: WRK.Dealing: MM is Yes
     C     WUDLMM        IFEQ      'Y'                                          *IF
     C                   MOVEL     'D'           WUFNSC                         Final Screen
     C                   ELSE
      * CASE: WRK.Dealing: FX is Yes
     C     WUDLFX        IFEQ      'Y'                                          *IF
     C                   MOVEL     'D'           WUFNSC                         Final Screen
      * End of SAR S01117
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'T'           WUFNSC                         Final Screen
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *                                                                   CPB001
     C                   END                                                                   CPB00
     C                   END                                                                   CSD00
      * Get Base Currency - Bank Details  *
     C                   EXSR      TGRVGN
      * Get Base CCY for Limits - Dealing Data  *
     C                   EXSR      THRVGN
     C                   MOVEL     '**YES**'     WUMCEI                         Main Currency E
     C                   MOVEL     '*AMEND*'     WUNOAL                         No Amend Allowe
      * Start of change CRT001.
     C                   MOVEL     'N'           WURTSS                         Switchable feat
     C                   MOVEL     'CRT001'      WUSARN                         SAR number fiel
      * SAR switched on check - Standard Functions  *
     C                   CALL      'AOSARDR0'                           90      SAR switched on
     C     WUAPRC        PARM      WUAPRC        WQ0308            7            Access Pgm Retu
     C                   PARM      '*VERIFY'     WQ0309            7            Option for ACCO
     C     WUSARN        PARM      WUSARN        WQ0310            6            SAR number fiel
     C                   PARM      WUFDY         WQ0311           76            Access obj dumm
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'AOSARDR0'    W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Does the switchable feature CRT001 exist ?
      * CASE: WRK.Access Pgm Return Code is *Normal
     C     WUAPRC        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'Y'           WURTSS                         Switchable feat
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WURTSS                         Switchable feat
     C                   END                                                    *FI
     C                   MOVEL     'N'           WUCRT2                         Switchable feat
     C                   MOVEL     'CRT002'      WUSARN                         SAR number fiel
      * SAR switched on check - Standard Functions  *
     C                   CALL      'AOSARDR0'                           90      SAR switched on
     C     WUAPRC        PARM      WUAPRC        WQ0312            7            Access Pgm Retu
     C                   PARM      '*VERIFY'     WQ0313            7            Option for ACCO
     C     WUSARN        PARM      WUSARN        WQ0314            6            SAR number fiel
     C                   PARM      WUFDY         WQ0315           76            Access obj dumm
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'AOSARDR0'    W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Does the switchable feature CRT002 exist ?
      * CASE: WRK.Access Pgm Return Code is *Normal
     C     WUAPRC        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'Y'           WUCRT2                         Switchable feat
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUCRT2                         Switchable feat
     C                   END                                                    *FI
      * Start CRT003
     C                   MOVEL     'N'           WUCRT3                         Switchable feat
     C                   MOVEL     'CRT003'      WUSARN                         SAR number fiel
      * SAR switched on check - Standard Functions  *
     C                   CALL      'AOSARDR0'                           90      SAR switched on
     C     WUAPRC        PARM      WUAPRC        WQ0316            7            Access Pgm Retu
     C                   PARM      '*VERIFY'     WQ0317            7            Option for ACCO
     C     WUSARN        PARM      WUSARN        WQ0318            6            SAR number fiel
     C                   PARM      WUFDY         WQ0319           76            Access obj dumm
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'AOSARDR0'    W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Does the switchable feature CRT003 exist ?
      * CASE: WRK.Access Pgm Return Code is *Normal
     C     WUAPRC        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'Y'           WUCRT3                         Switchable feat
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUCRT3                         Switchable feat
     C                   END                                                    *FI
      * End CRT003
     C                   MOVEL     'N'           WUDRTS                         Display RTS fie
      * Start CRT003
      * CRT003: Conditioning amended so appearence of Numeric ISO Ccy dep
      *         on CRT003 only not CRT002 or CRT001.
      * CASE:
      *  - c1 AND c3 AND c4
      *   |- c1    : WRK.Switchable feature CRT003 is Present
      *   |- c3    : WRK.Retail Banking is Yes
      *   |- c4    : WRK.Retail 3 is Yes
      *   '-
     C                   MOVEL     '0'           Y0CX01            1
     C     WUCRT3        IFEQ      'Y'                                          *IF
     C     WURTBN        IFEQ      'Y'                                          *IF
     C     WUNXST        IFEQ      'Y'                                          *IF
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C/COPY WNCPYSRC,SD0021RC19
     C     Y0CX01        IFEQ      '1'                                          *IF
     C     WUN3ST        OREQ      'Y'
     C     CTI006        OREQ      'Y'
     C********** WUCRT2    OREQ 'Y'                                                  CTI006 MD030956
     C                   MOVEL     'Y'           WUDRTS                         Display RTS fie
     C                   END                                                    *FI
      * End CRT003
     C                   MOVEL     'N'           WUCRTP                         Call RTS Progra
      * Start CRT003
     C                   MOVEL     'N'           WURT13                         CRT001, CRT002
      * CASE:
      *  - c1 OR c2 OR c3
      *   |- c1    : WRK.Switchable feature CRT001 is Present
      *   |- c2    : WRK.Switchable feature CRT002 is Present
      *   |- c3    : WRK.Switchable feature CRT003 is Present
      *   '-
     C     WURTSS        IFEQ      'Y'                                          *IF
     C     WUCRT2        OREQ      'Y'                                          *OR
     C     WUCRT3        OREQ      'Y'                                          *OR
     C                   MOVEL     'Y'           WURT13                         CRT001, CRT002
     C                   END                                                    *FI
      * CRT003: Amend conditioning to include CRT002 & CRT003
      * CASE:
      *  - c1 AND c2 AND c3
      *   |- c1    : WRK.CRT001, CRT002 or CRT003 is Present
      *   |- c2    : WRK.Retail Banking is Yes
      *   |- c3    : WRK.Retail 3 is Yes
      *   '-
     C                   MOVEL     '0'           Y0CX01            1
     C     WURT13        IFEQ      'Y'                                          *IF
     C     WURTBN        IFEQ      'Y'                                          *IF
     C     WUNXST        IFEQ      'Y'                                          *IF
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C/COPY WNCPYSRC,SD0021RC09
     C     Y0CX01        IFEQ      '1'                                          *IF
     C                   MOVEL     'Y'           WUCRTP                         Call RTS Progra
     C                   END                                                    *FI
      * End CRT003
      * End of change CRT001.
     C                   MOVEL     'Y'           WUMFTS                         S01212
      * Windows and /Copys.
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * Get 'Window required' ind - MIDAS Modules  *
     C                   EXSR      TIRVGN
      * Currency Data Structure - Currency Codes  *
      * 00/Copy member SD0021RFPG - Currency Codes  *
      * 00/Copy member SD0021RIPG - Currency Codes  *
      * 00/Copy member SD0021REPG - Currency Codes  *
      * 00/Copy member SD0021RCPG - Currency Codes  *
     C*
     C/COPY WNCPYSRC,SD0021RCPG
     C*
      * 00/Copy member SD0021ROPG - Currency Codes  *
     C                   END                                                    *FI
      * Start CEU002                                                      CEU002
     C                   MOVEL     'N'           CEU002            1            Switchable featCEU00
     C                   MOVEL     'CEU002'      WUSARN                         SAR no. field  CEU00
      * SAR switched on check - Standard Functions  *                     CEU002
     C                   CALL      'AOSARDR0'                           90      SAR switched onCEU00
     C     WUAPRC        PARM      WUAPRC        WQ0316                         Access Pgm RetuCEU00
     C                   PARM      '*VERIFY'     WQ0317                         Option for ACCOCEU00
     C     WUSARN        PARM      WUSARN        WQ0318                         SAR no. field  CEU00
     C                   PARM      WUFDY         WQ0319                         Access obj dummCEU00
      *                                                                   CEU002
     C     *IN90         IFEQ      '1'                                                         CEU00
      * Call to program ended in error                                    CEU002
     C                   MOVEL     'Y2U0032'     W0RTN                                         CEU00
     C                   MOVEL     *BLANKS       W0CLPG           10                           CEU00
     C                   MOVEL     'AOSARDR0'    W0CLPG                                        CEU00
      * Send message '*Error occured on CALL...'                          CEU002
     C                   MOVEL     'Y2U0032'     ZAMSID                                        CEU00
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        CEU00
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data   CEU00
     C                   EXSR      ZASNMS                                                      CEU00
     C                   END                                                                   CEU00
      *                                                                   CEU002
      * Does the switchable feature CEU002 exist ?                        CEU002
      * CASE: WRK.Access Pgm Return Code is *Normal                       CEU002
     C     WUAPRC        IFEQ      *BLANK                                       *IF            CEU00
     C                   MOVEL     'Y'           CEU002                         Switchable ON  CEU00
     C                   ELSE                                                                  CEU00
      * CASE: *OTHERWISE                                                  CEU002
     C                   MOVEL     'N'           CEU002                         Switchable OFF CEU00
     C                   END                                                    *FI            CEU00
      * End CEU002                                                        CEU002
      *                                                                   CDL008
      * Check if CDL008 is installed                                      CDL008
      *                                                                   CDL008
     C                   MOVEL     'CDL008'      WUSARN                                        CDL00
     C                   MOVEL     *BLANK        WUAPRC                                        CDL00
     C                   CALL      'AOSARDR0'                           90                     CDL00
     C     WUAPRC        PARM      WUAPRC        WQ0316                                        CDL00
     C                   PARM      '*VERIFY'     WQ0317                                        CDL00
     C     WUSARN        PARM      WUSARN        WQ0318                                        CDL00
     C                   PARM      WUFDY         WQ0319                                        CDL00
      *                                                                   CDL008
     C     *IN90         IFEQ      *ON                                                         CDL00
     C                   MOVEL     'Y2U0032'     W0RTN                                         CDL00
     C                   MOVEL     *BLANKS       W0CLPG                                        CDL00
     C                   MOVEL     'AOSARDR0'    W0CLPG                                        CDL00
     C                   MOVEL     'Y2U0032'     ZAMSID                                        CDL00
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        CDL00
     C                   MOVEL     W0CLPG        ZAMSDA                                        CDL00
     C                   EXSR      ZASNMS                                                      CDL00
     C                   ENDIF                                                                 CDL00
      *                                                                   CDL008
     C     WUAPRC        IFEQ      *BLANKS                                                     CDL00
     C                   MOVEL     'Y'           CDL008            1                           CDL00
     C                   MOVE      *OFF          *IN80                                         CDL00
     C                   ELSE                                                                  CDL00
     C                   MOVEL     'N'           CDL008                                        CDL00
     C                   MOVE      *ON           *IN80                                         CDL00
     C                   ENDIF                                                                 CDL00
      *                                                                   CDL008
      ** Access SAR details file to determine if CIR007                                       CIR007
      ** (Overnight Index Swaps) is switched on.                                              CIR007
      *                                                                                       CIR007
     C                   MOVEL     'N'           CIR007
     C                   MOVEL     'CIR007'      WUSARN
     C                   MOVEL     *BLANK        WUAPRC
     C                   CALL      'AOSARDR0'                           90
     C                   PARM      WUAPRC        PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      WUSARN        PSARD             6
     C     *IN90         IFEQ      *ON
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG
     C                   MOVEL     'AOSARDR0'    W0CLPG
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CIR007            1
     C                   MOVE      *OFF          *IN81
     C                   ELSE
     C                   MOVEL     'N'           CIR007
     C                   MOVE      *ON           *IN81
     C                   ENDIF
      *                                                                                       CIR007
      * Define keylist for SDAULGL0                                                           CSD012
     C     KAULG         KLIST
     C**********           KFLD           K1CYCD 20                                    CSD012 CGL029
     C                   KFLD                    K1CYCD           26
      *                                                                                       CSD012
      * Check if CSD012 is switched on                                                        CSD012
     C                   CALL      'AOSARDR0'
     C                   PARM                    PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CSD012'      PSARD             6
      *                                                                                       CSD012
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSD012            1
     C                   ELSE
     C                   MOVE      'N'           CSD012
     C                   ENDIF
      *                                                                                       CSD012
      * Check if Currencies Authorisation is on                                               CSD012
     C     CSD012        IFEQ      'Y'
      *                                                                                       CSD012
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       RTNCDE            7
     C                   PARM                    SVALK1           20
     C                   PARM                    SVAL1           200
     C                   PARM                    SVALK2           20
     C                   PARM                    SVAL2           200
     C                   PARM                    SVALK3           20
     C                   PARM                    SVAL3           200
     C                   PARM                    SVALK4           20
     C                   PARM                    SVAL4           200
     C                   PARM                    SVALK5           20
     C                   PARM                    SVAL5           200
     C                   PARM                    SVALK6           20
     C                   PARM                    SVAL6           200
     C                   PARM                    SVALK7           20
     C                   PARM                    SVAL7           200
     C                   PARM                    SVALK8           20
     C                   PARM                    SVAL8           200
     C                   PARM                    SVALK9           20
     C                   PARM                    SVAL9           200
     C                   PARM                    SVALK0           20
     C                   PARM                    SVAL10          200
      *                                                                                       CSD012
     C     RTNCDE        IFNE      *BLANKS
     C     SVAL10        IFEQ      '*NRF'
     C                   MOVE      SVALK0        DBKEY
     C                   ENDIF
     C     SVAL9         IFEQ      '*NRF'
     C                   MOVE      SVALK9        DBKEY
     C                   ENDIF
     C     SVAL8         IFEQ      '*NRF'
     C                   MOVE      SVALK8        DBKEY
     C                   ENDIF
     C     SVAL7         IFEQ      '*NRF'
     C                   MOVE      SVALK7        DBKEY
     C                   ENDIF
     C     SVAL6         IFEQ      '*NRF'
     C                   MOVE      SVALK6        DBKEY
     C                   ENDIF
     C     SVAL5         IFEQ      '*NRF'
     C                   MOVE      SVALK5        DBKEY
     C                   ENDIF
     C     SVAL4         IFEQ      '*NRF'
     C                   MOVE      SVALK4        DBKEY
     C                   ENDIF
     C     SVAL3         IFEQ      '*NRF'
     C                   MOVE      SVALK3        DBKEY
     C                   ENDIF
     C     SVAL2         IFEQ      '*NRF'
     C                   MOVE      SVALK2        DBKEY
     C                   ENDIF
     C     SVAL1         IFEQ      '*NRF'
     C                   MOVE      SVALK1        DBKEY
     C                   ENDIF
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   MOVE      'SDSVALPD'    DBFILE
     C                   MOVE      'SD0021R'     DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSD012
     C                   ENDIF
      *                                                                                       CSD012
      ** Access SAR details file to determine if CGP001                                       CGP001
      ** (Global Processing) is switched on.                                                  CGP001
      *                                                                                       CGP001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGP001'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CGP001
     C                   MOVE      'N'           CGP001            1
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGP001
      *                                                                                       CGP001
      ** Open the Global ISO Currency Codes File.                                             CGP001
      *                                                                                       CGP001
     C                   EXSR      SRGPOF
     C                   ELSE
      *                                                                                       CGP001
     C     PRTCD         IFNE      '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CGP001'      DBKEY
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDIF
      *                                                                                       CGP001
     C                   MOVE      'N'           CGL014            1
      *                                                                                       CGL014
      ** Access SAR details to see if CGL014 is switched on                                   CGL014
      *                                                                                       CGL014
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGL014'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CGL014
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CGL014'      DBKEY
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CGL014
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGL014
     C                   ENDIF
      *                                                                                       CGL014
     C                   MOVE      'N'           CLE025            1
      *                                                                                       CLE025
      ** Access SAR details to see if CLE025 is switched on                                   CLE025
      *                                                                                       CLE025
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE025'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE025
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CLE025'      DBKEY
     C                   Z-ADD     3             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CLE025
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE025
     C                   ENDIF
      *                                                                                       CLE025
     C                   MOVE      *OFF          *IN71
      *                                                                                       CGL014
     C     CGL014        IFEQ      'Y'
     C     WUN4ST        OREQ      'Y'
     C     CLE025        OREQ      'Y'
     C                   MOVE      *ON           *IN71
     C                   ENDIF
      *                                                                                       CGL014
      ** Access SAR details to see if ULX043 is switched on.                                  CER001
      *                                                                                       CER001
     C                   MOVE      'N'           ULX043            1
      *                                                                                       CER001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'ULX043'      PSARD
     C     SCSARD        PARM      *BLANKS       DSFDY
      *                                                                                       CER001
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           ULX043
     C                   ELSE
      *                                                                                       CER001
     C     PRTCD         IFNE      '*NRF   '
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG
     C                   MOVEL     'AOSARDR0'    W0CLPG
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CER001
     C                   ENDIF
      *                                                                                       CER001
     C                   MOVEL     *BLANKS       RTCODE            1
     C                   MOVEL     *BLANKS       ACTION            1
      *                                                                                       CER001
      ** Call AOSARDR0 to check if CER043 is switched on                                      CER043
      *                                                                                       CER043
     C                   MOVE      'N'           CER043            1
      *                                                                                       CER043
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CER043'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CER043
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CER043
     C                   ELSE
     C                   MOVEL     'N'           CER043
     C                   ENDIF
      *                                                                                       CER043
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'CER043'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     4             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CER043
     C     CER043        IFEQ      'N'
     C                   MOVE      *ON           *IN64
     C                   ELSE
     C                   MOVE      *OFF          *IN64
     C                   ENDIF
      *                                                                                       CER043
      ** Access SAR details to see if CRE026 is switched on.                                  CRE026
      *                                                                                       CRE026
     C                   MOVE      'N'           CRE026            1
      *                                                                                       CRE026
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CRE026'      PSARD
     C     SCSARD        PARM      *BLANKS       DSFDY
      *                                                                                       CRE026
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CRE026
     C                   ELSE
      *                                                                                       CRE026
     C     PRTCD         IFNE      '*NRF   '
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG
     C                   MOVEL     'AOSARDR0'    W0CLPG
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CRE026
     C                   ENDIF
      *                                                                                       CRE026
     C     CRE026        IFEQ      'Y'
     C                   MOVE      'Y'           WUDRTS
     C                   OPEN      SDCURRLF
     C                   ENDIF
      *                                                                                       CRE026
      ** OBTAIN BANK DETAILS
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *                                                                                     BUG11870
      ** DB error if not found                                                              BUG11870
     C     PRTCD         IFNE      *BLANK
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     004           DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SD0021R'     DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSW212
      ** Check if SWIFT Changes 2012 is switched on                                           CSW212
      *                                                                                       CSW212
     C                   CALL      'SWIF2012'
     C                   PARM      *BLANKS       PRTCD
      *                                                                                       CSW212
     C     PRTCD         IFEQ      'CSW2012'
     C                   MOVE      'Y'           CSW212            1
     C                   ELSE
     C                   MOVE      'N'           CSW212
     C                   ENDIF
      *                                                                                       CSW212
      ** Check if CMG003 is installed                                                         CMG003
      *                                                                                       CMG003
     C                   MOVEL     'N'           CMG003            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CMG003'      PSARD
     C     SCSARD        PARM      *BLANKS       DSFDY
      *                                                                                       CMG003
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CMG003'      DBKEY
     C                   Z-ADD     4             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CMG003
     C     PRTCD         IFEQ      *BLANKS
     C     CSW212        ANDEQ     'Y'
     C                   MOVE      'Y'           CMG003
     C                   ENDIF
     C/COPY WNCPYSRC,EML110_008                                                               EML110
      *                                                                                     MD025467
      ** This is a dummy condition for compilation purpose                                  MD025467
      *                                                                                     MD025467
     C     *IN01         IFEQ      *ON
     C     *IN01         ANDEQ     *OFF
     C                   READ      SDFCTLA0                               01
     C                   ENDIF
      *                                                                                       CMG003
     C/COPY WNCPYSRC,SD0021RC21
      *================================================================
     CSR   ZZEXIT        ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRGPOF - Opens the Global ISO Currency Codes File.           *                       CGP001
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRGPOF        BEGSR
      *                                                                                       CGP001
     C                   Z-ADD     80            PLEN             15 5
     C                   MOVE      OVRC(1)       PCMD             80
      *                                                                                       CGP001
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCMD
     C                   PARM                    PLEN
      *                                                                                       CGP001
     C**********           OPEN GPICURL0                                              CGP001 BUG5452
     C                   OPEN      GPCURL0
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                       CMG003
      /EJECT                                                                                  CMG003
      *****************************************************************                       CMG003
      *                                                               *                       CMG003
      *  SRDEL - Delete record from Commodity main file               *                       CMG003
      *          Write record from Commodity Shadow file for deletion *                       CMG003
      *                                                               *                       CMG003
      *****************************************************************                       CMG003
     C     SRDEL         BEGSR
      *                                                                                       CMG003
     C     CMG003        IFEQ      'Y'
     C     #1CRDL        ANDEQ     'Y'
     C     PHRC          CHAIN     SDCMDTL1                           90
     C     *IN90         IFEQ      '0'
     C                   MOVEL     'D'           PGANCD
     C     CSD012        IFEQ      'Y'
     C     SVAL11        ANDEQ     'Y'
     C                   MOVEL     'D'           A6CMLT
     C                   WRITE     SDCMSHD0
     C                   ELSE
     C     *IN90         IFEQ      '0'
     C                   DELETE    SDCMDTD0                             91
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *****************************************************************                       CMG003
      /EJECT                                                                                  CMG003
      *****************************************************************                       CGP001
     C/COPY WNCPYSRC,SD0021RC08
      /EJECT
      *****************************************************************                       CSD031
      *                                                               *                       CSD031
      *  SRDAT2 - Convert Day Number to Screen Format Date            *                       CSD031
      *                                                               *                       CSD031
      *****************************************************************                       CSD031
      *                                                                                       CSD031
     C     SRDAT2        BEGSR
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE            7
      *                                                                                       CSD031
     C                   ENDSR
      /EJECT                                                                                  CSD031
     CSR   *PSSR         BEGSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
      * Core function specific processing.
      *
     C/COPY WNCPYSRC,SD0021RPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0021RPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*SDCPYSRC,SDPSSRINT                                                              MD058085
     C/COPY SDCPYSRC,SDPSSRINTI                                                             MD058085
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0021RPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
     C*COPY*ZSRSRC,ZDATE1Z2                                                CDL008           MD058085
     C/COPY ZSRSRC,ZDATE1Z2LE                                                               MD058085
     C*COPY*ZSRSRC,ZDATE2Z2                                                CDL008           MD058085
     C/COPY ZSRSRC,ZDATE2Z2LE                                                               MD058085
     C*COPY*ZSRSRC,ZALIGNZ2                                                CDL008           MD058085
     C/COPY ZSRSRC,ZALIGNZ2LE                                                               MD058085
     O*
     O/COPY WNCPYSRC,SD0021ROPG
     O*
**
ABCDEFGHIJKLMNOPQRSTUVWXYZ
** CPY@     : Copyright notice for inclusion in all programs
(c) Finastra International Limited 2001
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
** OVRC                                                                                       CGP001
OVRDBF FILE(GPCURL0) TOFILE(GPCURRL0)                                                        BUG5452
     X/COPY WNCPYSRC,SD0021RX01
