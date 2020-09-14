     H DEBUG
      *****************************************************************
/*S*D****RPGBASE*******************************************************                      CER073D
/*STD *  RPGBASEBND                                                   *                      CER073D
/*EXI *  ALWNULL(*USRCTL)                                             *                      CER073D
/*EXI *  TEXT('Midas LE Loans and parts purch & sold maintenance')    *
0003 F*****************************************************************
0002 F*                                                               *
     F*  Midas - Customer Lending Module                              *
0005 F*                                                               *
0006 F*  LE0310 - LOANS AND PARTICIPATIONS INPUT TODAY PRINT          *
0007 F*                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CER073D            Date 13Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD054605           Date 17Oct19               *
      *                 CLE071             Date 18Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 CER073C            Date 09Oct17               *
      *                 CER073B            Date 25Sep17               *
      *                 CER073A            Date 05Sep17               *
      *                 CER073             Date 10Jul17               *
      *                 CLE141             Date 08Feb16               *
      *                 MD021416           Date 09Mar15               *
      *                 AR847588           Date 09Mar15               *
      *                 AR833482           Date 09Mar15               *
      *                 MD020563           Date 21May13               *
      *                 AR1097176          Date 22Mar13               *
      *                 CFC006             Date 06Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR944795           Date 30Mar12               *
      *                 AR852289           Date 07Dec11               *
      *                 AR823767           Date 02Sep11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 AR787620           Date 10Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 247519             Date 11May07               *
      *                 244691             Date 18Apr07               *
      *                 245014             Date 22Jan07               *
      *                 236008             Date 03Nov06               *
      *                 BUG13338           Date 14Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242055             Date 20Sep06               *
      *                 241660             Date 17Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 237732             Date 20Jun06               *
      *                 BUG11610           Date 26Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CER001             Date 25Apr05               *
      *                 BUG9103            Date 26Oct05               *
      *                 BUG8954            Date 12Oct05               *
      *                 BUG8940            Date 11Oct05               *
      *                 CLE038             Date 11May04               *
      *                 CLE036             Date 22Sep03               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP074             Date 15Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 05Feb03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CLE028             Date 27Jun02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 196066             Date 10Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 193859             Date 19Nov01               *
      *                 CLE015             Date 13Dec01               *
      *                 199886             Date 08Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 04Apr00               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CLE011             Date 07Nov00               *
      *                 187663             Date 17Jan01               *
      *                 187904             Date 12Jan01               *
      *                 186808             Date 04Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 13Aug99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 154567             Date 04Feb99               *
      *                 147994             Date 06Jan99               *
      *                 147935             Date 02Dec98               *
      *                 140822             Date 15Feb99               *
      *                 140821             Date 15Feb99               *
     F*                 148631             Date 09DEV98               *
     F*                 CEU020             Date 13Mar98               *
     F*                 107009             Date 17Feb98               *
     F*                 CLE005             Date 22May97               *
     F*                 122653             Date 05Sep97               *
     F*                 121520             Date 06Aug97               *
     F*                 CLE006             Date 02Dec96               *
     F*                 CLE004             Date 02Dec96               *
     F*                 S01408             DATE 04OCT96               *
     F*                 S01408             DATE 04SEP96               *
     F*                 S01408             DATE 12AUG96               *
     F*                 CAC001             DATE 01FEB96               *
     F*                 088373             DATE 03JUL96               *
     F*                 S01408             DATE 22MAY96               *
     F*                 S01408             DATE 26APR96               *  *S01392
     F*                 S01408             DATE 08FEB96                  *S01392
     F*                 S01408             DATE 08JAN96               *  *S01392
     F*                 S01408             DATE 11DEC95               *
     F*                 088897             DATE 24OCT95               *
     F*                 S01408             DATE 05OCT95                  *S01392
     F*                 S01408             DATE 05SEP95               *  *S01392
     F*                 088426             DATE 21JUN95               *
     F*                 086726             DATE 15JUN95               *
     F*                 S01408             DATE 22FEB95               *
     F*                 S01486             DATE 22NOV94               *
     F*                 S01518             DATE 03OCT94               *
     F*                 S01408             DATE 19AUG94               *
     F*                 S01408             DATE 18MAY94               *
     F*                 071036             DATE 16MAY94               *
     F*                 070711             DATE 12MAY94               *
     F*                 S01465             DATE 22MAR94               *
     F*                 S01393             DATE 30OCT92               *
     F*                 S01392             DATE 16SEP92               *
     F*                 S01220             DATE 22AUG90               *
     F*                 S01270             DATE 02AUG90               *
     F*                 LN0143             DATE 03JAN90               *
     F*                 S01194             DATE 03JAN90               *
     F*                 S01117             DATE 22/06/89              *
     F*                                                               *
     F*---------------------------------------------------------------*
      *                                                               *
      *  CER073D - Upgrade of EML014 to FB2.1 SP23                    *
      *      EML014 - AnaCredit Reporting Enhancement                 *
      *  CER050 - Annualised Percentage Rate                          *
      *           Applied for MD-55510.
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  CER073C - CER073 Change Control 3                            *
      *  CER073B - CER073 Change Control 2                            *
      *  CER073A - CER073 Change Control 1                            *
      *  CER073 - AnaCredit Reporting                                 *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           for LE Transactions                                 *
      *  MD021416 - Minus sign is missing in Rollover spread rate.    *
      *             Add minus sign for NRTS output field.             *
      *           - Applied for MD033488                              *
      *  AR847588 - Ensure that spread rate is shown as negative in   *
      *             the report if it is negative. (Child: AR847589)   *
      *           - Applied for MD033488                              *
      *  AR833482 - Amended program to ensure that negative sign for  *
      *             calculated interest is properly shown in LE0310P1.*
      *           - Applied for MD033488                              *
      *  MD020563 - CFC006 issues                                     *
      *  AR1097176 - Accessing AOCOMR0 multiple times slows down the  *
      *              system                                           *
      *  CFC006 - COB Restructure - Remove reports from COB           *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR944795 - Effective Annual Interest Rate and amount is not  *
      *             in LE0310P1 report                                *
      *  AR852289 - Alignment of Effective Annual Interest Rate in    *
      *             LE0310P1 report                                   *
      *  AR823767 - Incorrect Effective Annual Interest Rate value in *
      *             LE0310P1 report                                   *
      *  CRE073 - Interest Rate Rounding                              *
      *  CLE143 - Original Loan Contract Date and Effective Interest  *
      *           Rate                                                *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00008                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  247519 - Database error occurs when processing loans inser-  *
      *           ted via Loan IQ.                                    *
      *  244691 - Re-positioning of fields (BASE RATE, ROLLOVER BASE  *
      *           RATE, BASE CCY RATE, FCLT CCY RATE)
      *  245014 - Display Rollover Rate Fixing Days field on the      *
      *           report. Applied fix BUG8548.                        *
      *  236008 - When trailer does not match, do not halt COB.       *
      *           Show audit report for information purposes only.    *
      *  BUG13338 - Incorrect Customer Name compared to Participation *
      *             Purchased detail enquiry                          *
      *  242055 - Overprinting report.(Recompile)                     *
      *  241660 - Purchased from party is reported as customer. Fix   *
      *           to move and rename Purchased From field in place of *
      *           customer number and vice versa for participation    *
      *           purchased loan. Apply 199458.                       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  237732 - Output amount for loan principal transfers.         *
      *           Apply 216607 and 222408.                            *
      *  BUG11610 - COCU with '000000' value not filtered             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *           Internalise IML/IBLC                                *
      *  BUG9103- Missing Loan fields in Loan Maintenance Today       *
      *           Report                                              *
      *  BUG8954- Settlement Pay/Rec Details not in Loan              *
      *           Maintenance Today Report                            *
      *  BUG8940- Base rate code is indicated for loan that has a     *
      *           base rate                                           *
      *  CLE038 - Lending Enhancement for Nordea: Allocation by Amount*
      *  CLE036 - LE Enh for Nordea Phase 1 Pty 2 - Specific Base Rate*
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *  CLE031 - Lending Enhancements.                               *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enahancements to CAS001, CAS002 and CAS004          *
      *           (Recompile)                                         *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *  196066 - Insert/Amend/Authorise user blank when CLE002 is    *
      *           off. Fix is to only display the fields when CLE002  *
      *           (Authorisation) feature is switched on.             *
      *  193859 - Wrong decimal places being used when editing field  *
      *           New facility ccy exchange rate (NFCE).              *
      *  CLE015 - Functionality moved from Syndicated Lending to      *
      *           Customer Lending                                    *
      *  199886 - When rollover detail is reported in LE0310P1, the   *
      *           amending user is not shown although status is 'A'.  *
      *           Add Rollover Amend User Profile & Rollover Authorise*
      *           User Profile fields to LE0310P1/P2 reports.         *
      *  CDE002 - Revenue Analysis                                    *
      *  CLE011 - Rate Fixing Days for Lending Rollover Processing    *
      *  187663 - Do not print LE0300P2 if Syndicated Lending         *
      *           Enhancement CLE006 is switched off.                 *
      *  187904 - Do not print Transfer of Principal Details if       *
      *           CLE006 is switched off.                             *
      *  186808 - Portfolio Reference description is not aligned on   *
      *           the report. Also, Portfolio Reference should not be *
      *           blank.  Recompile due to changes in CLOANL1.        *
      *  CPB001 - 'Private Banking' Module                            *
      *  154567 - Authorising user always blank                       *
      *  147994 - Negative amounts shown and Mult/Div indicators      *
      *           missing.                                            *
      *  147935 - Addition of insert, authorise and amend user        *
      *           profiles to lending reports                         *
      *  140822 - LE0310P2 should show the participant facility       *
      *           + borrower facility.                                *
      *  140821 - Prime loan in a syndication is appearing on the     *
      *           LE0310P1 report.  It should be on the LE0310P2.     *
      *           LE0310P2 should include the loan being syndicated   *
     F*  148631 - CHECK DECIMAL FOR NEW CURRENCY WHEN USED            *
     F*  CEU020 - EMU Lending Multi-currency Rollover                 *
     F*  107009 - Receiver number is not printed                      *
     F*  CLE005 - Customer Lending Enhancements - Tranche 3           *
     F*  122653 - Recompiled over amended LE0310P2                    *
     F*  121520 - Already locked lda causes problem in call to zsfile *
     F*  CLE006 - Customer Lending Enhancements - Rollovers           *
     F*  CLE004 - Customer Lending Enhancements - Syndications        *
     F*  S01408 - Correction of core hook LE0310CCP2                  *
     F*  S01408 - Addition of core hooks LE0310CCP8                   *
     F*  S01408 - Addition of core hooks LE0310OOP9                   *
     F*         - Addition of core hooks LE0310CCP7                   *
     F*  CAC001 - Print New Funding Spread/Rate and New Funding Sign. *
     F*         - Profit Centre Accounting Development:               *
     F*           If Analytical Accounting is installed, margin profit*
     F*           centre and funding details on each loan will be     *
     F*           printed.                                            *
     F*  088373 - Move settlement instructions onto the next page     *
     F*  S01408 - Addition of core hooks LE0310OOP8                   *
     F*  S01408 - Addition of core hooks LE0310FFP2                   *
     F*           Addition of core hooks LE0310CCP6                   *
     F*           Addition of core hooks LE0310CCP5                   *
     F*           Addition of core hooks LE0310OOP7                   *
     F*           Addition of core hooks LE0310OOP6                   *
     F*  S01408 - Addition of core hooks LE0310CCP3                   *
     F*           Addition of core hooks LE0310CCP4                   *
     F*           Addition of core hooks LE0310OOP4                   *
     F*           Addition of core hooks LE0310OOP5                   *
     F*  S01408 - Core hook LE0310IIPG added                          *
     F*  S01408 - Addition of core hooks LE0310CCP2                   *
     F*                                  LE0310OOP3                   *
     F*  088897 - Conflicting usage of indicators causes error.       *
     F*  S01408 - Core hook LE0310OOP2 added                          *
     F*  S01408 - Core hook LE0310CCP1 added                          *
     F*         - Core hook LE0310FFP1 added                          *
     F*         - Core hook LE0310OOP1 added                          *
     F*  088426 - New fields int pay date and maturity date must be   *
     F*           shown if features S01465 and S01518 are on.         *
     F*  086726 - New Rollover interest payment date must be show on  *
     F*           report only when field <> 0 and feature S01465 is on*
     F*  S01408 - Core hook LE0310OP4  added                          *
     F*  S01486 - Portfolio Management Upgrade to Release 10.         *
     F*  S01518 - BLI Lending Swift Enhancements.                     *
     F*           Applied fix BL0015 and BL0016.                      *
     F*  S01408 - Core hook LE0310PDR  added                          *
     F*           Core hook LE0310OP2  added                          *
     F*           Core hook LE0310OP3  added                          *
     F*  S01408 - Core hook LE0310OLH1 added                          *
     F*           Core hook LE0310OLH2 added                          *
     F*           Core hook LE0310CRSP added                          *
     F*           Core hook LE0310CCPG added                          *
     F*           Core hook LE0310FFPG added                          *
     F*  071036 - Original maturity written even when there's nothing *
     F*           to report                                           *
     F*  070711 - Change in the design of the report layout           *
     F*  S01465 - BLI Lending and Guarantees Issued Enhancement.      *
     F*  S01393 - RECOMPILE FOR STRATEGIC RISK MANAGEMENT             *
     F*  S01392 - JAPANESE SUB MODULE ENHANCEMENTS                    *
     F*  S01220 - Amended for Strategic Risk Management Release 10    *
     F*           to include Book Code field.                         *
     F*  S01270 - CUSTOMER LENDING CHANGES                            *
     F*  LN0143 - RUN CONTROLS INCORRECTLY CALCULATED                 *
     F*  S01194 - STANDING DATA CHANGES.                              *
     F*  S01117 - MULTIBRANCHING.                                     *
     F*                                                               *
0012 F*****************************************************************
0013 F*                                                               *
     F*  C R E A T I O N     P A R A M E T E R S                      *
     F*                                                               *
     F*                                                               *
     F*****************************************************************
0014 F*LOAN***IP**F     400  7AI     2 DISK                               S01117
0014 FCLOANL1   IP   E           K DISK                                         S01117
     F/COPY WNCPYSRC,LE0310F001
0015 F*CLONT***UF**F*****400  7AI     2 DISK                        S01220S01270
     F***CLONT***UF**F     436  7AI     2 DISK                     S01270 S01465
     F***CLONT***UF**F     458  7AI     2 DISK                     S01465 S01518
     F***CLONT***UF  F    1087  7AI     2 DISK                     S01518 S01486
     F***CLONT***UF**F    1092  7AI     2 DISK                     S01486 CAC001
     F*CLONT**UF**F    1187  7AI     2 DISK                                            CAC001 CLE031
     F*CLONT**UF**F    1374  7AI     2 DISK                                            CLE031 CAP074
     FCLONT     UF   F 1560     7AIDISK    KEYLOC(2)
0016 F*CLINT***IF  F     256  7AI     2 DISK                              S01194
0017 F*TABLE***IF  F      96 12AI     2 DISK                              S01194
     F*                                                                   S01408
     FLELOANL8  IF   E           K DISK                                         140821
     F                                     RENAME(CLOANCLF:LELOAN8F)            140821
     F/COPY WNCPYSRC,LE0310FFP1                                           S01408
     FLELOAML7  IF   E           K DISK
     F*                                                                   S01408
     FLECLX1L0  IF   E           K DISK
      ** ER Customer Loans - LUX Extension file                                               CER001
     FFCLTYL1   IF   E           K DISK                                         140821
     FLESTALL5  IF   E           K DISK
     FSDCURRPD  IF   E             DISK
     FLEAPRHI0  IF   E           K DISK
     FLEANACI1  IF   E           K DISK
      ** CER073 AnaCredit - Loans Extension File                                              CER073
0018 F*E0310P1O   F     132     OF     PRINTER                      S01124S01117
     FLE0310AU  O    F  132        PRINTER INFDS(SPOOLU)                        S01117
     F                                     OFLIND(*INOA)
     F*                                                                   S01408
     F/COPY WNCPYSRC,LE0310FFP2                                           S01408
     F*                                                                   S01408
     FLE0310P1  O    F  132        PRINTER INFDS(SPOOL)                         S01117
     F                                     OFLIND(*INOF)
     F                                     USROPN
     F***LE0310P2O   E                    PRINTER      KINFDS SPOOL2     UC            CLE004 CLE034
     FLE0310P2  O    E             PRINTER INFDS(SPOOL2)
     F                                     OFLIND(*IN83)
     F                                     USROPN
0019 F**
     F*                                                                   S01408
     F** Core hook for externalisation.                                   S01408
     F/COPY WNCPYSRC,LE0310FFPG                                           S01408
     F*                                                                   S01408
0020 F* ID F  C  H  L    FUNCTION OF INDICATORS
0021 F**01************CLOAN*-*HEADER***********************************   S01117
0022 F**02******************-DETAIL*REC.1*-LIVE************************   S01117
     F*       01      BASR is not Empty                                                       CLE036
0022 F* 02          CLOANL1 -DETAIL REC.1 -LIVE                           S01117
0023 F* 03                     "      "   -MATURED
0024 F* 04                     "      "   -REVERSED
0025 F* 05                  -DETAIL REC.2 -LIVE
0026 F* 06                     "      "   -MATURED
0027 F* 07                     "      "   -REVERSED
0028 F**08******************-TRAILER***********************************   S01117
     F* 08            LELOANL8                                            140821
0029 F**09******      CLINT -DETAIL 'A'                                   S01194
0030 F**10******      TABLE -ICD1                                         S01194
0031 F**11******             CURRENCIES REC.1                             S01194
0032 F**
      *   10  - Output indicator for RADIF, RADCF, RICIF, RCHGA in    *                       CLE028
      *         LE0310P1                                              *                       CLE028
0033 F*       12      WORK INDICATOR - LIVE RECORD
0034 F* 13            CLOAN - TRAILER FOR UPDATE
     F*       14      RECOURSE INDICATOR BLANK
     F*       15      Analytical Accounting is installed                  CAC001
      *               or Revenue Analysis is installed                    CDE002
     F*       17      Settlement Allocations to be printed                                    CLE034
     F*       19      NO DETAILS TO REPORT FOR THIS BRANCH                S01117
0035 F*       20      FIRST CYCLE INDICATOR
     F*       21      FIRST LINE OF SPECIAL INSTRUCTIONS IS BLANK
0036 F*       22      ACTIONED TODAY
     F*       23      WORK INDICATOR USED FOR BENIFICIARY BANK DETAILS
0037 F*       24      INSERTED RECORD
0038 F*       25      AMENDED    "
0039 F*       26      DELETED    "
0040 F*       27      RECORDS IN CORRECT SEQUENCE
     F*       28      BENIFICIARY BANK DETAILS EXIST ON FIRST LINE OF SPI
      *       29      CLE011 is installed                                 CLE011
0042 F*       30      OUTPUT INDICATOR
0043 F*       31      PARTICIPATION PURCHASED
0044 F*       32           "        SOLD
0045 F*       33      LOAN
0046 F*       34      NO INPUT TODAY
0047 F*       35      0 DECIMAL PLACES
0048 F*       36      1    "      "
0049 F*       37      2    "      "
0050 F*       38      3    "     "
0051 F********39      CHAIN TO TABLE FILE FAILED                          S01194
     F*       39      CLE002 is ON                                                            196066
0052 F********40        "      CLINT  "      "                            S01194
0053 F**
      *       40      Pay: Settlement Allocation by Amount                                    CLE038
0054 F*       41      FILE CONTROLS BALANCE REPORT TOTALS - INSERTED RECS
0055 F*       42        "      "       "      "      "    - DELETED RECS
0056 F*       43        "      "      "       "      "    - LIVE RECS
0057 F*       44      FILE CONTROLS VERIFIED
0058 F*       45      SECURED INDICATOR ON
0059 F*       46      DOCUMENTS   "     "
0060 F*       47      FEES        "     "
0061 F*       48      CURRENT PRIN.AMT. = NEGATIVE
0062 F**
0063 F*       49      DATE TO BE PRINTED ON REPORT
0064 F*       50        "          "        "
0065 F*       51        "          "        "
0066 F*       52        "          "        "
0067 F*       53        "          "        "
0068 F*       54        "          "        "
0069 F*       55        "          "        "
0070 F*       56      BASE RATE TO BE PRINTED ON REPORT
0071 F*       57      INT.PAYMENT DAYNO  "         "
0072 F*       58      ROLLOVER DAYNO     "         "
0073 F*       59      REPAY IND          "         "
0074 F*       60      REPAY DAYNO        "         "
0075 F*       61      FRB CODE           "         "
0076 F*       62      BILLING DAYS       "         "
0077 F*       63      BASE CCY RATE      "         "
0078 F*       64      FCLT CCY RATE      "         "
0079 F*       65      R/OVER BASE RT CD  "         "
0080 F*       66      EXCEPTION OUTPUT FOR FILE CONTROLS
     F*       67      GUARANTEES ISSUED INDICATOR IN ICD IS ACTIVE        S01465
     F*       68      CORE FEATURE S01465 IS SWITCHED ON                  S01465
     F*       69      Portfolio Management is switched on                 S01486
     F*       70      Database error                                      CLE004
     F*       71      Original maturity date to be printed                088897
     F*       73      End of Report line for LE0300P2                     CLE004
0081 F********73******EXCEPTION OUTPUT*-*"NO INPUT TODAY"**************   S01117
0082 F*       74      CHAIN TO CLOAN TRAILER FAILED
      *       74      ULX004 is switched *ON                                                  CER001
     F*       75      MULTIBRANCHING INDICATOR ON ICD 2 IS Y.             S01117
     F*       76      ORIGINATING BRANCH NOT USED                         S01117
     F*       77      PROFIT CENTRE NOT USED                              S01117
     F*       78      SOME DETAILS REPORTED ON ANY P1 SPOOL               S01117
     F*       79      NEW MATURITY DATE IS NOT 0                          088426
     F*       80      SAR S01518 IS ON                                    S01518
     F*       81      ROLLOVER NEW INTEREST PAYMENT DATE                  S01518
     F*       82      DISCOUNTED LOAN (PROCESSING TYPE 63)                S01518
      *       83      CLE141 is switched ON                                                   CLE141
     F*       84      Multi-branch                                        CLE004
     F********85      CLE006 is switched *ON                        CLE004CLE015
     F*       85      CLE006 or CLE007 is *ON                             CLE015
     F*       86      NBSR is not Empty                                                       CLE036
     F*       87      CLE004 is switched *ON                              CLE004
     F*       88      CEU020 is switched *ON                              CEU020
      *       89      Receipt: Settlement Allocation by Amount                                CLE038
      *       90      Difference in trailer file values.                                      236008
      *       92      CER073 is switched ON                                                   CER073
      *       96      CER073 is switched ON                                                   CER073
0083 F*
0084 F*          U7+U8DATABASE ERROR
0085 F*          U8   FILE CONTROLS OUT OF BALANCE
0073 D*/COPY*ZSRSRC,ZDATE2Z1*********                                                 S01392 CER073D
0073 D/COPY ZSRSRC,ZDATE2Z1LE                                                                CER073D
     D/COPY WNCPYSRC,LE0310E001
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D SVAL            S             20    DIM(1) CTDATA PERRCD(1)
     D XCYA            S              3    DIM(150)
     D XDPA            S              1  0 DIM(150)
     D/COPY ZSRSRC,ZEDITZ1LE                                                                 CER073D
0272 D*
0273 D*****CLIENT*FILE*-*CUSTOMER*STANDING*DATA*RECORD.                   S01194
0274 D*
0275 D*CLINT***NS  09   1 CD   8 CA                                       S01194
0276 D**********                              1   1 RECI                  S01194
     D**********                              2   70CNUMA                 S01194
0278 D**********                              8   8 RCDT                  S01194
0279 D**********                              9  28 CRNM                  S01194
0280 D**********                             29  38 CTWN                  S01194
0281 D**********                             39  48 CSNM                  S01194
0282 D**********                             49  56 CASK                  S01194
0283 D**********                             57  68 TELX                  S01194
0284 D**********                             69  80 CSID                  S01194
0285 D**********                             81  82 ACOC                  S01194
0286 D**********                             83  83 CBSI                  S01194
0287 D**********                             84  85 CCTZ                  S01194
0288 D**********                             86  87 CLOC                  S01194
0289 D**********                             88  930CPAR                  S01194
0290 D**********                             97  980LINS                  S01194
0292 D**********                          P 102 1040DASU                  S01194
0293 D**********                          P 105 1070CDIC                  S01194
0294 D**********                          P 108 1100DADE                  S01194
0295 D**********                            111 111 CMIN                  S01194
0296 D**********                            112 112 CTYP                  S01194
0297 D**********                            113 124 TELF                  S01194
0298 D**********                            125 133 CHID                  S01194
0299 D**********                            134 136 CHAB                  S01194
0300 D**********                          P 250 2520LCD                   S01194
0301 D**********                            253 253 CHTP                  S01194
0302 D**********                          P 254 2560TNLU                  S01194
0303 D**********                                                          S01194
0304 D*****CLIENT*FILE*-*CATCHALL                                         S01194
0305 D********NS                                                          S01194
0306 D**********                              1   1 RECI                  S01194
0307 D*
0308 D*****TABLE*FILE*-*INSTALLATION*CONTROL*DATA*RECORD*1.               S01194
0309 D*
0310 D*TABLE***NS  10   2 C0   3 C1  12 C1                                S01194
0311 D*******AND      13 C0                                               S01194
0312 D**********                              1   1 RECI                  S01194
0313 D**********                              2   30RECT                  S01194
0314 D**********                             12  130RCDE                  S01194
0315 D**********                             14  66 TITL                  S01194
0316 D**********                             67  67 DATF                  S01194
0317 D***********                            68  700DFBR                  S01194
0318 D**********                             74  74 MODI1                 S01194
0319 D**********                             75  75 MODI2                 S01194
0320 D**********                             76  76 MODI3                 S01194
0321 D**********                          P  77  790RUND                  S01194
0322 D**********                             80  86 RUNA                  S01194
0323 D**********                             87  870SFLG                  S01194
0324 D**********                          P  90  920LCD                   S01194
0325 D**********                             93  93 CHTP                  S01194
0326 D**********                          P  94  960TNLU                  S01194
0327 D*
0328 D*****TABLE*FILE*-*CURRENCIES*RECORD*1.                              S01194
0329 D*
0330 D*TABLE***NS  11   1 CD   2 C2   3 C0                                S01194
0331 D*******AND      13 C1                                               S01194
0332 D**********                              1   1 RECI                  S01194
0333 D**********                              2   30RECT                  S01194
0334 D**********                             10  12 CCY                   S01194
0335 D**********                             13  130SREC                  S01194
0336 D**********                             14  27 CCNM                  S01194
0337 D**********                          P  28  348SPOT                  S01194
0338 D**********                             35  37 CCYS                  S01194
0339 D**********                             38  380CDP                   S01194
0340 D**********                             39  390TNOT                  S01194
0341 D**********                             40  40 DCCY                  S01194
0342 D**********                             41  44 SRC1                  S01194
0343 D**********                             45  48 SRC2                  S01194
0344 D**********                             49  520TACC                  S01194
0345 D**********                             53  560TEQV                  S01194
0346 D**********                             57  600SWQV                  S01194
0347 D**********                             61  640TAC4                  S01194
0348 D**********                             65  680TAC5                  S01194
0349 D**********                             69  69 HIND                  S01194
0350 D**********                          P  70  768PART                  S01194
0351 D**********                             77  780SSNO                  S01194
0352 D**********                          P  79  858ERLC                  S01194
0353 D**********                             86  860MDIN                  S01194
0354 D**********                             87  870MDIA                  S01194
0355 D**********                             88  880MDIB                  S01194
0356 D**********                          P  90  920LCD                   S01194
0357 D**********                             93  93 CHTP                  S01194
0358 D**********                          P  94  960TNLU                  S01194
0359 D*
0360 D*****TABLE*FILE*-*CATCH-ALL                                         S01194
0361 D*
0362 D********NS       1NCD                                               S01194
0363 D**********                              1   1 RECI                  S01194
     D**   FIELDS USED FOR BENIFICIARY BANK DETAILS
     D                 DS
     D  SPI1                   1     30
     D  SPEC3                  1      3
     D  SPEC5                  1      5
     D  SPEC8                  6      8
     D  SPEC9                  1      8
     D  SPEC12                 6     12
     D  SPEC14                 9     14
     D  SPEC17                 9     17
     D  SPEC18                10     18
     D  SPEC29                 5     29
     D  SPEC30                 6     30
     D*
0364 D*
0365 D*    LOCAL DATA AREA FOR DATABASE ERROR REFERENCES
0366 D*
0367 D LDA            UDS           256
0368 D***********                           134 138 DBFILE                S01117
0369 D***********                           139 167 DBKEY                 S01117
0370 D***********                           168 175 DBPGM                 S01117
0371 D***********                           176 177 DBASE                 S01117
     D  DBFILE               134    141                                         S01117
     D  DBKEY                142    170                                         S01117
     D  DBPGM                171    180                                         S01117
     D  DBASE                181    183  0                                      S01117
     D**                                                                  S01117
     D**   FILE INFORMATION DATA STRUCTURE                                S01117
     D**                                                                  S01117
     D SPOOL           DS                                                       S01117
     D  SFILE                 83     92                                         S01117
     D  SFNUM                123    124B 0                                      S01117
     D SPOOL2          DS                                                       CLE004
      ** File information data structure for LE0310P2                     CLE004
      *                                                                   CLE004
     D  OPEN2                  9      9                                         CLE004
     D  SFILE2                83     92                                         CLE004
     D  SFNUM2               123    124B 0                                      CLE004
     D**                                                                  CLE004
     D**                                                                  S01117
     D**   FILE INFORMATION DATA STRUCTURE                                S01117
     D**                                                                  S01117
     D SPOOLU          DS                                                       S01117
     D  SFILEU                83     92                                         S01117
     D  SFNUMU               123    124B 0                                      S01117
     D                 DS                                                       CLE004
      ** Format amount returned by standard subroutine                    CLE004
     D  ZOUT22                 1     22                                         CLE004
     D  ZOUT18                 4     21                                         CLE004
     D  ZOUT17                 4     20                                         CLE004
     D  ZNEG                  21     21                                         CLE004
     D*/COPY*ZSRSRC,ZFRPEDZ2*********                                                 CLE004 CER073D
      *                                                                   S01117
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                    S01117
      **  EXTERNAL DS FOR BANK DETAILS                                    S01117
     D  TITL         E                     EXTFLD(BJURPT)                       S01194
      **                                                                  S01117
     D*                                                                                      CER073D
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                 CER073D
     D** DEALING DATA                                                                        CER073D
     D  QQACCT       E                     EXTFLD(QQACCD)                                    CER073D
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                    S01117
      **  EXTERNAL DS FOR BRANCH CODE DETAILS                             S01117
     D  BRNM         E                     EXTFLD(A8BRNM)                       S01194
      **                                                                  S01117
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                    S01117
      **  EXTERNAL DS FOR GENERAL LEDGER DETAILS                          S01117
     D  PFCU         E                     EXTFLD(BKPRCU)                       S01194
     D  OBRU         E                     EXTFLD(BKOBRU)                       S01194
     D*
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    S01194
      **  EXTERNAL DS FOR CUSTOMER DETAILS                                S01194
     D  CRNM         E                     EXTFLD(BBCRNM)                       S01194
     D  #DFAC1       E                     EXTFLD(QQDFAC)
     D*                                                                   S01194
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                    S01194
      **  EXTERNAL DS FOR CURRENCY DETAILS                                S01194
     D  CDP          E                     EXTFLD(A6NBDP)                       S01194
     D*                                                                   S01465
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    S01465
     D** SAR FILE DETAILS                                                 S01465
     D  LCDX         E                     EXTFLD(LCD)                          S01465
     D*                                                                   S01465
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)                    S01465
     D** CUSTOMER LENDING DETAILS                                         S01465
      *                                                                   S01194
     D*                                                                   S01194
     D SDPORT        E DS                  EXTNAME(SDPORTPD)                    S01486
      ** Portfolio Management ICD                                         S01486
     D*                                                                   S01486
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                    S01486
      ** Midas Module details                                             S01486
      *                                                                   S01486
     D*                                                                   S01408
     D***/COPY*WNCPYSRC,LE0310IIPG***                                                  S01408 CFC006
     D/COPY WNCPYSRC,LE0310IIPG                                                             MD020563
     D SECTN           C                   CONST('LE0310001')
     D*                                                                   S01408
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01194
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                S01194
     D*                                                                   S01194
     D DSSDY         E DS                  EXTNAME(DSSDY)                       S01194
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE                S01194
     D*                                                                   S01194
      **                                                                  S01117
     D*SDSVAL*** E DSSDSVALPD                                                        CLE038 MD054605
      *                                                                                       CLE038
      ** External DS for System Values                                                        CLE038
      *                                                                                       CLE038
     D ANACDS        E DS                  EXTNAME(LEANACQD)                                       C
      *                                                                                      CER073A
     D** AnaCredit Details                                                                   CER073A
      *                                                                                      CER073A
     D RUNDT           DS                                                       S01117
      **  DATA AREA RUNDAT                                                S01117
     D  RUNA                   1      7                                         S01117
     D  RUND                   8     10P 0                                      S01117
     D  SSF                   11     11                                         S01117
     D  DATF                  12     12                                         S01117
     D  MBIN                  13     13                                         S01117
     I*/COPY*ZSRSRC,ZFRPEDZ1*********                                                 CLE004 CER073D
     D/COPY ZSRSRC,ZFRPEDZ1LE                                                                CER073D
      ** Arrays to contain the input and output fields.                   CLE004
      *                                                                   CLE004
     I*/COPY ZSRSRC,ZEDITZ1**********                                                 CLE004 CER073D
      ** Arrays to contain the input and output fields.                   CLE004
      *                                                                   CLE004
     IFCLTYFMF                                                                  140821
      ** Rename Fields similar to CLOAN fields.                           140821
     I              RECI                        FRECI                           140821
     I              CNUM                        FCNUM                           140821
     I              BRCA                        FBRCA                           140821
     I              FCCY                        FFCCY                           140821
     I              NACD                        FNACD                           140821
     I              CRSK                        FCRSK                           140821
     I              NAR1                        FNAR1                           140821
     I              NAR2                        FNAR2                           140821
     I              NAR3                        FNAR3                           140821
     I              NAR4                        FNAR4                           140821
     I              ACOF                        FACOF                           140821
     I              ORBR                        FORBR                           140821
     I              ORED                        FORED                           140821
     I              LCD                         FLCD                            140821
     I              CHTP                        FCHTP                           140821
     I              TNLU                        FTNLU                           140821
     I              DFTP                        FDFTP                           140821
     I              DFST                        FDFST                           140821
     I              IUSR                        FIUSR                           140821
     I              AUSR                        FAUSR                           140821
     I              XUSR                        FXUSR                           140821
     I              PCRF                        FPCRF                           140821
     I              RCSI                        FRCSI                           140821
     I              OSDB                        FOSDB                           140821
     I              OMDB                        FOMDB                           140821
     I              RSTM                        FRSTM                           140821
     I              RONS                        FRONS                           140821
     I              RIBN                        FRIBN                           140821
     I              RIBA                        FRIBA                           140821
     I              ROBN                        FROBN                           140821
     I              ROCN                        FROCN                           140821
     I              PSTM                        FPSTM                           140821
     I              PONS                        FPONS                           140821
     I              PIBN                        FPIBN                           140821
     I              PIBA                        FPIBA                           140821
     I              POBN                        FPOBN                           140821
     I              POCN                        FPOCN                           140821
     I              RCRN                        FRCRN                           140821
     I              RCRA                        FRCRA                           140821
     I              RVNO                        FRVNO                           140821
     I              AWBN                        FAWBN                           140821
     I              AWBA                        FAWBA                           140821
     I              BENN                        FBENN                           140821
     I              BENA                        FBENA                           140821
     I              DTP1                        FDTP1                           140821
     I              DTP2                        FDTP2                           140821
     I              DTP3                        FDTP3                           140821
     I              DTP4                        FDTP4                           140821
     I              DCHG                        FDCHG                           140821
     I              BTB1                        FBTB1                           140821
     I              BTB2                        FBTB2                           140821
     I              BTB3                        FBTB3                           140821
     I              BTB4                        FBTB4                           140821
     I              BTB5                        FBTB5                           140821
     I              BTB6                        FBTB6                           140821
     I              CVMR                        FCVMR                           140821
     I              PCOB                        FPCOB                           140821
     I              SCCY                        FSCCY
     I              REXR                        FREXR
     I              REXI                        FREXI
     I              PSCY                        FPSCY
     I              PEXR                        FPEXR
     I              PEXI                        FPEXI
     I              DFCL                        FDFCL
      *                                                                                       CLE034
     ILESTALD0
      ** Rename Fields similar to CLOAN fields.                                               CLE034
     I              RECI                        LRECI
     I              TYPE                        LTYPE
     I              TMST                        LTMST
     I              PCRF                        LPCRF
     I              LNRF                        LLNRF
     I              VDAT                        LVDAT
     I              LASQ                        LLASQ
     I              CNUM                        LCNUM
     I              FACL                        LFACL
     I              FESQ                        LFESQ
     I              SEQ                         LSEQ
     I              RCPC                        LRCPC
     I              RSTM                        LRSTM
     I              RONS                        LRONS
     I              RIBN                        LRIBN
     I              RIBA                        LRIBA
     I              ROBN                        LROBN
     I              ROCN                        LROCN
     I              ROBR                        LROBR
     I              RSCY                        LRSCY
     I              REXR                        LREXR
     I              REXI                        LREXI
     I              PYPC                        LPYPC
     I              PSTM                        LPSTM
     I              PONS                        LPONS
     I              PIBN                        LPIBN
     I              PIBA                        LPIBA
     I              POBN                        LPOBN
     I              POCN                        LPOCN
     I              RCRN                        LRCRN
     I              RCRA                        LRCRA
     I              RVNO                        LRVNO
     I              AWBN                        LAWBN
     I              AWBA                        LAWBA
     I              BENN                        LBENN
     I              BENA                        LBENA
     I              DTP1                        LDTP1
     I              DTP2                        LDTP2
     I              DTP3                        LDTP3
     I              DTP4                        LDTP4
     I              DCHG                        LDCHG
     I              BTB1                        LBTB1
     I              BTB2                        LBTB2
     I              BTB3                        LBTB3
     I              BTB4                        LBTB4
     I              BTB5                        LBTB5
     I              BTB6                        LBTB6
     I              POBR                        LPOBR
     I              CVMR                        LCVMR
     I              PSCY                        LPSCY
     I              IC72                        LIC72
     I              PEXR                        LPEXR
     I              PEXI                        LPEXI
     I              PTRF                        LPTRF
     I              PYBA                        LPYBA
     I              PYAM                        LPYAM
     I              RCBA                        LRCBA
     I              RCAM                        LRCAM
     I              CCY                         LCCY
      *                                                                                       CLE034
