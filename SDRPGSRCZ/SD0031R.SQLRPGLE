     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*OVR *  OVRDBF FILE(GPACDXL0) TOFILE(GPACODXL0)                      *                       CGP001
/*OVR *  OVRDBF FILE(GPPRDXL0) TOFILE(GPPRODXL0)                      *                      BUG2312
/*OVR *  OVRDBF FILE(GPINSXL0) TOFILE(GPINSTXL0)                      *                      BUG2312
/**** *  RPGBASE                                                      *                     MD058085
/*STD *  RPGSQLBND                                                    *                     MD058085
/*EXI *  TEXT('Midas SD Account codes maintenance')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0031R - Account Codes Maintenance                          *
      *                                                               *
      *  Function:  This program maintains account codes records.     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD062338           Date 19Mar24               *
      *  Prev Amend No. MD061007           Date 31Dec21               *
      *                 MD058188           Date 11May21               *
      *                 MD058085           Date 11May21               *
      *                 AR672002           Date 11Jan22               *
      *                 CSD103             Date 10Aug20               *
      *                 MD039031           Date 22May20               *
      *                 MD055821           Date 12May20               *
      *                 MD046248           Date 27Oct17               *
      *                 MD037807           Date 25Mar16               *
      *                 CGL165             Date 23Feb15               *
      *                 MD030956           Date 09Oct14               *
      *                 MD028343           Date 10Jul14               *
      *                 CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CRE015             Date 18Dec09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG18743           Date 12May08               *
      *                 BUG17212           Date 25Mar08               *
      *                 247957             Date 24May07               *
      *                 245932             Date 13Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12391           Date 16Nov02               *
      *                 CDL013             Date 10Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CGL052             Date 03Feb06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG6613            Date 14Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 BG9199             Date 10Nov05               *
      *                 CGL037             Date 29Apr05               *
      *                 BUG6180            Date 11Mar05               *
      *                 BUG6309            Date 18Mar05               *
      *                 CAS010             Date 09Feb05               *
      *                 CPB004             Date 11Jul02               *
      *                 BUG3525            Date 25Aug04               *
      *                 BUG3032            Date 17Jun04               *
      *                 BUG3078            Date 08Jun04               *
      *                 BUG2951            Date 26May04               *
      *                 CTI004             Date 12Apr04               *
      *                 BUG2637            Date 27May04               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG2847            Date 21May04               *
      *                 BUG2695            Date 19May04               *
      *                 BUG2312            Date 05May04               *
      *                 BG2012             Date 21Apr04               *
      *                 TCA105             Date 01Apr04               *
      *                 CGP001             Date 23May03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 210207             Date 30Oct02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 199078             Date 30Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 185171             Date 20Dec00               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CGL010             Date 08Nov99               *
      *                 CPB001             Date 18Oct99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSD005             Date 02MAR99               *
      *                 CFT002             Date 18Nov98               *   CFT002
      *                 CTI002             DATE 20AUG98               *
      *                 CSD003             Date 27OCT97               *
      *                 122096             DATE 22AUG97               *
      *                 CTI001             DATE 25JUL97               *
      *                 CRE002             DATE 03FEB97               *
      *                 104645             DATE 05NOV96               *
      *                 091322             DATE 11JUL96               *
      *                 CAC001             DATE 06FEB96               *
      *                 S01522             DATE 10OCT94               *
      *                 S01486             DATE 29JUN94               *
      *                 063606             DATE 02FEB94               *
      *                 S01461             DATE 14JAN94               *
      *                 S01459             DATE 14JAN94               *
      *                 S01437             DATE 16SEP93               *  *
      *                 057868             DATE 08JUL93               *
      *                 S01413             DATE 28JUN93               *
      *                 042930             DATE 20AUG92               *
      *                 E23836             DATE 11SEP91               *
      *                 E24400             DATE 06SEP91               *
      *                 S01309             DATE 30JAN91               *
      *                 S01267             DATE 29JAN91               *
      *                 LN0947             DATE 24JAN91               *
      *                 E21390             DATE 27NOV90               *
      *                 E21267             DATE 27NOV90               *
      *                 S01117             DATE 08JUN90               *
      *                 S01212             DATE                       *
      *                 S01216             DATE                       *
      *                 E19592             DATE                       *
      *                 E19016             DATE                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD062338 - Authority issue when accessing UDC details from   *
      *             Standing Data Account Codes Maintenance Enquiry   *
      *  MD061007 - Deliverable Data Split for SDFCTLPA and GPFCTLPA  *
      *  MD058188 - Deliverable Data Split for Global files           *
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  AR672002 - Account Section Maintenance.                      *
      *             Reapply the fixes of 263398B and 263398.          *
      *             - Make sure that indicator 70 is properly set-on  *
      *             when action code is 'I'.                          *
      *             - Apply fix of 243107. Protect Account Section    *
      *             field during amend mode.                          *
      *             (Child: AR672004)                                 *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD039031 - A5TOIN and A5ACTY fields used by CGL010 contain   *
      *             different values due to incorrect DS used.        *
      *             AOACODR0 should use SDACODPD format for parameter.*
      *             Also, restrict entry of nostro and retail account *
      *             codes in Transitory account codes.                *
      *             Applied fix for MD055359.                         *
      *  MD055821 - Protect tax fields when CGL165 is ON (Recompile)  *
      *  MD046248 - Finastra Rebranding                               *
      *  MD037807 - Default Vostro and Lostro fields (CFT002) to 'N'. *
      *  CGL165 - Dual Withholding Tax                                *
      *  MD030956 - Additional changes to BFM-TI enhancement          *
      *  MD028343 - Incorrect label of Trade Finance Exposure Account *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CRE015 - Retail Term and Notice Accounts                     *
      *  BUG18743 - Account Code Mapping Error                        *
      *           - Applied fix BUG18507                              *
      *  BUG18507 - Unsuccessful CM Configuration set-up              *
      *  BUG17212 - No input field for global account code.           *
      *             Recompiled due to changes in SD0031R#.            *
      *  247957  - Issue only warning message if the Private Banking  *
      *            is OFF.                                            *
      *  245932 - Midas SD Account Codes Maintenance SD0031R# Display *
      *           File (Recompile)                                    *
      *  BUG12391 - Fields that are non amendable on initial display  *
      *             becomes editable on succeeding displays.          *
      *             (Recompile)                                       *
      *  CDL013 - Tiered Withholding Tax                              *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *  CGL052 - Upgrade LBV058 to Midas Plus.                       *
      *           Amend Washout Processing                            *
      *           Recompile over changes in SD0030GDTA                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG6613 - Change 'PM Instrument Code' to 'Instrument Type'   *
      *            (Recompile)                                        *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  BG9199 - Recompiled due to changes in SD0031R#               *
      *  CGL037 - Account Access Security                             *
      *  BUG6180 - Error in account codes maintenance screen          *
      *            (Recompile)                                        *
      *  BUG6309 - To resolve numeric field error                     *
      *  CAS010 - IAS + PB Enhancements Upgrade to Midasplus          *
      *  CPB004 - Add 'To be transferred to TOF' flag to be           *
      *           maintained for each account code.                   *
      *  BUG3525 - *IN46 in CGP001 clashed with screen error handling *
      *            Use *IN66 instead.                                 *
      *  BUG3032 - Amend program to ensure correct validation for     *
      *            message USR4176.                                   *
      *  BUG3078 - Field #1INNR is not displayed                      *
      *  BUG2951 - Partially applied BUG2637.                         *
      *  CTI004 - MidasPlus-TI Integration Enchancements              *
      *           Account Codes Integration                           *
      *  BUG2637 - Global Account code no longer mandatory.           *
      *  CLE025 - Credit Lines                                        *
      *  BUG2847 - If global instrument code or product code is blank,*
      *            records on GPINSTXPD and GPPRODXPD must not be     *
      *            present.                                           *
      *  BUG2695 - TABTE10 and TABTE20 should no longer be used on    *
      *            a 10-digit Account Code system. Programs should    *
      *            use SDACODPD instead.                              *
      *  BUG2312 - Global product code and global instrument code     *
      *          - are being written to incorrect file. These fields  *
      *          - are being added to end of record in GPACODXPD.     *
      *          - Global product code --> GPPRODXPD (new record)     *
      *          - Global instrument code --> GPPRODXPD (new record)  *
      *  BG2012 - No database error if record not on GPACODXPD        *
      *  TCA105 - No database error if record not on GPACODXPD        *
      *  CGP001 - Global Processing                                   *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  210207 - Change CHAIN fail indicator for ACCNTAB from *IN70  *
      *           to *IN80, as the first is already used by CGL010.   *
      *           Modification to 199078/185171.                      *
      *  199078 - 185171 only works for 'A'. Need to always set on    *
      *           *IN70 if action is 'I'.                             *
      *  185171 - Prevent change of Account type or Sub-type if a/cs  *
      *           for the code exists, and always with SSF on.  Also  *
      *           do not allow deletion of Account Code when still    *
      *           attached to live accounts.                          *
      *           Applied fixes 180233 and 180014.
      *  CGL010 - Future Value Dated Journal Entries for              *
      *           Non-Retail Accounts.                                *
      *  CPB001 - 'Private Banking' Module                            *
      *  CSD005 - Addition of Standing Data Account Narrative field   *
      *           on condition of switchable feature CSD005           *
      *  CFT002 - Straight Through Processing Phase 1                 *   CFT002
      *           - Include Vostro & Loro Account Flags               *   CFT002
      *  CTI002 - Trade innovation :                                  *
      *           - New Field  Trade Finance Contingent Account.      *
      *  CSD003 - Synon Closedown Project (SD):                       *
      *           - Program removed from SD model.                    *
      *  122096 - Addition of call to SD0520X to save deleted         *
      *           records for audit during COB.                       *
      *  CTI001 - Midas-Trade Innovation Interface:                   *
      *           - Addition of 'TI Account Type' field.              *
      *  CRE002 - Retail Accruals Processing Enhancement.             *
      *  104645 - Instrument Code must be entered for Bank PM a/c.    *
      *  091322 - IN and EX account codes must not be retail.         *
      *  CAC001 - Profit Centre Accounting - additional fields:       *
      *            Management Accnts Analysis By Profit Centre;       *
      *            Management Accnts Analysis By Book;                *
      *            Management Accnts Analysis By Assoc. Customer;     *
      *            Management Accnts Analysis By Product.             *
      *  S01522 - User Defined Correspondence development.            *
      *  S01486 - Private Banking:                                    *
      *           Addition of 'Portfolio Management Instrument Code'. *
      *  063606 - 'Minimum withholding tax' should have the same      *
      *           number of decimal places as base currency.          *
      *           The withholding tax fields should be conditioned    *
      *           on 'Retail 3 + Taxes ', not only on Taxes.          *
      *  S01461 - The Midas Export module processing was removed      *
      *           and moved to the Eureka platform.                   *
      *  S01459 - Addition of headerbox and PSSR processing.          *
      *  S01437 - Add 'Midas Export Account Code' field               *
      *           to the screen.                                      *
      *  057868 - Title only accounts should not be allowed to be     *
      *           entered for accrual/capitalisation A/C codes.       *
      *  S01413 - Retail 3 incorporation:- Withholding Tax Details    *
      *           available.                                          *
      *  042930 - When '?' entered in "Title only Indicator" field,   *
      *           details applicable to the "Customer Originated      *
      *           Indicator" field were displayed.                    *
      *           In Amend Mode the program did not accept Blank in   *
      *           "Title only indicator', however it did in Insert    *
      *           Mode, and wrote the record to file with 'Title Only *
      *           Indicator' blank.                                   *
      *           Program has been amended to accept blank and update *
      *           the file with 'N' in 'title Only Indicator' field.  *
      *  E23836 - Change 'Debt' to 'Debit' on screen for 'Interest'   *
      *           Accrual A/c Code'                                   *
      *  E24400 - Change description of Acct Post Retention on        *
      *           screen to 'Posting Retention Period'                *
      *  S01309 - GL Reporting Enhancements.                          *
      *  S01267 - MIS Changes.                                        *
      *  LN0947 - REGENERATE DUE TO CHANGE IN SDACODPD                *
      *  E21390 - RETAIL ACCOUNT ONLY IF RE OR IA IS ON (LN1020)      *
      *  E21267 - PREVENT ACCOUNT CODE OF 'R' IF RETAIL IS OFF(LN1020)*
      *  S01117 - Release 10 Changes                                  *
      *  S01212 - WINDOW PROCESSING & /COPY                           *
      *  S01216 - RELEASE 1 ENHANCEMENTS                              *
      *  E19592 - CREDIT & DEBIT FIELDS HAVE BEEN RE-ARRANGED ON      *
      *           SCREEN SUCH THAT ALL DR FIELDS APPEAR BEFORE ALL    *
      *           CR FIELDS.                                          *
      *  E19016 - F10=DELETE NOT BEING DISPLAYED IN DELETE MODE       *
      *                                                               *
      *****************************************************************
     F/COPY WNCPYSRC,SD0031RFPG
     FSD0031R#  CF   E             WORKSTN USROPN
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD Account codes maintenance
      *
     FSDACODL1  IF   E           K DISK    USROPN
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Account codes retrieval
      *
     FSDACOAL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     COMMIT
      *                                                                                       CDL013
      * Account code ext. file update/add under commitment control.                           CDL013
      *                                                                                       CDL013
     FSDACOAL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(SDACODDA:SDACODYY)
      * Account code ext. file input.                                                         CDL013
      *                                                                                       CDL013
     FSDACD1L0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     COMMIT
      *                                                                                       CRE015
      ** Account Codes - T&N Accounts                                                         CRE015
      *                                                                                       CRE015
     FSDGELRL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0001)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD General ledger ICD details retrieval
      *
     F*SDTIACL1* IF   E           K DISK    USROPN                                          MD058085
     F**********                           INFDS(ID0002)                                    MD058085
     F**********                           INFSR(*PSSR)                                     MD058085
      * RTV : Midas SD Trade innovation account types retrieval
      *
     FSDACRCL4  IF   E           K DISK    USROPN
     F                                     INFDS(ID0003)
     F                                     INFSR(*PSSR)
      * RSQ : Midas SD Accounts by report codes by a/c code
      *
     FSDMMODL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0004)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Midas module flags retrieval
      *
     FSDBANKL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0005)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Bank details ICD retrieval
      *
     FSDCURRL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0006)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Currency codes retrieval
      *
     FSDPORTL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0007)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Portfolio management ICD retrieval
      *
     FACACOD    UF A E           K DISK    INFSR(*PSSR)                         CPB004
     F                                     USROPN
      * ACCOUNT DETAILS KEYED BY ACCOUNT CODE                             CPB004
      *                                                                   CPB004
     F                                     RENAME(ACCNTABF:ACCNTABG)            CPB004
      *                                                                   CPB004
     FSDACODL0  UF A E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFDS(ID0008)
     F                                     INFSR(*PSSR)
      * UPD : Midas SD Account codes update
      *
     FSDACODL9  IF   E           K DISK
     F                                     INFSR(*PSSR)
      *                                                                                       CTI004
     F*SDFCTLL0* UF   E           K DISK    USROPN                                          MD061007
     F**********                           COMMIT                                           MD061007
     F**********                           INFDS(ID0009)                                    MD061007
     F**********                           INFSR(*PSSR)                                     MD061007
      * UPD : Midas SD Standing data controls update
      *
     FGPPRDXL0  UF A E           K DISK    USROPN                                                  B
     F                                     INFSR(*PSSR)                                            B
     F                                     RENAME(GPPRODXD0:GPPRDXD0)                              B
     F                                     COMMIT                                                  B
      ** Midas GP Global Products X-Reference                                                BUG2312
      *                                                                                      BUG2312
     FGPINSXL0  UF A E           K DISK    USROPN                                                  B
     F                                     INFSR(*PSSR)                                            B
     F                                     RENAME(GPINSTXD0:GPINSXD0)                              B
     F                                     COMMIT                                                  B
      ** Midas GP Global Instruments X-Reference                                             BUG2312
      *                                                                                      BUG2312
     FSDACRCL0  UF A E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFDS(ID0010)
     F                                     INFSR(*PSSR)
     FGLVALPL3  IF   E           K DISK    INFSR(*PSSR)                         CGL010
      ** Midas GL Future Valued Postings by Account Code                  CGL010
      *                                                                   CGL010
     FAUACNTV1  IF   E           K DISK                                         185171
     F                                     INFDS(ID0011)                        185171
     F                                     INFSR(*PSSR)                         185171
      * UPD : Midas SD Accounts by report codes update
      *
     FGPACDXL0  UF A E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     F                                     RENAME(GPACODXD0:GPACDXD0)
     F                                     COMMIT
      ** Midas GP Global Account Codes X-Reference                                            CGP001
      *                                                                                       CGP001
     FSDAACDL0  UF   E           K DISK    USROPN
     F                                     RENAME(SDACODD0:SDACDD0R)
     F                                     INFSR(*PSSR)
      ** Midas GP Global Account Codes Acceptance                                             CSD031
      *                                                                                       CSD031
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D/COPY WNCPYSRC,SD0031REPG
     D**********          OVRC    1   1 80                                            CGP001 BUG2312
     D OVRC            S             80    DIM(3) CTDATA PERRCD(1)
     D DATALX          DS          1024
     D  #2ACCD                 1     10
     D  #1RTRN                11     17
     D  #1TOIN                18     18
     D  #1ACTY                19     19
     D/COPY WNCPYSRC,SD0031RIPG
      /EJECT
      * Data structures:
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
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D LDA             DS           256
      ** Local data area for database error details                                           CGP001
      *                                                                                       CGP001
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D @1DBRC        E DS                  EXTNAME(SDACODL0)
      * UPD : Midas SD Account codes update
      * Current/previous master file format fields for change control
      *                                                                                       CDL013
     D @1DBRX        E DS                  EXTNAME(SDACOAL0)
      * Before update record image file format                                                CDL013
      *                                                                                       CDL013
     D #1DBRX          DS            30
      * Stored data structure                                                                 CDL013
      *
     D*****#1DBRC      DS                            140                  CTI002
     D*****#1DBRC      DS                            141            CTI002CFT002
     D*****#1DBRC      DS                            143            CFT002CSD005
     D***#1DBRC**      DS                            193           CSD005 CGL010
     D***#1DBRC*     DS                            201                                 CGL010 CGL029
     D***#1DBRC**      DS                            371                               CGL029 CPB004
     D #1DBRC          DS           372
      * Stored master file format fields
     D  #1DB1                  1      1
     D/COPY WNCPYSRC,SD0031RI02
     D***WWACOD*     DS                            201                                 CGL010 CGL029
     D WWACOD          DS           371
      ** Master file format fields - copy                                 CGL010
     D**********                            194 197 WWTRDA                             CGL010 CGL029
     D**********                            198 201 WWTRCA                             CGL010 CGL029
     D  WWTRDA               352    361
     D  WWTRCA               362    371
      *
     D/COPY QWINDSRC,SD0030GDTL                                           S01229            MD058085
     D UUSDY         E DS                  EXTNAME(DSSDY)
     D*
     D* 800 byte DS for incoming data from Access Program
     D*
      *-------------------------------------------------------------------CFT002
     D DSFDY         E DS                  EXTNAME(DSFDY)                       CFT002
      * DS for Access Programs, short data structure.                     CFT002
      *-------------------------------------------------------------------CFT002
     D DSSARD        E DS                  EXTNAME(SCSARDPD)                    CFT002
      * Definition: Switchable Features Accessed Via Access Program.      CFT002
      *-------------------------------------------------------------------CFT002
     D GPACOD        E DS                  EXTNAME(GPACODPD)
     D  ACGLCD       E                     EXTFLD(ACLCD)
     D  ACGCHT       E                     EXTFLD(ACCHTP)
      ** Global Product Code Details Data Structure                                           CGP001
      *                                                                                       CGP001
     D GPPROD        E DS                  EXTNAME(GPPRODPD)
     D  PDGLCD       E                     EXTFLD(PDLCD)
     D  PDGCHT       E                     EXTFLD(PDCHTP)
      ** Global Product Code Details Data Structure                                           CGP001
      *                                                                                       CGP001
     D*GPINST***     E DS                  EXTNAME(GPINSTPD)                                MD058188
     D GPINST        E DS                  EXTNAME(GPINSJW0)                                MD058188
      ** Global Instrument Code Details Data Structure                                        CGP001
      *                                                                                       CGP001
     D SDRETD        E DS                  EXTNAME(SDRETRPD)
      *                                                                                       CRE015
      ** Midas Retail Transaction Types Data Structure                                        CRE015
      *                                                                                       CRE015
     D SDNARR        E DS                  EXTNAME(SDNARRPD)
      *                                                                                       CRE015
      ** Midas Narrative Codes Data Structure                                                 CRE015
      *                                                                                       CRE015
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
      *                                                                                       CRE015
      ** Midas Profit Centres Data Structure                                                  CRE015
      *                                                                                       CRE015
     D SDTIAC        E DS                  EXTNAME(SDTIAJW0)                                MD058085
     D D@PLIN        E DS                  EXTNAME(SDPLINPD)
     D*
     D* DS TO HOLD DATA READ FROM FILE TO BE USED WITHIN THE PROGRAM
     D*
     D*QSDFC1***     E DS                  EXTNAME(SDFCTLL0)                                MD061007
     D QSDFC1          DS                                                                   MD061007
     D  AHFLNM                 1     10                                                     MD061007
     D  AHNORC                11     13P 0                                                  MD061007
     D  AHNOIN                14     16P 0                                                  MD061007
     D  AHNOAM                17     19P 0                                                  MD061007
     D  AHNODL                20     22P 0                                                  MD061007
      * UPD : Midas SD Standing data controls update
     D YARDCS          DS            22
     D YBRDCS          DS            22
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
     D PARC            DS          3064
      * RCD : Midas SD Deleted records file retrieval
      * I :  File name
     D  PAFNME                 1     10
      * I :  Long Key
     D  PALKEY                11     60
      * I :  Deleted Data Record Pt1
     D  PADR01                61    310
      * I :  Deleted Data Record Pt2
     D  PADR02               311    560
      * I :  Deleted Data Record Pt3
     D  PADR03               561    810
      * I :  Deleted Data Record Pt4
     D  PADR04               811   1060
      * I :  Deleted Data Record Pt5
     D  PADR05              1061   1310
      * I :  Deleted Data Record Pt6
     D  PADR06              1311   1560
      * I :  Deleted Data Record Pt7
     D  PADR07              1561   1810
      * I :  Deleted Data Record Pt8
     D  PADR08              1811   2060
      * I :  Deleted Data Record Pt9
     D  PADR09              2061   2310
      * I :  Deleted Data Record Pt10
     D  PADR00              2311   2560
      * I :  Deleted Data Record Pt11
     D  PADR11              2561   2810
      * I :  Deleted Data Record Pt12
     D  PADR12              2811   3060
      * I :  Last Change Date
     D  PALCD               3061   3063P 0
      * I :  Type of Last Change
     D  PATYLC              3064   3064
      *
     D YCRDCS          DS            22
     D YDRDCS          DS            22
     D***YERDCS*     DS                            140                                        CGL029
     D YERDCS          DS           371
     D YFRDCS          DS            22
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright
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
     D ID0007          DS           528
      * File information data structure
      *
     D ID0008          DS           528
      * File information data structure
      *
     D ID0009          DS           528
      * File information data structure
      *
     D ID0010          DS           528
      * File information data structure
      *
     D ID0011          DS           528                                         185171
      ** File information data structure                                  185171
      *                                                                   185171
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * FLD: Account Codes
      * I : MAP Account Code
     D**********                              1   4 P1ACCD                                    CGL029
     D  P1ACCD                 1     10
     D P2PARM          DS
      * I :  Action Code
     D  P2ANCD                 1      1
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Man Accs Anal by Prt Cntr'
      * Message data for 'Receivable'
      * Message data for 'Income'
      * Message data for 'Expense'
      * Message data for 'Payable'
      * Message data for 'Receivable'
      * Message data for 'Payable'
      * Message data for 'Receivable'
      * Message data for 'Interim'
      * Message data for 'Interim'
      * Message data for 'Payable'
      * Message data for 'Income'
      * Message data for 'Expense'
      * Message data for 'Man Accs Anal by Prt Cntr'
      * Message data for 'Receivable'
      * Message data for 'Income'
      * Message data for 'Expense'
      * Message data for 'Payable'
      * Message data for 'Receivable'
      * Message data for 'Payable'
      * Message data for 'Receivable'
      * Message data for 'Interim'
      * Message data for 'Interim'
      * Message data for 'Payable'
      * Message data for 'Income'
      * Message data for 'Expense'
      * Message data for 'Account Code Exists'
      * Account Code
     D**********                              1   4 ZA0001                                    CGL029
     D  ZA0001                 1     10
      * Message data for 'Code cannot be 0000/9999'
      * Account Code
     D**********                              1   4 ZA0002                                    CGL029
     D  ZA0002                 1     10
      * Message data for 'Code cannot be 0000/9999'
      * Account Code
     D**********                              1   4 ZA0003                                    CGL029
     D  ZA0003                 1     10
      * Message data for 'Account code Cannot be ?'
      * Account Code
     D**********                              1   4 ZA0004                                    CGL029
     D  ZA0004                 1     10
      * Message data for 'Asterisk invalid'
      * Region Name
     D  ZA0005                 1     30
      * Message data for 'Account Code Name Req'
      * Account Code Name
     D  ZA0006                 1     25
      * Message data for 'Account type is required'
      * Account type
     D  ZA0007                 1      1
      * Message data for 'Account Type can't be R'
      * Account type
     D  ZA0008                 1      1
      * Message data for 'Retail ac not IN or EX'
      * Account type
     D  ZA0009                 1      1
      * Message data for 'Invalid Account Type'
      * Account type
     D  ZA0010                 1      1
      * Message data for 'Sub-type is req.'
      * Account Sub-type
     D  ZA0011                 1      1
      * Message data for 'Invalid A/C Sub-type'
      * Account Sub-type
     D  ZA0012                 1      1
      * Message data for 'Sub-type Non-retail'
      * Account Sub-type
     D  ZA0013                 1      1
      * Message data for 'Man Acc by Pft Cntr  INVD'
      * Man A/C Anal Profit Cntr
     D  ZA0014                 1      1
      * Message data for 'Account Section is req.'
      * Account Section
     D  ZA0015                 1      2
      * Message data for 'Invalid Account Section'
      * Account Section
     D  ZA0016                 1      2
      * Message data for 'A/c sectn IN or EX not R'
      * Account Section
     D  ZA0017                 1      2
      * Message data for 'Man Acc Anal by Book INVD'
      * Man A/C Anal Book
     D  ZA0018                 1      1
      * Message data for 'A/c Posting Ret Numeric'
      * A/c Posting Ret Pd  Alpha
     D  ZA0019                 1      2
      * Message data for 'Database Error (ICD)'
      * Filename
     D  ZA0020                 1     10
      * Message data for 'A/c Post Retention GT 0'
      * A/c Posting Ret Pd  Alpha
     D  ZA0021                 1      2
      * Message data for 'Not GE than GL ICD Ret Pd'
      * A/c Posting Ret Pd  Alpha
     D  ZA0022                 1      2
      * A/c Posting Retention Pd
     D  ZA0023                 3      4P 0
      * Message data for 'Man Acc Anal by AsCst INV'
      * Man A/C Anal Ass Cust
     D  ZA0024                 1      1
      * Message data for 'Invalid Title Indicator'
      * Title Only Indicator
     D  ZA0025                 1      1
      * Message data for 'Title Only cannot be chgd'
      * Title Only Indicator
     D  ZA0026                 1      1
      * Message data for 'Invalid Title Indicator'
      * Title Only Indicator
     D  ZA0027                 1      1
      * Message data for 'Man Acc Anal by Prod INVD'
      * Man A/C Anal Prod
     D  ZA0028                 1      1
      * Message data for 'Debit Int Debit Retail'
      * Debt Interest Accrual Dr.
     D**********                              1   4 ZA0029                                    CGL029
     D  ZA0029                 1     10
      * Message data for 'A/C Code NF - Highlight'
      * Account Code
     D**********                              1   4 ZA0030                                    CGL029
     D  ZA0030                 1     10
      * Message data for 'Self Ref Debt Int a/c Dr'
      * Debt Interest Accrual Dr.
     D**********                              1   4 ZA0031                                    CGL029
     D  ZA0031                 1     10
      * Message data for 'Account code mustn't be R'
      * Account Code
     D**********                              1   4 ZA0032                                    CGL029
     D  ZA0032                 1     10
      * Message data for 'Account code mustn't be t'
      * Interbranch Branch A/c
     D**********                              1   4 ZA0033                                    CGL029
     D  ZA0033                 1     10
      * Message data for 'Invalid Account Code'
      * Account Code
     D**********                              1   4 ZA0034                                    CGL029
     D  ZA0034                 1     10
      * Message data for 'A/C Sctn not  IN  or EX'
      * Debt Interest Accrual Dr.
     D**********                              1   4 ZA0035                                    CGL029
     D  ZA0035                 1     10
      * Message data for 'Debit Int Debit Non-Rtl'
      * Debt Interest Accrual Dr.
     D**********                              1   4 ZA0036                                    CGL029
     D  ZA0036                 1     10
      * Message data for 'Debit Int Credit Retail'
      * Debt Interest Accrual Cr.
     D**********                              1   4 ZA0037                                    CGL029
     D  ZA0037                 1     10
      * Message data for 'A/C Code NF - Highlight'
      * Account Code
     D**********                              1   4 ZA0038                                    CGL029
     D  ZA0038                 1     10
      * Message data for 'Self Ref Debt Int a/c Cr'
      * Debt Interest Accrual Cr.
     D**********                              1   4 ZA0039                                    CGL029
     D  ZA0039                 1     10
      * Message data for 'Account code mustn't be R'
      * Account Code
     D**********                              1   4 ZA0040                                    CGL029
     D  ZA0040                 1     10
      * Message data for 'Account code mustn't be t'
      * Interbranch Branch A/c
     D**********                              1   4 ZA0041                                    CGL029
     D  ZA0041                 1     10
      * Message data for 'Invalid Account Code'
      * Account Code
     D**********                              1   4 ZA0042                                    CGL029
     D  ZA0042                 1     10
      * Message data for 'A/C Sctn not IN or EX'
      * Debt Interest Accrual Cr.
     D**********                              1   4 ZA0043                                    CGL029
     D  ZA0043                 1     10
      * Message data for 'Debit Int Credit Non-Rtl'
      * Debt Interest Accrual Cr.
     D**********                              1   4 ZA0044                                    CGL029
     D  ZA0044                 1     10
      * Message data for 'Credit Int Debit Retail'
      * Credit Int. Accrual Dr.
     D**********                              1   4 ZA0045                                    CGL029
     D  ZA0045                 1     10
      * Message data for 'A/C Code NF - Highlight'
      * Account Code
     D**********                              1   4 ZA0046                                    CGL029
     D  ZA0046                 1     10
      * Message data for 'Self Ref Cred Int a/c Dr'
      * Credit Int. Accrual Dr.
     D**********                              1   4 ZA0047                                    CGL029
     D  ZA0047                 1     10
      * Message data for 'Account code mustn't be R'
      * Account Code
     D**********                              1   4 ZA0048                                    CGL029
     D  ZA0048                 1     10
      * Message data for 'Account code mustn't be t'
      * Interbranch Branch A/c
     D**********                              1   4 ZA0049                                    CGL029
     D  ZA0049                 1     10
      * Message data for 'Invalid Account Code'
      * Account Code
     D**********                              1   4 ZA0050                                    CGL029
     D  ZA0050                 1     10
      * Message data for 'A/C Sctn may no be IN/EX'
      * Credit Int. Accrual Dr.
     D**********                              1   4 ZA0051                                    CGL029
     D  ZA0051                 1     10
      * Message data for 'Credit Int Debit Non-Rtl'
      * Credit Int. Accrual Dr.
     D**********                              1   4 ZA0052                                    CGL029
     D  ZA0052                 1     10
      * Message data for 'Credit Int Credit Retail'
      * Credit Int. Accrual Cr.
     D**********                              1   4 ZA0053                                    CGL029
     D  ZA0053                 1     10
      * Message data for 'A/C Code NF - Highlight'
      * Account Code
     D**********                              1   4 ZA0054                                    CGL029
     D  ZA0054                 1     10
      * Message data for 'Self Ref Cred Int a/c Cr'
      * Credit Int. Accrual Cr.
     D**********                              1   4 ZA0055                                    CGL029
     D  ZA0055                 1     10
      * Message data for 'Account code mustn't be R'
      * Account Code
     D**********                              1   4 ZA0056                                    CGL029
     D  ZA0056                 1     10
      * Message data for 'Account code mustn't be t'
      * Interbranch Branch A/c
     D**********                              1   4 ZA0057                                    CGL029
     D  ZA0057                 1     10
      * Message data for 'Invalid Account Code'
      * Account Code
     D**********                              1   4 ZA0058                                    CGL029
     D  ZA0058                 1     10
      * Message data for 'A/C Sctn may not be IN/EX'
      * Credit Int. Accrual Cr.
     D**********                              1   4 ZA0059                                    CGL029
     D  ZA0059                 1     10
      * Message data for 'Credit Int Credit Non-Rtl'
      * Credit Int. Accrual Cr.
     D**********                              1   4 ZA0060                                    CGL029
     D  ZA0060                 1     10
      * Message data for 'Int Cap. Debit Retail'
      * Interest Capital in Debt
     D**********                              1   4 ZA0061                                    CGL029
     D  ZA0061                 1     10
      * Message data for 'A/C Code NF - Highlight'
      * Account Code
     D**********                              1   4 ZA0062                                    CGL029
     D  ZA0062                 1     10
      * Message data for 'Self Ref Int Cap Dr'
      * Interest Capital in Debt
     D**********                              1   4 ZA0063                                    CGL029
     D  ZA0063                 1     10
      * Message data for 'Account code mustn't be R'
      * Account Code
     D**********                              1   4 ZA0064                                    CGL029
     D  ZA0064                 1     10
      * Message data for 'Account code mustn't be t'
      * Interbranch Branch A/c
     D**********                              1   4 ZA0065                                    CGL029
     D  ZA0065                 1     10
      * Message data for 'Invalid Account Code'
      * Account Code
     D**********                              1   4 ZA0066                                    CGL029
     D  ZA0066                 1     10
      * Message data for 'Cap A/C cde must be IN'
      * Interest Capital in Debt
     D**********                              1   4 ZA0067                                    CGL029
     D  ZA0067                 1     10
      * Message data for 'Int Cap. Debit Non-Rtl'
      * Interest Capital in Debt
     D**********                              1   4 ZA0068                                    CGL029
     D  ZA0068                 1     10
      * Message data for 'Int Cap. Credit Retail'
      * Interest Capital in Cr.
     D**********                              1   4 ZA0069                                    CGL029
     D  ZA0069                 1     10
      * Message data for 'A/C Code NF - Highlight'
      * Account Code
     D**********                              1   4 ZA0070                                    CGL029
     D  ZA0070                 1     10
      * Message data for 'Self Ref Int Cap Cr'
      * Interest Capital in Cr.
     D**********                              1   4 ZA0071                                    CGL029
     D  ZA0071                 1     10
      * Message data for 'Account code mustn't be R'
      * Account Code
     D**********                              1   4 ZA0072                                    CGL029
     D  ZA0072                 1     10
      * Message data for 'Account code mustn't be t'
      * Interbranch Branch A/c
     D**********                              1   4 ZA0073                                    CGL029
     D  ZA0073                 1     10
      * Message data for 'Invalid Account Code'
      * Account Code
     D**********                              1   4 ZA0074                                    CGL029
     D  ZA0074                 1     10
      * Message data for 'Cap A/C cde must be EX'
      * Interest Capital in Cr.
     D**********                              1   4 ZA0075                                    CGL029
     D  ZA0075                 1     10
      * Message data for 'Int Cap. Credit Non-Rtl'
      * Interest Capital in Cr.
     D**********                              1   4 ZA0076                                    CGL029
     D  ZA0076                 1     10
      * Message data for 'Stat Returns BS L/C Num'
      * Stat Returns L/C Func
     D  ZA0077                 1      5
      * Message data for 'Stat Returns BS L/C GT 0'
      * Stat Returns L/C Func
     D  ZA0078                 1      5
      * Message data for 'Stat Returns BS F/C Num'
      * Stat Returns F/C Func
     D  ZA0079                 1      5
      * Message data for 'Stat Returns BS F/C Gt 0'
      * Stat Returns F/C Func
     D  ZA0080                 1      5
      * Message data for 'Invalid TI Account Type'
      * TI Account Type
     D  ZA0081                 1      2
      * Message data for 'Reporting Code must numer'
      * Reporting Code Func  Fld
     D  ZA0082                 1     10
      * Message data for 'Reporting Code GT Zero'
      * Reporting Code Func  Fld
     D  ZA0083                 1     10
      * Message data for 'Instrument Code invald'
      * PM Instrument Code (Lndr)
     D  ZA0084                 1      3
      * Message data for 'Instrument Code invald'
      * PM Instrument Code (Lndr)
     D  ZA0085                 1      3
      * Message data for 'Dr Int Pay A/C mandatory'
      * Dr Int pay A/C code Dr
     D**********                              1   4 ZA0086                                    CGL029
     D  ZA0086                 1     10
      * Message data for 'A/C Code NF - Highlight'
      * Account Code
     D**********                              1   4 ZA0087                                    CGL029
     D  ZA0087                 1     10
      * Message data for 'Self Ref Dr Int Pay AC Dr'
      * Dr Int pay A/C code Dr
     D**********                              1   4 ZA0088                                    CGL029
     D  ZA0088                 1     10
      * Message data for 'Account code mustn't be R'
      * Account Code
     D**********                              1   4 ZA0089                                    CGL029
     D  ZA0089                 1     10
      * Message data for 'Account code mustn't be t'
      * Interbranch Branch A/c
     D**********                              1   4 ZA0090                                    CGL029
     D  ZA0090                 1     10
      * Message data for 'Invalid Account Code'
      * Account Code
     D**********                              1   4 ZA0091                                    CGL029
     D  ZA0091                 1     10
      * Message data for 'Dr Int Pay A/C Dr prohib'
      * Dr Int pay A/C code Dr
     D**********                              1   4 ZA0092                                    CGL029
     D  ZA0092                 1     10
      * Message data for 'Dr Int Pay A/C Cr mandtry'
      * Dr Int pay A/C code Cr
     D**********                              1   4 ZA0093                                    CGL029
     D  ZA0093                 1     10
      * Message data for 'A/C Code NF - Highlight'
      * Account Code
     D**********                              1   4 ZA0094                                    CGL029
     D  ZA0094                 1     10
      * Message data for 'Self Ref Dr Int Pay AC Cr'
      * Dr Int pay A/C code Cr
     D**********                              1   4 ZA0095                                    CGL029
     D  ZA0095                 1     10
      * Message data for 'Account code mustn't be R'
      * Account Code
     D**********                              1   4 ZA0096                                    CGL029
     D  ZA0096                 1     10
      * Message data for 'Account code mustn't be t'
      * Interbranch Branch A/c
     D**********                              1   4 ZA0097                                    CGL029
     D  ZA0097                 1     10
      * Message data for 'Invalid Account Code'
      * Account Code
     D**********                              1   4 ZA0098                                    CGL029
     D  ZA0098                 1     10
      * Message data for 'Dr Int Pay A/C Cr prohbtd'
      * Dr Int pay A/C code Cr
     D**********                              1   4 ZA0099                                    CGL029
     D  ZA0099                 1     10
      * Message data for 'Withholding tax mandatory'
      * Withholding Tax A/C code
     D**********                              1   4 ZA0100                                    CGL029
     D  ZA0100                 1     10
      * Message data for 'A/C Code NF - Highlight'
      * Account Code
     D**********                              1   4 ZA0101                                    CGL029
     D  ZA0101                 1     10
      * Message data for 'Self Ref With. Tax A/C'
      * Withholding Tax A/C code
     D**********                              1   4 ZA0102                                    CGL029
     D  ZA0102                 1     10
      * Message data for 'Account code mustn't be R'
      * Account Code
     D**********                              1   4 ZA0103                                    CGL029
     D  ZA0103                 1     10
      * Message data for 'Account code mustn't be t'
      * Interbranch Branch A/c
     D**********                              1   4 ZA0104                                    CGL029
     D  ZA0104                 1     10
      * Message data for 'Invalid Account Code'
      * Account Code
     D**********                              1   4 ZA0105                                    CGL029
     D  ZA0105                 1     10
      * Message data for 'With. Tax A/C prohibited'
      * Withholding Tax A/C code
     D**********                              1   4 ZA0106                                    CGL029
     D  ZA0106                 1     10
      * Message data for 'Cr Int Pay A/C Cr mandtry'
      * Cr Int pay A/C code Cr
     D**********                              1   4 ZA0107                                    CGL029
     D  ZA0107                 1     10
      * Message data for 'A/C Code NF - Highlight'
      * Account Code
     D**********                              1   4 ZA0108                                    CGL029
     D  ZA0108                 1     10
      * Message data for 'Self Ref Cr Int Pay AC Cr'
      * Cr Int pay A/C code Cr
     D**********                              1   4 ZA0109                                    CGL029
     D  ZA0109                 1     10
      * Message data for 'Account code mustn't be R'
      * Account Code
     D**********                              1   4 ZA0110                                    CGL029
     D  ZA0110                 1     10
      * Message data for 'Account code mustn't be t'
      * Interbranch Branch A/c
     D**********                              1   4 ZA0111                                    CGL029
     D  ZA0111                 1     10
      * Message data for 'Invalid Account Code'
      * Account Code
     D**********                              1   4 ZA0112                                    CGL029
     D  ZA0112                 1     10
      * Message data for 'Cr Int Pay AC Cr prohibtd'
      * Cr Int pay A/C code Cr
     D**********                              1   4 ZA0113                                    CGL029
     D  ZA0113                 1     10
      * Message data for 'Min Int Sub to Tax prohib'
      * Withholding Tax screen
     D  ZA0114                 1     16
      * Message data for 'Min Int Sub to Tax prohib'
      * Withholding Tax screen
     D  ZA0115                 1     16
      * Message data for 'Min Int Sub to tax not nm'
      * Withholding Tax screen
     D  ZA0116                 1     16
      * Message data for 'Cr Int Pay A/C Sub mndtry'
      * Cr Int pay A/C code Sub
     D**********                              1   4 ZA0117                                    CGL029
     D  ZA0117                 1     10
      * Message data for 'A/C Code NF - Highlight'
      * Account Code
     D**********                              1   4 ZA0118                                    CGL029
     D  ZA0118                 1     10
      * Message data for 'Self Ref Cr Int Pay Sub'
      * Cr Int pay A/C code Sub
     D**********                              1   4 ZA0119                                    CGL029
     D  ZA0119                 1     10
      * Message data for 'Account code mustn't be R'
      * Account Code
     D**********                              1   4 ZA0120                                    CGL029
     D  ZA0120                 1     10
      * Message data for 'Account code mustn't be t'
      * Interbranch Branch A/c
     D**********                              1   4 ZA0121                                    CGL029
     D  ZA0121                 1     10
      * Message data for 'Invalid Account Code'
      * Account Code
     D**********                              1   4 ZA0122                                    CGL029
     D  ZA0122                 1     10
      * Message data for 'Cr Int Pay A/C Sub prhbtd'
      * Cr Int pay A/C code Sub
     D**********                              1   4 ZA0123                                    CGL029
     D  ZA0123                 1     10
      * Message data for 'Cr Int Pay A/C N-sub mand'
      * Cr Int pay A/C code N-Sub
     D**********                              1   4 ZA0124                                    CGL029
     D  ZA0124                 1     10
      * Message data for 'A/C Code NF - Highlight'
      * Account Code
     D**********                              1   4 ZA0125                                    CGL029
     D  ZA0125                 1     10
      * Message data for 'Self Ref Cr Int Pay N-sub'
      * Cr Int pay A/C code N-Sub
     D**********                              1   4 ZA0126                                    CGL029
     D  ZA0126                 1     10
      * Message data for 'Account code mustn't be R'
      * Account Code
     D**********                              1   4 ZA0127                                    CGL029
     D  ZA0127                 1     10
      * Message data for 'Account code mustn't be t'
      * Interbranch Branch A/c
     D**********                              1   4 ZA0128                                    CGL029
     D  ZA0128                 1     10
      * Message data for 'Invalid Account Code'
      * Account Code
     D**********                              1   4 ZA0129                                    CGL029
     D  ZA0129                 1     10
      * Message data for 'Cr Int Pay AC N-sub prhbd'
      * Cr Int pay A/C code N-Sub
     D**********                              1   4 ZA0130                                    CGL029
     D  ZA0130                 1     10
      * Message data for 'Database Error (ICD)'
      * Filename
     D  ZA0131                 1     10
      * Message data for 'Database Error (ICD)'
      * Filename
     D  ZA0132                 1     10
      * Message data for 'Vostro A/C must be Y/N'                         CFT002
      * Vostro A/C                                                        CFT002
     D  ZA0133                 1      1                                         CFT002
      * Message data for 'Loro A/C must be Y/N'                           CFT002
      * Loro A/C                                                          CFT002
     D  ZA0134                 1      1                                         CFT002
      * Message data for 'Account Code Name and Narrative Req'            CSD005
      * Account Code Narrative                                            CSD005
     D  ZA0135                 1     50                                         CSD005
      ** Account Code Details                                                               MD039031
     D SDACOD          DS           417                                                           MD
     D  #2ACTY                33     33                                                           MD
     D  #2TOIN                65     65                                                           MD
     D/COPY WNCPYSRC,SD0031RI03
      *                                                                                       CGP001
     D GOPGM           C                   CONST('GOGETZONE')
     D GOMSG           C                   CONST('ERROR IN GOGETZONE')
      ** Global Processing Constants                                                          CGP001
      *                                                                                       CGP001
     D WWHTX           C                   CONST('WITHHOLDING TAX DETA-                           MD
     D                                     ILS:-        ')                                        MD
     D WTFCA           C                   CONST('Trade Finance Exposu-                           MD
     D**********    're  Accnt...:'                                                MD028343 MD030956
     D                                     re Account..:')                                        MD
      *                                                                                     MD062338
      ** External Data Area of Menu Item                                                    MD062338
     D ZMITEM        E DS                  EXTNAME(ZMITEM)                                  MD062338
      *                                                                                     MD062338
      ** Menu item index                                                                    MD062338
     D UDCMNT          C                   CONST('0000000583')                              MD062338
     D ACCMNT          C                   CONST('0000000788')                              MD062338
      *                                                                                     MD062338
      ** Override Command Array                                                               CGP001
      *                                                                                       CGP001
     I*
     I*
     I* Description     : Copyright notice for inclusion in all programs
     I*
      ** Rename Account Code for SDACODL9                                                     CAS010
      *                                                                                       CAS010
     ISDACODD0
     I              A5ACCD                      A9ACCD
      *                                                                                       CRE015
      ** Rename Account Code for SDACD1L0                                                     CRE015
      *                                                                                       CRE015
     ISDACD1D0
     I              A5ACCD                      AXACCD
      *                                                                                       CRE015
     I****/COPY QWINDSRC,DLE1DTA                                          S01229
     I*COPY*QWINDSRC,SD0030GDTA                                           S01229            MD058085
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C********** P1ACCD    PARM           WP0001  4        Account Code                       CGL029
     C     P1ACCD        PARM                    WP0001           10
     C     P2ANCD        PARM                    WP0002            1            Action Code
     C                   PARM                    PMODE             1            Mode
      *****************************************************************
      * Initialize
     C                   EXSR      ZZINIT
      *                                                                                       CSD031
      ** Execute Accept Mode                                                                  CSD031
      *                                                                                       CSD031
     C     PMODE         IFEQ      'A'
     C     CSD032        ANDEQ     'Y'
     C                   EXSR      SRACCP
     C                   ENDIF
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
     C     #1ACCD        IFEQ      *BLANK                                       Account Code
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
     C                   MOVE      *IN84         WIN84             1
     C     CDL013        IFEQ      '1'
     C                   MOVE      '0'           *IN84
     C                   ELSE
     C                   MOVE      '1'           *IN84
     C                   ENDIF
     C                   EXFMT     #RCDKEY
     C                   MOVE      WIN84         *IN84
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
     C                   MOVEL     'ADD'         W0PMD
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
      * only if in change mode                                                                CSD031
     C     CSD032        IFEQ      'Y'
     C     PMODE         IFEQ      'C'
     C                   EXSR      BFVLKY
     C     *IN99         CABEQ     '1'           BEEXIT
     C                   ENDIF
     C                   ELSE
     C                   EXSR      BFVLKY
     C     *IN99         CABEQ     '1'           BEEXIT
     C                   ENDIF
      * Check for existing record
     C     KRTV          KLIST
     C                   KFLD                    A5ACCD                         Account Code
      * Setup key
     C                   MOVEL     #1ACCD        A5ACCD                         Account Code
     C     KRTV          CHAIN     @A5REA6                            9091      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   SETON                                        9931      *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
     C     WUTI02        IFEQ      'Y'                                                         CTI00
     C     BGN3ST        ANDEQ     'Y'                                                         CTI00
     C     CTI007        OREQ      'Y'
     C                   MOVEL     A5TFCT        WKTFCA                                        CTI00
     C                   ELSE                                                                  CTI00
     C                   MOVEL     *BLANK        WKTFCA                                        CTI00
     C                   ENDIF                                                                 CTI00
      *
     C     P2ANCD        IFEQ      'I'
     C**********           SETON                     70                                199078 210207
     C                   SETON                                        70                    AR672002
     C                   SETON                                        80
     C                   ENDIF
     C*                                                                                       199078
      * Verify record existence against program mode
     C     W0PMD         IFNE      'ADD'
      * If record does not exist, error
     C     *IN90         IFEQ      '1'
     C                   SETON                                        9931      *
      * Send message 'Account Codes          NF'
     C                   MOVEL     'USR0069'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C/COPY WNCPYSRC,SD0031RC15
      *                                                                                       CDL013
      ** Access Account code extension file. If no record on file                             CDL013
      ** error message.                                                                       CDL013
      *                                                                                       CDL013
     C     CDL013        IFEQ      '1'
     C     KRTV          CHAIN     SDACOAL1                           80
      *                                                                                       CDL013
     C     *IN80         IFEQ      *ON
     C                   MOVEL     'XXW0104'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN99
     C                   MOVE      *ON           *IN31
     C                   GOTO      BEEXIT
      *                                                                                       CDL013
     C                   ENDIF
      *                                                                                       CDL013
     C                   ENDIF
      *                                                                                       CDL013
     C                   EXSR      MBFL#1
      * CALC: Detail screen function fields
      * Start of SAR S01212
      * 00/Copy Member SD0031RSFF - Account Codes  *
     C*
     C/COPY WNCPYSRC,SD0031RSFF
     C*
      * End of SAR S01212
      * USER: Initialize detail screen (existing record)
      * Set-up DTL Screen Footer - Standard Functions  *
     C*
     C*  DETAIL LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C*  If Action Code is Delete :
     C*
     C     P2ANCD        IFEQ      'D'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F10=Delete   F12=Previous
     C                   MOVEL     'USR3350'     WUMSID            7            Message Identifier
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
     C*  If Action Code is Insert :
     C*
     C     P2ANCD        IFEQ      'I'                                                         S0122
     C* Setup footer text:
     C* F3=Exit   F12=Previous
     C                   MOVEL     'USR3351'     WUMSID                         Message Identifier
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
     C*  If Action Code is Amend :
     C*
     C     P2ANCD        IFEQ      'A'                                                         S0122
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
      *                                                                   185171
      ** If Amend, check if Account already exists for account code.      185171
      *                                                                   185171
     C     P2ANCD        IFEQ      'A'                                                         18517
     C**********           MOVE A5ACCD    ACDNUM  40                                   185171 CGL029
     C                   MOVE      A5ACCD        ACDNUM           10 0
     C********** ACDNUM    CHAINACCNTABF             70                                185171 210207
     C     ACDNUM        CHAIN     ACCNTABF                           80
     C                   ENDIF                                                                 18517
     C*
     C                   MOVEL     'N'           WUDELA                         Deletion Allowe
      * CASE: WRK.Set Up Complete is No
     C     WUSUC         IFEQ      'N'                                          *IF
     C                   MOVEL     'Y'           WUDELA                         Deletion Allowe
     C                   END                                                    *FI
      * Start of Fix S01117
      * Post Retention Period
      * CASE: DB1.Acct Post Retention Prd is Not Equal Zero
     C     A5ACPR        IFNE      *ZERO                                        *IF
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     A5ACPR        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0001            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0002           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0003            1 0          ZALIGN No Of De
     C                   PARM      2             WQ0004            2 0          ZALIGN No Of Di
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
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0006           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0007            1 0          ZALIGN No Of De
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
      * Zalign Post Retention Prd - Account Codes  *
     C* Zalign A/c Posting Ret Prd
     C                   MOVE      WUZASF        #DAPRA
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        #DAPRA                         A/c Posting Ret
     C                   END                                                    *FI
      * Stat Returns BS L/C
      * CASE: DB1.Stat Returns BS L/C is Not Blank
     C     A5SRLC        IFNE      *ZERO                                        *IF
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     A5SRLC        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0008            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0009           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0010            1 0          ZALIGN No Of De
     C                   PARM      5             WQ0011            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0012           16            ZALIGN File Fie
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
     C     WUZASF        PARM      WUZASF        WQ0013           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0014            1 0          ZALIGN No Of De
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
      * Zalign Stat Returns L/C - Account Codes  *
     C* Zalign Stat Returns L/C
     C                   MOVE      WUZASF        #DSRLF
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        #DSRLF                         Stat Returns L/
     C                   END                                                    *FI
      * Stat Returns BS F/C
      * CASE: DB1.Stat Returns BS F/C is Not Blank
     C     A5SRFC        IFNE      *ZERO                                        *IF
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     A5SRFC        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0015            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0016           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0017            1 0          ZALIGN No Of De
     C                   PARM      5             WQ0018            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0019           16            ZALIGN File Fie
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
     C     WUZASF        PARM      WUZASF        WQ0020           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0021            1 0          ZALIGN No Of De
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
      * Zalign Stat Returns F/C - Account Codes  *
     C* Zalign Stat Returns F/C
     C                   MOVE      WUZASF        #DSRFF
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        #DSRFF                         Stat Returns F/
     C                   END                                                    *FI
      * Reporting Code
      * CASE: DB1.Reporting Code is Not Zero
     C     A5RPCD        IFNE      *ZERO                                        *IF
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     A5RPCD        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0022            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0023           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0024            1 0          ZALIGN No Of De
     C                   PARM      10            WQ0025            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0026           16            ZALIGN File Fie
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
     C     WUZASF        PARM      WUZASF        WQ0027           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0028            1 0          ZALIGN No Of De
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
      * Zalign Reporting Code - Account Codes  *
     C* Zalign Reporting Code func field
     C                   MOVE      WUZASF        #DRPCF
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        #DRPCF                         Reporting Code
     C                   END                                                    *FI
      * start 063606
      * start S01413
      * Withholding tax details
      * CASE: WRK.Dsp withholding tax Flds is Display
     C     WUDSWT        IFEQ      'Y'                                          *IF
      * Zalign Withholding tax - Account Codes  *
     C                   MOVE      *BLANKS       WUZASF                         ZALIGN Screen F
     C                   MOVE      A5MISU        WUZASF                         ZALIGN Screen F
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0029           16            ZALIGN Screen F
     C                   PARM      WUZAND        WQ0030            1 0          ZALIGN No Of De
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
     C                   MOVEL     WUZASF        #DWTSC                         Withholding Tax
     C                   END                                                    *FI
      * end S01413
      * end 063606
      * End of Fix S01117
      * Start of SAR S01309
     C                   MOVEL     A5TOIN        WUTIOF                         Title Only func
      * End of SAR S01309
      * Start of S01522
     C                   MOVEL     'Y'           WUACDL                         A/C code cannot
      * User Defined Correspondence
      * CASE: WRK.User Defined Correspondnc is Yes
     C     WUN1ST        IFEQ      'Y'                                          *IF
      * CASE: DTL.Title Only Indicator is NO
     C     #1TOIN        IFEQ      'N'                                          *IF
      * CASE: PAR.Action Code is Delete
     C     P2ANCD        IFEQ      'D'                                          *IF
     C                   MOVEL     *BLANK        WURTCD                         Return Code wor
      * Call the UDC CL PGM - Account Codes  *
     C                   CALL      'CGC0021'                            90      Call the UDC CL
     C     WURTCD        PARM      WURTCD        WQ0031            7            Return Code wor
     C                   PARM      'D'           WQ0032            1            Action Code
     C**********           PARM P1ACCD    WQ0033  4        Account Code                       CGL029
     C                   PARM      P1ACCD        WQ0033           10
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'CGC0021'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * CASE: WRK.Return Code work field is equal to CGD1180
     C     WURTCD        IFEQ      'CGD1180'                                    *IF
     C                   MOVEL     'N'           WUACDL                         A/C code cannot
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of S01522
      * Start CAC001
      * Management Accounting Analysis By Profit Centre
      * CASE: WRK.CMC001 is Present
     C     WUCMC1        IFEQ      'Y'                                          *IF
      * CASE: WRK.Profit Centres Used is No
     C     WUPRCU        IFEQ      'N'                                          *IF
     C                   MOVEL     *BLANK        #1MAPC                         Man A/C Anal Pr
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
      * Retrieve message Man Accs Anal by Prt Cntr
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR2880'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DMAPF        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * CASE: WRK.Analytical Accounting is Yes
     C     WUN0ST        IFEQ      'Y'                                          *IF
     C                   MOVEL     'Y'           #1MAPC                         Man A/C Anal Pr
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        #1MAPC                         Man A/C Anal Pr
     C                   END                                                    *FI
      * End CAC001
      * Start of CRE002
      * Retail Accruels processing enhancement.
      * CASE: WRK.CRE002 is Not present
     C     WURAPE        IFEQ      'N'                                          *IF
      * Setup message data for message
      * Retrieve message Receivable
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR3195'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DFLD1        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * Setup message data for message
      * Retrieve message Income
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR3196'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DFLD2        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * Setup message data for message
      * Retrieve message Expense
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR3197'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DFLD3        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * Setup message data for message
      * Retrieve message Payable
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR3198'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DFLD4        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * Setup message data for message
      * Retrieve message Receivable
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR3195'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DFLD5        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * Setup message data for message
      * Retrieve message Payable
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR3198'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DFLD6        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
      * Retrieve message Receivable
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR3195'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DFLD1        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * Setup message data for message
      * Retrieve message Interim
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR3199'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DFLD2        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * Setup message data for message
      * Retrieve message Interim
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR3199'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DFLD3        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * Setup message data for message
      * Retrieve message Payable
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR3198'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DFLD4        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * Setup message data for message
      * Retrieve message Income
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR3196'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DFLD5        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * Setup message data for message
      * Retrieve message Expense
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR3197'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DFLD6        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
     C                   END                                                    *FI
      * End of CRE002
      * Start of SAR S01212
      * 00/Copy Member SD0031RISE - Account Codes  *
     C*
     C/COPY WNCPYSRC,SD0031RISE
     C*
      * End of SAR S01212
     C                   END
      *
     C                   ELSE
      * If record already exists, error
     C     *IN90         IFEQ      '0'
     C                   SETON                                        9931      *
      * Send message 'Account Codes          EX'
     C                   MOVEL     'USR0070'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
      * USER: Initialize detail screen (new record)
      * Set-up DTL Screen Footer - Standard Functions  *
     C*
     C*  DETAIL LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C*  If Action Code is Delete :
     C*
     C     P2ANCD        IFEQ      'D'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F10=Delete   F12=Previous
     C                   MOVEL     'USR3350'     WUMSID            7            Message Identifier
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
     C*  If Action Code is Insert :
     C*
     C     P2ANCD        IFEQ      'I'                                                         S0122
     C* Setup footer text:
     C* F3=Exit   F12=Previous
     C                   MOVEL     'USR3351'     WUMSID                         Message Identifier
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
     C*  If Action Code is Amend :
     C*
     C     P2ANCD        IFEQ      'A'                                                         S0122
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
      * Start of Fix S01267
      * Coding for Balance Sheet Codes, Profit & Loss Codes removed.
      * End of Fix S01267
     C                   MOVEL     'G'           #1ACTY                         Account type
     C                   MOVEL     'N'           #1TOIN                         Title Only Indi
     C                   MOVEL     *BLANK        #1ACST                         Account Sub-typ
     C     CFT002        IFEQ      'Y'
     C                   MOVEL     'N'           #1VOST
     C                   MOVEL     'N'           #1LORO
     C                   ENDIF
      * Start of SAR S01212
      * 00/Copy Member SD0031RISN - Account Codes  *
     C*
     C/COPY WNCPYSRC,SD0031RISN
     C*
      * End of SAR S01212
      * Start CAC001
      * Set Defaults for PCA-Management Accounting fields
      * CASE: WRK.CMC001 is Present
     C     WUCMC1        IFEQ      'Y'                                          *IF
     C                   MOVEL     'N'           #1MABK                         Man A/C Anal Bo
     C                   MOVEL     'N'           #1MAAC                         Man A/C Anal As
     C                   MOVEL     'N'           #1MAPR                         Man A/C Anal Pr
      * Management Accounting Analysis By Profit Centre
      * CASE: WRK.Profit Centres Used is Yes
     C     WUPRCU        IFEQ      'Y'                                          *IF
      * Setup message data for message
      * Retrieve message Man Accs Anal by Prt Cntr
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR2880'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DMAPF        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * CASE: WRK.Analytical Accounting is Yes
     C     WUN0ST        IFEQ      'Y'                                          *IF
     C                   MOVEL     'Y'           #1MAPC                         Man A/C Anal Pr
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           #1MAPC                         Man A/C Anal Pr
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        #1MAPC                         Man A/C Anal Pr
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        #1MAPC                         Man A/C Anal Pr
     C                   END                                                    *FI
      * End CAC001
      * Start of CRE002
      * Retail Accruels processing enhancement.
      * CASE: WRK.CRE002 is Not present
     C     WURAPE        IFEQ      'N'                                          *IF
      * Setup message data for message
      * Retrieve message Receivable
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR3195'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DFLD1        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * Setup message data for message
      * Retrieve message Income
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR3196'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DFLD2        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * Setup message data for message
      * Retrieve message Expense
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR3197'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DFLD3        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * Setup message data for message
      * Retrieve message Payable
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR3198'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DFLD4        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * Setup message data for message
      * Retrieve message Receivable
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR3195'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DFLD5        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * Setup message data for message
      * Retrieve message Payable
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR3198'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DFLD6        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
      * Retrieve message Receivable
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR3195'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DFLD1        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * Setup message data for message
      * Retrieve message Interim
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR3199'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DFLD2        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * Setup message data for message
      * Retrieve message Interim
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR3199'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DFLD3        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * Setup message data for message
      * Retrieve message Payable
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR3198'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DFLD4        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * Setup message data for message
      * Retrieve message Income
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR3196'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DFLD5        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * Setup message data for message
      * Retrieve message Expense
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR3197'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DFLD6        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
     C                   END                                                    *FI
      * End of CRE002
     C                   END
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
      *                                                                                      BUG6309
      ** Convert account code to numeric format                                              BUG6309
      *                                                                                      BUG6309
     C                   CALL      'ZALIGN'                             90
     C                   PARM                    ZRTN              7
     C                   PARM      #1ACCD        ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      10            ZADIG             2 0
     C                   PARM                    ZAFLD            16
     C     *IN90         IFEQ      *ON
      *                                                                                      BUG6309
      ** Send message '*Error occured on CALL...'                                            BUG6309
      *                                                                                      BUG6309
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     *BLANKS       ZAMSDA
     C                   EXSR      ZASNMS
     C                   ELSE
     C     ZRTN          IFEQ      *BLANKS
     C                   MOVE      ZAFLD         #1ACCD
     C                   ENDIF
     C                   ENDIF
      *                                                                                      BUG6309
      * Check Account Code is numeric
     C                   MOVEL     *IN90         XG90              1
     C                   TESTN                   #1ACCD               90  90    *
     C   90              MOVE      #1ACCD        XGX1              1
     C   90              TESTB     '0123'        XGX1                     90    *
      * All blank is OK
     C  N90#1ACCD        COMP      *BLANKS                                90    *
      * '?' is OK
     C  N90              MOVEL     #1ACCD        XGX1
     C  N90XGX1          COMP      '?'                                    90    *
     C     *IN90         IFEQ      '0'
      * Send message '*Field must be numeric'
     C                   MOVEL     'Y2U0010'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
     C                   END
     C                   MOVEL     XG90          *IN90
     C     W0PMD         IFNE      'ADD'
      * Select existing record
     C                   EXSR      VACKRL
     C                   END
      * USER: Validate key screen
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
      * Retrieve Record - Account Codes  *
     C                   EXSR      SARVGN
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
      * Start of Fix S01117
      * Setup message data for message
     C                   MOVEL     #1ACCD        ZA0001                         Account Code
      * Send message 'Account Code Exists'
     C                   MOVEL     'USR1236'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
      * End of Fix S01117
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: KEY.Account code is Zero
     C********** #1ACCD    IFEQ '0000'                     *IF                                CGL029
     C                   MOVE      *ALL'0'       WACC0            10
     C     #1ACCD        IFEQ      WACC0
      * Setup message data for message
     C                   MOVEL     #1ACCD        ZA0002                         Account Code
      * Send message 'Code cannot be 0000/9999'
     C                   MOVEL     'USR0163'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   END                                                    *FI
      * CASE: KEY.Account code is 9999
     C********** #1ACCD    IFEQ '9999'                     *IF                                CGL029
     C                   MOVE      *ALL'9'       WACC9            10
     C     #1ACCD        IFEQ      WACC9
      * Setup message data for message
     C                   MOVEL     #1ACCD        ZA0003                         Account Code
      * Send message 'Code cannot be 0000/9999'
     C                   MOVEL     'USR0163'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   END                                                    *FI
      * Start of Fix S01117
     C                   MOVEL     #1ACCD        WUTIVK                         Test invalid va
      * CASE: WRK.Test invalid val in key f is Question Mark
     C     WUTIVK        IFEQ      '?'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1ACCD        ZA0004                         Account Code
      * Send message 'Account code Cannot be ?'
     C                   MOVEL     'USR1244'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   END                                                    *FI
      * End of Fix S01117
      * Start of Fix S01267
      * CASE: WRK.Test invalid val in key f is Asterisk
     C     WUTIVK        IFEQ      '*'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1ACCD        ZA0005                         Account Code
      * Send message 'Asterisk invalid'
     C                   MOVEL     'USR1164'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   END                                                    *FI
      * End of Fix S01267
      * Start of SAR S01212
      * 00/Copy Member SD0031RVKS - Account Codes  *
     C*
     C/COPY WNCPYSRC,SD0031RVKS
     C*
      * End of SAR S01212
      * Account Code required
     C     #1ACCD        IFEQ      *BLANK                                       IF
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
     C                   MOVEL     'Y'           W0TRN2            1
     C     W0TRN         DOWEQ     'Y'
     C     W0TRN2        OREQ      'P'
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
      /EJECT                                                                                  CRE015
     CSR   DXEXFM        BEGSR
      *================================================================                       CRE015
      * Display Term & Notice Screen and Process Help Request                                 CRE015
      *================================================================                       CRE015
      *                                                                                       CRE015
      ** Defer confirm                                                                        CRE015
      *                                                                                       CRE015
     C                   MOVE      'N'           W0DCF
      *                                                                                       CRE015
      ** Update screen time                                                                   CRE015
      *                                                                                       CRE015
     C                   TIME                    ##TME
      *                                                                                       CRE015
      ** PUTOVR unless conditioned fields change                                              CRE015
      *                                                                                       CRE015
     C                   SETON                                            86
     C     *IN89         IFNE      CXIN89
     C                   SETOFF                                           86
     C                   ENDIF
     C                   MOVE      *IN89         CXIN89            1
      *                                                                                       CRE015
      ** Set cursor by *SET CURSOR data                                                       CRE015
      *                                                                                       CRE015
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y0SET
     C                   ENDIF
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT3
     C                   EXFMT     #RCDDTL2
      *                                                                                       CRE015
      ** Test cursor                                                                          CRE015
      *                                                                                       CRE015
     C                   EXSR      Y8TST
      *                                                                                       CRE015
      ** Clear set cursor DDS indicator                                                       CRE015
      *                                                                                       CRE015
     C     WCSRLC        IFEQ      'OFF'
     C                   SETOFF                                       94
     C                   ENDIF
      *                                                                                       CRE015
      ** Update job time                                                                      CRE015
      *                                                                                       CRE015
     C                   TIME                    ##JTM
      *                                                                                       CRE015
      ** Clear messages from program message queue                                            CRE015
      *                                                                                       CRE015
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      *                                                                                       CRE015
      ** Reset first message only flag                                                        CRE015
      *                                                                                       CRE015
     C                   MOVEL     'Y'           ZAFSMS            1
      *                                                                                       CRE015
      ** Reset global error indicator                                                         CRE015
      *                                                                                       CRE015
     C                   SETOFF                                           99
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y9CLR
     C                   ENDIF
      *================================================================                       CRE015
     CSR   DXEXIT        ENDSR
      /EJECT                                                                                  CRE015
     CSR   CXPRTN        BEGSR
      *================================================================                       CRE015
      * Display and Process Term and Notice Detail screen                                     CRE015
      *================================================================                       CRE015
      *                                                                                       CRE015
      ** Initialise Screen Fields                                                             CRE015
      *                                                                                       CRE015
     C                   EXSR      MXIZ#1
     C                   MOVEL     'Y'           W0TRN
      *                                                                                       CRE015
      ** Rewrite Header                                                                       CRE015
      *                                                                                       CRE015
     C     W0BYP         IFEQ      'Y'
     C                   EXSR      BBEXFM
     C                   ENDIF
      *                                                                                       CRE015
     C     W0RPT         IFEQ      'N'
     C     W0TRN         DOWEQ     'Y'
      *                                                                                       CRE015
      ** Display detail screen                                                                CRE015
      *                                                                                       CRE015
     C                   EXSR      DXEXFM
      *                                                                                       CRE015
      ** Process response to detail screen                                                    CRE015
      ** Cancel & exit program                                                                CRE015
      *                                                                                       CRE015
     C   03              CAS                     ZXEXPG
      *                                                                                       CRE015
      ** Redisplay previous screen                                                            CRE015
      *                                                                                       CRE015
     C   12              CAS                     FFDSPV
      *                                                                                       CRE015
      ** Process Term & Notice details screen input                                           CRE015
      *                                                                                       CRE015
     C                   CAS                     BXPRTN
     C                   ENDCS
      *                                                                                       CRE015
     C     *IN99         IFEQ      *ON
     C                   MOVE      'Y'           W0TRN
     C                   ELSE
      *                                                                                       CRE015
      * Defer confirm/update requested                                                        CRE015
     C     W0DCF         IFEQ      'N'
     C                   MOVE      'N'           W0TRN
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *================================================================                       CRE015
     CSR   CXEXIT        ENDSR
      /EJECT                                                                                  CRE015
     CSR   DDVLDL        BEGSR
      *================================================================                       CRE015
      * Validate Term & Notice Details Input Fields                                           CRE015
      *================================================================                       CRE015
     C                   MOVE      *OFF          *IN21
     C                   MOVE      *OFF          *IN22
     C                   MOVE      *OFF          *IN23
     C                   MOVE      *OFF          *IN24
     C                   MOVE      *OFF          *IN26
     C                   MOVE      *OFF          *IN27
     C                   MOVE      *OFF          *IN28
      *                                                                                       CRE015
     C     #1ATTY        IFNE      'O'
     C     #1ATTY        ANDNE     'P'
     C                   MOVEL     'REUSRMSG'    ZAMSGF
     C                   MOVEL     'RE76101'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9921
     C                   ENDIF
      *                                                                                       CRE015
     C     #1ATTY        IFEQ      'O'
     C     #1CHIA        IFNE      *BLANKS
     C                   MOVEL     'REUSRMSG'    ZAMSGF
     C                   MOVEL     'RE76103'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9922
     C                   ENDIF
     C     #1RTTY        IFNE      *BLANKS
     C                   MOVEL     'REUSRMSG'    ZAMSGF
     C                   MOVEL     'RE76105'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9923
     C                   ENDIF
     C     #1NCVD        IFNE      *BLANKS
     C                   MOVEL     'REUSRMSG'    ZAMSGF
     C                   MOVEL     'RE76107'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9924
     C                   ENDIF
     C     #1PRFC        IFNE      *BLANKS
     C                   MOVEL     'REUSRMSG'    ZAMSGF
     C                   MOVEL     'RE76109'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9926
     C                   ENDIF
     C     #1RTDN        IFNE      *BLANKS
     C                   MOVEL     'REUSRMSG'    ZAMSGF
     C                   MOVEL     'RE76111'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9927
     C                   ENDIF
     C     #1RTDI        IFNE      *BLANKS
     C                   MOVEL     'REUSRMSG'    ZAMSGF
     C                   MOVEL     'RE76113'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9928
     C                   ENDIF
     C                   ENDIF
     C     #1ATTY        IFEQ      'P'
     C     #1CHIA        IFNE      *BLANKS
     C                   MOVE      *IN93         IN93              1
     C     '?'           SCAN      #1CHIA                                 93
     C   93              MOVE      'Y'           W0DCF
     C                   MOVE      IN93          *IN93
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C     #1CHIA        PARM      #1CHIA        P@ACOD
     C     @1DBRC        PARM      *BLANKS       UUSDY
     C                   ENDIF
     C     P@RTCD        IFEQ      '*NRF'
     C     #1CHIA        OREQ      *BLANKS
     C                   MOVEL     'REUSRMSG'    ZAMSGF
     C                   MOVEL     'RE76104'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9922
     C                   ENDIF
      *                                                                                       CRE015
     C     #1RTTY        IFNE      *BLANKS
     C                   MOVE      *IN93         IN93              1
     C     '?'           SCAN      #1RTTY                                 93
     C   93              MOVE      'Y'           W0DCF
     C                   MOVE      IN93          *IN93
     C                   CALL      'AORETRR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C     #1RTTY        PARM      #1RTTY        P@RETR            5
     C     SDRETD        PARM      *BLANKS       UUSDY
     C                   ENDIF
     C     P@RTCD        IFNE      *BLANKS
     C     #1RTTY        OREQ      *BLANKS
     C                   MOVEL     'REUSRMSG'    ZAMSGF
     C                   MOVEL     'RE76106'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9923
     C                   ENDIF
      *                                                                                       CRE015
     C     #1NCVD        IFNE      *BLANKS
     C                   MOVE      *IN93         IN93              1
     C     '?'           SCAN      #1NCVD                                 93
     C   93              MOVE      'Y'           W0DCF
     C                   MOVE      IN93          *IN93
     C                   CALL      'AONARRR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C     #1NCVD        PARM      #1NCVD        P@NARR            2
     C     SDNARR        PARM      *BLANKS       UUSDY
     C                   ENDIF
     C     P@RTCD        IFNE      *BLANKS
     C     #1NCVD        OREQ      *BLANKS
     C                   MOVEL     'REUSRMSG'    ZAMSGF
     C                   MOVEL     'RE76108'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9924
     C                   ENDIF
      *                                                                                       CRE015
     C     #1PRFC        IFNE      *BLANKS
     C                   MOVE      *IN93         IN93              1
     C     '?'           SCAN      #1PRFC                                 93
     C   93              MOVE      'Y'           W0DCF
     C                   MOVE      IN93          *IN93
     C                   CALL      'AOPRFCR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C     #1PRFC        PARM      #1PRFC        P@PFTC            4
     C     SDPRFC        PARM      *BLANKS       UUSDY
     C                   ENDIF
     C     P@RTCD        IFEQ      '*NRF'
     C     #1PRFC        OREQ      *BLANKS
     C                   MOVEL     'REUSRMSG'    ZAMSGF
     C                   MOVEL     'RE76110'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9926
     C                   ENDIF
      *                                                                                       CRE015
     C                   TESTN                   #1RTDN               90  90
     C  N90#1RTDN        COMP      *BLANKS                                90
     C     *IN90         IFEQ      '0'
     C                   MOVEL     'REUSRMSG'    ZAMSGF
     C                   MOVEL     'RE76112'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9927
     C                   ENDIF
      *                                                                                       CRE015
     C                   TESTN                   #1RTDI               90  90
     C  N90#1RTDI        COMP      *BLANKS                                90
     C     *IN90         IFEQ      '0'
     C                   MOVEL     'REUSRMSG'    ZAMSGF
     C                   MOVEL     'RE76114'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9928
     C                   ENDIF
     C                   ENDIF
      *================================================================                       CRE015
     CSR   DDEXIT        ENDSR
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
     C                   MOVE      *IN84         WIN84             1
     C                   MOVE      *IN86         WIN86             1
     C     CDL013        IFEQ      '1'
     C                   MOVE      '0'           *IN84
     C     WTERR         IFEQ      'Y'
     C                   MOVE      '1'           *IN86
     C                   ELSE
     C                   MOVE      '0'           *IN86
     C                   ENDIF
     C                   ELSE
     C                   MOVE      '1'           *IN84
     C                   ENDIF
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y1SET
     C                   END
      *                                                                                     AR672002
     C     P2ANCD        IFEQ      'A'                                                      AR672002
     C                   MOVE      '0'           *IN70                                      AR672002
     C                   ENDIF                                                              AR672002
      *                                                                                     AR672002
     C                   WRITE     #MSGCTL
     C/COPY WNCPYSRC,SD0031RC16
     C                   WRITE     #CMDTXT2
     C                   EXFMT     #RCDDTL1
     C                   MOVE      WIN84         *IN84
     C                   MOVE      WIN86         *IN86
      * Test cursor
     C                   EXSR      Y8TST
      * Clear set cursor DDS indicator
     C     WCSRLC        IFEQ      'OFF'
     C                   SETOFF                                       94        *
     C                   END
     C                   MOVE      *BLANK        WCSRLC
      * If help requested, display help text
     C   25              EXSR      ZHHPKY
     C/COPY WNCPYSRC,SD0031RC06
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
      * Start of Fix S01117
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
     C                   END                                                    *FI
      * End of Fix S01117
      * Start of SAR S01212
      * 00/Copy Member SD0031RPKR - Account Codes  *
     C*
     C/COPY WNCPYSRC,SD0031RPKR
     C*
      * End of SAR S01212
     C   05              MOVEL     'R'           W0TRN
     C   12              MOVEL     'K'           W0TRN
     C                   MOVEL     'Y'           W0TRN2
      *================================================================
     CSR   CCEXIT        ENDSR
      /EJECT                                                                                  CRE015
     CSR   FFDSPV        BEGSR
      *================================================================                       CRE015
      * Redisplay Previous Screen (Initial Screen)                                            CRE015
      *================================================================                       CRE015
      *                                                                                       CRE015
      ** Set-up KEY Screen Footer - Standard Functions                                        CRE015
      *                                                                                       CRE015
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
      *                                                                                       CRE015
      ** Setup footer text:                                                                   CRE015
      *                                                                                       CRE015
     C     P2ANCD        IFEQ      'D'
      *                                                                                       CRE015
      ** F3/F10/F12                                                                           CRE015
      *                                                                                       CRE015
     C                   MOVEL     'USR3350'     WUMSID            7
     C                   CALL      'SDRTVTXT'                           90
     C     WUMSID        PARM      WUMSID        KE0286            7
     C     WUMSGF        PARM      WUMSGF        KE0287           10
     C     WUMTXT        PARM      WUMTXT        KE0288           80
     C                   MOVEL     WUMTXT        ##CTX1
     C                   ELSE
      *                                                                                       CRE015
      ** F3/F12                                                                               CRE015
      *                                                                                       CRE015
     C                   MOVEL     'USR3351'     WUMSID            7
     C                   CALL      'SDRTVTXT'                           90
     C     WUMSID        PARM      WUMSID        KE0286            7
     C     WUMSGF        PARM      WUMSGF        KE0287           10
     C     WUMTXT        PARM      WUMTXT        KE0288           80
     C                   MOVEL     WUMTXT        ##CTX1
     C                   ENDIF
      *                                                                                       CRE015
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CRE015
     C/COPY WNCPYSRC,SD0031RPKR                                                               CRE015
      *                                                                                       CRE015
     C   05              MOVEL     'R'           W0TRN
     C   12              MOVEL     'P'           W0TRN2
      *================================================================                       CRE015
     CSR   FFEXIT        ENDSR
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
     C  N99              MOVE      'N'           W0RPT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           CFEXIT
     C     CRE015        IFEQ      'Y'
     C     #1ACTY        ANDEQ     'R'
     C                   EXSR      CXPRTN
     C     W0DCF         IFEQ      'Y'
     C                   GOTO      CFEXIT
     C                   ENDIF
     C                   ENDIF
      * No error: update record
     C     *IN12         IFEQ      *OFF
     C                   EXSR      EBPR##
     C                   MOVE      'N'           W0TRN
     C                   MOVE      'Y'           W0TRN2
     C                   ENDIF
      *================================================================
     CSR   CFEXIT        ENDSR
      /EJECT                                                                                  CRE015
     CSR   BXPRTN        BEGSR
      *================================================================                       CRE015
      * Validate Term & Notice Input                                                          CRE015
      *================================================================                       CRE015
     C                   MOVEL     'N'           W0DCF             1
     C     P2ANCD        IFEQ      'D'
     C     *IN10         ANDEQ     *OFF
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USR0534'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
      *                                                                                       CRE015
      ** Validate details                                                                     CRE015
      *                                                                                       CRE015
     C  N10              CAS                     DDVLDL
     C                   ENDCS
      *                                                                                       CRE015
      ** QUIT if error:                                                                       CRE015
      *                                                                                       CRE015
     C   99              GOTO      BXEXIT
     C     W0DCF         CABEQ     'Y'           BXEXIT
      *================================================================                       CRE015
     CSR   BXEXIT        ENDSR
      /EJECT
     CSR   DCVLDL        BEGSR
      *================================================================
      * Validate details
      *================================================================
      * Validate Account type
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1ACTY        W0NSRQ            1            Account type
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1144524       Y2LSNO            7 0
     C     #1ACTY        PARM      #1ACTY        W0EXVL           20            Account type
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Account Sub-type
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1ACST        W0NSRQ            1            Account Sub-typ
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100805       Y2LSNO            7 0
     C     #1ACST        PARM      #1ACST        W0EXVL           20            Account Sub-typ
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Man A/C Anal Profit Cntr
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MAPC        W0NSRQ            1            Man A/C Anal Pr
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1197241       Y2LSNO            7 0
     C     #1MAPC        PARM      #1MAPC        W0EXVL           20            Man A/C Anal Pr
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Account Section
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1ACSC        W0NSRQ            1            Account Section
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1144581       Y2LSNO            7 0
     C     #1ACSC        PARM      #1ACSC        W0EXVL           20            Account Section
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Man A/C Anal Book
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MABK        W0NSRQ            1            Man A/C Anal Bo
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1197251       Y2LSNO            7 0
     C     #1MABK        PARM      #1MABK        W0EXVL           20            Man A/C Anal Bo
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Man A/C Anal Ass Cust
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MAAC        W0NSRQ            1            Man A/C Anal As
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1197232       Y2LSNO            7 0
     C     #1MAAC        PARM      #1MAAC        W0EXVL           20            Man A/C Anal As
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Title Only Indicator
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1TOIN        W0NSRQ            1            Title Only Indi
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1166566       Y2LSNO            7 0
     C     #1TOIN        PARM      #1TOIN        W0EXVL           20            Title Only Indi
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Man A/C Anal Prod
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MAPR        W0NSRQ            1            Man A/C Anal Pr
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1197236       Y2LSNO            7 0
     C     #1MAPR        PARM      #1MAPR        W0EXVL           20            Man A/C Anal Pr
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * USER: Validate detail screen fields
      * Start of S01461
      * Remove the processing for 'Midas export ' module.
      * End of S01461
      * Start of fix S01117
      * Action code is delete
      * CASE: PAR.Action Code is Delete
     C     P2ANCD        IFEQ      'D'                                          *IF
      * Send message 'F3/F10 Only Valid Options'
     C                   MOVEL     'USR0534'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DCEXIT                                       *QUIT
     C                   END                                                    *FI
      *                                                                                       CGP001
      ** If CGP001 is enabled, validate the                                                   CGP001
      ** Global Account fields.                                                               CGP001
      *                                                                                       CGP001
     C     CGP001        IFEQ      'Y'
     C*********************EXSR SRVGPC                                                 CGP001 TCA105
     C                   EXSR      SRVGAC
     C                   EXSR      SRVGPC
     C                   EXSR      SRVGIC
     C     CLE025        IFEQ      'Y'
     C     CGL014        OREQ      'Y'
     C                   EXSR      SRADCK
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CGP001
      *                                                                   CSD005
      *** If switchable feature is required and both acct code name       CSD005
      *** and acct code narrative are blank then send error message       CSD005
      *                                                                   CSD005
     C     *IN69         IFEQ      *ON                                                         CSD00
     C                   SELECT                                                                CSD00
     C     #1NARR        WHENEQ    *BLANK                                                      CSD00
     C     #1ACC2        ANDEQ     *BLANK                                                      CSD00
      *                                                                   CSD005
      *** Setup message data for message                                  CSD005
      *                                                                   CSD005
     C                   MOVEL     #1NARR        ZA0135                         Acct Code Narr CSD00
      *                                                                   CSD005
      *** Send message 'Account Code Name or Narr is req'                 CSD005
      *                                                                   CSD005
     C                   MOVEL     'USR4287'     ZAMSID                                        CSD00
     C                   EXSR      ZASNMS                                                      CSD00
     C                   SETON                                        9931      *              CSD00
      *                                                                   CSD005
      *** If acct narr is blank but acct name is entered, copy data       CSD005
      *** from acct name to acct narr                                     CSD005
      *                                                                   CSD005
     C     #1NARR        WHENEQ    *BLANK                                                      CSD00
     C     #1ACC2        ANDNE     *BLANK                                                      CSD00
     C                   MOVEL     #1ACC2        #1NARR                                        CSD00
      *                                                                   CSD005
      *** If acct name is blank but acct narr is entered, copy data       CSD005
      *** from acct narr to acct name                                     CSD005
      *                                                                   CSD005
     C     #1ACC2        WHENEQ    *BLANK                                                      CSD00
     C     #1NARR        ANDNE     *BLANK                                                      CSD00
     C                   MOVEL     #1NARR        #1ACC2                                        CSD00
      *                                                                   CSD005
     C                   ENDSL                                                                 CSD00
      *                                                                   CSD005
     C                   ENDIF                                                                 CSD00
      *                                                                   CSD005
      *** If Account narrative feature is not available then check to     CSD005
      *** see if account name is blank                                    CSD005
      *                                                                   CSD005
     C     *IN69         IFEQ      *OFF                                                        CSD00
     C     #1ACCN        ANDEQ     *BLANK                                                      CSD00
      *                                                                   CSD005
      * Account Code Name
      * CASE: DTL.Account Code Name is Not Entered
     C*********  #1ACCN    IFEQ *BLANK                     *IF            CSD005
      * Setup message data for message
     C                   MOVEL     #1ACCN        ZA0006                         Account Code Na
      * Send message 'Account Code Name Req'
     C                   MOVEL     'USR1243'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
     C*********            END                             *FI            CSD005
      *                                                                   CSD005
     C                   ENDIF                                                                 CSD00
      *                                                                   CGL010
      ** Validate Trasitory Account Codes if CGL010 is present            CGL010
      *                                                                   CGL010
     C     *IN65         IFEQ      *ON                                                         CGL01
     C                   MOVEL     @1DBRC        WWACOD                                        CGL01
      *                                                                   CGL010
      ** Check if there are existing future valued transitory postings    CGL010
      ** only if Transitory Account Codes changed.                        CGL010
      *                                                                   CGL010
     C**********           MOVEL#1ACCD    KACCD   40                                   CGL010 CGL029
     C                   MOVEL     #1ACCD        KACCD            10 0
     C     KACCD         CHAIN     GLVALPL3                           70                       CGL01
      *                                                                   CGL010
     C     DDTRDA        IFEQ      '?'                                                         CGL01
     C     DDTRCA        OREQ      '?'                                                         CGL01
     C                   MOVEL     'Y'           W0DCF                                         CGL01
     C                   ENDIF                                                                 CGL01
      *                                                                   CGL010
      ** Debit                                                            CGL010
      *                                                                   CGL010
     C     DDTRDA        IFNE      *BLANKS                                                     CGL01
     C                   CALL      'AOACODR0'                                                  CGL01
     C                   PARM      *BLANKS       P@RTCD                                        CGL01
     C                   PARM      '*KEY   '     P@OPTN                                        CGL01
     C********** DDTRDA    PARM DDTRDA    P@ACOD  4                                    CGL010 CGL029
     C     DDTRDA        PARM      DDTRDA        P@ACOD           10
     C********** @1DBRC    PARM *BLANKS   UUSDY                                      CGL010 MD039031
     C     SDACOD        PARM      *BLANKS       UUSDY
      *                                                                   CGL010
      ** Record not found                                                 CGL010
      *                                                                   CGL010
     C     P@RTCD        IFNE      '*NOSEL '                                                   CGL01
     C     P@RTCD        IFNE      *BLANKS                                                     CGL01
     C                   MOVEL     'USR0173'     ZAMSID                                        CGL01
     C                   EXSR      ZASNMS                                                      CGL01
     C                   MOVE      *ON           *IN99                                         CGL01
     C                   MOVE      *ON           *IN63                                         CGL01
     C                   ELSE                                                                  CGL01
      *                                                                   CGL010
      ** Cannot be a title only account code                              CGL010
      *                                                                   CGL010
     C********** A5TOIN    IFEQ 'Y'                                                  CGL010 MD039031
     C     #2TOIN        IFEQ      'Y'
     C                   MOVEL     'USR0221'     ZAMSID                                        CGL01
     C                   EXSR      ZASNMS                                                      CGL01
     C                   MOVE      *ON           *IN99                                         CGL01
     C                   MOVE      *ON           *IN63                                         CGL01
     C                   ENDIF                                                                 CGL01
      *                                                                   CGL010
      ** Cannot be a retail account code                                  CGL010
      ** or cannot be a nostro account code                                                 MD039031
      *                                                                   CGL010
     C********** A5ACTY    IFEQ 'R'                                                  CGL010 MD039031
     C     #2ACTY        IFEQ      'R'
     C     #2ACTY        OREQ      'N'
     C     #2ACTY        IFEQ      'R'
     C                   MOVEL     'USR0176'     ZAMSID                                        CGL01
     C                   ELSE
     C                   MOVEL     'USR8445'     ZAMSID
     C                   ENDIF
     C                   EXSR      ZASNMS                                                      CGL01
     C                   MOVE      *ON           *IN99                                         CGL01
     C                   MOVE      *ON           *IN63                                         CGL01
     C                   ENDIF                                                                 CGL01
      *                                                                   CGL010
     C     DDTRDA        IFNE      WWTRDA                                                      CGL01
     C     *IN70         ANDEQ     *OFF                                                        CGL01
     C                   MOVEL     'USR8658'     ZAMSID                                        CGL01
     C                   EXSR      ZASNMS                                                      CGL01
     C                   MOVE      *ON           *IN99                                         CGL01
     C                   MOVE      *ON           *IN63                                         CGL01
     C                   ENDIF                                                                 CGL01
     C                   ENDIF                                                                 CGL01
     C                   ENDIF                                                                 CGL01
     C                   ENDIF                                                                 CGL01
      *                                                                   CGL010
      ** Credit                                                           CGL010
      *                                                                   CGL010
     C     DDTRCA        IFNE      *BLANKS                                                     CGL01
     C                   CALL      'AOACODR0'                                                  CGL01
     C                   PARM      *BLANKS       P@RTCD                                        CGL01
     C                   PARM      '*KEY   '     P@OPTN                                        CGL01
     C     DDTRCA        PARM      DDTRCA        P@ACOD                                        CGL01
     C     @1DBRC        PARM      *BLANKS       UUSDY                                         CGL01
     C********** @1DBRC    PARM *BLANKS   UUSDY                                      CGL010 MD039031
     C     SDACOD        PARM      *BLANKS       UUSDY
      *                                                                   CGL010
      ** Record not found                                                 CGL010
      *                                                                   CGL010
     C     P@RTCD        IFNE      '*NOSEL '                                                   CGL01
     C     P@RTCD        IFNE      *BLANKS                                                     CGL01
     C                   MOVEL     'USR0173'     ZAMSID                                        CGL01
     C                   EXSR      ZASNMS                                                      CGL01
     C                   MOVE      *ON           *IN99                                         CGL01
     C                   MOVE      *ON           *IN64                                         CGL01
     C                   ELSE                                                                  CGL01
      *                                                                   CGL010
      ** Cannot be a title only account code                              CGL010
      *                                                                   CGL010
     C********** A5TOIN    IFEQ 'Y'                                                  CGL010 MD039031
     C     #2TOIN        IFEQ      'Y'
     C                   MOVEL     'USR0221'     ZAMSID                                        CGL01
     C                   EXSR      ZASNMS                                                      CGL01
     C                   MOVE      *ON           *IN99                                         CGL01
     C                   MOVE      *ON           *IN64                                         CGL01
     C                   ENDIF                                                                 CGL01
      *                                                                   CGL010
      ** Cannot be a retail account code                                  CGL010
      ** or cannot be a nostro account code                                                 MD039031
      *                                                                   CGL010
     C********** A5ACTY    IFEQ 'R'                                                  CGL010 MD039031
     C     #2ACTY        IFEQ      'R'
     C     #2ACTY        OREQ      'N'
     C     #2ACTY        IFEQ      'R'
     C                   MOVEL     'USR0176'     ZAMSID                                        CGL01
     C                   ELSE
     C                   MOVEL     'USR8445'     ZAMSID
     C                   ENDIF
     C                   EXSR      ZASNMS                                                      CGL01
     C                   MOVE      *ON           *IN99                                         CGL01
     C                   MOVE      *ON           *IN64                                         CGL01
     C                   ENDIF                                                                 CGL01
      *                                                                   CGL010
     C     DDTRCA        IFNE      WWTRCA                                                      CGL01
     C     *IN70         ANDEQ     *OFF                                                        CGL01
     C                   MOVEL     'USR8658'     ZAMSID                                        CGL01
     C                   EXSR      ZASNMS                                                      CGL01
     C                   MOVE      *ON           *IN99                                         CGL01
     C                   MOVE      *ON           *IN64                                         CGL01
     C                   ENDIF                                                                 CGL01
     C                   ENDIF                                                                 CGL01
     C                   ENDIF                                                                 CGL01
     C                   ENDIF                                                                 CGL01
      *                                                                   CGL010
     C                   MOVEL     WWACOD        @1DBRC                                        CGL01
     C                   ENDIF                                                                 CGL01
      *
      * Account Type
      * CASE: DTL.Account type is blank
     C     #1ACTY        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1ACTY        ZA0007                         Account type
      * Send message 'Account type is required'
     C                   MOVEL     'USR0994'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Account type is valid Account type
     C     #1ACTY        IFEQ      'D'                                          *IF
     C     #1ACTY        OREQ      'C'
     C     #1ACTY        OREQ      'G'
     C     #1ACTY        OREQ      'N'
     C     #1ACTY        OREQ      'R'
      * Start of Fix E21267 and E21390
      * If an 'R' is entered for account type and both retail and
      * interest on accounts are off send an error message
      * CASE: DTL.Account type is Retail Accounts
     C     #1ACTY        IFEQ      'R'                                          *IF
      * CASE: WRK.Retail Present is No
     C     WUREPR        IFEQ      'N'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1ACTY        ZA0008                         Account type
      * Send message 'Account Type can't be R'
     C                   MOVEL     'USR1516'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of Fix E21267 and E21390
      * Start of change 091322
      * Account section cannot be IN or EX for a retail account
      * CASE:
      *  - c1 AND c2 OR c1 AND c3
      *   |- c1    : DTL.Account type is Retail Accounts
      *   |- c2    : DTL.Account Section is Income
      *   |- c3    : DTL.Account Section is Expense
      *   '-
     C                   MOVEL     '0'           Y0CX01            1
     C     #1ACTY        IFEQ      'R'                                          *IF
     C     #1ACSC        IFEQ      'IN'                                         *IF
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     Y0CX01        IFNE      '1'                                          *IF
     C     #1ACTY        IFEQ      'R'                                          *IF
     C     #1ACSC        IFEQ      'EX'                                         *IF
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     Y0CX01        IFEQ      '1'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1ACTY        ZA0009                         Account type
      * Send message 'Retail ac not IN or EX'
     C                   MOVEL     'USR3030'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   END                                                    *FI
      * End of change 091322
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1ACTY        ZA0010                         Account type
      * Send message 'Invalid Account Type'
     C                   MOVEL     'USR0995'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Account Sub-type depends on Retail
      * CASE: DTL.Account type is Retail Accounts
     C     #1ACTY        IFEQ      'R'                                          *IF
      * CASE: DTL.Account Sub-type is blank
     C     #1ACST        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1ACST        ZA0011                         Account Sub-typ
      * Send message 'Sub-type is req.'
     C                   MOVEL     'USR0121'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Account Sub-type is valid sub-type
     C     #1ACST        IFEQ      'C'                                          *IF
     C     #1ACST        OREQ      'L'
     C     #1ACST        OREQ      'S'
      * Account sub-type 'V' or 'I' valid  if CGL037 is switched-ON                           CGL037
     C     CGL037        OREQ      'Y'
     C     #1ACST        ANDEQ     'V'
     C     CGL037        OREQ      'Y'
     C     #1ACST        ANDEQ     'I'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1ACST        ZA0012                         Account Sub-typ
      * Send message 'Invalid A/C Sub-type'
     C                   MOVEL     'USR0992'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      * Values 'V' and 'I' valid only if CGL037 is switched-ON                                CGL037
     C     #1ACST        IFEQ      'V'
     C     CGL037        ANDEQ     'N'
     C     #1ACST        OREQ      'I'
     C     CGL037        ANDEQ     'N'
     C                   MOVEL     'USR9840'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933
     C                   ENDIF
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Account Sub-type is blank
     C     #1ACST        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1ACST        ZA0013                         Account Sub-typ
      * Send message 'Sub-type Non-retail'
     C                   MOVEL     'USR0122'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Start CAC001
      * Man. Accounts Analysis by Profit Centre
      * CASE: WRK.CMC001 is Present
     C     WUCMC1        IFEQ      'Y'                                          *IF
      * CASE:
      *  - c1 AND c2
      *   |- c1    : WRK.Profit Centres Used is Yes
      *   |- c2    : WRK.Analytical Accounting is No
      *   '-
     C                   MOVEL     '0'           Y0CX01            1
     C     WUPRCU        IFEQ      'Y'                                          *IF
     C     WUN0ST        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     Y0CX01        IFEQ      '1'                                          *IF
      * CASE: DTL.Man A/C Anal Profit Cntr is Valid Values
     C     #1MAPC        IFEQ      'N'                                          *IF
     C     #1MAPC        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MAPC        ZA0014                         Man A/C Anal Pr
      * Send message 'Man Acc by Pft Cntr  INVD'
     C                   MOVEL     'USR2884'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End CAC001
      *-------------------------------------------------------------------CFT002
      * If Decode and AutoGen Feature is installed                        CFT002
      *                                                                   CFT002
     C     CFT002        IFEQ      'Y'                                          If Feature On  CFT00
      *                                                                   CFT002
      *- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -CFT002
      * Vostro A/C Flag Validation                                        CFT002
     C     #1VOST        IFEQ      ' '                                           And Not ' '
     C                   MOVEL     'N'           #1VOST                          And Not ' '
     C                   ENDIF                                                   And Not ' '
      *                                                                   CFT002
     C     #1VOST        IFNE      'Y'                                           If Not Y      CFT00
     C     #1VOST        ANDNE     'N'                                           And Not N     CFT00
     C                   MOVEL     #1VOST        ZA0133                           Set Msg Dta  CFT00
     C                   MOVEL     'USR0740'     ZAMSID                           Set Msg Id   CFT00
     C                   EXSR      ZASNMS                                         Rtv Msg Txt  CFT00
     C                   SETON                                        9959        Set Err Ind  CFT00
     C                   ENDIF                                                   End If        CFT00
      *- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -CFT002
      * Loro A/C Flag Validation                                          CFT002
     C     #1LORO        IFEQ      ' '                                           And Not ' '
     C                   MOVEL     'N'           #1LORO                          And Not ' '
     C                   ENDIF                                                   And Not ' '
      *                                                                   CFT002
     C     #1LORO        IFNE      'Y'                                           If Not Y      CFT00
     C     #1LORO        ANDNE     'N'                                           And Not N     CFT00
     C                   MOVEL     #1LORO        ZA0134                           Set Msg Dta  CFT00
     C                   MOVEL     'USR0740'     ZAMSID                           Set Msg Id   CFT00
     C                   EXSR      ZASNMS                                         Rtv Msg Txt  CFT00
     C                   SETON                                        9960        Set Err Ind  CFT00
     C                   ENDIF                                                   End If        CFT00
     C                   ENDIF                                                  End If         CFT00
      *                                                                   CPB004
      * If "Account closing" CPB004 is installed                          CPB004
     C     WPB004        IFEQ      'Y'                                                         CPB00
      *                                                                   CPB004
     C     P2ANCD        IFEQ      'I'                                          *B1            CPB00
      *                                                                   CPB004
      * If the account type is not 'General Ledger'                       CPB004
     C     #1ACTY        IFNE      'G'                                          *B2            CPB00
      *                                                                   CPB004
      *  If the account type is 'Retail' ledger                           CPB004
      *  it must be to transfer to ToF                                    CPB004
     C     #1ACTY        IFEQ      'R'                                          *B3            CPB00
     C                   MOVE      'Y'           #1TRAN                                        CPB00
     C                   ELSE                                                   *X3            CPB00
     C                   MOVE      'N'           #1TRAN                                        CPB00
     C                   END                                                    *E3            CPB00
      *                                                                   CPB004
      *  the account type is 'General Ledger'                             CPB004
     C                   ELSE                                                   *X2            CPB00
      *                                                                   CPB004
      *  Default value is 'N'                                             CPB004
      *                                                                   CPB004
     C     #1TRAN        IFEQ      *BLANKS                                      *B3            CPB00
     C                   MOVE      'N'           #1TRAN                                        CPB00
     C                   ELSE                                                   *X3            CPB00
      *                                                                   CPB004
      *  Valid value is 'N' or 'Y'                                        CPB004
     C     #1TRAN        IFNE      'Y'                                          *B4            CPB00
     C     #1TRAN        ANDNE     'N'                                                         CPB00
     C                   MOVEL     'USR3163'     ZAMSID                                        CPB00
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                                        CPB00
     C                   MOVEL     #1TRAN        ZAMSDA                                        CPB00
     C                   EXSR      ZASNMS                                                      CPB00
     C                   SETON                                        9967                     CPB00
     C                   MOVEL     *BLANKS       ZAMSGF                                        CPB00
     C                   ELSE                                                   *E4            CPB00
     C     #1TRAN        IFEQ      'Y'                                          *B5            CPB00
     C                   CALL      'PB7201'                                                    CPB00
     C                   PARM                    #1ACCD                                        CPB00
     C                   END                                                    *E5            CPB00
     C                   END                                                    *E4            CPB00
     C                   END                                                    *E3            CPB00
     C                   END                                                    *E2            CPB00
     C                   END                                                    *E1            CPB00
      *                                                                   CPB004
     C     P2ANCD        IFEQ      'A'                                          *B1            CPB00
      *  Default value: Y for a Retail Account                            CPB004
      *                 N for other                                       CPB004
     C     #1TRAN        IFEQ      *BLANKS                                      *B2            CPB00
     C     A5TRAN        ANDEQ     *BLANKS                                                     CPB00
     C     #1ACTY        IFEQ      'R'                                          *B3            CPB00
     C                   MOVE      'Y'           #1TRAN                                        CPB00
     C                   ELSE                                                   *X3            CPB00
     C                   MOVE      'N'           #1TRAN                                        CPB00
     C                   END                                                    *E3            CPB00
     C                   ELSE                                                   *X2            CPB00
      *  If the account type is 'Retail' ledger                           CPB004
      *  it must be to transfer to ToF                                    CPB004
     C     #1ACTY        IFEQ      'R'                                          *B3            CPB00
     C     #1TRAN        IFNE      'Y'                                          *B4            CPB00
     C                   MOVEL     'USR3165'     ZAMSID                                        CPB00
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                                        CPB00
     C                   MOVEL     #1TRAN        ZAMSDA                                        CPB00
     C                   EXSR      ZASNMS                                                      CPB00
     C                   SETON                                        9967                     CPB00
     C                   MOVEL     *BLANKS       ZAMSGF                                        CPB00
     C                   ENDIF                                                  *E4            CPB00
     C                   ENDIF                                                  *E3            CPB00
      *                                                                   CPB004
      ** Only possible to transfer to ToF,                                CPB004
      ** if the account type is 'General Ledger'                          CPB004
      *                                                                   CPB004
     C     #1ACTY        IFEQ      'G'                                          *B3            CPB00
      *                                                                   CPB004
      ** Must be a valid Field                                            CPB004
     C     #1TRAN        IFNE      'Y'                                          *B4            CPB00
     C     #1TRAN        ANDNE     'N'                                                         CPB00
     C                   MOVEL     'USR3163'     ZAMSID                                        CPB00
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                                        CPB00
     C                   MOVEL     #1TRAN        ZAMSDA                                        CPB00
     C                   EXSR      ZASNMS                                                      CPB00
     C                   SETON                                        9967                     CPB00
     C                   MOVEL     *BLANKS       ZAMSGF                                        CPB00
     C                   ELSE                                                   *X4            CPB00
     C     #1TRAN        IFEQ      'Y'                                          *B5            CPB00
     C     #1TRAN        ANDNE     A5TRAN                                                      CPB00
     C                   CALL      'PB7201'                                                    CPB00
     C                   PARM                    #1ACCD                                        CPB00
     C                   END                                                    *E5            CPB00
      *                                                                   CPB004
      **  Transfer field can be changed from 'Y' to 'N'                   CPB004
      **  only if all account with this account code have                 CPB004
      **  a balance equal to zero                                         CPB004
      *                                                                   CPB004
     C     #1TRAN        IFEQ      'N'                                          *B5            CPB00
     C     #1TRAN        ANDNE     A5TRAN                                                      CPB00
      *                                                                   CPB004
      **  Main loop processing                                            CPB004
     C**********           MOVEL#1ACCD    KACOD   40                                   CPB004 CAS010
     C********** KACOD     SETLLACACOD                                                 CPB004 CAS010
     C********** KACOD     READEACACOD                   80                            CPB004 CAS010
     C                   MOVEL     #1ACCD        KACOD@           10 0
     C     KACOD@        SETLL     ACACOD
     C     KACOD@        READE     ACACOD                                 80
     C     *IN80         DOWEQ     *OFF                                                        CPB00
      *                                                                   CPB004
     C     LDBL          IFNE      *ZERO                                        *B6            CPB00
     C     CLBL          ANDNE     *ZERO                                                       CPB00
     C                   MOVEL     'USR3164'     ZAMSID                                        CPB00
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                                        CPB00
     C                   MOVEL     #1TRAN        ZAMSDA                                        CPB00
     C                   EXSR      ZASNMS                                                      CPB00
     C                   SETON                                        9967                     CPB00
     C                   MOVEL     *BLANKS       ZAMSGF                                        CPB00
     C                   END                                                    *E6            CPB00
      *                                                                   CPB004
      **  Read next record                                                CPB004
     C********** KACOD     READEACACOD                   80                            CPB004 CAS010
     C     KACOD@        READE     ACACOD                                 80
     C                   ENDDO                                                                 CPB00
     C                   END                                                    *E5            CPB00
     C                   END                                                    *E4            CPB00
     C                   END                                                    *E3            CPB00
     C                   END                                                    *E2            CPB00
     C                   END                                                    *E1            CPB00
      *                                                                   CPB004
      **  End check if CPB004 is installed                                CPB004
     C                   END                                                                   CPB00
      *                                                                   CPB004
      * Account Section
      * CASE: DTL.Account Section is blank
     C     #1ACSC        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1ACSC        ZA0015                         Account Section
      * Send message 'Account Section is req.'
     C                   MOVEL     'USR1001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Account Section is valid values
     C     #1ACSC        IFEQ      'AS'                                         *IF
     C     #1ACSC        OREQ      'CN'
     C     #1ACSC        OREQ      'CO'
     C     #1ACSC        OREQ      'EX'
     C     #1ACSC        OREQ      'IN'
     C     #1ACSC        OREQ      'LI'
     C     #1ACSC        OREQ      'ME'
     C     #1ACSC        OREQ      'TR'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1ACSC        ZA0016                         Account Section
      * Send message 'Invalid Account Section'
     C                   MOVEL     'USR1002'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   END                                                    *FI
      * Start of change 091322
      * Account section cannot be IN or EX for a retail account
      * CASE:
      *  - c1 AND c2 OR c1 AND c3
      *   |- c1    : DTL.Account type is Retail Accounts
      *   |- c2    : DTL.Account Section is Income
      *   |- c3    : DTL.Account Section is Expense
      *   '-
     C                   MOVEL     '0'           Y0CX01            1
     C     #1ACTY        IFEQ      'R'                                          *IF
     C     #1ACSC        IFEQ      'IN'                                         *IF
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     Y0CX01        IFNE      '1'                                          *IF
     C     #1ACTY        IFEQ      'R'                                          *IF
     C     #1ACSC        IFEQ      'EX'                                         *IF
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     Y0CX01        IFEQ      '1'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1ACSC        ZA0017                         Account Section
      * Send message 'A/c sectn IN or EX not R'
     C                   MOVEL     'USR3031'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   END                                                    *FI
      * End of change 091322
     C                   END                                                    *FI
      * Start CAC001
      * Man. Accounts Analysis by Book
      * CASE: WRK.CMC001 is Present
     C     WUCMC1        IFEQ      'Y'                                          *IF
      * CASE: DTL.Man A/C Anal Book is Valid Values
     C     #1MABK        IFEQ      'N'                                          *IF
     C     #1MABK        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MABK        ZA0018                         Man A/C Anal Bo
      * Send message 'Man Acc Anal by Book INVD'
     C                   MOVEL     'USR2881'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End CAC001
      * Post retention period
      * CASE: DTL.A/c Posting Ret Pd  Alpha is Not equal to Blank
     C     #DAPRA        IFNE      *BLANK                                       *IF
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DAPRA        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0035            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0036           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0037            1 0          ZALIGN No Of De
     C                   PARM      2             WQ0038            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0039           16            ZALIGN File Fie
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
     C     WUZASF        PARM      WUZASF        WQ0040           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0041            1 0          ZALIGN No Of De
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
     C                   MOVEL     #DAPRA        ZA0019                         A/c Posting Ret
      * Send message 'A/c Posting Ret Numeric'
     C                   MOVEL     'USR1239'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * Zalign Post Retention Prd - Account Codes  *
     C* Zalign A/c Posting Ret Prd
     C                   MOVE      WUZASF        #DAPRA
     C                   MOVE      WUZAFF        #1ACPR                         Acct Post Reten
      * Fetch Retention Period - General Ledger Details  *
     C                   EXSR      SBRVGN
      * CASE: DTL.Acct Post Retention Prd is Equal Zero
     C     #1ACPR        IFEQ      *ZERO                                        *IF
      * Setup message data for message
     C                   MOVEL     #DAPRA        ZA0021                         A/c Posting Ret
      * Send message 'A/c Post Retention GT 0'
     C                   MOVEL     'USR1254'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: DTL.Acct Post Retention Prd GE WRK.A/c Posting Retention Pd
     C     #1ACPR        IFGE      WUAPRP                                       *IF
      * Setup message data for message
     C                   MOVEL     #DAPRA        ZA0022                         A/c Posting Ret
     C                   Z-ADD     WUAPRP        ZA0023                         A/c Posting Ret
      * Send message 'Not GE than GL ICD Ret Pd'
     C                   MOVEL     'USR0637'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   Z-ADD     *ZERO         #1ACPR                         Acct Post Reten
     C                   END                                                    *FI
      * End of fix S01117
      * Start CAC001
      * Man. Accounts Analysis by Assoc. Customer
      * CASE: WRK.CMC001 is Present
     C     WUCMC1        IFEQ      'Y'                                          *IF
      * CASE: DTL.Man A/C Anal Ass Cust is Valid values
     C     #1MAAC        IFEQ      'Y'                                          *IF
     C     #1MAAC        OREQ      'N'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MAAC        ZA0024                         Man A/C Anal As
      * Send message 'Man Acc Anal by AsCst INV'
     C                   MOVEL     'USR2882'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End CAC001
      * Start of SAR S01309
      * Validate Title Only Indicator
      * CASE: PAR.Action Code is Amend
     C     P2ANCD        IFEQ      'A'                                          *IF
      * CASE: DTL.Title Only Indicator NE WRK.Title Only func
     C     #1TOIN        IFNE      WUTIOF                                       *IF
      * CASE: WRK.Set Up Complete is No
     C     WUSUC         IFEQ      'N'                                          *IF
      * CASE: DTL.Title Only Indicator is Valid values
     C     #1TOIN        IFEQ      'N'                                          *IF
     C     #1TOIN        OREQ      'Y'
     C                   ELSE
      * CASE: DTL.Title Only Indicator is Blank
     C     #1TOIN        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1TOIN        ZA0025                         Title Only Indi
      * Send message 'Invalid Title Indicator'
     C                   MOVEL     'USR0996'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1TOIN        ZA0026                         Title Only Indi
      * Send message 'Title Only cannot be chgd'
     C                   MOVEL     'USR1565'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
      * CASE: DTL.Title Only Indicator is Valid values
     C     #1TOIN        IFEQ      'N'                                          *IF
     C     #1TOIN        OREQ      'Y'
     C                   ELSE
      * CASE: DTL.Title Only Indicator is Blank
     C     #1TOIN        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1TOIN        ZA0027                         Title Only Indi
      * Send message 'Invalid Title Indicator'
     C                   MOVEL     'USR0996'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of SAR S01309
      * Start CAC001
      * Man. Accounts Analysis by Product
      * CASE: WRK.CMC001 is Present
     C     WUCMC1        IFEQ      'Y'                                          *IF
      * CASE: DTL.Man A/C Anal Prod is Valid Values
     C     #1MAPR        IFEQ      'N'                                          *IF
     C     #1MAPR        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1MAPR        ZA0028                         Man A/C Anal Pr
      * Send message 'Man Acc Anal by Prod INVD'
     C                   MOVEL     'USR2883'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9940      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End CAC001
      * Start of SAR S01212
      * 00/Copy Member SD0031RVSF - Account Codes  *
     C*
     C/COPY WNCPYSRC,SD0031RVSF
     C*
      * End of SAR S01212
      * Check relations
      * CALC: Detail screen function fields
      * Start of SAR S01212
      * 00/Copy Member SD0031RSFF - Account Codes  *
     C*
     C/COPY WNCPYSRC,SD0031RSFF
     C*
      * End of SAR S01212
      * USER: Validate detail screen relations
      * Start of Fix S01117
      * Retail Only: Account codes
      * Debt Interest Accrual Debit
      * CASE: DTL.Account type is Retail Accounts
     C     #1ACTY        IFEQ      'R'                                          *IF
      * CASE: DTL.Debt Interest Accrual Dr. is blank
     C     #1DIAD        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1DIAD        ZA0029                         Debt Interest A
      * Send message 'Debit Int Debit Retail'
     C                   MOVEL     'USR0123'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9941      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1DIAD        WUACCD                         Account Code
      * Check A/c Code Numeric - Account Codes  *
      * Check Account code is number
     C                   MOVEL     *IN90         XG90              1            * Save *IN90
     C*********************TESTN          WUAFNB     90  90* Check numericS01229
     C***90****************MOVE WUAFNB    XGX1    1        Check +ve      S01229
     C                   TESTN                   WUACCD               90  90    * Check numericS0122
     C   90              MOVE      WUACCD        XGX1              1            Check +ve      S0122
     C   90              TESTB     '0123'        XGX1                     90    *
     C**N90****************MOVELWUAFNB    XGX1                            S01229
     C  N90              MOVEL     WUACCD        XGX1                                          S0122
     C  N90XGX1          COMP      '?'                                    90    * ? is OK
      *
      * Set up flag - alphanumeric
     C     *IN90         IFEQ      '0'
     C*********************MOVE 'N'       WUFEST                          S01229
     C                   MOVE      'N'           WUNMFL                                        S0122
     C                   END
      *
      * Set up flag - numeric/select
     C     *IN90         IFEQ      '1'
      *
     C     XGX1          IFEQ      '?'
     C*********************MOVE '?'       WUFEST                          S01229
     C                   MOVE      '?'           WUNMFL                                        S0122
     C                   ELSE
     C*********************MOVE 'Y'       WUFEST                          S01229
     C                   MOVE      'Y'           WUNMFL                                        S0122
     C                   END
      *
     C                   END
      *
     C                   MOVEL     XG90          *IN90                          * Restore *IN90
      * Select Request
      * CASE: WRK.Numeric flag is Select request
     C     WUNMFL        IFEQ      '?'                                          *IF
      * Select Account Codes - Account Codes  *
     C                   CALL      'SD0031S'                            90      Select Account
     C                   PARM      *BLANK        W0RTN             7
     C********** #1DIAD    PARM #1DIAD    WQ0042  4        Account Code                       CGL029
     C     #1DIAD        PARM      #1DIAD        WQ0042           10
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
     C                   SETON                                        9941      *
     C                   END
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   MOVEL     'Y'           WUNMFL                         Numeric flag
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Numeric
     C     WUNMFL        IFEQ      'Y'                                          *IF
      * Start of 057868 retrieve title only indicator for account code
      * Start of CRE002
      * Get A/C cde, Type & Sctn - Account Codes  *
     C                   EXSR      SCRVGN
      * End of CRE002
      * End of 057868
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1DIAD        ZA0030                         Debt Interest A
      * Send message 'A/C Code NF - Highlight'
     C                   MOVEL     'USR0173'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9941      *
      *
     C                   ELSE
      * CASE: DTL.Account Code EQ DTL.Debt Interest Accrual Dr.
     C     #1ACCD        IFEQ      #1DIAD                                       *IF
      * Setup message data for message
     C                   MOVEL     #1DIAD        ZA0031                         Debt Interest A
      * Send message 'Self Ref Debt Int a/c Dr'
     C                   MOVEL     'USR1245'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9941      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: WRK.Account type is Retail Accounts
     C     WUACTY        IFEQ      'R'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1DIAD        ZA0032                         Debt Interest A
      * Send message 'Account code mustn't be R'
     C                   MOVEL     'USR0176'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9941      *
      *
     C                   END                                                    *FI
      * Start of 057868 - account cannot be title only
      * CASE: WRK.Title Only Indicator is YES
     C     WUTOIN        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1DIAD        ZA0033                         Debt Interest A
      * Send message 'Account code mustn't be t'
     C                   MOVEL     'USR0221'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9941      *
      *
     C                   END                                                    *FI
      * End of 057868
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Alpha-numeric
     C     WUNMFL        IFEQ      'N'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1DIAD        ZA0034                         Debt Interest A
      * Send message 'Invalid Account Code'
     C                   MOVEL     'USR0183'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9941      *
      *
     C                   END                                                    *FI
      * Start of CRE002
      * Debit Interest Accrued Dr.
      * CASE: WRK.CRE002 is Present
     C     WURAPE        IFEQ      'Y'                                          *IF
      * CASE:
      *  - c1 OR c2
      *   |- c1    : WRK.Account Section is Income
      *   |- c2    : WRK.Account Section is Expense
      *   '-
     C     WUACSC        IFEQ      'IN'                                         *IF
     C     WUACSC        OREQ      'EX'                                         *OR
      * Setup message data for message
     C                   MOVEL     #1DIAD        ZA0035                         Debt Interest A
      * Send message 'A/C Sctn not  IN  or EX'
     C                   MOVEL     'USR3202'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9941      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of CRE002
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Debt Interest Accrual Dr. is Non-blank
     C     #1DIAD        IFNE      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1DIAD        ZA0036                         Debt Interest A
      * Send message 'Debit Int Debit Non-Rtl'
     C                   MOVEL     'USR0125'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9941      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Debt Interest Accrual Credit
      * CASE: DTL.Account type is Retail Accounts
     C     #1ACTY        IFEQ      'R'                                          *IF
      * CASE: DTL.Debt Interest Accrual Cr. is blank
     C     #1DIAC        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1DIAC        ZA0037                         Debt Interest A
      * Send message 'Debit Int Credit Retail'
     C                   MOVEL     'USR0124'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9942      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1DIAC        WUACCD                         Account Code
      * Check A/c Code Numeric - Account Codes  *
     C                   MOVEL     *IN90         XG90              1            * Save *IN90
     C*********************TESTN          WUAFNB     90  90* Check numericS01229
     C***90****************MOVE WUAFNB    XGX1    1        Check +ve      S01229
     C                   TESTN                   WUACCD               90  90    * Check numericS0122
     C   90              MOVE      WUACCD        XGX1              1            Check +ve      S0122
     C   90              TESTB     '0123'        XGX1                     90    *
     C**N90****************MOVELWUAFNB    XGX1                            S01229
     C  N90              MOVEL     WUACCD        XGX1                                          S0122
     C  N90XGX1          COMP      '?'                                    90    * ? is OK
     C     *IN90         IFEQ      '0'
     C*********************MOVE 'N'       WUFEST                          S01229
     C                   MOVE      'N'           WUNMFL                                        S0122
     C                   END
     C     *IN90         IFEQ      '1'
     C     XGX1          IFEQ      '?'
     C*********************MOVE '?'       WUFEST                          S01229
     C                   MOVE      '?'           WUNMFL                                        S0122
     C                   ELSE
     C*********************MOVE 'Y'       WUFEST                          S01229
     C                   MOVE      'Y'           WUNMFL                                        S0122
     C                   END
     C                   END
     C                   MOVEL     XG90          *IN90                          * Restore *IN90
      * Select Request
      * CASE: WRK.Numeric flag is Select request
     C     WUNMFL        IFEQ      '?'                                          *IF
      * Select Account Codes - Account Codes  *
     C                   CALL      'SD0031S'                            90      Select Account
     C                   PARM      *BLANK        W0RTN             7
     C********** #1DIAC    PARM #1DIAC    WQ0043  4        Account Code                       CGL029
     C     #1DIAC        PARM      #1DIAC        WQ0043           10
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
     C                   SETON                                        9942      *
     C                   END
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   MOVEL     'Y'           WUNMFL                         Numeric flag
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Numeric
     C     WUNMFL        IFEQ      'Y'                                          *IF
      * Start of 057868 - retrieve title only indicator
      * Start of CRE002
      * Get A/C cde, Type & Sctn - Account Codes  *
     C                   EXSR      SDRVGN
      * End of CRE002
      * End of 057868
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1DIAC        ZA0038                         Debt Interest A
      * Send message 'A/C Code NF - Highlight'
     C                   MOVEL     'USR0173'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9942      *
      *
     C                   ELSE
      * CASE: DTL.Account Code EQ DTL.Debt Interest Accrual Cr.
     C     #1ACCD        IFEQ      #1DIAC                                       *IF
      * Setup message data for message
     C                   MOVEL     #1DIAC        ZA0039                         Debt Interest A
      * Send message 'Self Ref Debt Int a/c Cr'
     C                   MOVEL     'USR1246'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9942      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: WRK.Account type is Retail Accounts
     C     WUACTY        IFEQ      'R'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1DIAC        ZA0040                         Debt Interest A
      * Send message 'Account code mustn't be R'
     C                   MOVEL     'USR0176'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9942      *
      *
     C                   END                                                    *FI
      * Start of 057868 - account cannot be title only
      * CASE: WRK.Title Only Indicator is YES
     C     WUTOIN        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1DIAC        ZA0041                         Debt Interest A
      * Send message 'Account code mustn't be t'
     C                   MOVEL     'USR0221'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9942      *
      *
     C                   END                                                    *FI
      * End of 057868
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Alpha-numeric
     C     WUNMFL        IFEQ      'N'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1DIAC        ZA0042                         Debt Interest A
      * Send message 'Invalid Account Code'
     C                   MOVEL     'USR0183'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9942      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Start of CRE002
      * Debit Interest Accrued
      * CASE: WRK.CRE002 is Present
     C     WURAPE        IFEQ      'Y'                                          *IF
      * CASE:
      *  - c1 OR c2
      *   |- c1    : WRK.Account Section is Income
      *   |- c2    : WRK.Account Section is Expense
      *   '-
     C     WUACSC        IFEQ      'IN'                                         *IF
     C     WUACSC        OREQ      'EX'                                         *OR
      * Setup message data for message
     C                   MOVEL     #1DIAC        ZA0043                         Debt Interest A
      * Send message 'A/C Sctn not IN or EX'
     C                   MOVEL     'USR3203'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9942      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of CRE002
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Debt Interest Accrual Cr. is Non-blank
     C     #1DIAC        IFNE      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1DIAC        ZA0044                         Debt Interest A
      * Send message 'Debit Int Credit Non-Rtl'
     C                   MOVEL     'USR0126'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9942      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Credit Interest Accrual Debit
      * CASE: DTL.Account type is Retail Accounts
     C     #1ACTY        IFEQ      'R'                                          *IF
      * CASE: DTL.Credit Int. Accrual Dr. is blank
     C     #1CIAD        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1CIAD        ZA0045                         Credit Int. Acc
      * Send message 'Credit Int Debit Retail'
     C                   MOVEL     'USR0129'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9943      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1CIAD        WUACCD                         Account Code
      * Check A/c Code Numeric - Account Codes  *
     C                   MOVEL     *IN90         XG90              1            * Save *IN90
     C*********************TESTN          WUAFNB     90  90* Check numericS01229
     C***90****************MOVE WUAFNB    XGX1    1        Check +ve      S01229
     C                   TESTN                   WUACCD               90  90    * Check numericS0122
     C   90              MOVE      WUACCD        XGX1              1            Check +ve      S0122
     C   90              TESTB     '0123'        XGX1                     90    *
     C**N90****************MOVELWUAFNB    XGX1                            S01229
     C  N90              MOVEL     WUACCD        XGX1                                          S0122
     C  N90XGX1          COMP      '?'                                    90    * ? is OK
     C     *IN90         IFEQ      '0'
     C*********************MOVE 'N'       WUFEST                          S01229
     C                   MOVE      'N'           WUNMFL                                        S0122
     C                   END
     C     *IN90         IFEQ      '1'
     C     XGX1          IFEQ      '?'
     C*********************MOVE '?'       WUFEST                          S01229
     C                   MOVE      '?'           WUNMFL                                        S0122
     C                   ELSE
     C*********************MOVE 'Y'       WUFEST                          S01229
     C                   MOVE      'Y'           WUNMFL                                        S0122
     C                   END
     C                   END
     C                   MOVEL     XG90          *IN90                          * Restore *IN90
      * Select Request
      * CASE: WRK.Numeric flag is Select request
     C     WUNMFL        IFEQ      '?'                                          *IF
      * Select Account Codes - Account Codes  *
     C                   CALL      'SD0031S'                            90      Select Account
     C                   PARM      *BLANK        W0RTN             7
     C********** #1CIAD    PARM #1CIAD    WQ0044  4        Account Code                       CGL029
     C     #1CIAD        PARM      #1CIAD        WQ0044           10            Account Code
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
     C                   SETON                                        9943      *
     C                   END
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   MOVEL     'Y'           WUNMFL                         Numeric flag
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Numeric
     C     WUNMFL        IFEQ      'Y'                                          *IF
      * Start of 057868 - retrieve title only indicator for account
      * Start of CRE002
      * Get A/C cde, Type & Sctn - Account Codes  *
     C                   EXSR      SERVGN
      * End of CRE002
      * End of 057868
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1CIAD        ZA0046                         Credit Int. Acc
      * Send message 'A/C Code NF - Highlight'
     C                   MOVEL     'USR0173'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9943      *
      *
     C                   ELSE
      * CASE: DTL.Account Code EQ DTL.Credit Int. Accrual Dr.
     C     #1ACCD        IFEQ      #1CIAD                                       *IF
      * Setup message data for message
     C                   MOVEL     #1CIAD        ZA0047                         Credit Int. Acc
      * Send message 'Self Ref Cred Int a/c Dr'
     C                   MOVEL     'USR1247'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9943      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: WRK.Account type is Retail Accounts
     C     WUACTY        IFEQ      'R'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CIAD        ZA0048                         Credit Int. Acc
      * Send message 'Account code mustn't be R'
     C                   MOVEL     'USR0176'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9943      *
      *
     C                   END                                                    *FI
      * Start of 057868 - account cannot be title only
      * CASE: WRK.Title Only Indicator is YES
     C     WUTOIN        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CIAD        ZA0049                         Credit Int. Acc
      * Send message 'Account code mustn't be t'
     C                   MOVEL     'USR0221'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9943      *
      *
     C                   END                                                    *FI
      * End of 057868
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Alpha-numeric
     C     WUNMFL        IFEQ      'N'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CIAD        ZA0050                         Credit Int. Acc
      * Send message 'Invalid Account Code'
     C                   MOVEL     'USR0183'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9943      *
      *
     C                   END                                                    *FI
      * Start of CRE002
      * Credit Interest Accrued
      * CASE: WRK.CRE002 is Present
     C     WURAPE        IFEQ      'Y'                                          *IF
      * CASE:
      *  - c1 OR c2
      *   |- c1    : WRK.Account Section is Income
      *   |- c2    : WRK.Account Section is Expense
      *   '-
     C     WUACSC        IFEQ      'IN'                                         *IF
     C     WUACSC        OREQ      'EX'                                         *OR
      * Setup message data for message
     C                   MOVEL     #1CIAD        ZA0051                         Credit Int. Acc
      * Send message 'A/C Sctn may no be IN/EX'
     C                   MOVEL     'USR3204'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9943      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of CRE002
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Credit Int. Accrual Dr. A is Non-blank
     C     #1CIAD        IFNE      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1CIAD        ZA0052                         Credit Int. Acc
      * Send message 'Credit Int Debit Non-Rtl'
     C                   MOVEL     'USR0130'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9943      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Credit Interest Accrual Credit
      * CASE: DTL.Account type is Retail Accounts
     C     #1ACTY        IFEQ      'R'                                          *IF
      * CASE: DTL.Credit Int. Accrual Cr. is blank
     C     #1CIAC        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1CIAC        ZA0053                         Credit Int. Acc
      * Send message 'Credit Int Credit Retail'
     C                   MOVEL     'USR0127'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9944      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1CIAC        WUACCD                         Account Code
      * Check A/c Code Numeric - Account Codes  *
     C                   MOVEL     *IN90         XG90              1            * Save *IN90
     C*********************TESTN          WUAFNB     90  90* Check numericS01229
     C***90****************MOVE WUAFNB    XGX1    1        Check +ve      S01229
     C                   TESTN                   WUACCD               90  90    * Check numericS0122
     C   90              MOVE      WUACCD        XGX1              1            Check +ve      S0122
     C   90              TESTB     '0123'        XGX1                     90    *
     C**N90****************MOVELWUAFNB    XGX1                            S01229
     C  N90              MOVEL     WUACCD        XGX1                                          S0122
     C  N90XGX1          COMP      '?'                                    90    * ? is OK
     C     *IN90         IFEQ      '0'
     C*********************MOVE 'N'       WUFEST                          S01229
     C                   MOVE      'N'           WUNMFL                                        S0122
     C                   END
     C     *IN90         IFEQ      '1'
     C     XGX1          IFEQ      '?'
     C*********************MOVE '?'       WUFEST                          S01229
     C                   MOVE      '?'           WUNMFL                                        S0122
     C                   ELSE
     C*********************MOVE 'Y'       WUFEST                          S01229
     C                   MOVE      'Y'           WUNMFL                                        S0122
     C                   END
     C                   END
     C                   MOVEL     XG90          *IN90                          * Restore *IN90
      * Select Processing
      * CASE: WRK.Numeric flag is Select request
     C     WUNMFL        IFEQ      '?'                                          *IF
      * Select Account Codes - Account Codes  *
     C                   CALL      'SD0031S'                            90      Select Account
     C                   PARM      *BLANK        W0RTN             7
     C********** #1CIAC    PARM #1CIAC    WQ0045  4        Account Code                       CGL029
     C     #1CIAC        PARM      #1CIAC        WQ0045           10            Account Code
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
     C                   SETON                                        9944      *
     C                   END
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   MOVEL     'Y'           WUNMFL                         Numeric flag
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Numeric
     C     WUNMFL        IFEQ      'Y'                                          *IF
      * Start of 057868 - get title only indicator
      * Start of CRE002
      * Get A/C cde, Type & Sctn - Account Codes  *
     C                   EXSR      SFRVGN
      * Start of CRE002
      * End of 057868
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1CIAC        ZA0054                         Credit Int. Acc
      * Send message 'A/C Code NF - Highlight'
     C                   MOVEL     'USR0173'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9944      *
      *
     C                   ELSE
      * CASE: DTL.Account Code EQ DTL.Credit Int. Accrual Cr.
     C     #1ACCD        IFEQ      #1CIAC                                       *IF
      * Setup message data for message
     C                   MOVEL     #1CIAC        ZA0055                         Credit Int. Acc
      * Send message 'Self Ref Cred Int a/c Cr'
     C                   MOVEL     'USR1248'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9944      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: WRK.Account type is Retail Accounts
     C     WUACTY        IFEQ      'R'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CIAC        ZA0056                         Credit Int. Acc
      * Send message 'Account code mustn't be R'
     C                   MOVEL     'USR0176'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9944      *
      *
     C                   END                                                    *FI
      * Start of 057868 - account cannot be title only
      * CASE: WRK.Title Only Indicator is YES
     C     WUTOIN        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CIAC        ZA0057                         Credit Int. Acc
      * Send message 'Account code mustn't be t'
     C                   MOVEL     'USR0221'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9944      *
      *
     C                   END                                                    *FI
      * End of 057868
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Alpha-numeric
     C     WUNMFL        IFEQ      'N'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CIAC        ZA0058                         Credit Int. Acc
      * Send message 'Invalid Account Code'
     C                   MOVEL     'USR0183'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9944      *
      *
     C                   END                                                    *FI
      * Start of CRE002
      * Credit Interest Accrued CR
      * CASE: WRK.CRE002 is Present
     C     WURAPE        IFEQ      'Y'                                          *IF
      * CASE:
      *  - c1 OR c2
      *   |- c1    : WRK.Account Section is Income
      *   |- c2    : WRK.Account Section is Expense
      *   '-
     C     WUACSC        IFEQ      'IN'                                         *IF
     C     WUACSC        OREQ      'EX'                                         *OR
      * Setup message data for message
     C                   MOVEL     #1CIAC        ZA0059                         Credit Int. Acc
      * Send message 'A/C Sctn may not be IN/EX'
     C                   MOVEL     'USR3205'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9944      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of CRE002
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Credit Int. Accrual Cr. is Non-blank
     C     #1CIAC        IFNE      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1CIAC        ZA0060                         Credit Int. Acc
      * Send message 'Credit Int Credit Non-Rtl'
     C                   MOVEL     'USR0128'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9944      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Interest Capital in Debit
      * CASE: DTL.Account type is Retail Accounts
     C     #1ACTY        IFEQ      'R'                                          *IF
      * CASE: DTL.Interest Capital in Debt is blank
     C     #1ICID        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1ICID        ZA0061                         Interest Capita
      * Send message 'Int Cap. Debit Retail'
     C                   MOVEL     'USR0133'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9945      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1ICID        WUACCD                         Account Code
      * Check A/c Code Numeric - Account Codes  *
     C                   MOVEL     *IN90         XG90              1            * Save *IN90
     C*********************TESTN          WUAFNB     90  90* Check numericS01229
     C***90****************MOVE WUAFNB    XGX1    1        Check +ve      S01229
     C                   TESTN                   WUACCD               90  90    * Check numericS0122
     C   90              MOVE      WUACCD        XGX1              1            Check +ve      S0122
     C   90              TESTB     '0123'        XGX1                     90    *
     C**N90****************MOVELWUAFNB    XGX1                            S01229
     C  N90              MOVEL     WUACCD        XGX1                                          S0122
     C  N90XGX1          COMP      '?'                                    90    * ? is OK
     C     *IN90         IFEQ      '0'
     C*********************MOVE 'N'       WUFEST                          S01229
     C                   MOVE      'N'           WUNMFL                                        S0122
     C                   END
     C     *IN90         IFEQ      '1'
     C     XGX1          IFEQ      '?'
     C*********************MOVE '?'       WUFEST                          S01229
     C                   MOVE      '?'           WUNMFL                                        S0122
     C                   ELSE
     C*********************MOVE 'Y'       WUFEST                          S01229
     C                   MOVE      'Y'           WUNMFL                                        S0122
     C                   END
     C                   END
     C                   MOVEL     XG90          *IN90                          * Restore *IN90
      * Select Request
      * CASE: WRK.Numeric flag is Select request
     C     WUNMFL        IFEQ      '?'                                          *IF
      * Select Account Codes - Account Codes  *
     C                   CALL      'SD0031S'                            90      Select Account
     C                   PARM      *BLANK        W0RTN             7
     C********** #1ICID    PARM #1ICID    WQ0046  4        Account Code                       CGL029
     C     #1ICID        PARM      #1ICID        WQ0046           10
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
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   MOVEL     'Y'           WUNMFL                         Numeric flag
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Numeric
     C     WUNMFL        IFEQ      'Y'                                          *IF
      * Start of 057868 - get title only indicator
      * Start of CRE002
      * Get A/C cde, Type & Sctn - Account Codes  *
     C                   EXSR      SGRVGN
      * End of CRE002
      * End of 057868
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1ICID        ZA0062                         Interest Capita
      * Send message 'A/C Code NF - Highlight'
     C                   MOVEL     'USR0173'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9945      *
      *
     C                   ELSE
      * CASE: DTL.Account Code EQ DTL.Interest Capital in Debt
     C     #1ACCD        IFEQ      #1ICID                                       *IF
      * Setup message data for message
     C                   MOVEL     #1ICID        ZA0063                         Interest Capita
      * Send message 'Self Ref Int Cap Dr'
     C                   MOVEL     'USR1249'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9945      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: WRK.Account type is Retail Accounts
     C     WUACTY        IFEQ      'R'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1ICID        ZA0064                         Interest Capita
      * Send message 'Account code mustn't be R'
     C                   MOVEL     'USR0176'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9945      *
      *
     C                   END                                                    *FI
      * Start of 057868 - account cannot be title only
      * CASE: WRK.Title Only Indicator is YES
     C     WUTOIN        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1ICID        ZA0065                         Interest Capita
      * Send message 'Account code mustn't be t'
     C                   MOVEL     'USR0221'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9945      *
      *
     C                   END                                                    *FI
      * End of 057868
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Alpha-numeric
     C     WUNMFL        IFEQ      'N'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1ICID        ZA0066                         Interest Capita
      * Send message 'Invalid Account Code'
     C                   MOVEL     'USR0183'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9945      *
      *
     C                   END                                                    *FI
      * Start of CRE002
      * Capitalissation A/C code
      * CASE: WRK.CRE002 is Present
     C     WURAPE        IFEQ      'Y'                                          *IF
      * CASE: WRK.Account Section is Income
     C     WUACSC        IFEQ      'IN'                                         *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1ICID        ZA0067                         Interest Capita
      * Send message 'Cap A/C cde must be IN'
     C                   MOVEL     'USR3206'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9945      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of CRE002
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Interest Capital in Debt is Non-blank
     C     #1ICID        IFNE      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1ICID        ZA0068                         Interest Capita
      * Send message 'Int Cap. Debit Non-Rtl'
     C                   MOVEL     'USR0134'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9945      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Interest Capital in Credit
      * CASE: DTL.Account type is Retail Accounts
     C     #1ACTY        IFEQ      'R'                                          *IF
      * CASE: DTL.Interest Capital in Cr. is blank
     C     #1ICIC        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1ICIC        ZA0069                         Interest Capita
      * Send message 'Int Cap. Credit Retail'
     C                   MOVEL     'USR0131'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9946      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1ICIC        WUACCD                         Account Code
      * Check A/c Code Numeric - Account Codes  *
     C                   MOVEL     *IN90         XG90              1            * Save *IN90
     C*********************TESTN          WUAFNB     90  90* Check numericS01229
     C***90****************MOVE WUAFNB    XGX1    1        Check +ve      S01229
     C                   TESTN                   WUACCD               90  90    * Check numericS0122
     C   90              MOVE      WUACCD        XGX1              1            Check +ve      S0122
     C   90              TESTB     '0123'        XGX1                     90    *
     C**N90****************MOVELWUAFNB    XGX1                            S01229
     C  N90              MOVEL     WUACCD        XGX1                                          S0122
     C  N90XGX1          COMP      '?'                                    90    * ? is OK
     C     *IN90         IFEQ      '0'
     C*********************MOVE 'N'       WUFEST                          S01229
     C                   MOVE      'N'           WUNMFL                                        S0122
     C                   END
     C     *IN90         IFEQ      '1'
     C     XGX1          IFEQ      '?'
     C*********************MOVE '?'       WUFEST                          S01229
     C                   MOVE      '?'           WUNMFL                                        S0122
     C                   ELSE
     C*********************MOVE 'Y'       WUFEST                          S01229
     C                   MOVE      'Y'           WUNMFL                                        S0122
     C                   END
     C                   END
     C                   MOVEL     XG90          *IN90                          * Restore *IN90
      * Select Request
      * CASE: WRK.Numeric flag is Select request
     C     WUNMFL        IFEQ      '?'                                          *IF
      * Select Account Codes - Account Codes  *
     C                   CALL      'SD0031S'                            90      Select Account
     C                   PARM      *BLANK        W0RTN             7
     C********** #1ICIC    PARM #1ICIC    WQ0047  4        Account Code                       CGL029
     C     #1ICIC        PARM      #1ICIC        WQ0047           10            Account Code
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
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   MOVEL     'Y'           WUNMFL                         Numeric flag
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Numeric
     C     WUNMFL        IFEQ      'Y'                                          *IF
      * Start of 057868 - get title only indicator
      * Start of CRE002
      * Get A/C cde, Type & Sctn - Account Codes  *
     C                   EXSR      SHRVGN
      * End of CRE002
      * End of 057868
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1ICIC        ZA0070                         Interest Capita
      * Send message 'A/C Code NF - Highlight'
     C                   MOVEL     'USR0173'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9946      *
      *
     C                   ELSE
      * CASE: DTL.Account Code EQ DTL.Interest Capital in Cr.
     C     #1ACCD        IFEQ      #1ICIC                                       *IF
      * Setup message data for message
     C                   MOVEL     #1ICIC        ZA0071                         Interest Capita
      * Send message 'Self Ref Int Cap Cr'
     C                   MOVEL     'USR1250'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9946      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: WRK.Account type is Retail Accounts
     C     WUACTY        IFEQ      'R'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1ICIC        ZA0072                         Interest Capita
      * Send message 'Account code mustn't be R'
     C                   MOVEL     'USR0176'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9946      *
      *
     C                   END                                                    *FI
      * Start of 057868 - account cannot be title only
      * CASE: WRK.Title Only Indicator is YES
     C     WUTOIN        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1ICIC        ZA0073                         Interest Capita
      * Send message 'Account code mustn't be t'
     C                   MOVEL     'USR0221'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9946      *
      *
     C                   END                                                    *FI
      * End of 057868
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Alpha-numeric
     C     WUNMFL        IFEQ      'N'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1ICIC        ZA0074                         Interest Capita
      * Send message 'Invalid Account Code'
     C                   MOVEL     'USR0183'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9946      *
      *
     C                   END                                                    *FI
      * Start of CRE002
      * Capitalissation A/C code Cr.
      * CASE: WRK.CRE002 is Present
     C     WURAPE        IFEQ      'Y'                                          *IF
      * CASE: WRK.Account Section is Expense
     C     WUACSC        IFEQ      'EX'                                         *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1ICIC        ZA0075                         Interest Capita
      * Send message 'Cap A/C cde must be EX'
     C                   MOVEL     'USR3215'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9946      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of CRE002
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Interest Capital in Cr. is Non-blank
     C     #1ICIC        IFNE      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1ICIC        ZA0076                         Interest Capita
      * Send message 'Int Cap. Credit Non-Rtl'
     C                   MOVEL     'USR0132'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9946      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C/COPY WNCPYSRC,SD0031RC11
      * Stat Returns BS L/C
      * CASE: DTL.Stat Returns L/C Func is Not Blank
     C     #DSRLF        IFNE      *BLANK                                       *IF
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DSRLF        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0048            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0049           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0050            1 0          ZALIGN No Of De
     C                   PARM      5             WQ0051            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0052           16            ZALIGN File Fie
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
     C     WUZASF        PARM      WUZASF        WQ0053           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0054            1 0          ZALIGN No Of De
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
     C                   MOVEL     #DSRLF        ZA0077                         Stat Returns L/
      * Send message 'Stat Returns BS L/C Num'
     C                   MOVEL     'USR1240'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9947      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * Zalign Stat Returns L/C - Account Codes  *
     C* Zalign Stat Returns L/C
     C                   MOVE      WUZASF        #DSRLF
     C                   MOVE      WUZAFF        #1SRLC                         Stat Returns BS
      * CASE: DTL.Stat Returns BS L/C is Is Zero
     C     #1SRLC        IFEQ      *ZERO                                        *IF
      * Setup message data for message
     C                   MOVEL     #DSRLF        ZA0078                         Stat Returns L/
      * Send message 'Stat Returns BS L/C GT 0'
     C                   MOVEL     'USR1252'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9947      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   Z-ADD     *ZERO         #1SRLC                         Stat Returns BS
     C                   END                                                    *FI
      * Stat Returns BS F/C
      * CASE: DTL.Stat Returns F/C Func is Not Blank
     C     #DSRFF        IFNE      *BLANK                                       *IF
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DSRFF        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0055            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0056           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0057            1 0          ZALIGN No Of De
     C                   PARM      5             WQ0058            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0059           16            ZALIGN File Fie
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
     C     WUZASF        PARM      WUZASF        WQ0060           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0061            1 0          ZALIGN No Of De
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
     C                   MOVEL     #DSRFF        ZA0079                         Stat Returns F/
      * Send message 'Stat Returns BS F/C Num'
     C                   MOVEL     'USR1241'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9948      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * Zalign Stat Returns F/C - Account Codes  *
     C* Zalign Stat Returns F/C
     C                   MOVE      WUZASF        #DSRFF
     C                   MOVE      WUZAFF        #1SRFC                         Stat Returns BS
      * CASE: DTL.Stat Returns BS F/C is Is Zero
     C     #1SRFC        IFEQ      *ZERO                                        *IF
      * Setup message data for message
     C                   MOVEL     #DSRFF        ZA0080                         Stat Returns F/
      * Send message 'Stat Returns BS F/C Gt 0'
     C                   MOVEL     'USR1253'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9948      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   Z-ADD     *ZERO         #1SRFC                         Stat Returns BS
     C                   END                                                    *FI
      * Start of change CTI001
      * TI Account Type
      * CASE: WRK.Midas-Trade Innovation If is Yes
     C     WUN3ST        IFEQ      'Y'                                          *IF
      * TI Account Type validation
      * CASE: DTL.TI Account Type is Not Blank
     C     #1TIAT        IFNE      *BLANK                                       *IF
     C                   MOVEL     #1TIAT        WUQMEN                         question mark e
      * Validate TI Account Type entry
      * CASE: WRK.question mark entered is Question mark
     C     WUQMEN        IFEQ      '?'                                          *IF
      * Select Trade Innov A/c Ty - Trade Innov A/c Types  *
     C                   CALL      'SD0035S'                            90      Select Trade In
     C                   PARM      *BLANK        W0RTN             7
     C     #1TIAT        PARM      #1TIAT        WQ0062            2            A/c Type
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0035S'     W0CLPG
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
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: *OTHERWISE
      * Retrieve TI A/c Type - Trade Innov A/c Types  *
     C                   EXSR      SIRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1TIAT        ZA0081                         TI Account Type
      * Send message 'Invalid TI Account Type'
     C                   MOVEL     'USR3509'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9949      *
      *
     C                   END                                                    *FI
      * Validate TI Account type against SCACODPD                                             CTI004
     C     #1TIAT        CHAIN     SDACODL9                           17
     C     *IN17         IFEQ      '0'
     C********** #1ACCD    ANDNEA5ACCD                                                BUG3032 CAS010
     C     #1ACCD        ANDNE     A9ACCD
      * Send message 'TI Account Already exist'                                               CTI004
     C                   MOVEL     'USR4176'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9949
     C                   END
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of change CTI001
      * Reporting Code
      * CASE: DTL.Reporting Code Func  Fld is Not Blank
     C     #DRPCF        IFNE      *BLANK                                       *IF
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DRPCF        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0063            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0064           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0065            1 0          ZALIGN No Of De
     C                   PARM      10            WQ0066            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0067           16            ZALIGN File Fie
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
     C     WUZASF        PARM      WUZASF        WQ0068           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0069            1 0          ZALIGN No Of De
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
     C                   MOVEL     #DRPCF        ZA0082                         Reporting Code
      * Send message 'Reporting Code must numer'
     C                   MOVEL     'USR1242'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9950      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * Zalign Reporting Code - Account Codes  *
     C* Zalign Reporting Code func field
     C                   MOVE      WUZASF        #DRPCF
     C                   MOVE      WUZAFF        #1RPCD                         Reporting Code
      * CASE: DTL.Reporting Code is Is Zero
     C     #1RPCD        IFEQ      *ZERO                                        *IF
      * Setup message data for message
     C                   MOVEL     #DRPCF        ZA0083                         Reporting Code
      * Send message 'Reporting Code GT Zero'
     C                   MOVEL     'USR1251'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9950      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy Member SD0031RC01 - Account Codes  *
     C/COPY WNCPYSRC,SD0031RC01
     C                   ELSE
      * CASE: *OTHERWISE
     C                   Z-ADD     *ZERO         #1RPCD                         Reporting Code
     C                   END                                                    *FI
      * End of Fix S01117
      * Start of S01486
      * PM Instrument Code.
      * CASE: WRK.Portfolio Management is Yes
      * CASE: OR WRK.Private Banking is Yes                               CPB001
     C     WUPFMG        IFEQ      'Y'                                          *IF
     C     WUN4ST        OREQ      'Y'                                                         CPB00
     C     CGL014        OREQ      'Y'
     C     CLE025        OREQ      'Y'
      * CASE: DTL.PM Instrument Code (Lndr) is Blank
     C     #1INNR        IFEQ      *BLANK                                       *IF
      * If Private Banking Module is active                               CPB001
     C     WUN4ST        IFEQ      'Y'                                                         CPB00
     C********** CGL014    OREQ 'Y'                                                   BUG3078 247957
     C     CGL014        IFEQ      'Y'
     C     CLE025        OREQ      'Y'
      * If Account Type is 'R' (Retail)                                   CPB001
     C     #1ACTY        IFEQ      'R'                                          *IF            CPB00
      * Setup message data for message                                    CPB001
     C                   MOVEL     #1INNR        ZA0084                         PM Instrument  CPB00
      * Send message 'Instrument Code invald'                             CPB001
     C                   MOVEL     'USR4550'     ZAMSID                                        CPB00
     C                   EXSR      ZASNMS                                                      CPB00
     C                   SETON                                        9951      *              CPB00
     C                   ENDIF                                                                 CPB00
     C                   ENDIF
     C                   ELSE
     C     CGL014        IFEQ      'Y'
     C     CLE025        OREQ      'Y'
      * SECO='Y'   Warning message has sent to the screen, by pass this process               247957
     C     SECO          IFEQ      ' '
      * Setup message data for message                                                        247957
     C                   MOVEL     #1INNR        ZA0084                         PM Instrument
      * Send message 'Instrument Code invald'                                                 247957
     C                   MOVEL     'USR4599'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           W0RPT
     C                   MOVE      'Y'           SECO
     C**********           SETON                       51  *                           247957 CRE015
     C                   SETON                                        9951
     C                   ELSE
     C                   MOVE      'N'           W0RPT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                 CPB00
      * Start of change 104645
      * If 'Portfolios Supported' is 'B' (Bank).
      * CASE: WRK.Portfolios Supported is Bank
     C     WUPORS        IFEQ      'B'                                          *IF
     C     WUPFMG        ANDEQ     'Y'                                                         CPB00
     C     WUN4ST        ANDNE     'Y'                                                         CPB00
     C     WUPORS        OREQ      'B'
     C     CGL014        ANDEQ     'Y'
     C     WUPORS        OREQ      'B'
     C     CLE025        ANDEQ     'Y'
     C/COPY WNCPYSRC,SD0031RC02
      * If Account Type is  'R' (Retail) or 'N' (Nostro)
      * CASE:
      *  - c1 OR c2
      *   |- c1    : DTL.Account type is Retail Accounts
      *   |- c2    : DTL.Account type is Nostro
      *   '-
     C     #1ACTY        IFEQ      'R'                                          *IF
     C     #1ACTY        OREQ      'N'                                          *OR
      * Setup message data for message
     C                   MOVEL     #1INNR        ZA0084                         PM Instrument C
      * Send message 'Instrument Code invald'
     C                   MOVEL     'USR2358'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9951      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of change 104645
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1INNR        WUTQKF                         Test ? in Key F
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      '?'                                          *IF
     C                   MOVEL     #1INNR        WUINNR                         PM Instrument C
     C                   MOVEL     *BLANK        WUAPOP                         Access Pgm Opti
     C                   MOVEL     '*KEY'        WUAPOP                         Access Pgm Opti
      * Access SDPLINPD - Standard Functions  *     *KEY
     C*
     C                   CALL      'AOPLINR0'
     C     WUAPRC        PARM      WUAPRC        UUAPRC            7            RETURN CDE
     C                   PARM      WUAPOP        UUAPOP            7            OPTION
     C                   PARM      WUINNR        UUINNR            3            INS TYPE
     C     D@PLIN        PARM      *BLANK        UUSDY                          FORMAT
     C*
      * No selection was made, send an information message.
      * CASE: WRK.Access Pgm Return Code is No selection
     C     WUAPRC        IFEQ      '*NOSEL'                                     *IF
      * Send message 'Ins code not selected'
     C                   MOVEL     'USR2364'     ZAMSID
     C                   MOVEL     '*INFO  '     ZAMSTP                         Message type
     C                   EXSR      ZASNMS
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
      * Move PM INS to screen - Account Codes  *
     C*
     C                   MOVE      PDINNR        #1INNR
     C*
     C                   MOVEL     *BLANK        WUAPOP                         Access Pgm Opti
     C                   MOVEL     '*FREE'       WUAPOP                         Access Pgm Opti
      * Access SDPLINPD - Standard Functions  *     *FREE
     C*
     C                   CALL      'AOPLINR0'
     C     WUAPRC        PARM      WUAPRC        UUAPRC            7            RETURN CDE
     C                   PARM      WUAPOP        UUAPOP            7            OPTION
     C                   PARM      WUINNR        UUINNR            3            INS TYPE
     C     D@PLIN        PARM      *BLANK        UUSDY                          FORMAT
     C*
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1INNR        WUINNR                         PM Instrument C
     C                   MOVEL     '*VERIFY'     WUAPOP                         Access Pgm Opti
      * Access SDPLINPD - Standard Functions  *     *VERIFY
     C*
     C                   CALL      'AOPLINR0'
     C     WUAPRC        PARM      WUAPRC        UUAPRC            7            RETURN CDE
     C                   PARM      WUAPOP        UUAPOP            7            OPTION
     C                   PARM      WUINNR        UUINNR            3            INS TYPE
     C     D@PLIN        PARM      *BLANK        UUSDY                          FORMAT
     C*
      * Check access object return code
      * CASE: WRK.Access Pgm Return Code is *Normal
     C     WUAPRC        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1INNR        ZA0085                         PM Instrument C
      * Send message 'Instrument Code invald'
     C                   MOVEL     'USR2358'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9951      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of S01486
      * start S01413
      * Withholding Tax Details
      * CASE: WRK.Dsp withholding tax Flds is Display
     C     WUDSWT        IFEQ      'Y'                                          *IF
      * Debit Interest Payment A/C Code Dr
      * CASE: DTL.Account type is Retail Accounts
     C     #1ACTY        IFEQ      'R'                                          *IF
      * CASE: DTL.Dr Int pay A/C code Dr is blank
     C     #1DIPD        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1DIPD        ZA0086                         Dr Int pay A/C
      * Send message 'Dr Int Pay A/C mandatory'
     C                   MOVEL     'USR1924'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9952      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1DIPD        WUACCD                         Account Code
      * Check A/c Code Numeric - Account Codes  *
     C                   MOVEL     *IN90         XG90              1            * Save *IN90
     C*********************TESTN          WUAFNB     90  90* Check numericS01229
     C***90****************MOVE WUAFNB    XGX1    1        Check +ve      S01229
     C                   TESTN                   WUACCD               90  90    * Check numericS0122
     C   90              MOVE      WUACCD        XGX1              1            Check +ve      S0122
     C   90              TESTB     '0123'        XGX1                     90    *
     C**N90****************MOVELWUAFNB    XGX1                            S01229
     C  N90              MOVEL     WUACCD        XGX1                                          S0122
     C  N90XGX1          COMP      '?'                                    90    * ? is OK
     C     *IN90         IFEQ      '0'
     C*********************MOVE 'N'       WUFEST                          S01229
     C                   MOVE      'N'           WUNMFL                                        S0122
     C                   END
     C     *IN90         IFEQ      '1'
     C     XGX1          IFEQ      '?'
     C*********************MOVE '?'       WUFEST                          S01229
     C                   MOVE      '?'           WUNMFL                                        S0122
     C                   ELSE
     C*********************MOVE 'Y'       WUFEST                          S01229
     C                   MOVE      'Y'           WUNMFL                                        S0122
     C                   END
     C                   END
     C                   MOVEL     XG90          *IN90                          * Restore *IN90
      * Select Request
      * CASE: WRK.Numeric flag is Select request
     C     WUNMFL        IFEQ      '?'                                          *IF
      * Select Account Codes - Account Codes  *
     C                   CALL      'SD0031S'                            90      Select Account
     C                   PARM      *BLANK        W0RTN             7
     C********** #1DIPD    PARM #1DIPD    WQ0070  4        Account Code                       CGL029
     C     #1DIPD        PARM      #1DIPD        WQ0070           10
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
     C                   SETON                                        9952      *
     C                   END
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   MOVEL     'Y'           WUNMFL                         Numeric flag
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Numeric
     C     WUNMFL        IFEQ      'Y'                                          *IF
      * retrieve type as well - Account Codes  *
     C                   EXSR      SJRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1DIPD        ZA0087                         Dr Int pay A/C
      * Send message 'A/C Code NF - Highlight'
     C                   MOVEL     'USR0173'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9952      *
      *
     C                   ELSE
      * CASE: DTL.Account Code EQ DTL.Dr Int pay A/C code Dr
     C     #1ACCD        IFEQ      #1DIPD                                       *IF
      * Setup message data for message
     C                   MOVEL     #1DIPD        ZA0088                         Dr Int pay A/C
      * Send message 'Self Ref Dr Int Pay AC Dr'
     C                   MOVEL     'USR1925'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9952      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: WRK.Account type is Retail Accounts
     C     WUACTY        IFEQ      'R'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1DIPD        ZA0089                         Dr Int pay A/C
      * Send message 'Account code mustn't be R'
     C                   MOVEL     'USR0176'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9952      *
      *
     C                   END                                                    *FI
      * CASE: WRK.Title Only Indicator is YES
     C     WUTOIN        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1DIPD        ZA0090                         Dr Int pay A/C
      * Send message 'Account code mustn't be t'
     C                   MOVEL     'USR0221'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9952      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Alpha-numeric
     C     WUNMFL        IFEQ      'N'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1DIPD        ZA0091                         Dr Int pay A/C
      * Send message 'Invalid Account Code'
     C                   MOVEL     'USR0183'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9952      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Dr Int pay A/C code Dr is Non-blank
     C     #1DIPD        IFNE      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1DIPD        ZA0092                         Dr Int pay A/C
      * Send message 'Dr Int Pay A/C Dr prohib'
     C                   MOVEL     'USR1926'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9952      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Debit Interest Payment A/C Code Cr
      * CASE: DTL.Account type is Retail Accounts
     C     #1ACTY        IFEQ      'R'                                          *IF
      * CASE: DTL.Dr Int pay A/C code Cr is blank
     C     #1DIPC        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1DIPC        ZA0093                         Dr Int pay A/C
      * Send message 'Dr Int Pay A/C Cr mandtry'
     C                   MOVEL     'USR1927'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9953      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1DIPC        WUACCD                         Account Code
      * Check A/c Code Numeric - Account Codes  *
     C                   MOVEL     *IN90         XG90              1            * Save *IN90
     C*********************TESTN          WUAFNB     90  90* Check numericS01229
     C***90****************MOVE WUAFNB    XGX1    1        Check +ve      S01229
     C                   TESTN                   WUACCD               90  90    * Check numericS0122
     C   90              MOVE      WUACCD        XGX1              1            Check +ve      S0122
     C   90              TESTB     '0123'        XGX1                     90    *
     C**N90****************MOVELWUAFNB    XGX1                            S01229
     C  N90              MOVEL     WUACCD        XGX1                                          S0122
     C  N90XGX1          COMP      '?'                                    90    * ? is OK
     C     *IN90         IFEQ      '0'
     C*********************MOVE 'N'       WUFEST                          S01229
     C                   MOVE      'N'           WUNMFL                                        S0122
     C                   END
     C     *IN90         IFEQ      '1'
     C     XGX1          IFEQ      '?'
     C*********************MOVE '?'       WUFEST                          S01229
     C                   MOVE      '?'           WUNMFL                                        S0122
     C                   ELSE
     C*********************MOVE 'Y'       WUFEST                          S01229
     C                   MOVE      'Y'           WUNMFL                                        S0122
     C                   END
     C                   END
     C                   MOVEL     XG90          *IN90                          * Restore *IN90
      * Select Request
      * CASE: WRK.Numeric flag is Select request
     C     WUNMFL        IFEQ      '?'                                          *IF
      * Select Account Codes - Account Codes  *
     C                   CALL      'SD0031S'                            90      Select Account
     C                   PARM      *BLANK        W0RTN             7
     C********** #1DIPC    PARM #1DIPC    WQ0071  4        Account Code                       CGL029
     C     #1DIPC        PARM      #1DIPC        WQ0071           10
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
     C                   SETON                                        9953      *
     C                   END
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   MOVEL     'Y'           WUNMFL                         Numeric flag
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Numeric
     C     WUNMFL        IFEQ      'Y'                                          *IF
      * retrieve type as well - Account Codes  *
     C                   EXSR      SKRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1DIPC        ZA0094                         Dr Int pay A/C
      * Send message 'A/C Code NF - Highlight'
     C                   MOVEL     'USR0173'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9953      *
      *
     C                   ELSE
      * CASE: DTL.Account Code EQ DTL.Dr Int pay A/C code Cr
     C     #1ACCD        IFEQ      #1DIPC                                       *IF
      * Setup message data for message
     C                   MOVEL     #1DIPC        ZA0095                         Dr Int pay A/C
      * Send message 'Self Ref Dr Int Pay AC Cr'
     C                   MOVEL     'USR1928'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9953      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: WRK.Account type is Retail Accounts
     C     WUACTY        IFEQ      'R'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1DIPC        ZA0096                         Dr Int pay A/C
      * Send message 'Account code mustn't be R'
     C                   MOVEL     'USR0176'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9953      *
      *
     C                   END                                                    *FI
      * CASE: WRK.Title Only Indicator is YES
     C     WUTOIN        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1DIPC        ZA0097                         Dr Int pay A/C
      * Send message 'Account code mustn't be t'
     C                   MOVEL     'USR0221'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9953      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Alpha-numeric
     C     WUNMFL        IFEQ      'N'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1DIPC        ZA0098                         Dr Int pay A/C
      * Send message 'Invalid Account Code'
     C                   MOVEL     'USR0183'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9953      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Dr Int pay A/C code Cr is Non-blank
     C     #1DIPC        IFNE      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1DIPC        ZA0099                         Dr Int pay A/C
      * Send message 'Dr Int Pay A/C Cr prohbtd'
     C                   MOVEL     'USR1929'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9953      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Withholding Tax A/C Code
      * CASE: DTL.Account type is Retail Accounts
     C     #1ACTY        IFEQ      'R'                                          *IF
      * CASE: DTL.Withholding Tax A/C code is blank
     C     #1WTAC        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1WTAC        ZA0100                         Withholding Tax
      * Send message 'Withholding tax mandatory'
     C                   MOVEL     'USR1921'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9954      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1WTAC        WUACCD                         Account Code
      * Check A/c Code Numeric - Account Codes  *
     C                   MOVEL     *IN90         XG90              1            * Save *IN90
     C*********************TESTN          WUAFNB     90  90* Check numericS01229
     C***90****************MOVE WUAFNB    XGX1    1        Check +ve      S01229
     C                   TESTN                   WUACCD               90  90    * Check numericS0122
     C   90              MOVE      WUACCD        XGX1              1            Check +ve      S0122
     C   90              TESTB     '0123'        XGX1                     90    *
     C**N90****************MOVELWUAFNB    XGX1                            S01229
     C  N90              MOVEL     WUACCD        XGX1                                          S0122
     C  N90XGX1          COMP      '?'                                    90    * ? is OK
     C     *IN90         IFEQ      '0'
     C*********************MOVE 'N'       WUFEST                          S01229
     C                   MOVE      'N'           WUNMFL                                        S0122
     C                   END
     C     *IN90         IFEQ      '1'
     C     XGX1          IFEQ      '?'
     C*********************MOVE '?'       WUFEST                          S01229
     C                   MOVE      '?'           WUNMFL                                        S0122
     C                   ELSE
     C*********************MOVE 'Y'       WUFEST                          S01229
     C                   MOVE      'Y'           WUNMFL                                        S0122
     C                   END
     C                   END
     C                   MOVEL     XG90          *IN90                          * Restore *IN90
      * Select Request
      * CASE: WRK.Numeric flag is Select request
     C     WUNMFL        IFEQ      '?'                                          *IF
      * Select Account Codes - Account Codes  *
     C                   CALL      'SD0031S'                            90      Select Account
     C                   PARM      *BLANK        W0RTN             7
     C********** #1WTAC    PARM #1WTAC    WQ0072  4        Account Code                       CGL029
     C     #1WTAC        PARM      #1WTAC        WQ0072           10
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
     C                   SETON                                        9954      *
     C                   END
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   MOVEL     'Y'           WUNMFL                         Numeric flag
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Numeric
     C     WUNMFL        IFEQ      'Y'                                          *IF
      * retrieve type as well - Account Codes  *
     C                   EXSR      SLRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1WTAC        ZA0101                         Withholding Tax
      * Send message 'A/C Code NF - Highlight'
     C                   MOVEL     'USR0173'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9954      *
      *
     C                   ELSE
      * CASE: DTL.Account Code EQ DTL.Withholding Tax A/C code
     C     #1ACCD        IFEQ      #1WTAC                                       *IF
      * Setup message data for message
     C                   MOVEL     #1WTAC        ZA0102                         Withholding Tax
      * Send message 'Self Ref With. Tax A/C'
     C                   MOVEL     'USR1922'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9954      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: WRK.Account type is Retail Accounts
     C     WUACTY        IFEQ      'R'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1WTAC        ZA0103                         Withholding Tax
      * Send message 'Account code mustn't be R'
     C                   MOVEL     'USR0176'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9954      *
      *
     C                   END                                                    *FI
      * CASE: WRK.Title Only Indicator is YES
     C     WUTOIN        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1WTAC        ZA0104                         Withholding Tax
      * Send message 'Account code mustn't be t'
     C                   MOVEL     'USR0221'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9954      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Alpha-numeric
     C     WUNMFL        IFEQ      'N'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1WTAC        ZA0105                         Withholding Tax
      * Send message 'Invalid Account Code'
     C                   MOVEL     'USR0183'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9954      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Withholding Tax A/C code is Non-blank
     C     #1WTAC        IFNE      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1WTAC        ZA0106                         Withholding Tax
      * Send message 'With. Tax A/C prohibited'
     C                   MOVEL     'USR1923'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9954      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     CDL013        IFEQ      '1'
     C                   MOVE      *BLANKS       WTERR             1
      * Withholding Tax A/C Code                                                              CDL013
      * CASE: DTL.Account type is Retail Accounts                                             CDL013
     C     #1ACTY        IFEQ      'R'                                          *IF
      * CASE: DTL.Withholding Tax A/C code is blank                                           CDL013
     C     #1WTCC        IFEQ      *BLANK                                       *IF
      * Setup message data for message                                                        CDL013
     C                   MOVEL     #1WTCC        ZA0086                         Withholding Tax
      * Send message 'Withholding tax mandatory'                                              CDL013
     C                   MOVEL     'USR1921'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVE      'Y'           WTERR             1
      *                                                                                       CDL013
     C                   ELSE
      * CASE: *OTHERWISE                                                                      CDL013
     C                   MOVEL     #1WTCC        WUACCD                         Account Code
      * Check A/c Code Numeric - Account Codes  *                                             CDL013
     C                   MOVEL     *IN90         XG90              1            * Save *IN90
     C                   TESTN                   WUACCD               90  90    * Check numeric
     C   90              MOVE      WUACCD        XGX1              1            Check +ve
     C   90              TESTB     '0123'        XGX1                     90    *
     C  N90              MOVEL     WUACCD        XGX1
     C  N90XGX1          COMP      '?'                                    90    * ? is OK
     C     *IN90         IFEQ      '0'
     C                   MOVE      'N'           WUNMFL
     C                   END
     C     *IN90         IFEQ      '1'
     C     XGX1          IFEQ      '?'
     C                   MOVE      '?'           WUNMFL
     C                   ELSE
     C                   MOVE      'Y'           WUNMFL
     C                   END
     C                   END
     C                   MOVEL     XG90          *IN90                          * Restore *IN90
      *                                                                                       CDL013
      *                                                                                       CDL013
      * Select Request                                                                        CDL013
      * CASE: WRK.Numeric flag is Select request                                              CDL013
     C     WUNMFL        IFEQ      '?'                                          *IF
      * Select Account Codes - Account Codes  *                                               CDL013
     C                   CALL      'SD0031S'                            90      Select Account
     C                   PARM      *BLANK        W0RTN             7
     C     #1WTCC        PARM      #1WTCC        WQ0071           10            Account Code
      *                                                                                       CDL013
     C     *IN90         IFEQ      '1'
      * Call to program ended in error                                                        CDL013
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0031S'     W0CLPG
      * Send message '*Error occured on CALL...'                                              CDL013
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *                                                                                       CDL013
      * Error detected?                                                                       CDL013
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   MOVE      'Y'           WTERR             1
     C                   END
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   MOVEL     'Y'           WUNMFL                         Numeric flag
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Numeric                                                     CDL013
     C     WUNMFL        IFEQ      'Y'                                          *IF
      * retrieve type as well - Account Codes  *                                              CDL013
     C                   EXSR      SPRVGN
      * CASE: PGM.*Return code is *Record does not exist                                      CDL013
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message                                                        CDL013
     C                   MOVEL     #1WTCC        ZA0087                         Withholding Tax
      * Send message 'A/C Code NF - Highlight'                                                CDL013
     C                   MOVEL     'USR0173'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVE      'Y'           WTERR             1
      *                                                                                       CDL013
     C                   ELSE
      * CASE: DTL.Account Code EQ DTL.Withholding Tax A/C code                                CDL013
     C     #1ACCD        IFEQ      #1WTCC                                       *IF
      * Setup message data for message                                                        CDL013
     C                   MOVEL     #1WTCC        ZA0088                         Withholding Tax
      * Send message 'Self Ref With. Tax A/C'                                                 CDL013
     C                   MOVEL     'USR1922'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WTERR             1
     C                   SETON                                        99        *
      *                                                                                       CDL013
     C                   ELSE
      * CASE: *OTHERWISE                                                                      CDL013
      * CASE: WRK.Account type is Retail Accounts                                             CDL013
     C     WUACTY        IFEQ      'R'                                          *IF
      * Setup message data for message                                                        CDL013
     C                   MOVEL     #1WTCC        ZA0089                         Withholding Tax
      * Send message 'Account code mustn't be R'                                              CDL013
     C                   MOVEL     'USR0176'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WTERR             1
     C                   SETON                                        99        *
      *                                                                                       CDL013
     C                   END                                                    *FI
      * CASE: WRK.Title Only Indicator is YES                                                 CDL013
     C     WUTOIN        IFEQ      'Y'                                          *IF
      * Setup message data for message                                                        CDL013
     C                   MOVEL     #1WTCC        ZA0090                         Withholding Tax
      * Send message 'Account code mustn't be t'                                              CDL013
     C                   MOVEL     'USR0221'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVE      'Y'           WTERR             1
      *                                                                                       CDL013
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Alpha-numeric                                               CDL013
     C     WUNMFL        IFEQ      'N'                                          *IF
      * Setup message data for message                                                        CDL013
     C                   MOVEL     #1WTCC        ZA0091                         Withholding Tax
      * Send message 'Invalid Account Code'                                                   CDL013
     C                   MOVEL     'USR0183'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVE      'Y'           WTERR             1
      *                                                                                       CDL013
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE                                                                      CDL013
      * CASE: DTL.Withholding Tax A/C code is Non-blank                                       CDL013
     C     #1WTCC        IFNE      *BLANK                                       *IF
      * Setup message data for message                                                        CDL013
     C                   MOVEL     #1WTCC        ZA0092                         Withholding Tax
      * Send message 'With. Tax A/C prohibited'                                               CDL013
     C                   MOVEL     'USR1923'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVE      'Y'           WTERR             1
      *                                                                                       CDL013
     C                   END                                                    *FI
     C                   END                                                    *FI
      *                                                                                       CDL013
     C                   ENDIF                                                  *FI
      *                                                                                       CDL013
     C/COPY WNCPYSRC,SD0031RC17
      * Credit Interest Payment A/C Code Cr
      * CASE: DTL.Account type is Retail Accounts
     C     #1ACTY        IFEQ      'R'                                          *IF
      * CASE: DTL.Cr Int pay A/C code Cr is blank
     C     #1CIPC        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1CIPC        ZA0107                         Cr Int pay A/C
      * Send message 'Cr Int Pay A/C Cr mandtry'
     C                   MOVEL     'USR1930'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9955      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1CIPC        WUACCD                         Account Code
      * Check A/c Code Numeric - Account Codes  *
     C                   MOVEL     *IN90         XG90              1            * Save *IN90
     C*********************TESTN          WUAFNB     90  90* Check numericS01229
     C***90****************MOVE WUAFNB    XGX1    1        Check +ve      S01229
     C                   TESTN                   WUACCD               90  90    * Check numericS0122
     C   90              MOVE      WUACCD        XGX1              1            Check +ve      S0122
     C   90              TESTB     '0123'        XGX1                     90    *
     C**N90****************MOVELWUAFNB    XGX1                            S01229
     C  N90              MOVEL     WUACCD        XGX1                                          S0122
     C  N90XGX1          COMP      '?'                                    90    * ? is OK
     C     *IN90         IFEQ      '0'
     C*********************MOVE 'N'       WUFEST                          S01229
     C                   MOVE      'N'           WUNMFL                                        S0122
     C                   END
     C     *IN90         IFEQ      '1'
     C     XGX1          IFEQ      '?'
     C*********************MOVE '?'       WUFEST                          S01229
     C                   MOVE      '?'           WUNMFL                                        S0122
     C                   ELSE
     C*********************MOVE 'Y'       WUFEST                          S01229
     C                   MOVE      'Y'           WUNMFL                                        S0122
     C                   END
     C                   END
     C                   MOVEL     XG90          *IN90                          * Restore *IN90
      * Select Request
      * CASE: WRK.Numeric flag is Select request
     C     WUNMFL        IFEQ      '?'                                          *IF
      * Select Account Codes - Account Codes  *
     C                   CALL      'SD0031S'                            90      Select Account
     C                   PARM      *BLANK        W0RTN             7
     C********** #1CIPC    PARM #1CIPC    WQ0073  4        Account Code                       CGL029
     C     #1CIPC        PARM      #1CIPC        WQ0073           10
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
     C                   SETON                                        9955      *
     C                   END
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   MOVEL     'Y'           WUNMFL                         Numeric flag
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Numeric
     C     WUNMFL        IFEQ      'Y'                                          *IF
      * retrieve type as well - Account Codes  *
     C                   EXSR      SMRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1CIPC        ZA0108                         Cr Int pay A/C
      * Send message 'A/C Code NF - Highlight'
     C                   MOVEL     'USR0173'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9955      *
      *
     C                   ELSE
      * CASE: DTL.Account Code EQ DTL.Cr Int pay A/C code Cr
     C     #1ACCD        IFEQ      #1CIPC                                       *IF
      * Setup message data for message
     C                   MOVEL     #1CIPC        ZA0109                         Cr Int pay A/C
      * Send message 'Self Ref Cr Int Pay AC Cr'
     C                   MOVEL     'USR1931'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9955      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: WRK.Account type is Retail Accounts
     C     WUACTY        IFEQ      'R'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CIPC        ZA0110                         Cr Int pay A/C
      * Send message 'Account code mustn't be R'
     C                   MOVEL     'USR0176'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9955      *
      *
     C                   END                                                    *FI
      * CASE: WRK.Title Only Indicator is YES
     C     WUTOIN        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CIPC        ZA0111                         Cr Int pay A/C
      * Send message 'Account code mustn't be t'
     C                   MOVEL     'USR0221'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9955      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Alpha-numeric
     C     WUNMFL        IFEQ      'N'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CIPC        ZA0112                         Cr Int pay A/C
      * Send message 'Invalid Account Code'
     C                   MOVEL     'USR0183'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9955      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Cr Int pay A/C code Cr is Non-blank
     C     #1CIPC        IFNE      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1CIPC        ZA0113                         Cr Int pay A/C
      * Send message 'Cr Int Pay AC Cr prohibtd'
     C                   MOVEL     'USR1932'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9955      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Minimum Interest Subject to Withholding Tax
      * CASE: DTL.Withholding Tax screen is Not equal to blank
     C     #DWTSC        IFNE      *BLANK                                       *IF
      * Start of 063606
      * Zalign withholding tax sc - Account Codes  *
     C                   MOVE      #DWTSC        WUWTSC                         WITHHOLDING TAX
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     WUWTSC        WUZASF                         ZALIGN Screen F
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0074            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0075           16            ZALIGN Screen F
     C                   PARM      WUZAND        WQ0076            1 0          ZALIGN No Of De
     C                   PARM      WUZADG        WQ0077            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0078           16            ZALIGN File Fie
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
      * Check whether value entered is valid or not.
      * CASE: PGM.*Return code is *Normal
     C     W0RTN         IFEQ      *BLANK                                       *IF
     C                   MOVE      WUZAFF        #1MISU                         Min Int subject
      * Must not be entered for non-retail accounts.
      * CASE:
      *  - c1 AND c2
      *   |- c1    : DTL.Min Int subject to tax is Not equal Zero
      *   |- c2    : DTL.Account type is Not Retail
      *   '-
     C                   MOVEL     '0'           Y0CX01            1
     C     #1MISU        IFNE      *ZERO                                        *IF
     C     #1ACTY        IFEQ      'D'                                          *IF
     C     #1ACTY        OREQ      *BLANK
     C     #1ACTY        OREQ      'C'
     C     #1ACTY        OREQ      'G'
     C     #1ACTY        OREQ      'N'
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     Y0CX01        IFEQ      '1'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DWTSC        ZA0114                         Withholding Tax
      * Send message 'Min Int Sub to Tax prohib'
     C                   MOVEL     'USR1968'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9956      *
      *
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Account type is Not Retail
     C     #1ACTY        IFEQ      'D'                                          *IF
     C     #1ACTY        OREQ      *BLANK
     C     #1ACTY        OREQ      'C'
     C     #1ACTY        OREQ      'G'
     C     #1ACTY        OREQ      'N'
      * Setup message data for message
     C                   MOVEL     #DWTSC        ZA0115                         Withholding Tax
      * Send message 'Min Int Sub to Tax prohib'
     C                   MOVEL     'USR1968'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9956      *
      *
     C                   ELSE
      * CASE: DTL.Account type is Retail Accounts
     C     #1ACTY        IFEQ      'R'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DWTSC        ZA0116                         Withholding Tax
      * Send message 'Min Int Sub to tax not nm'
     C                   MOVEL     'USR1942'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9956      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of 063606
     C                   ELSE
      * CASE: *OTHERWISE
     C                   Z-ADD     *ZERO         #1MISU                         Min Int subject
     C                   END                                                    *FI
      * Credit Interest Payment A/C Code Dr (Subject to Tax)
      * CASE: DTL.Account type is Retail Accounts
     C     #1ACTY        IFEQ      'R'                                          *IF
      * CASE: DTL.Cr Int pay A/C code Sub is blank
     C     #1CISU        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1CISU        ZA0117                         Cr Int pay A/C
      * Send message 'Cr Int Pay A/C Sub mndtry'
     C                   MOVEL     'USR1933'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9957      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1CISU        WUACCD                         Account Code
      * Check A/c Code Numeric - Account Codes  *
     C                   MOVEL     *IN90         XG90              1            * Save *IN90
     C*********************TESTN          WUAFNB     90  90* Check numericS01229
     C***90****************MOVE WUAFNB    XGX1    1        Check +ve      S01229
     C                   TESTN                   WUACCD               90  90    * Check numericS0122
     C   90              MOVE      WUACCD        XGX1              1            Check +ve      S0122
     C   90              TESTB     '0123'        XGX1                     90    *
     C**N90****************MOVELWUAFNB    XGX1                            S01229
     C  N90              MOVEL     WUACCD        XGX1                                          S0122
     C  N90XGX1          COMP      '?'                                    90    * ? is OK
     C     *IN90         IFEQ      '0'
     C*********************MOVE 'N'       WUFEST                          S01229
     C                   MOVE      'N'           WUNMFL                                        S0122
     C                   END
     C     *IN90         IFEQ      '1'
     C     XGX1          IFEQ      '?'
     C*********************MOVE '?'       WUFEST                          S01229
     C                   MOVE      '?'           WUNMFL                                        S0122
     C                   ELSE
     C*********************MOVE 'Y'       WUFEST                          S01229
     C                   MOVE      'Y'           WUNMFL                                        S0122
     C                   END
     C                   END
     C                   MOVEL     XG90          *IN90                          * Restore *IN90
      * Select Request
      * CASE: WRK.Numeric flag is Select request
     C     WUNMFL        IFEQ      '?'                                          *IF
      * Select Account Codes - Account Codes  *
     C                   CALL      'SD0031S'                            90      Select Account
     C                   PARM      *BLANK        W0RTN             7
     C********** #1CISU    PARM #1CISU    WQ0079  4        Account Code                       CGL029
     C     #1CISU        PARM      #1CISU        WQ0079           10
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
     C                   SETON                                        9957      *
     C                   END
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   MOVEL     'Y'           WUNMFL                         Numeric flag
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Numeric
     C     WUNMFL        IFEQ      'Y'                                          *IF
      * retrieve type as well - Account Codes  *
     C                   EXSR      SNRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1CISU        ZA0118                         Cr Int pay A/C
      * Send message 'A/C Code NF - Highlight'
     C                   MOVEL     'USR0173'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9957      *
      *
     C                   ELSE
      * CASE: DTL.Account Code EQ DTL.Cr Int pay A/C code Sub
     C     #1ACCD        IFEQ      #1CISU                                       *IF
      * Setup message data for message
     C                   MOVEL     #1CISU        ZA0119                         Cr Int pay A/C
      * Send message 'Self Ref Cr Int Pay Sub'
     C                   MOVEL     'USR1934'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9957      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: WRK.Account type is Retail Accounts
     C     WUACTY        IFEQ      'R'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CISU        ZA0120                         Cr Int pay A/C
      * Send message 'Account code mustn't be R'
     C                   MOVEL     'USR0176'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9957      *
      *
     C                   END                                                    *FI
      * CASE: WRK.Title Only Indicator is YES
     C     WUTOIN        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CISU        ZA0121                         Cr Int pay A/C
      * Send message 'Account code mustn't be t'
     C                   MOVEL     'USR0221'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9957      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Alpha-numeric
     C     WUNMFL        IFEQ      'N'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CISU        ZA0122                         Cr Int pay A/C
      * Send message 'Invalid Account Code'
     C                   MOVEL     'USR0183'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9957      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Cr Int pay A/C code Sub is Non-blank
     C     #1CISU        IFNE      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1CISU        ZA0123                         Cr Int pay A/C
      * Send message 'Cr Int Pay A/C Sub prhbtd'
     C                   MOVEL     'USR1935'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9957      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Credit Interest Payment A/C Code Dr (Not Subject to Tax)
      * CASE: DTL.Account type is Retail Accounts
     C     #1ACTY        IFEQ      'R'                                          *IF
      * CASE: DTL.Cr Int pay A/C code N-Sub is blank
     C     #1CINS        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1CINS        ZA0124                         Cr Int pay A/C
      * Send message 'Cr Int Pay A/C N-sub mand'
     C                   MOVEL     'USR1936'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9958      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1CINS        WUACCD                         Account Code
      * Check A/c Code Numeric - Account Codes  *
     C                   MOVEL     *IN90         XG90              1            * Save *IN90
     C*********************TESTN          WUAFNB     90  90* Check numericS01229
     C***90****************MOVE WUAFNB    XGX1    1        Check +ve      S01229
     C                   TESTN                   WUACCD               90  90    * Check numericS0122
     C   90              MOVE      WUACCD        XGX1              1            Check +ve      S0122
     C   90              TESTB     '0123'        XGX1                     90    *
     C**N90****************MOVELWUAFNB    XGX1                            S01229
     C  N90              MOVEL     WUACCD        XGX1                                          S0122
     C  N90XGX1          COMP      '?'                                    90    * ? is OK
     C     *IN90         IFEQ      '0'
     C*********************MOVE 'N'       WUFEST                          S01229
     C                   MOVE      'N'           WUNMFL                                        S0122
     C                   END
     C     *IN90         IFEQ      '1'
     C     XGX1          IFEQ      '?'
     C*********************MOVE '?'       WUFEST                          S01229
     C                   MOVE      '?'           WUNMFL                                        S0122
     C                   ELSE
     C*********************MOVE 'Y'       WUFEST                          S01229
     C                   MOVE      'Y'           WUNMFL                                        S0122
     C                   END
     C                   END
     C                   MOVEL     XG90          *IN90                          * Restore *IN90
      * Select Request
      * CASE: WRK.Numeric flag is Select request
     C     WUNMFL        IFEQ      '?'                                          *IF
      * Select Account Codes - Account Codes  *
     C                   CALL      'SD0031S'                            90      Select Account
     C                   PARM      *BLANK        W0RTN             7
     C********** #1CINS    PARM #1CINS    WQ0080  4        Account Code                       CGL029
     C     #1CINS        PARM      #1CINS        WQ0080           10
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
     C                   SETON                                        9958      *
     C                   END
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   MOVEL     'Y'           WUNMFL                         Numeric flag
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Numeric
     C     WUNMFL        IFEQ      'Y'                                          *IF
      * retrieve type as well - Account Codes  *
     C                   EXSR      SORVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1CINS        ZA0125                         Cr Int pay A/C
      * Send message 'A/C Code NF - Highlight'
     C                   MOVEL     'USR0173'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9958      *
      *
     C                   ELSE
      * CASE: DTL.Account Code EQ DTL.Cr Int pay A/C code N-Sub
     C     #1ACCD        IFEQ      #1CINS                                       *IF
      * Setup message data for message
     C                   MOVEL     #1CINS        ZA0126                         Cr Int pay A/C
      * Send message 'Self Ref Cr Int Pay N-sub'
     C                   MOVEL     'USR1937'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9958      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: WRK.Account type is Retail Accounts
     C     WUACTY        IFEQ      'R'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CINS        ZA0127                         Cr Int pay A/C
      * Send message 'Account code mustn't be R'
     C                   MOVEL     'USR0176'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9958      *
      *
     C                   END                                                    *FI
      * CASE: WRK.Title Only Indicator is YES
     C     WUTOIN        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CINS        ZA0128                         Cr Int pay A/C
      * Send message 'Account code mustn't be t'
     C                   MOVEL     'USR0221'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9958      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.Numeric flag is Alpha-numeric
     C     WUNMFL        IFEQ      'N'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CINS        ZA0129                         Cr Int pay A/C
      * Send message 'Invalid Account Code'
     C                   MOVEL     'USR0183'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9958      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Cr Int pay A/C code N-Sub is Non-blank
     C     #1CINS        IFNE      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1CINS        ZA0130                         Cr Int pay A/C
      * Send message 'Cr Int Pay AC N-sub prhbd'
     C                   MOVEL     'USR1938'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9958      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * end S01413
      * Start of SAR S01212
      * 00/Copy Member SD0031RVSR - Account Codes  *
     C*
     C/COPY WNCPYSRC,SD0031RVSR
     C*
      * End of SAR S01212
      *================================================================
      *                                                                   CTI002
      * Only check if CTI002 feature is active                            CTI002
     C     WUTI02        IFEQ      'Y'                                                         CTI00
     C     BGN3ST        ANDEQ     'Y'                                          Trade Innovat  CTI00
     C     CTI007        OREQ      'Y'
      *                                                                   CTI002
      * Trade Finance Indicator must be a Y or N                          CTI002
     C     #1TFCA        IFNE      'Y'                                                         CTI00
     C     #1TFCA        ANDNE     'N'                                                         CTI00
      * Send message 'The field must be either Y or N'                    CTI002
     C                   MOVEL     'EMT0012'     ZAMSID                                        CTI00
     C                   MOVEL     'EMUSRMSG'    ZAMSGF                                        CTI00
     C                   MOVEL     #1TFCA        ZAMSDA                                        CTI00
     C                   EXSR      ZASNMS                                                      CTI00
     C*********************SETON                     9960           CTI002CFT002
     C                   SETON                                        9962                     CFT00
     C                   ENDIF                                                                 CTI00
      *                                                                   CTI002
      *                                                                   CTI002
     C     #1TFCA        IFEQ      'Y'                                                         CTI00
     C     #1ACTY        ANDNE     'G'                                                         CTI00
      * Send message TRADE FINANCE ACCOUNT MUST BE A GENERAL LEDGER A/C   CTI002
     C                   MOVEL     'EMT0013'     ZAMSID                                        CTI00
     C                   MOVEL     'EMUSRMSG'    ZAMSGF                                        CTI00
     C                   MOVEL     #1TFCA        ZAMSDA                                        CTI00
     C                   EXSR      ZASNMS                                                      CTI00
     C*********************SETON                     9960           CTI002CFT002
     C                   SETON                                        9962                     CFT00
     C                   ENDIF                                                                 CTI00
      *                                                                   CTI002
      *                                                                   CTI002
     C     #1TFCA        IFEQ      *BLANK                                                      CTI00
      * Send message 'The field is Mandatory   '                          CTI002
     C                   MOVEL     'EMT0011'     ZAMSID                                        CTI00
     C                   MOVEL     'EMUSRMSG'    ZAMSGF                                        CTI00
     C                   MOVEL     #1TFCA        ZAMSDA                                        CTI00
     C                   EXSR      ZASNMS                                                      CTI00
     C*********************SETON                     9960           CTI002CFT002
     C                   SETON                                        9962                     CFT00
     C                   ENDIF                                                                 CTI00
      *                                                                   CTI002
     C     #1TFCA        IFEQ      'Y'                                                         CTI00
     C     #1TIAT        ANDEQ     *BLANKS                                                     CTI00
     C     CTI007        ANDEQ     'N'
     C                   MOVEL     'EMT0042'     ZAMSID                                        CTI00
     C                   MOVEL     'EMUSRMSG'    ZAMSGF                                        CTI00
     C                   MOVEL     #1TFCA        ZAMSDA                                        CTI00
     C                   EXSR      ZASNMS                                                      CTI00
     C*********************SETON                     9960           CTI002CFT002
     C                   SETON                                        9962                     CFT00
     C                   ENDIF                                                                 CTI00
      *                                                                   CTI002
      * ===============================================================   CTI002
      * If no errors                                                      CTI002
      * If field screen Trade Finance Contingent Account                  CTI002
      * move from Y to N when we show an other bottom                     CTI002
      * footer text to oblige the customer to confirm                     CTI002
      * the deletion                                                      CTI002
     C************IN60     IFEQ '0'                                 CTI002CFT002
     C     *IN62         IFEQ      '0'                                                         CFT00
     C     #1TFCA        IFEQ      'N'                                                         CTI00
     C     WKTFCA        ANDEQ     'Y'                                                         CTI00
     C     WYNCA         IFNE      'Y'                                                         CTI00
     C                   MOVEL     'Y'           WYNCA                                         CTI00
     C                   MOVEL     'Y'           W0DCF                                         CTI00
     C                   MOVEL     ##CTX1        WOCTX1                                        CTI00
     C* Setup footer text:                                                CTI002
     C* F10=Confirm  F12=Previous                                         CTI002
     C                   MOVEL     'USR4288'     WUMSID            7            Message IdentifCTI00
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF mCTI00
     C     WUMSID        PARM      WUMSID        KE0286            7            Message IdentifCTI00
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File NaCTI00
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text   CTI00
     C                   MOVEL     WUMTXT        ##CTX1                                        CTI00
     C                   ELSE                                                                  CTI00
     C     *IN10         IFNE      '1'                                                         CTI00
     C     *IN12         ANDNE     '1'                                                         CTI00
      * Send message 'Only F10 and F12 are allowed'                       CTI002
     C                   MOVEL     'EMT0015'     ZAMSID                                        CTI00
     C                   MOVEL     'EMUSRMSG'    ZAMSGF                                        CTI00
     C                   EXSR      ZASNMS                                                      CTI00
     C                   SETON                                        99                       CTI00
     C                   ENDIF                                                                 CTI00
     C                   ENDIF                                                                 CTI00
     C                   ELSE                                                                  CTI00
     C     WYNCA         IFEQ      'Y'                                                         CTI00
     C                   MOVEL     'N'           WYNCA                                         CTI00
     C                   MOVEL     'Y'           W0DCF                                         CTI00
     C* Restore previous footer text:                                     CTI002
     C                   MOVEL     WOCTX1        ##CTX1                                        CTI00
     C                   ENDIF                                                                 CTI00
     C                   ENDIF                                                                 CTI00
     C                   ENDIF                                                                 CTI00
      *                                                                   CTI002
      * End of WUTI02 check                                               CTI002
     C                   ENDIF                                                                 CTI00
      *                                                                   CTI002
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   EBPR##        BEGSR
      *================================================================
      * Process record:
      *================================================================
      * Process delete request                                            CTI002
     C***10                CAS            EDDLRQ                          CTI002
      * Process add request                                               CTI002
     C***********W0PMD     CASEQ'ADD'     ECADRQ                          CTI002
      * Process update request                                            CTI002
     C***********W0PMD     CASNE'ADD'     EECHRQ                          CTI002
     C*********************END                                            CTI002
     C                   SELECT                                                                CTI00
      * Process delete request                                            CTI002
     C     *IN10         WHENEQ    '1'                                                         CTI00
     C     WYNCA         ANDNE     'Y'                                                         CTI00
     C                   EXSR      EDDLRQ                                                      CTI00
      *                                                                   CTI002
      * Process update request 1                                          CTI002
     C     *IN10         WHENEQ    '1'                                                         CTI00
     C     WYNCA         ANDEQ     'Y'                                                         CTI00
     C     W0PMD         ANDNE     'ADD'                                                       CTI00
     C                   EXSR      EECHRQ                                                      CTI00
      *                                                                   CTI002
      * Process update request 2                                          CTI002
     C     W0PMD         WHENNE    'ADD'                                                       CTI00
     C                   EXSR      EECHRQ                                                      CTI00
      *                                                                   CTI002
      * Process add request                                               CTI002
     C     W0PMD         WHENEQ    'ADD'                                                       CTI00
     C                   EXSR      ECADRQ                                                      CTI00
      *                                                                   CTI002
     C                   END                                                                   CTI00
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
      * Start of SAR S01212
      * 00/Copy Member SD0031RPCK - Account Codes  *
     C*
     C/COPY WNCPYSRC,SD0031RPCK
     C*
      * End of SAR S01212
      * Start of S01522
      * User Defined Correspondence
      * CASE:
      *  - c1 AND c2 AND c3
      *   |- c1    : PAR.Action Code is Insert or Amend
      *   |- c2    : WRK.User Defined Correspondnc is Yes
      *   |- c3    : DTL.Title Only Indicator is NO
      *   '-
     C                   MOVEL     '0'           Y0CX01            1
     C     P2ANCD        IFEQ      'A'                                          *IF
     C     P2ANCD        OREQ      'I'
     C     WUN1ST        IFEQ      'Y'                                          *IF
     C     #1TOIN        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     Y0CX01        IFEQ      '1'                                          *IF
      *                                                                                     MD062338
      ** Change ZMITEM to UDC Maintenance Menu Item                                         MD062338
     C     *LOCK         IN        ZMITEM                                                   MD062338
     C                   EVAL      INDX = UDCMNT                                            MD062338
     C                   OUT       ZMITEM                                                   MD062338
      *                                                                                     MD062338
     C                   MOVEL     *BLANK        WURTCD                         Return Code wor
      * Call the UDC CL PGM - Account Codes  *
     C                   CALL      'CGC0021'                            90      Call the UDC CL
     C     WURTCD        PARM      WURTCD        WQ0081            7            Return Code wor
     C                   PARM      P2ANCD        WQ0082            1            Action Code
     C**********           PARM P1ACCD    WQ0083  4        Account Code                       CGL029
     C                   PARM      P1ACCD        WQ0083           10
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'CGC0021'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *                                                                                     MD062338
      ** Change ZMITEM back to Account Codes Maintenance Menu Item                          MD062338
     C     *LOCK         IN        ZMITEM                                                   MD062338
     C                   EVAL      INDX = ACCMNT                                            MD062338
     C                   OUT       ZMITEM                                                   MD062338
      *
      * F3 Prpcessing
      * CASE: WRK.Return Code work field is USER QUIT REQUESTED
     C     WURTCD        IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * F12 Processing
      * CASE: WRK.Return Code work field is Previous screen
     C     WURTCD        IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of S01522
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
      * Create Account Codes - Account Codes  *
     C                   EXSR      SPCRRC
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
     C*                                                                   185171
     C** Before deleting a record, check first if there's an existing     185171
     C** account/s in GL a/c file using that a/c code.                    185171
     C*                                                                   185171
     C                   MOVEL     *BLANK        W0RTN                                         18517
     C     *LIKE         DEFINE    ACOD          WQSO02                                        18517
     C     KEYACO        KLIST                                                                 18517
     C                   KFLD                    WQSO02                                        18517
     C                   MOVEL     #1ACCD        WQSO02                                        18517
     C     KEYACO        SETLL     AUACNTV1                                                    18517
     C     KEYACO        CHAIN     AUACNTV1                           90                       18517
     C*                                                                   185171
     C** IF record found, send message 'Record cannot be deleted -        185171
     C** a/c code is in use'.                                             185171
     C*                                                                   185171
     C     *IN90         IFEQ      '0'                                                         18517
     C                   MOVEL     'Y2U0090'     W0RTN                                         18517
     C                   MOVEL     'Y2U0090'     ZAMSID                                        18517
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        18517
     C                   EXSR      ZASNMS                                                      18517
     C                   GOTO      EDEXIT                                                      18517
     C                   ENDIF                                                                 18517
     C*                                                                   185171
      * Delete Account Codes - Account Codes  *
     C                   EXSR      STDLRC
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
      * Change Account Codes - Account Codes  *
     C                   EXSR      SYCHRC
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
     C     P1ACCD        IFEQ      *BLANK                                       Account Code
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
     C     WUDELA        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN78
     C     WUDMPN        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN78
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN77
     C     WUDMPC        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN77
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN76
     C     WUCMC1        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN76
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN75
     C     WUN3ST        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN75
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN74
     C********** WUPFMG    IFEQ *BLANK                     *IF            CPB001
     C********** WUPFMG    OREQ 'N'                                       CPB001
     C     WUPFMG        IFNE      'Y'                                                         CPB00
     C     WUN4ST        ANDNE     'Y'                                                         CPB00
     C                   MOVEL     '1'           *IN74
     C                   END                                                    *FI
      *                                                                                      BUG3078
     C     CGL014        IFEQ      'Y'
     C     CLE025        OREQ      'Y'
     C                   MOVE      *OFF          *IN74
     C                   ENDIF
      *                                                                                      BUG3078
     C                   MOVEL     '0'           *IN72
     C                   MOVEL     '0'           *IN73
      *                                                                                     MD028343
     C     *IN61         IFEQ      '1'
     C                   MOVEL     WWHTX         #1WHTF
     C                   ENDIF
      *                                                                                     MD028343
     C     WUDSWT        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN72
     C                   MOVEL     '1'           *IN73
     C                   MOVEL     *BLANKS       #1WHTF
     C                   END                                                    *FI
      * Enable key screen
     C                   SETON                                        87        *
      *----------------------------------------------------------------CFT002
      * If Decode & Auto Gen Installed, display Vostro and Loro Codes  CFT002
      *                                                                CFT002
     C     CFT002        IFEQ      'Y'                                          If Feature OCFT002
     C                   MOVE      *ON           *IN71                           Set Ind    CFT002
     C                   ELSE                                                   Else        CFT002
     C                   MOVE      *OFF          *IN71                           Set Ind    CFT002
     C                   ENDIF                                                  End If      CFT002
      *                                                                   CPB004
      * If "Acount Closing" is installed                                  CPB004
      *                                                                   CPB004
     C     WPB004        IFEQ      'Y'                                          If Feature     CPB00
     C                   MOVE      *ON           *IN66                           Set Ind       CPB00
     C                   ELSE                                                   Else           CPB00
     C                   MOVE      *OFF          *IN66                           Set Ind       CPB00
     C                   ENDIF                                                  End If         CPB00
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise record - except for key fields and "neither" paramete
      *================================================================
     C                   MOVEL     *BLANK        #1ACGC                         Midas Export Va
     C                   MOVEL     *BLANK        #1MATR                         Man A/C Anal Tr
     C                   MOVEL     *BLANK        #1FNAC                         Funding Account
     C                   MOVEL     *BLANK        #1FNBR                         Funding Base Ra
     C                   MOVEL     *BLANK        #1FNIC                         Funding Int A/C
     C                   MOVEL     *BLANK        #1FNAA                         Funding Accrual
     C                   MOVEL     *BLANK        #1CAAC                         Capitalise to t
     C                   MOVEL     *BLANK        #DACTF                         Account Type fu
     C                   MOVEL     *BLANK        #DTIOF                         Title Only func
     C                   MOVEL     *BLANK        #DACSF                         Account Sub-Typ
     C                   Z-ADD     *ZERO         #1ACPR                         Acct Post Reten
     C                   Z-ADD     *ZERO         #1MISU                         Min Int subject
     C                   Z-ADD     *ZERO         #1LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #1TYLC                         Type of Last Ch
     C                   Z-ADD     *ZERO         #1SRLC                         Stat Returns BS
     C                   Z-ADD     *ZERO         #1SRFC                         Stat Returns BS
     C                   MOVEL     *BLANK        #DTATS                         TI Account Type
     C                   Z-ADD     *ZERO         #1RPCD                         Reporting Code
     C                   MOVEL     *BLANK        #1TRFD                         A/C transferred
     C                   MOVEL     *BLANK        #DMISF                         Min Int sub to
     C                   MOVEL     *BLANK        #1ACCN                         Account Code Na
     C                   MOVEL     *BLANK        #1ACC2                         Account Code NaCSD00
     C                   MOVEL     *BLANK        #1NARR                         Acct Code Narr CSD00
     C                   MOVEL     *BLANK        #1ACTY                         Account type
     C                   MOVEL     *BLANK        #1ACST                         Account Sub-typ
     C                   MOVEL     *BLANK        #DMAPF                         Man Accnt Anal
     C                   MOVEL     *BLANK        #1MAPC                         Man A/C Anal Pr
     C                   MOVEL     *BLANK        #1ACSC                         Account Section
     C                   MOVEL     *BLANK        #1MABK                         Man A/C Anal Bo
     C                   MOVEL     *BLANK        #DAPRA                         A/c Posting Ret
     C                   MOVEL     *BLANK        #1MAAC                         Man A/C Anal As
     C                   MOVEL     *BLANK        #1TOIN                         Title Only Indi
     C                   MOVEL     *BLANK        #1MAPR                         Man A/C Anal Pr
     C                   MOVEL     *BLANK        #DFLD1                         Field one
     C                   MOVEL     *BLANK        #1DIAD                         Debt Interest A
     C                   MOVEL     *BLANK        #DFLD2                         Field two
     C                   MOVEL     *BLANK        #1DIAC                         Debt Interest A
     C                   MOVEL     *BLANK        #DFLD3                         Field three
     C                   MOVEL     *BLANK        #1CIAD                         Credit Int. Acc
     C                   MOVEL     *BLANK        #DFLD4                         Field four
     C                   MOVEL     *BLANK        #1CIAC                         Credit Int. Acc
     C                   MOVEL     *BLANK        #DFLD5                         Field five
     C                   MOVEL     *BLANK        #1ICID                         Interest Capita
     C                   MOVEL     *BLANK        #DFLD6                         Field six
     C                   MOVEL     *BLANK        #1ICIC                         Interest Capita
     C                   MOVEL     *BLANK        #DSRLF                         Stat Returns L/
     C                   MOVEL     *BLANK        #DSRFF                         Stat Returns F/
     C                   MOVEL     *BLANK        #1TIAT                         TI Account Type
     C                   MOVEL     *BLANK        #DRPCF                         Reporting Code
     C                   MOVEL     *BLANK        #1INNR                         PM Instrument C
     C                   MOVEL     *BLANK        #1DIPD                         Dr Int pay A/C
     C                   MOVEL     *BLANK        #1DIPC                         Dr Int pay A/C
     C                   MOVEL     *BLANK        #1WTAC                         Withholding Tax
     C                   MOVEL     *BLANK        #1CIPC                         Cr Int pay A/C
     C                   MOVEL     *BLANK        #DWTSC                         Withholding Tax
     C                   MOVEL     *BLANK        #1CISU                         Cr Int pay A/C
     C                   MOVEL     *BLANK        #1CINS                         Cr Int pay A/C
     C                   MOVEL     *BLANK        #1VOST                         Vostro A/C FlagCFT00
     C                   MOVEL     *BLANK        #1LORO                         Loro A/C Flag  CFT00
     C     BGN3ST        IFEQ      'Y'                                                         CTI00
     C     CTI007        OREQ      'Y'
     C                   MOVEL     'N'           #1TFCA                                        CTI00
     C                   ELSE                                                                  CTI00
     C                   MOVEL     *BLANK        #1TFCA                                        CTI00
     C                   ENDIF                                                                 CTI00
      *                                                                   CGL010
     C/COPY WNCPYSRC,SD0031RC12
      ** Transitory Account Codes                                         CGL010
      *                                                                   CGL010
     C                   MOVEL     *BLANKS       DDTRDA                                        CGL01
     C                   MOVEL     *BLANKS       DDTRCA                                        CGL01
     C                   MOVE      *BLANKS       #1GACD
     C                   MOVE      *BLANKS       #1PRDC
     C                   MOVE      *BLANKS       #1INSC
      *                                                                   CPB004
     C                   MOVEL     *BLANK        #1TRAN                                        CPB00
      *                                                                                       CSD031
      ** Central Data and Effective Date field                                                CSD031
      *                                                                                       CSD031
     C     CSD032        IFEQ      'Y'
     C                   MOVEL     *BLANK        #1CDTA
     C                   MOVEL     *BLANK        #1EFDT
     C                   ELSE
     C                   MOVEL     *BLANK        A5IUSR
     C                   MOVEL     *BLANK        A5AUSR
     C                   MOVEL     *BLANK        A5XUSR
     C                   MOVEL     *BLANK        A5AACC
     C                   MOVE      *ZERO         A5EACC
     C                   MOVEL     *BLANK        A5GPDT
     C                   ENDIF
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT                                                                                  CRE015
     CSR   MXIZ#1        BEGSR
      *================================================================                       CRE015
      * Initialise record - Defaulting of field values                                        CRE015
      *================================================================                       CRE015
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     'O'           #1ATTY                         Agreed Period
     C                   MOVEL     *BLANK        #1CHIA                         Penalty A/c Cde
     C                   MOVEL     *BLANK        #1RTTY                         Penalty Trn Typ
     C                   MOVEL     *BLANK        #1NCVD                         Penalty Nar Cde
     C                   MOVEL     *BLANK        #1PRFC                         Penalty Prf Ctr
     C                   MOVEL     *BLANK        #1RTDN                         Reten Cus Notif
     C                   MOVEL     *BLANK        #1RTDI                         Reten Int Notif
     C                   ENDIF
      *================================================================                       CRE015
     CSR   MXEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @A5REA6 fields to screen
      *================================================================
     C                   MOVEL     A5ACGC        #1ACGC                         Midas Export Va
     C                   MOVEL     A5MATR        #1MATR                         Man A/C Anal Tr
     C                   MOVEL     A5FNAC        #1FNAC                         Funding Account
     C                   MOVEL     A5FNBR        #1FNBR                         Funding Base Ra
     C                   MOVEL     A5FNIC        #1FNIC                         Funding Int A/C
     C                   MOVEL     A5FNAA        #1FNAA                         Funding Accrual
     C                   MOVEL     A5CAAC        #1CAAC                         Capitalise to t
     C                   Z-ADD     A5ACPR        #1ACPR                         Acct Post Reten
     C                   Z-ADD     A5MISU        #1MISU                         Min Int subject
     C                   Z-ADD     A5LCD         #1LCD                          Last Change Dat
     C                   MOVEL     A5TYLC        #1TYLC                         Type of Last Ch
     C                   Z-ADD     A5SRLC        #1SRLC                         Stat Returns BS
     C                   Z-ADD     A5SRFC        #1SRFC                         Stat Returns BS
     C                   Z-ADD     A5RPCD        #1RPCD                         Reporting Code
     C                   MOVEL     A5TRFD        #1TRFD                         A/C transferred
     C                   MOVEL     A5ACCD        #1ACCD                         Account Code
     C                   MOVEL     A5ACCN        #1ACCN                         Account Code Na
     C                   MOVEL     A5ACCN        #1ACC2                         Acct Code NAME CSD00
     C                   MOVEL     A5NARR        #1NARR                         Acct Code NarraCSD00
     C                   MOVEL     A5ACTY        #1ACTY                         Account type
     C                   MOVEL     A5ACST        #1ACST                         Account Sub-typ
     C                   MOVEL     A5MAPC        #1MAPC                         Man A/C Anal Pr
     C                   MOVEL     A5ACSC        #1ACSC                         Account Section
     C                   MOVEL     A5MABK        #1MABK                         Man A/C Anal Bo
     C                   MOVEL     A5MAAC        #1MAAC                         Man A/C Anal As
     C                   MOVEL     A5TOIN        #1TOIN                         Title Only Indi
     C                   MOVEL     A5MAPR        #1MAPR                         Man A/C Anal Pr
     C                   MOVEL     A5DIAD        #1DIAD                         Debt Interest A
     C                   MOVEL     A5DIAC        #1DIAC                         Debt Interest A
     C                   MOVEL     A5CIAD        #1CIAD                         Credit Int. Acc
     C                   MOVEL     A5CIAC        #1CIAC                         Credit Int. Acc
     C                   MOVEL     A5ICID        #1ICID                         Interest Capita
     C                   MOVEL     A5ICIC        #1ICIC                         Interest Capita
     C                   MOVEL     A5TIAT        #1TIAT                         TI Account Type
     C                   MOVEL     A5INNR        #1INNR                         PM Instrument C
     C                   MOVEL     A5DIPD        #1DIPD                         Dr Int pay A/C
     C                   MOVEL     A5DIPC        #1DIPC                         Dr Int pay A/C
     C/COPY WNCPYSRC,SD0031RC18
     C                   MOVEL     A5WTAC        #1WTAC                         Withholding Tax
      *                                                                                       CDL013
     C     CDL013        IFEQ      '1'
     C                   MOVEL     EACRE         #1WTAC                         WHT Ret. A/CD
     C                   MOVEL     EACCO         #1WTCC                         WHT Corp. A/CD
     C                   ENDIF
      *                                                                                       CDL013
     C/COPY WNCPYSRC,SD0031RC19
     C                   MOVEL     A5CIPC        #1CIPC                         Cr Int pay A/C
     C                   MOVEL     A5CISU        #1CISU                         Cr Int pay A/C
     C                   MOVEL     A5CINS        #1CINS                         Cr Int pay A/C
     C                   MOVEL     A5VOST        #1VOST                         Vostro A/C FlagCFT00
     C                   MOVEL     A5LORO        #1LORO                         Loro A/C Flag  CFT00
     C                   MOVEL     A5TFCT        #1TFCA                                        CTI00
      *                                                                                       CGP001
      ** Move the Global Processing fields to screen                                          CGP001
      ** if CGP001 is enabled.                                                                CGP001
      *                                                                                       CGP001
     C     CGP001        IFEQ      'Y'
     C                   EXSR      SRGPAC
     C                   EXSR      SRGPPI
      *                                                                                       CSD031
      ** Central Data and Effective Date                                                      CSD031
      *                                                                                       CSD031
     C     CSD032        IFEQ      'Y'
     C                   CALL      'ZDATE2'
     C                   PARM                    A5EACC
     C                   PARM      'D'           ZJDFIN            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    DATEB             7
     C                   MOVEL     DATEB         #1EFDT
     C                   MOVEL     A5GPDT        #1CDTA
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CPB004
     C     WPB004        IFEQ      'Y'
     C                   MOVEL     A5TRAN        #1TRAN
     C                   ENDIF
      *                                                                                       CPB004
     C/COPY WNCPYSRC,SD0031RC13
      * Hold existing record image
     C                   MOVEL     @1DBRC        #1DBRC
      *                                                                                       CDL013
      * Hold existing record image(Extension File)                                            CDL013
     C     CDL013        IFEQ      '1'
     C                   MOVEL     @1DBRX        #1DBRX
     C                   ENDIF
     C/COPY WNCPYSRC,SD0031RC20
      *                                                                   CGL010
      ** Transitory Account Codes                                         CGL010
      *                                                                   CGL010
     C     A5TRDA        IFGT      *ZERO                                                       CGL01
     C                   MOVEL     A5TRDA        DDTRDA                                        CGL01
     C                   ENDIF                                                                 CGL01
     C     A5TRCA        IFGT      *ZERO                                                       CGL01
     C                   MOVEL     A5TRCA        DDTRCA                                        CGL01
     C                   ENDIF                                                                 CGL01
      *                                                                                       CRE015
      ** Term and Notice Account Details                                                      CRE015
      *                                                                                       CRE015
     C     CRE015        IFEQ      'Y'
     C     #1ACTY        ANDEQ     'R'
     C                   MOVEL     #1ACCD        PCACCD
     C     KRTVAC        CHAIN     SDACD1D0                           9091
     C                   MOVEL     A5ACCD        #1ACCD
     C     *IN90         IFEQ      '1'
     C                   MOVE      'O'           #1ATTY
     C                   MOVE      *BLANKS       #1CHIA
     C                   MOVE      *BLANKS       #1RTTY
     C                   MOVE      *BLANKS       #1NCVD
     C                   MOVE      *BLANKS       #1PRFC
     C                   MOVE      *BLANKS       #1RTDN
     C                   MOVE      *BLANKS       #1RTDI
     C                   ELSE
     C                   MOVE      A5ATTY        #1ATTY
     C                   MOVE      A5RTTY        #1RTTY
     C                   MOVE      A5NVCD        #1NCVD
     C                   MOVE      A5PRFC        #1PRFC
     C     A5CHIA        IFEQ      *ZERO
     C                   MOVE      *BLANKS       #1CHIA
     C                   ELSE
     C                   MOVE      A5CHIA        #1CHIA
     C                   ENDIF
     C     A5RTDN        IFEQ      *ZERO
     C                   MOVE      *BLANKS       #1RTDN
     C                   ELSE
     C                   MOVE      A5RTDN        #1RTDN
     C                   ENDIF
     C     A5RTDI        IFEQ      *ZERO
     C                   MOVE      *BLANKS       #1RTDI
     C                   ELSE
     C                   MOVE      A5RTDI        #1RTDI
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialize key screen
      *================================================================
      *                                                                                       CSD031
      ** If Change mode, protect global fields                                                CSD031
      *                                                                                       CSD031
     C     PMODE         IFEQ      'C'
     C     CSD032        ANDEQ     'Y'
     C                   MOVE      *ON           *IN92
     C                   ENDIF
      *                                                                                       CSD031
     C                   MOVEL     P1ACCD        #1ACCD                         Account Code
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
      * Start of SAR S01212
      * 00/Copy Member SD0031RIKS - Account Codes  *
     C*
     C/COPY WNCPYSRC,SD0031RIKS
     C*
      * End of SAR S01212
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Retrieve Record - Account Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSA         KLIST
     C                   KFLD                    A5ACCD                         Account Code
      * Move fields to key list
     C                   MOVEL     #1ACCD        A5ACCD                         Account Code
     C     KRSSA         CHAIN     @A5REA6                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0069'     W0RTN             7
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
      * Fetch Retention Period - General Ledger Details  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSB         KLIST
     C                   KFLD                    BKGNLG                         General Ledger
      * Move fields to key list
     C                   MOVE      *BLANK        BKGNLG                         General Ledger
     C                   MOVEL     'GELR'        BKGNLG                         General Ledger
     C     KRSSB         CHAIN     @BKREEC                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0199'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
      * Setup message data for message
     C                   MOVEL     'SDGELRPD'    ZA0020                         Filename
      * Send message 'Database Error (ICD)'
     C                   MOVEL     'USR0377'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   GOTO      SBEXIT                                       *QUIT
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
      * PAR = DB1 By name
     C                   Z-ADD     BKAPRP        WUAPRP                         A/c Posting Ret
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCRVGN        BEGSR
      *================================================================
      * Get A/C cde, Type & Sctn - Account Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSC         KLIST
     C                   KFLD                    A5ACCD                         Account Code
      * Move fields to key list
     C                   MOVEL     #1DIAD        A5ACCD                         Account Code
     C     KRSSC         CHAIN     @A5REA6                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0069'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SCEXIT
     C                   END
      *
      * USER: Exit processing
      * PAR = DB1 By name
     C                   MOVEL     A5ACTY        WUACTY                         Account type
     C                   MOVEL     A5TOIN        WUTOIN                         Title Only Indi
     C                   MOVEL     A5ACSC        WUACSC                         Account Section
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDRVGN        BEGSR
      *================================================================
      * Get A/C cde, Type & Sctn - Account Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSD         KLIST
     C                   KFLD                    A5ACCD                         Account Code
      * Move fields to key list
     C                   MOVEL     #1DIAC        A5ACCD                         Account Code
     C     KRSSD         CHAIN     @A5REA6                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0069'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SDEXIT
     C                   END
      *
      * USER: Exit processing
      * PAR = DB1 By name
     C                   MOVEL     A5ACTY        WUACTY                         Account type
     C                   MOVEL     A5TOIN        WUTOIN                         Title Only Indi
     C                   MOVEL     A5ACSC        WUACSC                         Account Section
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   SERVGN        BEGSR
      *================================================================
      * Get A/C cde, Type & Sctn - Account Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSE         KLIST
     C                   KFLD                    A5ACCD                         Account Code
      * Move fields to key list
     C                   MOVEL     #1CIAD        A5ACCD                         Account Code
     C     KRSSE         CHAIN     @A5REA6                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0069'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SEEXIT
     C                   END
      *
      * USER: Exit processing
      * PAR = DB1 By name
     C                   MOVEL     A5ACTY        WUACTY                         Account type
     C                   MOVEL     A5TOIN        WUTOIN                         Title Only Indi
     C                   MOVEL     A5ACSC        WUACSC                         Account Section
      *================================================================
     CSR   SEEXIT        ENDSR
      /EJECT
     CSR   SFRVGN        BEGSR
      *================================================================
      * Get A/C cde, Type & Sctn - Account Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSF         KLIST
     C                   KFLD                    A5ACCD                         Account Code
      * Move fields to key list
     C                   MOVEL     #1CIAC        A5ACCD                         Account Code
     C     KRSSF         CHAIN     @A5REA6                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0069'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SFEXIT
     C                   END
      *
      * USER: Exit processing
      * PAR = DB1 By name
     C                   MOVEL     A5ACTY        WUACTY                         Account type
     C                   MOVEL     A5TOIN        WUTOIN                         Title Only Indi
     C                   MOVEL     A5ACSC        WUACSC                         Account Section
      *================================================================
     CSR   SFEXIT        ENDSR
      /EJECT
     CSR   SGRVGN        BEGSR
      *================================================================
      * Get A/C cde, Type & Sctn - Account Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSG         KLIST
     C                   KFLD                    A5ACCD                         Account Code
      * Move fields to key list
     C                   MOVEL     #1ICID        A5ACCD                         Account Code
     C     KRSSG         CHAIN     @A5REA6                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0069'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SGEXIT
     C                   END
      *
      * USER: Exit processing
      * PAR = DB1 By name
     C                   MOVEL     A5ACTY        WUACTY                         Account type
     C                   MOVEL     A5TOIN        WUTOIN                         Title Only Indi
     C                   MOVEL     A5ACSC        WUACSC                         Account Section
      *================================================================
     CSR   SGEXIT        ENDSR
      /EJECT
     CSR   SHRVGN        BEGSR
      *================================================================
      * Get A/C cde, Type & Sctn - Account Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSH         KLIST
     C                   KFLD                    A5ACCD                         Account Code
      * Move fields to key list
     C                   MOVEL     #1ICIC        A5ACCD                         Account Code
     C     KRSSH         CHAIN     @A5REA6                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0069'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SHEXIT
     C                   END
      *
      * USER: Exit processing
      * PAR = DB1 By name
     C                   MOVEL     A5ACTY        WUACTY                         Account type
     C                   MOVEL     A5TOIN        WUTOIN                         Title Only Indi
     C                   MOVEL     A5ACSC        WUACSC                         Account Section
      *================================================================
     CSR   SHEXIT        ENDSR
      /EJECT
     CSR   SIRVGN        BEGSR
      *================================================================
      * Retrieve TI A/c Type - Trade Innov A/c Types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSI         KLIST
     C                   KFLD                    GDC5AT                         A/c Type
      * Move fields to key list
     C                   MOVEL     #1TIAT        GDC5AT                         A/c Type
     C*****KRSSI         CHAIN     @TIACL1                            90        *           MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDTIAC                                                                        MD058085
     C+ from SDTIAJW0                                                                       MD058085
     C+ where GDC5AT = :GDC5AT                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       90                    MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR3504'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SIEXIT
     C                   END
      *
      *================================================================
     CSR   SIEXIT        ENDSR
      /EJECT
     CSR   SJRVGN        BEGSR
      *================================================================
      * retrieve type as well - Account Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSJ         KLIST
     C                   KFLD                    A5ACCD                         Account Code
      * Move fields to key list
     C                   MOVEL     #1DIPD        A5ACCD                         Account Code
     C     KRSSJ         CHAIN     @A5REA6                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0069'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SJEXIT
     C                   END
      *
      * USER: Exit processing
      * PAR = DB1 By name
     C                   MOVEL     A5ACTY        WUACTY                         Account type
     C                   MOVEL     A5TOIN        WUTOIN                         Title Only Indi
      *================================================================
     CSR   SJEXIT        ENDSR
      /EJECT
     CSR   SKRVGN        BEGSR
      *================================================================
      * retrieve type as well - Account Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSK         KLIST
     C                   KFLD                    A5ACCD                         Account Code
      * Move fields to key list
     C                   MOVEL     #1DIPC        A5ACCD                         Account Code
     C     KRSSK         CHAIN     @A5REA6                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0069'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SKEXIT
     C                   END
      *
      * USER: Exit processing
      * PAR = DB1 By name
     C                   MOVEL     A5ACTY        WUACTY                         Account type
     C                   MOVEL     A5TOIN        WUTOIN                         Title Only Indi
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
     C                   MOVEL     #1WTAC        A5ACCD                         Account Code
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
      * retrieve type as well - Account Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSM         KLIST
     C                   KFLD                    A5ACCD                         Account Code
      * Move fields to key list
     C                   MOVEL     #1CIPC        A5ACCD                         Account Code
     C     KRSSM         CHAIN     @A5REA6                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0069'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SMEXIT
     C                   END
      *
      * USER: Exit processing
      * PAR = DB1 By name
     C                   MOVEL     A5ACTY        WUACTY                         Account type
     C                   MOVEL     A5TOIN        WUTOIN                         Title Only Indi
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
     C                   MOVEL     #1CISU        A5ACCD                         Account Code
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
      * retrieve type as well - Account Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSO         KLIST
     C                   KFLD                    A5ACCD                         Account Code
      * Move fields to key list
     C                   MOVEL     #1CINS        A5ACCD                         Account Code
     C     KRSSO         CHAIN     @A5REA6                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0069'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SOEXIT
     C                   END
      *
      * USER: Exit processing
      * PAR = DB1 By name
     C                   MOVEL     A5ACTY        WUACTY                         Account type
     C                   MOVEL     A5TOIN        WUTOIN                         Title Only Indi
      *================================================================
     CSR   SOEXIT        ENDSR
      /EJECT                                                                                  CDL013
     CSR   SPRVGN        BEGSR
      *================================================================                       CDL013
      * retrieve type as well - Account Codes  *                                              CDL013
      *================================================================                       CDL013
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist                                                                        CDL013
     C     KRSSP         KLIST
     C                   KFLD                    A5ACCD                         Account Code
      * Move fields to key list                                                               CDL013
     C                   MOVEL     #1WTCC        A5ACCD                         Account Code
     C     KRSSP         CHAIN     @A5REA6                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found                                                                 CDL013
     C                   MOVEL     'USR0069'     W0RTN             7
      * USER: Processing if Data record not found                                             CDL013
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      PREXIT
     C                   END
      *                                                                                       CDL013
      * USER: Exit processing                                                                 CDL013
      * PAR = DB1 By name                                                                     CDL013
     C                   MOVEL     A5ACTY        WUACTY                         Account type
     C                   MOVEL     A5TOIN        WUTOIN                         Title Only Indi
      *================================================================                       CDL013
     CSR   PREXIT        ENDSR
      /EJECT
     CSR   SPCRRC        BEGSR
      *================================================================
      * Create Account Codes - Account Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @A5UPA7
     C                   MOVEL     #1ACCD        A5ACCD                         Account Code
     C/COPY WNCPYSRC,SD0031RC21
      *                                                                                      CDL013
     C     CDL013        IFEQ      '1'
     C                   MOVEL     #1ACCD        EACOD                          Account Code
     C                   ENDIF
      *                                                                                      CDL013
     C                   MOVEL     #1CIAD        A5CIAD                         Credit Int. Acc
     C                   MOVEL     #1CIAC        A5CIAC                         Credit Int. Acc
     C                   MOVEL     #1DIAC        A5DIAC                         Debt Interest A
     C                   MOVEL     #1DIAD        A5DIAD                         Debt Interest A
     C                   MOVEL     #1ICIC        A5ICIC                         Interest Capita
     C                   MOVEL     #1ICID        A5ICID                         Interest Capita
     C                   Z-ADD     WURDNB        A5LCD                          Last Change Dat
     C                   MOVEL     'I'           A5TYLC                         Type of Last Ch
     C                   MOVEL     #1ACTY        A5ACTY                         Account type
     C*********************MOVEL#1ACCN    A5ACCN           Account Code NaCSD005
     C  N69              MOVEL     #1ACCN        A5ACCN                         Account Code NaCSD00
     C   69              MOVEL     #1ACC2        A5ACCN                         Account Code NaCSD00
     C                   MOVEL     #1NARR        A5NARR                         Acct Code Narr CSD00
     C                   Z-ADD     #1SRLC        A5SRLC                         Stat Returns BS
     C                   Z-ADD     #1SRFC        A5SRFC                         Stat Returns BS
     C                   MOVEL     #1TOIN        A5TOIN                         Title Only Indi
     C                   Z-ADD     #1RPCD        A5RPCD                         Reporting Code
     C                   MOVEL     #1ACSC        A5ACSC                         Account Section
     C                   MOVEL     #1ACST        A5ACST                         Account Sub-typ
     C                   Z-ADD     #1ACPR        A5ACPR                         Acct Post Reten
     C                   MOVEL     #1TRFD        A5TRFD                         A/C transferred
     C                   MOVEL     #1DIPD        A5DIPD                         Dr Int pay A/C
     C                   MOVEL     #1DIPC        A5DIPC                         Dr Int pay A/C
     C                   MOVEL     #1CIPC        A5CIPC                         Cr Int pay A/C
     C                   MOVEL     #1CISU        A5CISU                         Cr Int pay A/C
     C                   MOVEL     #1CINS        A5CINS                         Cr Int pay A/C
     C                   MOVEL     #1WTAC        A5WTAC                         Withholding Tax
      *                                                                                       CDL013
     C     CDL013        IFEQ      '1'
     C                   MOVEL     #1WTAC        EACRE                          WHT Ret. A/CD
     C                   MOVEL     #1WTCC        EACCO                          WHT Crp. A/CD
     C                   ENDIF
      *                                                                                       CDL013
     C/COPY WNCPYSRC,SD0031RC22
     C                   Z-ADD     #1MISU        A5MISU                         Min Int subject
     C                   MOVEL     #1ACGC        A5ACGC                         Midas Export Va
     C                   MOVEL     #1INNR        A5INNR                         PM Instrument C
     C                   MOVEL     #1MAPC        A5MAPC                         Man A/C Anal Pr
     C                   MOVEL     #1MABK        A5MABK                         Man A/C Anal Bo
     C                   MOVEL     #1MAAC        A5MAAC                         Man A/C Anal As
     C                   MOVEL     #1MATR        A5MATR                         Man A/C Anal Tr
     C                   MOVEL     #1MAPR        A5MAPR                         Man A/C Anal Pr
     C                   MOVEL     #1FNAC        A5FNAC                         Funding Account
     C                   MOVEL     #1FNBR        A5FNBR                         Funding Base Ra
     C                   MOVEL     #1FNIC        A5FNIC                         Funding Int A/C
     C                   MOVEL     #1FNAA        A5FNAA                         Funding Accrual
     C                   MOVEL     #1CAAC        A5CAAC                         Capitalise to t
     C                   MOVEL     #1TFCA        A5TFCT                                        CTI00
     C                   MOVEL     #1TIAT        A5TIAT                         TI Account Type
     C                   MOVEL     #1VOST        A5VOST                         Vostro A/C FlagCFT00
     C                   MOVEL     #1LORO        A5LORO                         Loro A/C Flag  CFT00
      *                                                                   CGL010
      ** If CGL010 is present                                             CGL010
      *                                                                   CGL010
     C     *IN65         IFEQ      *ON                                                         CGL01
     C                   MOVEL     DDTRDA        A5TRDA                                        CGL01
     C                   MOVEL     DDTRCA        A5TRCA                                        CGL01
     C                   ELSE                                                                  CGL01
     C                   Z-ADD     0             A5TRDA                                        CGL01
     C                   Z-ADD     0             A5TRCA                                        CGL01
     C                   ENDIF                                                                 CGL01
      *                                                                   CPB004
      ** If CPB004 is present                                             CPB004
      *                                                                   CPB004
     C     WPB004        IFEQ      'Y'                                                         CPB00
     C                   MOVEL     #1TRAN        A5TRAN                                        CPB00
     C                   ELSE                                                                  CPB00
     C                   MOVEL     *BLANKS       A5TRAN                                        CPB00
     C                   ENDIF                                                                 CPB00
      *
      * USER: Processing before Data update
      * Start of 042930
      * Title Only Indicator is blank
      * CASE: PAR.Title Only Indicator is Blank
     C     #1TOIN        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           A5TOIN                         Title Only Indi
     C                   END                                                    *FI
      * End of 042930
     C/COPY WNCPYSRC,SD0031RC03
      * Start of SAR S01212
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
      * Start of SAR S01117
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,WN0481CCP1                                           S01408
      *                                                                                       CER001
     C     ULX004        IFEQ      'Y'
     C     ULX043        OREQ      'Y'
     C     ULX053        OREQ      'Y'
      *                                                                                       CER001
     C                   Z-ADD     1             SCRN              1 0
      *                                                                                       CER001
     C     SCRN          DOULT     1
     C     SCRN          ORGT      3
      *                                                                                       CER001
     C                   MOVE      'N'           W0DCF
     C                   MOVEL     #1ACCD        #2ACCD
      *                                                                                       CER001
     C                   SELECT
     C     SCRN          WHENEQ    1
     C                   EXSR      SRLX04
     C     SCRN          WHENEQ    2
     C                   EXSR      SRLX43
     C     SCRN          WHENEQ    3
     C                   EXSR      SRLX52
     C                   ENDSL
      *                                                                                       CER001
      ** If enter key pressed                                                                 CER001
      *                                                                                       CER001
     C     W0RTN         IFEQ      *BLANKS
     C                   ADD       1             SCRN
     C                   ENDIF
      *                                                                                       CER001
      ** If F12 key pressed or window/DB error                                                CER001
      *                                                                                       CER001
     C     W0RTN         IFEQ      'USR0790'
     C     W0RTN         OREQ      'USR0563'
     C     W0RTN         OREQ      'Y2U0004'
     C                   MOVEL     'Y'           W0DCF
     C                   SUB       1             SCRN
     C                   ENDIF
      *                                                                                       CER001
      ** If F3 key pressed                                                                    CER001
      *                                                                                       CER001
     C     W0RTN         IFEQ      'Y2U9999'
     C                   LEAVE
     C                   ENDIF
      *                                                                                       CER001
     C                   ENDDO
      *                                                                                       CER001
     C     W0RTN         IFEQ      'Y2U9999'
     C                   MOVEL     'Y'           W0DCF
     C                   MOVEL     W0RTN         P0RTN
     C                   EXSR      ZYEXPG
     C                   ENDIF
      *                                                                                       CER001
     C     W0RTN         IFNE      *BLANKS
     C                   MOVE      'Y'           W0DCF
     C                   GOTO      SPEXIT
     C                   ENDIF
      *                                                                                       CER001
     C                   ENDIF
      *                                                                                       CER001
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
     C                   GOTO      SPEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SPEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SPEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy Member SD0031RCBW - Account Codes  *
     C*
     C/COPY WNCPYSRC,SD0031RCBW
     C*
     C                   END                                                    *FI
      * 00/Copy Member SD0031RCBU - Account Codes  *
     C*
     C/COPY WNCPYSRC,SD0031RCBU
     C*
      * End of SAR S01212
     C     KLCRSP        KLIST
     C                   KFLD                    A5ACCD                         Account Code
      * Check for duplicate primary key
     C     KLCRSP        SETLL     @A5UPA7                                90    *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR0070'     W0RTN             7
      * Send message 'Account Codes          EX'
     C                   MOVEL     'USR0070'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SPEXIT
     C                   END
      *                                                                                       CDL013
     C     CDL013        IFEQ      '1'
     C     KLCRSP        CHAIN     SDACOAL0                           83
     C     *IN83         IFEQ      *OFF
     C                   MOVEL     'XXW0105'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN99
     C                   MOVE      *ON           *IN31
     C                   GOTO      SPEXIT
      *                                                                                       CDL013
      ** Write record to Extension file                                                       CDL013
      *                                                                                       CDL013
     C                   ELSE
     C                   WRITE     SDACODDA
     C                   END
      *                                                                                       CDL013
     C                   ENDIF
      *
     C/COPY WNCPYSRC,SD0031RC23
     C                   WRITE     @A5UPA7                              91      *
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *                                                                                       CGP001
      ** Save the Global Processing fields to the Cross-                                      CGP001
      ** Reference Files if CGP001 is enabled.                                                CGP001
      *                                                                                       CGP001
     C     CGP001        IFEQ      'Y'
     C                   EXSR      SRGPXU
     C                   EXSR      XRGPXU
     C                   ENDIF
      * USER: Processing after Data update
     C                   Z-ADD     1             WUNORC                         No. of Records
     C                   Z-ADD     1             WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
      * Start of SAR S01117
      * Change code to filename ACCCD - SDACODPD
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SQCHRC
      * End of SAR S01117
      **update*TABTE**-*Account*Codes***********************************                     BUG2695
     C**********           CALL 'TABTE'                90  update TABTE*                     BUG2695
     C**********           PARM A5ACCD    WQ0084  4        Account Code                       CGL029
     C**********           PARM A5CIAD    WQ0085  4        Credit Int. Acc                    CGL029
     C**********           PARM A5CIAC    WQ0086  4        Credit Int. Acc                    CGL029
     C**********           PARM A5DIAC    WQ0087  4        Debt Interest A                    CGL029
     C**********           PARM A5DIAD    WQ0088  4        Debt Interest A                    CGL029
     C**********           PARM A5ICIC    WQ0089  4        Interest Capita                    CGL029
     C**********           PARM A5ICID    WQ0090  4        Interest Capita                    CGL029
     C**********           PARM A5ACCD    WQ0084 10                                   CGL029 BUG2695
     C**********           PARM A5CIAD    WQ0085 10                                   CGL029 BUG2695
     C**********           PARM A5CIAC    WQ0086 10                                   CGL029 BUG2695
     C**********           PARM A5DIAC    WQ0087 10                                   CGL029 BUG2695
     C**********           PARM A5DIAD    WQ0088 10                                   CGL029 BUG2695
     C**********           PARM A5ICIC    WQ0089 10                                   CGL029 BUG2695
     C**********           PARM A5ICID    WQ0090 10                                   CGL029 BUG2695
     C**********           PARM WURDNB    WQ0091  50       Last Change Dat                   BUG2695
     C**********           PARM 'I'       WQ0092  1        Type of Last Ch                   BUG2695
     C**********           PARM A5ACTY    WQ0093  1        Account type                      BUG2695
     C**********           PARM A5ACCN    WQ0094 25        Account Code Na                   BUG2695
     C**********           PARM A5SRLC    WQ0095  50       Stat Returns BS                   BUG2695
     C**********           PARM A5SRFC    WQ0096  50       Stat Returns BS                   BUG2695
     C**********           PARM A5TOIN    WQ0097  1        Title Only Indi                   BUG2695
     C**********           PARM A5RPCD    WQ0098 100       Reporting Code                    BUG2695
     C**********           PARM A5ACSC    WQ0099  2        Account Section                   BUG2695
     C**********           PARM A5ACST    WQ0100  1        Account Sub-typ                   BUG2695
     C********** W0RTN     PARM *BLANK    WQ0101  7        *Return code                      BUG2695
      *
     C********** *IN90     IFEQ '1'                                                          BUG2695
      **Call*to*program*ended*in*error**********************************                     BUG2695
     C**********           MOVEL'Y2U0032' W0RTN                                              BUG2695
     C**********           MOVEL*BLANKS   W0CLPG 10                                          BUG2695
     C**********           MOVEL'TABTE'   W0CLPG                                             BUG2695
      **Send*message*'*Error*occured*on*CALL...'************************                     BUG2695
     C**********           MOVEL'Y2U0032' ZAMSID                                             BUG2695
     C**********           MOVEL'Y2USRMSG'ZAMSGF                                             BUG2695
     C**********           MOVELW0CLPG    ZAMSDA           Message data                      BUG2695
     C**********           EXSR ZASNMS                                                       BUG2695
     C**********           END                                                               BUG2695
      *
      **Error*detected?*************************************************                     BUG2695
     C********** W0RTN     IFNE *BLANK                                                       BUG2695
     C**********           SETON                     99    *                                 BUG2695
     C**********           END                                                               BUG2695
      **CASE:*PGM.*Return*code*is*Old*Table*Error***********************                     BUG2695
     C********** W0RTN     IFEQ '*ERROR*'                  *IF                               BUG2695
      **Send*message*'Unable*to*update'*********************************                     BUG2695
     C**********           MOVEL'USR0015' ZAMSID                                             BUG2695
     C**********           EXSR ZASNMS                                                       BUG2695
     C**********           SETON                     99    *                                 BUG2695
      *
     C**********           ELSE                                                              BUG2695
      **CASE:**OTHERWISE************************************************                     BUG2695
      * Start of SAR S01309
      * CASE: DB1.Title Only Indicator is NO or Blank
     C     A5TOIN        IFEQ      *BLANK                                       *IF
     C     A5TOIN        OREQ      'N'
      * Create accounts by report - Accounts by Report Codes  *
     C                   EXSR      SRCRRC
      * End of SAR S01309
     C                   END                                                    *FI
     C**********           END                             *FI                               BUG2695
      * Start of SAR S01212
      * 00/Copy Member SD0031RCAU - Account Codes  *
     C*
     C/COPY WNCPYSRC,SD0031RCAU
     C*
      * End of SAR S01212
     C                   END
      *                                                                                       CRE015
      ** Term and Notice Detail  Fields                                                       CRE015
      *                                                                                       CRE015
     C     CRE015        IFEQ      'Y'
     C     #1ACTY        ANDEQ     'R'
     C                   MOVEL     #1ACCD        AXACCD
     C                   MOVEL     #1ATTY        A5ATTY
     C                   MOVEL     #1CHIA        A5CHIA
     C                   MOVEL     #1RTTY        A5RTTY
     C                   MOVEL     #1NCVD        A5NVCD
     C                   MOVEL     #1PRFC        A5PRFC
     C                   MOVEL     #1RTDN        A5RTDN
     C                   MOVEL     #1RTDI        A5RTDI
     C                   WRITE     SDACD1D0
     C                   ENDIF
      *================================================================
     CSR   SPEXIT        ENDSR
      /EJECT
     CSR   SQCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YARDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDACODPD'    AHFLNM                         Filename
      *
     C     KLCHSQ        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C*****KLCHSQ        CHAIN     @AHREAU                            9091      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*RTV'        ZMODE             4                        MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM      0             AHNORC                                     MD061007
     C                   PARM      0             AHNOIN                                     MD061007
     C                   PARM      0             AHNOAM                                     MD061007
     C                   PARM      0             AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN           10                        MD061007
      *                                                                                     MD061007
     C                   SETOFF                                       9091                  MD061007
     C     ZRETRN        IFEQ      '*NRF'                                                   MD061007
     C                   SETON                                        90                    MD061007
     C                   ENDIF                                                              MD061007
     C     ZRETRN        IFEQ      '*ERROR'                                                 MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
      *                                                                                     MD061007
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SQEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SQEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      QSDFC1        YARDCS
      * USER: Processing after Data read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
      * Set PGM.*Record Data Changed flag
     C     QSDFC1        IFNE      YARDCS
     C                   MOVE      'Y'           YARDC
     C                   END
      * If changed update record otherwise release record
     C     YARDC         IFEQ      'Y'
     C**********         UPDATE    @AHREAU                              91      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*UPD'        ZMODE                                      MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM                    AHNORC                                     MD061007
     C                   PARM                    AHNOIN                                     MD061007
     C                   PARM                    AHNOAM                                     MD061007
     C                   PARM                    AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN                                     MD061007
                                                                                            MD061007
     C                   SETOFF                                       91                    MD061007
     C     ZRETRN        IFNE      *BLANKS                                                  MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
                                                                                            MD061007
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    SDFCTLL0                             91      *           MD061007
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SQEXIT        ENDSR
      /EJECT
     CSR   SRCRRC        BEGSR
      *================================================================
      * Create accounts by report - Accounts by Report Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @AGREAQ
     C                   MOVEL     '*'           G6RSNO                         Reporting Set N
     C                   MOVEL     '****'        G6RSCD                         Reporting Struc
     C                   MOVEL     A5ACCD        G6ACCD                         Account Code
     C                   MOVEL     *BLANK        G6DRCR                         Debit/Credit In
     C                   Z-ADD     A5LCD         G6LCD                          Last Change Dat
     C                   MOVEL     A5TYLC        G6TYLC                         Type of Last Ch
      *
     C     KLCRSR        KLIST
     C                   KFLD                    G6RSNO                         Reporting Set N
     C                   KFLD                    G6RSCD                         Reporting Struc
     C                   KFLD                    G6ACCD                         Account Code
     C                   KFLD                    G6DRCR                         Debit/Credit In
      * Check for duplicate primary key
     C     KLCRSR        SETLL     @AGREAQ                                90    *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR1554'     W0RTN             7
      * Send message 'Accounts by Report Cod EX'
     C                   MOVEL     'USR1554'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SREXIT
     C                   END
      *
     C                   WRITE     @AGREAQ                              91      *
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *                                                                                       CGP001
      ** Save the Global Processing fields to the Cross-                                      CGP001
      ** Reference File if CGP001 is enabled.                                                 CGP001
      *                                                                                       CGP001
     C     CGP001        IFEQ      'Y'
     C     CSD032        ANDEQ     'N'
     C                   EXSR      SRGPXU
     C                   ENDIF
      * USER: Processing after Data update
     C                   Z-ADD     1             WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     1             WUNOIN                         No. of Inserts
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SSCHRC
     C                   END
      *================================================================
     CSR   SREXIT        ENDSR
      /EJECT
     CSR   SSCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YBRDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDACRCPD'    AHFLNM                         Filename
      *
     C     KLCHSS        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C*****KLCHSS        CHAIN     @AHREAU                            9091      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*RTV'        ZMODE             4                        MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM      0             AHNORC                                     MD061007
     C                   PARM      0             AHNOIN                                     MD061007
     C                   PARM      0             AHNOAM                                     MD061007
     C                   PARM      0             AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN           10                        MD061007
      *                                                                                     MD061007
     C                   SETOFF                                       9091                  MD061007
     C     ZRETRN        IFEQ      '*NRF'                                                   MD061007
     C                   SETON                                        90                    MD061007
     C                   ENDIF                                                              MD061007
     C     ZRETRN        IFEQ      '*ERROR'                                                 MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
      *                                                                                     MD061007
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SSEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SSEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      QSDFC1        YBRDCS
      * USER: Processing after Data read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
      * Set PGM.*Record Data Changed flag
     C     QSDFC1        IFNE      YBRDCS
     C                   MOVE      'Y'           YBRDC
     C                   END
      * If changed update record otherwise release record
     C     YBRDC         IFEQ      'Y'
     C**********         UPDATE    @AHREAU                              91      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*UPD'        ZMODE                                      MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM                    AHNORC                                     MD061007
     C                   PARM                    AHNOIN                                     MD061007
     C                   PARM                    AHNOAM                                     MD061007
     C                   PARM                    AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN                                     MD061007
                                                                                            MD061007
     C                   SETOFF                                       91                    MD061007
     C     ZRETRN        IFNE      *BLANKS                                                  MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
                                                                                            MD061007
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    SDFCTLL0                             91      *           MD061007
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SSEXIT        ENDSR
      /EJECT
     CSR   STDLRC        BEGSR
      *================================================================
      * Delete Account Codes - Account Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * USER: Processing before Data update
      * CASE: PAR.Action Code is Delete
     C     P2ANCD        IFEQ      'D'                                          *IF
      * Start of S01522
      * Account code cannot be deleted (UDC holds Account code data)
      * CASE: WRK.A/C code cannot be deletd is cannot be deleted
     C     WUACDL        IFEQ      'N'                                          *IF
      * Send message 'UDC holds A/C data'
     C                   MOVEL     'USR2616'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   MOVEL     'USR0534'     W0RTN                          *Return code
     C                   GOTO      STEXIT                                       *QUIT
     C                   END                                                    *FI
      * End of S01522
      *                                                                   CGL010
      ** Check if there are existing future valued transitory postings    CGL010
      *                                                                   CGL010
     C     *IN65         IFEQ      *ON                                                         CGL01
     C                   MOVEL     #1ACCD        KACCD                                         CGL01
     C     KACCD         CHAIN     GLVALPL3                           70                       CGL01
     C     *IN70         IFEQ      *OFF                                                        CGL01
     C                   MOVEL     'USR8659'     ZAMSID                                        CGL01
     C                   EXSR      ZASNMS                                                      CGL01
     C                   MOVE      *ON           *IN99                                         CGL01
     C                   MOVEL     'Y'           W0DCF                                         CGL01
     C                   MOVEL     'USR0534'     W0RTN                                         CGL01
     C                   GOTO      STEXIT                                                      CGL01
     C                   ENDIF                                                                 CGL01
     C                   ENDIF                                                                 CGL01
     C/COPY WNCPYSRC,SD0031RC28
      *                                                                   CGL010
     C                   ELSE
      * CASE: *OTHERWISE
      * Send message 'Function key not allowed'
     C                   MOVEL     'USR0533'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
      * Start of Fix S01117
     C                   MOVEL     'Y2U0004'     W0RTN                          *Return code
     C                   GOTO      STEXIT                                       *QUIT
      * End of Fix S01117
     C                   END                                                    *FI
     C/COPY WNCPYSRC,SD0031RC04
      * Start of SAR S01212
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
      * Start of SAR S01117
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,WN0481CCP1                                           S01408
      *                                                                                       CER001
     C     ULX004        IFEQ      'Y'
     C     ULX043        OREQ      'Y'
     C     ULX053        OREQ      'Y'
      *                                                                                       CER001
     C                   Z-ADD     1             SCRN
      *                                                                                       CER001
     C     SCRN          DOULT     1
     C     SCRN          ORGT      3
      *                                                                                       CER001
     C                   MOVE      'N'           W0DCF
     C                   MOVEL     #1ACCD        #2ACCD
      *                                                                                       CER001
     C                   SELECT
     C     SCRN          WHENEQ    1
     C                   EXSR      SRLX04
     C     SCRN          WHENEQ    2
     C                   EXSR      SRLX43
     C     SCRN          WHENEQ    3
     C                   EXSR      SRLX52
     C                   ENDSL
      *                                                                                       CER001
      ** If enter key pressed                                                                 CER001
      *                                                                                       CER001
     C     W0RTN         IFEQ      *BLANKS
     C                   ADD       1             SCRN
     C                   ENDIF
      *                                                                                       CER001
      ** If F12 key pressed or window/DB error                                                CER001
      *                                                                                       CER001
     C     W0RTN         IFEQ      'USR0790'
     C     W0RTN         OREQ      'USR0563'
     C     W0RTN         OREQ      'Y2U0004'
     C                   MOVEL     'Y'           W0DCF
     C                   SUB       1             SCRN
     C                   ENDIF
      *                                                                                       CER001
      ** If F3 key pressed                                                                    CER001
      *                                                                                       CER001
     C     W0RTN         IFEQ      'Y2U9999'
     C                   LEAVE
     C                   ENDIF
      *                                                                                       CER001
     C                   ENDDO
      *                                                                                       CER001
     C     W0RTN         IFEQ      'Y2U9999'
     C                   MOVEL     'Y'           W0DCF
     C                   MOVEL     W0RTN         P0RTN
     C                   EXSR      ZYEXPG
     C                   ENDIF
      *                                                                                       CER001
     C     W0RTN         IFNE      *BLANKS
     C                   MOVE      'Y'           W0DCF
     C                   GOTO      STEXIT
     C                   ENDIF
      *                                                                                       CER001
     C                   ENDIF
      *                                                                                       CER001
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
     C                   GOTO      STEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      STEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      STEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy Member SD0031RDBW - Account Codes  *
     C*
     C/COPY WNCPYSRC,SD0031RDBW
     C*
     C                   END                                                    *FI
      * 00/Copy Member SD0031RDBU - Account Codes  *
     C*
     C/COPY WNCPYSRC,SD0031RDBU
     C*
      * End of SAR S01117
      * End of SAR S01212
      * Move key fields to @A5UPA7
     C                   MOVEL     #1ACCD        A5ACCD                         Account Code
      *
     C     KLDLST        KLIST
     C                   KFLD                    A5ACCD                         Account Code
     C     KLDLST        CHAIN     @A5UPA7                            9091      *
     C     *IN90         IFEQ      '1'
      * Record already deleted
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      STEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
      * Send message '*Database operation error'
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      STEXIT
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
     C     KLDLST        SETLL     @A5UPA7                            9091      *
     C                   GOTO      STEXIT
     C                   END                                                    FI #1DBRC
      *                                                                                       CDL013
      ** Access Account code extension file. If no record on file s                           CDL013
      ** error message.                                                                       CDL013
      *                                                                                       CDL013
     C     CDL013        IFEQ      '1'
     C     KLDLST        CHAIN     SDACOAL0                           81
     C     *IN81         IFEQ      *ON
     C                   MOVEL     'XXW0104'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN99
     C                   MOVE      *ON           *IN31
     C                   GOTO      STEXIT
      *                                                                                       CDL013
     C                   ELSE
      *                                                                                       CDL013
      * Check for changed record                                                              CDL013
      *                                                                                       CDL013
     C     @1DBRX        IFNE      #1DBRX
      * Send message '*Update not accepted'                                                   CDL013
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN99
     C                   MOVE      *ON           *IN31
      *                                                                                       CDL013
      * Use SETLL to release record lock                                                      CDL013
      *                                                                                       CDL013
     C     KLDLST        SETLL     SDACOAL0                               81
     C                   GOTO      STEXIT
     C                   ELSE
      *                                                                                       CDL013
     C                   DELETE    SDACOAL0
     C                   END
     C                   END
      *                                                                                       CDL013
     C                   ENDIF
      *                                                                                       CDL013
     C/COPY WNCPYSRC,SD0031RC24
      *................................................................
     C                   DELETE    @A5UPA7                              91      *
      *                                                                                       CRE015
      ** Delete from SDACD1PD file                                                            CRE015
      *                                                                                       CRE015
     C     CRE015        IFEQ      'Y'
     C     #1ACTY        ANDEQ     'R'
     C                   MOVEL     #1ACCD        PCACCD
     C     KRTVAC        CHAIN     SDACD1D0                           9091
     C                   DELETE    SDACD1D0                             91
     C                   ENDIF
      *                                                                                       CRE015
     C     *IN91         IFEQ      '1'
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *                                                                                       CGP001
      ** Enforce referential integrity if CGP001 is enabled.                                  CGP001
      *                                                                                       CGP001
     C     CGP001        IFEQ      'Y'
     C                   EXSR      SRGPXD
     C                   EXSR      XRGPXD
     C                   ENDIF
      * DBF delete successful
      * USER: Processing after Data update
      * Start of change 122096
      * WUDELR Data Structure - SD Deleted Records File  *
     C                   MOVEL     @1DBRC        WUDELR
      * Write Deleted Record - SD Deleted Records File  *
     C                   CLEAR                   PARC
     C                   MOVEL     'SDACODPD'    PAFNME                         File name
     C                   MOVEL     #1ACCD        PALKEY                         Long Key
     C                   MOVEL     WUDR01        PADR01                         Deleted Data Re
     C                   MOVEL     WUDR02        PADR02                         Deleted Data Re
     C                   MOVEL     WUDR03        PADR03                         Deleted Data Re
     C                   MOVEL     WUDR04        PADR04                         Deleted Data Re
     C                   MOVEL     WUDR05        PADR05                         Deleted Data Re
     C                   MOVEL     WUDR06        PADR06                         Deleted Data Re
     C                   MOVEL     WUDR07        PADR07                         Deleted Data Re
     C                   MOVEL     WUDR08        PADR08                         Deleted Data Re
     C                   MOVEL     WUDR09        PADR09                         Deleted Data Re
     C                   MOVEL     WUDR00        PADR00                         Deleted Data Re
     C                   MOVEL     WUDR11        PADR11                         Deleted Data Re
     C                   MOVEL     WUDR12        PADR12                         Deleted Data Re
     C                   Z-ADD     WURDNB        PALCD                          Last Change Dat
     C                   MOVEL     'D'           PATYLC                         Type of Last Ch
      *
     C                   CALL      'SD0520X'                            90      Write Deleted R
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PARC                           RCD: SD Deleted
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
     C                   Z-ADD     -1            WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C                   Z-ADD     1             WUNODL                         No. of Deletes
      * Start of SAR S01117
      * Change code to filename ACCCD - SDACODPD
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SUCHRC
      * End of SAR S01117
      **update*TABTE**-*Account*Codes***********************************                     BUG2695
     C**********           CALL 'TABTE'                90  update TABTE*                     BUG2695
     C**********           PARM A5ACCD    WQ0102  4        Account Code                       CGL029
     C**********           PARM A5CIAD    WQ0103  4        Credit Int. Acc                    CGL029
     C**********           PARM A5CIAC    WQ0104  4        Credit Int. Acc                    CGL029
     C**********           PARM A5DIAC    WQ0105  4        Debt Interest A                    CGL029
     C**********           PARM A5DIAD    WQ0106  4        Debt Interest A                    CGL029
     C**********           PARM A5ICIC    WQ0107  4        Interest Capita                    CGL029
     C**********           PARM A5ICID    WQ0108  4        Interest Capita                    CGL029
     C**********           PARM A5ACCD    WQ0102 10                                   CGL029 BUG2695
     C**********           PARM A5CIAD    WQ0103 10                                   CGL029 BUG2695
     C**********           PARM A5CIAC    WQ0104 10                                   CGL029 BUG2695
     C**********           PARM A5DIAC    WQ0105 10                                   CGL029 BUG2695
     C**********           PARM A5DIAD    WQ0106 10                                   CGL029 BUG2695
     C**********           PARM A5ICIC    WQ0107 10                                   CGL029 BUG2695
     C**********           PARM A5ICID    WQ0108 10                                   CGL029 BUG2695
     C**********           PARM WURDNB    WQ0109  50       Last Change Dat                   BUG2695
     C**********           PARM 'D'       WQ0110  1        Type of Last Ch                   BUG2695
     C**********           PARM A5ACTY    WQ0111  1        Account type                      BUG2695
     C**********           PARM A5ACCN    WQ0112 25        Account Code Na                   BUG2695
     C**********           PARM A5SRLC    WQ0113  50       Stat Returns BS                   BUG2695
     C**********           PARM A5SRFC    WQ0114  50       Stat Returns BS                   BUG2695
     C**********           PARM A5TOIN    WQ0115  1        Title Only Indi                   BUG2695
     C**********           PARM A5RPCD    WQ0116 100       Reporting Code                    BUG2695
     C**********           PARM A5ACSC    WQ0117  2        Account Section                   BUG2695
     C**********           PARM A5ACST    WQ0118  1        Account Sub-typ                   BUG2695
     C********** W0RTN     PARM *BLANK    WQ0119  7        *Return code                      BUG2695
      *
     C********** *IN90     IFEQ '1'                                                          BUG2695
      **Call*to*program*ended*in*error**********************************                     BUG2695
     C**********           MOVEL'Y2U0032' W0RTN                                              BUG2695
     C**********           MOVEL*BLANKS   W0CLPG 10                                          BUG2695
     C**********           MOVEL'TABTE'   W0CLPG                                             BUG2695
      **Send*message*'*Error*occured*on*CALL...'************************                     BUG2695
     C**********           MOVEL'Y2U0032' ZAMSID                                             BUG2695
     C**********           MOVEL'Y2USRMSG'ZAMSGF                                             BUG2695
     C**********           MOVELW0CLPG    ZAMSDA           Message data                      BUG2695
     C**********           EXSR ZASNMS                                                       BUG2695
     C**********           END                                                               BUG2695
      *
      **Error*detected?*************************************************                     BUG2695
     C********** W0RTN     IFNE *BLANK                                                       BUG2695
     C**********           SETON                     99    *                                 BUG2695
     C**********           END                                                               BUG2695
      **CASE:*PGM.*Return*code*is*Old*Table*Error***********************                     BUG2695
     C********** W0RTN     IFEQ '*ERROR*'                  *IF                               BUG2695
      **Send*message*'Unable*to*update'*********************************                     BUG2695
     C**********           MOVEL'USR0015' ZAMSID                                             BUG2695
     C**********           EXSR ZASNMS                                                       BUG2695
     C**********           SETON                     99    *                                 BUG2695
      *
     C**********           ELSE                                                              BUG2695
      **CASE:**OTHERWISE************************************************                     BUG2695
      * Start of SAR S01309
      * Rtv all recs for 1 a/c cd - Accounts by Report Codes  *
     C                   EXSR      SVRVGN
      * End of SAR S01309
     C**********           END                             *FI                               BUG2695
      * Start of SAR S01212
      * 00/Copy Member SD0031RDAU - Account Codes  *
     C*
     C/COPY WNCPYSRC,SD0031RDAU
     C*
      * End of SAR S01212
     C                   END
      *================================================================
     CSR   STEXIT        ENDSR
      /EJECT
     CSR   SUCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YCRDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDACODPD'    AHFLNM                         Filename
      *
     C     KLCHSU        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C*****KLCHSU        CHAIN     @AHREAU                            9091      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*RTV'        ZMODE             4                        MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM      0             AHNORC                                     MD061007
     C                   PARM      0             AHNOIN                                     MD061007
     C                   PARM      0             AHNOAM                                     MD061007
     C                   PARM      0             AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN           10                        MD061007
      *                                                                                     MD061007
     C                   SETOFF                                       9091                  MD061007
     C     ZRETRN        IFEQ      '*NRF'                                                   MD061007
     C                   SETON                                        90                    MD061007
     C                   ENDIF                                                              MD061007
     C     ZRETRN        IFEQ      '*ERROR'                                                 MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
      *                                                                                     MD061007
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
     C                   MOVE      QSDFC1        YCRDCS
      * USER: Processing after Data read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
      * Set PGM.*Record Data Changed flag
     C     QSDFC1        IFNE      YCRDCS
     C                   MOVE      'Y'           YCRDC
     C                   END
      * If changed update record otherwise release record
     C     YCRDC         IFEQ      'Y'
     C**********         UPDATE    @AHREAU                              91      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*UPD'        ZMODE                                      MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM                    AHNORC                                     MD061007
     C                   PARM                    AHNOIN                                     MD061007
     C                   PARM                    AHNOAM                                     MD061007
     C                   PARM                    AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN                                     MD061007
                                                                                            MD061007
     C                   SETOFF                                       91                    MD061007
     C     ZRETRN        IFNE      *BLANKS                                                  MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
                                                                                            MD061007
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    SDFCTLL0                             91      *           MD061007
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
      * Rtv all recs for 1 a/c cd - Accounts by Report Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C     *LIKE         DEFINE    G6ACCD        WQSV01                         Account Code
      * Define keylist
     C     KRSSV         KLIST
     C                   KFLD                    WQSV01                         Account Code
      * Move fields to key list
     C                   MOVEL     #1ACCD        WQSV01                         Account Code
     C     KRSSV         SETLL     @ACRCBX                                      *
     C     KRSSV         READE     @ACRCBX                                90    *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR1553'     W0RTN             7
      * USER: Processing if Data record not found
      * If Account Code is Title Only, no record will exist on SDACRCPD -
      * ensure return code is blank, otherwise will not allow record on
      * SDACODPD to be deleted.
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   GOTO      SVEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
      * Delete Accounts by Report - Accounts by Report Codes  *
     C                   EXSR      SWDLRC
     C     KRSSV         READE     @ACRCBX                                90    *
     C                   END
      *================================================================
     CSR   SVEXIT        ENDSR
      /EJECT
     CSR   SWDLRC        BEGSR
      *================================================================
      * Delete Accounts by Report - Accounts by Report Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @AGREAQ
     C                   MOVEL     #1ACCD        G6ACCD                         Account Code
      *
     C     KLDLSW        KLIST
     C                   KFLD                    G6RSNO                         Reporting Set N
     C                   KFLD                    G6RSCD                         Reporting Struc
     C                   KFLD                    G6ACCD                         Account Code
     C                   KFLD                    G6DRCR                         Debit/Credit In
     C     KLDLSW        CHAIN     @AGREAQ                            9091      *
     C     *IN90         IFEQ      '1'
      * Record already deleted
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SWEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
      * Send message '*Database operation error'
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SWEXIT
     C                   END
      *
      *................................................................
     C                   DELETE    @AGREAQ                              91      *
     C     *IN91         IFEQ      '1'
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF delete successful
      * USER: Processing after Data update
     C                   Z-ADD     -1            WUNORC                         No. of Records
     C                   Z-ADD     1             WUNODL                         No. of Deletes
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SXCHRC
     C                   END
      *================================================================
     CSR   SWEXIT        ENDSR
      /EJECT
     CSR   SXCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YDRDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDACRCPD'    AHFLNM                         Filename
      *
     C     KLCHSX        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C*****KLCHSX        CHAIN     @AHREAU                            9091      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*RTV'        ZMODE             4                        MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM      0             AHNORC                                     MD061007
     C                   PARM      0             AHNOIN                                     MD061007
     C                   PARM      0             AHNOAM                                     MD061007
     C                   PARM      0             AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN           10                        MD061007
      *                                                                                     MD061007
     C                   SETOFF                                       9091                  MD061007
     C     ZRETRN        IFEQ      '*NRF'                                                   MD061007
     C                   SETON                                        90                    MD061007
     C                   ENDIF                                                              MD061007
     C     ZRETRN        IFEQ      '*ERROR'                                                 MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
      *                                                                                     MD061007
      *
     C     *IN90         IFEQ      '1'
      * Record not found
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
     C                   GOTO      SXEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      QSDFC1        YDRDCS
      * USER: Processing after Data read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
      * Set PGM.*Record Data Changed flag
     C     QSDFC1        IFNE      YDRDCS
     C                   MOVE      'Y'           YDRDC
     C                   END
      * If changed update record otherwise release record
     C     YDRDC         IFEQ      'Y'
     C**********         UPDATE    @AHREAU                              91      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*UPD'        ZMODE                                      MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM                    AHNORC                                     MD061007
     C                   PARM                    AHNOIN                                     MD061007
     C                   PARM                    AHNOAM                                     MD061007
     C                   PARM                    AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN                                     MD061007
                                                                                            MD061007
     C                   SETOFF                                       91                    MD061007
     C     ZRETRN        IFNE      *BLANKS                                                  MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
                                                                                            MD061007
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    SDFCTLL0                             91      *           MD061007
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SXEXIT        ENDSR
      /EJECT
     CSR   SYCHRC        BEGSR
      *================================================================
      * Change Account Codes - Account Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YERDC             1
      *
      * Move key fields to @A5UPA7
     C                   MOVEL     #1ACCD        A5ACCD                         Account Code
      *
     C     KLCHSY        KLIST
     C                   KFLD                    A5ACCD                         Account Code
     C     KLCHSY        CHAIN     @A5UPA7                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SYEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SYEXIT
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
     C                   UNLOCK    SDACODL0                             91      *
     C                   GOTO      SYEXIT
     C                   END                                                    FI #1DBRC
      *                                                                                       CDL013
      ** Access WHT A/C code file                                                             CDL013
      *                                                                                       CDL013
     C     CDL013        IFEQ      '1'
     C     KLCHSY        CHAIN     SDACOAL0                           82
      *                                                                                       CDL013
      * Record not on file                                                                    CDL013
     C     *IN82         IFEQ      *ON
     C                   MOVEL     'XXW0104'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN99
     C                   MOVE      *ON           *IN31
     C                   GOTO      SYEXIT
     C                   ELSE
      *                                                                                       CDL013
      * Check for changed record                                                              CDL013
      *                                                                                       CDL013
     C     @1DBRX        IFNE      #1DBRX
      * Send message '*Update not accepted'                                                   CDL013
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN99
     C                   MOVE      *ON           *IN31
      *                                                                                       CDL013
      * Use SETLL to release record lock                                                      CDL013
      *                                                                                       CDL013
     C     KLCHSY        SETLL     SDACOAL0                               81
     C                   GOTO      SYEXIT
     C                   ENDIF
      *                                                                                       CDL013
     C                   ENDIF
      *                                                                                       CDL013
     C                   ENDIF
      *                                                                                       CDL013
     C/COPY WNCPYSRC,SD0031RC25
      * Store record data for null update check
     C                   MOVE      @1DBRC        YERDCS
      * Move non-key fields to @A5UPA7
     C                   MOVEL     #1CIAD        A5CIAD                         Credit Int. Acc
     C                   MOVEL     #1CIAC        A5CIAC                         Credit Int. Acc
     C                   MOVEL     #1DIAC        A5DIAC                         Debt Interest A
     C                   MOVEL     #1DIAD        A5DIAD                         Debt Interest A
     C                   MOVEL     #1ICIC        A5ICIC                         Interest Capita
     C                   MOVEL     #1ICID        A5ICID                         Interest Capita
     C                   Z-ADD     WURDNB        A5LCD                          Last Change Dat
     C                   MOVEL     'A'           A5TYLC                         Type of Last Ch
     C                   MOVEL     #1ACTY        A5ACTY                         Account type
     C                   MOVEL     #1ACCN        A5ACCN                         Account Code Na
     C   69              MOVEL     #1ACC2        A5ACCN                         Account Code NaCSD00
     C                   MOVEL     #1NARR        A5NARR                         Acct Code Narr CSD00
     C                   Z-ADD     #1SRLC        A5SRLC                         Stat Returns BS
     C                   Z-ADD     #1SRFC        A5SRFC                         Stat Returns BS
     C                   MOVEL     #1TOIN        A5TOIN                         Title Only Indi
     C                   Z-ADD     #1RPCD        A5RPCD                         Reporting Code
     C                   MOVEL     #1ACSC        A5ACSC                         Account Section
     C                   MOVEL     #1ACST        A5ACST                         Account Sub-typ
     C                   Z-ADD     #1ACPR        A5ACPR                         Acct Post Reten
     C                   MOVEL     #1TRFD        A5TRFD                         A/C transferred
     C                   MOVEL     #1DIPD        A5DIPD                         Dr Int pay A/C
     C                   MOVEL     #1DIPC        A5DIPC                         Dr Int pay A/C
     C                   MOVEL     #1CIPC        A5CIPC                         Cr Int pay A/C
     C                   MOVEL     #1CISU        A5CISU                         Cr Int pay A/C
     C                   MOVEL     #1CINS        A5CINS                         Cr Int pay A/C
     C                   MOVEL     #1WTAC        A5WTAC                         Withholding Tax
     C                   Z-ADD     #1MISU        A5MISU                         Min Int subject
     C                   MOVEL     #1ACGC        A5ACGC                         Midas Export Va
     C                   MOVEL     #1INNR        A5INNR                         PM Instrument C
     C                   MOVEL     #1MAPC        A5MAPC                         Man A/C Anal Pr
     C                   MOVEL     #1MABK        A5MABK                         Man A/C Anal Bo
     C                   MOVEL     #1MAAC        A5MAAC                         Man A/C Anal As
     C                   MOVEL     #1MATR        A5MATR                         Man A/C Anal Tr
     C                   MOVEL     #1MAPR        A5MAPR                         Man A/C Anal Pr
     C                   MOVEL     #1FNAC        A5FNAC                         Funding Account
     C                   MOVEL     #1FNBR        A5FNBR                         Funding Base Ra
     C                   MOVEL     #1FNIC        A5FNIC                         Funding Int A/C
     C                   MOVEL     #1FNAA        A5FNAA                         Funding Accrual
     C                   MOVEL     #1CAAC        A5CAAC                         Capitalise to t
     C                   MOVEL     #1TFCA        A5TFCT                                        CTI00
     C                   MOVEL     #1TIAT        A5TIAT                         TI Account Type
     C                   MOVEL     #1VOST        A5VOST                         Vostro A/C FlagCFT00
     C                   MOVEL     #1LORO        A5LORO                         Loro A/C Flag  CFT00
      *                                                                   CGL010
      ** If CGL010 is present                                             CGL010
      *                                                                   CGL010
     C     *IN65         IFEQ      *ON                                                         CGL01
     C                   MOVEL     DDTRDA        A5TRDA                                        CGL01
     C                   MOVEL     DDTRCA        A5TRCA                                        CGL01
     C                   ENDIF                                                                 CGL01
      *                                                                   CPB004
      ** If CPB004 is present                                             CPB004
      *                                                                   CPB004
     C     WPB004        IFEQ      'Y'                                                         CPB00
     C                   MOVEL     #1TRAN        A5TRAN                                        CPB00
     C                   ENDIF                                                                 CPB00
      *
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YERDCS
     C                   MOVE      'Y'           YERDC
     C                   END
      * USER: Processing before Data update
      * Start of 042930
      * Title Only Indicator is blank
      * CASE: PAR.Title Only Indicator is Blank
     C     #1TOIN        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           A5TOIN                         Title Only Indi
     C                   END                                                    *FI
      * End of 042930
     C/COPY WNCPYSRC,SD0031RC05
      * Start of SAR S01212
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
      * Start of SAR S01117
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,WN0481CCP1                                           S01408
      *                                                                                       CER001
     C     ULX004        IFEQ      'Y'
     C     ULX043        OREQ      'Y'
     C     ULX053        OREQ      'Y'
      *                                                                                       CER001
     C                   Z-ADD     1             SCRN
      *                                                                                       CER001
     C     SCRN          DOULT     1
     C     SCRN          ORGT      3
      *                                                                                       CER001
     C                   MOVE      'N'           W0DCF
     C                   MOVEL     #1ACCD        #2ACCD
      *                                                                                       CER001
     C                   SELECT
     C     SCRN          WHENEQ    1
     C                   EXSR      SRLX04
     C     SCRN          WHENEQ    2
     C                   EXSR      SRLX43
     C     SCRN          WHENEQ    3
     C                   EXSR      SRLX52
     C                   ENDSL
      *                                                                                       CER001
      ** If enter key pressed                                                                 CER001
      *                                                                                       CER001
     C     W0RTN         IFEQ      *BLANKS
     C                   ADD       1             SCRN
     C                   ENDIF
      *                                                                                       CER001
      ** If F12 key pressed or window/DB error                                                CER001
      *                                                                                       CER001
     C     W0RTN         IFEQ      'USR0790'
     C     W0RTN         OREQ      'USR0563'
     C     W0RTN         OREQ      'Y2U0004'
     C                   MOVEL     'Y'           W0DCF
     C                   SUB       1             SCRN
     C                   ENDIF
      *                                                                                       CER001
      ** If F3 key pressed                                                                    CER001
      *                                                                                       CER001
     C     W0RTN         IFEQ      'Y2U9999'
     C                   LEAVE
     C                   ENDIF
      *                                                                                       CER001
     C                   ENDDO
      *                                                                                       CER001
     C     W0RTN         IFEQ      'Y2U9999'
     C                   MOVEL     'Y'           W0DCF
     C                   MOVEL     W0RTN         P0RTN
     C                   EXSR      ZYEXPG
     C                   ENDIF
      *                                                                                       CER001
     C     W0RTN         IFNE      *BLANKS
     C                   MOVE      'Y'           W0DCF
     C                   GOTO      SYEXIT
     C                   ENDIF
      *                                                                                       CER001
     C                   ENDIF
      *                                                                                       CER001
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
     C                   GOTO      SYEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SYEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SYEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of SAR S01117
      * 00/Copy Member SD0031RBUW - Account Codes  *
     C*
     C/COPY WNCPYSRC,SD0031RBUW
     C*
     C                   END                                                    *FI
      * 00/Copy Member SD0031RBDU - Account Codes  *
     C*
     C/COPY WNCPYSRC,SD0031RBDU
     C*
      * End of SAR S01212
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YERDCS
     C                   MOVE      'Y'           YERDC
     C                   END
      * If changed update record otherwise release record
     C     YERDC         IFEQ      'Y'
     C                   UPDATE    @A5UPA7                              91      *
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDACODL0                             91      *
     C                   END
     C/COPY WNCPYSRC,SD0031RC26
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *                                                                                       CGP001
      ** Save the Global Processing fields to the Cross-                                      CGP001
      ** Reference Files if CGP001 is enabled.                                                CGP001
      *                                                                                       CGP001
     C     CGP001        IFEQ      'Y'
     C                   EXSR      SRGPXU
     C                   EXSR      XRGPXU
     C                   ENDIF
      *
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
      * DBF change successful
      * USER: Processing after Data update
     C                   Z-ADD     *ZERO         WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     1             WUNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
      * Start of SAR S01117
      * Change code to filename ACCCD - SDACODPD
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SZCHRC
      * End of SAR S01117
      **update*TABTE**-*Account*Codes***********************************                     BUG2695
     C**********           CALL 'TABTE'                90  update TABTE*                     BUG2695
     C**********           PARM A5ACCD    WQ0120  4        Account Code                       CGL029
     C**********           PARM A5CIAD    WQ0121  4        Credit Int. Acc                    CGL029
     C**********           PARM A5CIAC    WQ0122  4        Credit Int. Acc                    CGL029
     C**********           PARM A5DIAC    WQ0123  4        Debt Interest A                    CGL029
     C**********           PARM A5DIAD    WQ0124  4        Debt Interest A                    CGL029
     C**********           PARM A5ICIC    WQ0125  4        Interest Capita                    CGL029
     C**********           PARM A5ICID    WQ0126  4        Interest Capita                    CGL029
     C**********           PARM A5ACCD    WQ0120 10                                   CGL029 BUG2695
     C**********           PARM A5CIAD    WQ0121 10                                   CGL029 BUG2695
     C**********           PARM A5CIAC    WQ0122 10                                   CGL029 BUG2695
     C**********           PARM A5DIAC    WQ0123 10                                   CGL029 BUG2695
     C**********           PARM A5DIAD    WQ0124 10                                   CGL029 BUG2695
     C**********           PARM A5ICIC    WQ0125 10                                   CGL029 BUG2695
     C**********           PARM A5ICID    WQ0126 10                                   CGL029 BUG2695
     C**********           PARM WURDNB    WQ0127  50       Last Change Dat                   BUG2695
     C**********           PARM 'A'       WQ0128  1        Type of Last Ch                   BUG2695
     C**********           PARM A5ACTY    WQ0129  1        Account type                      BUG2695
     C**********           PARM A5ACCN    WQ0130 25        Account Code Na                   BUG2695
     C**********           PARM A5SRLC    WQ0131  50       Stat Returns BS                   BUG2695
     C**********           PARM A5SRFC    WQ0132  50       Stat Returns BS                   BUG2695
     C**********           PARM A5TOIN    WQ0133  1        Title Only Indi                   BUG2695
     C**********           PARM A5RPCD    WQ0134 100       Reporting Code                    BUG2695
     C**********           PARM A5ACSC    WQ0135  2        Account Section                   BUG2695
     C**********           PARM A5ACST    WQ0136  1        Account Sub-typ                   BUG2695
     C********** W0RTN     PARM *BLANK    WQ0137  7        *Return code                      BUG2695
      *
     C********** *IN90     IFEQ '1'                                                          BUG2695
      **Call*to*program*ended*in*error**********************************                     BUG2695
     C**********           MOVEL'Y2U0032' W0RTN                                              BUG2695
     C**********           MOVEL*BLANKS   W0CLPG 10                                          BUG2695
     C**********           MOVEL'TABTE'   W0CLPG                                             BUG2695
      **Send*message*'*Error*occured*on*CALL...'************************                     BUG2695
     C**********           MOVEL'Y2U0032' ZAMSID                                             BUG2695
     C**********           MOVEL'Y2USRMSG'ZAMSGF                                             BUG2695
     C**********           MOVELW0CLPG    ZAMSDA           Message data                      BUG2695
     C**********           EXSR ZASNMS                                                       BUG2695
     C**********           END                                                               BUG2695
      *
      **Error*detected?*************************************************                     BUG2695
     C********** W0RTN     IFNE *BLANK                                                       BUG2695
     C**********           SETON                     99    *                                 BUG2695
     C**********           END                                                               BUG2695
      **CASE:*PGM.*Return*code*is*Old*Table*Error***********************                     BUG2695
     C********** W0RTN     IFEQ '*ERROR*'                  *IF                               BUG2695
      **Send*message*'Unable*to*update'*********************************                     BUG2695
     C**********           MOVEL'USR0015' ZAMSID                                             BUG2695
     C**********           EXSR ZASNMS                                                       BUG2695
     C**********           SETON                     99    *                                 BUG2695
      *
     C**********           END                             *FI                               BUG2695
      *                                                                                       CDL013
      ** If WHT Account Codes changed:                                                        CDL013
      *                                                                                       CDL013
     C     CDL013        IFEQ      '1'
     C     #1WTAC        IFNE      EACRE
     C     #1WTCC        ORNE      EACCO
      *                                                                                       CDL013
      ** Move screen WHT account codes to file fields update Ext. f                           CDL013
     C                   MOVEL     #1WTAC        EACRE                          WHT Ret.
     C                   MOVEL     #1WTCC        EACCO                          WHT Corp
     C                   UPDATE    SDACODDA
      *                                                                                       CDL013
      ** Update saved record image(Extension File)                                            CDL013
     C                   MOVEL     @1DBRX        #1DBRX
      *                                                                                       CDL013
     C                   ENDIF
      *                                                                                       CDL013
     C                   ENDIF
      *                                                                                       CDL013
      * Start of SAR S01212
      * 00/Copy Member SD0031RADU - Account Codes  *
     C*
     C/COPY WNCPYSRC,SD0031RADU
     C*
      * End of SAR S01212
     C                   END
      *                                                                                       CRE015
      ** Term and Notice Details                                                              CRE015
      *                                                                                       CRE015
     C     CRE015        IFEQ      'Y'
     C     #1ACTY        ANDEQ     'R'
     C                   MOVEL     #1ACCD        PCACCD
     C     KRTVAC        KLIST
     C                   KFLD                    PCACCD           10
     C     KRTVAC        CHAIN     SDACD1D0                           9091
     C                   MOVEL     #1ACCD        AXACCD
     C                   MOVEL     #1ATTY        A5ATTY
     C                   MOVEL     #1CHIA        A5CHIA
     C                   MOVEL     #1RTTY        A5RTTY
     C                   MOVEL     #1NCVD        A5NVCD
     C                   MOVEL     #1PRFC        A5PRFC
     C                   MOVEL     #1RTDN        A5RTDN
     C                   MOVEL     #1RTDI        A5RTDI
     C     *IN90         IFEQ      '1'
     C                   WRITE     SDACD1D0
     C                   ELSE
     C                   UPDATE    SDACD1D0
     C                   ENDIF
     C                   ENDIF
      *================================================================
     CSR   SYEXIT        ENDSR
      /EJECT
     CSR   SZCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YFRDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDACODPD'    AHFLNM                         Filename
      *
     C     KLCHSZ        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C*****KLCHSZ        CHAIN     @AHREAU                            9091      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*RTV'        ZMODE             4                        MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM      0             AHNORC                                     MD061007
     C                   PARM      0             AHNOIN                                     MD061007
     C                   PARM      0             AHNOAM                                     MD061007
     C                   PARM      0             AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN           10                        MD061007
      *                                                                                     MD061007
     C                   SETOFF                                       9091                  MD061007
     C     ZRETRN        IFEQ      '*NRF'                                                   MD061007
     C                   SETON                                        90                    MD061007
     C                   ENDIF                                                              MD061007
     C     ZRETRN        IFEQ      '*ERROR'                                                 MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
      *                                                                                     MD061007
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SZEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SZEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      QSDFC1        YFRDCS
      * USER: Processing after Data read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
      * Set PGM.*Record Data Changed flag
     C     QSDFC1        IFNE      YFRDCS
     C                   MOVE      'Y'           YFRDC
     C                   END
      * If changed update record otherwise release record
     C     YFRDC         IFEQ      'Y'
     C**********         UPDATE    @AHREAU                              91      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*UPD'        ZMODE                                      MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM                    AHNORC                                     MD061007
     C                   PARM                    AHNOIN                                     MD061007
     C                   PARM                    AHNOAM                                     MD061007
     C                   PARM                    AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN                                     MD061007
                                                                                            MD061007
     C                   SETOFF                                       91                    MD061007
     C     ZRETRN        IFNE      *BLANKS                                                  MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
                                                                                            MD061007
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    SDFCTLL0                             91      *           MD061007
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SZEXIT        ENDSR
      /EJECT
     CSR   TARVGN        BEGSR
      *================================================================
      * Get all Midas Modules - MIDAS Modules  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSTA         KLIST
     C                   KFLD                    BGMODS                         Modules
      * Move fields to key list
     C                   MOVE      *BLANK        BGMODS                         Modules
     C                   MOVEL     'MMOD'        BGMODS                         Modules
     C     KRSTA         CHAIN     @BGREC8                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0096'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
      * Setup message data for message
     C                   MOVEL     'SDMMODPD'    ZA0131                         Filename
      * Send message 'Database Error (ICD)'
     C                   MOVEL     'USR0377'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   GOTO      TAEXIT                                       *QUIT
     C                   GOTO      TAEXIT
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
     C                   MOVEL     BGN4ST        WUN4ST                         Private BankingCPB00
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
     CSR   TAEXIT        ENDSR
      /EJECT
     CSR   TBRVGN        BEGSR
      *================================================================
      * Get Base Currency - Bank Details  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSTB         KLIST
     C                   KFLD                    BJBANK                         Bank
      * Move fields to key list
     C                   MOVE      *BLANK        BJBANK                         Bank
     C                   MOVEL     'BANK'        BJBANK                         Bank
     C     KRSTB         CHAIN     @BJREEF                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0197'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
      * Setup message data for message
     C                   MOVEL     'SDBANKPD'    ZA0132                         Filename
      * Send message 'Database Error (ICD)'
     C                   MOVEL     'USR0377'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   GOTO      TBEXIT                                       *QUIT
     C                   GOTO      TBEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
      * PAR = DB1 By name
     C                   MOVEL     BJCYCD        WUCYCD                         Currency Code
     C                   END
      *================================================================
     CSR   TBEXIT        ENDSR
      /EJECT
     CSR   TCRVGN        BEGSR
      *================================================================
      * Get Number of Dec Places - Currency Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSTC         KLIST
     C                   KFLD                    A6CYCD                         Currency Code
      * Move fields to key list
     C                   MOVEL     WUCYCD        A6CYCD                         Currency Code
     C     KRSTC         CHAIN     @A6REA3                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0071'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      TCEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   Z-ADD     A6NBDP        WUNBDP                         Number of Decim
     C                   END
      *================================================================
     CSR   TCEXIT        ENDSR
      /EJECT
     CSR   TDRVGN        BEGSR
      *================================================================
      * Check Profit Centres Used - General Ledger Details  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSTD         KLIST
     C                   KFLD                    BKGNLG                         General Ledger
      * Move fields to key list
     C                   MOVE      *BLANK        BKGNLG                         General Ledger
     C                   MOVEL     'GELR'        BKGNLG                         General Ledger
     C     KRSTD         CHAIN     @BKREEC                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0199'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      TDEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
      * PAR = DB1 By name
     C                   MOVEL     BKPRCU        WUPRCU                         Profit Centres
     C                   END
      *================================================================
     CSR   TDEXIT        ENDSR
      /EJECT
     CSR   TERVGN        BEGSR
      *================================================================
      * Get Port Man ICD fields - Portfolio Management ICD  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSTE         KLIST
     C                   KFLD                    FCPORT                         Portfolio Manag
      * Move fields to key list
     C                   MOVEL     WUPORT        FCPORT                         Portfolio Manag
     C     KRSTE         CHAIN     @PORTL1                            90        *
      * Data record not found
     C   90              MOVEL     'USR2284'     W0RTN             7
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     FCR997        WUR997                         Ref Attached to
     C                   MOVEL     FCPORS        WUPORS                         Portfolios Supp
     C                   END
      *================================================================
     CSR   TEEXIT        ENDSR
      /EJECT
     CSR   VACKRL        BEGSR
      *================================================================
      * Select existing record
      *================================================================
      * Name search required?
     C                   MOVEL     #1ACCD        WK1X01            1
     C     WK1X01        IFEQ      '?'                                          Account Code
     C                   CALL      'SD0031S'                            90      Select Account
     C                   PARM      *BLANK        W0RTN             7
     C********** #1ACCD    PARM #1ACCD    WQ0034  4        Account Code                       CGL029
     C     #1ACCD        PARM      #1ACCD        WQ0034           10
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
     C     @#DFMT        IFEQ      '#RCDDTL2'
      *                                                                                       CRE015
      ** Term & Notice Detail Screen                                                          CRE015
      *                                                                                       CRE015
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
     C                   ENDIF
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
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRVGAC - Validates the Global Account Code.                  *                       CGP001
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRVGAC        BEGSR
      *                                                                                       CGP001
     C                   MOVE      *BLANKS       ZAMSID
     C                   MOVE      *BLANKS       ZAMSGF
      *                                                                                       CGP001
      ** Global Account Code must be entered.                                                 CGP001
      ** This is no longer mandatory.                                                        BUG2637
      *                                                                                       CGP001
     C     #1GACD        IFEQ      *BLANKS
     C*********************MOVEL'USR9780' ZAMSID                                       CGP001BUG2637
     C                   ELSE
      *                                                                                       CGP001
     C                   CALL      'AOGACDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1GACD        PGACD            10
     C     GPACOD        PARM      GPACOD        DSFDY
      *                                                                                       CGP001
     C     PRTCD         IFEQ      *BLANKS
      *                                                                                       CGP001
     C     '?'           SCAN      #1GACD        WPOS              2 0
     C     WPOS          IFNE      *ZERO
     C                   MOVE      'Y'           W0DCF
     C                   ENDIF
      *                                                                                       CGP001
     C                   MOVE      PGACD         #1GACD
     C                   ELSE
      *                                                                                       CGP001
     C                   SELECT
     C     PRTCD         WHENEQ    '*NOSEL '
     C                   MOVEL     'USR9762'     ZAMSID
      *                                                                                       CGP001
      ** Invalid Global Account Code.                                                         CGP001
      *                                                                                       CGP001
     C     PRTCD         WHENEQ    '*NRF   '
     C                   MOVE      'USR9781'     ZAMSID
     C                   OTHER
     C************LOCK     IN   LDA                                                    CGP001 BG2012
     C***********          MOVEL'GPACODPD'DBFILE                                       CGP001 BG2012
     C***********          MOVELACGACD    DBKEY                                        CGP001 BG2012
     C***********          Z-ADD4         DBASE                                        CGP001 BG2012
     C***********          OUT  LDA                                                    CGP001 BG2012
     C***********          MOVE *ON       *INU7                                        CGP001 BG2012
     C***********          MOVE *ON       *INU8                                        CGP001 BG2012
     C***********          MOVE *ON       *INLR                                        CGP001 BG2012
     C***********          EXSR *PSSR                                                  CGP001 BG2012
     C                   ENDSL
      *                                                                                       CGP001
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDIF
      *                                                                                       CGP001
     C     ZAMSID        IFNE      *BLANKS
     C                   MOVE      *ON           *IN81
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRVGPC - Validates the Global Product Code.                  *                       CGP001
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRVGPC        BEGSR
      *                                                                                       CGP001
     C                   MOVE      *BLANKS       ZAMSID
     C                   MOVE      *BLANKS       ZAMSGF
      *                                                                                       CGP001
      ** Product Code is optional                                                             CGP001
      *                                                                                       CGP001
     C     #1PRDC        IFNE      *BLANKS
      *                                                                                       CGP001
     C                   CALL      'AOGPRDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1PRDC        PGPRD            10
     C     GPPROD        PARM      GPPROD        DSFDY
      *                                                                                       CGP001
     C     PRTCD         IFEQ      *BLANKS
      *                                                                                       CGP001
     C     '?'           SCAN      #1PRDC        WPOS              2 0
     C     WPOS          IFNE      *ZERO
     C                   MOVE      'Y'           W0DCF
     C                   ENDIF
      *                                                                                       CGP001
     C                   MOVE      PGPRD         #1PRDC
     C                   ELSE
      *                                                                                       CGP001
     C                   SELECT
     C     PRTCD         WHENEQ    '*NOSEL '
     C                   MOVE      'USR9762'     ZAMSID
      *                                                                                       CGP001
      ** Invalid Product Code.                                                                CGP001
      *                                                                                       CGP001
     C     PRTCD         WHENEQ    '*NRF   '
     C                   MOVE      'USR9782'     ZAMSID
     C                   OTHER
     C     *LOCK         IN        LDA
     C                   MOVEL     'GPPRODPD'    DBFILE
     C                   MOVEL     PGPRD         DBKEY
     C                   Z-ADD     3             DBASE
     C                   OUT       LDA
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDSL
      *                                                                                       CGP001
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDIF
      *                                                                                       CGP001
     C     ZAMSID        IFNE      *BLANKS
     C                   MOVE      *ON           *IN82
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRVGIC - Validates the Global Instrument Code.               *                       CGP001
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRVGIC        BEGSR
      *                                                                                       CGP001
     C                   MOVE      *BLANKS       ZAMSID
     C                   MOVE      *BLANKS       ZAMSGF
      *                                                                                       CGP001
      ** Instrument Code is optional.                                                         CGP001
      *                                                                                       CGP001
     C     #1INSC        IFNE      *BLANKS
      *                                                                                       CGP001
     C                   CALL      'AOGINSR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1INSC        PGINS            10
     C     GPINST        PARM      GPINST        DSFDY
      *                                                                                       CGP001
     C     PRTCD         IFEQ      *BLANKS
      *                                                                                       CGP001
     C     '?'           SCAN      #1INSC        WPOS
     C     WPOS          IFNE      *ZERO
     C                   MOVE      'Y'           W0DCF
     C                   ENDIF
      *                                                                                       CGP001
     C                   MOVE      PGINS         #1INSC
     C                   ELSE
      *                                                                                       CGP001
     C                   SELECT
     C     PRTCD         WHENEQ    '*NOSEL '
     C                   MOVE      'USR9762'     ZAMSID
      *                                                                                       CGP001
      ** Invalid Instrument Code.                                                             CGP001
      *                                                                                       CGP001
     C     PRTCD         WHENEQ    '*NRF   '
     C                   MOVE      'USR9783'     ZAMSID
     C                   OTHER
     C     *LOCK         IN        LDA
     C                   MOVEL     'GPINSTPD'    DBFILE
     C                   MOVEL     PGINS         DBKEY
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDSL
      *                                                                                       CGP001
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDIF
      *                                                                                       CGP001
     C     ZAMSID        IFNE      *BLANKS
     C                   MOVE      *ON           *IN83
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRGPAC - Gets the Global Account, Product                    *                       CGP001
      *           and Instrument Codes.                               *                       CGP001
      *           Product and Instrument code overwritten in s/r      *                      BUG2312
      *           SRGPPI from files GPPRDXL0 and GPINSXL0             *                      BUG2312
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRGPAC        BEGSR
      *                                                                                       CGP001
     C                   MOVE      *BLANKS       #1GACD
     C                   MOVE      *BLANKS       #1PRDC
     C                   MOVE      *BLANKS       #1INSC
      *                                                                                       CGP001
     C                   MOVE      WZONE         KZONE
     C                   MOVEL     #1ACCD        KACOD
      *                                                                                       CGP001
     C********** KGPAC     CHAINGPACDXL0            N46                               CGP001 BUG3525
     C     KGPAC         CHAIN(N)  GPACDXL0                           66
      *                                                                                       CGP001
     C********** *IN46     IFEQ *OFF                                                  CGP001 BUG3525
     C     *IN66         IFEQ      *OFF
     C                   MOVE      ACGACD        #1GACD
     C                   MOVE      ACGPRD        #1PRDC
     C                   MOVE      ACGINS        #1INSC
     C                   ELSE
     C                   MOVE      *BLANK        #1GACD
     C                   MOVE      *BLANK        #1PRDC
     C                   MOVE      *BLANK        #1INSC
     C**********           MOVE *OFF      *IN46                                       TCA105 BUG3525
     C                   MOVE      *OFF          *IN66
     C************LOCK*****IN   LDA                                                    CGP001 TCA105
     C*********************MOVEL'GPACOD'  DBFILE                                       CGP001 TCA105
     C*********************CAT  'XPD':0   DBFILE                                       CGP001 TCA105
     C*********************MOVELKZONE     DBKEY                                        CGP001 TCA105
     C*********************CAT  KACOD:0   DBKEY                                        CGP001 TCA105
     C*********************Z-ADD4         DBASE                                        CGP001 TCA105
     C*********************OUT  LDA                                                    CGP001 TCA105
     C*********************MOVE *ON       *INU7                                        CGP001 TCA105
     C*********************MOVE *ON       *INU8                                        CGP001 TCA105
     C*********************MOVE *ON       *INLR                                        CGP001 TCA105
     C*********************EXSR *PSSR                                                  CGP001 TCA105
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                      BUG2312
      /EJECT                                                                                 BUG2312
      *****************************************************************                      BUG2312
      *                                                               *                      BUG2312
      *  SRGPPI - Gets the Global Product and Instrument Codes.       *                      BUG2312
      *                                                               *                      BUG2312
      *****************************************************************                      BUG2312
     C     SRGPPI        BEGSR
      *                                                                                      BUG2312
     C                   MOVE      *BLANKS       #1PRDC
     C                   MOVE      *BLANKS       #1INSC
      *                                                                                      BUG2312
     C                   MOVE      WZONE         KZONE
     C                   MOVE      'GL'          KMOD
     C                   MOVEL     #1ACCD        KTRTP
     C                   MOVE      #1ACCD        KTRST
      *                                                                                      BUG2312
     C********** KGPXR     CHAINGPPRDXL0            N46                              BUG2312 BUG3525
     C     KGPXR         CHAIN(N)  GPPRDXL0                           66
      *                                                                                      BUG2312
     C********** *IN46     IFEQ *OFF                                                 BUG2312 BUG3525
     C     *IN66         IFEQ      *OFF
     C                   MOVE      PDGPRD        #1PRDC
     C                   ENDIF
      *                                                                                      BUG2312
     C********** KGPXR     CHAINGPINSXL0            N46                              BUG2312 BUG3525
     C     KGPXR         CHAIN(N)  GPINSXL0                           66
      *                                                                                      BUG2312
     C********** *IN46     IFEQ *OFF                                                 BUG2312 BUG3525
     C     *IN66         IFEQ      *OFF
     C                   MOVE      INGINS        #1INSC
     C                   ENDIF
      *                                                                                      BUG2312
     C                   ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRGPOF - Opens the Global Processing Cross-Reference Files.  *                       CGP001
      *           Need to open GPPRDXL0 and GPINSXL0 as well.         *                      BUG2312
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRGPOF        BEGSR
      *                                                                                       CGP001
     C                   Z-ADD     80            PLEN             15 5
      *                                                                                       CGP001
     C                   DO        3             WIDX              1 0
      *                                                                                      BUG2312
     C**********           MOVE OVRC,1    PCMD   80                                    GP001 BUG2312
     C                   MOVE      OVRC(WIDX)    PCMD             80
      *                                                                                       CGP001
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCMD
     C                   PARM                    PLEN
      *                                                                                      BUG2312
     C                   ENDDO
      *                                                                                       CGP001
     C                   OPEN      GPACDXL0
     C                   OPEN      GPPRDXL0
     C                   OPEN      GPINSXL0
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRGPGZ - Gets the Zone via GOGETZONE.                        *                       CGP001
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRGPGZ        BEGSR
      *                                                                                       CGP001
     C                   CALL      GOPGM
     C                   PARM      *BLANKS       PZRTCD            7
     C                   PARM      *BLANKS       PZERMS           50
     C                   PARM      'N'           PZFCHK            1
     C                   PARM      *BLANKS       PZZONE           10
     C                   PARM      *BLANKS       PZSHTC            4
     C                   PARM      *ZERO         PZRDNB            5 0
     C                   PARM      *ZERO         PZDNWD            5 0
     C                   PARM      *BLANKS       PZBCCY            3
     C                   PARM      *ZERO         PZNJOB            1 0
      *                                                                                       CGP001
     C     PZRTCD        IFEQ      *BLANKS
     C                   MOVE      PZZONE        WZONE            10
     C                   ELSE
      *                                                                                       CGP001
     C     PZRTCD        IFEQ      '*ERROR'
     C                   MOVEL     GOMSG         PZERMS
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRGPXU - Writes and updates records on the Global            *                       CGP001
      *           Processing Cross-Reference File.                    *                       CGP001
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRGPXU        BEGSR
      *                                                                                       CGP001
     C                   MOVE      WZONE         KZONE
     C                   MOVEL     A5ACCD        KACOD
      *                                                                                       CGP001
     C********** KGPAC     CHAINGPACDXL0             46                               CGP001 BUG3525
     C     KGPAC         CHAIN     GPACDXL0                           66
      *                                                                                       CGP001
     C********** *IN46     IFEQ *ON                                                   CGP001 BUG3525
     C     *IN66         IFEQ      *ON
     C                   MOVE      KZONE         ACZONE
     C                   MOVE      KACOD         ACACCD
     C                   MOVE      #1GACD        ACGACD
     C                   MOVE      #1PRDC        ACGPRD
     C                   MOVE      #1INSC        ACGINS
     C                   WRITE     GPACDXD0
     C                   ELSE
     C                   MOVE      #1GACD        ACGACD
     C                   MOVE      #1PRDC        ACGPRD
     C                   MOVE      #1INSC        ACGINS
     C                   UPDATE    GPACDXD0
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                      BUG2312
      /EJECT                                                                                 BUG2312
      *****************************************************************                      BUG2312
      *                                                               *                      BUG2312
      *  XRGPXU - Writes and updates records on the Global            *                      BUG2312
      *           Processing Cross-Reference Files.                   *                      BUG2312
      *                                                               *                      BUG2312
      *****************************************************************                      BUG2312
     C     XRGPXU        BEGSR
      *                                                                                      BUG2312
     C                   MOVE      WZONE         KZONE
     C                   MOVE      'GL'          KMOD
     C                   MOVEL     #1ACCD        KTRTP
     C                   MOVE      #1ACCD        KTRST
      *                                                                                      BUG2312
     C********** KGPXR     CHAINGPPRDXL0             46                              BUG2312 BUG3525
     C     KGPXR         CHAIN     GPPRDXL0                           66
      *                                                                                      BUG2312
     C********** *IN46     IFEQ *ON                                                  BUG2312 BUG3525
     C     *IN66         IFEQ      *ON
     C                   MOVE      KZONE         PDZONE
     C                   MOVE      KMOD          PDMOD
     C                   MOVE      KTRTP         PDTRTP
     C                   MOVE      KTRST         PDTRST
     C                   MOVE      #1PRDC        PDGPRD
     C     PDGPRD        IFNE      *BLANK
     C                   WRITE     GPPRDXD0
     C                   ENDIF
     C                   ELSE
     C                   MOVE      #1PRDC        PDGPRD
     C     PDGPRD        IFNE      *BLANK
     C                   UPDATE    GPPRDXD0
     C                   ELSE
     C                   DELETE    GPPRDXD0
     C                   ENDIF
     C                   ENDIF
      *                                                                                      BUG2312
     C********** KGPXR     CHAINGPINSXL0             46                              BUG2312 BUG3525
     C     KGPXR         CHAIN     GPINSXL0                           66
      *                                                                                      BUG2312
     C********** *IN46     IFEQ *ON                                                  BUG2312 BUG3525
     C     *IN66         IFEQ      *ON
     C                   MOVE      KZONE         INZONE
     C                   MOVE      KMOD          INMOD
     C                   MOVE      KTRTP         INTRTP
     C                   MOVE      KTRST         INTRST
     C                   MOVE      #1INSC        INGINS
     C     INGINS        IFNE      *BLANK
     C                   WRITE     GPINSXD0
     C                   ENDIF
     C                   ELSE
     C                   MOVE      #1INSC        INGINS
     C     INGINS        IFNE      *BLANK
     C                   UPDATE    GPINSXD0
     C                   ELSE
     C                   DELETE    GPINSXD0
     C                   ENDIF
     C                   ENDIF
      *                                                                                      BUG2312
     C                   ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRGPXD - Deletes records on the Global Processing Cross-     *                       CGP001
      *           Reference Files.                                    *                       CGP001
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRGPXD        BEGSR
      *                                                                                       CGP001
     C                   MOVE      WZONE         KZONE
     C                   MOVEL     A5ACCD        KACOD
      *                                                                                       CGP001
     C********** KGPAC     CHAINGPACDXL0             46                               CGP001 BUG3525
     C     KGPAC         CHAIN     GPACDXL0                           66
      *                                                                                       CGP001
     C********** *IN46     IFEQ *OFF                                                  CGP001 BUG3525
     C     *IN66         IFEQ      *OFF
     C                   DELETE    GPACDXD0
     C                   ELSE
     C**********           MOVE *OFF      *IN46                                       TCA105 BUG3525
     C                   MOVE      *OFF          *IN66
     C************LOCK*****IN   LDA                                                    CGP001 TCA105
     C*********************MOVEL'GPACOD'  DBFILE                                       CGP001 TCA105
     C*********************CAT  'XPD':0   DBFILE                                       CGP001 TCA105
     C*********************MOVELKZONE     DBKEY                                        CGP001 TCA105
     C*********************CAT  KACOD:0   DBKEY                                        CGP001 TCA105
     C*********************Z-ADD4         DBASE                                        CGP001 TCA105
     C*********************OUT  LDA                                                    CGP001 TCA105
     C*********************MOVE *ON       *INU7                                        CGP001 TCA105
     C*********************MOVE *ON       *INU8                                        CGP001 TCA105
     C*********************MOVE *ON       *INLR                                        CGP001 TCA105
     C*********************EXSR *PSSR                                                  CGP001 TCA105
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                      BUG2312
      /EJECT                                                                                 BUG2312
      *****************************************************************                      BUG2312
      *                                                               *                      BUG2312
      *  XRGPXD - Deletes records on the Global Processing Cross-     *                      BUG2312
      *           Reference Files.                                    *                      BUG2312
      *                                                               *                      BUG2312
      *****************************************************************                      BUG2312
     C     XRGPXD        BEGSR
      *                                                                                      BUG2312
     C                   MOVE      WZONE         KZONE
     C                   MOVE      'GL'          KMOD
     C                   MOVEL     #1ACCD        KTRTP
     C                   MOVE      #1ACCD        KTRST
      *                                                                                      BUG2312
     C********** KGPXR     CHAINGPPRDXL0             46                              BUG2312 BUG3525
     C     KGPXR         CHAIN     GPPRDXL0                           66
      *                                                                                      BUG2312
     C********** *IN46     IFEQ *OFF                                                 BUG2312 BUG3525
     C     *IN66         IFEQ      *OFF
     C                   DELETE    GPPRDXD0
     C                   ENDIF
      *                                                                                      BUG2312
     C********** KGPXR     CHAINGPINSXL0             46                              BUG2312 BUG3525
     C     KGPXR         CHAIN     GPINSXL0                           66
      *                                                                                      BUG2312
     C********** *IN46     IFEQ *OFF                                                 BUG2312 BUG3525
     C     *IN66         IFEQ      *OFF
     C                   DELETE    GPINSXD0
     C                   ENDIF
      *                                                                                      BUG2312
     C                   ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      *                                                               *                       CLE025
      *  SRADCHK - Additional Check for CLE025 and CGL014             *                       CLE025
      *                                                               *                       CLE025
      *****************************************************************                       CLE025
     C     SRADCK        BEGSR
      *                                                                                       CLE025
     C                   MOVE      *BLANKS       ZAMSID
     C                   MOVE      *BLANKS       ZAMSGF
      *                                                                                       CLE025
      ** At least one of the Product Code or Instrument Code must be                          CLE025
      ** entered for Retail account code                                                      CLE025
      *                                                                                       CLE025
     C     #1PRDC        IFEQ      *BLANKS
     C     #1INSC        ANDEQ     *BLANKS
     C     #1ACTY        ANDEQ     'R'
     C                   MOVE      *ON           *IN82
     C                   MOVE      *ON           *IN83
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USR9830'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE025
     C                   ENDSR
      *****************************************************************                       CLE025
      /EJECT                                                                                  CLE025
      *****************************************************************                       CLE025
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
      * Start of SAR S01212
      * 00/Copy Member SD0031REPP - Account Codes  *
     C*
     C/COPY WNCPYSRC,SD0031REPP
     C*
      * End of SAR S01212
      * CASE: KEY.*CMD key is *Exit
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C     CSD032        IFEQ      'N'
     C                   MOVEL     *BLANK        P0RTN
     C                   ENDIF
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
     C                   CLOSE     GPACDXL0
     C                   ENDIF
      *                                                                                       CSD031
     C     CSD032        IFEQ      'Y'
     C                   CLOSE     SDAACDL0
     C                   ENDIF
      *                                                                                       CRE015
     C     CRE015        IFEQ      'Y'
     C                   CLOSE     SDACD1L0
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
      *                                                                                       CGP001
      ** Global Processing X-Reference Key Defn                                               CGP001
      *                                                                                       CGP001
     C     *LIKE         DEFINE    WZONE         KZONE
     C     *LIKE         DEFINE    A5ACCD        KACOD
      *                                                                                       CGP001
      ** Global Processing X-Reference Key List                                               CGP001
      *                                                                                       CGP001
     C     KGPAC         KLIST
     C                   KFLD                    KZONE
     C                   KFLD                    KACOD
      *                                                                                      BUG2312
      ** The 'real' Global Processing X-Reference Key List                                   BUG2312
      *                                                                                      BUG2312
     C     KGPXR         KLIST
     C                   KFLD                    KZONE
     C                   KFLD                    KMOD              2
     C                   KFLD                    KTRTP             5
     C                   KFLD                    KTRST             5
      *                                                                                       CGP001
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
      * Obtain default message file
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field Deletion Allowed
     C                   MOVEL     *BLANK        WUDELA            1
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field ZALIGN Screen Fun Field
     C                   MOVEL     *BLANK        WUZASF           16
      * Define work field ZALIGN File Field
     C                   MOVEL     *BLANK        WUZAFF           16
      * Define work field Err Code
     C                   MOVEL     *BLANK        WUERCD            1
      * Define work field Dsp withholding tax Flds
     C                   MOVEL     *BLANK        WUDSWT            1
      * Define work field ZALIGN No Of Decimals
     C                   Z-ADD     *ZERO         WUZAND            1 0
      * Define work field Title Only func
     C                   MOVEL     *BLANK        WUTIOF            1
      * Define work field A/C code cannot be deletd
     C                   MOVEL     *BLANK        WUACDL            1
      * Define work field User Defined Correspondnc
     C                   MOVEL     *BLANK        WUN1ST            1
      * Define work field Return Code work field
     C                   MOVEL     *BLANK        WURTCD            7
      * Define work field CMC001
     C                   MOVEL     *BLANK        WUCMC1            1
      * Define work field Profit Centres Used
     C                   MOVEL     *BLANK        WUPRCU            1
      * Define work field Analytical Accounting
     C                   MOVEL     *BLANK        WUN0ST            1
      * Define work field CRE002
     C                   MOVEL     *BLANK        WURAPE            1
      * Define work field Test invalid val in key f
     C                   MOVEL     *BLANK        WUTIVK            1
      * Define work field Retail Present
     C                   MOVEL     *BLANK        WUREPR            1
      * Define work field A/c Posting Retention Pd
     C                   Z-ADD     *ZERO         WUAPRP            2 0
      * Define work field Account Code
     C**********           MOVEL*BLANK    WUACCD  4                                           CGL029
     C                   MOVEL     *BLANK        WUACCD           10
      * Define work field Numeric flag
     C                   MOVEL     *BLANK        WUNMFL            1
      * Define work field Account type
     C                   MOVEL     *BLANK        WUACTY            1
      * Define work field Title Only Indicator
     C                   MOVEL     *BLANK        WUTOIN            1
      * Define work field Account Section
     C                   MOVEL     *BLANK        WUACSC            2
      * Define work field Midas-Trade Innovation If
     C                   MOVEL     *BLANK        WUN3ST            1
      * Define work field question mark entered
     C                   MOVEL     *BLANK        WUQMEN            1
      * Define work field Portfolio Management
     C                   MOVEL     *BLANK        WUPFMG            1
      * Define work field Portfolios Supported
     C                   MOVEL     *BLANK        WUPORS            1
      * Define work field Test ? in Key Field
     C                   MOVEL     *BLANK        WUTQKF            1
      * Define work field PM Instrument Code (Lndr)
     C                   MOVEL     *BLANK        WUINNR            3
      * Define work field Access Pgm Option
     C                   MOVEL     *BLANK        WUAPOP            7
      * Define work field Access Pgm Return Code
     C                   MOVEL     *BLANK        WUAPRC            7
      * Define work field Withholding Tax screen
     C                   MOVEL     *BLANK        WUWTSC           16
      * Define work field ZALIGN No Of Digits
     C                   Z-ADD     *ZERO         WUZADG            2 0
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field Window processing requir.
     C                   MOVEL     *BLANK        WUWDPR            1
      * Define work field No. of Records
     C                   Z-ADD     *ZERO         WUNORC            5 0
      * Define work field No. of Inserts
     C                   Z-ADD     *ZERO         WUNOIN            5 0
      * Define work field No. of Amends
     C                   Z-ADD     *ZERO         WUNOAM            5 0
      * Define work field No. of Deletes
     C                   Z-ADD     *ZERO         WUNODL            5 0
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
      * Define work field Dsp Man Acc Anl by PC Nar
     C                   MOVEL     *BLANK        WUDMPN            1
      * Define work field Dsp MA Anal by Prft Cntr
     C                   MOVEL     *BLANK        WUDMPC            1
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
      * Define work field Dealing: FX
     C                   MOVEL     *BLANK        WUDLFX            1
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
      * Define work field Midas/Swift direct link
     C                   MOVEL     *BLANK        WUMSDL            1
      * Define work field Securities
     C                   MOVEL     *BLANK        WUSECS            1
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
      * Define work field Funds Transfer
     C                   MOVEL     *BLANK        WUFDTR            1
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
      * Define work field Interest Risk Management
     C                   MOVEL     *BLANK        WURKMG            1
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
      * Define work field Midas-Plato Interface
     C                   MOVEL     *BLANK        WUN2ST            1
      * Define work field Private Banking                                 CPB001
     C                   MOVEL     *BLANK        WUN4ST            1
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
      * Define work field Currency Code
     C                   MOVEL     *BLANK        WUCYCD            3
      * Define work field Number of Decimal Places
     C                   Z-ADD     *ZERO         WUNBDP            1 0
      * Define work field SAR number field
     C                   MOVEL     *BLANK        WUSARN            6
      * Define work field Access obj dummy DS (76)
     C                   MOVEL     *BLANK        WUFDY            76
      * Define work field Portfolio Manage ICD Key
     C                   MOVEL     *BLANK        WUPORT           10
      * Define work field Ref Attached to 9997
     C                   MOVEL     *BLANK        WUR997            4
      * Define flag which indicates shift Y->N for #1TFCA                 CTI002
     C                   MOVEL     *BLANK        WYNCA             1                           CTI00
      * Define work field Trade Finance Contingent Account                CTI002
     C     *LIKE         DEFINE    #1TFCA        WKTFCA                                        CTI00
      * Define flag CTI002 is or not active                               CTI002
     C     *LIKE         DEFINE    WUPFMG        WUTI02                                        CTI00
      * To memorize previous message for footer                           CTI002
     C     *LIKE         DEFINE    ##CTX1        WOCTX1                                        CTI00
      * Flag no *SET CURSOR in the program
     C                   MOVE      'N'           YSETCS            1
     C                   MOVE      *BLANK        WCSRLC            3
     C                   MOVE      *BLANK        SECO              1
      *                                                                                     MD062338
      ** ZMITEM Data Area                                                                   MD062338
     C     *DTAARA       DEFINE                  ZMITEM                                     MD062338
      *                                                                                     MD062338
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
     C                   OPEN      SD0031R#
     C                   OPEN      SDACODL1
     C                   OPEN      SDGELRL1
     C**********         OPEN      SDTIACL1                                                 MD058085
     C                   OPEN      SDACRCL4
     C                   OPEN      SDMMODL1
     C                   OPEN      SDBANKL1
     C                   OPEN      SDCURRL1
     C                   OPEN      SDPORTL1
     C                   OPEN      SDACODL0
     C**********         OPEN      SDFCTLL0                                                 MD061007
     C                   OPEN      SDACRCL0
      *                                                                                       CDL013
      ***   Check if CAR CDL013 is installed                                                  CDL013
      *                                                                                       CDL013
     C                   CALL      'AOSARDR0'                           85
     C                   PARM      *BLANK        WQ0138            7
     C                   PARM      '*VERIFY'     WQ0139            7
     C                   PARM      'CDL013'      WQ0140            6
     C                   PARM      *BLANK        WQ0141           76
      *                                                                                       CDL013
      ** If program fails send error message                                                  CDL013
      *                                                                                       CDL013
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      *                                                                                       CDL013
     C                   ELSE
      *                                                                                       CDL013
      ** CAR CDL013 is not installed set off flag                                             CDL013
      *                                                                                       CDL013
     C     WQ0138        IFEQ      '*NRF'
     C                   MOVE      '0'           CDL013            1
      *                                                                                       CDL013
      ** CAR CDL013 is installed set on flag.                                                 CDL013
      *                                                                                       CDL013
     C                   ELSE
     C                   MOVE      '1'           CDL013
     C                   MOVE      *OFF          *IN87
     C                   MOVE      *OFF          *IN72
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CDL013
      *                                                                                       CDL013
     C     CDL013        IFEQ      '1'
     C                   OPEN      SDACOAL0
     C                   OPEN      SDACOAL1
     C                   ENDIF
      *                                                                                       CDL013
      *                                                                                       CDL013
     C/COPY WNCPYSRC,SD0031RC14
     C                   MOVEL     'N'           W0PMT             1
     C                   MOVEL     'CHG'         W0PMD             3
     C                   MOVEL     *BLANK        W0GRP             1
      *                                                                   CSD005
      *** Move switch into  working field                                 CSD005
      *                                                                   CSD005
     C                   MOVEL     'CSD005'      WUSARN                         SAR number fielCSD00
      *                                                                   CSD005
      *** Retrieve the status of the switchable feature                   CSD005
      *                                                                   CSD005
     C                   CALL      'AOSARDR0'                           90      SAR switched onCSD00
     C     WUAPRC        PARM      WUAPRC        WQ0146            7            Access Pgm RetuCSD00
     C                   PARM      '*VERIFY'     WQ0147            7            Option for ACCOCSD00
     C     WUSARN        PARM      WUSARN        WQ0148            6            SAR number fielCSD00
     C                   PARM      WUFDY         WQ0149           76            Access obj dummCSD00
      *                                                                   CSD005
      *** If call end in error send error message                         CSD005
      *                                                                   CSD005
     C     *IN90         IFEQ      '1'                                                         CSD00
      *                                                                   CSD005
     C                   MOVEL     'Y2U0032'     W0RTN                                         CSD00
     C                   MOVEL     *BLANKS       W0CLPG           10                           CSD00
     C                   MOVEL     'AOSARDR0'    W0CLPG                                        CSD00
      *
      *** Send message '*Error occured on CALL...'                        CSD005
      *
     C                   MOVEL     'Y2U0032'     ZAMSID                                        CSD00
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        CSD00
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data   CSD00
     C                   EXSR      ZASNMS                                                      CSD00
     C                   ENDIF                                                                 CSD00
      *                                                                   CSD005
      *** If no error on call then switch on feature indicator            CSD005
      *                                                                   CSD005
     C                   SELECT                                                                CSD00
     C     WUAPRC        WHENEQ    *BLANK                                                      CSD00
     C                   MOVE      *ON           *IN69                                         CSD00
     C     WUAPRC        WHENEQ    '*NRF'                                                      CSD00
     C                   MOVE      *OFF          *IN69                                         CSD00
     C                   ENDSL                                                                 CSD00
      *                                                                                       CGP001
      ** Check if CGP001 is enabled.                                                          CGP001
      *                                                                                       CGP001
     C     *DTAARA       DEFINE                  LDA
      *                                                                                       CGP001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CGP001'      PSARD             6
     C     DSSARD        PARM      DSSARD        DSFDY
      *                                                                                       CGP001
     C                   MOVE      'N'           CGP001            1
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGP001
     C                   MOVE      *ON           *IN68
      *                                                                                       CGP001
      ** Open the Global Processing Files.                                                    CGP001
      *                                                                                       CGP001
     C                   EXSR      SRGPOF
      *                                                                                       CGP001
      ** Get the Zone.                                                                        CGP001
      *                                                                                       CGP001
     C                   EXSR      SRGPGZ
     C                   ELSE
      *                                                                                       CGP001
     C     PRTCD         IFNE      '*NRF'
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CGP001'      DBKEY
     C                   MOVEL     7             DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDIF
      *                                                                                       CSD031
      ** Check if CSD032 is switched on                                                       CSD031
      *                                                                                       CSD031
     C                   MOVE      'N'           CSD032            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD032'      PSARD
     C     DSSARD        PARM      DSSARD        DSFDY
      *                                                                                       CSD031
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSD032
     C                   OPEN      SDAACDL0
     C                   MOVE      *ON           *IN92
     C                   ENDIF
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBKEY
     C                   MOVEL     '08'          DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CLE025
      ** Check if Credit Lines (CLE025) is installed                                          CLE025
      *                                                                                       CLE025
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE025'      PSARD
     C     DSSARD        PARM      DSSARD        DSFDY
      *                                                                                       CLE025
     C                   MOVE      'N'           CLE025            1
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE025
     C                   ELSE
     C     PRTCD         IFNE      '*NRF'
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CLE025'      DBKEY
     C                   Z-ADD     8             DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE025
      ** Check if Collateralised Lending (CGL014) is switched on                              CLE025
      *                                                                                       CLE025
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGL014'      PSARD
     C     DSSARD        PARM      DSSARD        DSFDY
      *                                                                                       CLE025
     C                   MOVE      'N'           CGL014            1
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGL014
     C                   ELSE
     C     PRTCD         IFNE      '*NRF'
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CGL014'      DBKEY
     C                   Z-ADD     9             DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *                                                                   CSD005
      *** Move switch into  working field                                 CPB004
      *                                                                   CPB004
     C                   MOVEL     'CPB004'      WUSARN                         SAR number fielCPB00
      *                                                                   CPB004
      *** Retrieve the status of the switchable feature                   CPB004
      *                                                                   CPB004
     C                   CALL      'AOSARDR0'                           90      SAR switched onCPB00
     C     WUAPRC        PARM      WUAPRC        WQ0146            7            Access Pgm RetuCPB00
     C                   PARM      '*VERIFY'     WQ0147            7            Option         CPB00
     C     WUSARN        PARM      WUSARN        WQ0148            6            SAR number fielCPB00
     C                   PARM      WUFDY         WQ0149           76            Access obj dummCPB00
      *                                                                   CPB004
      *** If call end in error send error message                         CPB004
      *                                                                   CPB004
     C     *IN90         IFEQ      '1'                                                         CPB00
      *                                                                   CPB004
     C                   MOVEL     'Y2U0032'     W0RTN                                         CPB00
     C                   MOVEL     *BLANKS       W0CLPG           10                           CPB00
     C                   MOVEL     'AOSARDR0'    W0CLPG                                        CPB00
      *                                                                   CPB004
      *** Send message '*Error occured on CALL...'                        CPB004
      *                                                                   CPB004
     C                   MOVEL     'Y2U0032'     ZAMSID                                        CPB00
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        CPB00
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data   CPB00
     C                   EXSR      ZASNMS                                                      CPB00
     C                   ENDIF                                                                 CPB00
      *                                                                   CPB004
      *** If no error on call then switch on feature indicator            CPB004
      *                                                                   CPB004
     C                   SELECT                                                                CPB00
     C     WUAPRC        WHENEQ    *BLANK                                                      CPB00
     C                   MOVE      'Y'           WPB004            1                           CPB00
     C                   OPEN      ACACOD                                                      CPB00
      *                                                                   CPB004
      *** Only to declare this LF in update mode                          CPB004
      *                                                                   CPB004
     C     *IN99         IFEQ      *ON                                                         CPB00
     C     *IN99         ANDEQ     *OFF                                                        CPB00
     C                   WRITE     ACCNTABG                                                    CPB00
     C                   ENDIF                                                                 CPB00
     C     WUAPRC        WHENEQ    '*NRF'                                                      CPB00
     C                   MOVE      'N'           WPB004                                        CPB00
     C                   ENDSL                                                                 CPB00
      *                                                                   CPB004
      * USER: Initialize program
      * Start of S01459
      * Remove the last amend box function.
      * Remove the creation parameters function.
      * SD0031R precompiler - Account Codes  *
      * End of S01459
      * Copyright Statement 1988 - Standard Functions  * copyright
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      * Set-up DTL Screen Footer - Standard Functions  *
     C*
     C*  DETAIL LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C*  If Action Code is Delete :
     C*
     C     P2ANCD        IFEQ      'D'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F10=Delete   F12=Previous
     C                   MOVEL     'USR3350'     WUMSID            7            Message Identifier
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
     C*  If Action Code is Insert :
     C*
     C     P2ANCD        IFEQ      'I'                                                         S0122
     C* Setup footer text:
     C* F3=Exit   F12=Previous
     C                   MOVEL     'USR3351'     WUMSID                         Message Identifier
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
     C*  If Action Code is Amend :
     C*
     C     P2ANCD        IFEQ      'A'                                                         S0122
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
      * Start of S01522
      * Call 'get all Midas Modules' to retrieve the module flags.
      * Get all Midas Modules - MIDAS Modules  *
     C                   EXSR      TARVGN
      * End of S01522
      * Start of 063606
      * Determine the number of decimal places for base currency.
      * Get Base Currency - Bank Details  *
     C                   EXSR      TBRVGN
      * Get Number of Dec Places - Currency Codes  *
     C                   EXSR      TCRVGN
     C                   Z-ADD     WUNBDP        WUZAND                         ZALIGN No Of De
     C     13            SUB       WUZAND        WUZADG                         ZALIGN No Of Di
     C                   MOVEL     'N'           WUDSWT                         Dsp withholding
      * start S01413
      * Start of S01522
      * Called 'get all Midas Modules' instead of calling
      * 'Get Taxes & R3 indicators'.
      * End of S01522
      * Display or hide withholding tax fields.
      * CASE:
      *  - c1 AND c2
      *   |- c1    : WRK.Retail 3 is Yes
      *   |- c2    : WRK.Taxes is Yes
      *   '-
     C                   MOVEL     '0'           Y0CX01            1
     C     WUNXST        IFEQ      'Y'                                          *IF
     C     WUNTST        IFEQ      'Y'                                          *IF
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     Y0CX01        IFEQ      '1'                                          *IF
     C                   MOVEL     'Y'           WUDSWT                         Dsp withholding
     C                   END                                                    *FI
      * end S01413
      * End of 063606
      * Start of S01461
      * Remove the processing for 'Midas export ' module.
      * Determine which Midas modules are 'on' in the system.
      * Start of S01522
      * Called 'get all Midas Modules' instead of calling
      * 'Get practically everything'.
      * End of S01522
      * End of S01461
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
     C                   MOVEL     'ADD'         W0PMD                          *Program mode
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'CHG'         W0PMD                          *Program mode
     C                   END                                                    *FI
      * CASE: PAR.Account code is blank
     C     P1ACCD        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'ADD'         W0PMD                          *Program mode
     C                   END                                                    *FI
      * Start of S01486
      * Start of S01522
      * Called 'get all Midas Modules' instead of calling
      * 'Get Portfolio Management'.
      * End of S01522
      * End of S01486
      * Start of SAR S01212
      * Start of Fix E21267 and E21390
      * Change retrieve object so that the retail and interest on account
      * indicators are retrieved from the midas modules file
      * Start of S01522
      * Called 'get all Midas Modules' instead of calling
      * 'Get WN, RE and IA Inds.'
      * End of S01522
      * retail present is yes unless both retail and interest on accounts
      * are not present
     C                   MOVEL     'Y'           WUREPR                         Retail Present
      * CASE: WRK.Retail Banking is No or Blank
     C     WURTBN        IFEQ      *BLANK                                       *IF
     C     WURTBN        OREQ      'N'
      * CASE: WRK.Interest on accounts is No or Blank
     C     WUIOAC        IFEQ      *BLANK                                       *IF
     C     WUIOAC        OREQ      'N'
     C                   MOVEL     'N'           WUREPR                         Retail Present
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of Fix E21267 and E21390
      * Start CAC001 - Profit Centre Accounting.
      * Check to see if CAC001 - Profit Centre Accounting - is present.
     C                   MOVEL     'CMC001'      WUSARN                         SAR number fiel
      * SAR switched on check - Standard Functions  *
     C                   CALL      'AOSARDR0'                           90      SAR switched on
     C     WUAPRC        PARM      WUAPRC        WQ0138            7            Access Pgm Retu
     C                   PARM      '*VERIFY'     WQ0139            7            Option for ACCO
     C     WUSARN        PARM      WUSARN        WQ0140            6            SAR number fiel
     C                   PARM      WUFDY         WQ0141           76            Access obj dumm
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
     C                   MOVEL     'Y'           WUCMC1                         CMC001
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUCMC1                         CMC001
     C                   END                                                    *FI
      * Check Profit Centres Used - General Ledger Details  *
     C                   EXSR      TDRVGN
      * Set Input/Output indicator for 'Man. Acc. Analysis by Profit Cent
      * CASE:
      *  - c1 AND c2
      *   |- c1    : WRK.CMC001 is Present
      *   |- c2    : WRK.Profit Centres Used is Yes
      *   '-
     C                   MOVEL     '0'           Y0CX01            1
     C     WUCMC1        IFEQ      'Y'                                          *IF
     C     WUPRCU        IFEQ      'Y'                                          *IF
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     Y0CX01        IFEQ      '1'                                          *IF
     C                   MOVEL     'Y'           WUDMPN                         Dsp Man Acc Anl
      * CASE: WRK.Analytical Accounting is Yes
     C     WUN0ST        IFEQ      'Y'                                          *IF
     C                   MOVEL     'N'           WUDMPC                         Dsp MA Anal by
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'Y'           WUDMPC                         Dsp MA Anal by
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUDMPC                         Dsp MA Anal by
     C                   MOVEL     'N'           WUDMPN                         Dsp Man Acc Anl
     C                   END                                                    *FI
      * End CAC001
      * Start CRE002 - Retail Accruals Processing Enhancement
      * Check if CRE002 - Retail Accruals Processing Enhancement is prese
     C                   MOVEL     'CRE002'      WUSARN                         SAR number fiel
      * SAR switched on check - Standard Functions  *
     C                   CALL      'AOSARDR0'                           90      SAR switched on
     C     WUAPRC        PARM      WUAPRC        WQ0142            7            Access Pgm Retu
     C                   PARM      '*VERIFY'     WQ0143            7            Option for ACCO
     C     WUSARN        PARM      WUSARN        WQ0144            6            SAR number fiel
     C                   PARM      WUFDY         WQ0145           76            Access obj dumm
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
     C                   MOVEL     'Y'           WURAPE                         CRE002
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WURAPE                         CRE002
     C                   END                                                    *FI
      * End CRE002
      *-------------------------------------------------------------------CFT002
      * Check if CFT002 - Decode & Auto-Gen Feature is installed          CFT002
      *                                                                   CFT002
     C                   CALL      'AOSARDR0'                                   Rtv SAR DetailsCFT00
     C                   PARM      *BLANKS       P@RTCD            7            -B:Return Code CFT00
     C                   PARM      '*VERIFY'     P@OPTN            7            -I:Action      CFT00
     C                   PARM      'CFT002'      P@SARD            6            -I:SAR Id      CFT00
     C     DSSARD        PARM      *BLANKS       DSFDY                          -O:Format      CFT00
      *                                                                   CFT002
      *- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -CFT002
      * Check return code.                                                CFT002
      *                                                                   CFT002
     C     P@RTCD        IFEQ      *BLANK                                       If Feature on  CFT00
     C                   MOVEL     'Y'           CFT002            1             Set Flag      CFT00
     C                   ELSE                                                   Else           CFT00
     C                   MOVEL     'N'           CFT002                          Set Flag      CFT00
     C                   END                                                    End If         CFT00
      *                                                                   CFT002
      * Start of change 104645
      * If Portfolio Management present.
      * CASE: WRK.Portfolio Management is Yes
     C     WUPFMG        IFEQ      'Y'                                          *IF
      * Get Port Man ICD fields - Portfolio Management ICD  *
     C                   EXSR      TERVGN
     C                   END                                                    *FI
      * End of change 104645
      * Account Data Structure - Account Codes  *
      * 00/Copy Member SD0031RIPG - Account Codes  *
     C/COPY WNCPYSRC,SD0031RCPG
      * End of SAR S01212
      *================================================================
      *                                                                                     MD030956
      ** Access SAR details to see if CTI007 is switched on                                 MD030956
      *                                                                                     MD030956
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*VERIFY'     P@OPTN
     C                   PARM      'CTI007'      P@SARD
     C     DSSARD        PARM      *BLANKS       DSFDY
      *                                                                                     MD030956
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CTI007            1
     C                   ELSE
     C                   MOVE      'N'           CTI007
     C                   ENDIF
      *                                                                                     MD030956
      * Check to see if CTI002 - is present.                              CTI002
     C                   MOVEL     'CTI002'      WUSARN                         SAR number fielCTI00
      * SAR switched on check - Standard Functions  *                     CTI002
     C                   CALL      'AOSARDR0'                           90      SAR switched onCTI00
     C     WUAPRC        PARM      WUAPRC        WQ0146            7            Access Pgm RetuCTI00
     C                   PARM      '*VERIFY'     WQ0147            7            Option for ACCOCTI00
     C     WUSARN        PARM      WUSARN        WQ0148            6            SAR number fielCTI00
     C                   PARM      WUFDY         WQ0149           76            Access obj dummCTI00
      *                                                                   CTI002
     C     *IN90         IFEQ      '1'                                                         CTI00
      * Call to program ended in error                                    CTI002
     C                   MOVEL     'Y2U0032'     W0RTN                                         CTI00
     C                   MOVEL     *BLANKS       W0CLPG           10                           CTI00
     C                   MOVEL     'AOSARDR0'    W0CLPG                                        CTI00
      * Send message '*Error occured on CALL...'                          CTI002
     C                   MOVEL     'Y2U0032'     ZAMSID                                        CTI00
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        CTI00
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data   CTI00
     C                   EXSR      ZASNMS                                                      CTI00
     C                   END                                                                   CTI00
      *                                                                   CTI002
      * Check return code.                                                CTI002
      * CASE: WRK.Access Pgm Return Code is *Normal                       CTI002
      *       AND TRADE INNOVATION ACTIVE                                 CTI002
     C     WUAPRC        IFEQ      *BLANK                                                      CTI00
     C     WUN3ST        ANDEQ     'Y'                                                         CTI00
     C     CTI007        OREQ      'Y'
     C                   MOVEL     'Y'           WUTI02                                        CTI00
     C*********************MOVEL'0'       *IN59                     CTI002CFT002
     C                   MOVEL     '0'           *IN61                                         CFT00
     C                   MOVEL     WTFCA         #1WHTF
     C                   ELSE                                                                  CTI00
      * CASE: *OTHERWISE                                                  CTI002
     C                   MOVEL     'N'           WUTI02                                        CTI00
     C*********************MOVEL'1'       *IN59                     CTI002CFT002
     C                   MOVEL     '1'           *IN61                                         CFT00
     C                   MOVEL     *BLANKS       #1WHTF
     C                   END                                                                   CTI00
      *                                                                   CGL010
      ** Access SAR details to see if CGL010 is switched on               CGL010
      *                                                                   CGL010
     C                   CALL      'AOSARDR0'                                                  CGL01
     C                   PARM      *BLANKS       P@RTCD                                        CGL01
     C                   PARM      '*VERIFY'     P@OPTN                                        CGL01
     C                   PARM      'CGL010'      P@SARD                                        CGL01
     C     DSSARD        PARM      *BLANKS       DSFDY                                         CGL01
      *                                                                   CGL010
     C                   MOVE      *OFF          *IN65                                         CGL01
     C     P@RTCD        IFEQ      *BLANKS                                                     CGL01
     C                   MOVE      *ON           *IN65                                         CGL01
     C                   ENDIF                                                                 CGL01
      *                                                                                       CGL037
      ** Access SAR details file to determine if Account Access                               CGL037
      ** Security is switched on                                                              CGL037
      *                                                                                       CGL037
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGL037'      PSARD
     C     DSSARD        PARM      DSSARD        DSFDY
      *                                                                                       CGL037
     C                   MOVE      'N'           CGL037            1
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGL037
     C                   ELSE
     C     PRTCD         IFNE      '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVE      'CGL037'      DBKEY
     C                   Z-ADD     10            DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CGL037
     C/COPY WNCPYSRC,SD0031RC27
      *                                                                                       CER001
      ** Determine if ULX004 is installed                                                     CER001
      *                                                                                       CER001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*VERIFY'     P@OPTN
     C                   PARM      'ULX004'      P@SARD
     C     DSSARD        PARM      *BLANKS       DSFDY
      *                                                                                       CER001
     C     P@RTCD        IFEQ      *BLANK
     C                   MOVE      'Y'           ULX004            1
     C                   ELSE
     C                   MOVE      'N'           ULX004
     C                   ENDIF
      *                                                                                       CER001
     C     P@RTCD        IFNE      *BLANKS
     C     P@RTCD        ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   Z-ADD     011           DBASE
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'ULX004'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CER001
      ** Determine if ULX043 is installed                                                     CER001
      *                                                                                       CER001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*VERIFY'     P@OPTN
     C                   PARM      'ULX043'      P@SARD
     C     DSSARD        PARM      *BLANKS       DSFDY
      *                                                                                       CER001
     C     P@RTCD        IFEQ      *BLANK
     C                   MOVE      'Y'           ULX043            1
     C                   ELSE
     C                   MOVE      'N'           ULX043
     C                   ENDIF
      *                                                                                       CER001
     C     P@RTCD        IFNE      *BLANKS
     C     P@RTCD        ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   Z-ADD     012           DBASE
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'ULX043'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CER001
      ** Determine if ULX053 is installed                                                     CER001
      *                                                                                       CER001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*VERIFY'     P@OPTN
     C                   PARM      'ULX053'      P@SARD
     C     DSSARD        PARM      *BLANKS       DSFDY
      *                                                                                       CER001
     C     P@RTCD        IFEQ      *BLANK
     C                   MOVE      'Y'           ULX053            1
     C                   ELSE
     C                   MOVE      'N'           ULX053
     C                   ENDIF
      *                                                                                       CER001
     C     P@RTCD        IFNE      *BLANKS
     C     P@RTCD        ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   Z-ADD     013           DBASE
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'ULX053'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CER001
     C                   MOVE      WP0002        ACTION
      *                                                                                       CER001
      ** Access SAR details to see if CRE015 is switched on                                   CRE015
      *                                                                                       CRE015
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*VERIFY'     P@OPTN
     C                   PARM      'CRE015'      P@SARD
     C     DSSARD        PARM      *BLANKS       DSFDY
      *                                                                                       CRE015
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CRE015            1
     C                   OPEN      SDACD1L0
     C                   ELSE
     C                   MOVE      'N'           CRE015
     C                   ENDIF
      *                                                                                       CRE015
      ** Access SAR details to see if CGL165 is switched on                                   CGL165
      *                                                                                       CGL165
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*VERIFY'     P@OPTN
     C                   PARM      'CGL165'      P@SARD
     C     DSSARD        PARM      *BLANKS       DSFDY
      *                                                                                       CGL165
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CGL165            1
     C                   MOVE      *ON           *IN93
     C                   ELSE
     C                   MOVE      'N'           CGL165
     C                   ENDIF
     CSR   ZZEXIT        ENDSR
      /EJECT                                                                                  CSD031
      *****************************************************************                       CSD031
      *                                                               *                       CSD031
      * SRACCP - Program to update SDACODL0 from SDAACDL0 file        *                       CSD031
      *                                                               *                       CSD031
      *****************************************************************                       CSD031
     CSR   SRACCP        BEGSR
      *                                                                                       CSD031
     C                   MOVEL     *BLANK        P0RTN
     C     WP0001        CHAIN     SDACODL0                           9591
     C                   Z-ADD     A5SRLC        WSRLC             5 0
     C                   Z-ADD     A5SRFC        WSRFC             5 0
     C                   Z-ADD     A5RPCD        WRPCD            10 0
     C                   MOVEL     A5INNR        WINNR             1
     C                   Z-ADD     A5MISU        WMISU            13 0
     C     WP0001        CHAIN     SDAACDL0                           90
      *                                                                                       CSD031
      ** Error on record retrieval                                                            CSD031
      *                                                                                       CSD031
     C     *IN91         IFEQ      '1'
     C                   MOVEL     'Y2U0004'     P0RTN
     C                   GOTO      SRAERR
     C                   ENDIF
      *                                                                                       CSD031
      ** If record does not exist, database error                                             CSD031
      *                                                                                       CSD031
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'SDAACDL0'    DBFILE
     C                   MOVEL     WP0001        DBKEY
     C                   Z-ADD     11            DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSD031
     C     P2ANCD        IFEQ      'D'
     C                   DELETE    SDACDD0R
     C                   GOTO      DBSTS
     C                   ENDIF
      *                                                                                       CSD031
     C     P2ANCD        IFEQ      'X'
      *                                                                                       CSD031
     C                   SELECT
     C     A5TYLC        WHENEQ    'D'
      *                                                                                       CSD031
      ** Delete records if acceptance data requires deletion                                  CSD031
      *                                                                                       CSD031
     C                   EXSR      DLTFAC
     C     P0RTN         IFNE      *BLANKS
     C     P0RTN         ANDNE     'Y2U0009'
     C                   GOTO      DBSTS
     C                   ELSE
     C                   MOVE      *OFF          *IN90
     C                   MOVE      *BLANKS       P0RTN
     C                   ENDIF
      *                                                                                       CSD031
      ** Delete record from SDAACDL0                                                          CSD031
      *                                                                                       CSD031
     C                   DELETE    SDACDD0R                             91
      *                                                                                       CSD031
     C                   OTHER
     C                   Z-ADD     WURDNB        A5EACC
      *                                                                                       CSD031
      ** If record exist, update details to SDACODL0                                          CSD031
      *                                                                                       CSD031
     C     *IN95         IFEQ      '0'
      *                                                                                       CSD031
     C                   Z-ADD     WSRLC         A5SRLC
     C                   Z-ADD     WSRFC         A5SRFC
     C                   Z-ADD     WRPCD         A5RPCD
     C                   MOVEL     WINNR         A5INNR
     C                   Z-ADD     WMISU         A5MISU
     C                   UPDATE    @A5UPA7                              91
      *                                                                                       CSD031
     C     *IN91         IFEQ      '1'
     C                   MOVEL     'Y2U0004'     P0RTN
     C                   GOTO      DBSTS
     C                   ENDIF
      *                                                                                       CSD031
      ** Update trailer file                                                                  CSD031
      *                                                                                       CSD031
     C                   Z-ADD     *ZERO         WUNORC
     C                   Z-ADD     *ZERO         WUNOIN
     C                   Z-ADD     1             WUNOAM
     C                   Z-ADD     *ZERO         WUNODL
     C                   EXSR      SZCHRC
      *                                                                                       CSD031
     C                   DELETE    SDACDD0R                             91
      *                                                                                       CSD031
      ** If record does not exist, write details to SDACODL0                                  CSD031
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
      ** Check for duplicate primary key                                                      CSD031
      *                                                                                       CSD031
     C                   MOVEL     WP0001        A5ACCD
     C     KLCRSP        SETLL     @A5UPA7                                90
     C     *IN90         IFEQ      '1'
     C                   Z-ADD     WSRLC         A5SRLC
     C                   Z-ADD     WSRFC         A5SRFC
     C                   Z-ADD     WRPCD         A5RPCD
     C                   MOVEL     WINNR         A5INNR
     C                   Z-ADD     WMISU         A5MISU
     C                   UPDATE    @A5UPA7                              91
      *                                                                                       CSD031
     C     *IN91         IFEQ      '1'
     C                   MOVEL     'Y2U0004'     P0RTN
     C                   GOTO      DBSTS
     C                   ENDIF
      *                                                                                       CSD031
      ** Update trailer file                                                                  CSD031
      *                                                                                       CSD031
     C                   Z-ADD     *ZERO         WUNORC
     C                   Z-ADD     *ZERO         WUNOIN
     C                   Z-ADD     1             WUNOAM
     C                   Z-ADD     *ZERO         WUNODL
     C                   EXSR      SZCHRC
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
     C                   WRITE     @A5UPA7                              91
      *                                                                                       CSD031
     C     *IN91         IFEQ      '1'
     C                   MOVEL     'Y2U0004'     P0RTN
     C                   GOTO      DBSTS
     C                   ENDIF
      *                                                                                       CSD031
      ** Update trailer file                                                                  CSD031
      *                                                                                       CSD031
     C                   Z-ADD     1             WUNORC
     C                   Z-ADD     1             WUNOIN
     C                   Z-ADD     *ZERO         WUNOAM
     C                   Z-ADD     *ZERO         WUNODL
     C                   EXSR      SQCHRC
      *                                                                                       CSD031
      ** Create accounts by report - Accounts by Report Codes                                 CSD031
      *                                                                                       CSD031
     C     A5TOIN        IFEQ      *BLANK
     C     A5TOIN        OREQ      'N'
     C                   EXSR      SRCRRC
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                       CSD031
      ** Delete record from SDAACDL0                                                          CSD031
      *                                                                                       CSD031
     C                   DELETE    SDACDD0R                             91
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDSL
     C                   ENDIF
      *                                                                                       CSD031
     C     DBSTS         TAG
     C     *IN91         IFEQ      *ON
     C                   ROLBK
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
      *                                                                                       CSD031
     C     SRAERR        TAG
     C                   EXSR      ZXEXPG
      *                                                                                       CSD031
      *================================================================                       CSD031
     CSR   SRAEXT        ENDSR
      /EJECT                                                                                  CSD031
     CSR   DLTFAC        BEGSR
      *================================================================                       CSD031
      * Delete Account Codes as specified in the                                              CSD031
      * Acceptance record                                                                     CSD031
      *================================================================                       CSD031
      *                                                                                       CSD031
      ** Account code cannot be deleted (UDC holds Account code data)                         CSD031
      ** A/C code cannot be deletd is cannot be deleted                                       CSD031
      *                                                                                       CSD031
     C     WUACDL        IFEQ      'N'
      *                                                                                       CSD031
      ** Send message 'UDC holds A/C data'                                                    CSD031
      *                                                                                       CSD031
     C                   MOVEL     'USR2616'     P0RTN
     C                   GOTO      DLTEXT
     C                   ENDIF
      *                                                                                       CSD031
      ** Check if there are existing future valued transitory postings                        CSD031
      *                                                                                       CSD031
     C                   MOVEL     WP0001        KACCD
     C     KACCD         CHAIN     GLVALPL3                           70
     C     *IN70         IFEQ      *OFF
     C                   MOVEL     'USR8659'     P0RTN
     C                   GOTO      DLTEXT
     C                   ENDIF
      *                                                                                       CSD031
     C     WP0001        CHAIN     @A5UPA7                            9091
     C     *IN90         IFEQ      '1'
      *                                                                                       CSD031
      ** Send message '*Record no longer on file'                                             CSD031
      *                                                                                       CSD031
     C                   MOVEL     'Y2U0009'     P0RTN
     C                   GOTO      DLTEXT
     C                   ENDIF
      *                                                                                       CSD031
     C     *IN91         IFEQ      '1'
      *                                                                                       CSD031
      ** Send message '*Database operation error'                                             CSD031
      *                                                                                       CSD031
     C                   MOVEL     'Y2U0004'     P0RTN
     C                   GOTO      DLTEXT
     C                   ENDIF
      *                                                                                       CSD031
     C                   DELETE    @A5UPA7                              91
     C     *IN91         IFEQ      '1'
     C                   MOVEL     'Y2U0004'     P0RTN
     C                   ELSE
     C                   MOVEL     @1DBRC        WUDELR
      *                                                                                       CSD031
      ** Write Deleted Record - SD Deleted Records File                                       CSD031
      *                                                                                       CSD031
     C                   CLEAR                   PARC
     C                   MOVEL     'SDACODPD'    PAFNME
     C                   MOVEL     #1ACCD        PALKEY
     C                   MOVEL     WUDR01        PADR01
     C                   MOVEL     WUDR02        PADR02
     C                   MOVEL     WUDR03        PADR03
     C                   MOVEL     WUDR04        PADR04
     C                   MOVEL     WUDR05        PADR05
     C                   MOVEL     WUDR06        PADR06
     C                   MOVEL     WUDR07        PADR07
     C                   MOVEL     WUDR08        PADR08
     C                   MOVEL     WUDR09        PADR09
     C                   MOVEL     WUDR00        PADR00
     C                   MOVEL     WUDR11        PADR11
     C                   MOVEL     WUDR12        PADR12
     C                   Z-ADD     WURDNB        PALCD
     C                   MOVEL     'D'           PATYLC
      *                                                                                       CSD031
     C                   CALL      'SD0520X'                            90
     C                   PARM      *BLANK        W0RTN
     C                   PARM                    PARC
      *                                                                                       CSD031
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'Y2U0032'     P0RTN
     C                   ENDIF
      *                                                                                       CSD031
     C                   Z-ADD     -1            WUNORC
     C                   Z-ADD     *ZERO         WUNOIN
     C                   Z-ADD     *ZERO         WUNOAM
     C                   Z-ADD     1             WUNODL
      *                                                                                       CSD031
     C                   EXSR      SUCHRC
     C                   MOVEL     #1ACCD        TDACCD           10
     C                   EXSR      SVRVGN
     C                   MOVEL     TDACCD        #1ACCD
      *                                                                                       CSD031
     C                   ENDIF
      *================================================================                       CSD031
     CSR   DLTEXT        ENDSR
      /EJECT                                                                                  CSD031
      *================================================================                       CSD031
      *                                                                                       CER001
      /EJECT                                                                                  CER001
      *----------------------------------------------------------------                       CER001
      * SRLX04 - Display LUX Account Codes 1                                                  CER001
      *----------------------------------------------------------------                       CER001
     C     SRLX04        BEGSR
     C     ULX004        IFEQ      'Y'
     C                   CALL      'SD0037'
     C                   PARM                    RTCODE            1
     C                   PARM                    ACTION            1
     C                   PARM                    DATALX
     C                   PARM                    W0RTN
     C                   ENDIF
     C                   ENDSR
      *                                                                                       CER001
      /EJECT                                                                                  CER001
      *----------------------------------------------------------------                       CER001
      * SRLX43 - Display LUX Account Codes 2                                                  CER001
      *----------------------------------------------------------------                       CER001
     C     SRLX43        BEGSR
     C     ULX043        IFEQ      'Y'
     C                   CALL      'SD0040'
     C                   PARM                    RTCODE
     C                   PARM                    ACTION
     C                   PARM                    DATALX
     C                   PARM                    W0RTN
     C                   ENDIF
     C                   ENDSR
      /EJECT                                                                                  CER001
      *----------------------------------------------------------------                       CER001
      * SRLX52 - Midas IBAN related character                                                 CER001
      *----------------------------------------------------------------                       CER001
     C     SRLX52        BEGSR
     C     ULX053        IFEQ      'Y'
     C                   CALL      'SD0039'
     C                   PARM                    RTCODE
     C                   PARM                    ACTION
     C                   PARM                    DATALX
     C                   PARM                    W0RTN
     C                   ENDIF
     C                   ENDSR
      /EJECT
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
     C/COPY WNCPYSRC,SD0031RPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0031RPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*SDCPYSRC,SDPSSRINT                                                              MD058085
     C/COPY SDCPYSRC,SDPSSRINTI                                                             MD058085
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0031RPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
     O/COPY WNCPYSRC,SD0031ROPG
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA OVRC
OVRDBF FILE(GPACDXL0) TOFILE(GPACODXL0)                                                       CGP001
OVRDBF FILE(GPPRDXL0) TOFILE(GPPRODXL0)                                                      BUG2312
OVRDBF FILE(GPINSXL0) TOFILE(GPINSTXL0)                                                      BUG2312
