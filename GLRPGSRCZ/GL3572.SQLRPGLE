     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056557
/*STD *  RPGSQLBND                                                    *                     MD056557
/*EXI *  TEXT('Midas GL Account master details report')               *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  GL3572 - ACCOUNT MASTER DETAILS REPORT                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056557           Date 31Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD039072           Date 25Jul16               *
      *                 MD034725           Date 27Jul16               *
      *                 MD031966           Date 27Jul15               *
      *                 LLN022A            Date 03Jun15               *
      *                 CRE101             Date 02Sep14               *
      *                 CRE095             Date 25Apr14               *
      *                 CGL165             Date 17Feb15               *
      *                 MD027647           Date 20Jun14               *
      *                 CRE090             Date 14Feb14               *
      *                 AR1095876          Date 30Sep13               *
      *                 AR936766A          Date 27Mar12               *
      *                 CRE073             Date 06Dec10               *
      *                 AR762809           Date 26May11               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CRE015             Date 18Dec09               *
      *                 CAP205             Date 19Feb10               *
      *                 BUG26720           Date 09Nov09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG18520           Date 06May08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244099             Date 19Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 BUG8210            Date 02Sep05               *
      *                 CSW037A            Date 02May05               *
      *                 LLN022             Date 24Jan05               *
      *                 CSD023             Date 18Nov04               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL018             Date 30Sep02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 21Dec99               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 174063             Date 29Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035             Date 11Nov99               *
      *                 CPB001             DATE 18Aug99               *
      *                 170996             Date 18Nov99               *
      *                 CFT004             Date 19Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSD005             DATE 15MAR99               *
      *                 S01408             DATE 28Jan99               *
      *                 CEU013             DATE 08APR98               *
      *                 CTI001             DATE 30SEP97               *
      *                 CGL004             DATE 28OCT97               *
      *                 CRE001             Date 20Feb97               *
      *                 S01408             DATE 21FEB96               *
      *                 092519             DATE 24AUG95               *
      *                 S01408             DATE 05SEP95               *
      *                 S01408             DATE 25MAY95               *
      *                 084517             DATE 18APR95               *
      *                 084499             DATE 18APR95               *
      *                 S01408             DATE 11APR95               *
      *                 S01486             DATE 07NOV94               *
      *                 076546             DATE 30SEP94               *
      *                 S01408             DATE 22AUG94               *
      *                 S01413 *CREATE     DATE 13APR93               *
      *                 xnnnnn             DATE nnxxxnn               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD056557 - Deliverable Data Split for Pulldown               *
      *  CER050 - Annualised Percentage Rate                          *
      *  MD046248 - Finastra Rebranding                               *
      *  MD039072 - GL3572AU is empty and no GL03572P1 report when    *
      *             called from GLC3571. Print only inserted, closed  *
      *             and amended on rundate if called from GLC3571.    *
      *  MD034725 - Single CCY + Branch available in BFM and TI Plus  *
      *  MD031966 - GL3572P1 does not produce expected accounts       *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  CRE101 - Interim Interest Statemetns on a Frequency          *
      *           Addition of hook CRE101_069                         *
      *           Addition of hook CRE101_070                         *
      *           Addition of hook CRE101_071                         *
      *  CRE095 - Rate fixing for RE Accounts                         *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  MD027647 - Delay cap days reported is incorrect.             *
      *  CRE090 - Delay Capitalisation of Interest                    *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877) (Recompile)               *
      *  AR936766A - Overlapping of Effective Date and Portfolio      *
      *              Reference field in GL3572P1 report (Reopen)      *
      *              (Recompile)                                      *
      *  CRE073 - Interest Rate Rounding                              *
      *  AR762809 - Effective Date incorrect in the report            *
      *  CRE075 - Effective Date for Retail Accounts                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CRE015 - Retail Term and Notice Accounts                     *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *  BUG26720 - COB error on GLC3571 00001                        *
      *  BUG18520 - Do not chain to ACCNTBXC if account is closed     *
      *  244099 - Report problem. Alternative A/C To Post Interest,   *
      *           blank on CREDIT side.                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  BUG8210 - GLC3571 failed due to DBERR in ACCNTBXC (empty)    *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *  CSD023 - Automatic Customer Account Closure                  *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines                                        *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL018 - Risk Weighted Assets.                               *
      *  208221 - Default Margin from Rate/Spread changes             *
      *  CDE002 - Revenue Analysis - New fields added to report.      *
      *  174063 - Data structure added for field ATCHAM in order for  *
      *           the correct number of decimal places to be applied  *
      *           to the field depending on currency.                 *
      *  CAP035 - Account maintenance API; recompiled over changed    *
      *           ACCBR.                                              *
      *  CPB001 - 'Private Banking' Module                            *
     F*  170996 - Overflow problems when printing retail accounts     *
      *  CFT004 - Straight Through Processing Phase 2                 *
      *           International Bank Account Numbers (IBAN)           *
      *  CSD005 - Switchable feature- if account narrative feature    *  *
      *           is active the current account description shall be  *  *
      *           replaced with the account narrative. Unless the Mida*  *
      *           retail module is present then it willnot be replaced*  *
     F*  S01408 - Correction of blank hook names:                     *
     F*         - Addition of core hook GL3572FTC1                    *
     F*         - Addition of core hook GL3572CTC1                    *
      *  CEU013 - EMU Account Postings Narrative                      *
      *  CTI001 - Midas / Trade Innovation Interface Phase 1          *
      *  CGL004 - Addition of Midas-Fontis Interface Account Details  *
      *  CRE001 - Overdraft Interest Calculation:                     *
      *           Read and output to report the related additional    *
      *           overdraft rate and overdraft line fields.  Also     *
      *           applied fix 109011 to move the read of SDMMODPD.    *
      *  S01408 - Core hook GL3572CCP6 added.                         *
      *  092519 - Print out portfolio reference correctly             *
      *  S01408 - Core hook GL3572CCP3 added.                         *
      *           Core hook GL3572CCP4 added.                         *
      *           Core hook GL3572CCP5 added.                         *
      *  S01408 - Core hook GL3572IIPG added.                         *
      *           Core hook GL3572EEPG added.                         *
      *           Core hook GL3572CCP1 added.                         *
      *           Core hook GL3572CCP2 added.                         *
      *           Core hook GL3572CPD1 added.                         *
      *           Core hook GL3572CLH2 added.                         *
      *  084499 - Read TABTBRE only if retail exists.                 *
      *  084517 - Initialise output file GL3572AU fields if primary   *
      *           file SADET empty.                                   *
      *  S01408 - Core hook GL3572CLH1 added.                         *
      *           Core hook GL3572CPLH added.                         *
      *  S01486 - Portfolio Management Upgrade to Release 10.         *
      *  076546 - Report profit centre                                *
      *  S01408 - Core hook GL3572FFPG added.                         *
      *           Core hook GL3572CPDR added.                         *
      *           Core hook GL3572CCPG added.                         *
      *  S01413 - Retail 3 Incorporation                              *
      *                                                               *
     F*****************************************************************
     F***SADET***IP**F     424 18AI     2 DISK                            S01486
     F***SADET***IP**F     429 18AI     2 DISK                      S01486092519
     F***SADET   IP  F     437 18AI     2 DISK                      092519CTI001
     F***SADET***IP**F  447 18AI     2 DISK                         CTI001CEU013
     F***SADET***IP  F     448 18AI     2 DISK                     CEU013 CFT004
     F***SADET***IP  F     485 18AI     2 DISK                     CFT004 CAP035
     F***SADET***IP  F     552 18AI     2 DISK                                         CAP035 CGL029
     F***SADET** IP  F     573 18AI     2 DISK                                         CGL029 CLE025
     F***SADET** IP  F     607 18AI     2 DISK                                         CLE025 CER047
     F***SADET** IP  F     648 18AI     2 DISK                                         CER047 CRE075
     F***SADET** IP  F     651 18AI     2 DISK                                         CRE075 CRE073
     FSADET     IP   F  687    18AIDISK    KEYLOC(2)
     FSDCURRL0  IF   E           K DISK
     F/COPY WNCPYSRC,GL3572F001
     F***REIAC** IF  F     143 18AI     2 DISK                                                CGL029
     FREIAC     IF   F  218    24AIDISK    KEYLOC(2)
     F***REACR** IF  F     172 18AI     2 DISK                                                CGL029
     FREACR     IF   F  191    24AIDISK    KEYLOC(2)
     FACCNTBXC  IF   E           K DISK
     F/COPY WNCPYSRC,GL3572FTC1                                           S01408
     FGLFONAL0  IF   E           K DISK                                         CGL004
     F*                                                                   S01408
     F/COPY WNCPYSRC,GL3572FFPG                                           S01408
      *                                                                                      LLN022A
     FBYACCTY0  IF   E           K DISK                                                            L
      ** Account Details Extention File - retrieval                                          LLN022A
      *                                                                                      LLN022A
     FREACX1PD  IF   E           K DISK
     F*                                                                   S01408
     FRECCY     IF   E           K DISK                                         CDE002
      *                                                                   CDE002
      *-------------------------------------------------------------------
     FTABTBRE   IF   E             DISK
      *                                Retail ICD
     FRECOM     IF   E           K DISK
      *                                Retail commission
     F*SDMMODPDIF E                    DISK
      *                                Modules
     FGLARWAL0  IF   E           K DISK
      * RTW: Account Risk Weigted Assets Code/Set                                             CGL018
      *                                                                                       CGL018
     FGLACNTL3  IF   E           K DISK
      ** RTV: Midas GL Account Extension File                                                 CAP205
      *                                                                                       CAP205
     FREPRPNL2  IF   E           K DISK
      ** Midas RE T&N Accounts - Periods and Penalties                                        CRE015
     F/COPY OFCPYSRCZ,CRE101_069                                                              CRE101
     FGL3572AU  O    E             PRINTER INFDS(SPOOLU)
      *                                Audit report
     FGL3572P1  O    E             PRINTER INFDS(SPOOL)
     F                                     USROPN
      *                                Account details report
     FREAPRHI0  IF   E           K DISK
     FREAPRHI1  IF   E           K DISK
     F                                     RENAME(REAPRHD0:REAPRHD1)
     F/COPY WNCPYSRC,GL3572F002
     F*****************************************************************
     F*
     F*  F U N C T I O N   O F   I N D I C A T O R S
     F*
     F*       01      ACCOUNT MASTER DETAIL.
     F*       02      ACCOUNT MASTER TRAILER RECORD.
     F*       03      ACCOUNT MASTER CATCHALL.
     F*       04      ACCOUNT MASTER CLOSED ACCOUNT
     F*       06      REIAC - LIVE DETAIL OR CLOSED DETAIL RECORD
     F*       07      REACR - LIVE DETAIL OR CLOSED DETAIL RECORD
     F*
     F*       17      PRINT EFFECTIVE DATE                                                    CRE075
     F*       18      CHAIN TO GL ACCOUNT EXTENSION FILE                                      CAP205
     F*       19      RETAIL ACCOUNT NO. PRESENT
     F*       20      ACCOUNT NUMBER IS 0.
     F*       21      PRINT DETAIL
     F*       22      ACCNT CONTROLS DISAGREE - NO. OF A/CS OPENED
     F*       23                              - NO. OF A/CS AMENDED
     F*       24                              - NO. OF A/CS CLOSED
     F*       25                              - NO. OF CLOSE TRAN.FAILURES
     F*       26                              - NO. OF A/CS REOPENED
     F*-------------------------------------------------------------------
     F*       28      WITHHOLDING TAX MODULE IS NOT PRESENT
     F*       29      Portfolio module on, print portfolio reference      S01486
     F*       30      = U3, for external O specs
     F*       31      = U1, for external O specs
     F*-------------------------------------------------------------------
     F*       32      CLOSED DATE IS 0.
     F*       33      OVERDRAFT SECURED
     F*       34      PRINT BRT CATEGORY
     F*       35      Overdraft Interest Calculation Feature Indicator    CRE001
     F*       36      FONTIS ACCOUNT DETAILS PRESENT                      CGL004
     F*
     F*       37      Account Narrative switchable feature                CSD005
      *       38      Rvenue Analysis switchable feature (CDE002)         CDE002
     F*       39      MICROFICHE FREQUENCY BLANK
     F*       40      NON-FIRST CYCLE.
     F*       41      CGL018 IS ON                                                            CGL018
     F*       42      REFER ALL DEBITS - YES.
     F*       43      REFER CREDIT - YES.
     F*       44      BLOCK ALL DEBITS - YES.
     F*       45      PRINT ADDRESS - YES.
     F*       46      BLOCK ALL CREDITS - YES.
     F*       47      INACTIVE - YES.
     F*       48      PRINT TRANSACTION ADVICE - YES.
     F*       49      PRINT RATE CHANGE ADVICE - YES.
     F*       50      CHANGE IN ACCOUNT CURRENCY CODE.
     F*       51      SPREAD +VE (DEBIT)
     F*       52      ADDITIONAL OVERDRAFT RATE -VE                       CRE001
     F*       53      SPREAD +VE (CREDIT)
     F*       54      ADDITIONAL OVERDRAFT RATE +VE                       CRE001
     F*       55      MAN. ADJ. +VE (DEBIT)
     F*       56      PROCESSING ACCOUNTS AFTER UPDATE FIELD NULL
     F*       57      MAN. ADJ. +VE (CREDIT)
     F*       58      MAN. ADJ. = ZERO (CREDIT)
     F*       59      ACCOUNT CLOSED TODAY
     F*       60      DATE COMPARISON
     F*       61      RETAIL A/C NOS SUPPORTED ON ICDR 3
     F*       62      ACCOUNT BALANCE CHECK (CAP205 IS ON)                                    CAP205
     F*       63      LAST CR INC/EXP AMOUNT IS DR
     F*       64      CEU013 ENHANCEMENT SWITCHED ON                      CEU013
     F*       65      DEBIT GENERATED ADJUSTMENTS TO DEBIT INTEREST
     F*       66      CREDTIT GENERATED ADJUSTMENTS TO DEBIT INTEREST
     F*       67      DEBIT GENERATED ADJUSTMENTS TO CREDIT INTEREST
     F*       68      CREDTIT GENERATED ADJUSTMENTS TO CREDIT INTEREST
     F*       69      Midas/TI Interface is on                            CTI001
     F*       70      CURRENCY HAS 0 DECIMAL PLACES.
     F*       71      CURRENCY HAS 1 DECIMAL PLACE.
     F*       72      CURRENCY HAS 2 DECIMAL PLACES.
     F*       73      CURRENCY HAS 3 DECIMAL PLACES.
     F*       74      STATEMENT CHARGES PROCESSED
     F*       75      PRINTER FILE GL0572P1 IS OPEN.
     F*       76      WHEN = 0, FILE OPENED, NO DETAILS TO REPORT.
     F*       77      FIXED ACCOUNT CHARGE PROCESSED
     F*       78      SINGLE BRANCH REQUESTED WHEN MBIN = Y
     F*       79      RECORD OUTPUT AT LEAST ONCE
     F*       80      CHANGE TYPE I - INSERT
     F*       81      CHANGE TYPE A - AMEND.
     F*       82      CHANGE TYPE C - CLOSE.
     F*       83      CHANGE TYPE R - RE-OPEN.
     F*       84      BANKRUPT - YES
     F*       85      BAD DEBT - YES
     F*       86      ACCRUED AMOUNT NEGATIVE
     F*       87      AT LEAST ONE REPORT - NO MORE OPENED
     F*       88      MBIN = Y
     F*       89      NO REPORT PRODUCED
     F*       90-99   USED IN SUBROUTINES.
     F*
     F*          U1   AMENDMENTS RUN.
     F*          U3   INTERIM REPORT.
     F*          U7   DATABASE ERROR
     F*          U8   FILE CONTROLS OUT OF BALANCE
     F*
     F*****************************************************************
     D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)              ZDATE SR. ARRAY
     D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)            ZDATE SR. ARRAY
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)            ZDATE2 SR. ARRAY
     D CCYA            S              3    DIM(150)
     D DPA             S              1  0 DIM(150)
      *-------------------------------------------------------------------
     D ZA1             S              1    DIM(16)                              ZALIGN/ZEDIT AR.
     D ZA2             S              1    DIM(16)                              ZALIGN/ZEDIT AR.
     D XRWA            S              5    DIM(90)                              Work Array
     D**
     D**   DATA STRUCTURE TO CHAIN TO RETAIL FILES
     D**
     D                 DS
     D**********                              1  18 REKEY                                     CGL029
     D  REKEY                  1     24
     D**********                              1   60CNUM                                      CSD027
     D  CNUM                   1      6
     D  CCY                    7      9
     D**********                             10  130ACOD                                      CGL029
     D**********                             14  150ACSQ                                      CGL029
     D**********                             16  18 BRCA                                      CGL029
     D**********                             16  18 BRCA2                                     CGL029
     D  ACOD                  10     19  0
     D  ACSQ                  20     21  0
     D  BRCA                  22     24
     D  BRCA2                 22     24
     D**                                                                  CGL004
     D**   DATA STRUCTURE TO CHAIN TO FONTIS DETAILS                      CGL004
     D**                                                                  CGL004
     D                 DS                                                       CGL004
     D**********                              1  18 KACCNO                             CGL004 CGL029
     D  KACCNO                 1     24
     D  KBRCA                  1      3                                         CGL004
     D**********                              4   90KCNUM                              CGL004 CSD027
     D  KCNUM                  4      9
     D  KCCY                  10     12                                         CGL004
     D**********                             13  160KACOD                              CGL004 CGL029
     D**********                             17  180KACSQ                              CGL004 CGL029
     D  KACOD                 13     22  0
     D  KACSQ                 23     24  0
      *
      ** Data Structure to chain to RE ICD by Ccy Details                 CDE002
      *                                                                   CDE002
     D                 DS                                                       CDE002
     D  KRECCY                 1     12                                         CDE002
     D  K#CCY                  9     11                                         CDE002
     D  K#D                   12     12                                         CDE002
      *                                                                   CDE002
     D*    LOCAL DATA AREA
     D*
     D*  DATA STRUCTURE FOR COMPILATION  - COPYRIGHT INSERTION
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
     D*
     D LDA            UDS           256
     D  LPROC                  1      8
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D**
      *-------------------------------------------------------------------
      * Redefine fields for different edit words or multiple output
      *
     D                 DS
     D  LDBL                   1     15  0
     D  LDBL0                  1     15  0
     D  LDBL1                  1     15  0
     D  LDBL2                  1     15  0
     D  LDBL3                  1     15  0
      *
     D                 DS
     D  CLBL                   1     15  0
     D  CLBL0                  1     15  0
     D  CLBL1                  1     15  0
     D  CLBL2                  1     15  0
     D  CLBL3                  1     15  0
      *
     D                 DS
     D  CFSB                   1     15  0
     D  CFSB0                  1     15  0
     D  CFSB1                  1     15  0
     D  CFSB2                  1     15  0
     D  CFSB3                  1     15  0
      *
     D                 DS
     D  ECFB                   1     15  0
     D  ECFB0                  1     15  0
     D  ECFB1                  1     15  0
     D  ECFB2                  1     15  0
     D  ECFB3                  1     15  0
      *
     D                 DS
     D  DIIE                   1     13  0
     D  DIIE0                  1     13  0
     D  DIIE1                  1     13  0
     D  DIIE2                  1     13  0
     D  DIIE3                  1     13  0
      *
     D                 DS
     D  CIIE                   1     13  0
     D  CIIE0                  1     13  0
     D  CIIE1                  1     13  0
     D  CIIE2                  1     13  0
     D  CIIE3                  1     13  0
      *
     D                 DS
     D  DAIC0                  1     13  0
     D  DAIC00                 1     13  0
     D  DAIC01                 1     13  0
     D  DAIC02                 1     13  0
     D  DAIC03                 1     13  0
      *
     D                 DS
     D  CAIC0                  1     13  0
     D  CAIC00                 1     13  0
     D  CAIC01                 1     13  0
     D  CAIC02                 1     13  0
     D  CAIC03                 1     13  0
      *
     D                 DS
     D  MADI                   1     13  0
     D  MADI0                  1     13  0
     D  MADI1                  1     13  0
     D  MADI2                  1     13  0
     D  MADI3                  1     13  0
      *
     D                 DS
     D  MACI                   1     13  0
     D  MACI0                  1     13  0
     D  MACI1                  1     13  0
     D  MACI2                  1     13  0
     D  MACI3                  1     13  0
      *
     D                 DS
     D  GADI                   1     13  0
     D  GADI0                  1     13  0
     D  GADI1                  1     13  0
     D  GADI2                  1     13  0
     D  GADI3                  1     13  0
      *
     D                 DS
     D  GACI                   1     13  0
     D  GACI0                  1     13  0
     D  GACI1                  1     13  0
     D  GACI2                  1     13  0
     D  GACI3                  1     13  0
      *
     D                 DS
     D  CALC                   1     13  0
     D  CALC0                  1     13  0
     D  CALC1                  1     13  0
     D  CALC2                  1     13  0
     D  CALC3                  1     13  0
      *
     D                 DS
     D  HELDA                  1     14  0
     D  HELDA0                 1     14  0
     D  HELDA1                 1     14  0
     D  HELDA2                 1     14  0
     D  HELDA3                 1     14  0
      *
     D                 DS
     D  NOCL                   1      5  0
     D  NOCL1                  1      5  0
      *
     D                 DS
     D  NOCF                   1      5  0
     D  NOCF1                  1      5  0
      *
     D                 DS
     D  NORD                   1      5  0
     D  NORD1                  1      5  0
      *
     D                 DS
     D  NOOA                   1      5  0
     D  NOOA1                  1      5  0
      *
     D                 DS
     D  NOAU                   1      5  0
     D  NOAU1                  1      5  0
      *
     D                 DS
     D  NAUP                   1      5  0
     D  NAUP1                  1      5  0
      *
     D                 DS
     D  CINUAF                 1      5  0
     D  CINUA1                 1      5  0
     D  CINUA2                 1      5  0
     D  CINUA3                 1      5  0
      *
     D                 DS
     D  COCLAF                 1      5  0
     D  COCLA1                 1      5  0
     D  COCLA2                 1      5  0
     D  COCLA3                 1      5  0
      *
     D                 DS
     D  COCFAF                 1      5  0
     D  COCFA1                 1      5  0
     D  COCFA2                 1      5  0
     D  COCFA3                 1      5  0
      *                                                                   174063
     D**********  DS                                                                 174063 BUG26720
     D**********                              1   70ATCHAM                           174063 BUG26720
     D**********                              1   70ATCHA0                           174063 BUG26720
     D**********                              1   70ATCHA1                           174063 BUG26720
     D**********                              1   70ATCHA2                           174063 BUG26720
     D**********                              1   70ATCHA3                           174063 BUG26720
     D*                                                                                       208221
     D*COPY*ZSRSRC,ZSEDITZ2                                                          208221 MD056557
     D                 DS                                                                   MD056557
     D  WORK15                 1     15  0                                                  MD056557
     D  ZS1X                   1     15  0                                                  MD056557
     D*
     D**   SPOOL FILE INFORMATION DATA STRUCTURE
     D**
     D                 DS
     D  SPLFA                  1     42
     D  SFILP                  1      8
     D  JBNMP                  9     18
     D  USERP                 19     28
     D  JBNOP                 29     34  0
     D  SPLNO                 35     39  0
     D  BRCHP                 40     42
     D**
     D**   PROGRAM STATUS DATA STRUCTURE
     D**
     D PSDS           SDS
     D  #PGM             *PROC
     D  JOBNM                244    253
     D  USRID                254    263
     D  JOBNO                264    269  0
     D**
     D**   FILE INFORMATION DATA STRUCTURE
     D**
     D SPOOLU          DS
     D  SFILEU                83     90
     D  SFNUMU               123    124B 0
     D SPOOL           DS
     D  SFILE                 83     90
     D  SFNUM                123    124B 0
     D  SFLIN                152    153B 0
     D  OFLLN                188    189B 0
     D  PRTLN                367    368B 0
     D/COPY WNCPYSRC,GL3572I002
     D**
     D** DATA AREA RUNDAT
     D**
     D RUNDT           DS
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
     D**
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D**  EXTERNAL DS FOR BANK DETAILS
     D**
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D**  EXTERNAL DS FOR BRANCH CODES
     D**
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  DFACQQ       E                     EXTFLD(QQDFAC)
     D** CLIENT DETAILS
     D**
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
     D** MIDAS MODULE DETAILS
     D**
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D** RETAIL DETAILS
     D**
     D SDPORT        E DS                  EXTNAME(SDPORTPD)                    S01486
      ** Portfolio Management ICD details                                 S01486
     D**                                                                  CEU013
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                    CEU013
     D** CURRENCY DETAILS                                                 CEU013
     D**                                                                  CEU013
     D*                                                                   CSD005
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CSD005
     D** MIDAS Switchable Features Accessed Via Access Program            CSD005
     D*                                                                   CSD005
     D SDACOD        E DS                  EXTNAME(SDACODPD)                    CSD005
     D  ACCDQQ       E                     EXTFLD(QQACCD)
      **  Account code details                                            CSD005
      *                                                                   CSD005
      *                                                                   S01486
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *                                                                   CSD023
     D DSLDY         E DS                  EXTNAME(DSLDY)                       CSD023
      ** Third DS for access programs, very long data structure           CSD023
      *                                                                                       CGL018
      * Datastructure to output RWA details                                                   CGL018
      *                                                                                       CGL018
     D RWSECO          DS             5    OCCURS(1)
     D  #RCODE                 1      2
     D  #BLANK                 3      3    INZ(' ')
     D  #RSET                  4      4
     D  #COMMA                 5      5    INZ(',')
      *                                                                                       CGL018
     D*
     D*                                                                   S01408
     D/COPY WNCPYSRC,GL3572IIPG                                           S01408
     D                 DS
     D  WECOAM                 1     15  0
     D  WECOA0                 1     15  0
     D  WECOA1                 1     15  0
     D  WECOA2                 1     15  0
     D  WECOA3                 1     15  0
      *                                                                                       CER001
      * Data structure for Correction Account                                                 CER001
      *                                                                                       CER001
     D                 DS
     D  WECOAC                 1     21
     D  WWCNUM                 1      6
     D  WWCCY                  7      9
     D  WWACOD                10     19
     D  WWACSQ                20     21
     D                 DS
     D  W#COAC                 1     24
     D  W#CNUM                 1      6
     D  W#HF1                  7      7
     D  W#CCY                  8     10
     D  W#HF2                 11     11
     D  W#ACOD                12     21
     D  W#HF3                 22     22
     D  W#ACSQ                23     24
     D*                                                                   S01408
     D                 DS
     D  C#ACOD                 1     10
     D  N#ACOD                 1     10  0
     I*                                                                                       208221
     I*COPY*ZSRSRC,ZSEDITZ1                                                          208221 MD056557
     D ZS1             S              1  0 DIM(15)                                          MD056557
     D ZS2             S              1    DIM(21)                                          MD056557
     I*                                                                   S01408
     I/COPY WNCPYSRC,GL3572EEPG                                           S01408
     I*                                                                   S01408
      *-------------------------------------------------------------------
     I**
     I*    ACCOUNT MASTER DETAIL RECORD
     I**
     ISADET     NS  01    1 CD
     I         OR   04    1 CC
     I**********                              2   70CNUM                                      CSD027
     I                                  2    7  CNUM
     I                                  8   10  CCY
     I**********                             11  140ACOD                                      CGL029
     I                                 11   14 0ACODQQ
     I                                 15   16 0ACSQ
     I                                 23   25  BRCA          L1
     I                                 26   26  ATYP
     I                                 27   27  STYP
     I                                 28   28  MFFQ                    39
     I                                 29   29  ACST
     I                             P   30   32 0DACO
     I                             P   33   35 0DACC
     I                                 36   55  ANAM
     I                             P   56   63 0LDBL
     I                             P   64   71 0CLBL
     I                                 72   72  STFQ
     I                             P   78   80 0NSTD
     I                             P   81   82 0LSTP
     I                             P   83   90 0CFSB
     I                             P   91   93 0LMVD
     I                                118  118  GLBT
     I                                119  126  ADF1
     I                                127  130  PRFC                            076546
     I                                174  175  ADF2
     I                                190  199 0ACNO
     I                                200  200  RETB
     I                                201  201  ODSC
     I                             P  202  207 0ODLN
     I                             P  208  210 0ODED
     I                             P  211  212 0DIOD
     I                                213  215 0FACT
     I                                216  217 0FCNO
     I                                218  219  EFAC
     I                             P  220  227 0HELD
     I                             P  228  233 0MINB
     I                             P  234  236 0LACD
     I                                242  243 0DRIB
     I                             P  244  249 7DRIS
     I                             P  250  252 0DRCD
     I                                253  253 0DRIC
     I                                254  254  DRIF
     I                                255  256 0DRDY
     I                             P  257  259 0NDID
     I                             P  260  262 0LDID
     I                             P  263  269 0LDIA
     I                             P  271  273 0LPAR
     I                             P  274  280 0DIIE
     I                                318  319 0CRIB
     I                             P  320  325 7CRIS
     I                             P  326  328 0CRCD
     I                                329  329 0CRIC
     I                                330  330  CRIF
     I                                331  332 0CRDY
     I                             P  333  335 0NCID
     I                             P  336  338 0LCID
     I                             P  339  345 0LCIA
     I                             P  347  349 0LPAP
     I                             P  350  356 0CIIE
     I                             P  394  396 0LCD
     I                                397  397  CHTP
     I                             P  398  400 0TNLU
     I                                401  401  BRTCA
     I                             P  404  405 0ENOC
     I                             P  406  407 0EPNO
     I                             P  408  415 0ECFB
     I***********                           425 428 PTFR            S01486092519
     I***********                           429 429 HLEX            S01486092519
     I                                433  436  PTFR                            092519
     I                                437  437  HLEX                            092519
     I                                438  438  A5TIAC                          CTI001
     I                                439  444  A5TIAN                          CTI001
     I                                445  447  A5TIAS                          CTI001
     I                                448  448  EUSB                            CEU013
     I                                449  482  IBAN                            CFT004
     I                                554  563 0ACOD
     I**********                            574 5790FCCU                               CLE025 CSD027
     I                                574  579  FCCU
     I                             P  649  651 0ACEFDT
     I                             P  652  657 7DCSP
     I                                658  658  DCSG
     I                                659  665  DRMT
     I                                666  669  DRFD
     I                             P  670  675 7CCSP
     I                                676  676  CCSG
     I                                677  683  CRMT
     I                                684  687  CRFD
     I/COPY WNCPYSRC,GL3572I003
     I**
     I**
     I*    ACCOUNT MASTER TRAILER RECORD
     I**
     I          NS  02    1 CT
     I                                  1    1  RECI
     I                             P   23   25 0NORE
     I                             P   29   31 0NOOA
     I                             P   32   34 0NINU
     I                             P   35   37 0NOAM
     I                             P   38   40 0NOCL
     I                             P   41   43 0NOAU
     I                             P   44   46 0NINP
     I                             P   47   49 0NORD
     I                             P   50   52 0NOCF
     I                             P   53   55 0NAMP
     I                             P   56   58 0NAUP
     I**
     I*    CATCHALL FOR DELETED RECORDS
     I**
     I          NS  03
     I                                  1    1  RECI
     I**
     I*    RETAIL INTEREST AND CHARGES FILE
     I**
     IREIAC     NS  06    1 CD
     I         OR         1 CC
     I                                 17   18 0DICT
     I                                 19   23 0DCST
     I**********                             24  38 DACP                                      CGL029
     I                                 24   38  DACPQQ
     I                                 39   40 0DICP
     I                                 41   42 0CICT
     I                                 43   47 0CCST
     I**********                             48  62 CACP                                      CGL029
     I                                 48   62  CACPQQ
     I                                 63   64 0CICP
     I                                 65   66 0CHCT
     I                                 67   71 0CHST
     I**********                             72  86 CHAC                                      CGL029
     I                                 72   86  CHACQQ
     I                                 87   87  PTRA
     I                                 88   88  PRCA
     I                             P   89   95 0NRCA
     I                             P   96  102 0RECA
     I                             P  103  110 0MCBC
     I                             P  131  134 0TCHO
     I                                135  137  CRBR
     I                                138  140  DRBR
     I                                141  143  CHBR
     I                                156  176  DACP
     I                                177  197  CACP
     I**********                            198 218 CACP                               CGL029 244099
     I                                198  218  CHAC
     I**
     I*    CATCHALL FOR DELETED RECORDS
     I**
     I          NS
     I**
     I*    RETAIL ACCRUED INTEREST TO DATE RECORD
     I**
     IREACR     NS  07    1 CD
     I         OR         1 CC
     I                             P   41   47 0DAIC
     I                             P   48   54 0MADI
     I                             P   55   61 0GADI
     I                             P   62   68 0CAIC
     I                             P   69   75 0MACI
     I                             P   76   82 0GACI
     I**
     I*    CATCHALL FOR DELETED RECORDS
     I**
     I          NS
     I**
     I/COPY WNCPYSRC,GL3572I001
     C/EJECT
      *-------------------------------------------------------------------
     C     *ENTRY        PLIST
     C                   PARM                    SEQ               5             SEQUENCE NUM.
     C                   PARM                    BRNCH             3             BRANCH OR ALL
     C*    DEFINE LDA
     C     *DTAARA       DEFINE                  LDA
     C*
      ** Check if Switchable Feature ULX004 is installed                                      CER001
      *                                                                                       CER001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'ULX004'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                       CER001
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           ULX004            1
     C                   ELSE
     C                   MOVE      'N'           ULX004
     C                   ENDIF
      *                                                                                       CER001
     C     PRTCD         IFNE      *BLANK
     C     PRTCD         ANDNE     '*NRF   '
     C                   SETON                                        U7U8LR
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     PRTCD         DBKEY
     C                   MOVE      '029'         DBASE
     C                   EXSR      *PSSR
     C                   GOTO      END
     C                   END
      *                                                                                       CER001
      ** Check if Switchable Feature CAP205 is installed.                                     CAP205
      *                                                                                       CAP205
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CAP205'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                       CAP205
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAP205            1
     C                   ELSE
     C                   MOVE      'N'           CAP205
     C                   ENDIF
      *                                                                                       CAP205
     C     PRTCD         IFNE      *BLANK
     C     PRTCD         ANDNE     '*NRF   '
     C                   SETON                                        U7U8LR
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     PRTCD         DBKEY
     C                   MOVE      '062'         DBASE
     C                   EXSR      *PSSR
     C                   GOTO      END
     C                   END
      *                                                                                       CAP205
      ** Check if Switchable Feature CER050 is installed                                      CER050
      *                                                                                       CER050
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CER050'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                       CER050
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CER050            1
     C                   ELSE
     C                   MOVE      'N'           CER050
     C                   ENDIF
      *                                                                                       CER050
     C*    PERFORM FIRST CYCLE OPERATIONS.
     C   40              GOTO      START
     C                   MOVEA     CPY@          BIS@             80
     C*
     C     *DTAARA       DEFINE    RUNDAT        RUNDT
     C                   IN        RUNDT
     C*
     C                   SETOFF                                       89
     C     MBIN          IFEQ      'Y'
     C                   SETON                                        88
     C                   END
     C                   MOVE      ' '           BLK256          256
     C                   MOVE      BLK256        DBKEY
     C*
     C     *INU1         IFEQ      '1'
     C                   MOVE      'GLC3571 '    LPROC
     C                   END
     C*
     C     *INU3         IFEQ      '1'
     C                   MOVE      'GLC3572 '    LPROC
     C                   END
     C*
     C                   MOVEL     ' GL3572 '    DBPGM
     C                   SETON                                        40
     C**
     C*-------------------------------------------------------------------
     C*
     C                   MOVE      '0'           *IN98
     C*
     C                   Z-ADD     RUND          ZDAYNO
     C                   EXSR      ZDATE2
     C                   Z-ADD     ZDATE         RUNN              7 0
     C*
     C* Use *IN30/31 instead of *INU3/U1 for external descriptions
     C*
     C                   MOVE      *INU3         *IN30
     C                   MOVE      *INU1         *IN31
      *                                                                   CRE001
      ** Access Midas Modules Details                                     CRE001
      *                                                                   CRE001
     C                   CALL      'AOMMODR0'                                                  CRE00
     C                   PARM      '*MSG   '     @RTCD                                         CRE00
     C                   PARM      '*FIRST '     @OPTN                                         CRE00
     C     SDMMOD        PARM      SDMMOD        DSFDY                                         CRE00
      *                                                                   CRE001
     C     @RTCD         IFNE      *BLANK                                                      CRE00
     C                   SETON                                        U7U8LR                   CRE00
     C                   MOVEL     'SDMMODPD'    DBFILE                                        CRE00
     C                   MOVEL     @OPTN         DBKEY                                         CRE00
     C                   MOVEL     @OPTN         DBOPTN                                        CRE00
     C                   MOVEL     '002'         DBASE                                         CRE00
     C                   EXSR      *PSSR                                                       CRE00
     C                   GOTO      END                                                         CRE00
     C                   ENDIF                                                                 CRE00
     C*
      *                                                                   CSD005
      *** Obtain switchable feature CSD005 status.                        CSD005
      *                                                                   CSD005
     C                   CALL      'AOSARDR0'                                                  CSD00
     C                   PARM      *BLANKS       @RTCD             7                           CSD00
     C                   PARM      '*VERIFY'     @OPTN             7                           CSD00
     C                   PARM      'CSD005'      @SARD             6                           CSD00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CSD00
      *                                                                   CSD005
     C                   SELECT                                                                CSD00
     C     @RTCD         WHENEQ    *BLANK                                                      CSD00
     C                   MOVE      *ON           *IN37                                         CSD00
     C     @RTCD         WHENEQ    '*NRF'                                                      CSD00
     C                   MOVE      *OFF          *IN37                                         CSD00
     C                   OTHER                                                                 CSD00
     C     *LOCK         IN        LDA                                                         CSD00
     C                   MOVEL     'SCSARDPD'    DBFILE                          ************* CSD00
     C                   MOVEL     '015'         DBASE                           *DBERROR 015* CSD00
     C                   MOVEL     @OPTN         DBKEY                           ************* CSD00
     C                   SETON                                        U7U8LR                   CSD00
     C                   OUT       LDA                                                         CSD00
     C                   EXSR      *PSSR                                                       CSD00
     C                   ENDSL                                                                 CSD00
     C/COPY WNCPYSRC,GL3572C028
      *                                                                   CSD005
     C* Get ICD55/Retail record
     C*
     C     BGRTBN        IFEQ      'Y'                                                         08449
     C     BGIOAC        OREQ      'Y'                                                         08449
     C     1             SETLL     TABTBRE
     C                   READ      TABTBRE                                99
     C     *IN99         IFEQ      '1'
     C                   SETON                                        U7LR      ** DB ERROR 95
     C                   MOVE      'TABLE'       DBFILE
     C                   MOVEL     *BLANKS       DBKEY
     C                   Z-ADD     95            DBASE
     C                   GOTO      END
     C                   END
     C                   END                                                                   08449
     C*
     C***********STMC      IFEQ 'Y'                                       CRE001
     C     TSTMC         IFEQ      'Y'                                                         CRE00
     C                   MOVE      '1'           *IN74
     C                   END
     C***********FXAC      IFEQ 'Y'                                       CRE001
     C     FACH          IFEQ      'Y'                                                         CRE00
     C                   MOVE      '1'           *IN77
     C                   END
     C*
     C**
     C**   ACCESS BANK DETAILS
     C**
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C*
     C     @RTCD         IFNE      *BLANK
     C                   SETON                                        U7U8LR
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY                          ***************
     C                   MOVEL     @OPTN         DBOPTN            7            * DBERROR 001 *
     C                   MOVEL     '001'         DBASE                          ***************
     C                   EXSR      *PSSR
     C                   GOTO      END
     C                   END
     C**
     C**   CHECK SYSTEM DATE FORMAT, DDMMYY OR MMDDYY.
     C     DATF          COMP      'M'                                    98    MMDDYY, 98 ON.
     C**
     C*****ACCESS MIDAS MODULE DETAILS                                    CRE001
     C***********                                                         CRE001
     C***********          CALL 'AOMMODR0'                                CRE001
     C***********          PARM '*MSG   ' @RTCD   7                       CRE001
     C***********          PARM '*FIRST ' @OPTN   7                       CRE001
     C***********SDMMOD    PARM SDMMOD    DSFDY                           CRE001
     C***********                                                         CRE001
     C***********@RTCD     IFNE *BLANK                                    CRE001
     C***********          SETON                     U7U8LR               CRE001
     C***********          MOVEL'SDMMODPD'DBFILE                          CRE001
     C***********          MOVEL@OPTN     DBKEY            ***************CRE001
     C***********          MOVEL@OPTN     DBOPTN  7        * DBERROR 002 *CRE001
     C***********          MOVEL'002'     DBASE            ***************CRE001
     C***********          EXSR *PSSR                                     CRE001
     C***********          GOTO END                                       CRE001
     C***********          END                                            CRE001
      *                                                                   CPB001
     C     BGN4ST        IFEQ      'Y'                                                         CPB00
     C                   MOVE      *ON           *IN29                                         CPB00
     C                   ENDIF                                                                 CPB00
      *                                                                   S01486
      ** Determine if Portfolio Management Module is switched on.         S01486
     C     BGPFMG        IFEQ      'Y'                                                         S0148
     C                   MOVE      *ON           *IN29                                         S0148
     C                   CALL      'AOPORTR0'                                                  S0148
     C                   PARM      '*MSG   '     @RTCD                                         S0148
     C                   PARM      '*FIRST '     @OPTN                                         S0148
     C     SDPORT        PARM      SDPORT        DSFDY                                         S0148
     C*                                                                   S01486
     C     @RTCD         IFNE      *BLANK                                                      S0148
     C                   SETON                                        U7U8LR                   S0148
     C                   MOVEL     'SDPORTPD'    DBFILE                                        S0148
     C                   MOVEL     @OPTN         DBKEY                          ***************S0148
     C                   MOVEL     @OPTN         DBOPTN            7            * DBERROR 012 *S0148
     C                   MOVEL     '012'         DBASE                          ***************S0148
     C                   EXSR      *PSSR                                                       S0148
     C                   GOTO      END                                                         S0148
     C                   END                                                                   S0148
     C                   END                                                                   S0148
     C**
     C**   ACCESS RETAIL DETAILS, WHEN RETAIL MODULE EXISTS
     C**
     C     BGRTBN        IFEQ      'Y'
     C*
     C                   CALL      'AORETLR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDRETL        PARM      SDRETL        DSFDY
     C*
     C     @RTCD         IFNE      *BLANK
     C                   SETON                                        U7U8LR
     C                   MOVEL     'SDRETLPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY                          ***************
     C                   MOVEL     @OPTN         DBOPTN            7            * DBERROR 003 *
     C                   MOVE      '003'         DBASE                          ***************
     C                   EXSR      *PSSR
     C                   GOTO      END
     C                   END
     C*
     C     BMRANR        COMP      'Y'                                    61
     C*
     C                   END
     C*
     C*
     C* Idem for Withholding Tax
     C*
     C     BGNTST        IFEQ      'N'                                          - B2
     C                   MOVE      '1'           *IN28
     C                   END                                                    - E2
      *
      * If Midas/TI Interface is on then seton *IN69                      CTI001
      *                                                                   CTI001
     C     BGN3ST        IFEQ      'Y'                                                         CTI00
     C                   MOVE      *ON           *IN69                                         CTI00
     C                   ELSE                                                                  CTI00
     C                   MOVE      *OFF          *IN69                                         CTI00
     C                   ENDIF                                                                 CTI00
     C/COPY WNCPYSRC,GL3572C025
      *                                                                   CTI001
     C**
     C** ACCESS SAR DETAILS FILE TO DETERMINE IF BRT SAR IS INSTALLED
     C**
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01383'      @SARD             6
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*NRF   '
     C                   SETON                                        U7U8LR
     C                   MOVEL     'SCSARDPD'    DBFILE                         ***************
     C                   MOVEL     @RTCD         DBKEY                          * DBERROR 008 *
     C                   MOVE      '008'         DBASE                          ***************
     C                   EXSR      *PSSR
     C                   GOTO      END
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     '1'           *IN34
     C                   END
     C/COPY WNCPYSRC,GL3572C023
      *
      ** Check if SAR CRE001 is set on                                    CRE001
      *                                                                   CRE001
     C                   MOVE      'N'           CRE001            1                           CRE00
     C                   CALL      'AOSARDR0'                                                  CRE00
     C                   PARM      *BLANKS       @RTCD             7                           CRE00
     C                   PARM      '*VERIFY'     @OPTN             7                           CRE00
     C                   PARM      'CRE001'      @SARD             6                           CRE00
      *                                                                   CRE001
     C     @RTCD         IFNE      *BLANKS                                                     CRE00
     C     @RTCD         ANDNE     '*NRF   '                                                   CRE00
     C                   SETON                                        U7U8LR                   CRE00
     C                   MOVEL     'CRE001'      DBKEY                          ***************CRE00
     C                   MOVE      'SCSARDPD'    DBFILE                         * DBERROR 009 *CRE00
     C                   Z-ADD     009           DBASE                          ***************CRE00
     C                   EXSR      *PSSR                                                       CRE00
     C                   GOTO      END                                                         CRE00
     C                   END                                                                   CRE00
      *                                                                   CRE001
     C     @RTCD         IFEQ      *BLANKS                                                     CRE00
     C                   MOVE      'Y'           CRE001                                        CRE00
     C                   MOVE      '1'           *IN35                                         CRE00
     C                   END                                                                   CRE00
      *                                                                   CGL004
      *  Access SAR Details File to determine if Midas-Fontis             CGL004
      *  Interface is active.                                             CGL004
      *                                                                   CGL004
     C                   CALL      'AOSARDR0'                                                  CGL00
     C                   PARM      '       '     @RTCD                                         CGL00
     C                   PARM      '*VERIFY'     @OPTN                                         CGL00
     C                   PARM      'CGL004'      @SARD             6                           CGL00
      *                                                                   CGL004
     C     @RTCD         IFNE      *BLANK                                                      CGL00
     C     @RTCD         ANDNE     '*NRF   '                                                   CGL00
     C                   SETON                                        U7U8LR                   CGL00
     C                   MOVEL     'SCSARDPD'    DBFILE                         ***************CGL00
     C                   MOVEL     @RTCD         DBKEY                          * DBERROR 010 *CGL00
     C                   MOVE      '010'         DBASE                          ***************CGL00
     C                   EXSR      *PSSR                                                       CGL00
     C                   GOTO      END                                                         CGL00
     C                   ENDIF                                                                 CGL00
      *                                                                   CGL004
     C     @RTCD         IFEQ      *BLANK                                                      CGL00
     C                   MOVE      'Y'           CGL004            1                           CGL00
     C                   ENDIF                                                                 CGL00
     C*                                                                   CEU013
     C**  Access SAR details file to see if CEU013 is installed.          CEU013
     C*                                                                   CEU013
     C                   CALL      'AOSARDR0'                                                  CEU01
     C                   PARM      '       '     @RTCD             7                           CEU01
     C                   PARM      '*VERIFY'     @OPTN             7                           CEU01
     C                   PARM      'CEU013'      WSARD             6                           CEU01
     C*                                                                   CEU013
     C     @RTCD         IFEQ      *BLANK                                                      CEU01
     C                   MOVE      'Y'           CEU013            1                           CEU01
     C                   ELSE                                                                  CEU01
     C                   MOVE      'N'           CEU013                                        CEU01
     C                   ENDIF                                                                 CEU01
      *                                                                   CFT004
      **  Access SAR details file to see if CFT004 is installed.          CFT004
      *                                                                   CFT004
     C                   CALL      'AOSARDR0'                                                  CFT00
     C                   PARM      *BLANKS       PRTCD             7                           CFT00
     C                   PARM      '*VERIFY'     POPTN             7                           CFT00
     C                   PARM      'CFT004'      PSARD             6                           CFT00
     C     SCSARD        PARM      SCSARD        DSSDY                                         CFT00
      *                                                                   CFT004
     C     PRTCD         IFEQ      *BLANKS                                                     CFT00
     C                   MOVE      'Y'           CFT004            1                           CFT00
     C                   MOVE      '1'           *IN05                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVE      'N'           CFT004                                        CFT00
     C                   ENDIF                                                                 CFT00
     C*                                                                   CEU013
      **  Access SAR details file to see if CDE002 is installed.          CDE002
      *                                                                   CDE002
     C                   CALL      'AOSARDR0'                                                  CDE00
     C                   PARM      *BLANKS       PRTCD                                         CDE00
     C                   PARM      '*VERIFY'     POPTN                                         CDE00
     C                   PARM      'CDE002'      PSARD                                         CDE00
     C     SCSARD        PARM      SCSARD        DSSDY                                         CDE00
      *                                                                   CDE002
     C     PRTCD         IFEQ      *BLANKS                                                     CDE00
     C                   MOVE      'Y'           CDE002            1                           CDE00
     C                   MOVE      *ON           *IN38                                         CDE00
     C                   ELSE                                                                  CDE00
     C                   MOVE      'N'           CDE002                                        CDE00
     C                   ENDIF                                                                 CDE00
     C*                                                                   CDE002
      *
      ***  Determine if switchable feature CGL018 is activated                                CGL018
      *                                                                                       CGL018
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CGL018'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CGL018
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CGL018            1
     C                   SETON                                        41
     C                   ELSE
     C                   MOVE      'N'           CGL018
     C                   SETOFF                                       41
     C                   ENDIF
      *                                                                                       CLE025
      ** Check if enhancement CLE025 (Credit Lines) is on                                     CLE025
      *                                                                                       CLE025
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE025'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                       CLE025
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CLE025'      DBKEY
     C                   MOVEL     '017'         DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   GOTO      END
     C                   ENDIF
      *                                                                                       CLE025
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE025            1
     C                   MOVE      *ON           *IN27
     C                   ELSE
     C                   MOVE      'N'           CLE025
     C                   ENDIF
      *                                                                                       CRE015
      ** Check if enhancement CRE015 (Terms and Notice) is on.                                CRE015
      *                                                                                       CRE015
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CRE015'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                       CRE015
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CRE015'      DBKEY
     C                   MOVEL     '018'         DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   GOTO      END
     C                   ENDIF
      *                                                                                       CRE015
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CRE015            1
     C                   ELSE
     C                   MOVE      'N'           CRE015
     C                   ENDIF
      *                                                                                       CRE075
      ** Check if enhancement CRE075 (Effective Date) is on.                                  CRE075
      *                                                                                       CRE075
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CRE075'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                       CRE075
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CRE075'      DBKEY
     C                   MOVEL     '019'         DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   GOTO      END
     C                   ENDIF
      *                                                                                       CRE075
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CRE075            1
     C                   ELSE
     C                   MOVE      'N'           CRE075
     C                   ENDIF
      *                                                                                       CRE095
      ** Check if Switchable Feature CRE095 is installed.                                     CRE095
      *                                                                                       CRE095
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CRE095'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                       CRE095
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      *ON           *IN15
     C                   MOVE      'Y'           CRE095            1
     C                   ELSE
     C                   MOVE      'N'           CRE095
     C                   ENDIF
     C/COPY OFCPYSRCZ,CRE101_070                                                              CRE101
      *                                                                                     MD034725
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CTI006'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *                                                                                     MD034725
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CTI006'      DBKEY
     C                   MOVEL     '919'         DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   GOTO      END
     C                   ENDIF
      *                                                                                     MD034725
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CTI006            1
     C                   ELSE
     C                   MOVE      'N'           CTI006
     C                   ENDIF
      *                                                                                       CGL018
      *  DEFINE KEY FOR CHAINING TO PF/ACCNTBXC
      *
     C     KACCNT        KLIST
     C**********           KFLD           CNUMC   60                                          CSD027
     C                   KFLD                    CNUMC             6
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    BRCA                                          CRE00
     C*
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL3572CCPG                                           S01408
     C*                                                                   S01408
     C                   Z-ADD     0             CINUAF
     C                   Z-ADD     0             COCLAF
     C                   Z-ADD     0             COCFAF
     C                   Z-ADD     0             CAIC0
     C                   Z-ADD     0             CALC
     C                   Z-ADD     0             DAIC0
     C                   Z-ADD     0             GACI
     C                   Z-ADD     0             GADI
     C                   Z-ADD     0             MACI
     C                   Z-ADD     0             MADI
     C                   Z-ADD     0             NAUP
     C                   Z-ADD     0             NOAU
     C                   Z-ADD     0             NOCF
     C                   Z-ADD     0             NOCL
     C                   Z-ADD     0             NOOA
     C                   Z-ADD     0             NORD
     C                   Z-ADD     0             DBASE
     C                   Z-ADD     0             ENOC
     C                   Z-ADD     0             EPNO
      *-------------------------------------------------------------------
      ** Initialize printer field                                                             CER001
     C                   Z-ADD     0             WE1A14
     C**
     C                   EXSR      CCYARR
     C                   TIME                    MTIME             6 0
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL3572CCP2                                           S01408
     C*                                                                   S01408
      ** Define work field for Yellow Book module.                                           LLN022A
      *                                                                                      LLN022A
     C                   MOVEL     *BLANK        LLN007            1
      *                                                                                      LLN022A
      ** Check to see if Yellow Book changes (LLN007) is switched on.                        LLN022A
      *                                                                                      LLN022A
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'LLN007'      @SARD
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*NRF   '
     C                   SETON                                        U7U8LR
     C                   MOVEL     'SCSARDPD'    DBFILE                         ***************
     C                   MOVEL     @RTCD         DBKEY                          * DBERROR 020 *
     C                   MOVE      '020'         DBASE                          ***************
     C                   EXSR      *PSSR
     C                   GOTO      END
     C                   ENDIF
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVEL     'N'           LLN007
     C                   ELSE
      *                                                                                      LLN022A
      ** Otherwise...                                                                        LLN022A
      *                                                                                      LLN022A
     C                   MOVEL     'Y'           LLN007                         BoE Yellow book
     C                   ENDIF
      *                                                                                      LLN022A
      ** Access Switchable Features file and check if CSD023              CSD023
      ** is switched on or not.                                           CSD023
      *                                                                   CSD023
     C                   CALL      'AOSARDR0'                                                  CSD02
     C                   PARM      *BLANKS       PRTCD             7                           CSD02
     C                   PARM      '*VERIFY'     POPTN             7                           CSD02
     C                   PARM      'CSD023'      PSARD             6                           CSD02
     C     SCSARD        PARM      SCSARD        DSFDY                                         CSD02
      *                                                                   CSD023
     C     PRTCD         IFEQ      *BLANKS                                                     CSD02
     C                   MOVE      'Y'           CSD023            1                           CSD02
     C                   ELSE                                                                  CSD02
     C                   MOVE      'N'           CSD023                                        CSD02
      *                                                                   CSD023
      ** Database Error, if Return Code is not blanks or *NRF             CSD023
      *                                                                   CSD023
     C     PRTCD         IFNE      '*NRF   '                                                   CSD02
     C                   MOVEL     'SCSARDPD'    DBFILE                                        CSD02
     C                   MOVEL     '001'         DBASE                                         CSD02
     C                   MOVEL     'CSD023  '    DBKEY                                         CSD02
     C                   EXSR      *PSSR                                                       CSD02
     C                   ENDIF                                                                 CSD02
     C                   ENDIF                                                                 CSD02
      ** Access Switchable Features file and check if CRE073                                  CRE073
      ** is switched on or not.                                                               CRE073
      *                                                                                       CRE073
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CRE073'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CRE073
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      *ON           *IN16
     C                   ELSE
     C                   MOVE      *OFF          *IN16
      *                                                                                       CRE073
      ** Database Error, if Return Code is not blanks or *NRF                                 CRE073
      *                                                                                       CRE073
     C     PRTCD         IFNE      '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '020'         DBASE
     C                   MOVEL     'CRE073  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C*
      *                                                                                       CER047
      ** Call AOSARDR0 to check for CER047                                                    CER047
      *                                                                                       CER047
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CER047'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CER047
     C     PRTCD         IFEQ      *BLANKS
      *                                                                                       CER047
     C                   MOVE      'Y'           CER047            1
     C                   ELSE
     C                   MOVE      'N'           CER047
      *                                                                                       CER047
     C                   ENDIF
      *                                                                                       CER047
      ** Database Error, if Return Code is not blanks or *NRF                                 CER047
      *                                                                                       CER047
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
      *                                                                                       CER047
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '906'         DBASE
     C                   MOVEL     'CER047'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *                                                                                       CER047
     C                   ENDIF
      *                                                                                       CER047
      ** Call AOSARDR0 to check if CRE090 is installed                                        CRE090
      *                                                                                       CRE090
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CRE090'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CRE090
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CRE090            1
     C                   MOVE      '1'           *IN08
     C                   ELSE
     C                   MOVE      '0'           *IN08
     C                   MOVE      'N'           CRE090
      *                                                                                       CRE090
     C                   ENDIF
      *                                                                                       CRE090
      ** Database Error, if Return Code is not blanks or *NRF                                 CRE090
      *                                                                                       CRE090
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
      *                                                                                       CRE090
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '907'         DBASE
     C                   MOVEL     'CRE090'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *                                                                                       CRE090
     C                   ENDIF
      *                                                                                       CRE090
     C     START         TAG                                                    ** START TAG **
     C*                                                                   S01408
     C     ULX004        IFEQ      'Y'
      *                                                                                       CER001
     C/COPY WNCPYSRC,GL3572CCP3                                           S01408
     C                   Z-ADD     ACOD          N#ACOD
     C                   MOVE      C#ACOD        NACOD
     C     KEYAC         CHAIN     REACX1PD                           95
     C*                                                                   S01408
     C                   ENDIF
      *                                                                                       CER001
     C                   Z-ADD     0             R#DECD
      *                                                                                     MD027647
     C                   Z-ADD     ACOD          N#ACOD
     C                   MOVE      C#ACOD        NACOD
     C     KEYAC         CHAIN     GLACNTL3                           18
      *                                                                                     MD027647
      ** Delay Capitalisation Days                                                          MD027647
      *                                                                                     MD027647
     C     CRE090        IFEQ      'Y'
     C     *IN18         ANDEQ     '0'
     C                   Z-ADD     F1DECD        R#DECD
     C                   ENDIF
      *                                                                                       CRE095
      ** Rate Fixing for RE Accounts                                                          CRE095
      *                                                                                       CRE095
     C     CRE095        IFEQ      'Y'
     C     F1DNFD        IFNE      0
     C                   Z-ADD     F1DNFD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        F2DNFD            7
     C                   ELSE
     C                   MOVE      *BLANKS       F2DNFD            7
     C                   ENDIF
     C     F1CNFD        IFNE      0
     C                   Z-ADD     F1CNFD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        F2CNFD            7
     C                   ELSE
     C                   MOVE      *BLANKS       F2CNFD
     C                   ENDIF
     C                   ENDIF
      *                                                                                     MD027647
     C     CAP205        IFEQ      'Y'
     C**********           Z-ADDACOD      N#ACOD                                     CAP205 MD027647
     C**********           MOVE C#ACOD    NACOD                                      CAP205 MD027647
     C                   SETON                                        62
     C********** KEYAC     CHAINGLACNTL3             18                              CAP205 MD027647
     C     *IN18         IFEQ      '1'
     C                   MOVEL     *BLANKS       R#IABC
     C                   MOVE(P)   '0'           R#TOLR
     C                   ELSE
      *                                                                                       CAP205
      ** Account Balance Check Indicator                                                      CAP205
      *                                                                                       CAP205
     C     F1IABC        IFEQ      'Y'
     C                   MOVEL(P)  'YES'         R#IABC
     C                   ELSE
     C                   MOVEL(P)  'NO'          R#IABC
     C                   ENDIF
      **********                                                                     CRE090 MD027647
      ***Delay*Capitalisation Days                                                   CRE090 MD027647
      **********                                                                     CRE090 MD027647
     C********** CRE090    IFEQ 'Y'                                                  CRE090 MD027647
     C**********           Z-ADDF1DECD    R#DECD                                     CRE090 MD027647
     C**********           ENDIF                                                     CRE090 MD027647
      *                                                                                       CAP205
      ** Overdraft Tolerance                                                                  CAP205
      *                                                                                       CAP205
     C                   Z-ADD     F1TOLR        ZFLD15
     C                   MOVEL     'J'           ZECODE
      *                                                                                       CAP205
     C                   CALL      'AOCURRR0'
     C                   PARM                    @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      F1CCY         @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
      *                                                                                       CAP205
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   SETON                                        U7U8
     C                   MOVE      '063'         DBASE
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     F1CCY         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   Z-ADD     A6NBDP        ZDECS
     C                   ENDIF
      *                                                                                       CAP205
     C                   EXSR      ZSEDIT
     C                   MOVE(P)   ZOUT21        R#TOLR
      *                                                                                       CAP205
     C                   ENDIF
     C                   ELSE
     C                   SETOFF                                       62
     C                   ENDIF
      *                                                                                       CAP205
     C/EJECT
     C                   SETOFF                                       21
     C   02                                                                                    08451
     COR 03              SETON                                        10                       08451
     C   02
     COR 03              GOTO      END
     C/COPY WNCPYSRC,GL3572C024
     C*
     C     *INL1         IFEQ      '1'
     C     *IN76         IFEQ      '0'
     C     *IN75         ANDEQ     '1'
     C                   WRITE     NODTL2
     C                   WRITE     NODTL2B
     C                   ELSE
      * Branch end of report
     C     *IN75         IFEQ      '1'
     C                   WRITE     GL3572FT
     C                   WRITE     GL3572FB
     C                   END
     C                   END
     C                   CLOSE     GL3572P1
     C                   SETOFF                                       76
     C     BRNCH         IFEQ      'ALL'
     C     BRNCH         OREQ      BRCA
     C                   MOVE      BRCA          BRCA1             3
     C                   SETON                                        7589
     C                   OPEN      GL3572P1
     C                   Z-ADD     SFNUM         SFNUM1            6 0
     C                   OUT       LDA
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQ
     C                   PARM      BRCA          SENTY             3
     C                   PARM                    SFILE
     C                   PARM                    SFNUM1
     C                   PARM      *BLANKS       ZSERR             1
     C*
     C     *LOCK         IN        LDA
     C     ZSERR         IFEQ      'Y'
     C*
     C* ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAMME
     C*
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   END
     C**
      *                                                                   CSD005
     C** To get Branch Name
     C**********           CALL 'AOBRCHR0'                                                    CGL029
     C                   CALL      'AOBRCHR1'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BRCA          @DSNB             3
     C********** SDBRCH    PARM SDBRCH    DSFDY                                               CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C     @RTCD         IFNE      *BLANK
     C                   SETON                                        U7U8LR
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   MOVEL     @DSNB         DBKEY                          ***************
     C                   MOVEL     @OPTN         DBOPTN            7            * DBERROR 004 *
     C                   MOVEL     '004'         DBASE                          ***************
     C                   EXSR      *PSSR
     C                   GOTO      END
     C                   END
     C**
     C                   ELSE
     C                   SETOFF                                       75
     C                   SETON                                        87LR
     C                   END
     C                   END
      *                                                                   CFT004
      ** Format International Bank Account Numbers                        CFT004
      *                                                                   CFT004
     C                   MOVEL     *BLANKS       RIBAN                                         CFT00
     C     CFT004        IFEQ      'Y'                                                         CFT00
     C     IBAN          ANDNE     *BLANKS                                                     CFT00
     C                   CALL      'AOIBANR3'                                                  CFT00
     C                   PARM      *BLANKS       PRTCD             7                           CFT00
     C                   PARM      IBAN          PIBAN            47                           CFT00
     C                   PARM      *BLANKS       PIWITH           47                           CFT00
     C                   PARM      *BLANKS       PINOBL           34                           CFT00
      *                                                                   CFT004
     C     PRTCD         IFEQ      *BLANKS                                                     CFT00
     C                   MOVEL     PIWITH        RIBAN                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT004
     C                   ENDIF                                                                 CFT00
     C*
     C** EXIT PROGRAM WHEN NO RECORD EXIST FOR THE REQUESTED BRANCH
     C*
     C   87              GOTO      EMPTY
     C**
      *-------------------------------------------------------------------
     C/COPY WNCPYSRC,GL3572C021
     C                   MOVE      CINUAF        CINUAF
     C                   MOVE      COCLAF        COCLAF
     C                   MOVE      COCFAF        COCFAF
     C                   MOVE      CAIC0         CAIC0
     C                   MOVE      CALC          CALC
     C                   MOVE      DAIC0         DAIC0
     C                   MOVE      GACI          GACI
     C                   MOVE      GADI          GADI
     C                   MOVE      MACI          MACI
     C                   MOVE      MADI          MADI
     C                   MOVE      NAUP          NAUP
     C                   MOVE      NOAU          NOAU
     C                   MOVE      NOCF          NOCF
     C                   MOVE      NOCL          NOCL
     C                   MOVE      NOOA          NOOA
     C                   MOVE      NORD          NORD
     C                   MOVE      DBASE         DBASE
     C                   MOVE      ENOC          ENOC
     C                   MOVE      EPNO          EPNO
     C                   MOVE      ECFB          ECFB
     C                   Z-ADD     0             FNSQ1                                         CGL00
     C                   MOVE      *BLANK        FONA1                                         CGL00
     C                   MOVE      *BLANK        ATVD1                                         CGL00
     C                   MOVE      *BLANK        DATV1                                         CGL00
     C                   MOVE      *BLANK        WD421                                         CGL00
     C                   MOVE      *BLANK        GN421                                         CGL00
      *-------------------------------------------------------------------
     C*
     C*    CHECK FOR CHANGE IN CURRENCY CODE.
     C     XCCY          COMP      CCY                                5050
     C*
     C**   LOOK UP NO. OF DECIMAL PLACES FOR CURRENCY.
     C                   MOVE      CCY           XCCY              3
     C                   Z-ADD     1             X
     C     XCCY          LOOKUP    CCYA(X)                                95
     C                   MOVE      DPA(X)        XDECP             1 0
     C*
     C*    CHECK NUMBER OF DECIMAL PLACES FOR ACCOUNT CURRENCY.
     C   50XDECP         COMP      1                                    7071
     C   50XDECP         COMP      2                                  73  72
     C*                                                                   CEU013
     C*    CHECK FOR 'IN' CURRENCY                                        CEU013
     C     *IN50         IFEQ      '1'                                                         CEU01
     C     CEU013        ANDEQ     'Y'                                                         CEU01
     C                   CALL      'AOCURRR0'                                                  CEU01
     C                   PARM                    @RTCD             7                           CEU01
     C                   PARM      '*KEY   '     @OPTN             7                           CEU01
     C                   PARM      XCCY          @AJCD             3                           CEU01
     C     SDCURR        PARM      SDCURR        DSSDY                                         CEU01
     C     @RTCD         IFNE      *BLANKS                                                     CEU01
     C                   SETON                                        U7U8                     CEU01
     C                   MOVE      '14'          DBASE                           ************  CEU01
     C                   MOVEL     'SDCURRPD'    DBFILE                          * DATABASE *  CEU01
     C                   MOVEL     XCCY          DBKEY                           * ERROR 14 *  CEU01
     C                   EXSR      *PSSR                                         ************  CEU01
     C                   ELSE                                                                  CEU01
     C     A6INCY        IFEQ      'Y'                                                         CEU01
     C     A6TPSD        ANDLE     BJRDNB                                                      CEU01
     C                   SETON                                        64                       CEU01
     C                   ELSE                                                                  CEU01
     C                   SETOFF                                       64                       CEU01
     C                   ENDIF                                                                 CEU01
     C                   ENDIF                                                                 CEU01
     C                   ENDIF                                                                 CEU01
     C**                                                                  CEU013
     C*
     C*    ADJUST HELD AMOUNT AND MINIMUM BALANCE FOR OUTPUT.
     C                   MOVE      HELD          HELDA            14 0
     C**********           MOVE MINB      MINBA  110                                        BUG26720
     C                   MOVE      MINB          MINBA
      *                                                                   CSD005
      *** Find the account narrative for the account code if feature      CSD005
      *** CSD005 is active.                                               CSD005
      *                                                                   CSD005
     C     *IN37         IFEQ      *ON                                                         CSD00
      *                                                                   CSD005
     C                   MOVEL     *BLANKS       W#NARR                                        CSD00
     C                   MOVEL     *BLANKS       @AFNB                                         CSD00
      *                                                                   CSD005
     C                   MOVEL     ACOD          @AFNB                                         CSD00
     C                   CALL      'AOACODR0'                                                  CSD00
     C                   PARM      '*BLANK '     @RTCD             7                           CSD00
     C                   PARM      '*KEY   '     @OPTN             7                           CSD00
     C**********           PARM           @AFNB   4                                    CSD005 CGL029
     C********** SDACOD    PARM SDACOD    DSFDY                                        CSD005 CGL029
     C                   PARM                    @AFNB            10
     C     SDACOD        PARM      SDACOD        DSSDY
      *                                                                   CSD005
     C                   SELECT                                                                CSD00
      *                                                                   CSD005
      *** When account narrative is entered move field into               CSD005
      *** printer field                                                   CSD005
      *                                                                   CSD005
     C     @RTCD         WHENEQ    *BLANKS                                                     CSD00
     C                   MOVEL     A5NARR        W#NARR                                        CSD00
      *                                                                   CSD005
      *** If field is blank then blank out printer file field             CSD005
      *                                                                   CSD005
     C     @RTCD         WHENEQ    '*NRF'                                                      CSD00
     C                   MOVEL     *BLANKS       W#NARR                                        CSD00
      *                                                                   CSD005
     C                   OTHER                                                                 CSD00
     C     *LOCK         IN        LDA                                                         CSD00
     C                   MOVEL     'SDACODPD'    DBFILE                          ************* CSD00
     C                   MOVEL     '016'         DBASE                           *DBERROR 016* CSD00
     C                   MOVEL     @OPTN         DBKEY                           ************* CSD00
     C                   SETON                                        U7U8LR                   CSD00
     C                   OUT       LDA                                                         CSD00
     C                   EXSR      *PSSR                                                       CSD00
     C                   ENDSL                                                                 CSD00
     C                   ENDIF                                                                 CSD00
      *                                                                   CSD005
     C*
     C*    CHECK CHANGE TYPE.
     C     CHTP          COMP      'I'                                    80
     C     CHTP          COMP      'A'                                    81
     C     CHTP          COMP      'C'                                    82
     C     CHTP          COMP      'R'                                    83
     C*
     C     ATYP          COMP      'R'                                    19
     C     DACC          COMP      RUND                                   59
     C*                                                                  *
     C/COPY WNCPYSRC,GL3572C020
     C  N19
     CORN59
     CAN 04              GOTO      NOINTC
     C*
     C**   R E T A I L
     C**   -----------
     C**
     C*    OBTAIN CUSTOMER DETAILS
     C                   MOVE      *BLANK        CLNKEY           10
     C                   MOVEL     CNUM          CLNKEY
     C*****                CALL 'AOCUSTR0'                                CSD023
     C                   CALL      'AOCUSTR2'                                                  CSD02
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      CLNKEY        @KEY1            10
     C                   PARM                    @KYST             7
     C     SDCUST        PARM      SDCUST        DSLDY                                         CSD02
     C*****      SDCUST    PARM SDCUST    DSSDY                           CSD023
     C*
      ** If CSD023 is on, allow processing of a closed record (return     CSD023
      ** code '*NRF' and date deleted equal to zero).                     CSD023
      *                                                                   CSD023
     C     @KYST         IFNE      '*CNUM  '
     C     @RTCD         ORNE      *BLANK
     C     @RTCD         ANDNE     '*NRF   '                                                   CSD02
     C     CSD023        ANDEQ     'Y'                                                         CSD02
     C     @RTCD         ORNE      *BLANKS                                                     CSD02
     C     @RTCD         ANDEQ     '*NRF   '                                                   CSD02
     C     BBDTDL        ANDNE     *ZEROS                                                      CSD02
     C     CSD023        ANDEQ     'Y'                                                         CSD02
     C     @RTCD         ORNE      *BLANKS                                                     CSD02
     C     CSD023        ANDNE     'Y'                                                         CSD02
     C                   SETON                                        U7U8LR
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     @KEY1         DBKEY                          ***************
     C                   MOVEL     @OPTN         DBOPTN            7            * DBERROR 005 *
     C                   MOVEL     '005'         DBASE                          ***************
     C                   EXSR      *PSSR
     C                   GOTO      END
     C                   END
     C*
     C**   OBTAIN INTEREST AND CHARGES DETAILS
     C                   SETOFF                                       0607
     C     REKEY         CHAIN     REACR                              99
     C  N07              SETON                                        99
     C   99              SETON                                        U7U8LR
     C   99              MOVEL     'REACR'       DBFILE
     C   99              MOVEL     REKEY         DBKEY                          ***************
     C   99              MOVEL     '092'         DBASE                          * DBERROR 092 *
     C   99              EXSR      *PSSR                                        ***************
     C   99              GOTO      END
     C**
     C     REKEY         CHAIN     REIAC                              99
     C  N06              SETON                                        99
     C   99              SETON                                        U7U8LR
     C   99              MOVEL     'REIAC'       DBFILE
     C   99              MOVEL     REKEY         DBKEY                          ***************
     C   99              MOVEL     '093'         DBASE                          * DBERROR 093 *
     C   99              EXSR      *PSSR                                        ***************
     C   99              GOTO      END
      *-------------------------------------------------------------------
      *
     C     KREKEY        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL3572CCP4                                           S01408
     C     KEYAC         KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    NACOD            10 0
     C                   KFLD                    ACSQ
     C                   KFLD                    BRCA
     C*                                                                   S01408
     C*
     C* Get RECOM details
     C*
     C     CMDR          IFEQ      'Y'
     C     MDPF          ANDEQ     'Y'
     C     FXAC          OREQ      'Y'
     C     CNDS          OREQ      'Y'
     C     CDRI          OREQ      'Y'
     C     CMBL          OREQ      'Y'
     C     CINA          OREQ      'Y'
     C     CDTO          OREQ      'Y'
     C*
     C     KREKEY        CHAIN     RECOM                              99
     C   99              MOVEL     'RECOM'       DBFILE
     C   99              SETON                                        U7LR      ** DB ERROR 97
     C   99              MOVEL     REKEY         DBKEY
     C   99              Z-ADD     97            DBASE
     C   99              GOTO      END
     C*
     C* Format TCHO field
     C*
     C                   Z-ADD     XDECP         ZADEC
     C                   MOVE      TCHO          ZFIELD
     C/COPY WNCPYSRC,GL3572C002
     C                   EXSR      GEDIT
     C                   MOVE      ZFIELD        TCHOVR
     C*
     C* Setup commissions
     C*
     C     MDPF          IFEQ      *BLANK
     C     CMDR          OREQ      *BLANK
     C/COPY WNCPYSRC,GL3572C003
     C                   MOVEL     '(N/A)'       CEXA
     C/COPY WNCPYSRC,GL3572C004
     C                   END
     C     CDTO          IFNE      'Y'
     C/COPY WNCPYSRC,GL3572C005
     C                   MOVEL     '(N/A)'       CEXB
     C/COPY WNCPYSRC,GL3572C006
     C                   END
     C     CDRI          IFNE      'Y'
     C/COPY WNCPYSRC,GL3572C007
     C                   MOVEL     '(N/A)'       CEXC
     C/COPY WNCPYSRC,GL3572C008
     C                   END
     C     CINA          IFNE      'Y'
     C/COPY WNCPYSRC,GL3572C009
     C                   MOVEL     '(N/A)'       CEXD
     C/COPY WNCPYSRC,GL3572C010
     C                   END
     C     CMBL          IFNE      'Y'
     C/COPY WNCPYSRC,GL3572C011
     C                   MOVEL     '(N/A)'       CEXE
     C/COPY WNCPYSRC,GL3572C012
     C                   END
     C     CNDS          IFNE      'Y'
     C/COPY WNCPYSRC,GL3572C013
     C                   MOVEL     '(N/A)'       CEXF
     C/COPY WNCPYSRC,GL3572C014
     C                   END
     C     FXAC          IFNE      'Y'
     C/COPY WNCPYSRC,GL3572C015
     C                   MOVEL     '(N/A)'       CEXG
     C/COPY WNCPYSRC,GL3572C016
     C                   END
     C*
     C                   END
      *                                                                   CGL004
      *  If Midas-Fontis Interface active, obtain Fontis Account          CGL004
      *  Details                                                          CGL004
      *                                                                   CGL004
     C     CGL004        IFEQ      'Y'                                                         CGL00
     C                   MOVE      BRCA          KBRCA                                         CGL00
     C**********           Z-ADDCNUM      KCNUM                                        CGL004 CSD027
     C                   MOVE      CNUM          KCNUM
     C                   MOVE      CCY           KCCY                                          CGL00
     C                   MOVE      ACOD          KACOD                                         CGL00
     C                   MOVE      ACSQ          KACSQ                                         CGL00
      *                                                                   CGL004
     C     KACCNO        CHAIN     GLFONAD0                           99                       CGL00
      *                                                                   CGL004
     C     *IN99         IFEQ      '0'                                                         CGL00
     C                   MOVE      '1'           *IN36                                         CGL00
     C                   ELSE                                                                  CGL00
     C                   MOVE      '0'           *IN36                                         CGL00
     C                   ENDIF                                                                 CGL00
     C                   ENDIF                                                                 CGL00
      *-------------------------------------------------------------------
     C*
     C********** *IN28     IFEQ '0'                                                          BUG8210
     C********** CRE001    OREQ 'Y'                                       CRE001             BUG8210
     C********** CDE002    OREQ 'Y'                                       CDE002             BUG8210
      *                                                                                      BUG8210
      ** Check if Retail Account                                                             BUG8210
      *                                                                                      BUG8210
     C     *IN19         IFEQ      '1'
     C     *IN04         ANDEQ     '0'
     C                   MOVE      CNUM          CNUMC
     C     KACCNT        CHAIN     ACCNTBXC                           99
     C*
     C** DATABASE ERROR
     C     *IN99         IFEQ      '1'
     C                   MOVE      'ACCNTBXC'    DBFILE
     C                   SETON                                        U7LR      ** DB ERROR 96
     C                   MOVEL     REKEY         DBKEY
     C                   Z-ADD     96            DBASE
     C                   GOTO      END
     C                   END
     C*
      *                                                                   CRE001
      ** Format additional overdraft fields if CRE001 is on               CRE001
     C     CRE001        IFEQ      'Y'                                                         CRE00
      *                                                                   CRE001
      ** Format Additional Overdraft Rate for output                      CRE001
     C                   Z-ADD     ATAODR        WAODR            11 7                         CRE00
     C     ATAODR        IFLT      *ZERO                                                       CRE00
     C     ATAODR        MULT      -1            WAODR                                         CRE00
     C                   ENDIF                                                                 CRE00
     C                   MOVE      *BLANKS       ZFIELD                                        CRE00
     C                   MOVE      WAODR         ZFIELD                                        CRE00
     C                   Z-ADD     7             ZADEC                                         CRE00
     C                   Z-ADD     4             ZADIG                                         CRE00
     C                   EXSR      GEDIT                                                       CRE00
     C                   MOVE      ZFIELD        RRAODR                                        CRE00
      *                                                                   CRE001
      ** Additional Overdraft Rate - Set on indicator 54 if > 0           CRE001
      **                           - Set on indicator 52 if < 0           CRE001
     C     ATAODR        COMP      0                                  5452                     CRE00
      *                                                                   CRE001
      ** Convert dates for printing to DDMMMYY                            CRE001
      *                                                                   CRE001
      ** Overdraft Rate Change Value Date                                 CRE001
     C                   MOVE      *BLANKS       RRORTC                                        CRE00
     C                   Z-ADD     ATORTC        ZDAYNO                                        CRE00
     C                   EXSR      ZDATE2                                                      CRE00
     C                   MOVE      ZADATE        RRORTC                                        CRE00
      *                                                                   CRE001
      ** Overdraft Line Change Value Date                                 CRE001
     C                   MOVE      *BLANKS       RROLVD                                        CRE00
     C                   Z-ADD     ATOLVD        ZDAYNO                                        CRE00
     C                   EXSR      ZDATE2                                                      CRE00
     C                   MOVE      ZADATE        RROLVD                                        CRE00
      *                                                                   CRE001
      ** Previous Overdraft Line Change Value Date                        CRE001
     C                   MOVE      *BLANKS       RRPOLC                                        CRE00
     C                   Z-ADD     ATPOLC        ZDAYNO                                        CRE00
     C                   EXSR      ZDATE2                                                      CRE00
     C                   MOVE      ZADATE        RRPOLC                                        CRE00
      *                                                                   CRE001
      ** Previous Overdraft Line Expiry Date                              CRE001
     C                   MOVE      *BLANKS       RRPOLE                                        CRE00
     C                   Z-ADD     ATPOLE        ZDAYNO                                        CRE00
     C                   EXSR      ZDATE2                                                      CRE00
     C                   MOVE      ZADATE        RRPOLE                                        CRE00
      *                                                                   CRE001
      ** Interest Rate Review Date                                        CRE001
     C                   MOVE      *BLANKS       RRITRD                                        CRE00
     C     ATITRD        IFEQ      99999                                                       CRE00
     C                   MOVEL     'NO MATR'     RRITRD                                        CRE00
     C                   ELSE                                                                  CRE00
     C     ATITRD        IFNE      0                                                           CRE00
     C                   Z-ADD     ATITRD        ZDAYNO                                        CRE00
     C                   EXSR      ZDATE2                                                      CRE00
     C                   MOVE      ZADATE        RRITRD                                        CRE00
     C                   ENDIF                                                                 CRE00
     C                   ENDIF                                                                 CRE00
      *                                                                   CRE001
     C                   ENDIF                                                                 CRE00
      *                                                                   CRE001
      ** If CDE002 is on and Interest Margin fields have not been         CDE002
      ** overridden, access PF/RECCYD for defaults.                       CDE002
      *                                                                   CDE002
     C     CDE002        IFEQ      'Y'                                                         CDE00
     C                   MOVE      'D'           K#D                                           CDE00
     C                   MOVE      CCY           K#CCY                                         CDE00
      *                                                                   CDE002
     C     KRECCY        CHAIN     RECCY                              99                       CDE00
      *                                                                   CDE002
      ** Database Error                                                   CDE002
      *                                                                   CDE002
     C     *IN99         IFEQ      '1'                                                         CDE00
     C                   MOVE      'RECCYD'      DBFILE                                        CDE00
     C                   MOVE      *ON           *INU7                                         CDE00
     C                   MOVE      *ON           *INLR                                         CDE00
     C                   MOVEL     REKEY         DBKEY                                         CDE00
     C                   Z-ADD     98            DBASE                                         CDE00
     C                   GOTO      END                                                         CDE00
     C                   ENDIF                                                                 CDE00
      *                                                                   CDE002
     C     ATOVRD        IFEQ      'Y'                                                         CDE00
     C     ATDMBR        IFNE      *BLANKS
     C                   MOVEL     *BLANKS       PDRMG
     C                   MOVEL     ATDMBR        PDRMG
     C                   ELSE
     C***********          MOVE ATDRMG    PDRMG                                         CDE002208221
     C                   MOVE      ATDRMG        ZFLD15
     C                   Z-ADD     7             ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        PDRMG
     C                   ENDIF
     C                   ELSE                                                                  CDE00
     C***********          MOVE DRMG      PDRMG                                         CDE002208221
     C                   MOVE      DRMG          ZFLD15
     C                   Z-ADD     7             ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        PDRMG
     C                   ENDIF                                                                 CDE00
      *                                                                   CDE002
     C     ATOVRC        IFEQ      'Y'                                                         CDE00
     C     ATCMBR        IFNE      *BLANKS
     C                   MOVEL     *BLANKS       PCRMG
     C                   MOVEL     ATCMBR        PCRMG
     C                   ELSE
     C***********          MOVE ATCRMG    PCRMG                                         CDE002208221
     C                   MOVE      ATCRMG        ZFLD15
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        PCRMG
     C                   ENDIF
     C                   ELSE                                                                  CDE00
     C***********          MOVE CRMG      PCRMG                                         CDE002208221
     C                   MOVE      CRMG          ZFLD15
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        PCRMG
     C                   ENDIF                                                                 CDE00
      *                                                                   CDE002
     C                   ENDIF                                                                 CDE00
      *                                                                   CDE002
     C/COPY OFCPYSRCZ,CRE101_071                                                              CRE101
     C                   END
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL3572CPDR                                           S01408
     C*                                                                   S01408
      ** If Yellow book feature is 'on'                                                      LLN022A
      *                                                                                      LLN022A
     C     LLN007        IFEQ      'Y'
      *                                                                                      LLN022A
     C     ACDTKY        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
      *                                                                                      LLN022A
      ** Get record from Account details extn file                                           LLN022A
      *                                                                                      LLN022A
     C     ACDTKY        CHAIN     BYACCTY0                           69
      *                                                                                      LLN022A
      ** If no record found                                                                  LLN022A
      *                                                                                      LLN022A
     C     *IN69         IFEQ      *ON
     C                   MOVE      *BLANK        LNETI                          Netting Ind.
     C                   MOVE      *BLANK        LDPTP                          Deposit type
     C                   MOVE      *BLANK        LSNOD                          SAYE/Shrsav nd
     C                   MOVE      *BLANK        LLNTP                          Loan type
     C                   MOVE      *BLANK        LMDAT                          Loan mat date
     C                   MOVE      *BLANK        LLLIM                          Loan limit
      *                                                                                      LLN022A
      ** If extension record found                                                           LLN022A
      *                                                                                      LLN022A
     C                   ELSE
      *                                                                                      LLN022A
      ** Convert 5-decimal date field to DDMMYY                                              LLN022A
      *                                                                                      LLN022A
     C                   Z-ADD     LMDAT         ZDAYNO
     C                   EXSR      ZDATE2
      *                                                                                      LLN022A
     C                   MOVEL     ZDATE         L#MDAT                         Loan Mat. Date
      *                                                                                      LLN022A
     C                   MOVEL     LNETI         L#NETI                         For Netting
     C                   MOVEL     LDPTP         L#DPTP                         Deposit type
     C                   MOVEL     LSNOD         L#SNOD                         SAYE/Sh not.day
     C                   MOVEL     LLNTP         L#LNTP                         Loan Type
     C                   MOVEL     LLLIM         L#LLIM                         Loan Limit
      *                                                                                      LLN022A
     C                   ENDIF
     C                   ENDIF
      *                                                                                      LLN022A
     C**
     C**   CALCULATE CHARGES ACCRUED SINCE LAST CAPITALISATION
     C     NRCA          ADD       RECA          CALC             13 0  86
     C**                                                                **
     C**   SETUP OUTPUT INDICATORS
     C     MADI          COMP      0                                  55
     C     GADI          COMP      0                                  6665
     C     MACI          COMP      0                                  57  58
     C     GACI          COMP      0                                  6867
     C*
     C*    ADJUST INTEREST AMOUNTS.
     C*
     C                   Z-ADD     DAIC          DAIC0            13 0
     C                   Z-ADD     CAIC          CAIC0            13 0
     C*
     C*
     C     NOINTC        TAG                                                    *** NOINTC ***
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL3572CCP6                                           S01408
     C*                                                                   S01408
     C*
     C*    COMPARE LAST CHANGE DATE WITH TODAY'S DATE.
     C     LCD           COMP      RUND                                   60
     C*
     C  N60              GOTO      TAG1
     C*
     C*    CALCULATE FILE CONTROL TOTALS.
     C*
     C   80CNINU         ADD       1             CNINU             5 0
     C   81CNOAM         ADD       1             CNOAM             5 0
     C   82
     CANN01CNOCL         ADD       1             CNOCL             5 0
     C   82
     CAN 01CNOCF         ADD       1             CNOCF             5 0
     C   83CNORD         ADD       1             CNORD             5 0
     C*
     C**   RETAIL ACCOUNT NUMBER CHECK
     C     ACNO          COMP      0                                      20
     C**
     C   20              GOTO      TAG1
     C*
     C***  RETAIL A/CS
     C*
     C   80
     CAN 61CINUAF        ADD       1             CINUAF            5 0
     C*
     C   82
     CANN01
     CAN 61COCLAF        ADD       1             COCLAF            5 0
     C*
     C   82
     CAN 01
     CAN 61COCFAF        ADD       1             COCFAF            5 0
     C*
     C     TAG1          TAG                                                    ** TAG1 TAG **
     C*
     C***  KEEP TOTAL OF OPEN A/CS
     C*
     C   19
     CAN 01
     CAN 61COAUAF        ADD       1             COAUAF            5 0
     C   01CNOAU         ADD       1             CNOAU             5 0
     C**
     C**   ACCOUNTS CLOSED BEFORE TODAY NOT REQUIRED TO REPORT
     C  N59
     CAN 04              GOTO      END
     C**
     C**   OUTPUT INDICATOR FOR PRINT TRANSACTION ADVICE
     C   19PTRA          COMP      'Y'                                    48
     C**
     C**   OUTPUT INDICATOR FOR RATE CHANGE ADVICE
     C   19PRCA          COMP      'Y'                                    49
     C**
     C**   SETUP OUTPUT INDICATORS
     C     ODSC          COMP      'Y'                                    33
     C     DRIS          COMP      0                                  51
     C     CRIS          COMP      0                                  53
     C     CIIE          COMP      0                                  63
     C     DACC          COMP      0                                      32
     C*
     C*    CONVERT DATES FOR REPORT PRINTING TO DDMMYY FORMAT.
     C*
     C                   Z-ADD     DACO          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        OPNDAT            7            OPEN DATE
     C*
     C  N32              Z-ADD     DACC          ZDAYNO
     C  N32              EXSR      ZDATE2
     C  N32              MOVE      ZADATE        CLSDAT            7            CLOSED DATE
     C*
     C   19              Z-ADD     ODED          ZDAYNO
     C   19              EXSR      ZDATE2
     C   19              MOVE      ZADATE        EXPDAT            7            EXPIRY DATE
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL3572CPD1                                           S01408
     C*                                                                   S01408
     C*
     C                   Z-ADD     NSTD          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        NXTDAT            7            NEXT STATMENT
     C*                                                    DATE
     C*
     C                   TESTB     '0'           RETB                     42    REFER DEBITS
     C*
     C                   TESTB     '1'           RETB                     43    REFER CREDITS
     C*
     C                   TESTB     '2'           RETB                     44    BLOCK DEBITS
     C*
     C                   TESTB     '2'           GLBT                     45    PRINT ADDRESS
     C*
     C                   TESTB     '3'           RETB                     46    BLOCK CREDITS
     C*
     C   19              TESTB     '4'           RETB                     47    INACTIVE
     C*
     C   19              TESTB     '6'           RETB                     84    BANKRUPT
     C*
     C   19              TESTB     '7'           RETB                     85    BAD DEBT
     C*
     C/COPY WNCPYSRC,GL3572CTC1                                           S01408
     C                   Z-ADD     LMVD          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        LMVDAT            7            LAST MOVE.DATE
     C/COPY WNCPYSRC,GL3572C022
     C*
     C                   Z-ADD     LACD          ZDAYNO
     C                   EXSR      ZDATE2                                       LAST ACTIVITY
     C                   MOVE      ZADATE        LACDAT            7            DATE
     C*
     C                   Z-ADD     LCD           ZDAYNO
     C                   EXSR      ZDATE2                                       LAST CHANGE
     C                   MOVE      ZADATE        LCHDAT            7            DATE
     C*
     C                   Z-ADD     DRCD          ZDAYNO
     C                   EXSR      ZDATE2                                       DEBIT RATE
     C                   MOVE      ZADATE        DRCDAT            7            CHANGE DATE
     C*
     C                   Z-ADD     CRCD          ZDAYNO
     C                   EXSR      ZDATE2                                       CREDIT RATE
     C                   MOVE      ZADATE        CRCDAT            7            CHANGE DATE
     C*
     C                   Z-ADD     NDID          ZDAYNO
     C                   EXSR      ZDATE2                                       NEXT CAP.
     C                   MOVE      ZADATE        NDIDAT            7            DEBIT DATE
     C*
     C                   Z-ADD     NCID          ZDAYNO
     C                   EXSR      ZDATE2                                       NEXT CAP.
     C                   MOVE      ZADATE        NCIDAT            7            CREDIT DATE
     C*
     C                   Z-ADD     LDID          ZDAYNO
     C                   EXSR      ZDATE2                                       LAST POSTING
     C                   MOVE      ZADATE        LPDDAT            7            DATE - DEBIT
     C*
     C                   Z-ADD     LCID          ZDAYNO
     C                   EXSR      ZDATE2                                       LAST POSTING
     C                   MOVE      ZADATE        LPCDAT            7            DATE -CREDIT
     C*
     C     CGL004        IFEQ      'Y'                                                         CGL00
     C                   Z-ADD     F1ATVD        ZDAYNO                                        CGL00
     C                   EXSR      ZDATE2                                       Activation     CGL00
     C                   MOVE      ZADATE        ATVD1             7            Date           CGL00
     C*                                                                   CGL004
     C                   Z-ADD     F1DATV        ZDAYNO                                        CGL00
     C                   EXSR      ZDATE2                                       De-Activation  CGL00
     C                   MOVE      ZADATE        DATV1             7            Date           CGL00
     C*                                                                   CGL004
     C                   Z-ADD     F1WD42        ZDAYNO                                        CGL00
     C                   EXSR      ZDATE2                                       Next MT942     CGL00
     C                   MOVE      ZADATE        WD421             7            Date           CGL00
     C                   ENDIF                                                                 CGL00
      ** Retrieve Reference attached to 9997 if needed.                   S01486
     C     *IN29         IFEQ      '1'                                                         S0148
     C********** PTFR      IFEQ *BLANKS                            S01486 CPB001
     C********** PTFR      OREQ '9997'                             S01486 CPB001
     C     PTFR          IFEQ      '9997'                                                      CPB00
     C     BGN4ST        ANDNE     'Y'                                                         CPB00
     C                   MOVE      FCR997        PTFR                                          S0148
     C                   END                                                                   S0148
     C                   END                                                                   S0148
     C*                                                                   S01486
     C/COPY WNCPYSRC,GL3572C027
     C     END           TAG                                                    ** END TAG ****
     C*
     C*    ACCUMULATE NUMBER OF RECORDS ON FILE.
     C     NREC          ADD       1             NREC              5 0
     C**
     C**   SET ACCOUNTS DETAILS OUTPUT INDICATOR FIR OPEN ACCOUNTS
     C**   AND ACCOUNTS CLOSED TODAY.
     C   01
     COR 59
     CAN 04              SETON                                        217976
      *-------------------------------------------------------------------
     C                   Z-ADD     CINUAF        CINUAF
     C                   Z-ADD     COCLAF        COCLAF
     C                   Z-ADD     COCFAF        COCFAF
     C                   Z-ADD     CAIC0         CAIC0
     C                   Z-ADD     CALC          CALC
     C                   Z-ADD     DAIC0         DAIC0
     C                   Z-ADD     GACI          GACI
     C                   Z-ADD     GADI          GADI
     C                   Z-ADD     MACI          MACI
     C                   Z-ADD     MADI          MADI
     C                   Z-ADD     NAUP          NAUP
     C                   Z-ADD     NOAU          NOAU
     C                   Z-ADD     NOCF          NOCF
     C                   Z-ADD     NOCL          NOCL
     C                   Z-ADD     NOOA          NOOA
     C                   Z-ADD     NORD          NORD
     C                   Z-ADD     DBASE         DBASE
     C                   Z-ADD     ENOC          ENOC
     C                   Z-ADD     EPNO          EPNO
     C                   Z-ADD     ECFB          ECFB
     C                   MOVE      F1FONA        FONA1                                         CGL00
     C                   MOVE      F1FNSQ        FNSQ1                                         CGL00
     C                   MOVE      F1GN42        GN421                                         CGL00
      *                                                                                       CER047
     C     ATYP          IFEQ      'R'
     C     CER047        ANDEQ     'Y'
      *                                                                                       CER047
     C                   MOVE      *ON           *IN09
     C                   ELSE
     C                   MOVE      *OFF          *IN09
      *                                                                                       CER047
     C                   ENDIF
      *                                                                                       CER047
     C     CTI006        IFEQ      'Y'
     C                   MOVE      *ON           *IN51
     C                   ENDIF
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL3572CCP1                                           S01408
     C*                                                                   S01408
      *-------------------------------------------------------------------
     C* Output to printer file
     C*
     C     *IN21         IFEQ      '1'
     C     *INU7         ANDEQ     '0'
     C     *INU1         ANDEQ     '0'
     C     *IN21         OREQ      '1'
     C     *INU7         ANDEQ     '0'
     C     *INU1         ANDEQ     '1'                                                         FROM
     C     *IN60         ANDEQ     '1'                                                         LCD =
     C* Header format
     C                   WRITE     GL3572HR                                                    17099
     C     CRE075        IFEQ      'Y'
     C     ATYP          ANDEQ     'R'
     C                   Z-ADD     ACEFDT        ZDAYNO
     C                   EXSR      ZDATE2
     C**********           MOVE ZADATE    DDEFDT  6                                  CRE075 AR762809
     C                   MOVE      ZADATE        DDEFDT            7
     C                   SETON                                            17
     C                   ENDIF
     C                   WRITE     GL3572F1
     C                   SETOFF                                           17
     C     *IN19         IFEQ      '1'
     C/COPY WNCPYSRC,GL3572C017
     C* Interest details
     C                   WRITE     GL3572F2
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL3572CPLH                                           S01408
     C*                                                                   S01408
     C* Overdraft
     C                   WRITE     GL3572F3
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL3572CLH1                                           S01408
     C*                                                                   S01408
     C* Charges
     C                   WRITE     GL3572F4
     C*
     C* Commission
     C*
     C                   WRITE     GL3572F5
     C*                                                                   170996
     C* Header details                                                    170996
     C*                                                                   170996
     C                   WRITE     GL3572HR                                                    17099
     C* Other details
     C*                                                                   S01408
     C     ULX004        IFEQ      'Y'
      *                                                                                       CER001
     C/COPY WNCPYSRC,GL3572CCP5                                           S01408
     C     WECOAC        IFEQ      *BLANKS
     C                   MOVE      *BLANKS       W#COAC
     C                   ELSE
     C                   MOVE      WWCNUM        W#CNUM
     C                   MOVE      '-'           W#HF1
     C                   MOVE      WWCCY         W#CCY
     C                   MOVE      '-'           W#HF2
     C                   MOVE      WWACOD        W#ACOD
     C                   MOVE      '-'           W#HF3
     C                   MOVE      WWACSQ        W#ACSQ
     C                   ENDIF
     C*                                                                   S01408
     C                   ENDIF
      *                                                                                       CER001
     C                   WRITE     GL3572F6
      *                                                                                       CRE015
      ** Periods and Penalties Details                                                        CRE015
      *                                                                                       CRE015
     C     CRE015        IFEQ      'Y'
      *                                                                                       CRE015
     C     KREKEY        SETLL     REPRPNL2
     C     KREKEY        READE     REPRPNL2                               99
     C                   MOVEL     'Y'           HDRIND            1
      *                                                                                       CRE015
     C     *IN99         DOWEQ     '0'
      *                                                                                       CRE015
     C     HDRIND        IFEQ      'Y'
     C                   WRITE     GL3572R1
     C                   MOVEL     'N'           HDRIND            1
     C                   ENDIF
      *                                                                                       CRE015
      **  Start Date                                                                          CRE015
      **  End Date                                                                            CRE015
      *                                                                                       CRE015
     C                   Z-ADD     E2VDAT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        E2SDAT
      *                                                                                       CRE015
     C                   Z-ADD     E2CEDE        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        E2EEDE
      *                                                                                       CRE015
      ** Debit and Credit Cap Day and Month                                                   CRE015
      *                                                                                       CRE015
     C                   MOVEL     E2DRDY        E2DRDD
     C                   MOVE      E2DRDY        E2DRDM
     C                   MOVEL     E2CRDY        E2CRDD
     C                   MOVE      E2CRDY        E2CRDM
      *                                                                                       CRE015
      ** Period Initial Balance                                                               CRE015
      *                                                                                       CRE015
     C   70              Z-ADD     E2BALN        E2BAL0
     C   71              Z-ADD     E2BALN        E2BAL1
     C   72              Z-ADD     E2BALN        E2BAL2
     C   73              Z-ADD     E2BALN        E2BAL3
      *                                                                                       CRE015
      ** If overflow encountered, print header and Period and Penalty header                  CRE015
      *                                                                                       CRE015
     C                   Z-ADD     11            RQDLN             2 0
     C     OFLLN         SUB       PRTLN         REMLN             2 0
     C     REMLN         IFLT      RQDLN
     C                   MOVE      '1'           *IN98
     C                   ELSE
     C                   MOVE      '0'           *IN98
     C                   ENDIF
      *                                                                                       CRE015
     C     *IN98         IFEQ      '1'
     C                   WRITE     GL3572HR
     C                   WRITE     GL3572R1
     C                   MOVE      '0'           *IN98
     C                   ENDIF
      *                                                                                       CRE015
     C                   WRITE     GL3572R2
     C     KREKEY        READE     REPRPNL2                               99
     C                   ENDDO
     C                   ENDIF
      *                                                                                       CRE015
     C*                                                                   CGL004
     C* Fontis Account Details.                                           CGL004
     C*                                                                   CGL004
     C     *IN36         IFEQ      '1'                                                         CGL00
     C                   WRITE     GL3572F7                                                    CGL00
     C                   ENDIF                                                                 CGL00
      *                                                                                       CER001
     C     ULX004        IFEQ      'Y'
      *                                                                                       CER001
     C                   WRITE     GL3572F9
     C                   ENDIF
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL3572CLH2                                           S01408
     C*                                                                   S01408
      ** If BoE yellow book is 'on'                                                          LLN022A
      *                                                                                      LLN022A
     C     LLN007        IFEQ      'Y'
     C                   WRITE     GL3572FA
      *                                                                                      LLN022A
      ** Set display file fields to blank                                                    LLN022A
      *                                                                                      LLN022A
     C                   MOVE      *BLANK        L#NETI                         Netting Ind.
     C                   MOVE      *BLANK        L#DPTP                         Deposit type
     C                   MOVE      *BLANK        L#SNOD                         SAYE/Shrsav nd
     C                   MOVE      *BLANK        L#LNTP                         Loan type
     C                   MOVE      *BLANK        L#MDAT                         Loan mat date
     C                   MOVE      *BLANK        L#LLIM                         Loan limit
     C                   ENDIF
     C*                                                                                      LLN022A
     C                   END
      *                                                                                       CGL018
      * Output RWA details for each account                                                   CGL018
      *                                                                                       CGL018
     C     CGL018        IFEQ      'Y'
     C                   EXSR      RWADTL
     C                   WRITE     GL3572F8
     C                   ENDIF
      *                                                                                       CGL018
     C/COPY WNCPYSRC,GL3572C001
     C     CER050        IFEQ      'Y'
     C     ACNO          CHAIN     REAPRHI0                           99
     C     *IN99         IFEQ      *OFF
     C                   Z-ADD     IAPRR         PAPRD
     C                   ELSE
     C                   Z-ADD     0             PAPRD
     C                   ENDIF
      *                                                                                       CER050
     C     ACNO          CHAIN     REAPRHI1                           99
     C     *IN99         IFEQ      *OFF
     C                   Z-ADD     IAPRR         PAPRC
     C                   ELSE
     C                   Z-ADD     0             PAPRC
     C                   ENDIF
     C                   WRITE     GL3572FC
     C                   ENDIF
      *                                                                                      LLN022A
      ** If yellow book feature is 'on'                                                      LLN022A
      *                                                                                      LLN022A
     C     LLN007        IFEQ      'Y'
      *                                                                                      LLN022A
      ** Convert 5-decimal date field to DDMMYY                                              LLN022A
      *                                                                                      LLN022A
     C                   Z-ADD     LMDAT         ZDAYNO
     C                   EXSR      ZDATE2
      *                                                                                      LLN022A
     C                   MOVEL     ZDATE         L#MDAT                         Loan Mat. Date
      *                                                                                      LLN022A
     C                   MOVEL     LNETI         L#NETI                         For Netting
     C                   MOVEL     LDPTP         L#DPTP                         Deposit type
     C                   MOVEL     LSNOD         L#SNOD                         SAYE/Sh not.day
     C                   MOVEL     LLNTP         L#LNTP                         Loan Type
     C                   MOVEL     LLLIM         L#LLIM                         Loan Limit
      *                                                                                      LLN022A
     C                   ENDIF
      *                                                                                      LLN022A
     C                   END
      *-------------------------------------------------------------------
     C*
     C/SPACE 3
     CLRN75
     CANN87              SETON                                        87
     CLR   NAUP          COMP      0                                      56
     CLR U1              GOTO      U1ON
     C*
     C*    COMPARE FILE CONTROL TOTALS.
     C*
     C*
     C** SKIP CONTROL CHECK WHEN SINGLE BRANCH IS SELECTED
     C*
     CLR   MBIN          IFEQ      'Y'
     CLR   BRNCH         ANDEQ     'ALL'
     CLR   MBIN          OREQ      'N'
     CLR   NINU          ADD       NORE          NORE                           INTERIM RUN
     CLR   NORE          ADD       NINP          NORE
     C*
     CLR   NREC          COMP      NORE                               U8U8
     CLR                 END
     C*
     C*    U1 ON INDICATES AMENDMENTS RUN.
     CLR                 GOTO      EMPTY
     C*
     CLR   U1ON          TAG                                                    ** U1ON TAG **
     C*
     C*    ACCUMULATE TOTALS.
     CLR   NINU          ADD       NINP          NOOP              5 0
     CLR   NOAM          ADD       NAMP          NOOM              5 0
     CLR   NOCL          SUB       NOCF          NOCLAC            5 0
     C*
     CLR   EMPTY         TAG
     CLR   MBIN          IFEQ      'Y'
     CLR   BRNCH         ANDNE     'ALL'
     CLR                 SETON                                        78
     CLR                 END
     C*
     CLR                 Z-ADD     SFNUMU        SFNUM2            6 0
     CLR                 OUT       LDA
     CLR                 CALL      'ZSFILE'
     CLR                 PARM                    SEQ
     CLR                 PARM      '     '       SENTY
     CLR                 PARM                    SFILEU
     CLR                 PARM                    SFNUM2
     CLR                 PARM      *BLANKS       ZSERR             1
     C*
     CLR   *LOCK         IN        LDA
     CLR   ZSERR         IFEQ      'Y'
     C*
     C* ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAMME
     C*
     CLR                 SETON                                        U7U8LR
     CLR                 RETURN
     CLR                 END
     C*
     CLR   MBIN          IFEQ      'Y'
     CLR   BRNCH         ANDEQ     'ALL'
     CLR   MBIN          OREQ      'N'
     C*
     C*    COMPARE ACCUMULATED AND CALCULATED TOTALS.
     C*
     C*  (ONLY TO BE DONE WHEN U1 IS ON AS TOTALISATION OF FIELDS
     C*  IS ONLY DONE IN AUDIT MODE - GLC3271.)
     CLR U1NOOP          COMP      CNINU                              2222
     CLR U1NOOM          COMP      CNOAM                              2323
     CLR U1NOCLAC        COMP      CNOCL                              2424
     CLR U1NOCF          COMP      CNOCF                              2525
     CLR U1NORD          COMP      CNORD                              2626
     C**
     C*
     CLR                 END
     C*
     C** PRINT NO DETAILS TO REPORT ON EXCEPTIONAL CASES
     C*
     CLR   *IN75         IFEQ      '1'
     CLR   *IN76         ANDEQ     '0'
     C**
     C**   ACCESS BANK DETAILS
     C**
     CLR                 CALL      'AOBANKR0'
     CLR                 PARM      '*MSG   '     @RTCD             7
     CLR                 PARM      '*FIRST '     @OPTN             7
     CLR   SDBANK        PARM      SDBANK        DSFDY
     C*
     CLR   @RTCD         IFNE      *BLANK
     CLR                 SETON                                        U7U8
     CLR                 MOVEL     'SDBANKPD'    DBFILE
     CLR                 MOVEL     @OPTN         DBKEY                          ***************
     CLR                 MOVEL     @OPTN         DBOPTN            7            * DBERROR 006 *
     CLR                 MOVEL     '006'         DBASE                          ***************
     CLR                 EXSR      *PSSR
     CLR                 END
     CLR                 WRITE     NODTL2
     CLR                 WRITE     NODTL2B
     CLR                 END
     C* End of report for last branch
     CLR   *IN75         IFEQ      '1'
     CLR   *INU7         ANDEQ     '0'
     CLR                 WRITE     GL3572FT
     CLR                 WRITE     GL3572FB
     CLR                 END
     C*
     CLR   *IN75         IFEQ      '0'
     CLR   BRNCH         ANDNE     'ALL'
     CLR   *IN89         ANDEQ     '0'
     C**
     C** CHECK THE MULTIBRANCHING INDICATOR
     CLR                 IN        RUNDT
     C*
     CLR   MBIN          IFEQ      'Y'
     CLR                 SETON                                        8788
     CLR                 OPEN      GL3572P1
     CLR                 Z-ADD     SFNUM         SFNUM1            6 0
     CLR                 OUT       LDA
     CLR                 CALL      'ZSFILE'
     CLR                 PARM                    SEQ
     CLR                 PARM      BRNCH         SENTY
     CLR                 PARM                    SFILE
     CLR                 PARM                    SFNUM1
     CLR                 PARM      *BLANKS       ZSERR             1
     C*
     CLR   *LOCK         IN        LDA
     CLR   ZSERR         IFEQ      'Y'
     C*
     C* ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAMME
     C*
     CLR                 SETON                                        U7U8LR
     CLR                 RETURN
     CLR                 END
     C** To get Branch Name
     C*LR*******           CALL 'AOBRCHR0'                                                    CGL029
     CLR                 CALL      'AOBRCHR1'
     CLR                 PARM      '*MSG   '     @RTCD             7
     CLR                 PARM      '*KEY   '     @OPTN             7
     CLR                 PARM      BRNCH         @DSNB             3
     C*LR******* SDBRCH    PARM SDBRCH    DSFDY                                               CGL029
     CLR   SDBRCH        PARM      SDBRCH        DSSDY
     CLR   @RTCD         IFNE      *BLANK
     CLR                 SETON                                        U7U8LR
     CLR                 MOVEL     'SDBRCHPD'    DBFILE
     CLR                 MOVEL     @DSNB         DBKEY                          ***************
     CLR                 MOVEL     @OPTN         DBOPTN            7            * DBERROR 013 *
     CLR                 MOVEL     '013'         DBASE                          ***************
     CLR                 EXSR      *PSSR
     CLR                 END
     C**
     C**   ACCESS BANK DETAILS
     C**
     CLR                 CALL      'AOBANKR0'
     CLR                 PARM      '*MSG   '     @RTCD             7
     CLR                 PARM      '*FIRST '     @OPTN             7
     CLR   SDBANK        PARM      SDBANK        DSFDY
     C*
     CLR   @RTCD         IFNE      *BLANK
     CLR                 SETON                                        U7U8
     CLR                 MOVEL     'SDBANKPD'    DBFILE
     CLR                 MOVEL     @OPTN         DBKEY                          ***************
     CLR                 MOVEL     @OPTN         DBOPTN            7            * DBERROR 007 *
     CLR                 MOVEL     '007'         DBASE                          ***************
     CLR                 EXSR      *PSSR
     CLR                 END
     CLRNU7              WRITE     NODTL2
     CLRNU7              WRITE     NODTL2B
     CLR U7              WRITE     NODTL
     CLR U7              WRITE     NODTLB
     CLR                 END
     CLR                 END
     C*
     CLR   *IN75         IFEQ      *OFF                                                        MD031
     C**   ACCESS BANK DETAILS                                            MD031966
     C**                                                                  MD031966
     CLR                 CALL      'AOBANKR0'                                                  MD031
     CLR                 PARM      '*MSG   '     @RTCD             7                           MD031
     CLR                 PARM      '*FIRST '     @OPTN             7                           MD031
     CLR   SDBANK        PARM      SDBANK        DSFDY                                         MD031
     C*                                                                   MD031966
     CLR   @RTCD         IFNE      *BLANK                                                      MD031
     CLR                 SETON                                        U7U8                     MD031
     CLR                 MOVEL     'SDBANKPD'    DBFILE                                        MD031
     CLR                 MOVEL     @OPTN         DBKEY                          ***************MD031
     CLR                 MOVEL     @OPTN         DBOPTN            7            * DBERROR 011 *MD031
     CLR                 MOVEL     '011'         DBASE                          ***************MD031
     CLR                 EXSR      *PSSR                                                       MD031
     CLR                 ELSE                                                                  MD031
     CLR                 TIME                    MTIME                                         MD031
     CLR                 MOVE      BJMRDT        RUNA                                          MD031
     CLR                 ENDIF                                                                 MD031
     CLR                 ENDIF                                                                 MD031
     C**                                                                  MD031966
     C/COPY WNCPYSRC,GL3572C026
     CLR   FINISH        TAG                                                    ** FINISH TAG *
      *-------------------------------------------------------------------
     C* Audit formats
     C** Initialisation of the output file fields if SADET empty          084517
     CLRN10              Z-ADD     0             NOCL                                          08451
     CLRN40              Z-ADD     0             NOCL                                          08451
     CLRN10              Z-ADD     0             NOCF                                          08451
     CLRN40              Z-ADD     0             NOCF                                          08451
     CLRN10              Z-ADD     0             NORD                                          08451
     CLRN40              Z-ADD     0             NORD                                          08451
     CLRN10              Z-ADD     0             NOOA                                          08451
     CLRN40              Z-ADD     0             NOOA                                          08451
     CLRN10              Z-ADD     0             NAUP                                          08451
     CLRN40              Z-ADD     0             NAUP                                          08451
     CLRN10              Z-ADD     0             CINUAF                                        08451
     CLRN40              Z-ADD     0             CINUAF                                        08451
     CLRN10              Z-ADD     0             COCLAF                                        08451
     CLRN40              Z-ADD     0             COCLAF                                        08451
     CLRN10              Z-ADD     0             COCFAF                                        08451
     CLRN40              Z-ADD     0             COCFAF                                        08451
     C*                                                                   084517
     CLR                 WRITE     GL3572AH
     CLRNU1              WRITE     GL3572A1
     CLR U1              WRITE     GL3572A2
     CLR U7              WRITE     GL3572A3
     CLR 87
     CANNU7
     CANN79              WRITE     NODTLT
     CLR                 WRITE     GL3572AT
      *-------------------------------------------------------------------
     C/COPY WNCPYSRC,GL3572C018
     C*
     C/COPY WNCPYSRC,GL3572C019
     C********************************************************************
     C**
     C**   SR. TO CONVERT A DAY NUMBER TO DATE FORMATS.
     C**
     CSR   ZDATE2        BEGSR                                                  ZDATE2 BEGSR
     C**
     C**   CLEAR DATE FIELDS.
     CSR                 Z-ADD     0             ZDATE             6 0
     CSR                 MOVEL     '       '     ZADATE            7
     C**
     C**   CALCULATION TO DEFINE INPUT DAY NUMBER.
     CSR                 Z-ADD     ZDAYNO        ZDAYNO            5 0
     C**
     C**   DETERMINE YEAR NUMBER.
     C**
     C**   ADJUST DAY NUMBER IN CASE LAST DAY OF YEAR.
     CSR   ZDAYNO        SUB       1             ZDAYN1            5 0  99
     CSR 99              GOTO      ZDEND2
     C**
     C**   CALCULATE NUMBER OF 4 YEAR SPANS SINCE 31/12/1971.
     CSR   ZDAYN1        DIV       1461          ZLYR              2 0
     CSR                 MVR                     ZDAYN1                         SAVE REMAINING
     C**                                                   DAYS.
     C**   CALCULATE NUMBER OF REMAINING YEARS.
     CSR                 Z-ADD     1             ZWRK2             2 0
     CSR   ZDTAG1        TAG                                                    ZDTAG1 TAG
     CSR   ZDAYN1        COMP      ZYDY(ZWRK2)                          90
     CSRN90ZWRK2         ADD       1             ZWRK2
     CSRN90              GOTO      ZDTAG1
     CSR   ZWRK2         SUB       1             ZWRK2                    91    LEAP YR, 91 ON.
     C**
     C**   DECREMENT DAY NO. BY DAYS IN REMAINING YEARS.
     CSRN91ZDAYN1        SUB       ZYDY(ZWRK2)   ZDAYN1
     C**
     C**   CALCULATE ACTUAL YEAR NUMBER.
     CSR   ZLYR          MULT      4             ZWRK3             3 0
     CSR   ZWRK3         ADD       72            ZWRK3                          BASE IS 1972.
     CSR                 Z-ADD     ZWRK3         ZYEAR             2 0
     CSR   ZYEAR         ADD       ZWRK2         ZYEAR                          YEAR.
     C**
     C**   DETERMINE MONTH NUMBER.
     C**
     C**   ADJUST DAY NO. IN CASE LAST DAY OF LEAP YEAR FEBRUARY.
     CSR                 SETOFF                                       9293
     CSR 91ZDAYN1        COMP      59                                   9293
     CSR 91
     CANN92ZDAYN1        SUB       1             ZDAYN1
     C**
     C**   CALCULATE MONTH NUMBER.
     CSR                 Z-ADD     2             ZWRK2
     CSR   ZDTAG2        TAG                                                    ZDTAG2 TAG
     CSR   ZDAYN1        COMP      ZMDY(ZWRK2)                          94
     CSRN94ZWRK2         ADD       1             ZWRK2
     CSRN94              GOTO      ZDTAG2
     CSR   ZWRK2         SUB       1             ZWRK2
     C**
     CSR                 Z-ADD     ZWRK2         ZMTH              2 0          MONTH.
     C**
     C**   DETERMINE DAY OF MONTH.
     C**
     C**   ADD BACK LAST DAY OF YEAR ADJUSTMENT.
     CSR   ZDAYN1        ADD       1             ZDAYN1
     C**
     C**   CALCULATE DAY OF MONTH.
     CSR   ZDAYN1        SUB       ZMDY(ZWRK2)   ZDAY              2 0          DAY.
     C**
     C**   ADD BACK LEAP YEAR 29TH FEBUARY ADJUSTMENT, IF REQUIRED.
     CSR 93ZDAY          ADD       1             ZDAY
     C**
     C**   FORMAT DATE, DDMMYY OR MMDDYY.
     CSRN98              MOVEL     ZDAY          ZWRK4             4 0
     CSR 98              MOVE      ZDAY          ZWRK4
     CSRN98              MOVE      ZMTH          ZWRK4
     CSR 98              MOVEL     ZMTH          ZWRK4
     CSR                 MOVEL     ZWRK4         ZDATE
     CSR                 MOVE      ZYEAR         ZDATE
     C**
     C**   FORMAT ALPHA DATE, DDMMMYY.
     CSR   ZDAY          COMP      10                                   95
     CSR                 MOVEL     ZDAY          ZWRK5             5
     CSR 95              MOVEL     ' '           ZWRK5
     CSR                 MOVE      ZMNM(ZMTH)    ZWRK5
     CSR                 MOVEL     ZWRK5         ZADATE
     CSR                 MOVE      ZYEAR         ZADATE
     C**
     CSR   ZDEND2        ENDSR                                                  ZDEND2 ENDSR
     C**
     C**
     C********************************************************************
     C**
     C**   SR. TO SET UP AN ARRAY OF CURRENCIES AND AN ARRAY OF
     C**   DECIMAL PLACES FOR THOSE CURRENCIES.
     C**
     C     CCYARR        BEGSR                                                  *** CCYARR  ***
     C**
     C**   SET OFF ERROR INDICATOR
     C                   SETOFF                                       99
     C**
     C**   SET ARRAY INDEX TO ZERO.
     C                   Z-ADD     0             X                 3 0
     C**
     C**   SET UP KEY FOR CURRENCY TABLE.
     C                   MOVE      *BLANKS       W@CKEY            3
     C**
     C**   SET LOWER LIMIT AND READ CURRENCY TABLE HEADER.
     C     W@CKEY        SETLL     SDCURRL0
     C**
     C**   LOOP TO READ CURRENCY DETAIL RECORDS.
     C     XLOOP         TAG                                                    ** XLOOP TAG **
     C                   READ      SDCURRL0                               99
     C**
     C**   END IF ALL CURRENCY RECORDS PROCESSED
     C   99              GOTO      XEND
     C**
     C**   INCREMENT ARRAY INDEX.
     C     X             ADD       1             X
     C**
     C**   MOVE DATA INTO ARRAYS.
     C                   MOVE      A6CYCD        CCYA(X)
     C                   MOVE      A6NBDP        DPA(X)
     C**
     C**   CHECK FOR FULL ARRAY.96 ON IF FULL.
     C     X             COMP      150                                    96
     C**
     C**   GO TO READ NEXT RECORD.
     C  N96              GOTO      XLOOP
     C**
     C     XEND          TAG                                                    ** XEND TAG  **
     C                   ENDSR
     C**
     C********************************************************************
      * Include ZEDIT for german standards
     C********************************************************************
     C**                                                                 *
     C**  GEDIT SUBROUTINE TO INSERT A DECIMAL POINT INTO A NUMERIC FIELD*
     C**  AND TO BLANK OUT LEADING ZEROES.                               *
     C**      INPUT FIELDS:   ZFIELD 16/                                 *
     C*                       ZADEC                                      *
     C*                       ZADIG - NOT ACTUALLY USED                  *
     C*                                                                  *
     C*       ARRAYS    ZA1 ,ZA2   BOTH 16 ELEMENTS, EACH ONE BYTE LONG. *
     C*                                                                  *
     C*       OUTPUT FIELD   ZFIELD                                      *
     C*                                                                  *
     C     GEDIT         BEGSR                                                  ***  GEDIT  ***
     C**
     C**   CALCULATION TO DEFINE NUMBER STRUCTURE CONTROL FIELDS.
     C                   Z-ADD     ZADIG         ZADIG             2 0
     C                   Z-ADD     ZADEC         ZADEC             1 0
     C**                                                                 *
     C*       SET UP WORK FIELDS                                         *
     C*                                                                  *
     C                   MOVEA     ' '           ZA1                                          *
     C                   MOVEA     ' '           ZA2                                          *
     C*                                                                  *
     C                   Z-ADD     16            Z1                2 0                        *
     C                   Z-ADD     16            Z2                2 0                        *
     C*                                                                  *
     C     16            SUB       ZADEC         ZADEC2            2 0                        *
     C*                                                                  *
     C*
     C                   MOVEA     ZFIELD        ZA1                                          *
     C*                                                                  *
     C*       CHECK TO SEE IF THERE ARE ANY DECIMAL PLACES               *
     C*                                                                  *
     C     ZADEC         COMP      0                                      91                  *
     C   91              GOTO      ZT20                                                       *
     C**                                                                 *
     C     ZT10          TAG                                                    ** ZT10 TAG ***
     C**                                                                 *
     C*                                                                  *
     C*       SET UP DECIMALS                                            *
     C*                                                                  *
     C                   MOVE      ZA1(Z1)       ZA2(Z2)                                      *
     C     Z1            SUB       1             Z1                                           *
     C     Z2            SUB       1             Z2                                           *
     C*                                                                  *
     C     Z2            COMP      0                                      90                  *
     C   90              GOTO      ZT30                                                       *
     C*                                                                  *
     C*       CHECK IF END OF DECIMALS                                   *
     C**                                                                 *
     C     Z2            COMP      ZADEC2                             90                      *
     C   90              GOTO      ZT10                                                       *
     C*                                                                  *
     C**                                                                 *
     C*       PUT IN DECIMAL PLACE                                       *
     C*                                                                  *
     C                   MOVE      ','           ZA2(Z2)                                      *
     C     Z2            SUB       1             Z2                                           *
     C*                                                                  *
     C     ZT20          TAG                                                    ** ZT20 TAG ***
     C*                                                                  *
     C*       SET UP INTEGERS                                            *
     C*                                                                  *
     C                   MOVE      ZA1(Z1)       ZA2(Z2)                                      *
     C     Z1            SUB       1             Z1                                           *
     C     Z2            SUB       1             Z2                                           *
     C**                                                                 *
     C     Z2            COMP      0                                  90                      *
     C   90              GOTO      ZT20                                                       *
     C*                                                                  *
     C*       PUT IN LEADING BLANKS                                      *
     C*                                                                  *
     C     ZT30          TAG                                                    ** ZT30 TAG ***
     C**                                                                 *
     C                   Z-ADD     1             Z2                                           *
     C**                                                                 *
     C     ZT40          TAG                                                    ** ZT40 TAG ***
     C*                                                                  *
     C     ZA2(Z2)       COMP      '0'                                9090                    *
     C   90ZA2(Z2)       COMP      ' '                                9090                    *
     C*                                                                  *
     C   90              GOTO      ZT50                                                       *
     C*                                                                  *
     C                   MOVE      ' '           ZA2(Z2)                                      *
     C     Z2            ADD       1             Z2                                           *
     C*                                                                  *
     C     Z2            COMP      16                                   90                    *
     C   90              GOTO      ZT40                                                       *
     C*                                                                  *
     C*       IF NO INTEGERS PUT IN LEADING ZERO                         *
     C*                                                                  *
     C     ZT50          TAG                                                    ** ZT50 TAG ***
     C*                                                                  *
     C                   Z-ADD     ZADEC2        Z2                                           *
     C  N91Z2            SUB       1             Z2                                           *
     C     ZA2(Z2)       COMP      ' '                                    90                  *
     C   90              MOVE      '0'           ZA2(Z2)                                      *
     C*                                                                  *
     C*       SET UP OUTPUT FIELD                                        *
     C*                                                                  *
     C     ZT60          TAG                                                    ** ZT60 TAG ***
     C*                                                                  *
     C                   MOVEA     ZA2           ZFIELD           16                          *
     C**                                                                 *
     CSR   GEND          ENDSR                                                  ** GEND **    *
     C**
     C********************************************************************
     C*
     C* *PSSR  --- SUBROUTINE TO HANDLE ABNORMAL ERROR CONDITIONS
     C*
     C* CALLED FROM: AFTER ABNORMAL OPERATION OCCURS
     C*
     C* CALLS: NOTHING
     C*
     C********************************************************************
     C*
     C     *PSSR         BEGSR                                                  ** *PSSR **
     C*
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
     C*
     C                   ENDSR                                                  ** *PSSR **
     C*****************************************************************
     C*                                                                                       208221
     C*COPY*ZSRSRC,ZSEDITZ3                                                          208221 MD056557
     CSR   ZSEDIT        BEGSR                                                  **  ZSEDIT  MD056557
      *                                                                                     MD056557
      * Define/Clear fields                                                                 MD056557
      *                                                                                     MD056557
     C                   Z-ADD     ZFLD15        ZFLD15           15 0                      MD056557
     C                   Z-ADD     ZDECS         ZDECS             1 0                      MD056557
     C                   MOVE      ZECODE        ZECODE            1                        MD056557
     C                   MOVE      *BLANKS       ZOUT21           21                        MD056557
      *                                                                                     MD056557
      * SET UP WORK FIELDS                                                                  MD056557
      *                                                                                     MD056557
     C                   Z-ADD     0             ZS1                                        MD056557
     C                   Z-ADD     0             ZS1X                                       MD056557
     C                   MOVE      ' '           ZS2                                        MD056557
      *                                                                                     MD056557
     C                   Z-ADD     15            Z1                2 0                      MD056557
     C                   Z-ADD     20            Z2                2 0                      MD056557
      *                                                                                     MD056557
     C     15            SUB       ZDECS         ZINTS             2 0                      MD056557
      *                                                                                     MD056557
      * Check if numeric field is negative                                                  MD056557
      *                                                                                     MD056557
     C     ZFLD15        IFLT      *ZEROS                                                   MD056557
     C                   MOVE      '-'           ZS2(21)                                    MD056557
     C                   Z-SUB     ZFLD15        ZFLD15                                     MD056557
     C                   END                                                                MD056557
      *                                                                                     MD056557
     C                   Z-ADD     ZFLD15        WORK15                                     MD056557
     C                   MOVEL     ZS1X          ZS1                                        MD056557
      *                                                                                     MD056557
      * CHECK TO SEE IF THERE ARE ANY DECIMAL PLACES                                        MD056557
      *                                                                                     MD056557
     C     ZDECS         CABEQ     0             ZS10                                       MD056557
      *                                                                                     MD056557
      * SET UP DECIMALS                                                                     MD056557
      *                                                                                     MD056557
     C                   Z-ADD     *ZEROS        ZCNT              1 0                      MD056557
     C     ZCNT          DOUEQ     ZDECS                                                    MD056557
     C                   MOVE      ZS1(Z1)       ZS2(Z2)                                    MD056557
     C                   SUB       1             Z2                                         MD056557
     C                   ADD       1             ZCNT                                       MD056557
     C                   SUB       1             Z1                                         MD056557
     C                   END                                                                MD056557
      *                                                                                     MD056557
      * PUT IN DECIMAL PLACE                                                                MD056557
      *                                                                                     MD056557
     C                   MOVE      '.'           ZS2(Z2)                                    MD056557
     C                   SUB       1             Z2                                         MD056557
      *                                                                                     MD056557
     C     ZS10          TAG                                                    ** ZS10 TAG MD056557
      *                                                                                     MD056557
      * SET UP INTEGERS                                                                     MD056557
      *                                                                                     MD056557
     C                   Z-ADD     *ZEROS        CNT3              1 0                      MD056557
     C     Z1            DOUEQ     *ZEROS                                                   MD056557
     C                   MOVE      ZS1(Z1)       ZS2(Z2)                                    MD056557
     C                   SUB       1             Z1                                         MD056557
     C                   SUB       1             Z2                                         MD056557
      *                                                                                     MD056557
      * If edit code is 'J', insert a ',' before each group of three                        MD056557
      * digits - not if beginning of array reached.                                         MD056557
      *                                                                                     MD056557
     C     Z2            IFGT      *ZEROS                                                   MD056557
     C     ZECODE        ANDEQ     'J'                                                      MD056557
     C                   ADD       1             CNT3                                       MD056557
     C     CNT3          IFEQ      3                                                        MD056557
     C                   MOVE      ','           ZS2(Z2)                                    MD056557
     C                   SUB       1             Z2                                         MD056557
     C                   Z-ADD     *ZEROS        CNT3                                       MD056557
     C                   END                                                                MD056557
     C                   END                                                                MD056557
      *                                                                                     MD056557
     C                   END                                                                MD056557
      *                                                                                     MD056557
      * PUT IN LEADING BLANKS                                                               MD056557
      *                                                                                     MD056557
     C                   Z-ADD     1             Z2                                         MD056557
     C     ZS2(Z2)       DOWEQ     '0'                                                      MD056557
     C     ZS2(Z2)       OREQ      ' '                                                      MD056557
     C     ZS2(Z2)       OREQ      ','                                                      MD056557
     C                   MOVE      ' '           ZS2(Z2)                                    MD056557
     C                   ADD       1             Z2                                         MD056557
     C     Z2            CABEQ     22            ZS20                                       MD056557
     C                   END                                                                MD056557
      *                                                                                     MD056557
      * IF NO INTEGERS PUT IN LEADING ZERO                                                  MD056557
      *                                                                                     MD056557
     C     ZS20          TAG                                                    ** ZS20 TAG MD056557
      *                                                                                     MD056557
     C     Z2            IFEQ      22                                                       MD056557
     C                   SUB       2             Z2                                         MD056557
     C                   MOVE      '0'           ZS2(Z2)                                    MD056557
     C                   ELSE                                                               MD056557
      *                                                                                     MD056557
     C     ZS2(Z2)       IFEQ      '.'                                                      MD056557
     C                   SUB       1             Z2                                         MD056557
     C                   MOVE      '0'           ZS2(Z2)                                    MD056557
     C                   END                                                                MD056557
     C                   END                                                                MD056557
      *                                                                                     MD056557
      * SET UP OUTPUT FIELD                                                                 MD056557
      *                                                                                     MD056557
     C                   MOVEA     ZS2           ZOUT21                                     MD056557
      *                                                                                     MD056557
     CSR                 ENDSR                                                              MD056557
      *******************************************************************                   MD056557
     C*                                                                                       208221
      * RWA       : Output RWA information from GLORWAPD                *                     CGL018
      * ---                                                             *                     CGL018
      * Called By : CAPRDT                                              *                     CGL018
      * Calls     : None                                                *                     CGL018
      *******************************************************************                     CGL018
     C     RWADTL        BEGSR
      *                                                                                       CGL018
     C     KREKEY        SETLL     GLARWAD0
     C     KREKEY        READE     GLARWAD0                               97
     C                   MOVE      *BLANKS       XRWA
     C                   MOVEL     *BLANKS       RWASE
     C                   MOVEL     *BLANKS       RWASEC
     C                   MOVEL     *BLANKS       #CONTI
     C                   Z-ADD     0             U                 2 0
     C     *IN97         DOWEQ     '0'
      *                                                                                       CGL018
     C                   ADD       1             U
     C                   MOVE      RWCODE        #RCODE
     C                   MOVE      RWSETN        #RSET
      *                                                                                       CGL018
     C     U             IFGT      18
     C     #CONTI        ANDNE     'C'
     C                   Z-ADD     1             U
     C                   MOVEL     'C'           #CONTI            1
     C                   MOVEL     *BLANKS       RWASE
     C                   MOVEA     XRWA          RWASE
     C                   MOVE      *BLANKS       XRWA
     C                   ENDIF
      *                                                                                       CGL018
     C                   MOVEA     RWSECO        XRWA(U)
      *                                                                                       CGL018
     C     KREKEY        READE     GLARWAD0                               97
     C                   ENDDO
      *                                                                                       CGL018
     C     U             IFEQ      0
     C                   MOVEL     'None'        RWASE
     C                   ELSE
      *                                                                                       CGL018
      * Last one must be without comma, so clear and output again                             CGL018
      *                                                                                       CGL018
     C                   MOVEL     *BLANKS       #COMMA
     C                   MOVEA     RWSECO        XRWA(U)
      *                                                                                       CGL018
     C     #CONTI        IFEQ      'C'
     C                   MOVEA     XRWA          RWASEC
     C                   ELSE
     C                   MOVEA     XRWA          RWASE
     C                   ENDIF
      *                                                                                       CGL018
     C                   MOVEL     ','           #COMMA
     C                   ENDIF
      *                                                                                       CGL018
     C                   ENDSR
      *******************************************************************                     CGL018
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA ZYDY
0366073110961461
**CTDATA ZMDY
000031059090120151181212243273304334365
**CTDATA ZMNM
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