0089 I*
0090 I* CUSTOMER LENDING - LOANS FILE - HEADER
0091 I*
0092 I*LOAN***NS* 01   1 CH                                               S01117
0093 I***********                             1   1 RECI                  S01117
0094 I***********                                                         S01117
0095 I**LOANS*FILE*-*DETAIL*RECORD*1***********************************   S01117
0096 I*
     ICLOANF                                                                    S01117
     I                                          BRCA          L1                S01117
     I              NCAS                        NCAC                            S01117
0117 I                                          CPAM                  48        S01117
0169 I                                          RCSI                    14      S01117
     I              CHTP                        CHTPA                           S01117
     I              LCD                         LCDA                            S01117
     I              NLRA                        NNLR                            CLE004
0225 I                                          SPI1                    21      S01117
0097 I********NS* 02   1 CD   8 CA                                        S01117
0098 I*******OR** 03   1 CM   8 CA                                        S01117
0099 I*******OR** 04   1 CR   8 CA                                        S01117
0100 I***********                             1   1 RECI                  S01117
0101 I***********                             2   70LNRF                  S01117
0102 I***********                             8   8 RCDT                  S01117
0103 I***********                             9   90MRIN                  S01117
0104 I***********                            10  110PTYP                  S01117
0105 I***********                            12  170CNUM                  S01117
0106 I***********                            18  200BRCD                  S01117
0107 I***********                            21  22 LTYP                  S01117
0108 I***********                            23  24 SUTP                  S01117
0109 I***********                         P  25  270DDAT                  S01117
0110 I***********                         P  28  300VDAT                  S01117
0111 I***********                         P  31  330MDAT                  S01117
0112 I***********                            34  350LASQ                  S01117
0113 I***********                            36  410FCUS                  S01117
0114 I***********                            42  440FTYP                  S01117
0115 I***********                            45  460FSEQ                  S01117
0116 I***********                            47  49 CCY                   S01117
0117 I***********                         P  50  560CPAM          48      S01117
0118 I***********                            57  57 INTC                  S01117
0119 I***********                         P  58  637INTR                  S01117
0120 I***********                            64  650BRTT                  S01117
0121 I***********                         P  66  717BRTE                  S01117
0122 I***********                         P  72  777RTSP                  S01117
0123 I***********                         P  78  815MARG                  S01117
0124 I***********                            82  82 SPIN                  S01117
0125 I***********                            83  83 CHIN                  S01117
0126 I***********                         P  84  897WTRT                  S01117
0127 I***********                            90  90 WTIN                  S01117
0128 I***********                            91  910REPT                  S01117
0129 I***********                         P  92  980RAMT                  S01117
0130 I***********                         P  99 1010NRPD                  S01117
0131 I***********                           102 102 RFRQ                  S01117
0132 I***********                           103 1040RDYN                  S01117
0133 I***********                           105 107 FCCY                  S01117
0134 I***********                           108 1100LIND                  S01117
0135 I***********                           111 112 CRSK                  S01117
0136 I***********                           113 114 ACOF                  S01117
0137 I***********                           115 115 NACD                  S01117
0138 I***********                           116 116 RELI                  S01117
0139 I***********                           117 117 AUTO                  S01117
0140 I***********                         P 118 1240PSAM                  S01117
0141 I***********                         P 125 1318BCXR                  S01117
0142 I***********                         P 132 1388FCXR                  S01117
0143 I***********                           139 1400SDST                  S01117
0144 I***********                           141 152 OSDA                  S01117
0145 I***********                           153 162 TSTN                  S01117
0146 I***********                           163 1640MDST                  S01117
0147 I***********                           165 176 OMDA                  S01117
0148 I***********                           177 186 TMAN                  S01117
0149 I***********                           187 196 FACO                  S01117
0150 I***********                         P 197 1990RLDT                  S01117
0151 I***********                         P 200 2020NROD                  S01117
0152 I***********                           203 203 RLFQ                  S01117
0153 I***********                           204 2050RLDY                  S01117
0154 I***********                           207 2080NBRA                  S01117
0155 I***********                         P 209 2147NRTS                  S01117
0156 I***********                           215 215 NSIN                  S01117
0157 I***********                           216 2160NCAC                  S01117
0158 I***********                         P 217 2230AWTP                  S01117
0159 I***********                         P 224 2300WTRD                  S01117
0160 I***********                         P 231 2370WTWD                  S01117
0161 I***********                         P 238 2440IWOD                  S01117
0162 I***********                         P 245 2510PWOD                  S01117
0163 I***********                           252 252 BMDI                  S01117
0164 I***********                           253 253 FMDI                  S01117
0165 I***********                         P 254 2600PDIN                  S01117
0166 I***********                           287 287 BTIN                  S01117
0167 I***********                           288 2890BLDY                  S01117
0168 I***********                           290 2950OLNO                  S01117
0169 I***********                           296 296 RCSI            14    S01117
0170 I***********                           297 2970ICBS                  S01117
0171 I***********                           298 298 IPFR                  S01117
0172 I***********                         P 299 3050TOTI                  S01117
0173 I***********                         P 306 3080NIDT                  S01117
0174 I***********                         P 309 3110IBDT                  S01117
0175 I***********                         P 312 3140SLID                  S01117
0176 I***********                         P 315 3210AIPD                  S01117
0177 I***********                         P 322 3240DLRC                  S01117
0178 I***********                         P 325 3270IACD                  S01117
0179 I***********                         P 328 3340AITC                  S01117
0180 I***********                         P 335 3410TFEP                  S01117
0181 I***********                         P 342 3480AIAP                  S01117
0182 I***********                         P 349 3550IPRD                  S01117
0183 I***********                         P 356 3620IPRM                  S01117
0184 I***********                         P 363 3690ICTD                  S01117
0185 I***********                         P 370 3760AIMN                  S01117
0186 I***********                         P 377 3790RBDT                  S01117
     I***********                           382 382 NCHI                  S01117
0187 I***********                           384 3850IFDY                  S01117
0188 I***********                           386 386 LONI                  S01117
0189 I***********                           387 387 CNFI                  S01117
0190 I***********                           388 388 ACEI                  S01117
0191 I***********                           389 389 TLXI                  S01117
0192 I***********                           390 390 CBLI                  S01117
0193 I***********                         P 391 3930ORED                  S01117
     I***********                         P 394 3960LCDA                  S01117
     I***********                           397 397 CHTPA                 S01117
0196 I***********                         P 398 4000TNLU                  S01117
0197 I***********                             1   7 DSA1                  S01117
0198 I***********                                                         S01117
0199 I*****LOANS*FILE*-*DETAIL*2***************************************   S01117
0200 I***********                                                         S01117
0201 I********NS* 05   1 CD   8 CB                                        S01117
0202 I*******OR** 06   1 CM   8 CB                                        S01117
0203 I*******OR** 07   1 CR   8 CB                                        S01117
0204 I***********                             1   1 RECI                  S01117
0205 I***********                             2   70LNRF                  S01117
0206 I***********                             8   8 RCDT                  S01117
0207 I***********                             9   90MRIN                  S01117
0208 I***********                            10  44 NAR1                  S01117
0209 I***********                            45  79 NAR2                  S01117
0210 I***********                            80 114 NAR3                  S01117
0211 I***********                           115 149 NAR4                  S01117
0212 I***********                         P 150 1560OPAM                  S01117
0213 I***********                           157 1610FRBC                  S01117
0214 I***********                         P 162 1680YPLN                  S01117
0215 I***********                         P 169 1750YFLN                  S01117
0216 I***********                         P 176 1820YILN                  S01117
0217 I***********                         P 183 1890ABLN                  S01117
0218 I***********                         P 190 1960YPLC                  S01117
0219 I***********                         P 197 2030YFLC                  S01117
0220 I***********                         P 204 2100YWLC                  S01117
0221 I***********                         P 211 2170ABLC                  S01117
0222 I***********                         P 218 2240WWLN                  S01117
0223 I***********                         P 225 2310IWLN                  S01117
0224 I***********                         P 232 2380PWLN                  S01117
0225 I***********                           245 274 SPI1            21    S01117
0226 I***********                           275 304 SPI2                  S01117
0227 I***********                           305 334 SPI3                  S01117
0228 I***********                         P 391 3930ORED                  S01117
0229 I***********                         P 394 3960LCD                   S01117
0230 I***********                           397 397 CHTP                  S01117
0231 I***********                         P 398 4000TNLU                  S01117
0232 I***********                             1   7 DSB1                  S01117
0233 I***********                                                         S01117
0234 I*****LOANS*FILE*-*TRAILER****                                       S01117
0235 I***********                                                         S01117
0236 I********NS* 08   1 CT                                               S01117
0237 I***********                             1   1 RECI                  S01117
0238 I***********                             2   70LNRF                  S01117
0239 I***********                             8   8 RCDT                  S01117
0240 I***********                         P  17  190NORE                  S01117
0241 I***********                         P  20  220FLSZ                  S01117
0242 I***********                         P  23  250NLRB                  S01117
0243 I***********                         P  26  280NINS                  S01117
0244 I***********                         P  29  310NDEL                  S01117
0245 I***********                         P  32  340NLRA                  S01117
0246 I***********                         P  35  420VLBF                  S01117
0247 I***********                         P  43  440VLBL                  S01117
0248 I***********                         P  45  520VRIF                  S01117
0249 I***********                         P  53  540VRIL                  S01117
0250 I***********                         P  55  620VRDF                  S01117
0251 I***********                         P  63  640VRDL                  S01117
0252 I***********                         P  65  720VLAF                  S01117
0253 I***********                         P  73  740VLAL                  S01117
0254 I***********                         P  75  770DTMR                  S01117
0255 I***********                         P  78  800ITMR                  S01117
0256 I***********                         P 394 3960LCD                   S01117
0257 I***********                           397 397 CHTP                  S01117
0258 I***********                         P 398 4000TNLU                  S01117
0259 I***********                                                         S01117
0260 I*****LOANS*FILE*-*CATCHALL****                                      S01117
0261 I***********                                                         S01117
0262 I********NS*                                                         S01117
0263 I***********                             1   1 RECI                  S01117
0264 I*
     I/COPY WNCPYSRC,LE0310I001
0265 I* LOANS FILE TRAILER FOR UPDATE
0266 ICLONT     NS  13    1 CT
0267 I                                  1    1  RECI
0238 I**********                              2   70LNRF                               S01117 CLE148
     I                                  2    7  LNRF
0239 I                                  8    8  RCDT                            S01117
0240 I                             P   17   19 0NORE                            S01117
0241 I                             P   20   22 0FLSZ                            S01117
0242 I                             P   23   25 0NLRB                            S01117
0243 I                             P   26   28 0NINS                            S01117
0244 I                             P   29   31 0NDEL                            S01117
0245 I                             P   32   34 0NLRA                            S01117
0246 I                             P   35   42 0VLBF                            S01117
0247 I                             P   43   44 0VLBL                            S01117
0248 I                             P   45   52 0VRIF                            S01117
0249 I                             P   53   54 0VRIL                            S01117
0250 I                             P   55   62 0VRDF                            S01117
0251 I                             P   63   64 0VRDL                            S01117
0252 I                             P   65   72 0VLAF                            S01117
0253 I                             P   73   74 0VLAL                            S01117
0254 I                             P   75   77 0DTMR                            S01117
0255 I                             P   78   80 0ITMR                            S01117
0256 I                             P  394  396 0LCD                             S01117
0257 I                                397  397  CHTP                            S01117
0258 I                             P  398  400 0TNLU                            S01117
     I**  BOOK CODE ADDITION FOR EXPOSURE MANAGEMENT                      S01220
     I                                435  436  BOKC                            S01220
     I                               1088 1091  PTFR                            S01486
     I                               1092 1092  HLEX                            S01486
0268 I*
0269 I* CATCHALL
0270 I          NS        1NCT
0271 I                                  1    1  RECI
      *                                                                   140821
     ILELOAN8F                                                                  140821
     I              OLNO                        OLNOA                           140821
     I              LNKS                        LNKSA                           140821
      *                                                                                       237732
     ILOAMSDKF
     I              PRAM                        CPAM
     C                   MOVEA     CPY@          BIS@             80
0372 C*
     C*
     C** PARAMETER LIST FOR PROGRAM 'AOBANKR0'                            S01194
     C     PLISTA        PLIST                                                                 S0119
     C                   PARM      '*MSG   '     @RTCD             7                           S0119
     C                   PARM      '*FIRST '     @OPTN             7                           S0119
     C     SDBANK        PARM      SDBANK        DSFDY                                         S0119
     C**                                                                  S01194
     C*                                                                   S01194
     C** PARAMETER LIST FOR PROGRAM 'AOCUSTR0'                            S01194
     C*                                                                   S01194
     C     PLIST1        PLIST                                                                 S0119
     C                   PARM      '*MSG   '     @RTCD                                         S0119
     C                   PARM      '*KEY   '     @OPTN                                         S0119
     C                   PARM                    CKEY             10                           S0119
     C                   PARM                    KEYSTS            7                           S0119
     C     SDCUST        PARM      SDCUST        DSSDY                                         S0119
     C*                                                                   S01194
     C** PARAMETER LIST FOR PROGRAM 'AOCURRR0'                            S01194
     C*                                                                   S01194
     C     PLIST2        PLIST                                                                 S0119
     C                   PARM      '*MSG   '     @RTCD                                         S0119
     C                   PARM      '*KEY   '     @OPTN                                         S0119
     C                   PARM                    CURKEY            3                        A  S0119
     C     SDCURR        PARM      SDCURR        DSSDY                                      B  S0119
     C*                                                                   S01194
0373 C*    FIRST CYCLE PROCESSING
0374 C*
     C/COPY WNCPYSRC,LEH00008
0375 C   20              GOTO      ENDFC
0376 C***01******          SETON                     20                   S01117
0376 C                   SETON                                        20                       S0111
     C*
     C/COPY WNCPYSRC,LE0310CCP8
     C*
      **                                                                  S01117
      **   IN THE DATAAREA RUNDAT                                         S01117
      **                                                                  S01117
     C     *DTAARA       DEFINE    RUNDAT        RUNDT                                         S0111
     C                   IN        RUNDT                                                       S0111
     C*    DEFINE LDA                                                     S01117
     C     *DTAARA       DEFINE                  LDA                                           S0111
     C     *LOCK         IN        LDA                                                         S0111
0377 C*
0378 C*    SET UP DATABASE ERROR REFERENCE
0379 C*
0380 C                   MOVE      'LE0310  '    DBPGM
0381 C                   MOVE      ' '           BLANKS           29
0382 C                   MOVE      BLANKS        DBKEY
0383 C*
0384 C*    ACCESS ICD-1 FOR DATE FORMAT, DATABASE ERROR IF NOT FOUND
0385 C*
0386 C                   EXSR      ZSYSTM                                       98ON-MMDDYY
0387 C   99              SETON                                        U7U8LR
0388 C   99              MOVE      '01'          DBASE
0389 C***99*****           MOVE 'TABLE'   DBFILE                          S01194
0389 C   99              MOVE      'SDBANKPD'    DBFILE                                        S0119
0390 C***99*****           MOVELZTABKY    DBKEY                           S01194
0391 C   99              GOTO      ENDT
      *                                                                   S01486
      ** Access SDMMODPD to check if Portfolio Management                 S01486
      ** module presenr                                                   S01486
      ** If Yes thus access Portfolio ICD                                 S01486
      *                                                                   S01486
      ** ACCESS MIDAS MODULE DETAILS                                      S01486
     C                   CALL      'AOMMODR0'                                                  S0148
     C                   PARM      '*DBERR '     @RTCD             7                           S0148
     C                   PARM      '*FIRST '     @OPTN             7                           S0148
     C     SDMMOD        PARM      SDMMOD        DSFDY                                         S0148
     C**                                                                  S01486
     C     @RTCD         IFNE      *BLANK                                                      S0148
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************  S0148
     C                   MOVEL     '015'         DBASE                          * DBERR 015 *  S0148
     C                   MOVEL     @OPTN         DBOPTN            7            *************  S0148
     C                   SETON                                        U7U8                     S0148
     C                   EXSR      *PSSR                                                       S0148
     C                   GOTO      ENDT                                                        S0148
     C                   END                                                                   S0148
      *                                                                   CDE002
      ** Access SAR details file to determine if CDE002 is switched on    CDE002
      *                                                                   CDE002
     C                   CALL      'AOSARDR0'                                                  CDE00
     C                   PARM      *BLANKS       PRTCD             7                           CDE00
     C                   PARM      '*VERIFY'     POPTN             7                           CDE00
     C                   PARM      'CDE002'      PSARD             6                           CDE00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CDE00
      *                                                                   CDE002
     C                   MOVE      'N'           CDE002            1                           CDE00
     C     PRTCD         IFEQ      *BLANKS                                                     CDE00
     C                   MOVE      'Y'           CDE002                                        CDE00
     C                   ENDIF                                                                 CDE00
      *                                                                   CAC001
     C                   EXSR      CSARC4
      *                                                                                       245014
      **  If Analytical Accounting is on, set on indicator that would     CAC001
      **  print funding information fields to LE0310P1                    CAC001
      **  or if Revenue Analysis is on, set on indicator that would       CDE002
      **  print funding information fields to LE0310P1                    CDE002
      *                                                                   CAC001
     C     BGN0ST        IFEQ      'Y'                                                         CAC00
     C     CDE002        OREQ      'Y'                                                         CDE00
     C                   MOVE      '1'           *IN15                                         CAC00
     C                   ENDIF                                                                 CAC00
      *                                                                   CPB001
     C     BGN4ST        IFEQ      'Y'                                                         CPB00
     C                   MOVE      '1'           *IN69                                         CPB00
     C                   ENDIF                                                                 CPB00
      *                                                                   S01486
     C     BGPFMG        IFEQ      'Y'                                                         S0148
     C                   MOVE      '1'           *IN69                                         S0148
      ** Access PM ICD File.                                              S01486
     C                   CALL      'AOPORTR0'                                                  S0148
     C                   PARM      '*DBERR '     @RTCD             7              B:Return codeS0148
     C                   PARM      '*FIRST'      @OPTN             7              I:Option     S0148
     C     SDPORT        PARM      SDPORT        DSFDY                            O:Rec format S0148
     C*                                                                   S01486
     C     @RTCD         IFNE      *BLANK                                                      S0148
     C                   MOVEL     'SDPORTPD'    DBFILE                         *************  S0148
     C                   MOVEL     '016'         DBASE                          * DBERR 016 *  S0148
     C                   MOVEL     @OPTN         DBOPTN            7            *************  S0148
     C                   SETON                                        U7U8                     S0148
     C                   EXSR      *PSSR                                                       S0148
     C                   GOTO      ENDT                                                        S0148
     C                   END                                                                   S0148
     C                   END                                                                   S0148
     C*                                                                   S01465
     C** Access customer lending data                                     S01465
     C*                                                                   S01465
     C                   CALL      'AOCLNDR0'                                                  S0146
     C                   PARM      '*DBERR '     @RTCD             7                           S0146
     C                   PARM      '*FIRST '     @OPTN             7                           S0146
     C********** SDCLND    PARM SDCLND    DSFDY                                        S01465 CLE134
     C     SDCLND        PARM      SDCLND        DSSDY
     C*                                                                   S01465
     C                   MOVE      '0'           *IN67                                         S0146
     C     @RTCD         IFNE      *BLANK                                                      S0146
     C                   MOVEL     'SDCLNDPD'    DBFILE                         ************   S0146
     C                   MOVEL     @OPTN         DBKEY                          * DBERR 22 *   S0146
     C                   Z-ADD     22            DBASE                          ************   S0146
     C                   EXSR      *PSSR                                                       S0146
     C                   GOTO      ENDT                                                        S0146
     C                   ELSE                                                                  S0146
     C     BPGIAV        IFEQ      'Y'                                                         S0146
     C                   MOVE      '1'           *IN67                                         S0146
     C                   END                                                                   S0146
     C                   END                                                                   S0146
     C*                                                                   S01465
     C** Access SAR details file to determine if the core feature         S01465
     C** S01465 is switched on                                            S01465
     C*                                                                   S01465
     C                   MOVE      '0'           *IN68                                         S0146
     C                   CALL      'AOSARDR0'                                                  S0146
     C                   PARM      *BLANKS       @RTCD             7                           S0146
     C                   PARM      '*VERIFY'     @OPTN             7                           S0146
     C                   PARM      'S01465'      @SARD             6                           S0146
     C     SCSARD        PARM      SCSARD        DSFDY                                         S0146
     C*                                                                   S01465
     C     @RTCD         IFEQ      *BLANKS                                                     S0146
     C                   MOVE      '1'           *IN68                                         S0146
     C                   ELSE                                                                  S0146
     C     @RTCD         IFNE      '*NRF   '                                                   S0146
     C                   MOVEL     'LE0310 '     DBPGM                                         S0146
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************   S0146
     C                   MOVEL     '*VERIFY'     DBKEY                          * DBERR 23 *   S0146
     C                   Z-ADD     23            DBASE                          ************   S0146
     C                   EXSR      *PSSR                                                       S0146
     C                   GOTO      ENDT                                                        S0146
     C                   END                                                                   S0146
     C                   END                                                                   S0146
     C*
     C***/COPY*WNCPYSRC,LE0310CCP3***                                                         CFC006
     C/COPY WNCPYSRC,LE0310CCP3                                                             MD020563
     C*
      *****************************************************************           AR1097176 MD020563
      ***Check*if*CFC006*-*COB*Restructure*-*Remove*reports*from*COB***           AR1097176 MD020563
      ***is*installed**************************************************           AR1097176 MD020563
      *****************************************************************           AR1097176 MD020563
     C**********           CALL 'AOSARDR0'                                        AR1097176 MD020563
     C**********           PARM *BLANKS   PRTCD                                   AR1097176 MD020563
     C**********           PARM '*VERIFY' POPTN                                   AR1097176 MD020563
     C**********           PARM 'CFC006'  PSARD                                   AR1097176 MD020563
     C********** SCSARD    PARM SCSARD    DSSDY                                   AR1097176 MD020563
      *****************************************************************           AR1097176 MD020563
     C********** PRTCD     IFNE *BLANKS                                           AR1097176 MD020563
     C********** PRTCD     ANDNE'*NRF   '                                         AR1097176 MD020563
     C********** *LOCK     IN   LDA                                               AR1097176 MD020563
     C**********           MOVEL'LE0310'  DBPGM                                   AR1097176 MD020563
     C**********           MOVEL'SCSARDPD'DBFILE                                  AR1097176 MD020563
     C**********           MOVEL'CFC006'  DBKEY                                   AR1097176 MD020563
     C**********           Z-ADD60        DBASE                                   AR1097176 MD020563
     C**********           OUT  LDA                                               AR1097176 MD020563
     C**********           MOVE *ON       *INU7                                   AR1097176 MD020563
     C**********           MOVE *ON       *INU8                                   AR1097176 MD020563
     C**********           MOVE *ON       *INLR                                   AR1097176 MD020563
     C**********           EXSR *PSSR                                             AR1097176 MD020563
     C**********           GOTO ENDT                                              AR1097176 MD020563
     C**********           ENDIF                                                  AR1097176 MD020563
      *****************************************************************           AR1097176 MD020563
     C**********           MOVE 'N'       CFC006  1                               AR1097176 MD020563
     C********** PRTCD     IFEQ *BLANKS                                           AR1097176 MD020563
     C**********           MOVE 'Y'       CFC006                                  AR1097176 MD020563
     C**********           ENDIF                                                  AR1097176 MD020563
      *                                                                                       CFC006
      ** Enable output indicator for LE0310P1                                                 CFC006
      *                                                                                       CFC006
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'N'           SUPFLG            1
     C********** CFC006    IFEQ 'Y'                                               AR1097176 MD020563
     C                   CALL      'AOCOMR0'
     C                   PARM      'LEC06  '     PNAME            10
     C                   PARM      '*ALL '       PCSEQ             5
     C                   PARM      SECTN         PSCTN            50
     C                   PARM      *BLANKS       PRTCD
      *                                                                                       CFC006
     C     PRTCD         IFEQ      'Y      '
     C                   MOVEL     'Y'           SUPFLG
     C                   MOVE      *OFF          *IN97
     C                   ENDIF
     C**********           ENDIF                                                  AR1097176 MD020563
      *                                                                                       CFC006
      **                                                                  S01117
      **   ACCESS GENERAL LEDGER DETAILS                                  S01117
      **                                                                  S01117
     C**********           CALL 'AOGELRR0'                                             S01117 CGL029
     C                   CALL      'AOGELRR1'
     C                   PARM      '*MSG   '     @RTCD             7                           S0111
     C                   PARM      '*FIRST '     @OPTN             7                           S0111
     C********** SDGELR    PARM SDGELR    DSFDY                                        S01117 CGL029
     C     SDGELR        PARM      SDGELR        DSSDY
     C*                                                                   S01117
     C     @RTCD         IFNE      *BLANK                                                      S0111
     C                   SETON                                        U7U8LR                   S0111
     C                   MOVEL     'SDGELRPD'    DBFILE                         ***************S0111
     C                   MOVEL     @OPTN         DBKEY                          * DBERROR 05  *S0111
     C                   Z-ADD     5             DBASE                          ***************S0111
     C                   EXSR      *PSSR                                                       S0111
     C                   GOTO      ENDT                                                        S0111
     C                   END                                                                   S0111
      ** Access Dealing details                                                              CER073D
     C                   CALL      'AODEALR1'                                                CER073D
     C                   PARM      *BLANKS       @RTCD                                       CER073D
     C                   PARM      '*FIRST '     @OPTN                                       CER073D
     C     SDDEAL        PARM      SDDEAL        DSSDY                                       CER073D
      *                                                                                      CER073D
     C     @RTCD         IFNE      *BLANKS                                                   CER073D
     C                   SETON                                        U7U8LR                 CER073D
     C                   MOVEL     'SDDEALPD'    DBFILE                                      CER073D
     C                   Z-ADD     900           DBASE                                       CER073D
     C                   MOVEL     @OPTN         DBKEY                                       CER073D
     C                   EXSR      *PSSR                                                     CER073D
     C                   GOTO      ENDT                                                      CER073D
     C                   ENDIF                                                               CER073D
      *                                                                   S01518
      **  Access SAR details file to see if S01518 is installed           S01518
      *                                                                   S01518
     C                   CALL      'AOSARDR0'                                                  S0151
     C                   PARM      '       '     @RTCD             7                           S0151
     C                   PARM      '*VERIFY'     @OPTN             7                           S0151
     C                   PARM      'S01518'      @SARD             6                           S0151
      *                                                                   S01518
     C     @RTCD         IFEQ      *BLANK                                                      S0151
     C                   MOVE      '1'           *IN80                                         S0151
     C                   ELSE                                                                  S0151
     C     @RTCD         IFNE      '*NRF   '                                                   S0151
     C                   SETON                                        U7U8LR                   S0151
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************   S0151
     C                   MOVEL     @SARD         DBKEY                          DB ERROR 007   S0151
     C                   Z-ADD     7             DBASE                          ************   S0151
     C                   EXSR      *PSSR                                                       S0151
     C                   GOTO      ENDT                                                        S0151
     C                   ELSE                                                                  S0151
     C                   MOVE      '0'           *IN80                                         S0151
     C                   END                                                                   S0151
     C                   END                                                                   S0151
     C*                                                                   S01408
     C*COPY*WMCPYSRC,LE0310CCP2************************                   S01408
     C/COPY WNCPYSRC,LE0310CCP2                                           S01408
     C                   MOVE      *OFF          *IN97
      *                                                                                       CER020
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CER020'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CER020
     C     PRTCD         IFEQ      *BLANKS
      *                                                                                       CER020
     C                   MOVE      'Y'           CER020            1
     C                   MOVE      *ON           *IN97
      *                                                                                       CER020
     C                   ELSE
     C                   MOVE      'N'           CER020
      *                                                                                       CER020
     C     PRTCD         IFNE      '*NRF   '
      *                                                                                       CER020
      ** Call to program ended in error                                                       CER020
      *                                                                                       CER020
     C                   MOVEL     'CER020'      DBKEY
     C                   MOVE      'SCSARDPD'    DBFILE
     C                   Z-ADD     75            DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
      *                                                                                       CER020
     C                   GOTO      ENDT
      *                                                                                       CER020
     C                   ENDIF
      *                                                                                       CER020
     C                   ENDIF
      *                                                                                       CER020
     C*                                                                   S01408
      **                                                                  S01117
      **   CHECK THE MULTIBRANCHING INDICATOR                             S01117
      **                                                                  S01117
     C     MBIN          IFEQ      'Y'                                                         S0111
      *                                                                   S01117
     C                   SETON                                        75                       S0111
     C     OBRU          IFNE      'Y'                                                         S0111
     C                   SETON                                        76                       S0111
     C                   ELSE                                                                  S0111
     C                   SETOFF                                       76                       S0111
     C                   END                                                                   S0111
      *                                                                   S01117
     C                   ELSE                                                                  S0111
     C                   SETOFF                                       75                       S0111
     C                   SETON                                        76                       S0111
     C                   END                                                                   S0111
      **                                                                  S01117
      **   SETON INDICATOR FOR NO PRINTING, PROFIT CENTRE FIELD           S01117
      **                                                                  S01117
     C     PFCU          IFNE      'Y'                                                         S0111
     C                   SETON                                        77                       S0111
     C                   ELSE                                                                  S0111
     C                   SETOFF                                       77                       S0111
     C                   END                                                                   S0111
      *                                                                                       196066
      ** Check if SAR is switched ON                                                          196066
      *                                                                                       196066
     C                   MOVE      'N'           CLE002            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       196066
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE002
     C                   MOVE      '1'           *IN39
     C                   END
      *                                                                                       196066
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
      *                                                                                       196066
      ** Call to program ended in error                                                       196066
      *                                                                                       196066
     C     *LOCK         IN        LDA
     C                   MOVEL     'CLE002'      DBKEY                          ***************
     C                   MOVE      'SCSARDPD'    DBFILE                         * DB ERROR 20 *
     C                   Z-ADD     20            DBASE                          ***************
     C                   MOVEL     'LE0310'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   SETON                                        U7U8
     C                   GOTO      ENDT
     C                   ENDIF
     C*                                                                   CLE004
     C** Check if SAR is switched ON                                      CLE004
     C*                                                                   CLE004
     C                   MOVE      'N'           CLE004            1                           CLE00
     C                   CALL      'AOSARDR0'                                                  CLE00
     C                   PARM      *BLANKS       @RTCD                                         CLE00
     C                   PARM      '*VERIFY'     @OPTN                                         CLE00
     C                   PARM      'CLE004'      @SARD             6                           CLE00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CLE00
     C*                                                                   CLE004
     C     @RTCD         IFEQ      *BLANKS                                                     CLE00
     C                   MOVE      'Y'           CLE004                                        CLE00
     C                   MOVE      *ON           *IN84                                         CLE00
     C                   MOVE      *ON           *IN87                                         CLE00
     C                   END                                                                   CLE00
     C*                                                                   CLE004
     C     @RTCD         IFNE      *BLANKS                                                     CLE00
     C     @RTCD         ANDNE     '*NRF   '                                                   CLE00
     C*                                                                   CLE004
     C** Call to program ended in error                                   CLE004
     C*                                                                   CLE004
     C     *LOCK         IN        LDA                                                         CLE00
     C                   MOVEL     'CLE004'      DBKEY                          ***************CLE00
     C                   MOVE      'SCSARDPD'    DBFILE                         * DB ERROR 47 *CLE00
     C                   Z-ADD     47            DBASE                          ***************CLE00
     C                   MOVEL     'LE0310'      DBPGM                                         CLE00
     C                   OUT       LDA                                                         CLE00
     C                   EXSR      *PSSR                                                       CLE00
     C                   SETON                                        U7U8                     CLE00
     C                   GOTO      ENDT                                                        CLE00
     C                   ENDIF                                                                 CLE00
     C*                                                                   CLE004
     C                   MOVE      'N'           CLE006            1                           CLE00
     C***********          MOVE *OFF      *IN85                     187904CLE015
     C                   CALL      'AOSARDR0'                                                  CLE00
     C                   PARM      *BLANKS       @RTCD                                         CLE00
     C                   PARM      '*VERIFY'     @OPTN                                         CLE00
     C                   PARM      'CLE006'      @SARD             6                           CLE00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CLE00
     C*                                                                   CLE006
     C     @RTCD         IFEQ      *BLANKS                                                     CLE00
     C                   MOVE      'Y'           CLE006                                        CLE00
     C***********          MOVE *ON       *IN85                     187904CLE015
     C                   END                                                                   CLE00
     C*                                                                   CLE006
     C     @RTCD         IFNE      *BLANKS                                                     CLE00
     C     @RTCD         ANDNE     '*NRF   '                                                   CLE00
     C*                                                                   CLE006
     C** Call to program ended in error                                   CLE006
     C*                                                                   CLE006
     C     *LOCK         IN        LDA                                                         CLE00
     C                   MOVEL     'CLE006'      DBKEY                          ***************CLE00
     C                   MOVE      'SCSARDPD'    DBFILE                         * DB ERROR 48 *CLE00
     C                   Z-ADD     48            DBASE                          ***************CLE00
     C                   MOVEL     'LE0310'      DBPGM                                         CLE00
     C                   OUT       LDA                                                         CLE00
     C                   EXSR      *PSSR                                                       CLE00
     C                   SETON                                        U7U8                     CLE00
     C                   GOTO      ENDT                                                        CLE00
     C                   ENDIF                                                                 CLE00
     C*                                                                   CLE006
     C                   MOVE      'N'           CLE007            1                           CLE01
     C                   CALL      'AOSARDR0'                                                  CLE01
     C                   PARM      *BLANKS       @RTCD                                         CLE01
     C                   PARM      '*VERIFY'     @OPTN                                         CLE01
     C                   PARM      'CLE007'      @SARD             6                           CLE01
     C     SCSARD        PARM      SCSARD        DSFDY                                         CLE01
     C*                                                                   CLE015
     C     @RTCD         IFEQ      *BLANKS                                                     CLE01
     C                   MOVE      'Y'           CLE007                                        CLE01
     C                   END                                                                   CLE01
     C*                                                                   CLE015
     C     CLE006        IFEQ      'Y'                                                         CLE01
     C     CLE007        OREQ      'Y'                                                         CLE01
     C                   MOVE      *ON           *IN85                                         CLE01
     C                   ELSE                                                                  CLE01
     C                   MOVE      *OFF          *IN85                                         CLE01
     C                   ENDIF                                                                 CLE01
     C*                                                                   CLE015
     C     @RTCD         IFNE      *BLANKS                                                     CLE01
     C     @RTCD         ANDNE     '*NRF   '                                                   CLE01
     C*                                                                   CLE015
     C** Call to program ended in error                                   CLE015
     C*                                                                   CLE015
     C     *LOCK         IN        LDA                                                         CLE01
     C                   MOVEL     'CLE006'      DBKEY                          ***************CLE01
     C                   MOVE      'SCSARDPD'    DBFILE                         * DB ERROR 50 *CLE01
     C                   Z-ADD     50            DBASE                          ***************CLE01
     C                   MOVEL     'LE0310'      DBPGM                                         CLE01
     C                   OUT       LDA                                                         CLE01
     C                   EXSR      *PSSR                                                       CLE01
     C                   SETON                                        U7U8                     CLE01
     C                   GOTO      ENDT                                                        CLE01
     C                   ENDIF                                                                 CLE01
     C*                                                                   CLE015
     C                   MOVE      'N'           CLE005            1                           CLE00
     C                   CALL      'AOSARDR0'                                                  CLE00
     C                   PARM      *BLANKS       @RTCD                                         CLE00
     C                   PARM      '*VERIFY'     @OPTN                                         CLE00
     C                   PARM      'CLE005'      @SARD             6                           CLE00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CLE00
     C*                                                                   CLE005
     C     @RTCD         IFEQ      *BLANKS                                                     CLE00
     C                   MOVE      'Y'           CLE005                                        CLE00
     C                   END                                                                   CLE00
     C*                                                                   CLE005
     C     @RTCD         IFNE      *BLANKS                                                     CLE00
     C     @RTCD         ANDNE     '*NRF   '                                                   CLE00
     C*                                                                   CLE005
     C** Call to program ended in error                                   CLE005
     C*                                                                   CLE005
     C     *LOCK         IN        LDA                                                         CLE00
     C                   MOVEL     'CLE005'      DBKEY                          ***************CLE00
     C                   MOVE      'SCSARDPD'    DBFILE                         * DB ERROR 49 *CLE00
     C                   Z-ADD     49            DBASE                          ***************CLE00
     C                   MOVEL     'LE0310'      DBPGM                                         CLE00
     C                   OUT       LDA                                                         CLE00
     C                   EXSR      *PSSR                                                       CLE00
     C                   SETON                                        U7U8                     CLE00
     C                   GOTO      ENDT                                                        CLE00
     C                   ENDIF                                                                 CLE00
     C*                                                                   CLE005
      ** Access SAR details file to see if EMU Lending                    CEU020
      ** Multi-Ccy Rollover                                               CEU020
      *                                                                   CEU020
     C                   MOVE      'N'           CEU020            1                           CEU02
     C                   CALL      'AOSARDR0'                                                  CEU02
     C                   PARM      *BLANKS       @RTCD                                         CEU02
     C                   PARM      '*KEY   '     @OPTN                                         CEU02
     C                   PARM      'CEU020'      @SARD                                         CEU02
     C     SCSARD        PARM      SCSARD        DSFDY                                         CEU02
      *                                                                   CEU020
     C     @RTCD         IFEQ      *BLANK                                                      CEU02
     C                   MOVE      'Y'           CEU020                                        CEU02
     C                   ELSE                                                                  CEU02
     C                   MOVE      'N'           CEU020                                        CEU02
     C     @RTCD         IFNE      '*NRF   '                                                   CEU02
     C     *LOCK         IN        LDA                                                         CEU02
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************   CEU02
     C                   Z-ADD     050           DBASE                          * DBERR 50 *   CEU02
     C                   MOVEL     'CEU020'      DBKEY                          ************   CEU02
     C                   OUT       LDA                                                         CEU02
     C                   EXSR      *PSSR                                                       CEU02
     C                   SETON                                        U7U8                     CEU02
     C                   GOTO      ENDT                                                        CEU02
     C                   ENDIF                                                                 CEU02
     C                   ENDIF                                                                 CEU02
      *                                                                   S01117
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE028'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE028
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE028            1
     C                   MOVE      *ON           *IN10
     C                   ELSE
     C                   MOVE      'N'           CLE028
     C                   MOVE      *OFF          *IN10
     C                   ENDIF
      *                                                                                       CLE028
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
      *                                                                                       CLE028
      ** Call to program ended in error                                                       CLE028
      *                                                                                       CLE028
     C                   MOVEL     'CLE028'      DBKEY
     C                   MOVE      'SCSARDPD'    DBFILE
     C                   Z-ADD     52            DBASE
     C                   MOVEL     'LE0310  '    DBPGM
     C                   EXSR      *PSSR
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   GOTO      ENDT
     C                   ENDIF
      *                                                                                       CLE028
      ** Determine if Lending Enhancements (CLE031) is installed.                             CLE031
      *                                                                                       CLE031
     C                   MOVE      'CLE031'      PSARD
     C                   MOVE      'N'           CLE031            1
      *                                                                                       CLE031
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM                    PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE031
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE031
     C                   MOVE      *ON           *IN11
     C                   ENDIF
      *                                                                                       CLE031
     C     PRTCD         IFNE      '*NRF    '
     C     PRTCD         ANDNE     *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     52            DBASE
     C                   MOVEL     'CLE031'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   GOTO      ENDT
     C                   ENDIF
      *                                                                                       CLE034
      ** Determine if CLE034 is installed.                                                    CLE034
      *                                                                                       CLE034
     C                   MOVE      'CLE034'      PSARD
     C                   MOVE      'N'           CLE034            1
      *                                                                                       CLE034
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM                    PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE034
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE034
     C                   MOVE      *ON           *IN16
     C                   ENDIF
      *                                                                                       CLE034
     C     PRTCD         IFNE      '*NRF    '
     C     PRTCD         ANDNE     *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     53            DBASE
     C                   MOVEL     'CLE034'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   GOTO      ENDT
     C                   ENDIF
      *                                                                                       CER001
      ** Determine if ULX004 is installed.                                                    CER001
      *                                                                                       CER001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'ULX004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      *ON           *IN74
     C                   MOVE      'Y'           ULX004            1
     C                   ELSE
     C                   MOVE      *OFF          *IN74
     C                   MOVE      'N'           ULX004
     C     @RTCD         IFNE      '*NRF    '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     54            DBASE
     C                   MOVEL     'ULX004'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE036
      ** Determine if CLE036 is installed.                                                    CLE036
      *                                                                                       CLE036
     C                   MOVE      'CLE036'      PSARD
     C                   MOVE      'N'           CLE036            1
      *                                                                                       CLE036
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM                    PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE036
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE036
     C                   MOVE      *ON           *IN72
     C                   ENDIF
      *                                                                                       CLE036
     C     PRTCD         IFNE      '*NRF    '
     C     PRTCD         ANDNE     *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     54            DBASE
     C                   MOVEL     'CLE036'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   GOTO      ENDT
     C                   ENDIF
      *                                                                                       CLE038
      ** Determine if CLE038 is installed.                                                    CLE038
      *                                                                                       CLE038
     C                   MOVE      'N'           CLE038            1
      *                                                                                       CLE038
     C     CLE034        IFEQ      'Y'
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE038'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE038
     C     PRTCD         IFNE      '*NRF    '
     C     PRTCD         ANDNE     *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'LE0310  '    DBPGM
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CLE038'      DBKEY
     C                   Z-ADD     55            DBASE
     C                   OUT       LDA
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   EXSR      *PSSR
     C                   GOTO      ENDT
     C                   ELSE
     C                   MOVE      'Y'           CLE038
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE038
      ** If CLE038 is installed, check for system value                                       CLE038
      ** 'Settlement09Postings' and set-up currency array                                     CLE038
      *                                                                                       CLE038
     C     CLE038        IFEQ      'Y'
      *                                                                                       CLE038
     C                   MOVEL     SVAL(1)       P@OP01
     C                   EXSR      SRSVAL
     C                   MOVEL     P@VL01        SET09             1
     C     *INU7         IFEQ      *ON
     C                   GOTO      ENDT
     C                   ENDIF
      *                                                                                       CLE038
     C                   EXSR      CCYARS
      *                                                                                       CLE038
     C                   ENDIF
      *                                                                                       247519
      ** Determine if CLE043 is installed.                                                    247519
      *                                                                                       247519
     C                   MOVE      'N'           CLE043            1
      *                                                                                       247519
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE043'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       247519
     C     PRTCD         IFNE      '*NRF    '
     C     PRTCD         ANDNE     *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'LE0310  '    DBPGM
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CLE043'      DBKEY
     C                   Z-ADD     58            DBASE
     C                   OUT       LDA
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   EXSR      *PSSR
     C                   GOTO      ENDT
     C                   ELSE
     C                   MOVE      'Y'           CLE043
     C                   ENDIF
      *                                                                                       CLE143
      ** Determine if CLE143 is installed.                                                    CLE143
      *                                                                                       CLE143
     C                   MOVE      'N'           CLE143            1
      *                                                                                       CLE143
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE143'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE143
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE143
     C                   ELSE
     C                   MOVE      'N'           CLE143
     C     PRTCD         IFNE      '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'LE0310  '    DBPGM
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CLE143'      DBKEY
     C                   Z-ADD     58            DBASE
     C                   OUT       LDA
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   EXSR      *PSSR
     C                   GOTO      ENDT
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE143
      ** Determine if CAS009 is installed.                                                    CLE143
      *                                                                                       CLE143
     C                   MOVE      'N'           CAS009            1
      *                                                                                       CLE143
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CAS009'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE143
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAS009
     C                   ELSE
     C                   MOVE      'N'           CAS009
     C     PRTCD         IFNE      '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'LE0310  '    DBPGM
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CAS009'      DBKEY
     C                   Z-ADD     59            DBASE
     C                   OUT       LDA
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   EXSR      *PSSR
     C                   GOTO      ENDT
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CRE073
      ** Determine if CRE073 Interest Rate Rounding feature is installed                      CRE073
      *                                                                                       CRE073
     C                   MOVE      'N'           CRE073            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CRE073'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CRE073
     C     PRTCD         IFNE      '*NRF    '
     C     PRTCD         ANDNE     *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'LE0310  '    DBPGM
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CRE073'      DBKEY
     C                   Z-ADD     59            DBASE
     C                   OUT       LDA
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   EXSR      *PSSR
     C                   GOTO      ENDT
     C                   ENDIF
      *                                                                                       CRE073
     C     PRTCD         IFEQ      BLANKS
     C                   MOVE      'Y'           CRE073
     C                   ENDIF
      *                                                                                       CLE141
      ** Check if CLE141 is switched ON                                                       CLE141
      *                                                                                       CLE141
     C                   MOVE      'N'           CLE141            1
     C                   MOVE      *OFF          *IN83
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE141'      PSARD
      *                                                                                       CLE141
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE141
     C                   MOVE      *ON           *IN83
     C                   ENDIF
      *                                                                                       CER073
      ** Check if CER073 is switched ON                                                       CER073
      *                                                                                       CER073
     C                   MOVE      'N'           CER073            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CER073'      PSARD
      *                                                                                       CER073
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CER073
     C                   ENDIF
      *                                                                                       CER050
      ** Determine if CER050 feature is enabled                                               CER050
      *                                                                                       CER050
     C                   MOVE      'N'           CER050            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CER050'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CER050
     C     PRTCD         IFNE      '*NRF    '
     C     PRTCD         ANDNE     *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'LE0310  '    DBPGM
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CER050'      DBKEY
     C                   Z-ADD     61            DBASE
     C                   OUT       LDA
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   EXSR      *PSSR
     C                   GOTO      ENDT
     C                   ENDIF
      *                                                                                       CER050
     C     PRTCD         IFEQ      BLANKS
     C                   MOVE      'Y'           CER050
     C                   ENDIF
      *                                                                                       CLE034
      ** Define new output variables for exception header.                                    CLE034
      *                                                                                       CLE034
     C     *LIKE         DEFINE    BRCA          WEBRCA
     C     *LIKE         DEFINE    BRNM          WEBRNM
     C     *LIKE         DEFINE    CHTPA         WECHTP
     C     *LIKE         DEFINE    BOKC          WEBOKC
     C     *LIKE         DEFINE    CRNM1         WECNM1
     C     *LIKE         DEFINE    FCUS          WEFCUS
     C     *LIKE         DEFINE    FTYP          WEFTYP
     C     *LIKE         DEFINE    FSEQ          WEFSEQ
     C     *LIKE         DEFINE    LTYP          WELTYP
     C     *LIKE         DEFINE    SUTP          WESUTP
     C     *LIKE         DEFINE    CLAS          WECLAS
     C     *LIKE         DEFINE    LASQ          WELASQ
     C     *LIKE         DEFINE    CNUM          WECNUM
     C     *LIKE         DEFINE    CCY           WECCY
     C     *LIKE         DEFINE    CPAM          WECPAM
     C     *LIKE         DEFINE    CRNM2         WECNM2
     C     *LIKE         DEFINE    OLNO          WEOLNO
     C     *LIKE         DEFINE    RCSI          WERCSI
      *                                                                                       CLE034
     C     KEY001        KLIST                                                                 14082
     C                   KFLD                    WBRCA             3                           14082
     C**********           KFLD           WCNUM   60                                   140821 CSD027
     C                   KFLD                    WCNUM             6
     C                   KFLD                    WFACT             3 0                         14082
     C                   KFLD                    WFCNO             2 0                         14082
      *                                                                   140821
     C     KSTAL5        KLIST
     C                   KFLD                    KTYPE             4
     C**********           KFLD           KLNRF   60                                   CLE034 CLE148
     C                   KFLD                    KLNRF             6
      *                                                                                       CLE034
     C                   MOVEL     'LOAN '       KTYPE
0392 C     ENDFC         TAG                                                    ** ENDFC TAG **
     C/COPY WNCPYSRC,LE0310C006
0393 C*
      *                                                                                       CLE034
      ** If not the first loan read and settlement allocation                                 CLE034
      ** are to be printed, print settlemenet allocation details                              CLE034
      ** for LE0310P1.                                                                        CLE034
      *                                                                                       CLE034
     C     *IN17         IFEQ      *ON
     C********** *IN84     ANDEQ*OFF                                                  CLE034 BUG8954
     C     CLE034        ANDEQ     'Y'
      *                                                                                       CLE034
     C                   MOVEL     'Y'           W1ST              1
     C     KSTAL5        SETLL     LESTALL5
     C     KSTAL5        READE     LESTALL5                               18
      *                                                                                       CLE034
      ** Determine if Receipt/Pay Settlement Allocation                                       CLE038
      ** by Amount will be used instead of percentage.                                        CLE038
      *                                                                                       CLE038
     C     CLE038        IFEQ      'Y'
     C                   MOVE      *OFF          *IN89
     C                   MOVE      *OFF          *IN40
      *                                                                                       CLE038
     C     LRCBA         IFEQ      'A'
     C                   MOVE      *ON           *IN89
     C                   ENDIF
      *                                                                                       CLE038
     C     LPYBA         IFEQ      'A'
     C                   MOVE      *ON           *IN40
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE038
     C     *IN18         DOWEQ     *OFF
      *                                                                                       CLE034
     C     W1ST          IFEQ      'Y'
     C     *INOF         OREQ      *ON
      *                                                                                       CLE034
      ** Print settlement allocation details next page, hence                                 CLE034
      ** it is necessary to print header and subheader.                                       CLE034
      *                                                                                       CLE034
     C***/COPY*WNCPYSRC,LEH01009***                                                           CFC006
     C/COPY WNCPYSRC,LEH01009                                                               MD020563
     C     SUPFLG        IFNE      'Y'
     C                   EXCEPT    EHDR1
     C                   EXCEPT    EHDR2
     C                   EXCEPT    EHDR3
     C                   EXCEPT    EHDR4
     C                   EXCEPT    EHDR5
     C                   EXCEPT    EHDR6
     C                   EXCEPT    EHDR7
     C                   EXCEPT    EHDR8
     C                   EXCEPT    EHDR9
     C***/COPY*WNCPYSRC,LEH01010***                                                           CFC006
     C/COPY WNCPYSRC,LEH01010                                                               MD020563
     C                   ENDIF
      *                                                                                       CLE034
     C                   MOVEL     'N'           W1ST
     C                   MOVE      *OFF          *INOF
     C                   ENDIF
      *                                                                                       CLE034
      ** Format details for settlement allocation.                                            CLE034
      *                                                                                       CLE034
     C                   EXSR      SRFMT
      *                                                                                       CLE034
      ** Write details for settlement allocation.                                             CLE034
      *                                                                                       CLE034
     C***/COPY*WNCPYSRC,LEH01011***                                                           CFC006
     C/COPY WNCPYSRC,LEH01011                                                               MD020563
     C     SUPFLG        IFNE      'Y'
     C                   EXCEPT    EDET1
     C***/COPY*WNCPYSRC,LEH01012***                                                           CFC006
     C/COPY WNCPYSRC,LEH01012                                                               MD020563
     C                   ENDIF
      *                                                                                       CLE034
      ** Read next compatible record.                                                         CLE034
      *                                                                                       CLE034
     C     KSTAL5        READE     LESTALL5                               18
     C                   ENDDO
      *                                                                                       CLE034
     C                   ENDIF
      *                                                                                       CLE034
      ** If branch changes (for syndicated loans/participation),          CLE004
      ** open a new printer file.                                         CLE004
      *                                                                   CLE004
     C     CLE004        IFEQ      'Y'                                                         CLE00
     C     *INL1         IFEQ      *ON                                                         CLE00
STOP  *                                                                   CLE004
     C     OPEN2         IFEQ      '1'                                                         CLE00
     C     *INU7         IFEQ      *ON                                                         CLE00
     C                   MOVE      *ON           *IN70                                         CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
     C     *IN70         IFEQ      *ON                                                         CLE00
     C     CLE006        ANDEQ     'Y'                                                         18766
     C     *IN84         OREQ      *ON                                                         CLE00
     C     CLE006        ANDEQ     'Y'                                                         18766
     C                   WRITE     HEADP2                                                      CLE00
     C                   ENDIF                                                                 CLE00
     C     CLE006        IFEQ      'Y'                                                         18766
     C                   WRITE     TRAIL2                                                      CLE00
     C                   ENDIF                                                                 18766
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
     C     OPEN2         IFEQ      '1'                                                         CLE00
     C     *IN75         ANDEQ     *ON                                                         CLE00
     C     CLE006        ANDEQ     'Y'                                                         18766
     C                   CLOSE     LE0310P2                                                    CLE00
     C                   ENDIF                                                                 CLE00
     C     OPEN2         IFNE      '1'                                                         CLE00
     C     *IN75         ANDEQ     *OFF                                                        CLE00
     C     CLE006        ANDEQ     'Y'                                                         18766
     C     *IN75         OREQ      *ON                                                         CLE00
     C     CLE006        ANDEQ     'Y'                                                         18766
     C                   OPEN      LE0310P2                                                    CLE00
      *                                                                   CLE004
     C                   Z-ADD     SFNUM2        ZSNUM                                         CLE00
     C                   UNLOCK    LDA                                                         12152
     C                   CALL      'ZSFILE'                                                    CLE00
     C                   PARM                    SEQ                                           CLE00
     C                   PARM      BRCA          SENTY             3                           CLE00
     C                   PARM                    SFILE2                                        CLE00
     C                   PARM                    ZSNUM                                         CLE00
     C                   PARM                    ZSERR             1                           CLE00
     C     *LOCK         IN        LDA                                                         12152
      *                                                                   CLE004
      ** Error during ZSFILE processing, return to calling program        CLE004
      *                                                                   CLE004
     C     ZSERR         IFEQ      'Y'                                                         CLE00
     C                   SETON                                        U7U8LR                   CLE00
     C                   RETURN                                                                CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
     C                   MOVE      *ON           *IN84                                         CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
      ** Save branch used.                                                CLE004
      *                                                                   CLE004
     C                   MOVE      BRCA          RPBRC                                         CLE00
     C                   ENDIF                                                                 CLE00
     C                   ENDIF                                                                 CLE00
0394 C*
0395 C                   SETOFF                                       020304                   S0111
0395 C                   SETOFF                                       050607                   S0111
0395 C                   SETOFF                                       2230
0396 C                   SETOFF                                       242526
     C                   SETOFF                                       2328
      **                                                                  S01117
      ** IF MBIN=YES, AND A LEVEL BREAK,                                  S01117
      ** OPEN LE0310P1                                                    S01117
     C     *INL1         IFEQ      '1'                                                         S0111
      *                                                                   S01117
     C                   CLOSE     LE0310P1                                                    S0111
      *                                                                   S01117
     C                   SETON                                        19                       S0111
     C                   MOVE      'Y'           P1OP              1                           S0111
      *                                                                   S01117
     C                   OPEN      LE0310P1                                                    S0111
     C                   Z-ADD     0             PAGE                                          S0111
      **                                                                  S01117
      ** ENSURE REPORT SPOOL FILE RECORDED BY RCF                         S01117
     C                   Z-ADD     SFNUM         ZSNUM             6 0                         S0111
     C                   OUT       LDA                                                         S0111
     C                   CALL      'ZSFILE'                                                    S0111
     C                   PARM                    SEQ               5                           S0111
     C                   PARM      BRCA          SENTY             3                           S0111
     C                   PARM                    SFILE                                         S0111
     C                   PARM                    ZSNUM                                         S0111
     C                   PARM                    ZSERR             1                           S0111
      *                                                                   S01117
     C     *LOCK         IN        LDA                                                         S0111
     C     ZSERR         IFEQ      'Y'                                                         S0111
      **  ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAM       S01117
     C                   SETON                                        U7U8LR                   S0111
     C                   RETURN                                                                S0111
     C                   END                                                                   S0111
     C**                                                                  S01117
      **                                                                  S01117
      ** GET BRANCH NAME, ONLY WHEN MBIN = 'Y'                            S01117
      **                                                                  S01117
     C     MBIN          IFEQ      'Y'                                                         S0111
      *                                                                   S01117
     C**********           CALL 'AOBRCHR0'                                             S01117 CGL029
     C                   CALL      'AOBRCHR1'
     C                   PARM      '*MSG   '     @RTCD             7                           S0111
     C                   PARM      '*KEY   '     @OPTN             7                           S0111
     C                   PARM      BRCA          @DSNB             3                           S0111
     C********** SDBRCH    PARM SDBRCH    DSFDY                                        S01117 CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C     @RTCD         IFNE      *BLANKS                                                     S0111
     C                   MOVEL     @DSNB         DBKEY                          ***************S0111
     C                   MOVEL     'SDBRCHPD'    DBFILE                         * DBERROR 12  *S0111
     C                   Z-ADD     12            DBASE                          ***************S0111
     C                   SETON                                        U7U8LR                   S0111
     C                   EXSR      *PSSR                                                       S0111
     C                   GOTO      ENDT                                                        S0111
     C                   END                                                                   S0111
      *                                                                   S01117
     C                   END                                                                   S0111
      *                                                                   S01117
     C                   END                                                                   S0111
0397 C*
0398 C*    SELECT PROCESSING FOR RECORD TYPE
0399 C*
     C     RCDT          IFEQ      'A'                                                         S0111
     C     RECIA         IFEQ      'D'                                                         S0111
     C                   SETON                                        02                       S0111
     C                   END                                                                   S0111
     C     RECIA         IFEQ      'M'                                                         S0111
     C                   SETON                                        03                       S0111
     C                   END                                                                   S0111
     C     RECIA         IFEQ      'R'                                                         S0111
     C                   SETON                                        04                       S0111
     C                   END                                                                   S0111
0400 C   02
0401 COR 03
0402 COR 04              EXSR      DETA
     C*                                                                   S01408
     C** Core hook for externalisation.                                   S01408
     C/COPY WNCPYSRC,LE0310CRSP                                           S01408
     C*                                                                   S01408
     C                   END                                                                   S0111
0403 C*
     C     RCDTB         IFEQ      'B'                                                         S0111
     C     RECIB         IFEQ      'D'                                                         S0111
     C                   SETON                                        05                       S0111
     C                   END                                                                   S0111
     C     RECIB         IFEQ      'M'                                                         S0111
     C                   SETON                                        06                       S0111
     C                   END                                                                   S0111
     C     RECIB         IFEQ      'R'                                                         S0111
     C                   SETON                                        07                       S0111
     C                   END                                                                   S0111
0404 C   05
0405 COR 06
0406 COR 07              EXSR      DETB
     C                   END                                                                   S0111
0407 C*
0408 C***08******          EXSR TRLR                                      S01117
     C/COPY WNCPYSRC,LE0310C005
0409 C*
0410 C*
     C     CRE073        IFEQ      'Y'
     C                   MOVE      *ON           *IN09
     C                   ENDIF
      *                                                                   CLE004
0411 C     ENDT          TAG                                                    ** ENDT TAG **
      *                                                                   CLE004
0412 C*
0413 C*    LAST RECORD PROCESSING
      **                                                                  S01117
      **   EXECUTE ERROR ROUTINE IF DATABASE ERROR EXISTS                 S01117
      **                                                                  S01117
     CLR   *INU7         IFEQ      '1'                                                         S0111
     CLR   *INU8         ANDEQ     '1'                                                         S0111
     CLR                 EXSR      *PSSR                                                       S0111
     CLR                 END                                                                   S0111
      **                                                                  S01117
      ** ENSURE TOTALS SPOOL FILE RECORDED BY RCF                         S01117
     CLR                 Z-ADD     SFNUMU        ZSNUMU            6 0                         S0111
     CLR                 OUT       LDA                                                         S0111
     CLR                 CALL      'ZSFILE'                                                    S0111
     CLR                 PARM                    SEQ                                           S0111
     CLR                 PARM      *BLANKS       SENTY             3                           S0111
     CLR                 PARM                    SFILEU                                        S0111
     CLR                 PARM                    ZSNUMU                                        S0111
     CLR                 PARM                    ZSERR                                         S0111
     C**                                                                  S01117
     CLR   *LOCK         IN        LDA                                                         S0111
     CLR   ZSERR         IFEQ      'Y'                                                         S0111
      **  ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAM       S01117
     CLR                 SETON                                        U7U8LR                   S0111
     CLR                 RETURN                                                                S0111
     CLR                 END                                                                   S0111
     C**                                                                  S01117
      **                                                                  S01117
      ** WHEN LR INDICATOR SET ON WITHOUT EXECUTING THE FIRST             S01117
      ** CYCLE                                                            S01117
     CLR   P1OP          IFNE      'Y'                                                         S0111
     CLR                 EXSR      #ZZ                                                         S0111
     CLR                 END                                                                   S0111
0414 C*
0415 C*    EXCEPTION OUTPUT FOR FILE CONTROLS
0416 C*
     CLRNU7
0408 CANNU8              EXSR      TRLR                                                        S0111
      *                                                                   CLE004
      ** Write trailer (and) header for last processing.                  CLE004
      *                                                                   CLE004
     C*LR******* OPEN2     IFNE '1'                                       CLE004       CLE004 245014
     C*LR*******           EXSR CSARC4                                    CLE004       CLE004 245014
     C*LR*******           ENDIF                                          CLE004       CLE004 245014
     CLR   CLE004        IFEQ      'Y'                                                         CLE00
     CLR                 SELECT                                                                CLE00
     CLR   *INU7         WHENEQ    *ON                                                         CLE00
     CLR                 MOVE      *ON           *IN70                                         CLE00
     CLR   *IN75         WHENEQ    *OFF                                                        CLE00
     CLR   *IN84         ANDEQ     *OFF                                                        CLE00
     CLR                 MOVE      *ON           *IN73                                         CLE00
     CLR                 ENDSL                                                                 CLE00
     CLR   OPEN2         IFNE      '1'                                                         CLE00
     CLR   CLE006        ANDEQ     'Y'                                                         18766
     CLR                 EXSR      OPENP2                                                      CLE00
     CLR                 ENDIF                                                                 CLE00
     CLR   *IN70         IFEQ      *ON                                                         CLE00
     CLR   CLE006        ANDEQ     'Y'                                                         18766
     CLR   *IN84         OREQ      *ON                                                         CLE00
     CLR   CLE006        ANDEQ     'Y'                                                         18766
     CLR                 WRITE     HEADP2                                                      CLE00
     CLR                 ENDIF                                                                 CLE00
     CLR   CLE006        IFEQ      'Y'                                                         18766
     CLR                 WRITE     TRAIL2                                                      CLE00
     CLR                 ENDIF                                                                 18766
     CLR                 ENDIF                                                                 CLE00
0417 CLR                 SETON                                        66OF
0418 CLR                 EXCEPT
0419 CLR                 SETOFF                                       66
0420 C*
0421 C*    IF FILE CONTROLS BALANCE, AND NO DATABASE ERROR,
     C*    AND FILE CONTROL CHECK IS YES                                  S01117
0422 C*    UPDATE TRAILER ON FILE
0423 C*
     CLRNU8
0424 CANN34              EXSR      UPDATE
0425 C*
0426 C********************************************************************
0427 C*
0428 C*    DETAIL '1' RECORD PROCESSING
0429 C*
0430 C     DETA          BEGSR                                                  *** DETA ***
0431 C*
0432 C*
0433 C                   SETOFF                                       313233
0434 C                   SETOFF                                       353637
0435 C                   SETOFF                                       384546
0435 C                   SETOFF                                       47
     C/COPY WNCPYSRC,LE0310CCP5                                           S01408
0437 C*
0438 C*    EXECUTE PROCESSING COMMON TO 1 & 2 RECORDS
0439 C*
     C     CER050        IFEQ      'Y'
     C                   MOVE      *ON           *IN98
     C     LNRF          CHAIN     LEAPRHI0                           99
     C     APRC          IFNE      'Y'
     C                   Z-ADD     0             IAPRR
     C                   Z-ADD     0             PREM
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CER050
0440 C                   EXSR      DETAB
     C/COPY WNCPYSRC,LE0310C003
0441 C*
0442 C*
0443 C*    FOR EACH LIVE RECORD (ID = 'D' OR 'M'), MAINTAIN HASH TOTAL
0444 C*    IF CPAM NEGATIVE, CHANGE SIGN AND ADD
0445 C   48              Z-SUB     CPAM          CPAM
0446 C*
0447 C   02
0448 COR 03              SETON                                        12
0449 C   12              MOVE      BLANKS        ZZAMT
0450 C   12              MOVE      CPAM          ZZAMT
0451 C   12              Z-ADD     LVTOTI        ZZTOTI
0452 C   12              Z-ADD     LVTOTD        ZZTOTD
0453 C   12              EXSR      GLZADD
0454 C   12              Z-ADD     ZZTOTI        LVTOTI           15 0
0455 C   12              Z-ADD     ZZTOTD        LVTOTD            3 0
0456 C                   SETOFF                                       12
0457 C*
0458 C*    IF NOT ACTIONED TODAY, NO FURTHER PROCESSING
0459 C*    RESTORE SIGN CPAM IF WAS NEGATIVE
     C  N22
0460 CAN 48              Z-SUB     CPAM          CPAM
0461 C*
0462 C  N22              GOTO      ENDA
0463 C*
0464 C*    FOR EACH INSERTED RECORD, MAINTAIN HASH TOTAL
0465 C*
0466 C   24              MOVE      BLANKS        ZZAMT
0467 C   24              MOVE      CPAM          ZZAMT
0468 C   24              Z-ADD     INTOTI        ZZTOTI
0469 C   24              Z-ADD     INTOTD        ZZTOTD
0470 C   24              EXSR      GLZADD
0471 C   24              Z-ADD     ZZTOTI        INTOTI           15 0
0472 C   24              Z-ADD     ZZTOTD        INTOTD            3 0
0473 C*
0474 C*    FOR EACH REVERSED RECORD, MAINTAIN HASH TOTAL
0475 C*
0476 C   26              MOVE      BLANKS        ZZAMT
0477 C   26              MOVE      CPAM          ZZAMT
0478 C   26              Z-ADD     DETOTI        ZZTOTI
0479 C   26              Z-ADD     DETOTD        ZZTOTD
0480 C   26              EXSR      GLZADD
0481 C   26              Z-ADD     ZZTOTI        DETOTI           15 0
0482 C   26              Z-ADD     ZZTOTD        DETOTD            3 0
0483 C*
0484 C*    RESTORE SIGN CPAM IF WAS NEGATIVE
0485 C   48              Z-SUB     CPAM          CPAM
0486 C*
0487 C*    DETERMINE PROCESSING TYPE
0488 C*    TYPES 64,65 = PART.PURCHASED (IND.31)
0489 C*    TYPES 66,67 = PART.SOLD      (IND.32)
0490 C*    61-63,70    = LOAN           (IND.33)
0491 C*
0492 C     PTYP          COMP      63                                   3333
0493 C  N33PTYP          COMP      65                                   3131
     C  N31
0494 CANN33PTYP          COMP      67                                   3232
     C  N31
0495 CANN32              SETON                                          33
      *
      ** Determine processing type for CLE005                             CLE005
      ** types 68,71 = Part. Purchased  (Ind. 31)                         CLE005
      ** types 69,72 = Part. Sold       (Ind. 32)                         CLE005
      *                                                                   CLE005
     C     CLE005        IFEQ      'Y'                                                         CLE00
     C     PTYP          IFEQ      68                                                          CLE00
     C     PTYP          OREQ      71                                                          CLE00
     C                   MOVE      '1'           *IN31                                         CLE00
     C                   MOVEA     '00'          *IN(32)                                       CLE00
     C                   ENDIF                                                                 CLE00
     C     PTYP          IFEQ      69                                                          CLE00
     C     PTYP          OREQ      72                                                          CLE00
     C                   MOVE      '1'           *IN32                                         CLE00
     C                   MOVE      '0'           *IN31                                         CLE00
     C                   MOVE      '0'           *IN33                                         CLE00
     C                   ENDIF                                                                 CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE005
     C/COPY WNCPYSRC,LE0310CCP6                                           S01408
      *                                                                   S01486
      ** Portfolio Reference                                              S01486
      *                                                                   S01486
     C     BGPFMG        IFEQ      'Y'                                                         S0148
     C     BGN4ST        OREQ      'Y'                                                         CPB00
     C     PTFR          IFEQ      '9997'                                                      S0148
     C     BGN4ST        ANDNE     'Y'                                                         CPB00
     C                   MOVEL     FCR997        OPTFR             4                           S0148
     C                   ELSE                                                                  S0148
     C                   MOVEL     PTFR          OPTFR                                         S0148
     C                   END                                                                   S0148
     C                   ELSE                                                                  S0148
     C                   MOVEL     *BLANKS       OPTFR                                         S0148
     C                   END                                                                   S0148
     C**                                                                  S01408
     C/COPY WNCPYSRC,LE0310CCP1                                           S01408
     C*                                                                   S01408
      *                                                                                       CER001
      ** Accessed to LECLX1L0 european reporting file                                         CER001
      *                                                                                       CER001
     C     ULX004        IFEQ      'Y'
     C     LNRF          CHAIN     LECLX1L0                           88
     C*                                                                                       CER001
     C     VKIMEX        IFEQ      0
     C                   MOVE      *BLANKS       XRIMEX            1
     C                   ELSE
     C                   MOVE      VKIMEX        XRIMEX
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CER073
      ** Get AnaCredit Details                                                                CER073
      *                                                                                       CER073
     C     CER073        IFEQ      'Y'
      *                                                                                       CER073
      ** AnaCredit Reporting indicator for printing                                           CER073
      *                                                                                       CER073
     C                   MOVEL     '1'           *IN96
     C                   CLEAR                   ANACDS
     C                   MOVE      *BLANKS       ADTPS
     C                   MOVE      *BLANKS       DTRS
     C                   MOVE      *BLANKS       DDSI
     C                   EXSR      LEANAC
     C                   ENDIF
0496 C*
0497 C*****CHAIN*TO*CUSTOMER*FILE*FOR*CUSTOMER*NAME                       S01194
     C*    CALL AOCUSTR0 FOR CUSTOMER NAME                                S01194
0498 C*
0499 C**********           MOVELCNUM      CLINKY  7                       S01194
0500 C**********           MOVE 'A'       CLINKY                          S01194
0501 C********** CLINKY    CHAINCLINT                40                   S01194
0502 C*
0499 C                   MOVEL     CNUM          CKEY                                          S0119
     C                   CALL      'AOCUSTR0'    PLIST1                                        S0119
     C     @RTCD         IFNE      *BLANKS                                                     S0119
     C                   SETON                                        U7U8LR                   S0119
     C                   MOVE      '02'          DBASE                          ***************S0119
     C                   MOVE      'SDCUSTPD'    DBFILE                         * DBERROR 02  *S0119
     C                   MOVEL     CKEY          DBKEY                          ***************S0119
     C                   GOTO      ENDA                                                        S0119
     C                   ELSE                                                                  S0119
0511 C                   MOVE      CRNM          CRNM1            20                           S0119
     C                   END                                                                   S0119
0503 C*    DATABASE ERROR IF LIVE RECORD NOT FOUND
0504 C*
0505 C**N40***** RECI      COMP 'D'                  4040                 S01194
0506 C***40*****           SETON                     U7U8LR               S01194
0507 C***40*****           MOVE '02'      DBASE                           S01194
0508 C***40*****           MOVE 'CLINT'   DBFILE                          S01194
0509 C***40*****           MOVELCLINKY    DBKEY                           S01194
0510 C***40*****           GOTO ENDA                                      S01194
0511 C**N40*****           MOVE CRNM      CRNM1  20                       S01194
0512 C*
0513 C*    IF PART.PURCHASED, CHAIN TO CLIENT FILE
0514 C*    FOR ORIGINAL BORROWER NAME.
0515 C*
0516 C***31*****           MOVELOLNO      CLINKY                          S01194
0517 C***31*****           MOVE 'A'       CLINKY                          S01194
0518 C***31***** CLINKY    CHAINCLINT                40                   S01194
     C*                                                                   S01194
     C     *IN31         IFEQ      '1'                                                         S0119
     C                   MOVEL     OLNO          CKEY                                          S0119
     C                   CALL      'AOCUSTR0'    PLIST1                                        S0119
0519 C*
0520 C*    DATABASE ERROR IF LIVE RECORD NOT FOUND
     C     @RTCD         IFNE      *BLANKS                                                     S0119
     C                   SETON                                        U7U8LR                   S0119
     C                   MOVE      '03'          DBASE                          ***************S0119
     C                   MOVE      'SDCUSTPD'    DBFILE                         * DBERROR 03  *S0119
     C                   MOVEL     CKEY          DBKEY                          ***************S0119
     C                   GOTO      ENDA                                                        S0119
     C                   ELSE                                                                  S0119
     C                   MOVE      CRNM          CRNM2            20                           S0119
     C                   END                                                                   S0119
     C*                                                                   S01194
     C                   END                                                                   S0119
0521 C*
0522 C***31N40** RECI      COMP 'D'                  4040                 S01194
0523 C***40*****           SETON                     U7U8LR               S01194
0524 C***40*****           MOVE '03'      DBASE                           S01194
0525 C***40*****           MOVE 'CLINT'   DBFILE                          S01194
0526 C***40*****           MOVELCLINKY    DBKEY                           S01194
0527 C***40*****           GOTO ENDA                                      S01194
0528 C***31N40**           MOVE CRNM      CRNM2  20                       S01194
     C/COPY WNCPYSRC,LE0310C004
0529 C*
0530 C*****CHAIN*TO*TABLE*FILE*FOR*CCY*DECIMAL*PLACES                     S01194
     C*    ACCESS AOCURRR0 FOR CCY DECIMAL PLACES                         S01194
     C*                                                                   S01194
     C                   MOVEL     CCY           CURKEY                                        S0119
     C                   CALL      'AOCURRR0'    PLIST2                                        S0119
     C     @RTCD         IFNE      *BLANKS                                                     S0119
     C                   SETON                                        U7U8LR                   S0119
     C                   MOVE      '04'          DBASE                          ***************S0119
     C                   MOVE      'SDCURRPD'    DBFILE                         * DBERROR 04  *S0119
     C                   MOVEL     CURKEY        DBKEY                          ***************S0119
     C                   GOTO      ENDA                                                        S0119
     C                   END                                                                   S0119
     C*
0532 C**********           MOVEL'20      'TABKEY 12                       S01194
0533 C**********           MOVELCCY       TKEY    4                       S01194
0534 C**********           MOVE '1'       TKEY                            S01194
0535 C**********           MOVE TKEY      TABKEY                          S01194
0536 C********** TABKEY    CHAINTABLE                39                   S01194
0537 C*
0538 C*    DATABASE ERROR IF LIVE RECORD NOT FOUND
0539 C*
0540 C**N39***** RECI      COMP 'D'                  3939                 S01194
0541 C***39*****           SETON                     U7U8LR               S01194
0542 C***39*****           MOVE '04'      DBASE                           S01194
0543 C***39*****           MOVE 'TABLE'   DBFILE                          S01194
0544 C***39*****           MOVELTABKEY    DBKEY                           S01194
0545 C***39*****           GOTO ENDA                                      S01194
0546 C*
0547 C*   DETERMINE NO. DECIMAL PLACES                       35=0
0548 C*                                                      36=1
0549 C     CDP           COMP      1                                    3536      37=2
     C  N35
0550 CANN36CDP           COMP      3                                    3738      38=3
0551 C*
     C*    ACCESS AOCURRR0 FOR NEW CCY DECIMAL PLACES                     148631
     C*                                                                   148631
     C                   Z-ADD     0             NEWCDP            1 0                         14863
     C     NCCY          IFNE      *BLANK                                                      14863
     C                   MOVEL     NCCY          CURKEY                                        14863
     C                   CALL      'AOCURRR0'    PLIST2                                        14863
     C     @RTCD         IFNE      *BLANKS                                                     14863
     C                   SETON                                        U7U8LR                   14863
     C                   MOVE      '14'          DBASE                          ***************14863
     C                   MOVE      'SDCURRPD'    DBFILE                         * DBERROR 14  *14863
     C                   MOVEL     CURKEY        DBKEY                          ***************14863
     C                   GOTO      ENDA                                                        14863
     C                   ELSE                                                                  14863
     C                   Z-ADD     CDP           NEWCDP                                        14863
     C                   END                                                                   14863
     C                   END                                                                   14863
     C*                                                                   148631
0552 C*    TEST BIT SETTINGS FOR 'SECURED', 'DOCUMENTS' & 'FEES'
0553 C*
0554 C                   TESTB     '0'           RELI                     45
0555 C                   TESTB     '1'           RELI                     46
0556 C                   TESTB     '2'           RELI                     47
     C*                                                                   S01465
     C** If the core feature for S01465 is switched on, validate          S01465
     C** the Customer Confirmation field if existing on file and output   S01465
     C** as shortname on the report                                       S01465
     C*                                                                   S01465
     C     *IN68         IFEQ      '1'                                                         S0146
     C*                                                                   S01465
     C********** COCU      IFNE *ZEROS                                                 S01465 CSD027
     C     COCU          IFNE      *BLANKS
     C     COCU          ANDNE     '000000'
     C                   MOVE      *BLANKS       CKEY                                          S0146
     C                   MOVEL     COCU          CKEY                                          S0146
     C                   CALL      'AOCUSTR0'    PLIST1                                        S0146
     C*                                                                   S01465
     C** Database error if record is not found                            S01465
     C*                                                                   S01465
     C     @RTCD         IFNE      *BLANKS                                                     S0146
     C                   SETON                                        U7U8LR                   S0146
     C                   Z-ADD     24            DBASE                          ************   S0146
     C                   MOVE      'SDCUSTPD'    DBFILE                         * DBERR 24 *   S0146
     C                   MOVEL     CKEY          DBKEY                          ************   S0146
     C                   GOTO      ENDA                                                        S0146
     C                   ELSE                                                                  S0146
     C                   MOVEL     BBCSSN        SCCNM            10                           S0146
     C                   END                                                                   S0146
     C*                                                                   S01465
     C** Output the customer confirmation field as blank when zero        S01465
     C** on file                                                          S01465
     C*                                                                   S01465
     C                   ELSE                                                                  S0146
     C                   MOVE      *BLANKS       SCCNM                                         S0146
     C                   END                                                                   S0146
     C                   END                                                                   S0146
     C*                                                                   S01465
     C** If Guarantees Issued is active, validate the Receiver of the     S01465
     C** Guarantee if existing on file and output the corresponding       S01465
     C** shortname and town on the report                                 S01465
     C*                                                                   S01465
     C     *IN67         IFEQ      '1'                                                         S0146
     C*                                                                   S01465
     C********** RECE      IFNE *ZEROS                                                 S01465 CSD027
     C     RECE          IFNE      *BLANKS
     C                   MOVE      *BLANKS       CKEY                                          S0146
     C                   MOVEL     RECE          CKEY                                          S0146
     C                   CALL      'AOCUSTR0'    PLIST1                                        S0146
     C*                                                                   S01465
     C** Database error if record is not found                            S01465
     C*                                                                   S01465
     C     @RTCD         IFNE      *BLANKS                                                     S0146
     C                   SETON                                        U7U8LR                   S0146
     C                   Z-ADD     25            DBASE                          ************   S0146
     C                   MOVE      'SDCUSTPD'    DBFILE                         * DBERR 25 *   S0146
     C                   MOVEL     CKEY          DBKEY                          ************   S0146
     C                   GOTO      ENDA                                                        S0146
     C                   ELSE                                                                  S0146
     C                   MOVE      BBCSSN        SCRNM            10                           S0146
     C                   MOVE      BBCRTN        SCRTN            10                           S0146
     C                   END                                                                   S0146
     C*                                                                   S01465
     C** Output the customer shortname and town of the Receiver of the    S01465
     C** guarantee as blanks when RECE is zero on file                    S01465
     C*                                                                   S01465
     C                   ELSE                                                                  S0146
     C                   MOVE      *BLANKS       SCRNM                                         S0146
     C                   MOVE      *BLANKS       SCRTN                                         S0146
     C                   END                                                                   S0146
     C                   END                                                                   S0146
      *                                                                   CLE011
     C     CLE011        IFEQ      'Y'                                                         CLE01
     C                   MOVE      *BLANKS       ZFIELD                                        CLE01
     C                   MOVE      RFRT          ZFIELD                                        CLE01
     C                   Z-ADD     7             ZADEC                                         CLE01
     C                   EXSR      ZEDIT                                                       CLE01
     C                   MOVE      ZFIELD        RRFRT1           12                           CLE01
     C                   ENDIF                                                                 CLE01
      *                                                                                       CLE028
      ** If Flat Rate Personal Loans (Rule of 78s) is installed,                              CLE028
      ** format the 4 new fields - Add on Interest, Add on Charges,                           CLE028
      ** Include Charges in Interest and Charge Amount.                                       CLE028
      *                                                                                       CLE028
     C     CLE028        IFEQ      'Y'
     C                   MOVE      ADIF          RADIF             1
     C                   MOVE      ADCF          RADCF             1
     C                   MOVE      ICIF          RICIF             1
     C                   MOVE      *BLANKS       RCHGA
      *                                                                                       CLE028
     C                   SELECT
     C     *IN35         WHENEQ    *ON
     C                   Z-ADD     0             ZDECS
     C     *IN36         WHENEQ    *ON
     C                   Z-ADD     1             ZDECS
     C     *IN37         WHENEQ    *ON
     C                   Z-ADD     2             ZDECS
     C     *IN38         WHENEQ    *ON
     C                   Z-ADD     3             ZDECS
     C                   ENDSL
      *                                                                                       CLE028
     C                   Z-ADD     CHGA          ZFLD15
     C                   EXSR      ZFRPED
     C                   MOVEL     ZOUT18        RCHGA            18
     C                   ENDIF
      *                                                                                       CLE143
      ** Output Original Contract Date & Effective Annual Interest                            CLE143
      ** Rate if CLE143 in on                                                                 CLE143
      *                                                                                       CLE143
     C                   MOVE      *OFF          *IN12
     C                   MOVE      *OFF          *IN48
     C     CLE143        IFEQ      'Y'
      *                                                                                       CLE143
     C                   MOVE      *ON           *IN12
     C                   MOVE      *BLANKS       ROCDT             7
     C**********           MOVE *BLANKS   REAIR  11                                  CLE143 AR823767
     C                   MOVE      *BLANKS       REAIR            16
      *                                                                                       CLE143
     C     OCDT          IFNE      *ZEROS
     C                   MOVE      OCDT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        ROCDT
     C                   ENDIF
      *                                                                                       CLE143
     C     CAS009        IFEQ      'Y'
     C                   MOVE      *ON           *IN48
     C                   CALL      'LE000070'
     C                   PARM                    LNRF
     C**********           PARM           WEAIR  16                                  CLE143 AR823767
     C                   PARM                    REAIR
     C     ' '           CHECK     REAIR:1       NBP              02 0    11
     C   11              SUBST(P)  REAIR:NBP     REAIR
     C********** 11        SUBSTWEAIR:5   REAIR                                      CLE143 AR823767
     C                   ELSE
     C     EAIR          IFNE      *ZEROS
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      EAIR          ZFIELD
     C**********           Z-ADD7         ZADEC                                      CLE143 AR823767
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        REAIR
     C     ' '           CHECK     REAIR:1       NBP              02 0    11
     C   11              SUBST(P)  REAIR:NBP     REAIR
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE143
     C                   ENDIF
0557 C*
     C*                                                                   S01408
     C/COPY WNCPYSRC,LE0310CCP7                                           S01408
     C*                                                                   S01408
0559 C     ENDA          ENDSR                                                  ** ENDA TAG **
0560 C*
0561 C*
0562 C********************************************************************
0563 C*
0564 C*    DETAIL '2' RECORD PROCESSING
0565 C*
0566 C     DETB          BEGSR                                                  *** DETB ***
0567 C*
0568 C*
0569 C                   SETOFF                                       27
0570 C*
0571 C*    EXECUTE PROCESSING COMMON TO 1 & 2 RECORDS
0572 C*
0573 C                   EXSR      DETAB
0574 C*
0575 C*    IF NOT ACTIONED TODAY, NO FURTHER PROCESSING
0576 C*
0577 C  N22              GOTO      ENDB
0578 C*
0579 C*    CHECK FOLLOWS CORRECT '1' RECORD
0580 C*
0581 C*
0582 C***********DSA1      COMP DSB1                     27               S01117
0582 C     RECIA         COMP      RECIB                                  27                   S0111
0583 C*
0584 C*    IF NOT SAME, DATABASE ERROR
0585 C*
0586 C  N27              SETON                                        U7U8LR
0587 C  N27              MOVE      '05'          DBASE
0588 C**N27******          MOVE 'CLOAN'   DBFILE                          S01117
0589 C**N27******          MOVELLNRF      DBKEY                           S01117
0588 C**N27******          MOVE 'CLOAN'   DBFILE           ***************S01117
0588 C  N27              MOVE      'CLOANL1'     DBFILE                         * DBERROR 05  *S0111
0589 C  N27              MOVEL     LNRF          DBKEY                          ***************S0111
0590 C  N27              GOTO      ENDB
     C*
0591 C*
0592 C*    CONVERT DAYNOS TO DATE FORMAT WHERE APPLICABLE
0593 C*
0594 C     NROD          COMP      0                                  49
0595 C   49              Z-ADD     NROD          ZDAYNO
0596 C   49              EXSR      ZDATE2
0597 C   49              MOVE      ZADATE        NRODO             7
0598 C*
0599 C     DDAT          COMP      0                                  50
0600 C   50              Z-ADD     DDAT          ZDAYNO
0601 C   50              EXSR      ZDATE2
0602 C   50              MOVE      ZADATE        DDATO             7
0603 C*
0604 C     VDAT          COMP      0                                  51
0605 C   51              Z-ADD     VDAT          ZDAYNO
0606 C   51              EXSR      ZDATE2
0607 C   51              MOVE      ZADATE        VDATO             7
0608 C*
0609 C     MDAT          COMP      0                                  52
0610 C   52              Z-ADD     MDAT          ZDAYNO
0611 C   52              EXSR      ZDATE2
0612 C   52              MOVE      ZADATE        MDATO             7
     C/COPY WNCPYSRC,LE0310C002
      *                                                                                       CER020
      ** Check if Feature CER020 is ON                                                        CER020
      *                                                                                       CER020
     C     CER020        IFEQ      'Y'
      *                                                                                       CER020
      ** Move file field to printer field                                                     CER020
      *                                                                                       CER020
     C     ISDT          IFNE      *ZEROS
      *                                                                                       CER020
     C                   MOVE      ISDT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        RISDT
      *                                                                                       CER020
     C                   ENDIF
      *                                                                                       CER020
     C     FMDT          IFNE      *ZEROS
      *                                                                                       CER020
     C                   MOVE      FMDT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        RFMDT
      *                                                                                       CER020
     C                   ENDIF
      *                                                                                       CER020
     C                   ENDIF
0613 C*
0614 C     NIDT          COMP      0                                  53
0615 C   53              Z-ADD     NIDT          ZDAYNO
0616 C   53              EXSR      ZDATE2
0617 C   53              MOVE      ZADATE        NIDTO             7
0618 C*
0619 C     RLDT          COMP      0                                  54
0620 C   54              Z-ADD     RLDT          ZDAYNO
0621 C   54              EXSR      ZDATE2
0622 C   54              MOVE      ZADATE        RLDTO             7
0623 C*
0624 C     NRPD          COMP      0                                  55
0625 C   55              Z-ADD     NRPD          ZDAYNO
0626 C   55              EXSR      ZDATE2
0627 C   55              MOVE      ZADATE        NRPDO             7
0623 C*                                                                   S01465
     C** Convert the Original Maturity date to alpha (7A) when not        S01465
     C** equal to zeros and if core feature for S01465 is switched on     S01465
     C*                                                                   S01465
     C     *IN68         IFEQ      '1'                                                         S0146
     C***********OMDT      COMP 0                    55            S01465 088897
     C***55******          Z-ADDOMDT      ZDAYNO                   S01465 088897
     C***55******          EXSR ZDATE2                             S01465 088897
     C***55******          MOVE ZADATE    SOMDT   7                S01465 088897
     C                   SETOFF                                       71                       08889
     C     OMDT          IFNE      0                                                           08889
     C                   SETON                                        71                       08889
     C                   Z-ADD     OMDT          ZDAYNO                                        08889
     C                   EXSR      ZDATE2                                                      08889
     C                   MOVE      ZADATE        SOMDT             7                           08889
     C                   END                                                                   08889
     C*                                                                   088897
     C                   SETOFF                                       79                       08842
     C     NMDT          IFNE      0                                                           08842
     C                   SETON                                        79                       08842
     C                   Z-ADD     NMDT          ZDAYNO                                        08842
     C                   EXSR      ZDATE2                                                      08842
     C                   MOVE      ZADATE        NMDTO             7                           08842
     C                   END                                                                   08842
     C                   END                                                                   S0146
     C*                                                                   S01518
     C                   SETOFF                                       81                       S0151
     C     NIPD          IFNE      0                                                           S0151
     C                   SETON                                        81                       S0151
     C                   Z-ADD     NIPD          ZDAYNO                                        S0151
     C                   EXSR      ZDATE2                                                      S0151
     C                   MOVE      ZADATE        NIPDO             7                           S0151
     C                   END                                                                   S0151
0628 C*
0629 C*    CHECK FIELDS TO BE BLANK ON REPORT IF ZERO ON FILE
0630 C*
0631 C     BRTT          COMP      0                                  56
0632 C     IFDY          COMP      0                                  57
0633 C     RLDY          COMP      0                                  58
0634 C     REPT          COMP      0                                  59
0635 C     RDYN          COMP      0                                  60
0636 C     FRBC          COMP      0                                  61
0637 C     BLDY          COMP      0                                  62
0638 C     BCXR          COMP      0                                  63
0639 C     FCXR          COMP      0                                  64
0640 C     NBRA          COMP      0                                  65
      *                                                                                       CLE036
      ** Set Indicators for Specific Base Rates                                               CLE036
      *                                                                                       CLE036
     C     CLE036        IFEQ      'Y'
      *                                                                                       CLE036
     C                   MOVE      *OFF          *IN01
     C                   MOVE      *OFF          *IN86
      *                                                                                       CLE036
     C     BASR          IFGT      *ZERO
     C                   MOVE      *ON           *IN01
     C                   ENDIF
      *                                                                                       CLE036
     C     NBSR          IFGT      *ZERO
     C                   MOVE      *ON           *IN86
     C                   ENDIF
      *                                                                                       CLE036
     C                   ENDIF
      *                                                                                       CLE036
     C**   CHECK BENIFICIARY BANK DETAILS
     C*
     C**   IGNORE IF FIRST LINE OF SPECIAL INSTRUCTIONS IS BLANK
     C   21              GOTO      BENEND
     C*
     C     SPEC5         COMP      '/BEN/'                            232328
     C   23              GOTO      BENEND
     C*
     C**   CHECK FOR CHIPS NUMBER
     C     SPEC8         COMP      '/CH'                                  23
     C   23              MOVE      SPEC14        WORK6             6
     C   23              MOVE      *BLANKS       SPI1
     C   23              MOVE      'CHIPS'       SPEC5
     C   23              MOVE      WORK6         SPEC12
     C   23              GOTO      BENEND
     C*
     C**   CHECK FOR FED. WIRE NUMBER
     C     SPEC8         COMP      '/FW'                                  23
     C   23              MOVE      SPEC17        WORK9             9
     C   23              MOVE      *BLANKS       SPI1
     C   23              MOVE      'FED.WIRE'    SPEC9
     C   23              MOVE      WORK9         SPEC18
     C   23              GOTO      BENEND
     C*
     C**   MUST NOW BE 'ACCOUNT'
     C                   MOVE      SPEC30        WORK25           25
     C                   MOVE      *BLANKS       SPI1
     C                   MOVE      'A/C'         SPEC3
     C                   MOVE      WORK25        SPEC29
     C*
     C     BENEND        TAG                                                    * BENEND TAG *
     C*
0641 C*
0642 C*    MAINTAIN COUNT NUMBER LOANS/PARTS PRINTED
0643 C*
0644 C     NLON          ADD       1             NLON              5 0
0645 C*
0646 C*    SET ON INDICATOR FOR OUTPUT TO PRINTER
0647 C*
     C***/COPY*WNCPYSRC,LEH01013***                                                           CFC006
     C/COPY WNCPYSRC,LEH01013                                                               MD020563
     C     SUPFLG        IFNE      'Y'
0648 C                   SETON                                        30
     C***/COPY*WNCPYSRC,LEH01014***                                                           CFC006
     C/COPY WNCPYSRC,LEH01014                                                               MD020563
     C                   ENDIF
     C                   SETON                                        78                       S0111
0648 C                   SETOFF                                       19                       S0111
     C     CLE004        IFEQ      'Y'                                                         CLE00
     C     *INU7         ANDNE     *ON                                                         CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
      ** If the loan is part of a Syndicate, switch off *IN30.            CLE004
      ** Output the details to LE0310P2 and switch off 'no                CLE004
      ** details to report' line for LE0310P1 for the branch              CLE004
      ** being processed.                                                 CLE004
      *                                                                   CLE004
     C     CLE004        IFEQ      'Y'                                                         CLE00
     C     *INU7         ANDNE     *ON                                                         CLE00
      *                                                                   CLE004
     C                   MOVE      ' '           WSYIN             1                           14082
     C********** LNRF      CHAINLELOAN8F             08                                140821 CSD027
     C                   MOVE      LNRF          LNRFA             6
     C     LNRFA         CHAIN     LELOAN8F                           08
      *                                                                   140821
      ** Check if the facility of the prime loan is syndicated            140821
      ** If it is, output the details to LE0310P2.                        140821
      *                                                                   140821
     C     LNKS          IFNE      'Y'                                                         14082
     C     *IN08         ANDEQ     '1'                                                         14082
     C                   MOVE      FCLB          WBRCA                                         14082
     C                   MOVE      FCUS          WCNUM                                         14082
     C                   MOVE      FTYP          WFACT                                         14082
     C                   MOVE      FSEQ          WFCNO                                         14082
     C                   MOVEL     FCLB          WKEY1             9                           14082
     C                   MOVE      FCUS          WKEY1                                         14082
     C                   MOVEL     WKEY1         FCLKEY           14                           14082
     C                   MOVEL     FTYP          WKEY2             5                           14082
     C                   MOVE      FSEQ          WKEY2                                         14082
     C                   MOVE      WKEY2         FCLKEY                                        14082
      *                                                                   140821
     C     KEY001        CHAIN     FCLTYL1                            09                       14082
      *                                                                   140821
     C     *IN09         IFEQ      '1'                                                         14082
     C     *LOCK         IN        LDA                                                         14082
     C                   MOVEL     FCLKEY        DBKEY                                         14082
     C                   MOVEL     'LE0310'      DBPGM                                         14082
     C                   MOVEL     'FCLTYL1'     DBFILE                         *************  14082
     C                   Z-ADD     048           DBASE                          * DBERR 048 *  14082
     C                   OUT       LDA                                          *************  14082
     C                   EXSR      *PSSR                                                       14082
     C                   ELSE                                                                  14082
     C                   MOVE      SYIN          WSYIN                                         14082
     C                   ENDIF                                                                 14082
     C                   ENDIF                                                                 14082
      *                                                                   140821
     C     LNKS          IFEQ      'Y'                                                         CLE00
     C     *IN08         OREQ      '0'                                                         14082
     C     WSYIN         OREQ      'Y'                                                         14082
     C                   EXSR      FILLP2                                                      CLE00
     C     OPEN2         IFEQ      '1'                                                         CLE00
     C     CLE006        ANDEQ     'Y'                                                         18766
     C                   EXSR      WRITP2                                                      CLE00
     C                   ENDIF                                                                 CLE00
     C                   MOVE      *OFF          *IN84                                         CLE00
     C                   MOVE      *OFF          *IN30                                         CLE00
     C                   MOVE      *ON           *IN19                                         CLE00
     C                   ELSE                                                                  CLE00
     C                   EXSR      ADDLP2                                                      CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
     C                   ENDIF                                                                 CLE00
      *                                                                   CEU020
     C     CLE004        IFEQ      'N'                                                         CEU02
      *                                                                   CEU020
     C     CEU020        IFEQ      'Y'                                                         CEU02
     C     ECIN          ANDEQ     'Y'                                                         CEU02
     C                   EXSR      EMUMCY                                                      CEU02
     C                   ELSE                                                                  CEU02
     C                   MOVE      '0'           *IN88                                         CEU02
     C                   ENDIF                                                                 CEU02
      *                                                                   CEU020
     C                   ENDIF                                                                 CEU02
      *                                                                   S01518
      ** If discounted loan (processing type is 63), display              S01518
      ** extended settlement of loan in the report.                       S01518
     C     *IN80         IFEQ      '1'                                                         S0151
     C     PTYP          IFEQ      63                                                          S0151
     C                   MOVE      '1'           *IN82                                         S0151
     C                   ELSE                                                                  S0151
     C                   MOVE      '0'           *IN82                                         S0151
     C                   ENDIF                                                                 S0151
     C                   ENDIF                                                                 S0151
0649 C*
     C*                                                                   S01408
     C** Core hook for externalisation.                                   S01408
     C/COPY WNCPYSRC,LE0310PDR                                            S01408
     C*                                                                   S01408
0650 C*
0651 C     ENDB          ENDSR                                                  ** ENDB TAG **
0652 C*
0653 C********************************************************************
0654 C*
0655 C*    PROCESSING FOR '1' AND '2' RECORDS
0656 C*
0657 C     DETAB         BEGSR                                                  *** DETAB ***
0658 C*
0659 C*
0660 C*    FOR EACH LIVE DETAIL RECORD (ID = D OR M), MAINTAIN COUNT
0661 C   02
0662 COR 03
0663 COR 05
0664 COR 06NROF          ADD       1             NROF              5 0
0665 C*
0666 C*    RECORDS D OR R - CHECK IF ACTIONED TODAY
0667 C*    IF NOT, NO FURTHER PROCESSING
0668 C*
0669 C   02
0670 COR 04
0671 COR 05
     COR 07LCDA          COMP      RUND                                   22
0673 C  N22              GOTO      ENDAB
0675 C*
0676 C*    DETERMINE CHANGE TYPE
0677 C*
     C     CHTPA         COMP      'I'                                    24
     C  N24CHTPA         COMP      'A'                                    25
     C  N24
     CANN25CHTPA         COMP      'R'                                    26
0681 C*
0682 C*    FOR EACH RECORD AMENDED OR REVERSED TODAY
0683 C*    CHECK IF ALSO INSERTED TODAY
0684 C*
0685 C   25
0686 COR 26ORED          COMP      RUND                                   24
0687 C*
0688 C*    MAINTAIN COUNT NUMBER RECORDS INSERTED
0689 C*
0690 C   24NRINS         ADD       1             NRINS             5 0
0691 C*
0692 C*    MAINTAIN COUNT NUMBER RECORDS REVERSED
0693 C*
0694 C   26NRDEL         ADD       1             NRDEL             5 0
0695 C*
0696 C*
     C*
     C/COPY WNCPYSRC,LE0310CCP4
     C*
0697 C     ENDAB         ENDSR                                                  ** ENDAB TAG **
0698 C*
0699 C*
     C/EJECT                                                              S01270
     C*****************************************************************   S01270
0701 C* SUBROUTINE TO ADD AN AMOUNT (ZZAMT) TO THE TOTAL (ZZTOTI,ZZTOTD)
0702 C*   IND '99' IS SET BY AN OVERFLOW ERROR
0703 C*
0704 CSR   GLZADD        BEGSR                                                  *** GLZADD ****
0705 C*
0706 CSR                 Z-ADD     ZZAMT         ZZAMT            15 3    91    -DEFINE ZZAMT
0707 CSR 91              GOTO      ZZAEND                                       AMT = 0.BYPASS
0708 C*
0709 C* SPLIT ZZAMT INTO INTEGER AND DECIMAL FIELDS
0710 CSR                 Z-ADD     ZZAMT         ZZAMTI           15 0          INTEGER FIELD
0711 CSR                 MOVE      ZZAMT         ZZAMTD            3 0          DECIMAL FIELD
0712 C* BOTH ZZAMTI AND ZZAMTD CONTAIN A 'SIGN' ZONE NOW
0713 C*
0714 CSR                 EXSR      GLZSUM
0715 CSR   ZZAEND        ENDSR                                                  ** ZZAEND TAG *
0716 C*
0717 C********************************************************************
0718 C* SUBROUTINE TO CARRY OUT THE ADDITION FOR SUBROUTINES -
0719 C*                        GLZADD, GLZSUB, GLZCMP.
0720 C*          PARAMETERS PASSED -
0721 C*                     I/P ZZAMTI ZZAMTD
0722 C*                     O/P ZZTOTI ZZTOTD ZZNEGD IND 96 IND 99.
0723 C*
0724 CSR   GLZSUM        BEGSR                                                  *** GLZSUM ****
0725 C*
0726 CSR                 Z-ADD     ZZTOTI        ZZTOTI           15 0          DEFINE ZZTOTI
0727 CSR                 Z-ADD     ZZTOTD        ZZTOTD            3 0          DEFINE ZZTOTD
0728 CSR                 SETOFF                                       919293
0729 CSR                 SETOFF                                       949599
0730 C*
0731 C*    DETERMINE SIGN OF ZZAMTI & D,   92 IF NEG
0732 CSR   ZZAMTI        COMP      0                                    9293
0733 CSR 93ZZAMTD        COMP      0                                    9293
0734 CSR 93              GOTO      ZZSEND                                       ZERO BYPASS
0735 C*
0736 C*    DETERMINE SIGN OF ZZTOTI & D, 91 IF NEG.
0737 CSR   ZZTOTI        COMP      0                                    9193
0738 CSR 93ZZTOTD        COMP      0                                    9193
0739 C*
0740 C*    IF ZZTOTAL IS ZERO, RETURN ZZAMOUNT.
0741 CSR 93              Z-ADD     ZZAMTI        ZZTOTI
0742 CSR 93              Z-ADD     ZZAMTD        ZZTOTD
0743 CSR 93              GOTO      ZZSEND                                       ZERO BYPASS
0744 C*    IF SIGNS DIFFER BYPASS OVERFLOW CHECKS.
     CSR 91
0745 CANN92
     CORN91
0746 CAN 92              GOTO      ZZOFPS
0747 C*
0748 CSR   ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
0749 CSR   ZZWK2         COMP      999                                93        '93' = CARRY
0750 CSRN93ZZWK2         COMP      -999                                 93        INTO INTEGER.
0751 C*
     CSR 93
0752 CANN92ZZAMTI        ADD       1             ZZWK3            15 0          ADD 'CARRY' +VE
     CSR 93
0753 CAN 92ZZAMTI        SUB       1             ZZWK3                          SUB 'CARRY' -VE
0754 CSR 93ZZTOTI        ADD       ZZWK3         ZZWK3
0755 CSRN93ZZTOTI        ADD       ZZAMTI        ZZWK3
0756 C*
0757 C* IF THE MODULUS OF ZZWK3 IS LT MOD. ZZTOTI THEN O/F HAS OCCURED
0758 CSRN92ZZWK3         COMP      ZZTOTI                               99      -92 MEANS NOS.
0759 CSR 92ZZWK3         COMP      ZZTOTI                             99         NEGATIVE
0760 CSRN99              Z-ADD     ZZWK2         ZZTOTD
0761 CSRN99              Z-ADD     ZZWK3         ZZTOTI
0762 C*
0763 C* IF O/F ZEROIZE ZZAMT , IND '99' SET AND ZZTOT FIELDS LEFT INTACT.
0764 CSR 99              Z-ADD     0             ZZAMT            15 3
0765 CSR                 GOTO      ZZSEND
0766 C*
0767 C* THE 'SIGNS' ARE DIFFERENT
0768 CSR   ZZOFPS        TAG                                                    ** ZZOFPS TAG**
0769 C* IF ZZAMT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZTOT
0770 C*
0771 CSR 92              Z-SUB     ZZAMTI        ZZAMTI           15 0
0772 CSR 92              Z-SUB     ZZAMTD        ZZAMTD            3 0
0773 C*
0774 C* IF ZZTOT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZAMT.
0775 C*
0776 CSR 91              Z-SUB     ZZTOTI        ZZTOTI
0777 CSR 91              Z-SUB     ZZTOTD        ZZTOTD
0778 C* BOTH ZZAMT AND ZZTOT ARE NOW POSITIVE.
0779 C*
0780 CSR   ZZTOTI        COMP      ZZAMTI                             93  95
0781 CSR 95ZZTOTD        COMP      ZZAMTD                             93  95
0782 C*
0783 C* IF ZZTOT EQ. ZZAMT RETURN ZERO.
0784 CSR 95              Z-ADD     0             ZZTOTI
0785 CSR 95              Z-ADD     0             ZZTOTD
0786 CSR 95              GOTO      ZZSEND
0787 C*
0788 C* IF ZZTOT GT. ZZAMT.
0789 CSR 93ZZAMTD        COMP      ZZTOTD                             94
     CSR 93
0790 CAN 94ZZTOTI        SUB       1             ZZTOTI
     CSR 93
0791 CAN 94ZZTOTD        ADD       1000          ZZWK2
0792 CSR 93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     CSR 93
0793 CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     CSR 93
0794 CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
0795 C*
0796 C*
0797 C* IF ZZAMT GT. ZZTOT.
0798 CSRN93ZZTOTD        COMP      ZZAMTD                             94
     CSRN93
0799 CAN 94ZZAMTI        SUB       1             ZZWK3            15 0
     CSRN93
0800 CAN 94ZZAMTD        ADD       1000          ZZWK2
     CSRN93
0801 CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     CSRN93
0802 CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
     CSRN93
0803 CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     CSRN93
0804 CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
0805 C*
0806 C* REVERSE SIGN OF ZZTOT IF LARGER I/P FIELDS WERE NEGATIVE
0807 CSR                 SETOFF                                       94
     CSR 93
0808 CAN 91
     CORN93
0809 CAN 92              SETON                                        94
0810 CSR 94              Z-SUB     ZZTOTI        ZZTOTI
0811 CSR 94              Z-SUB     ZZTOTD        ZZTOTD
0812 C**
0813 C**   RESTORE SIGN OF ZZAMTI & ZZAMTD IF IT WAS REVERSED.
0814 CSR 92              Z-SUB     ZZAMTI        ZZAMTI
0815 CSR 92              Z-SUB     ZZAMTD        ZZAMTD
0816 CSR   ZZSEND        TAG                                                    ** ZZSEND TAG *
0817 C**
0818 C**   IF ZZTOTD IS ZERO, AND ZZTOTI IS NEG. SET UP ZZNEGD.
0819 CSR                 SETOFF                                       96
0820 CSR   ZZTOTD        COMP      0                                      91
0821 CSR 91ZZTOTI        COMP      0                                    96
0822 CSR 96              MOVE      '.000-'       ZZNEGD            5
0823 CSR                 ENDSR                                                    ** ENDSR **
0824 C*
0073 C*/COPY*ZSRSRC,ZDATE2Z4*********                                                 S01392 CER073D
0073 C/COPY ZSRSRC,ZDATE2Z4LE                                                                CER073D
     C/COPY WNCPYSRC,LE0310C001
0915 C********************************************************************
0916 C*
0917 C*    TRAILER PROCESSING
0918 C*
0919 C     TRLR          BEGSR                                                  *** TRLR ***
0920 C*
1026 C*                                                                   S01117
1027 C* CHAIN TO LOANS FILE TRAILER                                       S01117
1028 C                   MOVE      '999999Z'     CLONKY            7                           S0111
     C                   MOVE      *IN74         WIN74A            1
1029 C     CLONKY        CHAIN     CLONT                              74                       S0111
     C                   MOVE      *IN74         WIN74B            1
     C                   MOVE      WIN74A        *IN74
1030 C*                                                                   S01117
1031 C* DATABASE ERROR IF NOT FOUND                                       S01117
1032 C**N13*****                                                                       S01117 CER001
1033 C*R*74*****           SETON                     U7U8                              S01117 CER001
     C     *IN13         IFEQ      '0'                                                         S0111
     C     WIN74B        OREQ      '1'
     C                   SETON                                        U7U8                     S0111
     C                   ENDIF
1034 C   U7              MOVE      '06'          DBASE                                         S0111
1035 C   U7              MOVE      'CLONT'       DBFILE                                        S0111
1036 C   U7              MOVEL     CLONKY        DBKEY                                         S0111
1037 C   U7              GOTO      TRLEND                                                      S0111
1038 C*                                                                   S01117
0921 C*****IF*NO*LOANS/PARTS*TO*PRINT,*OUTPUT*MESSAGE******************   S01117
0922 C*
0923 C     NLON          COMP      0                                      34
0924 C***34******          SETON                     73OF                 S01117
0925 C***73******          EXCPT                                          S01117
0926 C***********          SETOF                     73                   S01117
0927 C*
0928 C*    COMPARE RECORD COUNTS AND HASH TOTALS
0929 C*    TO FILE CONTROLS.  IF NOT EQUAL, SETON U8
0930 C*    AND SKIP FURTHER VALIDATIONS
0931 C*
0932 C*    NUMBER/VALUE OF INSERTS:-
0933 C     NRINS         COMP      NINS                                   41
0934 C   41INTOTI        COMP      VRIF                                   41
0935 C   41INTOTD        COMP      VRIL                                   41
0936 C*
0937 C*    NUMBER/VALUE OF DELETIONS:-
0938 C     NRDEL         COMP      NDEL                                   42
0939 C   42DETOTI        COMP      VRDF                                   42
0940 C   42DETOTD        COMP      VRDL                                   42
0941 C*
0942 C*    NUMBER/VALUE LIVE RECORDS AFTER INPUT:-
     C*                                                                   S01117
     C* NO CLOAN HEADER OR TRAILER READ, SO ADD 2 TO COUNT SO THAT        S01117
     C* COMPARE IS STILL OK                                               S01117
     C*********************ADD  2         NROF                     S01117 LN0143
     C*                                                                   S01117
0943 C     NROF          COMP      NLRA                                   43
0944 C   43LVTOTI        COMP      VLAF                                   43
0945 C   43LVTOTD        COMP      VLAL                                   43
0946 C*
0947 C**N41*****                                                                              236008
0948 C*ORN42****                                                                              236008
0949 C*ORN43****           SETON                     U8                                       236008
0950 C***U8*****           GOTO TRLEND                                                        236008
     C     *IN41         IFEQ      '0'
     C     *IN42         OREQ      '0'
     C     *IN43         OREQ      '0'
     C                   SETON                                        90
     C                   ENDIF
0951 C*
0952 C*
0953 C*    VERIFY NUMBER RECORDS ON FILE CONTROLS
0954 C*
0955 C     NLRB          ADD       NINS          FCONT             5 0
0956 C     FCONT         SUB       NDEL          FCONT
0957 C     FCONT         COMP      NLRA                                   44
0958 C**N44*****           SETON                     U8                                       236008
0959 C***U8*****           GOTO TRLEND                                                        236008
     C     *IN44         IFEQ      '0'
     C                   SETON                                        90
     C                   ENDIF
0960 C*
0961 C*    VERIFY HASH TOTALS ON FILE CONTROLS
0962 C*
0963 C*    VALUE LIVE RECORDS BEFORE INPUT:
0964 C                   Z-ADD     VLBF          ZZAMTI
0965 C                   MOVE      VLBL          ZZAMTD
0966 C                   Z-ADD     0             ZZTOTI
0967 C                   Z-ADD     0             ZZTOTD
0968 C                   EXSR      GLZSUM
0969 C*
0970 C*    ADD VALUE INSERTIONS:
0971 C                   Z-ADD     VRIF          ZZAMTI
0972 C                   MOVE      VRIL          ZZAMTD
0973 C                   EXSR      GLZSUM
0974 C*
0975 C*    CHANGE SIGN OF VALUE DELETIONS, AND ADD
0976 C                   Z-SUB     VRDF          VRDF
0977 C                   Z-SUB     VRDL          VRDL
0978 C                   Z-ADD     VRDF          ZZAMTI
0979 C                   MOVE      VRDL          ZZAMTD
0980 C                   EXSR      GLZSUM
0981 C*
0982 C*    RESTORE SIGN OF VALUE DELETIONS
0983 C                   Z-SUB     VRDF          VRDF
0984 C                   Z-SUB     VRDL          VRDL
0985 C*
0986 C*    COMPARE ABOVE HASH TOTALS WITH FILE CONTROLS
0987 C*
0988 C     ZZTOTI        COMP      VLAF                                   44
0989 C   44ZZTOTD        COMP      VLAL                                   44
0990 C*
0991 C*    IF TOTALS NOT AGREE, SET U8
0992 C*
0993 C**N44*****           SETON                     U8                                       236008
     C     *IN44         IFEQ      '0'
     C                   SETON                                        90
     C                   ENDIF
0994 C*
0995 C     TRLEND        TAG                                                    ** TRLEND TAG**
0996 C*
0997 C                   ENDSR
0998 C*
0999 C*
1000 C********************************************************************
1001 C**
1002 C**   ZSYSTM SR. TO CHAIN TO THE INSTALLATION CONTROL DATA RECORD.
1003 C**
1004 C     ZSYSTM        BEGSR                                                  *** ZSYSTM ***
1005 C**
1006 C**   SET UP KEY FOR INSTALLATION CONTROL RECORD.
1007 C**********           MOVEL'01      'ZTABKY 12                       S01194
1008 C**********           MOVE '  10'    ZTABKY                          S01194
1009 C**
1010 C********** ZTABKY    CHAINTABLE                99    ON NOT THERE   S01194
     C**   ACCESS BANK DETAILS                                            S01194
     C**                                                                  S01194
     C                   CALL      'AOBANKR0'    PLISTA                                        S0119
     C     @RTCD         COMP      *BLANKS                            9999                     S0119
     C*                                                                   S01194
     C**N99***** RECI      COMP 'D'                  9999  ON, IS DELETED S01194
1012 C**
1013 C**   CHECK SYSTEM DATE FORMAT, DDMMYY OR MMDDYY.
1014 C***********DATF      COMP 'M'                      98MMDDYY, 98 ON  S01194
1014 C     BJDFIN        COMP      'M'                                    98    MMDDYY, 98 ON  S0119
1015 C**
     C*                                                                   S01408
     C** Core hook for externalisation.                                   S01408
     C/COPY WNCPYSRC,LE0310CCPG                                           S01408
     C*                                                                   S01408
1016 C                   ENDSR
1017 C**
1018 C**
1019 C********************************************************************
1020 C*
1021 C*    IF CONTROLS BALANCE, UPDATE TRAILER RECORD
1022 C*
1023 C     UPDATE        BEGSR                                                  *** UPDATE ***
1024 C*
1025 C*
1026 C*
1027 C**CHAIN*TO*LOANS*FILE*TRAILER************************************   S01117
1028 C***********          MOVE '999999Z' CLONKY  7                       S01117
1029 C***********CLONKY    CHAINCLONT                74                   S01117
1030 C*
1031 C**DATABASE*ERROR*IF*NOT*FOUND************************************   S01117
1032 C**N13******                                                         S01117
1033 C*R*74******          SETON                     U7U8                 S01117
1034 C***U7******          MOVE '06'      DBASE                           S01117
1035 C***U7******          MOVE 'CLONT'   DBFILE                          S01117
1036 C***U7******          MOVELCLONKY    DBKEY                           S01117
1037 C***U7******          GOTO ENDU                                      S01117
1038 C*
1039 C*
1040 C                   Z-ADD     0             NINS
1041 C                   Z-ADD     0             NDEL
1042 C                   Z-ADD     0             VRIF
1043 C                   Z-ADD     0             VRIL
1044 C                   Z-ADD     0             VRDF
1045 C                   Z-ADD     0             VRDL
1046 C                   MOVE      NLRA          NLRB
1047 C                   MOVE      VLAF          VLBF
1048 C                   MOVE      VLAL          VLBL
1049 C*
1050 C*
1051 C***********ENDU      TAG                             ** ENDU TAG ** S01117
1052 C                   ENDSR
1053 C*
1054 C*
1055 C********************************************************************
     C*                                                                   S01117
     C* SUBROUTINE : #ZZ                                                  S01117
     C*                                                                   S01117
     C* CALLED BY MAIN PROCESSING DURING TOTAL TIME CALCULATIONS IF       S01117
     C* THE P1 FILES HAVE NOT ALREADY BEEN OPENED (IE, IF THERE ARE       S01117
     C* NO RECORDS READ AND THEREFORE FILES OPENING NOT PERFORMED)        S01117
     C*                                                                   S01117
     C     #ZZ           BEGSR                                                                 S0111
      **                                                                  S01117
      * SET UP INDICATORS AND FIELDS FOR P1 OUTPUT                        S01117
      **                                                                  S01117
     C                   IN        RUNDT                                                       S0111
      **                                                                  S01117
      **   ACCESS BANK DETAILS, FOR TITLE                                 S01117
     C                   CALL      'AOBANKR0'                                                  S0111
     C                   PARM      '*MSG   '     @RTCD             7                           S0111
     C                   PARM      '*FIRST '     @OPTN             7                           S0111
     C     SDBANK        PARM      SDBANK        DSFDY                                         S0111
     C*                                                                   S01117
     C     @RTCD         IFNE      *BLANK                                                      S0111
     C                   SETON                                        U7U8                     S0111
     C                   MOVEL     'SDBANKPD'    DBFILE                         ***************S0111
     C                   MOVEL     @OPTN         DBKEY                          * DBERROR 006 *S0111
     C                   Z-ADD     6             DBASE                          ***************S0111
     C                   EXSR      *PSSR                                                       S0111
     C                   GOTO      #ZZ9                                                        S0111
     C                   END                                                                   S0111
      **                                                                  S01117
      **   CHECK THE MULTIBRANCHING INDICATOR                             S01117
     C     MBIN          IFEQ      'Y'                                                         S0111
     C                   SETON                                        75                       S0111
     C                   ELSE                                                                  S0111
     C                   SETOFF                                       75                       S0111
     C                   END                                                                   S0111
      *                                                                   S01117
      ** OPEN P1 SPOOL FILE                                               S01117
     C                   OPEN      LE0310P1                                                    S0111
      ** OUTPUT NO DETAILS TO P1                                          S01117
     C                   SETON                                        19                       S0111
      *                                                                   S01117
      ** ENSURE REPORT SPOOL FILE RECORDED BY RCF                         S01117
     C                   Z-ADD     SFNUM         ZSNUM             6 0                         S0111
     C                   OUT       LDA                                                         S0111
     C                   CALL      'ZSFILE'                                                    S0111
     C                   PARM                    SEQ                                           S0111
     C                   PARM      *BLANKS       SENTY             3                           S0111
     C                   PARM                    SFILE                                         S0111
     C                   PARM                    ZSNUM                                         S0111
     C                   PARM                    ZSERR             1                           S0111
      *                                                                   S01117
     C     *LOCK         IN        LDA                                                         S0111
     C     ZSERR         IFEQ      'Y'                                                         S0111
      **  ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAM       S01117
     C                   SETON                                        U7U8LR                   S0111
     C                   RETURN                                                                S0111
     C                   END                                                                   S0111
      *                                                                   S01117
     C     #ZZ9          ENDSR                                                                 S0111
      *                                                                   S01117
     C********************************************************************S01117
     C*                                                                   S01117
     C* *PSSR  --- SUBROUTINE TO HANDLE ABNORMAL ERROR CONDITIONS         S01117
     C*                                                                   S01117
     C* CALLED FROM: AFTER ABNORMAL OPERATION OCCURS                      S01117
     C*                                                                   S01117
     C* CALLS: NOTHING                                                    S01117
     C*                                                                   S01117
     C********************************************************************S01117
     C*                                                                   S01117
     C     *PSSR         BEGSR                                                  ** *PSSR **    S0111
     C*                                                                   S01117
     C     @RUN          IFEQ      *BLANKS                                                     S0111
     C                   MOVE      'Y'           @RUN              1                           S0111
     C                   DUMP                                                                  S0111
     C                   END                                                                   S0111
     C*                                                                   S01117
     C                   ENDSR                                                  ** *PSSR **    S0111
      /EJECT                                                              CLE004
      *****************************************************************   CLE004
      *  FILLP2 - subroutine to fill up the report details in LE0310P2*   CLE004
      *                                                               *   CLE004
      *  Called by: DETB                                              *   CLE004
      *  Calls: ADDLP2                                                *   CLE004
      *                                                               *   CLE004
      *****************************************************************   CLE004
      *                                                                   CLE004
     C     FILLP2        BEGSR                                                  *** FILLP2 *** CLE00
      *                                                                   CLE004
     C                   SELECT                                                                CLE00
     C     *IN35         WHENEQ    *ON                                                         CLE00
     C                   Z-ADD     0             ZDECS                                         CLE00
     C     *IN36         WHENEQ    *ON                                                         CLE00
     C                   Z-ADD     1             ZDECS                                         CLE00
     C     *IN37         WHENEQ    *ON                                                         CLE00
     C                   Z-ADD     2             ZDECS                                         CLE00
     C     *IN38         WHENEQ    *ON                                                         CLE00
     C                   Z-ADD     3             ZDECS                                         CLE00
     C                   ENDSL                                                                 CLE00
      *                                                                   CLE004
      ** Format amount                                                    CLE004
      *                                                                   CLE004
     C                   Z-ADD     CPAM          ZFLD15                                        CLE00
     C                   EXSR      ZFRPED                                                      CLE00
     C     ZNEG          IFEQ      '-'                                                         CLE00
     C                   MOVEL     ZOUT18        RCPA0                                         CLE00
     C                   ELSE                                                                  CLE00
     C                   MOVEL     ZOUT17        RCPA0                                         CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
      ** Format Discount/Int.                                             CLE004
      *                                                                   CLE004
     C                   Z-ADD     TOTI          ZFLD15                                        CLE00
     C                   EXSR      ZFRPED                                                      CLE00
     C     ZNEG          IFEQ      '-'                                                         CLE00
     C                   MOVEL     ZOUT18        RTOT0                                         CLE00
     C                   ELSE                                                                  CLE00
     C                   MOVEL     ZOUT17        RTOT0                                         CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
      ** Format New Principal.                                            CLE004
      *                                                                   CLE004
     C                   Z-ADD     NPRAM         ZFLD15                                        CLE00
     C                   EXSR      ZFRPED                                                      CLE00
     C     ZNEG          IFEQ      '-'                                                         CLE00
     C                   MOVEL     ZOUT18        RNPR0                                         CLE00
     C                   ELSE                                                                  CLE00
     C                   MOVEL     ZOUT17        RNPR0                                         CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
      ** Format New Discount.                                             CLE004
      *                                                                   CLE004
     C                   Z-ADD     NDAM          ZFLD15                                        CLE00
     C                   EXSR      ZFRPED                                                      CLE00
     C     ZNEG          IFEQ      '-'                                                         CLE00
     C                   MOVEL     ZOUT18        RNDA0                                         CLE00
     C                   ELSE                                                                  CLE00
     C                   MOVEL     ZOUT17        RNDA0                                         CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
      ** Format Repay Amount.                                             CLE004
      *                                                                   CLE004
     C                   Z-ADD     FCRA          ZFLD15                                        CLE00
     C                   EXSR      ZFRPED                                                      CLE00
     C     ZNEG          IFEQ      '-'                                                         CLE00
     C                   MOVEL     ZOUT18        RFCR0                                         CLE00
     C                   ELSE                                                                  CLE00
     C                   MOVEL     ZOUT17        RFCR0                                         CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
      ** Format Margin                                                    CLE004
      *                                                                   CLE004
     C                   Z-ADD     5             ZADEC                                         CLE00
     C                   MOVEL     *BLANKS       ZFIELD                                        CLE00
     C                   MOVE      MARG          ZFIELD                                        CLE00
     C                   EXSR      ZEDIT                                                       CLE00
     C                   MOVE      ZFIELD        RMARG                                         CLE00
      *                                                                   CLE004
      ** Format Base Currency Rate                                        CLE004
      *                                                                   CLE004
     C                   Z-ADD     8             ZADEC                                         CLE00
     C                   MOVEL     *BLANKS       ZFIELD                                        CLE00
     C                   MOVE      BCXR          ZFIELD                                        CLE00
     C                   EXSR      ZEDIT                                                       CLE00
     C                   MOVE      ZFIELD        RBCXR                                         CLE00
      *                                                                   147994
      ** Base Currency Mult/div ind.                                      147994
      *                                                                   147994
     C                   MOVE      BMDI          RBMDI                                         14799
      *                                                                   CLE004
      ** Format Facility Currency Rate                                    CLE004
      *                                                                   CLE004
     C                   Z-ADD     8             ZADEC                                         CLE00
     C                   MOVEL     *BLANKS       ZFIELD                                        CLE00
     C                   MOVE      FCXR          ZFIELD                                        CLE00
     C                   EXSR      ZEDIT                                                       CLE00
     C                   MOVE      ZFIELD        RFCXR                                         CLE00
      *                                                                   147994
      ** Facility Currency Mult/div ind.                                  147994
      *                                                                   147994
     C                   MOVE      FMDI          RFMDI                                         14799
      *                                                                   CLE004
      ** Format W/Holding Tax Rate                                        CLE004
      *                                                                   CLE004
     C                   Z-ADD     7             ZADEC                                         CLE00
     C                   MOVEL     *BLANKS       ZFIELD                                        CLE00
     C                   MOVE      WTRT          ZFIELD                                        CLE00
     C                   EXSR      ZEDIT                                                       CLE00
     C                   MOVE      ZFIELD        RWTRT                                         CLE00
      *                                                                   CLE004
      ** Format Funding Spread Rate                                       CLE004
      *                                                                   CLE004
     C                   Z-ADD     7             ZADEC                                         CLE00
     C                   MOVEL     *BLANKS       ZFIELD                                        CLE00
     C                   MOVE      FSRP          ZFIELD                                        CLE00
     C                   EXSR      ZEDIT                                                       CLE00
     C                   MOVE      ZFIELD        RFSRP                                         CLE00
      *                                                                   CLE004
      ** Format Rollover Base Rate                                        CLE004
      *                                                                   CLE004
     C                   Z-ADD     7             ZADEC                                         CLE00
     C                   MOVEL     *BLANKS       ZFIELD                                        CLE00
     C                   MOVE      NBRA          ZFIELD                                        CLE00
     C                   EXSR      ZEDIT                                                       CLE00
     C                   MOVE      ZFIELD        RNBRA                                         CLE00
      *                                                                   CLE004
      ** Format Rollover Spread Rate                                      CLE004
      *                                                                   CLE004
     C                   Z-ADD     7             ZADEC                                         CLE00
     C                   MOVEL     *BLANKS       ZFIELD                                        CLE00
     C                   MOVE      NRTS          ZFIELD                                        CLE00
     C                   EXSR      ZEDIT                                                       CLE00
     C                   MOVE      ZFIELD        RNRTS                                         CLE00
      *                                                                   CLE011
      ** Print rollover fix day, rollover rate fixed indicator and        CLE011
      ** format rollover rate                                             CLE011
      *                                                                   CLE011
     C     CLE011        IFEQ      'Y'                                                         CLE01
     C                   MOVE      RFDY          RRFDY                                         CLE01
     C                   MOVE      RFRI          RRFRI                                         CLE01
     C                   MOVE      *BLANKS       ZFIELD                                        CLE01
     C                   MOVE      RFRT          ZFIELD                                        CLE01
     C                   Z-ADD     7             ZADEC                                         CLE01
     C                   EXSR      ZEDIT                                                       CLE01
     C                   MOVE      ZFIELD        RRFRT                                         CLE01
     C                   ENDIF                                                                 CLE01
      *                                                                   CLE004
      ** Format Spread/Rate                                               CLE004
      *                                                                   CLE004
     C                   Z-ADD     7             ZADEC                                         CLE00
     C                   MOVEL     *BLANKS       ZFIELD                                        CLE00
      *                                                                                     AR847588
      ** Display spread rate as negative in the report if rate is                           AR847588
      ** negative.                                                                          AR847588
      *                                                                                     AR847588
     C     RTSP          IFLT      0
     C                   MOVE      'Y'           WSUB              1
     C                   Z-SUB     RTSP          RTSP
     C                   ENDIF
      *                                                                                     AR847588
     C                   MOVE      RTSP          ZFIELD                                        CLE00
     C                   EXSR      ZEDIT                                                       CLE00
      *                                                                                     AR847588
     C     WSUB          IFEQ      'Y'
     C                   MOVE      *BLANKS       WSUB
     C                   MOVE      ZFIELD        WFLD1            19
     C     WFLD1         CAT       '-'           WFLD2            20
     C                   MOVE      WFLD2         RRTSP
     C                   Z-SUB     RTSP          RTSP
     C                   ELSE
     C                   MOVE      ZFIELD        RRTSP                                         CLE00
     C                   ENDIF
      *                                                                   CLE004
      ** Format New Funding Spread/Rate                                   CLE004
      *                                                                   CLE004
     C                   Z-ADD     7             ZADEC                                         CLE00
     C                   MOVEL     *BLANKS       ZFIELD                                        CLE00
     C                   MOVE      NFRS          ZFIELD                                        CLE00
     C                   EXSR      ZEDIT                                                       CLE00
     C                   MOVE      ZFIELD        RNFRS                                         CLE00
      *                                                                                       CLE036
      ** Format Base Rate                                                                     CLE036
      *                                                                                       CLE036
     C     CLE036        IFEQ      'Y'
      *                                                                                       CLE036
     C     *IN01         IFEQ      *ON
     C                   Z-ADD     7             ZADEC
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      BASR          ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        RBASR
     C                   ENDIF
      *                                                                                       CLE036
      ** Format Rollover Base Rate                                                            CLE036
      *                                                                                       CLE036
     C     *IN86         IFEQ      *ON
     C                   Z-ADD     7             ZADEC
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      NBSR          ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        RNBSR
     C                   ENDIF
      *                                                                                       CLE036
     C                   ENDIF
      *                                                                   CLE004
     C                   MOVE      NRODO         RNROD                                         CLE00
     C                   MOVE      SCRNM         RSCRN                                         CLE00
     C                   MOVE      SCRTN         RSCRT                                         CLE00
     C                   MOVE      SDST          RSDST                                         CLE00
     C                   MOVE      OSDA          ROSDA                                         CLE00
     C                   MOVE      OSDB          ROSDB                                         CLE00
     C                   MOVE      TSTN          RTSTN                                         CLE00
     C                   MOVE      MDST          RMDST                                         CLE00
     C                   MOVE      OMDA          ROMDA                                         CLE00
     C                   MOVE      OMDB          ROMDB                                         CLE00
     C                   MOVE      TMAN          RTMAN                                         CLE00
     C                   MOVE      FACO          RFACO                                         CLE00
     C                   MOVEL     SPI1          RSPI1                                         CLE00
     C                   MOVEL     SPI2          RSPI2                                         CLE00
     C                   MOVEL     SPI3          RSPI3                                         CLE00
     C                   MOVE      NAR3          RNAR3                                         CLE00
     C                   MOVE      NAR4          RNAR4                                         CLE00
      *                                                                   CLE004
     C                   MOVE      CRNM2         RCRN2                                         CLE00
     C                   MOVE      OLNO          ROLNO                                         CLE00
     C                   MOVE      RCSI          RRCSI                                         CLE00
     C                   MOVE      ORBR          RORB1                                         CLE00
     C                   MOVE      ORBR          RORB2                                         CLE00
     C                   MOVE      ORBR          RORB3                                         CLE00
     C                   MOVE      FCLB          RFCLB                                         CLE00
     C                   MOVE      SCRTN         RSCRT                                         CLE00
      *                                                                   CLE004
      *                                                                   CLE004
     C**********           MOVE CRNM      RCRN1                                      CLE004 BUG13338
     C                   MOVE      CRNM1         RCRN1
     C**********           Z-ADDCNUM      RCNUM                                        CLE004 CSD027
     C                   MOVE      CNUM          RCNUM
     C                   MOVE      DDATO         RDDAT                                         CLE00
     C                   Z-ADD     ICBS          RICBS                                         CLE00
     C                   MOVE      SPIN          RSPIN                                         CLE00
     C                   MOVE      NIDTO         RNIDT                                         CLE00
     C                   MOVE      INTC          RINTC                                         CLE00
     C                   MOVE      RLDTO         RRLDT                                         CLE00
     C                   Z-ADD     REPT          RREPT                                         CLE00
     C                   MOVE      NRPDO         RNRPD                                         CLE00
     C                   Z-ADD     FRBC          RFRBC                                         CLE00
     C                   MOVE      NACD          RNACD                                         CLE00
     C                   MOVE      ACOF          RACOF                                         CLE00
     C                   MOVE      FPRC          RFPRC                                         CLE00
      *                                                                   CLE004
     C**********           Z-ADDLNRF      RLNRF                                        CLE004 CLE148
     C                   MOVEL     LNRF          RLNRF
     C**********           Z-ADDFCUS      RFCUS                                        CLE004 CSD027
     C                   MOVE      FCUS          RFCUS
     C                   Z-ADD     FTYP          RFTYP                                         CLE00
     C                   Z-ADD     FSEQ          RFSEQ                                         CLE00
     C                   MOVE      CCY           RLCCY                                         CLE00
     C                   MOVE      VDATO         RVDAT                                         CLE00
     C                   Z-ADD     BRTT          RBRTT                                         CLE00
     C                   MOVE      CHIN          RCHIN                                         CLE00
     C                   MOVE      IPFR          RIPFR                                         CLE00
     C                   MOVE      ADDI          RADDI                                         CLE00
     C                   MOVE      RLFQ          RRLFQ                                         CLE00
     C                   MOVE      RFRQ          RRFRQ                                         CLE00
     C**********           Z-ADDLIND      RLIND                                        CLE004 CER020
     C                   MOVE      LOIC          RLIND
     C                   MOVE      BTIN          RBTIN                                         CLE00
     C                   MOVE      PRFC          RPRFC                                         CLE00
     C                   MOVE      SCCNM         RSCCN                                         CLE00
     C                   MOVE      FSGN          RFSGN                                         CLE00
     C                   MOVE      NSIN          RNSIN                                         CLE00
      *                                                                   CLE004
     C                   MOVE      LTYP          RLTYP                                         CLE00
     C                   MOVE      SUTP          RSUTP                                         CLE00
     C                   MOVE      CLAS          RCLAS
     C                   MOVE      LASQ          RLASQ                                         CLE00
     C                   MOVE      CHTPA         RCHTP                                         CLE00
     C                   MOVE      BOKC          RBOKC                                         CLE00
     C                   MOVE      MDATO         RMDAT                                         CLE00
     C                   MOVE      SOMDT         RSOMD                                         CLE00
     C                   Z-ADD     IFDY          RIFDY                                         CLE00
     C                   MOVE      OPTFR         ROPTF                                         CLE00
     C                   Z-ADD     RLDY          RRLDY                                         CLE00
     C                   MOVE      WTIN          RWTIN                                         CLE00
     C                   MOVE      AUTO          RAUTO                                         CLE00
     C                   Z-ADD     RDYN          RRDYN                                         CLE00
     C                   MOVE      CRSK          RCRSK                                         CLE00
     C                   MOVE      BLDY          RBLDY                                         CLE00
     C                   MOVE      APMI          RAPMI                                         CLE00
     C                   MOVE      FCLB          RFCLB                                         CLE00
     C                   MOVE      NAR1          RNAR1                                         CLE00
     C                   MOVE      NAR2          RNAR2                                         CLE00
      *                                                                   CLE004
     C                   Z-ADD     NCAC          RNCAC                                         CLE00
     C                   MOVE      NIPDO         RNIPD                                         CLE00
     C                   MOVE      NCHI          RNCHI                                         CLE00
      *                                                                   CLE004
     C                   MOVE      NMDTO         RNMDT                                         CLE00
     C                   MOVE      NFSN          RNFSN                                         CLE00
      *                                                                   140822
     C                   MOVE      PTFC          RPTFC                                         14082
     C                   MOVE      PTFT          RPTFT                                         14082
     C                   MOVE      PTFN          RPTFN                                         14082
      *                                                                   CLE004
      ** Receipt settlement instructions                                  CLE004
      *                                                                   CLE004
     C                   Z-ADD     RSTM          RRSTM                                         CLE00
     C                   MOVE      RONS          RRONS                                         CLE00
     C***********          Z-ADDROCN      RROCN                                        CLE004 CSD027
     C***********          Z-ADDROBN      RROBN                                        CLE004 CSD027
     C                   MOVE      ROCN          RROCN
     C                   MOVE      ROBN          RROBN
     C                   MOVE      RIBN          RRIBN                                         CLE00
     C                   MOVE      RIBA          RRIBA                                         CLE00
      *                                                                   CLE004
      ** Payment settlement instructions                                  CLE004
      *                                                                   CLE004
     C                   Z-ADD     PSTM          RPSTM                                         CLE00
     C                   MOVE      PONS          RPONS                                         CLE00
     C                   MOVE      CVMR          RCVMR                                         CLE00
     C                   MOVE      RVNO          RRVNO                                         CLE00
     C***********          Z-ADDPOCN      RPOCN                                        CLE004 CSD027
     C***********          Z-ADDPOBN      RPOBN                                        CLE004 CSD027
     C                   MOVE      POCN          RPOCN
     C                   MOVE      POBN          RPOBN
     C                   MOVEL     RCRN          RRCRN                                         CLE00
     C                   MOVEL     RCRA          RRCRA                                         CLE00
     C                   MOVEL     PIBN          RPIBN                                         CLE00
     C                   MOVEL     PIBA          RPIBA                                         CLE00
     C                   MOVEL     AWBN          RAWBN                                         CLE00
     C                   MOVEL     AWBA          RAWBA                                         CLE00
     C                   MOVEL     BENN          RBENN                                         CLE00
     C                   MOVEL     BENA          RBENA                                         CLE00
     C                   MOVEL     DTP1          RDTP1                                         CLE00
     C                   MOVEL     DTP2          RDTP2                                         CLE00
     C                   MOVEL     DTP3          RDTP3                                         CLE00
     C                   MOVEL     DTP4          RDTP4                                         CLE00
     C                   MOVEL     DCHG          RDCHG                                         CLE00
     C                   MOVEL     BTB1          RBTB1                                         CLE00
     C                   MOVEL     BTB2          RBTB2                                         CLE00
     C                   MOVEL     BTB3          RBTB3                                         CLE00
     C                   MOVEL     BTB4          RBTB4                                         CLE00
     C                   MOVEL     BTB5          RBTB5                                         CLE00
     C                   MOVEL     BTB6          RBTB6                                         CLE00
      *                                                                   CLE004
      ** Fill up user action details                                      147935
     C     *IN39         IFEQ      '1'
     C                   MOVE      IUSR          RIUSR                                         14793
     C                   MOVE      AUSR          RAUSR                                         14793
     C                   MOVE      XUSR          RXUSR                                         14793
     C                   MOVE      RAUS          RRAUS
     C                   MOVE      RXUS          RRXUS
     C                   ENDIF
      *                                                                                       CLE036
      ** Populate Repositioned fields for CLE036                                              CLE036
      *                                                                                       CLE036
     C     CLE036        IFEQ      'Y'
     C                   MOVE      RBRTT         RBRTT2
     C                   MOVE      RNBRA         RNBRA2
     C                   ENDIF
      *                                                                   147935
      ** Fill up Additional Details                                       CLE004
      *                                                                   CLE004
     C                   EXSR      ADDLP2                                                      CLE00
     C                   ENDSR                                                                 CLE00
      /EJECT                                                              CLE004
      *****************************************************************   CLE004
      *  ADDLP2 - subroutine to fill up additional details in LE0310P1*   CLE004
      *                                                               *   CLE004
      *  Called by: FILLP2, DETB                                      *   CLE004
      *  Calls: None                                                  *   CLE004
      *                                                               *   CLE004
      *****************************************************************   CLE004
      *                                                                   CLE004
     C     ADDLP2        BEGSR                                                  *** ADDLP2 *** CLE00
      *                                                                   CLE004
     C                   SELECT                                                                CLE00
     C     *IN35         WHENEQ    *ON                                                         CLE00
     C                   Z-ADD     0             ZDECS                                         CLE00
     C     *IN36         WHENEQ    *ON                                                         CLE00
     C                   Z-ADD     1             ZDECS                                         CLE00
     C     *IN37         WHENEQ    *ON                                                         CLE00
     C                   Z-ADD     2             ZDECS                                         CLE00
     C     *IN38         WHENEQ    *ON                                                         CLE00
     C                   Z-ADD     3             ZDECS                                         CLE00
     C                   ENDSL                                                                 CLE00
      *                                                                   CLE004
      ** Format Repay Amount                                              CLE004
      *                                                                   CLE004
     C                   Z-ADD     RAMT          ZFLD15                                        CLE00
     C                   EXSR      ZFRPED                                                      CLE00
     C     ZNEG          IFEQ      '-'                                                         CLE00
     C                   MOVEL     ZOUT18        RRAM0                                         CLE00
     C                   ELSE                                                                  CLE00
     C                   MOVEL     ZOUT17        RRAM0                                         CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
      ** Format New Currency Principal                                    CLE004
      *                                                                   CLE004
     C                   Z-ADD     NCPA          ZFLD15                                        CLE00
     C                   Z-ADD     NEWCDP        ZDECS                                         14863
     C                   EXSR      ZFRPED                                                      CLE00
     C     ZNEG          IFEQ      '-'                                                         CLE00
     C                   MOVEL     ZOUT18        RNCP0                                         CLE00
     C                   ELSE                                                                  CLE00
     C                   MOVEL     ZOUT17        RNCP0                                         CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
      ** Format New Loan Currency Repay                                   CLE004
      *                                                                   CLE004
     C                   Z-ADD     NNLR          ZFLD15                                        CLE00
     C                   Z-ADD     NEWCDP        ZDECS                                         14863
     C                   EXSR      ZFRPED                                                      CLE00
     C     ZNEG          IFEQ      '-'                                                         CLE00
     C                   MOVEL     ZOUT18        RNLR0                                         CLE00
     C                   ELSE                                                                  CLE00
     C                   MOVEL     ZOUT17        RNLR0                                         CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
     C                   MOVE      FCCY          RFCCY                                         CLE00
     C                   MOVE      PDDI          RPDDI                                         CLE00
     C                   MOVE      PTDI          RPTDI                                         CLE00
     C                   MOVE      GDPR          RGDPR                                         CLE00
     C                   MOVE      GDIN          RGDIN                                         CLE00
     C                   MOVE      GPRT          RGPRT                                         CLE00
     C                   MOVE      TOLN          RTOLN                                         CLE00
      *                                                                   154567
     C     *IN39         IFEQ      '1'
     C                   MOVE      IUSR          RIUSR                                         15456
     C                   MOVE      AUSR          RAUSR                                         15456
     C                   MOVE      XUSR          RXUSR                                         15456
     C                   ENDIF
     C                   MOVE      RAUS          RRAUS
     C                   MOVE      RXUS          RRXUS
      *                                                                   CLE006
      ** Output currency rollover details if CLE006 is *ON.               CLE006
      *                                                                   CLE006
     C     CLE006        IFEQ      'N'                                                         CLE00
     C     CLE007        ANDEQ     'N'                                                         CLE01
     C                   MOVE      *OFF          *IN85                                         CLE00
     C                   ELSE                                                                  CLE00
     C                   MOVE      *ON           *IN85                                         CLE00
     C                   MOVE      MCRA          RMCRA                                         CLE00
     C                   MOVE      NCCY          RNCCY                                         CLE00
     C                   MOVE      NFMD          RNFMD                                         CLE00
      *                                                                   CLE006
      ** Format Facility Currency Exchange Rate                           CLE006
      *                                                                   CLE006
     C**********           Z-ADD5         ZADEC                                        CLE006 193859
     C                   Z-ADD     8             ZADEC
     C                   MOVEL     *BLANKS       ZFIELD                                        CLE00
     C                   MOVE      NFCE          ZFIELD                                        CLE00
     C                   EXSR      ZEDIT                                                       CLE00
     C                   MOVE      ZFIELD        RNFCE                                         CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE006
      ** Output currency rollover details if CEU020 is *ON.               CEU020
      *                                                                   CEU020
     C     CEU020        IFEQ      'Y'                                                         CEU02
     C     ECIN          ANDEQ     'Y'                                                         CEU02
     C                   MOVE      '1'           *IN88                                         CEU02
     C                   MOVE      MCRA          RMCRA                                         CEU02
     C                   MOVE      NCCY          RNCCY                                         CEU02
     C                   MOVE      NFMD          RNFMD                                         CEU02
      *                                                                   CEU020
      ** Format Facility Currency Exchange Rate                           CEU020
      *                                                                   CEU020
     C                   Z-ADD     8             ZADEC                                         CEU02
     C                   MOVEL     *BLANKS       ZFIELD                                        CEU02
     C                   MOVE      NFCE          ZFIELD                                        CEU02
     C                   EXSR      ZEDIT                                                       CEU02
     C                   MOVE      ZFIELD        RNFCE                                         CEU02
     C                   ELSE                                                                  CEU02
     C                   MOVE      '0'           *IN88                                         CEU02
     C                   ENDIF                                                                 CEU02
      *                                                                                       237732
     C     KEY002        KLIST
     C                   KFLD                    WCNUM
     C**********           KFLD           WLNRF   60                                   237732 CLE148
     C                   KFLD                    WLNRF             6
     C                   KFLD                    WAMTP             2
      *                                                                                       237732
     C     GPRT          IFEQ      'Y'
     C     *IN24         ANDEQ     '1'
     C                   MOVEL     CNUM          WCNUM
     C                   MOVEL     LNRF          WLNRF
     C                   MOVEL     'PT'          WAMTP
      *                                                                                       237732
     C     KEY002        CHAIN     LELOAML7                           09
      *                                                                                       237732
     C     *IN09         IFEQ      '1'
      *                                                                                       247519
      ** Do not execute the database error if loan was generated by                           247519
      ** Loan IQ.                                                                             247519
      *                                                                                       247519
     C     CLE043        IFEQ      'Y'
     C********** TOLN      ANDEQ0                                                      247519 CLE148
     C     TOLN          ANDEQ     *BLANKS
     C     FRNT          ANDNE     *BLANKS
     C                   ELSE
      *                                                                                       247519
     C     *LOCK         IN        LDA
     C                   MOVEL     WLNRF         DBKEY
     C                   MOVEL     'LE0310  '    DBPGM
     C                   MOVEL     'LELOAML7'    DBFILE                         *************
     C                   Z-ADD     045           DBASE                          * DBERR 045 *
     C                   SETON                                        U7U8LR    *************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *                                                                                       237732
     C                   ENDIF
      *                                                                                       237732
      *                                                                                       CLE031
      ** Output Settlement Currency Exchange Rates entered against                            CLE031
      ** loans or their rollover instructions if Lending Enhancements                         CLE031
      ** (CLE031) is installed.                                                               CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'
      *                                                                                       CLE031
      ** Move Receipt/Payment Settlement Currency                                             CLE031
      *                                                                                       CLE031
     C                   MOVE      SCCY          RSCCY
     C                   MOVE      PSCY          RPSCY
      *                                                                                       CLE031
      ** Move Receipt/Payment Settlement Currency Indicator                                   CLE031
      *                                                                                       CLE031
     C                   MOVE      REXI          RREXI
     C                   MOVE      PEXI          RPEXI
      *                                                                                       CLE031
      ** Format Receipt Settlement Exchange Rate                                              CLE031
      *                                                                                       CLE031
     C                   Z-ADD     8             ZADEC
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      REXR          ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        RREXR
      *                                                                                       CLE031
      ** Format Payment Settlement Exchange Rate                                              CLE031
      *                                                                                       CLE031
     C                   Z-ADD     8             ZADEC
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      PEXR          ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        RPEXR
     C                   ENDIF
      *                                                                                       CLE034
      ** Initialise neccesary variables.                                                      CLE034
      *                                                                                       CLE034
     C                   MOVE      *OFF          *IN17
     C                   MOVEL     *BLANKS       RSTAL
     C                   MOVEL     *BLANKS       KLNRF
     C                   MOVEL     *BLANKS       WEBRCA
     C                   MOVEL     *BLANKS       WEBRNM
     C                   MOVEL     *BLANKS       WECHTP
     C                   MOVEL     *BLANKS       WEBOKC
     C                   MOVEL     *BLANKS       WECNM1
     C                   MOVEL     *BLANKS       WEFCUS
     C                   MOVEL     *BLANKS       WEFTYP
     C                   MOVEL     *BLANKS       WEFSEQ
     C                   MOVEL     *BLANKS       WELTYP
     C                   MOVEL     *BLANKS       WESUTP
     C                   MOVEL     *BLANKS       WECLAS
     C                   MOVEL     *BLANKS       WELASQ
     C                   MOVEL     *BLANKS       WECNUM
     C                   MOVEL     *BLANKS       WECCY
     C                   MOVEL     *BLANKS       WECPAM
     C                   MOVEL     *BLANKS       WECNM2
     C                   MOVEL     *BLANKS       WEOLNO
     C                   MOVEL     *BLANKS       WERCSI
      *                                                                                       CLE034
      ** If CLE034 is installed.                                                              CLE034
      *                                                                                       CLE034
     C     CLE034        IFEQ      'Y'
     C                   MOVEL     STAL          RSTAL
     C                   MOVE      LNRF          KLNRF
     C                   MOVEL     BRCA          WEBRCA
     C                   MOVEL     BRNM          WEBRNM
     C                   MOVEL     CHTPA         WECHTP
     C                   MOVEL     BOKC          WEBOKC
     C                   MOVEL     CRNM1         WECNM1
     C                   MOVEL     FCUS          WEFCUS
     C                   MOVEL     FTYP          WEFTYP
     C                   MOVE      FSEQ          WEFSEQ
     C                   MOVEL     LTYP          WELTYP
     C                   MOVEL     SUTP          WESUTP
     C                   MOVEL     CLAS          WECLAS
     C                   MOVE      LASQ          WELASQ
     C                   MOVE      CNUM          WECNUM
     C                   MOVEL     CCY           WECCY
     C                   MOVE      CPAM          WECPAM
     C                   MOVEL     CRNM2         WECNM2
     C                   MOVE      OLNO          WEOLNO
     C                   MOVE      RCSI          WERCSI
      *                                                                                       CLE034
      ** If settlement allocation is to be printed, set on indicator 17.                      CLE034
      *                                                                                       CLE034
     C     STAL          IFEQ      'Y'
     C                   MOVE      *ON           *IN17
     C                   ENDIF
     C                   ENDIF
      *                                                                   CEU020
     C                   ENDSR                                                                 CLE00
      /EJECT                                                              CLE004
      *****************************************************************   CEU020
      *  EMUMCY - subroutine to fill up additional details in LE0310P1*   CEU020
      *           if CEU020 is installed                              *   CEU020
      *  Called by:                                                   *   CEU020
      *  Calls: None                                                  *   CEU020
      *                                                               *   CEU020
      *****************************************************************   CEU020
     C     EMUMCY        BEGSR                                                                 CEU02
      *                                                                   CEU020
      ** Output currency rollover details if CEU020 is *ON.               CEU020
      *                                                                   CEU020
     C                   MOVE      '1'           *IN88                                         CEU02
     C                   MOVE      'Y'           RMCRA                                         CEU02
     C                   MOVE      NCCY          RNCCY                                         CEU02
     C                   MOVE      NFMD          RNFMD                                         CEU02
      *                                                                   CEU020
      ** Format New Currency Principal                                    CEU020
      *                                                                   CEU020
     C                   Z-ADD     NCPA          ZFLD15                                        CEU02
     C*****                Z-ADDCDP       ZDECS                     CEU020148631
     C                   Z-ADD     NEWCDP        ZDECS                                         14863
     C                   EXSR      ZFRPED                                                      CEU02
     C     ZNEG          IFEQ      '-'                                                         CEU02
     C                   MOVEL     ZOUT18        RNCP0                                         CEU02
     C                   ELSE                                                                  CEU02
     C                   MOVEL     ZOUT17        RNCP0                                         CEU02
     C                   ENDIF                                                                 CEU02
      *                                                                   CEU020
      ** Format Facility Currency Exchange Rate                           CEU020
      *                                                                   CEU020
     C                   Z-ADD     8             ZADEC                                         CEU02
     C                   MOVEL     *BLANKS       ZFIELD                                        CEU02
     C                   MOVE      NFCE          ZFIELD                                        CEU02
     C                   EXSR      ZEDIT                                                       CEU02
     C                   MOVE      ZFIELD        RNFCE                                         CEU02
      *                                                                   CEU020
      ** Format New Loan Currency Repay                                   CEU020
      *                                                                   CEU020
     C                   Z-ADD     NNLR          ZFLD15                                        CEU02
     C*****                Z-ADDCDP       ZDECS                     CEU020148631
     C                   Z-ADD     NEWCDP        ZDECS                                         14863
     C                   EXSR      ZFRPED                                                      CEU02
     C     ZNEG          IFEQ      '-'                                                         CEU02
     C                   MOVEL     ZOUT18        RNLR0                                         CEU02
     C                   ELSE                                                                  CEU02
     C                   MOVEL     ZOUT17        RNLR0                                         CEU02
     C                   ENDIF                                                                 CEU02
      *                                                                   CEU020
     C                   ENDSR                                                                 CEU02
      /EJECT                                                              CEU020
      *****************************************************************   CLE004
      *  WRITP2 - subroutine to write to LE0310P2                     *   CLE004
      *                                                               *   CLE004
      *  Called by: DETB                                              *   CLE004
      *  Calls: None                                                  *   CLE004
      *                                                               *   CLE004
      *****************************************************************   CLE004
      *                                                                   CLE004
     C     WRITP2        BEGSR                                                  *** FILLP2 *** CLE00
      *                                                                   CLE004
     C                   WRITE     HEADP2                                                      CLE00
     C                   WRITE     SUBHD1                                                      CLE00
     C                   WRITE     DETAL1                                                      CLE00
      *                                                                   CLE004
     C     *IN80         IFEQ      *OFF                                                        CLE00
     C                   WRITE     DETAL4                                                      CLE00
     C                   ELSE                                                                  CLE00
     C                   WRITE     DETAL3                                                      CLE00
      *                                                                                       CLE034
      ** If CLE034 is installed and settlement allocations is 'Y', print                      CLE034
      ** settlement allocation details.                                                       CLE034
      *                                                                                       CLE034
     C     CLE034        IFEQ      'Y'
     C     RSTAL         ANDEQ     'Y'
     C                   EXSR      SRPRSD
     C                   ELSE
      *                                                                                       CLE034
     C                   WRITE     HEADP2                                                      CLE00
     C                   WRITE     SUBHD1                                                      CLE00
     C                   WRITE     DETAL2                                                      CLE00
     C                   ENDIF
      *                                                                                       CLE034
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
     C                   ENDSR                                                  *** WRITP2 *** CLE00
      /EJECT                                                                                  CLE034
      *****************************************************************                       CLE034
      *                                                               *                       CLE034
      *  SRPRSD - subroutine to print settlement allocation details   *                       CLE034
      *                                                               *                       CLE034
      *  Called by:                                                   *                       CLE034
      *  Calls: None                                                  *                       CLE034
      *                                                               *                       CLE034
      *****************************************************************                       CLE034
      *                                                                                       CLE034
     C     SRPRSD        BEGSR
      *                                                                                       CLE034
     C                   MOVEL     'Y'           W1ST
     C     KSTAL5        SETLL     LESTALL5
     C     KSTAL5        READE     LESTALL5                               18
      *                                                                                       CLE038
      ** Determine if Receipt/Pay Settlement Allocation                                       CLE038
      ** by Amount will be used instead of percentage.                                        CLE038
      *                                                                                       CLE038
     C     CLE038        IFEQ      'Y'
     C                   MOVE      *OFF          *IN89
     C                   MOVE      *OFF          *IN40
      *                                                                                       CLE038
     C     LRCBA         IFEQ      'A'
     C                   MOVE      *ON           *IN89
     C                   ENDIF
      *                                                                                       CLE038
     C     LPYBA         IFEQ      'A'
     C                   MOVE      *ON           *IN40
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE034
     C     *IN18         DOWEQ     *OFF
      *                                                                                       CLE034
      ** Write header and print settlement allocation to next page.                           CLE034
      *                                                                                       CLE034
     C     W1ST          IFEQ      'Y'
     C     *IN83         OREQ      *ON
     C                   WRITE     HEADP2
     C                   WRITE     SUBHD1
     C                   WRITE     DETAL5
      *                                                                                       CLE034
     C                   MOVEL     'N'           W1ST
     C                   MOVE      *OFF          *IN83
     C                   ENDIF
      *                                                                                       CLE034
      ** Format settlement allocation details.                                                CLE034
      *                                                                                       CLE034
     C                   EXSR      SRFMT
      *                                                                                       CLE034
      ** Write settlement allocation details.                                                 CLE034
      *                                                                                       CLE034
     C                   WRITE     DETAL6
      *                                                                                       CLE034
     C     KSTAL5        READE     LESTALL5                               18
     C                   ENDDO
      *                                                                                       CLE034
     C                   ENDSR
      *                                                                                       CLE034
      /EJECT                                                              CLE004
      *****************************************************************   CLE004
      *  CSARC4 - subroutine to check if SAR CLE004 is switched *ON.  *   CLE004
      *                                                               *   CLE004
      *  Called by:                                                   *   CLE004
      *  Calls: None                                                  *   CLE004
      *                                                               *   CLE004
      *****************************************************************   CLE004
      *                                                                   CLE004
     C     CSARC4        BEGSR                                                  *** CSARC2 *** CLE00
      *                                                                   CLE004
      ** Check if SAR is switched ON                                      CLE004
      *                                                                   CLE004
     C                   MOVE      'N'           CLE004            1                           CLE00
     C                   CALL      'AOSARDR0'                                                  CLE00
     C                   PARM      *BLANKS       @RTCD                                         CLE00
     C                   PARM      '*VERIFY'     @OPTN                                         CLE00
     C                   PARM      'CLE004'      @SARD             6                           CLE00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CLE00
      *                                                                   CLE004
     C     @RTCD         IFEQ      *BLANKS                                                     CLE00
     C                   MOVE      'Y'           CLE004                                        CLE00
     C                   MOVE      *ON           *IN84                                         CLE00
     C                   MOVE      *ON           *IN87                                         CLE00
     C                   END                                                                   CLE00
      *                                                                   CLE011
      ** Check if Rollover Rate Fixing Day Enhancement switched on        CLE011
      *                                                                   CLE011
     C                   CALL      'AOSARDR0'                                                  CLE01
     C                   PARM      *BLANKS       PRTCD             7                           CLE01
     C                   PARM      '*VERIFY'     POPTN             7                           CLE01
     C                   PARM      'CLE011'      PSARD             6                           CLE01
      *                                                                   CLE011
     C     PRTCD         IFEQ      *BLANKS                                                     CLE01
     C                   MOVE      'Y'           CLE011            1                           CLE01
     C                   MOVE      *ON           *IN29                                         CLE01
     C                   ELSE                                                                  CLE01
     C                   MOVE      'N'           CLE011            1                           CLE01
     C                   MOVE      *OFF          *IN29                                         CLE01
     C     PRTCD         IFNE      '*NRF   '                                                   CLE01
     C                   MOVEL     'SCSARDPD'    DBFILE                                        CLE01
     C                   MOVEL     'CLE011'      DBKEY                                         CLE01
     C                   Z-ADD     51            DBASE                                         CLE01
     C                   MOVE      *ON           *INU7                                         CLE01
     C                   MOVE      *ON           *INU8                                         CLE01
     C                   MOVE      *ON           *INLR                                         CLE01
     C                   EXSR      *PSSR                                                       CLE01
     C                   GOTO      ENDT                                                        CLE01
     C                   ENDIF                                                                 CLE01
     C                   ENDIF                                                                 CLE01
      *                                                                   CLE004
     C     @RTCD         IFNE      *BLANKS                                                     CLE00
     C     @RTCD         ANDNE     '*NRF   '                                                   CLE00
      *                                                                   CLE004
      ** Call to program ended in error                                   CLE004
      *                                                                   CLE004
     C     *LOCK         IN        LDA                                                         CLE00
     C                   MOVEL     'CLE004'      DBKEY                          ***************CLE00
     C                   MOVE      'SCSARDPD'    DBFILE                         * DB ERROR 46 *CLE00
     C                   Z-ADD     46            DBASE                          ***************CLE00
     C                   MOVEL     'LE0310'      DBPGM                                         CLE00
     C                   OUT       LDA                                                         CLE00
     C                   EXSR      *PSSR                                                       CLE00
     C                   SETON                                        U7U8                     CLE00
     C                   GOTO      ENDT                                                        CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
     C                   ENDSR                                                  *** CSARC2 *** CLE00
      *                                                                   CLE004
      /EJECT                                                              CLE004
      *****************************************************************   CLE004
      *  OPENP2 - subroutine to open LE0310P2 when LE0310P2   is not  *   CLE004
      *           opened (when LF/CLOANL1 is empty).                  *   CLE004
      *                                                               *   CLE004
      *  Called by:                                                   *   CLE004
      *  Calls: None                                                  *   CLE004
      *                                                               *   CLE004
      *****************************************************************   CLE004
      *                                                                   CLE004
     C     OPENP2        BEGSR                                                  *** OPENP2 *** CLE00
      *                                                                   CLE004
     C                   OPEN      LE0310P2                                                    CLE00
      *                                                                   CLE004
     C                   Z-ADD     SFNUM2        ZSNUM                                         CLE00
     C                   UNLOCK    LDA                                                         12152
     C                   CALL      'ZSFILE'                                                    CLE00
     C                   PARM                    SEQ                                           CLE00
     C                   PARM      *BLANKS       SENTY             3                           CLE00
     C                   PARM                    SFILE2                                        CLE00
     C                   PARM                    ZSNUM                                         CLE00
     C                   PARM                    ZSERR             1                           CLE00
     C     *LOCK         IN        LDA                                                         12152
      *                                                                   CLE004
      ** Error during ZSFILE processing, return to calling program        CLE004
      *                                                                   CLE004
     C     ZSERR         IFEQ      'Y'                                                         CLE00
     C                   SETON                                        U7U8LR                   CLE00
     C                   RETURN                                                                CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
     C                   MOVE      *ON           *IN84                                         CLE00
      *                                                                   CLE004
     C                   ENDSR                                                  *** OPENP2 *** CLE00
      *****************************************************************                       CLE034
      *                                                               *                       CLE034
      *  SRFMT  - subroutine to format settlement allocation details  *                       CLE034
      *                                                               *                       CLE034
      *  Called by: MAIN                                              *                       CLE034
      *  Calls: ZFRPED                                                *                       CLE034
      *                                                               *                       CLE034
      *****************************************************************                       CLE034
      *                                                                                       CLE034
     C     SRFMT         BEGSR
      *                                                                                       CLE034
     C                   Z-ADD     9             ZADEC
      *                                                                                       CLE034
      ** Format Receipt details                                                               CLE034
      *                                                                                       CLE034
     C                   MOVEL     LRSTM         RMETR
     C                   MOVEL     LRSCY         RCCYR
     C                   MOVEL     LRONS         RACCR
     C                   MOVE      *BLANKS       ZFIELD
      *                                                                                       CLE038
      ** Settlement Allocation by Amount                                                      CLE038
      *                                                                                       CLE038
     C     CLE038        IFEQ      'Y'
     C     LRCBA         ANDEQ     'A'
     C                   MOVE      LRCAM         ZFIELD
      *                                                                                       CLE038
      ** If amount is in loan currency                                                        CLE038
     C     LRSCY         IFEQ      *BLANK
     C     LRSTM         OREQ      '09'
     C     SET09         ANDEQ     'T'
     C                   Z-ADD     CDP           ZADEC
      *                                                                                       CLE038
      ** Else, amount is in settlement currency                                               CLE038
     C                   ELSE
     C                   MOVEL     LRSCY         XCCY
     C                   EXSR      CCYDSP
     C                   Z-ADD     XDECP         ZADEC
     C                   ENDIF
      *                                                                                       CLE038
      ** Settlement Allocation by Percentage                                                  CLE038
      *                                                                                       CLE038
     C                   ELSE
     C                   MOVE      LRCPC         ZFIELD
     C                   ENDIF
      *                                                                                       CLE038
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        RPERR
      *                                                                                       CLE034
      ** Format Pay details.                                                                  CLE034
      *                                                                                       CLE034
     C                   MOVEL     LPSTM         RMETP
     C                   MOVEL     LPSCY         RCCYP
     C                   MOVEL     LPONS         RACCP
     C                   MOVE      *BLANKS       ZFIELD
      *                                                                                       CLE038
      ** Settlement Allocation by Amount                                                      CLE038
      *                                                                                       CLE038
     C     CLE038        IFEQ      'Y'
     C     LPYBA         ANDEQ     'A'
     C                   MOVE      LPYAM         ZFIELD
      *                                                                                       CLE038
      ** If amount is in loan currency                                                        CLE038
     C     LPSCY         IFEQ      *BLANK
     C     LPSTM         OREQ      '09'
     C     SET09         ANDEQ     'T'
     C                   Z-ADD     CDP           ZADEC
      *                                                                                       CLE038
      ** Else, amount is in settlement currency                                               CLE038
     C                   ELSE
     C                   MOVEL     LPSCY         XCCY
     C                   EXSR      CCYDSP
     C                   Z-ADD     XDECP         ZADEC
     C                   ENDIF
      *                                                                                       CLE038
      ** Settlement Allocation by Percentage                                                  CLE038
      *                                                                                       CLE038
     C                   ELSE
     C                   Z-ADD     9             ZADEC
     C                   MOVE      LPYPC         ZFIELD
     C                   ENDIF
      *                                                                                       CLE038
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        RPERP
      *                                                                                       CLE034
     C                   ENDSR
      *                                                                                       CLE034
      *****************************************************************                       CLE034
      * SR/SRSVAL - Retrieves system values                           *                       CLE038
      *****************************************************************                       CLE038
     C     SRSVAL        BEGSR
      *                                                                                       CLE038
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    P@OP01           20
     C                   PARM      *BLANKS       P@VL01          200
     C                   PARM      *BLANKS       P@OP02           20
     C                   PARM      *BLANKS       P@VL02          200
     C                   PARM      *BLANKS       P@OP03           20
     C                   PARM      *BLANKS       P@VL03          200
     C                   PARM      *BLANKS       P@OP04           20
     C                   PARM      *BLANKS       P@VL04          200
     C                   PARM      *BLANKS       P@OP05           20
     C                   PARM      *BLANKS       P@VL05          200
     C                   PARM      *BLANKS       P@OP06           20
     C                   PARM      *BLANKS       P@VL06          200
     C                   PARM      *BLANKS       P@OP07           20
     C                   PARM      *BLANKS       P@VL07          200
     C                   PARM      *BLANKS       P@OP08           20
     C                   PARM      *BLANKS       P@VL08          200
     C                   PARM      *BLANKS       P@OP09           20
     C                   PARM      *BLANKS       P@VL09          200
     C                   PARM      *BLANKS       P@OP10           20
     C                   PARM      *BLANKS       P@VL10          200
     C********** SDSVAL    PARM SDSVAL    DSSDY                                      CLE038 MD054605
      *                                                                                       CLE038
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'LE0310  '    DBPGM
     C                   MOVEL     'SDSVALPD'    DBFILE
     C                   MOVEL     P@OP01        DBKEY
     C                   Z-ADD     56            DBASE
     C                   OUT       LDA
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CLE038
     C                   ENDSR
      *****************************************************************                       CLE038
      * SR/CCYDSP - Retrieve CCY decimal places in arrays XCYA, XDPA  *                       CLE038
      *****************************************************************                       CLE038
     C     CCYDSP        BEGSR
      *                                                                                       CLE038
     C     XCCY          IFNE      *BLANKS
     C                   Z-ADD     1             X
     C                   Z-ADD     *ZERO         XDECP             1 0
     C                   MOVE      XCCY          XCCY              3
      *                                                                                       CLE038
      ** Check currency arrays for number of decimal places                                   CLE038
     C     XCCY          LOOKUP    XCYA(X)                                95
     C   95              MOVE      XDPA(X)       XDECP
     C                   ENDIF
      *                                                                                       CLE038
      ** *IN99 is set on for invalid currency                                                 CLE038
     C     *IN95         IFEQ      *OFF
     C                   MOVE      *ON           *IN99
     C     *LOCK         IN        LDA
     C                   MOVEL     'LE0310  '    DBPGM
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     XCCY          DBKEY
     C                   Z-ADD     57            DBASE
     C                   OUT       LDA
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CLE038
     C                   ENDSR
      *****************************************************************                       CLE038
      * SR/CCYARS - Create array of currencies and their decimal      *                       CLE038
      *             places                                            *                       CLE038
      *****************************************************************                       CLE038
     C     CCYARS        BEGSR
      *                                                                                       CLE038
      ** Set off indicators 96 and 99                                                         CLE038
     C                   MOVE      *OFF          *IN99
     C                   MOVE      *OFF          *IN96
      *                                                                                       CLE038
      ** Set array index to zero                                                              CLE038
     C                   Z-ADD     *ZERO         X                 3 0
      *                                                                                       CLE038
      ** Loop through all records in SDCURRPD                                                 CLE038
     C                   READ      SDCURRPD                               99
      *                                                                                       CLE038
     C     *IN99         DOWEQ     *OFF
     C     *IN96         ANDEQ     *OFF
      *                                                                                       CLE038
      ** Increment array index                                                                CLE038
     C     X             ADD       1             X
      *                                                                                       CLE038
      ** Move data into arrays                                                                CLE038
     C                   MOVE      A6CYCD        XCYA(X)
     C                   MOVE      A6NBDP        XDPA(X)
      *                                                                                       CLE038
      ** Check for full array (*IN96 on if full)                                              CLE038
     C     X             IFEQ      150
     C                   MOVE      *ON           *IN96
     C                   ENDIF
      *                                                                                       CLE038
     C                   READ      SDCURRPD                               99
     C                   ENDDO
      *                                                                                       CLE038
     C                   ENDSR
      *****************************************************************                       CLE038
      * LEANAC    : Output AnaCredit Reporting from LEANACQD            *                     CER073
      * ---                                                             *                     CER073
      * Called By : DETA                                                *                     CER073
      * Calls     : None                                                *                     CER073
      *******************************************************************                     CER073
     C     LEANAC        BEGSR
      *                                                                                       CER073
     C     KANAC         KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    LNRF
     C     KANAC         CHAIN     LEANACI1                           92
      *                                                                                       CER073
     C     *IN92         IFEQ      *OFF
      *                                                                                       CER073
      ** Convert Date of the Performing Status of the instrument to DDMMMYY                   CER073
      *                                                                                       CER073
     C     ACDTPS        IFEQ      0
     C                   MOVE      *BLANK        ADTPS             7
     C                   ELSE
     C                   Z-ADD     ACDTPS        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        ADTPS
     C                   ENDIF
      *                                                                                       CER073
      ** Convert Date of Forbearance and Renegotiation to DDMMCCYY                            CER073
      *                                                                                       CER073
     C     ACDTRS        IFEQ      0
     C                   MOVE      *BLANK        DTRS              7
     C                   ELSE
     C                   Z-ADD     ACDTRS        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        DTRS
     C                   ENDIF
      *                                                                                      CER073A
      ** Convert Date of the Default Status of the Instruments                               CER073A
      *                                                                                      CER073A
     C     ACDDSI        IFEQ      0
     C                   MOVE      *BLANK        DDSI              7
     C                   ELSE
     C                   Z-ADD     ACDDSI        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        DDSI
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *****************************************************************                       CER073
      *                                                                   CLE004
      /EJECT                                                              CLE004
     C*/COPY*ZSRSRC,ZFRPEDZ3*********                                                 CLE004 CER073D
     C/COPY ZSRSRC,ZFRPEDZ2LE                                                                CER073D
      ** Sub-routine to insert decimal point.                             CLE004
      *                                                                   CLE004
      /EJECT                                                              CLE004
     C*/COPY*ZSRSRC,ZEDITZ2**********                                                 CLE004 CER073D
     C/COPY ZSRSRC,ZEDITZ2LE                                                                 CER073D
      *                                                                   CLE004
     C********************************************************************S01117
     OLE0310P1  D    30                     2 03                                S01124
1057 O         OR    OF
1058 O***********                        22 'REFERENCE  LE0310'           S01117
1058 O                                           24 'REFERENCE  LE0310P1'       S01117
1059 O                       TITL                89
1060 O                                          104 'DATE'
1061 O                       RUNA               112
1062 O                                          122 'PAGE'
1063 O                       PAGE          Z    128
1064 O          D    30                     1
1065 O         OR    OF
1066 O***********                        60 'LOANS AND PARTICIPATIONS'    S01117
1067 O***********                        79 'PURCHASED AND SOLD'          S01117
1068 O***********                        97 'MAINTENANCE TODAY'           S01117
     O                                           40 'LOANS AND PARTICIPATIONS'  S01117
     O                                           59 'PURCHASED AND SOLD'        S01117
     O                                           77 'MAINTENANCE TODAY'         S01117
     O                     75                    87 'BRANCH'                    S01117
     O                     75BRCA                91                             S01117
     O                     75                    92 '-'                         S01117
     O                     75BRNM               122                             S01117
1069 O********D**2     30                                                 S01117
1069 O          D    30                     1                                   S01117
1070 O         OR    OF
1071 O***********                        60 '------------------------'    S01117
1072 O***********                        80 '--------------------'        S01117
1073 O***********                        97 '-----------------'           S01117
     O                                           40 '------------------------'  S01117
     O                                           60 '--------------------'      S01117
     O                                           77 '-----------------'         S01117
1074 O          D    30                     1
1075 O                                          108 'ACTION'
     O                       CHTPA              111
1077 O***********                       123 'BRANCH'                      S01117
1078 O***********              BRCD     128                               S01117
     O                                          126 'BOOK CODE'                 S01220
     O                       BOKC               130                             S01220
1079 O********D* 1     30                                                                     241660
     O          D    30N31                  1
1080 O                                           13 'CUSTOMER'
1081 O                       CRNM1               35
1082 O                                           41 'LOAN'
1083 O                       LNRF                48
1084 O                                           59 'FAC. CUST'
     O/COPY WNCPYSRC,LE0310O002
1085 O                       FCUS                66
1086 O                                           76 'FACILITY'
1087 O                       FTYP                80
1088 O                                           81 '/'
1089 O                       FSEQ                83
1090 O                                           94 'LOAN TYPE'
1091 O                       LTYP                98
1092 O                                          109 'SUB TYPE'
1093 O                       SUTP               113
1093 O                       CLAS               117
     O/COPY WNCPYSRC,LE0310O003
     O**********************************125 'A/C SEQ.'                                        CLE042
     O                                          125 'A/C SEQ'
     O                       LASQ               128
     O          D    30 31                  1
     O                                           17 'ORIG BORROWER'
     O                       CRNM2               38
     O                                           51 'LOAN'
     O                       LNRF                58
     O                                           68 'FAC. CUST'
     O                       FCUS                75
     O                                           84 'FACILITY'
     O                       FTYP                88
     O                                           89 '/'
     O                       FSEQ                91
     O                                          101 'LOAN TYPE'
     O                       LTYP               104
     O                                          113 'SUB TYPE'
     O                       SUTP               116
     O                       CLAS               120
     O                                          128 'A/C SEQ'
     O                       LASQ               131
1094 O          D    30 33                  2
     O         OR    30N33                  1
1095 O**********                         13 'NO.'                                             241660
1096 O**********               CNUM      21                                                   241660
     O              N31                          13 'NO.'
     O              N31      CNUM                21
     O               31                          17 'NO.'
     O               31      OLNO                24
1097 O                                           40 'CCY'
1098 O                       CCY                 45
1099 O                                           58 'AMOUNT'
1100 O               35      CPAM                78 ' ,   ,   ,   , 0 -'
1101 O               36      CPAM                78 '   ,   ,   , 0 . -'
1102 O               37      CPAM                78 '  ,   ,   , 0 .  -'
1103 O               38      CPAM                78 ' ,   ,   , 0 .   -'
1104 O**********       31                96 'ORIGINAL BORROWER'                               241660
1105 O**********       31      CRNM2    118                                                   241660
     O               31                          96 'PURCHASED FROM'
     O               31      CRNM1              118
1106 O               32                          94 'SALE OF LOAN'
1107 O               32      OLNO               104
     O          D    30N33                  1
     O                                           87 'RECOURSE'
     O                       RCSI               113
     O               14                         113 'N'
1108 O          D    30                     1
1109 O                                           14 'DEAL DATE'
1110 O               50      DDATO               33
1111 O                                           49 'START DATE'
1112 O               51      VDATO               73
1113 O                                           92 'MATURITY DATE'
1114 O               52      MDATO              113
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,LE0310OP4                                            S01408
     O*                                                                   S01408
     O********D**1*****68****************                          070711 071036
     O          D    30 68                  1                                   071036
     O                                           92 'ORIG MAT DATE'             070711
     O***********      55      SOMDT    113                        070711 088897
     O               71      SOMDT              113                             088897
      *                                                                                       CER020
     O          D    30 97                  1
     O                                           22 'INITIAL START DATE'
     O                       RISDT               35
     O                                           58 'FINAL MATURITY DATE'
     O                       RFMDT               73
     O               12                          94 'ORIG CONT. DATE'
     O               12      ROCDT              113
      *                                                                                       CER020
1115 O          D    30                     1
1116 O                                           10 'BASIS'
1117 O**********               ICBS      33                                                  BUG8940
1118 O**********                         48 'BASE RATE'                                       CLE036
1119 O**********       56      BRTT      73                                                   CLE036
1120 O**********                         90 'SPREAD/RATE'                                     CLE036
     O                       ICBS                13
     O**********         N72             25 'BASE RATE'                               CLE036  244691
     O**********          72             30 'BASE RATE CODE'                          CLE036  244691
     O**********       56      BRTT      33                                           CLE036  244691
     O**********          72             48 'BASE RATE'                               CLE036  244691
     O                 N72                       48 'BASE RATE'
     O                  72                       53 'BASE RATE CODE'
     O               56      BRTT                56
     O                  72                       66 'BASE RATE'
     O               01 72   BASR                73 '  0 .       '
     O                                           90 'SPREAD/RATE'                                  B
1121 O**********               RTSP     113 '  0 .       '                                  AR847588
     O                       RTSP               114 '  0 .       -'                               AR
1122 O          D    30                     1
1123 O                                           15 'SPREAD IND'
1124 O                       SPIN                33
1125 O                                           49 'CHANGE IND'
1126 O                       CHIN                73
1127 O                                           91 'DISCOUNT/INT'
1128 O**********       35      TOTI     113 ' ,   ,   ,   , 0 '                             AR833482
1129 O**********       36      TOTI     113 '   ,   ,   , 0 . '                             AR833482
1130 O**********       37      TOTI     113 '  ,   ,   , 0 .  '                             AR833482
1131 O**********       38      TOTI     113 ' ,   ,   , 0 .   '                             AR833482
     O               35      TOTI               114 ' ,   ,   ,   , 0 -'                          AR
     O               36      TOTI               114 '   ,   ,   , 0 . -'                          AR
     O               37      TOTI               114 '  ,   ,   , 0 .  -'                          AR
     O               38      TOTI               114 ' ,   ,   , 0 .   -'                          AR
     O          D    30 09                  1
     O                                           17 'C/SPREAD IND'
     O                       CNSG                33
     O                                           51 'CONT. SPREAD'
     O                       CNSP                73 '  0 .       '
     O                                           94 'ROUNDING METHOD'
     O                       RDMT               113
     O          D    30 09                  1
     O                                           22 'ROUNDING FRAC/DEC'
     O                       RDFD                33
1132 O          D    30                     1
1133 O                                           21 'INT PAYMENT DATE'
1134 O               53      NIDTO               33
1135 O                                           48 'FREQUENCY'
1136 O                       IPFR                73
1137 O                                           84 'DAYNO'
1138 O               57      IFDY               113
     O          D    30 10                  1
     O                                           20 'ADD ON INTEREST'
     O                       RADIF               33
     O                                           53 'ADD ON CHARGES'
     O                       RADCF               73
     O                                           97 'INCLUDE CHARGES IN'
     O                                          106 'INTEREST'
     O                       RICIF              113
     O********D* 1     30 10                                                         CLE028 AR944795
     O          D    30                     1                                                     AR
     O               12 48                       28 'EFFECTIVE INTEREST RATE'
     O               12N48                       25 'EFF. ANNUAL INT. RT.'
     O               12      REAIR               48
     O**********                         92 'CHARGE AMOUNT'                          CLE028 AR944795
     O**********               RCHGA    115                                          CLE028 AR944795
     O               10                          92 'CHARGE AMOUNT'                               AR
     O               10      RCHGA              115                                               AR
1139 O          D    30                     1
1140 O                                           23 'CAPITALISATION IND'
1141 O                       INTC                33
     O                                           63 'ACCRUE'                    S01392
     O                       ADDI                73                             S01392
     O***********      69                94 'PORTFOLIO REFERENCE'  S01486 186808
     O***********      69      OPTFR     96                        S01486 186808
     O               69                          98 'PORTFOLIO REFERENCE'       186808
     O               69      OPTFR              113                             186808
1142 O          D    30                     1
1143 O                                           18 'ROLLOVER DATE'
1144 O               54      RLDTO               33
1145 O                                           48 'FREQUENCY'
1146 O                       RLFQ                73
1147 O                                           84 'DAYNO'
1148 O               58      RLDY               113
1149 O          D    30                     1
1150 O                                           11 'MARGIN'
      *
     O/COPY WNCPYSRC,LE0310OOP6                                           S01408
      *
1151 O                       MARG                34 '0 .     -'
      *
     O/COPY WNCPYSRC,LE0310OOP7                                           S01408
      *
1152 O                                           54 'W/HOLD TAX RATE'
1153 O                       WTRT                73 '  0 .       '
1154 O                                           86 'TAX IND'
1155 O                       WTIN               113
1156 O          D    30                     1
1157 O                                           14 'REPAY IND'
1158 O               59      REPT                33
1159 O                                           45 'AMOUNT'
1160 O               35      RAMT                73 ' ,   ,   ,   , 0 '
1161 O               36      RAMT                73 '   ,   ,   , 0 . '
1162 O               37      RAMT                73 '  ,   ,   , 0 .  '
1163 O               38      RAMT                73 ' ,   ,   , 0 .   '
1164 O                                           94 'AUTO SETTLEMENT'
1165 O                       AUTO               113
1166 O          D    30                     1
1167 O                                           15 'REPAY DATE'
1168 O               55      NRPDO               33
1169 O                                           48 'FREQUENCY'
1170 O                       RFRQ                73
1171 O                                           84 'DAYNO'
1172 O               60      RDYN               113
1173 O          D    30                     1
1174 O                                           12 'SECURED'
1175 O               45                          33 'Y'
1176 O              N45                          33 'N'
1177 O                                           48 'DOCUMENTS'
1178 O               46                          73 'Y'
1179 O              N46                          73 'N'
1180 O                                           82 'FEE'
1181 O               47                         113 'Y'
1182 O              N47                         113 'N'
1183 O          D    30                     1
1184 O                                           13 'FRB CODE'
1185 O               61      FRBC                33
1186 O                                           47 'INDUSTRY'
1187 O**********               LIND      73                                                   CER020
     O                       LOIC                73
1188 O                                           94 'COUNTRY OF RISK'
1189 O                       CRSK               113
1190 O          D    30                     1
1191 O                                           22 'ALTERNATE N/A REF'
1192 O                       NACD                33
1193 O                                           50 'BILLING IND'
1194 O                       BTIN                73
1195 O                                           88 'BILL DAYS'
1196 O               62      BLDY               113
1197 O********D**2     30                                                 S01117
1197 O          D    30                     1                                   S01117
1198 O                                           20 'ACCOUNT OFFICER'
1199 O                       ACOF                33
     O              N77                          52 'PROFIT CENTRE'             S01117
     O              N77      PRFC                73                             S01117
     O****************N76****************97 'ORIGINATING BRANCH'   S01117 070711
     O****************N76******ORBR*****113                        S01117 070711
     O               68                          87 'AUTO PAY'                  070711
     O               68      APMI               113                             070711
     O              N76N68                       97 'ORIGINATING BRANCH'        070711
     O              N76N68   ORBR               113                             070711
     O          D    30 67                  1                                   070711
     O         OR    30 68                  1                                   070711
     O                  67                       18 'RECEIVER NAME'             070711
     O                  67   SCRNM               33                             070711
     O                  68                       48 'CUST CONF'                 070711
     O                  68   SCCNM               73                             070711
     O              N76 68                       97 'ORIGINATING BRANCH'        070711
     O              N76 68   ORBR               113                             070711
     O               75N68                       94 'FACILITY BRANCH'           070711
     O               75N68   FCLB               113                             070711
     O********D  2     30 67N68                                    070711 S01518
     O          D    30 67N68                                                   S01518
     O                                           18 'TOWN'                      070711
     O                       SCRTN               33                             070711
     O               15                          58 'FUNDING SPREAD/RATE'       CAC001
     O               15      FSRP                73 '  0 .       '              CAC001
1197 O********D**2*****30****************                          S01117 070711
     O********D  2     30N68N67                                    070711 S01518
     O*******OR  2     30 68 67                                    070711 S01518
     O*******OR  2     30 68N67                                    070711 S01518
     O          D    30N68N67                                                   S01518
     O         OR    30 68 67                                                   S01518
     O         OR    30 68N67                                                   S01518
     O               67                          18 'TOWN'                      070711
     O               67      SCRTN               33                             070711
     O               15                          58 'FUNDING SPREAD/RATE'       CAC001
     O               15      FSRP                73 '  0 .       '              CAC001
1197 O********D  2     30                                          S01117 S01518
1197 O          D    30                     1                                   S01518
     O/COPY WNCPYSRC,LE0310OOP8                                           S01408
     O               15                          26 'FUNDING PROFIT CENTRE'     CAC001
     O               15      FPRC                33                             CAC001
     O               15                          58 'FUNDING SPREAD SIGN'       CAC001
     O               15      FSGN                73                             CAC001
     O               75                          94 'FACILITY BRANCH'           S01117
     O               75      FCLB               113                             S01117
     O/COPY WNCPYSRC,LE0310O010
1200 O********D  1     30                                                 S01518
     O********D*11     30N80                                                           S01518 CLE034
     O          D    30N80N17            1  1
1201 O                                           30 'SETTLEMENT INSTRUCTIONS'
1202 O********D  1     30                                                 S01518
     O********D* 1     30N80                                                           S01518 CLE034
     O          D    30N80N17               1
1203 O                                           18 'START    TYPE'
1204 O                       SDST                33
1205 O                                           43 'OURS'
1206 O***********              OSDA      73                               S01117
1206 O                       OSDA                69                             S01117
     O               75      OSDB                73                             S01117
1207 O                                           85 'THEIRS'
     O/COPY WNCPYSRC,LE0310O004
1208 O                       TSTN               113
     O/COPY WNCPYSRC,LE0310O005
1209 O********D  1     30                                                 S01518
     O********D* 1     30N80                                                           S01518 CLE034
     O          D    30N80N17               1
1210 O                                           18 'MATURITY TYPE'
1211 O                       MDST                33
1212 O                                           43 'OURS'
1213 O***********              OMDA      73                               S01117
1213 O                       OMDA                69                             S01117
     O               75      OMDB                73                             S01117
1214 O                                           85 'THEIRS'
1215 O                       TMAN               113
1216 O********D  1     30                                                 S01518
     O********D* 1     30N80                                                           S01518 CLE034
     O          D    30N80N17               1
1217 O                                           19 'FOR ACCOUNT OF'
     O/COPY WNCPYSRC,LE0310O006
1218 O                       FACO                33
     O/COPY WNCPYSRC,LE0310O007
1219 O********D  1     30                                                 S01518
     O********D* 1     30N80                                                           S01518 CLE034
     O          D    30N80N17               1
     O                                           67 'SPECIAL INST'
     O               28                          67 'BENIF. BANK '
1221 O                       SPI1                99
1222 O********D  1     30                                                 S01518
     O          D    30N80                  1                                   S01518
1223 O                                           18 'BASE CCY RATE'
1224 O               63      BCXR                35 '   0 .        '
     O               63      RBMDI               37                             147994
     O**********       28                67 'SPECIAL INST'                                    CLE034
1225 O**********               SPI2      99                                                   CLE034
     O               28N17                       67 'SPECIAL INST'
     O              N17      SPI2                99
1226 O********D  2     30                                                 S01518
     O          D    30N80                  2                                   S01518
1227 O                                           18 'FCLT CCY RATE'
1228 O               64      FCXR                35 '   0 .        '
     O               64      RFMDI               37                             147994
1229 O**********               SPI3      99                                                   CLE034
     O              N17      SPI3                99
     O/COPY WNCPYSRC,LE0310O001
1230 O********D        30                                                 S01518
     O          D    30N80                                                      S01518
1231 O                                           14 'NARRATIVE'
1232 O                       NAR1                50
1234 O               65      NBRA                89
1233 O**********                         73 'ROLLOVER BASE RATE'                              CLE036
     O                 N72                       73 'ROLLOVER BASE RATE'
     O                  72                       78 'ROLLOVER BASE RATE CODE'
     O               86 72   NBSR               115 '  0 .       '
     O                  72                       93 'ROLLOVER BASE RATE'
     O*                                                                   S01408
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,LE0310OLH1                                           S01408
     O*                                                                   S01408
1235 O********D  1     30                                                 S01518
     O          D    30N80                  1                                   S01518
1236 O                       NAR2                50
1237 O                                           75 'ROLLOVER SPREAD/RATE'
1238 O**********               NRTS      89 '  0 .       '                                  MD021416
     O                       NRTS                90 '  0 .       -'                               MD
     O*                                                                   S01408
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,LE0310OLH2                                           S01408
     O*                                                                   S01408
1239 O********D  1     30                                                 S01518
     O          D    30N80                  1                                   S01518
1240 O                       NAR3                50
1241 O                                           74 'ROLLOVER SPREAD IND'
1242 O                       NSIN                89
     O*                                                                   S01408
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,LE0310OP2                                            S01408
     O*                                                                   S01408
1243 O********D  1     30                                                 S01518
     O          D    30N80                  1                                   S01518
1244 O                       NAR4                50
1245 O                                           78 'ROLLOVER INT CALC BASIS'
1246 O                       NCAC                89
     O*                                                                   S01408
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,LE0310OP3                                            S01408
     O*                                                                   S01408
1247 O********D  1     30                                                 S01518
     O          D    30N80                  1                                   S01518
1248 O                                           73 'NEXT ROLLOVER DATE'
1249 O               49      NRODO               89
     O               15                         118 'NEW FUNDING SPREAD/RATE'   CAC001
     O               15      NFRS               131 '  0 .       '              CAC001
     O*                                                                   S01408
     O/COPY WNCPYSRC,LE0310OOP2                                           S01408
     O*                                                                   S01408
     O********D  1     30                                                 S01518
     O          D    30N80                  1                                   S01518
     O                  87                       22 'FACILITY CURRENCY'         CLE004
     O                  87   RFCCY               37                             CLE004
     O                                           74 'ROLLOVER CHANGE IND'
     O                       NCHI                89
     O               15                         111 'NEW FUNDING SIGN'          CAC001
     O               15      NFSN               131                             CAC001
     O*                                                                   S01408
     O/COPY WNCPYSRC,LE0310OOP1                                           S01408
     O*                                                                   S01408
     O          D    30 74                  1
     O                                           16 'SUBORDINATE'
     O                       VKSUBR              33
     O                                           56 'IMPORT/EXPORT IND'
     O                       VKIMEX              73
     O                                           91 'LUM-SUM CODE'
     O                       VKLUSU             113
     O          D    30 74                  1
     O                                           26 'MOBILISATION CUSTOMER'
     O                       VKMOBL              33
     O                                           48 'RISK CODE'
     O                       VKRISC              73
     O                                           93 'DEGREE OF RISK'
     O                       VKDGRI             113
     O          D    30 74                  1
     O                                           20 'PROPERTY SECTOR'
     O                       VKPPSC              33
     O                                           58 'BCL CIRCULAR 96/127'
     O                       VKIM93              73
     O                                           94 'CONSUMER CREDIT'
     O                       VK1UAC             113
     O          D    30 74                  1
     O                                           16 'COR. AMOUNT'
     O               35      VKCOAM              33 '   ,   ,   ,   , 0 '
     O               36      VKCOAM              33 '  ,   ,   ,   , 0 . '
     O               37      VKCOAM              33 ' ,   ,   ,   , 0 .  '
     O               38      VKCOAM              33 '   ,   ,   , 0 .   '
     O                                           51 'CLAIM''S TYPE'
     O                       VKCLAT              73
     O********D  1     30                                           S01392S01518
     O          D    30N80                  1                                   S01518
     O                  87                       17 'REPAY AMOUNT'              CLE004
     O                  87   RFCR0               37                             CLE004
     O                                           68 'NEW PRINCIPAL'             S01392
     O               35      NPRAM               89 ' ,   ,   ,   , 0 '         S01392
     O               36      NPRAM               89 '   ,   ,   , 0 . '         S01392
     O               37      NPRAM               89 '  ,   ,   , 0 .  '         S01392
     O               38      NPRAM               89 ' ,   ,   , 0 .   '         S01392
     O               85 87                      114 'MULTI-CURRENCY ROLL'       CLE004
     O               85 87                      121 'ALLOWED'                   CLE004
     O               85 87   RMCRA              131                             CLE004
     O               88                         114 'MULTI-CURRENCY ROLL'       CEU020
     O               88                         121 'ALLOWED'                   CEU020
     O               88      RMCRA              131                             CEU020
     O********D  1     30                                           S01392S01518
     O          D    30N80                  1                                   S01518
     O                  87                       20 'PAYMENT DUE DAY'           CLE004
     O                  87   RPDDI               37                             CLE004
     O                                           67 'NEW DISCOUNT'              S01392
     O**********       35      NDAM      89 ' ,   ,   ,   , 0 '                      S01392 AR833482
     O**********       36      NDAM      89 '   ,   ,   , 0 . '                      S01392 AR833482
     O**********       37      NDAM      89 '  ,   ,   , 0 .  '                      S01392 AR833482
     O**********       38      NDAM      89 ' ,   ,   , 0 .   '                      S01392 AR833482
     O               35      NDAM                90 ' ,   ,   ,   , 0 -'                          AR
     O               36      NDAM                90 '   ,   ,   , 0 . -'                          AR
     O               37      NDAM                90 '  ,   ,   , 0 .  -'                          AR
     O               38      NDAM                90 ' ,   ,   , 0 .   -'                          AR
     O               85 87                      107 'NEW CURRENCY'              CLE004
     O               85 87   RNCCY              131                             CLE004
     O               88                         107 'NEW CURRENCY'              CEU020
     O               88      RNCCY              131                             CEU020
     O/COPY WNCPYSRC,LE0310O008
     O          D    30N80 87               1                                   CLE004
     O                                           22 'PAYMENT TAKEN DAY'         CLE004
     O                       RPTDI               37                             CLE004
     O                                           73 'NEW CURR PRINCIPAL'        CLE004
     O                       RNCP0               90                             CLE004
     O                  85                      115 'NEW FCLT CCY EX RATE'      CLE004
     O                  85   RNFCE              131                             CLE004
     O          D    30N80 88               1                                   CEU020
     O         AND  N87                                                         CEU020
     O                                           73 'NEW CURR PRINCIPAL'        CEU020
     O                       RNCP0               90                             CEU020
     O                                          115 'NEW FCLT CCY EX RATE'      CEU020
     O                       RNFCE              131                             CEU020
     O          D    30N80 87               1                                   CLE004
     O                                           29 'GRACE DAYS FOR PRINCIPAL'  CLE004
     O                       RPTDI               37                             CLE004
     O                                           73 'NEW LOAN CCY REPAY'        CLE004
     O***********              RNCP0     90                         CLE004148631
     O                       RNLR0               90                             148631
     O                  85                      117 'NEW FCLT CCY MULT/DIV '    CLE004
     O                  85                      120 'IND'                       CLE004
     O                  85   RNFMD              131                             CLE004
     O          D    30N80 88               1                                   CEU020
     O         AND  N87                                                         CEU020
     O                                           73 'NEW LOAN CCY REPAY'        CEU020
     O                       RNLR0               90                             CEU020
     O                                          117 'NEW FCLT CCY MULT/DIV '    CEU020
     O                                          120 'IND'                       CEU020
     O                       RNFMD              131                             CEU020
     O          D    30N80 87               1                                   CLE004
     O                                           28 'GRACE DAYS FOR INTEREST'   CLE004
     O                       RGDIN               37                             CLE004
     O********                           78 'ORIGINATING LOAN NUMBER'E004 187904
     O********                 RTOLN     90                        CLE004 187904
     O               85                          78 'ORIGINATING LOAN NUMBER'   187904
     O               85      RTOLN               90                             187904
     O********D  1     30N80 87                                    CLE004 187904
     O          D    30N80 85               1                                   187904
     O                                           26 'GENERATED BY TRANSFER'     CLE004
     O                       RGPRT               37                             CLE004
     O*                                                                   S01408
     O/COPY WNCPYSRC,LE0310OOP3                                           S01408
     O*                                                                   S01408
     O          D    30 80                  1
     O                  72                       62 'ROLLOVER BASE RATE CODE'
     O               65      NBRA                69
     O          D    30 80                  1                                   S01518
     O**********                         18 'BASE CCY RATE'                            S01518 CLE036
     O**********       63      BCXR      35 '   0 .        '                           S01518 CLE036
     O**********       63      RBMDI     37                                            147994 CLE036
     O**********                         57 'ROLLOVER BASE RATE'                       S01518 CLE036
     O**********       65      NBRA      75                                            S01518 CLE036
     O**********         N72             23 'ROLLOVER BASE RATE'                       CLE036 244691
     O**********          72             28 'ROLLOVER BASE RATE CODE'                  CLE036 244691
     O**********       65      NBRA      35                                            CLE036 244691
     O                                           18 'BASE CCY RATE'
     O               63      BCXR                35 '   0 .        '
     O               63      RBMDI               37
     O                 N72                       57 'ROLLOVER BASE RATE'
     O                  72                       57 'ROLLOVER BASE RATE'
     O               86 72   NBSR                75 '  0 .       '
     O                                           88 'NARRATIVE'                 S01518
     O                       NAR1               132                             S01518
     O          D    30 80                  1                                   S01518
     O**********                         18 'FCLT CCY RATE'                            S01518 CLE036
     O**********       64      FCXR      35 '   0 .        '                           S01518 CLE036
     O**********       64      RFMDI     37                                            147994 CLE036
     O**********                         18 'BASE CCY RATE'                            CLE036 244691
     O**********       63      BCXR      35 '   0 .        '                           CLE036 244691
     O**********       63      RBMDI     37                                            CLE036 244691
     O                                           18 'FCLT CCY RATE'
     O               64      FCXR                35 '   0 .        '
     O               64      RFMDI               37
     O                                           59 'ROLLOVER SPREAD/RATE'      S01518
     O**********               NRTS      75 '  0 .       '                           S01518 MD021416
     O                       NRTS                76 '  0 .       -'                               MD
     O                       NAR2               132                             S01518
     O          D    30 80                  1                                   S01518
     O**********                         18 'FCLT CCY RATE'                            CLE036 244691
     O**********       64      FCXR      35 '   0 .        '                           CLE036 244691
     O**********       64      RFMDI     37                                            CLE036 244691
     O          D    30 80                  1                                   S01518
     O                                           58 'ROLLOVER SPREAD IND'       S01518
     O                       NSIN                75                             S01518
     O                       NAR3               132                             S01518
     O          D    30 80                  1                                   CLE011
     O                       NAR4               132                             CLE011
     O          D    30 29                  1                                   CLE011
     O                                           27 'ROLLOVER RATE FIX DAYS'    CLE011
     O                       RFDY                37                             CLE011
     O                                           58 'ROLLOVER RATE FIXED'       CLE011
     O                       RFRI                75                             CLE011
     O                                           98 'ROLLOVER FIXED RATE'       CLE011
     O                       RRFRT1             115                             CLE011
     O          D    30 80                  1                                   S01518
     O               87                          22 'FACILITY CURRENCY'         CLE004
     O               87      RFCCY               37                             CLE004
     O                                           62 'ROLLOVER INT CALC BASIS'   S01518
     O                       NCAC                75                             S01518
     O**********               NAR4     132                        S01518 CLE011
     O          D    30 80                  1                                   S01518
     O***********                        60 'ROLLOVER INTEREST PAY'S01518 086726
     O***********                        65 ' DATE'                S01518 086726
     O***********      68      NIPDO     75                        S01518 086726
     O               87                          17 'REPAY AMOUNT'              CLE004
     O               87      RRAM0               37                             CLE004
     O                                           60 'NEW ROLLOVER INT. PAY'     086726
     O                                           65 ' DATE'                     086726
     O               68 81   NIPDO               75                             086726
     O                                           96 'NEW MATURITY DATE'         088426
     O               68 79   NMDTO              113                             088426
     O          D    30 80                  1                                   S01518
     O               87                          20 'PAYMENT DUE DAY'           CLE004
     O               87      RPDDI               37                             CLE004
     O                                           57 'NEXT ROLLOVER DATE'        S01518
     O               49      NRODO               75                             S01518
     O               15                         102 'NEW FUNDING SPREAD/RATE'   CAC001
     O               15      NFRS               115 '  0 .       '              CAC001
     O          D    30 80                  1                                   S01518
     O               87                          22 'PAYMENT TAKEN DAY'         CLE004
     O               87      RPTDI               37                             CLE004
     O                                           58 'ROLLOVER CHANGE IND'       S01518
     O                       NCHI                75                             S01518
     O               15                          95 'NEW FUNDING SIGN'          CAC001
     O               15      NFSN               115                             CAC001
     O          D    30 80                  1                                   S01518
     O               87                          24 'GRACE DAYS FOR PRIN'       CLE004
     O               87                          29 'CIPAL'                     CLE004
     O               87      RGDPR               37                             CLE004
     O                                           52 'NEW PRINCIPAL'             S01518
     O               35      NPRAM               75 ' ,   ,   ,   , 0 '         S01518
     O               36      NPRAM               75 '   ,   ,   , 0 . '         S01518
     O               37      NPRAM               75 '  ,   ,   , 0 .  '         S01518
     O               38      NPRAM               75 ' ,   ,   , 0 .   '         S01518
     O               87 85                       98 'MULTI-CURRENCY ROLL'       CLE004
     O               87 85                      106 'ALLOWED'                   CLE004
     O               87 85   RMCRA              115                             CLE004
     O               88                          98 'MULTI-CURRENCY ROLL'       CEU020
     O               88                         106 'ALLOWED'                   CEU020
     O               88      RMCRA              115                             CEU020
     O********D  2     30 80                                       S01392 S01518
     O          D    30 80                  1                                   S01518
     O               87                          28 'GRACE DAYS FOR INTEREST'   CLE004
     O               87      RGDIN               37                             CLE004
     O                                           51 'NEW DISCOUNT'              S01518
     O**********       35      NDAM      75 ' ,   ,   ,   , 0 '                      S01518 AR833482
     O**********       36      NDAM      75 '   ,   ,   , 0 . '                      S01518 AR833482
     O**********       37      NDAM      75 '  ,   ,   , 0 .  '                      S01518 AR833482
     O**********       38      NDAM      75 ' ,   ,   , 0 .   '                      S01518 AR833482
     O               35      NDAM                76 ' ,   ,   ,   , 0 -'                          AR
     O               36      NDAM                76 '   ,   ,   , 0 . -'                          AR
     O               37      NDAM                76 '  ,   ,   , 0 .  -'                          AR
     O               38      NDAM                76 ' ,   ,   , 0 .   -'                          AR
     O               87 85                       91 'NEW CURRENCY'              CLE004
     O               87 85   RNCCY              115                             CLE004
     O               88                          91 'NEW CURRENCY'              CEU020
     O               88      RNCCY              115                             CEU020
     O/COPY WNCPYSRC,LE0310O009
     O          D    30 80 87               1                                   CLE004
     O********                           26 'GENERATED BY TRANSFER'CLE004 187904
     O********                 RGPRT     37                        CLE004 187904
     O               85                          26 'GENERATED BY TRANSFER'     187904
     O               85      RGPRT               37                             187904
     O                                           57 'NEW CURR PRINCIPAL'        CLE004
     O                       RNCP0               75                             CLE004
     O               85                          99 'NEW FCLT CCY EX RATE'      CLE004
     O               85      RNFCE              115                             CLE004
     O          D    30 80 88               1                                   CEU020
     O         AND  N87                                                         CEU020
     O                                           57 'NEW CURR PRINCIPAL'        CEU020
     O                       RNCP0               75                             CEU020
     O                                           99 'NEW FCLT CCY EX RATE'      CEU020
     O                       RNFCE              115                             CEU020
     O          D    30 80 87               1                                   CLE004
     O********                           24 'ORIGINATING LOAN NU'  CLE004 187904
     O********                           28 'MBER'                 CLE004 187904
     O********                 RTOLN     37                        CLE004 187904
     O                                           24 'ORIGINATING LOAN NU'       187904
     O                                           28 'MBER'                      187904
     O                       RTOLN               37                             187904
     O                                           57 'NEW LOAN CCY REPAY'        CLE004
     O                       RNLR0               75                             CLE004
     O               85                          97 'NEW FCLT CCY MULT/'        CLE004
     O               85                         104 'DIV IND'                   CLE004
     O               85      RNFMD              115                             CLE004
     O********D* 1     30                                                              147935 196066
     O          D    30 39                  1
     O                                           19 'INSERTING USER'            147935
     O                       RIUSR               37                             147935
     O                                           52 'AMENDING USER'             147935
     O                       RAUSR               75                             147935
     O                                           95 'AUTHORISING USER'          147935
     O**********               RXUSR    115                                            147935 199886
     O                       RXUSR              118
     O********D* 1     30                                                              199886 196066
     O          D    30 39                  1
     O               16                          26 'SETTLEMENT ALLOCATION'
     O               16      RSTAL               37
     O                                           61 'ROLLOVER AMENDING USER'
     O                       RRAUS               75
     O                                          100 'ROLLOVER AUTHORISING '
     O                                          104 'USER'
     O                       RRXUS              118
     O          D    30 11                  1                                                      B
     O                                           18 'FCLT CCY PRIN'                                B
     O               35      FPAM                37 '            0 '                               B
     O               36      FPAM                37 '          0 . '                               B
     O               37      FPAM                37 '         0 .  '                               B
     O               38      FPAM                37 '        0 .   '                               B
     O                                           53 'FCLT CCY REPAY'                               B
     O               35      FCRA                75 '            0 '                               B
     O               36      FCRA                75 '          0 . '                               B
     O               37      FCRA                75 '         0 .  '                               B
     O               38      FCRA                75 '        0 .   '                               B
      *                                                                   147935
     O          D    30 80 88               1                                   CEU020
     O         AND  N87                                                         CEU020
     O                                           57 'NEW LOAN CCY REPAY'        CEU020
     O                       RNLR0               75                             CEU020
     O                                           97 'NEW FCLT CCY MULT/'        CEU020
     O                                          104 'DIV IND'                   CEU020
     O                       RNFMD              115                             CEU020
      *                                                                                       CER050
     O          D    30 68 98               1
     O                                           28 'APR CALCULATION REQUIRED'
     O                       APRC                31
     O                                           58 'ANNUAL PREMIUM AMOUNT'
     O               35      PREM                78 ' ,   ,   ,   , 0 -'
     O               36      PREM                78 '   ,   ,   , 0 . -'
     O               37      PREM                78 '  ,   ,   , 0 .  -'
     O               38      PREM                78 ' ,   ,   , 0 .   -'
     O                                           88 'APR RATE'
     O                       IAPRR               99 '  0 .  '
     O*
     O/COPY WNCPYSRC,LE0310OOP4
     O*
     O***LE0310P1D  203   30 80                                                        088373 CLE034
     OLE0310P1  D    30 80N17               2 03
     O                                           24 'REFERENCE  LE0310P1'       088373
     O                       TITL                89                             088373
     O                                          104 'DATE'                      088373
     O                       RUNA               112                             088373
     O                                          122 'PAGE'                      088373
     O                       PAGE          Z    128                             088373
     O********D* 1     30 80                                                           088373 CLE034
     O          D    30 80N17               1
     O                                           40 'LOANS AND PARTICIPATIONS'  088373
     O                                           59 'PURCHASED AND SOLD'        088373
     O                                           77 'MAINTENANCE TODAY'         088373
     O                     75                    87 'BRANCH'                    088373
     O                     75BRCA                91                             088373
     O                     75                    92 '-'                         088373
     O                     75BRNM               122                             088373
     O********D* 1     30 80                                                           088373 CLE034
     O          D    30 80N17               1
     O                                           40 '------------------------'  088373
     O                                           60 '--------------------'      088373
     O                                           77 '-----------------'         088373
     O********D* 1     30 80                                                           088373 CLE034
     O          D    30 80N17               1
     O                                          108 'ACTION'                    088373
     O                       CHTPA              111                             088373
     O                                          126 'BOOK CODE'                 088373
     O                       BOKC               130                             088373
     O********D* 1     30 80                                                           088373 CLE034
     O          D    30 80N17               1
     O         AND  N31
     O                                           13 'CUSTOMER'                  088373
     O                       CRNM1               35                             088373
     O                                           41 'LOAN'                      088373
     O                       LNRF                48                             088373
     O                                           59 'FAC. CUST'                 088373
     O                       FCUS                66                             088373
     O                                           76 'FACILITY'                  088373
     O                       FTYP                80                             088373
     O                                           81 '/'                         088373
     O                       FSEQ                83                             088373
     O                                           94 'LOAN TYPE'                 088373
     O                       LTYP                98                             088373
     O                                          109 'SUB TYPE'                  088373
     O                       SUTP               113                             088373
1093 O                       CLAS               117
     O**********************************125 'A/C SEQ.'                                 088373 CLE042
     O                                          125 'A/C SEQ'
     O                       LASQ               128                             088373
     O          D    30 80N17               1
     O         AND   31
     O                                           17 'ORIG BORROWER'
     O                       CRNM2               38
     O                                           51 'LOAN'
     O                       LNRF                58
     O                                           68 'FAC. CUST'
     O                       FCUS                75
     O                                           84 'FACILITY'
     O                       FTYP                88
     O                                           89 '/'
     O                       FSEQ                91
     O                                          101 'LOAN TYPE'
     O                       LTYP               104
     O                                          113 'SUB TYPE'
     O                       SUTP               116
1093 O                       CLAS               120
     O                                          128 'A/C SEQ'
     O                       LASQ               131
     O          D    30 33 80               2                                   088373
     O         AND  N17
     O         OR    30N33 80               1                                   088373
     O         AND  N17
     O**********                         13 'NO.'                         088373              241660
     O**********               CNUM      21                               088373              241660
     O              N31                          13 'NO.'
     O              N31      CNUM                21
     O               31                          17 'NO.'
     O               31      OLNO                24
     O                                           40 'CCY'                       088373
     O                       CCY                 45                             088373
     O                                           58 'AMOUNT'                    088373
     O               35      CPAM                78 ' ,   ,   ,   , 0 -'        088373
     O               36      CPAM                78 '   ,   ,   , 0 . -'        088373
     O               37      CPAM                78 '  ,   ,   , 0 .  -'        088373
     O               38      CPAM                78 ' ,   ,   , 0 .   -'        088373
     O**********       31                96 'ORIGINAL BORROWER'           088373              241660
     O**********       31      CRNM2    118                               088373              241660
     O               31                          96 'PURCHASED FROM'
     O               31      CRNM1              118
     O               32                          94 'SALE OF LOAN'              088373
     O               32      OLNO               104                             088373
     O          D    30N33 80               1                                   088373
     O                                           87 'RECOURSE'                  088373
     O                       RCSI               113                             088373
     O               14                         113 'N'                         088373
     O********D  1     30 80                                        S01518088373
     O********D*11     30 80                                                           088373 CLE034
     O          D    30 80N17            1  1
     O                                           29 'RECEIPT SETTLEMENT INSTR'  S01518
     O                                           36 'UCTIONS'                   S01518
     O                                           77 'PAYMENT SETTLEMENT INSTR'  S01518
     O                                           84 'UCTIONS'                   S01518
     O          D    30 80 11               1
     O         AND  N17
     O                                           24 'SETTLEMENT CURRENCY'
     O                       RSCCY               28
     O                                           78 'SETTLEMENT CURRENCY'
     O                       RPSCY               82
     O          D    30 80 11               1
     O         AND  N17
     O                                           28 'SETTLEMENT CCY EXCHANGE'
     O                                           37 'RATE/IND'
     O                       RREXR               52
     O                                           53 '/'
     O                       RREXI               54
     O                                           82 'SETTLEMENT CCY EXCHANGE'
     O                                           91 'RATE/IND'
     O                       RPEXR              106
     O                                          107 '/'
     O                       RPEXI              108
     O********D* 1     30 80                                                           S01518 CLE034
     O          D    30 80N17               1
     O                                           22 'SETTLEMENT METHOD'         S01518
     O                       RSTM                35                             S01518
     O                                           70 'SETTLEMENT METHOD'         S01518
     O                       PSTM                84                             S01518
     O********D* 1     30 80                                                           S01518 CLE034
     O          D    30 80N17               1
     O                                           15 'OUR NOSTRO'                S01518
     O**********               RONS      35                                            S01518 CGL029
     O                       RONS                41
     O                                           63 'OUR NOSTRO'                S01518
     O**********               PONS      94                                            S01518 CGL029
     O                       PONS               100
     O********D* 1     30 80                                                           S01518 CLE034
     O          D    30 80N17               1
     O                                           22 'ORDERING CUSTOMER'         S01518
     O                       ROCN                35                             S01518
     O                                           77 'MT202 SUPPLEMENTARY MESS'  S01518
     O                                           80 'AGE'                       S01518
     O                       CVMR                83                             S01518
     O********D* 1     30 80                                                           S01518 CLE034
     O          D    30 80N17               1
     O                                           18 'ORDERING BANK'             S01518
     O                       ROBN                35                             S01518
     O                                           61 'RECEIVER'                  S01518
     O************             RCRN      90                        S01518 107009
     O                       RVNO                90                             107009
     O********D* 1     30 80                                                           S01518 CLE034
     O          D    30 80N17               1
     O                                           25 'INTERMEDIARY BANK NO'      S01518
     O                       RIBN                35                             S01518
     O                                           70 'ORDERING CUSTOMER'         S01518
     O                       POCN                90                             S01518
     O********D* 1     30 80                                                           S01518 CLE034
     O          D    30 80N17               1
     O                                           18 'A/C LINE'                  S01518
     O                       RIBA                55                             S01518
     O                                           66 'ORDERING BANK'             S01518
     O                       POBN                90                             S01518
     O********D* 1     30 80                                                           S01518 CLE034
     O          D    30 80N17               1
     O                                           76 'RECEIVER''S CORRESPONDEN'  S01518
     O                                           80 'T NO'                      S01518
     O                       RCRN                90                             S01518
     O*
     O/COPY WNCPYSRC,LE0310OOP5
     O*
     O********D* 1     30 80                                                           S01518 CLE034
     O          D    30 80N17               1
     O                                           81 'A/C LINE'                  S01518
     O                       RCRA               117                             S01518
     O********D* 1     30 80                                                           S01518 CLE034
     O          D    30 80N17               1
     O                                           73 'INTERMEDIARY BANK NO'      S01518
     O                       PIBN                90                             S01518
     O********D* 1     30 80                                                           S01518 CLE034
     O          D    30 80N17               1
     O                                           81 'A/C LINE'                  S01518
     O                       PIBA               117                             S01518
     O********D* 1     30 80                                                           S01518 CLE034
     O          D    30 80N17               1
     O               82                          29 'ROLLOVER SETTLEMENT INST'  S01518
     O               82                          36 'RUCTIONS'                  S01518
     O                                           73 'ACCOUNT WITH BANK NO'      S01518
     O                       AWBN                90                             S01518
     O********D* 1     30 80                                                           S01518 CLE034
     O          D    30 80N17               1
     O               82                          22 'SETTLEMENT METHOD'         S01518
     O               82      RRST                35                             S01518
     O                                           81 'A/C LINE'                  S01518
     O                       AWBA               117                             S01518
     O********D* 1     30 80                                                           S01518 CLE034
     O          D    30 80N17               1
     O               82                          15 'OUR NOSTRO'                S01518
     O               82      RRON                35                             S01518
     O                                           67 'BENEFICIARY NO'            S01518
     O                       BENN                90                             S01518
     O********D* 1     30 80                                                           S01518 CLE034
     O          D    30 80N17               1
     O               82                          22 'ORDERING CUSTOMER'         S01518
     O               82      RROC                35                             S01518
     O                                           81 'A/C LINE'                  S01518
     O                       BENA               117                             S01518
     O********D* 1     30 80                                                           S01518 CLE034
     O          D    30 80N17               1
     O               82                          18 'ORDERING BANK'             S01518
     O               82      RROB                35                             S01518
     O                                           73 'DETAILS OF PAYMENT 1'      S01518
     O                       DTP1               117                             S01518
     O********D* 1     30 80                                                           S01518 CLE034
     O          D    30 80N17               1
     O               82                          25 'INTERMEDIARY BANK NO'      S01518
     O               82      RRIB                35                             S01518
     O                                           73 '2'                         S01518
     O                       DTP2               117                             S01518
     O********D* 1     30 80                                                           S01518 CLE034
     O          D    30 80N17               1
     O               82                          18 'A/C LINE'                  S01518
     O               82      RRBA                55                             S01518
     O                                           73 '3'                         S01518
     O                       DTP3               117                             S01518
     O/COPY WNCPYSRC,LE0310O011
     O********D* 1     30 80                                                           S01518 CLE034
     O          D    30 80N17               1
     O                                           73 '4'                         S01518
     O                       DTP4               117                             S01518
     O/COPY WNCPYSRC,LE0310O012
     O********D* 1     30 80                                                           S01518 CLE034
     O          D    30 80N17               1
     O                                           71 'DETAILS OF CHARGES'        S01518
     O                       DCHG                85                             S01518
     O/COPY WNCPYSRC,LE0310O013
     O********D* 1     30 80                                                           S01518 CLE034
     O          D    30 80N17               1
     O                                           70 'BANK TO BANK INFO'         S01518
     O/COPY WNCPYSRC,LE0310O014
     O********D* 1     30 80                                                           S01518 CLE034
     O          D    30 80N17               1
     O                                           54 '1'                         S01518
     O                       BTB1                90                             S01518
     O                                           94 '4'                         S01518
     O                       BTB4               130                             S01518
     O/COPY WNCPYSRC,LE0310O015
     O********D* 1     30 80                                                           S01518 CLE034
     O          D    30 80N17               1
     O                                           54 '2'                         S01518
     O                       BTB2                90                             S01518
     O                                           94 '5'                         S01518
     O                       BTB5               130                             S01518
     O/COPY WNCPYSRC,LE0310O016
     O********D* 1     30 80                                                           S01518 CLE034
     O          D    30 80N17               1
     O                                           54 '3'                         S01518
     O                       BTB3                90                             S01518
     O                                           94 '6'                         S01518
     O/COPY WNCPYSRC,LE0310O017
     O                       BTB6               130                             S01518
     O          D    83 30                  1
     O                                           24 'BUSINESS DAY CONVE'
     O                                           33 'NTION FOR'
     O                                           78 'BUSINESS DAY CONVE'
     O                                           87 'NTION FOR'
     O          D    83 30                  1
     O                                           24 'INTEREST AND PRINC'
     O                                           39 'IPAL REPAYMENTS'
     O                                           78 'ROLLOVER AND RATE '
     O                                           84 'FIXING'
     O          D    83 30                  1
     O                                           10 'CCY1'
     O                       C1PI                21
     O                                           30 'LOC1'
     O                       L1PI                41
     O                                           64 'CCY1'
     O                       C1PR                75
     O                                           84 'LOC1'
     O                       L1PR                95
     O          D    83 30                  1
     O                                           10 'CCY2'
     O                       C2PI                21
     O                                           30 'LOC2'
     O                       L2PI                41
     O                                           64 'CCY2'
     O                       C2PR                75
     O                                           84 'LOC2'
     O                       L2PR                95
     O          D    83 30                  1
     O                                           10 'CCY3'
     O                       C3PI                21
     O                                           30 'LOC3'
     O                       L3PI                41
     O                                           64 'CCY3'
     O                       C3PR                75
     O                                           84 'LOC3'
     O                       L3PR                95
     O          D    83 30                  1
     O                                           10 'CCY4'
     O                       C4PI                21
     O                                           30 'LOC4'
     O                       L4PI                41
     O                                           64 'CCY4'
     O                       C4PR                75
     O                                           84 'LOC4'
     O                       L4PR                95
     O          D    83 30                  1
     O                                           10 'CCY5'
     O                       C5PI                21
     O                                           30 'LOC5'
     O                       L5PI                41
     O                                           64 'CCY5'
     O                       C5PR                75
     O                                           84 'LOC5'
     O                       L5PR                95
     O          D    83 30                  1
     O                                           10 'CCY6'
     O                       C6PI                21
     O                                           30 'LOC6'
     O                       L6PI                41
     O                                           64 'CCY6'
     O                       C6PR                75
     O                                           84 'LOC6'
     O                       L6PR                95
     O          D    83 30                  1
     O                                           10 'CCY7'
     O                       C7PI                21
     O                                           30 'LOC7'
     O                       L7PI                41
     O                                           64 'CCY7'
     O                       C7PR                75
     O                                           84 'LOC7'
     O                       L7PR                95
     O          D    83 30                  1
     O                                           10 'CCY8'
     O                       C8PI                21
     O                                           30 'LOC8'
     O                       L8PI                41
     O                                           64 'CCY8'
     O                       C8PR                75
     O                                           84 'LOC8'
     O                       L8PR                95
     O          D    83 30                  1
     O                                           10 'CCY9'
     O                       C9PI                21
     O                                           30 'LOC9'
     O                       L9PI                41
     O                                           64 'CCY9'
     O                       C9PR                75
     O                                           84 'LOC9'
     O                       L9PR                95
     O          D    83 30                  1
     O                                           11 'CCY10'
     O                       C0PI                21
     O                                           31 'LOC10'
     O                       L0PI                41
     O                                           65 'CCY10'
     O                       C0PR                75
     O                                           85 'LOC10'
     O                       L0PR                95
     O          D    96 30                  1
     O                                           23 'ANACREDIT DETAILS'
     O          D    96 30                  1                                                      C
     O                                           27 'COUNTERPARTY ROLE-CRE'                        C
     O                                           32 'DITOR'                                        C
     O                       ACCRC1              40                                                C
     O                       ACCRC2              47                                                C
     O                       ACCRC3              54                                                C
     O                       ACCRC4              61                                                C
     O                       ACCRC5              68                                                C
     O                                           90 'COUNTERPARTY ROLE-SER'                        C
     O                                           95 'VICER'                                        C
     O                       ACCPRS             102                                                C
     O                                          125 'COUNTERPARTY ROLE-ORIG'                       C
     O                       ACCPRO             132                                                C
     O          D    96 30                  1                                                      C
     O                                           27 'COUNTERPARTY ROLE-DEB'                        C
     O                                           30 'TOR'                                          C
     O                       ACCRD1              48                                                C
     O                       ACCRD2              69                                                C
     O                       ACCRD3              90                                                C
     O                       ACCRD4             111                                                C
     O                       ACCRD5             132                                                C
     O          D    96 30                  1                                                      C
     O                                           25 'JOINT LIABILITY AMT'                          C
     O                       ACJLA1              48 ' ,   ,   ,   , 0 .  -'                        C
     O                       ACJLA2              69 ' ,   ,   ,   , 0 .  -'                        C
     O                       ACJLA3              90 ' ,   ,   ,   , 0 .  -'                        C
     O                       ACJLA4             111 ' ,   ,   ,   , 0 .  -'                        C
     O                       ACJLA5             132 ' ,   ,   ,   , 0 .  -'                        C
     O          D    96 30                  1
     O                                           23 'INTEREST RATE CAP'
     O**********               ACINRC    56 ' 0 .       '                             CER073 CER073B
     O                       ACINRC              56 ' 0 .       -'                                 C
     O                                           76 'INTEREST RATE FLOOR'
     O**********               ACINRF   101 ' 0 .       '                             CER073 CER073B
     O                       ACINRF             101 ' 0 .       -'                                 C
     O                                          109 'PURPOSE'                                      C
     O                       ACPURP             132                                                C
     O          D    96 30                  1
     O                                           29 'FV CHANGES BEFORE PURCH'
     O                                           32 'ASE'
     O**********               ACFVCH    56 ' ,   ,   ,   , 0 .  '                    CER073 CER073C
     O                       ACFVCH              56 ' ,   ,   ,   , 0 .  -'                        C
     O                                           79 'TYPE OF SECURITISATION'
     O                       ACTYOS             101
     O                                          119 'SUBORDINATED DEBT'                            C
     O                       ACSUBD             132                                                C
     O          D    96 30                  1                                                      C
     O                                           24 'TRANSFERRED AMOUNT'
     O**********               ACTRFA    56 ' ,   ,   ,   , 0 .  '                    CER073 CER073C
     O                       ACTRFA              56 ' ,   ,   ,   , 0 .  -'                        C
     O                                           80 'DEFAULT STATUS OF THE I'                      C
     O                                           89 'NSTRUMENT'                                    C
     O                       ACDFSI             101                                                C
     O                                          119 'ACCOUNTING CLASSI'
     O                                          127 'FICATION'
     O                       ACACOI             132
     O          D    96 30                  1
     O                                           28 'ACCUMULATED WRITE-OFFS'
     O**********               ACACWO    56 ' ,   ,   ,   , 0 .  '                    CER073 CER073C
     O                       ACACWO              56 ' ,   ,   ,   , 0 .  -'                        C
     O                                           76 'DATE OF THE DEFAULT'                          C
     O                                           83 'STATUS'                                       C
     O                       DDSI               101                                                C
     O                                          124 'SOURCES OF ENCUMBRANCE'
     O                       ACSOEN             132
     O          D    96 30                  1
     O                                           27 'ACC.IMPAIRMENT AMOUNT'
     O**********               ACAIMA    56 ' ,   ,   ,   , 0 .  '                    CER073 CER073C
     O                       ACAIMA              56 ' ,   ,   ,   , 0 .  -'                        C
     O                                           79 'DATE OF THE PERFORMING'
     O                                           86 'STATUS'
     O                       ADTPS              101
     O                                          123 'IMPAIRMENT ASSESSMENT'
     O                                          130 'METHOD'
     O                       ACIAMD             132
     O          D    96 30                  1
     O                                           29 'ACC.CHANGES IN FV(CREDI'
     O                                           35 'T RISK)'
     O**********               ACACFV    56 ' ,   ,   ,   , 0 .  '                    CER073 CER073C
     O                       ACACFV              56 ' ,   ,   ,   , 0 .  -'                        C
     O                                           76 'DATE OF FORBEARANCE'
     O                                           83 'STATUS'
     O                       DTRS               101
     O                                          123 'STATUS OF FORBEARANCE'
     O                       ACSFAR             132
     O          D    96 30                  1
     O                                           29 'OFF-BALANCE SHEET PROVI'
     O                                           34 'SIONS'
     O**********               ACPASE    56 ' ,   ,   ,   , 0 .  '                    CER073 CER073C
     O                       ACPASE              56 ' ,   ,   ,   , 0 .  -'                        C
     O                                           78 'BALANCE SHEET RECOGNI'
     O                                           82 'TION'
     O                       ACBSRE             101
     O                                          120 'TYPE OF IMPAIRMENT'
     O                       ACTOIM             132
     O          D    96 30                  1
     O                                           21 'CARRYING AMOUNT'
     O**********               ACCARA    56 ' ,   ,   ,   , 0 .  '                    CER073 CER073C
     O                       ACCARA              56 ' ,   ,   ,   , 0 .  -'                        C
     O                                           68 'CONTRACT ID'
     O                       ACSCID             132
     O          D    96 30                  1                                                CER073D
     O                                           25 'EFFECTIVE INT. RATE'                    CER073D
     O                       ACEIR               56 ' ,   , 0 .        -'                    CER073D
     O          E            EHDR1          2  3
     O                                           24 'REFERENCE  LE0310P1'
     O                       TITL                89
     O                                          104 'DATE'
     O                       RUNA               112
     O                                          122 'PAGE'
     O                       PAGE          Z    128
      *                                                                                       CLE034
     O          E            EHDR2          1
     O                                           40 'LOANS AND PARTICIPATIONS'
     O                                           59 'PURCHASED AND SOLD'
     O                                           77 'MAINTENANCE TODAY'
     O                     75                    87 'BRANCH'
     O                     75WEBRCA              91
     O                     75                    92 '-'
     O                     75WEBRNM             122
      *                                                                                       CLE034
     O          E            EHDR3          1
     O                                           40 '------------------------'
     O                                           60 '--------------------'
     O                                           77 '-----------------'
      *                                                                                       CLE034
     O          E            EHDR4          1
     O                                          108 'ACTION'
     O                       WECHTP             111
     O                                          126 'BOOK CODE'
     O                       WEBOKC             130
      *                                                                                       CLE034
     O          E            EHDR5          1
     O                                           13 'CUSTOMER'
     O                       WECNM1              35
     O                                           41 'LOAN'
     O                       KLNRF               48
     O                                           59 'FAC. CUST'
     O                       WEFCUS              66
     O                                           76 'FACILITY'
     O                       WEFTYP              80
     O                                           81 '/'
     O                       WEFSEQ              83
     O                                           94 'LOAN TYPE'
     O                       WELTYP              98
     O                                          109 'SUB TYPE'
     O                       WESUTP             113
     O                       WECLAS             117
     O**********************************125 'A/C SEQ.'                                 CLE034 CLE042
     O                                          125 'A/C SEQ'
     O                       WELASQ             128
      *                                                                                       CLE034
     O          E            EHDR6          1
     O                                           13 'NO.'
     O                       WECNUM              21
     O                                           40 'CCY'
     O                       WECCY               45
     O                                           58 'AMOUNT'
     O               35      WECPAM              78 ' ,   ,   ,   , 0 -'
     O               36      WECPAM              78 '   ,   ,   , 0 . -'
     O               37      WECPAM              78 '  ,   ,   , 0 .  -'
     O               38      WECPAM              78 ' ,   ,   , 0 .   -'
     O               31                          96 'ORIGINAL BORROWER'
     O               31      WECNM2             118
     O               32                          94 'SALE OF LOAN'
     O               32      WEOLNO             104
      *                                                                                       CLE034
     O          E            EHDR7          1
     O                                           87 'RECOURSE'
     O                       WERCSI             113
     O               14                         113 'N'
      *                                                                                       CLE034
     O          E            EHDR8          2
     O                                           23 'RECEIPT SETTLEMENT'
     O                                           37 'INSTRUCTIONS:'
     O                                           71 'PAYMENT SETTLEMENT'
     O                                           85 'INSTRUCTIONS:'
      *                                                                                       CLE034
     O          E            EHDR9          1
     O                                           24 '(METHOD/CCY/ACCOUNT'
     O**********                         36 '/PERCENTAGE)'                             CLE034 CLE038
     O              N89                          36 '/PERCENTAGE)'
     O               89                          36 '/AMOUNT)    '
     O                                           72 '(METHOD/CCY/ACCOUNT'
     O**********                         84 '/PERCENTAGE)'                             CLE034 CLE038
     O              N40                          84 '/PERCENTAGE)'
     O               40                          84 '/AMOUNT)    '
     O              N89                          36 '/PERCENTAGE)'
     O               89                          36 '/AMOUNT)    '
      *                                                                                       CLE034
     O          E            EDET1          1
     O                       RMETR                9
     O                                           11 '/'
     O                       RCCYR               15
     O                                           17 '/'
     O                       RACCR               36
     O                                           38 '/'
     O                       RPERR               53
     O                       RMETP               63
     O                                           65 '/'
     O                       RCCYP               69
     O                                           71 '/'
     O                       RACCP               90
     O                                           92 '/'
     O                       RPERP              107
     O**********               RACCR     30                                            CLE034 CGL029
     O**********                         32 '/'                                        CLE034 CGL029
     O**********               RPERR     47                                            CLE034 CGL029
     O**********               RMETP     57                                            CLE034 CGL029
     O**********                         59 '/'                                        CLE034 CGL029
     O**********               RCCYP     63                                            CLE034 CGL029
     O**********                         65 '/'                                        CLE034 CGL029
     O**********               RACCP     78                                            CLE034 CGL029
     O**********                         80 '/'                                        CLE034 CGL029
     O**********               RPERP     95                                            CLE034 CGL029
      *                                                                                       CLE034
     O***********************************                          S01465 070711
     O***Output*the*new*fields*for*core*feature S01465             S01465 070711
     O***********************************                          S01465 070711
     O********D*1******67****************                          S01465 070711
     O*******OR*1******68****************                          S01465 070711
     O********************68*************14 'CUST CONF'            S01465 070711
     O********************68***SCCNM*****33                        S01465 070711
     O********************68*************47 'AUTO PAY'             S01465 070711
     O********************68***APMI******50                        S01465 070711
     O********************68*************68 'ORIG MAT DATE'        S01465 070711
     O*****************55*68***SOMDT*****76                        S01465 070711
     O********************67*************92 'RECEIVER NAME'        S01465 070711
     O********************67***SCRNM****113                        S01465 070711
     O********D*1******67****************                          S01465 070711
     O***********************************92 'TOWN'                 S01465 070711
     O*************************SCRTN****113                        S01465 070711
     O*                                                                   S01408
     O***/COPY*WNCPYSRC,LE0310OOP9***                                                  S01408 CFC006
     O/COPY WNCPYSRC,LE0310OOP9                                                             MD020563
     O*                                                                   S01408
1251 O*
1252 O********D**230   U7 U8                                              S01117
1253 O***********                        51 '*** REFERENCE LE0310'        S01117
1254 O***********                        71 'DATABASE ERROR AT'           S01117
1255 O***********              DBASE     74                               S01117
1256 O********D**      U7 U8                                              S01117
1257 O***********                        37 'FILENAME'                    S01117
1258 O***********              DBFILE    43                               S01117
1259 O***********                        48 'KEY'                         S01117
1260 O***********              DBKEY     78                               S01117
1261 O********EF* 17   73N66                                              S01117
1261 O********EF*217   73N66                                    S01117    S01117
1262 O***********                        68 '***   NO INPUT TODAY'        S01117
1263 O***********                        74 '***'                         S01117
1315 O********E**      66                                                 S01117
1316 O***********                        68 '***   END OF REPORT'         S01117
1317 O***********                        74 '***'                         S01117
     O********T**203   L1    19                                           S01117
     O********T* 202   L1    19                                                        S01117 CFC006
     O          T    L1 97 19               2 02
     O         AND     NU7 75                                                   S01117
     O*******OR*       LR    19                                                        S01117 CFC006
     O         OR    LR 97 19
     O         AND     NU7N75                                                   S01117
     O*******OR*       U7 U8                                                           S01117 CFC006
     O         OR    U7 U8 97
1058 O                                           24 'REFERENCE  LE0310P1'       S01117
1059 O                       TITL                89                             S01117
1060 O                                          104 'DATE'                      S01117
1061 O                       RUNA               112                             S01117
1062 O                                          122 'PAGE'                      S01117
1063 O                       PAGE          Z    128                             S01117
     O********T* 1     L1    19                                                        S01117 CFC006
     O          T    L1 97 19               1
     O         AND     NU7 75                                                   S01117
     O*******OR*       LR    19                                                        S01117 CFC006
     O         OR    LR 97 19
     O         AND     NU7N75                                                   S01117
     O*******OR*       U7 U8                                                           S01117 CFC006
     O         OR    U7 U8 97
     O                                           40 'LOANS AND PARTICIPATIONS'  S01117
     O                                           59 'PURCHASED AND SOLD'        S01117
     O                                           77 'MAINTENANCE TODAY'         S01117
     O                     75                    87 'BRANCH'                    S01117
     O                     75BRCA                91                             S01117
     O                     75                    92 '-'                         S01117
     O                     75BRNM               122                             S01117
1069 O********T* 1     L1    19                                                        S01117 CFC006
     O          T    L1 97 19               1
     O         AND     NU7 75                                                   S01117
     O*******OR*       LR    19                                                        S01117 CFC006
     O         OR    LR 97 19
     O         AND     NU7N75                                                   S01117
     O*******OR*       U7 U8                                                           S01117 CFC006
     O         OR    U7 U8 97
     O                                           40 '------------------------'  S01117
     O                                           60 '--------------------'      S01117
     O                                           77 '-----------------'         S01117
1261 O********T*3      L1    19                                                        S01117 CFC006
     O          T    L1 97 19            3
     O         AND     NU7 75                                                   S01117
     O*******OR*       LR    19                                                        S01117 CFC006
     O         OR    LR 97 19
     O         AND     NU7N75                                                   S01117
     O                                           76 '*** NO DETAILS TO REPORT'  S01117
     O                                           80 '***'                       S01117
1252 O********T* 230   U7 U8                                                           S01117 CFC006
     O          T    U7 U8 97               2 30
1253 O                                           51 '*** REFERENCE LE0310'      S01117
1254 O                                           72 'DATABASE ERROR ***'        S01117
     O********T 3      L1 75NU7                                    S01117 S01518
     O          T    L1 75NU7            1                                      S01518
     O*******AND       80                                                              S01518 CFC006
     O         AND   80 97
     O         OR    L1 75NU7            3                                      S01518
     O*******AND      N80                                                              S01518 CFC006
     O         AND  N80 97
     O                                           66 '*** END OF REPORT FOR'     S01117
     O                                           74 ' BRANCH '                  S01117
     O                       BRCA                77                             S01117
     O                                           81 ' ***'                      S01117
     O********T 3      LRN75NU7                                    S01117 S01518
     O          T    LRN75NU7            1                                      S01518
     O*******AND       80                                                              S01518 CFC006
     O         AND   80 97
     O         OR    LRN75NU7            3                                      S01518
     O*******AND      N80                                                              S01518 CFC006
     O         AND  N80 97
     O                                           76 '*** END OF REPORT ***'     S01117
1318 O*
     O***/COPY*WNCPYSRC,LEH01020***                                                           CFC006
     O/COPY WNCPYSRC,LEH01020                                                               MD020563
     OLE0310AU  E    66                     2 03                                S01117
     O                                           24 'REFERENCE  LE0310AU'       S01117
     O                       TITL                89                             S01117
     O                                          104 'DATE'                      S01117
     O                       RUNA               112                             S01117
     O                                          122 'PAGE'                      S01117
     O                       PAGE1         Z    128                             S01117
     O          E    66                     1                                   S01117
     O                                           40 'LOANS AND PARTICIPATIONS'  S01117
     O                                           59 'PURCHASED AND SOLD'        S01117
     O                                           77 'MAINTENANCE TODAY'         S01117
     O                                           93 'RUN CONTROLS'              S01117
     O          E    66                     1                                   S01117
     O                                           40 '------------------------'  S01117
     O                                           60 '--------------------'      S01117
     O                                           77 '-----------------'         S01117
     O          E    66                     2 17                                S01117
1265 O                                           18 'RUN CONTROLS'
1266 O                                           72 '------------ REPORT'
1267 O                                           84 '-----------'
1268 O                                          115 '--------- FILE CONTROL'
1269 O                                          124 '--------'
1270 O          E    66                     2
1271 O                                           59 'NUMBER'
1272 O                                           84 'VALUE'
1273 O                                           99 'NUMBER'
1274 O                                          124 'VALUE'
1275 O          E    66                     2
1276 O                                           29 'LOANS & PARTS. LISTED'
1277 O                                           44 'IN THIS REPORT'
1278 O                       NLON          3     59
1279 O          E    66                     2
1280 O                                           28 'RECORDS BEFORE INPUT'
1281 O                                           34 'CYCLE'
1282 O                       NLRB          3     99
1283 O                       VLBF          Z    121
1284 O                       VLBL               124
1285 O          E    66                     2
1286 O                                           24 'RECORDS INSERTED'
1287 O                       NRINS         3     59
1288 O                       INTOTI        Z     81
1289 O                       INTOTD              84
1290 O                       NINS          3     99
1291 O                       VRIF          Z    121
1292 O                       VRIL               124
1293 O              N41NU7                      128 '***'
1294 O          E    66                     2
1295 O                                           23 'RECORDS DELETED'
1296 O                       NRDEL         3     59
1297 O                       DETOTI        Z     81
1298 O                       DETOTD              84
1299 O                       NDEL          3     99
1300 O                       VRDF          Z    121
1301 O                       VRDL               124
1302 O              N42NU7                      128 '***'
1303 O          E    66                     3
1304 O                                           27 'RECORDS AFTER INPUT'
1305 O                                           33 'CYCLE'
1306 O                       NROF          3     59
1307 O                       LVTOTI        Z     81
1308 O                       LVTOTD              84
1309 O                       NLRA          3     99
1310 O                       VLAF          Z    121
1311 O                       VLAL               124
1312 O              N43NU7                      128 '***'
1313 O********E**3     66 U8NU7                                                               236008
     O          E    66 90NU7               3
1314 O                                          128 '***   DIFFERENCE   ***'
1252 O          E    U7 U8 66            3  2                                   S01117
1253 O                                           51 '*** REFERENCE LE0310'      S01117
1254 O                                           71 'DATABASE ERROR AT'         S01117
1255 O                       DBASE               75                             S01117
1256 O          E    U7 U8 66                                                   S01117
1257 O                                           39 'FILENAME'                  S01117
1258 O                       DBFILE              48                             S01117
1259 O                                           52 'KEY'                       SW1117
1260 O                       DBKEY               82                             S01117
     O          E   NU7NU8 66            2  3                                   S01117
     O         AND  N78                                                         S01117
     O                                           76 '*** NO DETAILS TO REPORT'  S01117
     O                                           80 '***'                       S01117
1319 O*
1320 OCLONT     T    LRNU8N34
1321 O                       NLRB                25P
1322 O                       NINS                28P
1323 O                       NDEL                31P
1324 O                       VLBF                42P
1325 O                       VLBL                44P
1326 O                       VRIF                52P
1327 O                       VRIL                54P
1328 O                       VRDF                62P
1329 O                       VRDL                64P
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
** CPY@   **      OBJECT COPYRIGHT
(c) Finastra International Limited 2001
**   SVAL  -  SYSTEM VALUES ARRAY                                                             CLE038
Settlement09Postings                                                                          CLE038
