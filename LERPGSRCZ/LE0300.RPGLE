     H DEBUG
      *****************************************************************
/*S*D****RPGBASE*******************************************************                      CER073D
/*STD *  RPGBASEBND                                                   *                      CER073D
/*EXI *  ALWNULL(*USRCTL)                                             *                      CER073D
/*EXI *  TEXT('Midas LE Facilities Maintenance Today Report')         *
     F*****************************************************************
     F*                                                               *
     F*  Midas - Customer Lending Module                              *
     F*                                                               *
     F*  LE0300 - FACILITIES INPUT TODAY PRINT                        *
     F*                                                               *
     F*  Function - Checks FCLTY1 for LCD equal to rundate. If so,    *
     F*             outputs the following :                           *
     F*             a) If facility amount changed, output new amount  *
     F*                and previous amount from facility history file.*
     F*                Will show RVCD date if *NE 0 (date RVCD chgd). *
     F*             b) If amount not changed, but RVCD changed today, *
     F*                only one amount shown, and date revolving CR   *
     F*                indicator changed.                             *
     F*             c) If RVCD *GT 0 and LCD equals RUND, date of last*
     F*                change shown when amount changes.              *
     F*                                                               *
     F*  Called by - CLP/LEC0601A                                     *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CER073D            Date 28Nov19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD020563           Date 21May13               *
      *                 AR1097176          Date 22Mar13               *
      *                 CFC006             Date 06Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR787620           Date 10Jun11               *
      *                 AR750770           Date 28Apr11               *
      *                 AR744372           Date 15Apr11               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 248525             Date 15Jun07               *
      *                 246031A            Date 24Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 246031             Date 28Feb07               *
      *                 236008             Date 03Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12715           Date 27Nov06               *
      *                 242371             Date 20Sep06               *
      *                 242053             Date 20Sep06               *
      *                 242326             Date 16Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027A            Date 10May06               *
      *                 BUG11201           Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10505           Date 10Feb06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG10267           Date 01Feb06               *
      *                 CER001             Date 25Apr05               *
      *                 BUG8943            Date 12Oct05               *
      *                 CLE106             Date 22Feb05               *
      *                 CSW037A            Date 02May05               *
      *                 CLE041             Date 11Oct04               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4166            Date 06Sep04               *
      *                 BUG3781            Date 23Jul04               *
      *                 CFX001             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 CLE024             Date 20Oct03               *
      *                 CLE039             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE029             Date 24Sep02               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 03Feb03               *
      *                 CLE028             Date 27Jun02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 201127             Date 20Jan03               *
      *                 196066             Date 10Jan03               *
      *                 208458             Date 27Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CLE015             Date 13Dec01               *
      *                 193603             Date 31Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 189544             Date 01May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 187663             Date 17Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 171784             Date 01Aug00               *                       S01392
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CLE008             Date 10Dec98               *
      *                 147261             Date 27Jan99               *
      *                 147935             Date 17Dec98               *
      *                 149036             Date 07Dec98               *
      *                 141486             Date 18Feb99               *
      *                 149037             Date 15Feb99               *
      *                 140832             Date 15Feb99               *
      *                 138352             Date 11Feb99               *
      *                 136106             Date 11Feb99               *
      *                 135745 (BT0779)    Date 11Feb99               *
     F*                 CLE005             Date 22May97               *
     F*                 CLE007             Date 22May97               *
     F*                 122653             Date 05Sep97               *
     F*                 CLE006             Date 02Dec96               *
     F*                 CLE004             Date 02Dec96               *
     F*                 S01408             DATE 06SEP96               *                      *S01392
     F*                 S01408             DATE 05SEP95               *                      *S01392
     F*                 S01408             DATE 25MAY95               *
     F*                 S01408             DATE 13DEC94               *
     F*                 072062             DATE 07OCT94               *
     F*                 059790             DATE 05APR94               *
     F*                 058449             DATE 09MAR94               *
     F*                 060978             DATE 23NOV93               *
     F*                 S01392             DATE 30SEP92               *
     F*                 MOF60              DATE 21FEB92               *
     F*                 BHF064             DATE 17MAY90               *
     F*                 S01194             DATE 02JAN90               *
     F*                 S01117             DATE 21/06/89              *
     F*                                                               *
     F*---------------------------------------------------------------*
      *                                                               *
      *  CER073D - Upgrade of EML014 to FB2.1 SP21                    *
      *      EML014 - AnaCredit Reporting Enhancement                 *
      *  MD046248 - Finastra Rebranding                               *
      *  MD020563 - CFC006 issues                                     *
      *  AR1097176 - Accessing AOCOMR0 multiple times slows down the  *
      *              system                                           *
      *  CFC006 - COB Restructure - Remove reports from COB           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00126                                 *
      *             WNCPYSRC,LEH00090                                 *
      *             WNCPYSRC,LEH00127                                 *
      *             WNCPYSRC,LEH00128                                 *
      *             WNCPYSRC,LEH00091                                 *
      *             WNCPYSRC,LEH00129                                 *
      *             WNCPYSRC,LEH00125                                 *
      *             WNCPYSRC,LEH00094                                 *
      *             WNCPYSRC,LEH00092                                 *
      *             WNCPYSRC,LEH00130                                 *
      *             WNCPYSRC,LEH00095                                 *
      *             WNCPYSRC,LEH00093                                 *
      *             WNCPYSRC,LEH00131                                 *
      *             WNCPYSRC,LEH00096                                 *
      *  AR750770 - New Frequencies on Rollover Types field not dis-  *
      *             played in Facilities Input Today (Child: AR750771)*
      *  AR744372 - The report program attempted WRITE operation to   *
      *             a closed printer file LE0300P1 (Child: AR744373)  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *  248525 - Dump in LE000020 when Parent Group is 0.            *
      *  246031A- Closing date should be displayed instead of date    *
      *           committed.                                          *
      *  246031 - Print approval date whether facility is tranche     *
      *           or not.                                             *
      *  236008 - When trailer does not match, do not halt COB.       *
      *           Show audit report for information purposes only.    *
      *  BUG12715 - LE0300P2740579-Error in some data in Syndicated   *
      *             Facilities Maintenance Today report               *
      *  242371 - Print 'ALL' instead of 'NONE' for eligible          *
      *           customers of a multi-customer facility.             *
      *  242053 - Apply GEMS 218552.                                  *
      *  242326 - The report program attempted WRITE operation to     *
      *           a closed printer file LE0300P1.                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  BUG11201 - Tried to write to a close file in LE0300          *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10505-Tried to write to a close file in LE0300            *
      *  CLE042 - Extended Loan Sub Type                              *
      *  BUG10267-No extension field due to SynMan Merger.            *
      *           Indicator 60 should not be use for both             *
      *           CLE106(SYNMAN) and CER001(LUX)                      *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *           IML Circular 97/138                                 *
      *           Internalize IML/IBLC                                *
      *  BUG8943 - Print Base Rate when CLE035 is switched on.        *
      *  CLE106 - Syndication Manager                                 *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4166 - Incorrect format of Penalty field in LE0300P1      *
      *            report if penalty type is defined as 'P'.          *
      *            Applied fix 224715.                                *
      *  BUG3781 - Incorrect customer is being shown in the facility  *
      *            customer.                                          *
      *  CFX001 - FX Margin Trading                                   *
      *  CLE025 - Credit Lines                                        *
      *  CLE024 - Collateralised Lending                              *
      *  CLE039 - General LE Enhancement                              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE029 - Severity Codes.                                     *
      *           Under the core switchable feature CLE029            *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *  CLE031 - Lending Enhancements.                               *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *  201127 - Reports should show Start Date instead of Approved  *
      *           Date. LE0300P1 changed in O-specs, & corresponding  *
      *           changes were also made in the printer file LE0300P2.*
      *  196066 - Insert/Amend/Authorise user blank when CLE002 is    *
      *           off. Fix is to only display the fields when CLE002  *
      *           (Authorisation) feature is switched on.             *
      *  208458 - Unable to display some fields in LE0300P1 correctly *
      *  CLE015 - Functionality moved from Syndicated Lending to      *
      *           Customer Lending                                    *
      *  193603 - Hash total must take account of negative FAMT       *
     F*  189544 - Amended CR/AG customer to be displayed when CLE005  *
     F*           is switched on.  Also included, date approved, CR/AG*
     F*           exch rate and indicator                             *
      *  187663 - Do not print LE0300P2 if Syndicated Lending         *
      *           Enhancement CLE006 is switched off.                 *
      *  171784 - Report shows negative facility amounts as positive. *
     F*           Add negative sign to edit word of facility amounts. *
      *  CLE008 - Loan administration I.D. Amendments                 *
      *  147261 - Add Assignment or Participation indicator           *
      *  147935 - Addition of insert, authorise and amend user        *
      *           profiles to lending reports                         *
      *  149036 - Recompiled due to changes in LF/FCLTY1              *
      *  141486 - LE0300P1 does not have info of CA's and TR's        *
      *  149037 - LE0300P2 needs clean up.                            *
     F*  140832 - All Participant details not shown on report.        *
      *  138352 - LE0300-facility listed in synd(P2) and regular (P1) *
      *           report                                              *
     F*  136106 - LE0300P2 Printer Problems                           *
     F*  135745 - D/B error in German Returns SAR - change to         *
     F*           WNCPYSRC LE0300CN01 needed to exclude (BT0779)      *
     F*           participant and internal facilities                 *
     F*  CLE005 - Customer Lending Enhancements - Tranche 3           *
     F*  CLE007 - Customer Lending Enhancements - Others              *
     F*  122653 - Recompiled over amended LE0300P2                    *
     F*  CLE006 - Customer Lending Enhancements - Rollovers           *
     F*  CLE004 - Customer Lending Enhancements - Syndications        *
     F*  S01408 - Addition of core hooks LE0300CCP3                   *
     F*  S01408 - Addition of core hooks LE0300CCP1                   *
     F*                                  LE0300CCP2                   *
     F*  S01408 - Addition of core hooks LE0300OOP1                   *
     F*                                  LE0300CCPG                   *
     F*  S01408 - Addition of core hooks LE0300FFPG                   *
     F*                                  LE0300IIPG                   *
     F*                                  LE0300CEIP                   *
     F*                                  LE0300CPDR                   *
     F*                                  LE0300OOPG                   *
     F*  072062 - Report Bill/Telex ind. and Billing days             *
     F*  059790 - Customer may be deleted on same day as facility     *
     F*  058449 - Report incorrectly shows that revolving credit      *
     F*           indicator changed. To fix, initialize ind to zero.  *
     F*  060978 - Previous Facility Amount printed incorrect.         *
     F*  S01392 - JAPANESE SUB MODULE ENHANCEMENTS                    *
     F*  MOF60  - CUSTOMER PROFITABILITY & FEES PROCESSING            *
     F*           REMOVAL OF COMMITMENT FEE DETAILS & INCLUSION       *
     F*           OF PREVIOUS FACILITY AMNT & REVOLVING CREDIT        *
     F*           INDICATOR ON PRINT FILE                             *
     F*  BHF064 - SHOULD PRINT OUT CUSTOMER NUMBER                    *
     F*  S01194 - STANDING DATA CHANGES.                              *
     F*  S01117 - MULTIBRANCHING                                      *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     F*  C R E A T I O N     P A R A M E T E R S                      *
     F*                                                               *
     F*                                                               *
     F*****************************************************************
     F*CLTY***UP* F     256 12AI     2 DISK                                                   S01117
     FFCLTY1    IP   E           K DISK                                                       S01117
     FLEAGFYJ0  IS   E           K DISK    EXTIND(*INU1)                                      CLE041
     FFCLTYZZ   US   F  256        DISK                                                       S01117
     FLEAGFZPD  UF   E             DISK                                                       CLE041
     F                                     RENAME(FCLTYZZF:AGFCTYZF)                          CLE041
     FHISUPD    IF   E           K DISK                                                        MOF60
     F************FACHISAF                          KIGNORE                             MOF60 060978
     F                                     IGNORE(HISACTF)                                    060978
     FLEAGHSL0  IF   E           K DISK                                                       CLE041
     F*CLINT***IF  F     256  7AI     2 DISK                                                  S01194
     F*TABLE***IF  F      96 12AI     2 DISK                                                  S01194
      *                                                                                       CLE004
     FLEPARTL3  IF   E           K DISK                                                       CLE004
      ** Participant Details                                                                  CLE004
      *                                                                                       CLE004
     FLEFCLTLG  IF   E           K DISK                                                       CLE039
      ** LE Facility Extension Detail File                                                    CLE039
      *                                                                                       CLE039
     FLEAGFYL4  IF   E           K DISK                                                       CLE041
     F                                     RENAME(LEFCLTD0:AGFCTYD0)                          CLE041
      ** LE Aggregate Facility Extension Detail File                                          CLE041
      *                                                                                       CLE041
     FFCANACI1  IF   E           K DISK                                                      CER073D
      ** Midas LE Loans AnaCredit reporting details                                          CER073D
      *                                                                                      CER073D
     F*E0300P1O   F     132     OF     PRINTER                                         S01124 S01117
     FLE0300P1  O    F  132        PRINTER INFDS(SPOOL)                                       S01117
     F                                     OFLIND(*INOF)
     F                                     USROPN
     FLE0300P3  O    F  132        PRINTER INFDS(SPOOL3)                                      CLE041
     F                                     OFLIND(*INOG)
     F                                     USROPN
     FLE0300AU  O    F  132        PRINTER INFDS(SPOOLU)                                      S01117
     F                                     OFLIND(*INOA)
      *                                                                                       CLE004
     F***LE0300P2O   E                    PRINTER      KINFDS SPOOL2     UC            CLE004 CLE039
     FLE0300P2  O    E             PRINTER INFDS(SPOOL2)                                      CLE039
     F                                     OFLIND(*IN55)
     F                                     USROPN
      ** Syndicated Facilities printer file                                                   CLE004
     F*                                                                                       S01408
     F/COPY WNCPYSRC,LE0300FFPG                                                               S01408
     F*                                                                                       S01408
     FLEFCX2L0  UF A E           K DISK                                                       CER001
      ** ER Facilities details - LUX Extension File                                           CER001
     F*****************************************************************                        MOF60
     F*
     F* ID F  C  H  L    FUNCTION OF INDICATORS
     F**01************FCLTY*-FILE*HEADER****                                                  S01117
     F* 02                  -DETAIL RECORD 'A', LIVE
     F* 03                  -  "      "     "   REVERSED/CLOSED
     F* 04                  -  "      "     "   EXPIRED
     F* 05                  -  "      "    'B', LIVE
     F* 06                  -  "      "     "   REVERSED/CLOSED
     F* 07                  -  "      "     "   EXPIRED
     F* 08                  - TRAILER
     F**09******      CLIENT FILE- CUSTOMER STANDING DATA RECORD                              S01194
     F**10******      TABLE FILE - INST. CONTROL DATA REC.1                                   S01194
     F**11******        "    "   - CURRENCIES RECORD 1                                        S01194
      *       11      Difference in trailer file values.                                      236008
     F*
     F*       12      WORK INDICATOR, LIVE RECORDS
     F*       13      CLE034 is installed                                                     CLE034
     F*       15      SHOW CCY ROLLOVER DETAILS                                               CLE015
     F*       16      CLE039 is installed                                                     CLE039
     F*       17      CLE024 is installed                                                     CLE024
     F*       18      CFX001 or CLE025 is installed                                           CFX001
     F*       19      CLE106 installed & Risk Participant                                     CLE106
     F*
     F*       20      FIRST CYCLE INDICATOR
     F*       22      ACTIONED TODAY
     F*       24      INSERTED RECORD
     F*       25      AMENDED RECORD
     F*       26      REVERSED OR CLOSED RECORD
     F*       27      WORK INDICATOR- RECORDS IN CORRECT SEQUENCE
     F********28*      "       "     - FAC/CMMT IND = C                                        MOF60
     F********29*     CMMT FEE DETAILS TO BE BLANK ON REPORT                                   MOF60
     F*       28      CLE005 is ON                                                            CLE005
     F*       29      CLE007 is ON                                                            CLE007
     F*       30      OUTPUT INDICATOR
     F*       31      FILE CONTROLS BALANCE
     F*       33      MULTIBRANCHING INDICATOR = NO                                           S01117
     F*       34      NO INPUT TODAY
     F*       35      0 DECIMAL PLACES
     F*       36      1 DECIMAL PLACES
     F*       37      2 DECIMAL PLACES
     F*       38      3 DECIMAL PLACES
     F*       39      CLE002 is ON                                                            196066
     F********40*     CHAIN TO CLIENT FILE FAILED                                             S01194
     F********41*     CHAIN TO TABLE FILE FAILED                                              S01194
     F*       43      Print 'ELIGIBLE CUSTOMERS:' in LE0300P1 / Overflow indicator            CLE039
     F*       44      Print column 2 eligible customer details in LE0300P1                    CLE039
     F*       45      Print eligible customers for facility                                   CLE039
     F*       47      Print Customer Group                                                    CLE039
     F*       46      Chain to LEPARTL3                                                       CLE004
     F*       48      Print Multi-currency rollover details                                   CLE004
     F*       49      Participant Loan                                                        CLE004
     F*       50      DATE TO BE PRINTED ON REPORT
     F*       51        "          "         "
     F*       52        "          "         "
     F*       53        "          "         "
     F*       54      Print 'ELIGIBLE CUSTOMERS:' in LE0300P2                                 CLE039
     F*       55      Overflow indicator for LE0300P2                                         CLE039
     F*       56      Print column 2 eligible customer details in LE0300P2                    CLE039
     F*       57      End of file indicator for LEFCLTLG                                      CLE024
     F********54******  "          "         "                                                 MOF60
     F********55******  "          "         "                                                 MOF60
     F********56******  "          "         "                                                 MOF60
     F********57******BILLING DAYS "         "                                                 MOF60
     F*       58      REVIEW DAYNO "         "
     F********59******BASE RATE    "         "                                                 MOF60
     F********60******BILL DAYNO   "         "                                                 MOF60
     F*       59      CLE106 installed & Internal Participant                                 CLE106
     F*       60      CLE106 installed & Sub Participant                                      CLE106
     F*       61      CLE008 IS ON-indicator for loan admin i.d                               CLE008
     F*       62      ULX004 installed                                                      BUG10267
     F*       65      EDIT INDICATOR FOR FILE CONTROLS
     F*       66      EXCEPTION OUTPUT - FILE CONTROLS
     F********67**********"*******"****-*"NO*INPUT*TODAY"****                                 S01117
     F*       67      FILE CONTROLS HAS ALREADY BEEN PRINTED                                  S01117
     F*       70      Database Error                                                          CLE004
     F********71******CHAIN FAIL                                                        S01117 MOF60
     F*       71      End of Report for Branch line for LE0300P2                              CLE004
     F*       72      COUNT FOR 'A' FCLTY REC IF OFF, 'B' IF ON                               S01117
     F*       74      SOME DETAILS REPORT ON ANY P1 SPOOL                                     S01117
     F*       75      SOME DETAILS REPORT ON CURRENT P1 SPOOL                                 S01117
     F*       76      ORIGINATING BRANCH NOT USED                                             S01117
     F*       77      PROFIT CENTRE NOT USED                                                  S01117
     F*       78      OUTPUT PREVIOUS FCLTY AMT FROM HISTORY FILE                              MOF60
     F*       79      REVOLVING CREDIT INDICATOR HAS CHANGED                                   MOF60
     F*       81      Output Date Committed                                                   CLE004
     F*       82      Output Closing Date                                                     CLE004
     F*       83      Output Last Availability Date                                           CLE004
     F*       84      Output Joining Date                                                     CLE004
     F*       85      Risk Participant                                                        140832
     F*       88      RECORD NOT FOUND ON HISTORY FILE                                         MOF60
     F*
     F********98******USED IN ZSYSTM - DATE FORMAT MMDDYY                                      MOF60
     F*       98      SYSTEM DATE FORMAT                                                       MOF60
     F*       99      USED IN SUBROUTINES
     F*          U7+U8DATABASE ERROR
     F*          U8   FILE CONTROLS OUT OF BALANCE
     F*          L1   LEVEL BREAK ON BRCA                                                     S01117
     F*
     F*****************************************************************                        MOF60
     F/SPACE 3                                                                                 MOF60
     F*****************************************************************                        MOF60
     F*                                                                                        MOF60
     F*  S U B R O U T I N E   I N D E X                                                       MOF60
     F*                                                                                        MOF60
     F*  DETA   - Detail 'A' Record Processing                                                 MOF60
     F*  DETB   - Detail 'B' Record Processing                                                 MOF60
     F*  COUNT  - Subroutine to Count Records Input (A & B)                                    MOF60
     F*  GLZADD - Subroutine to add an amount (ZZAMT) to the total                             MOF60
     F*           (ZZTOTI, ZZTOTD)                                                             MOF60
     F*  GLZSUM - Subroutine to Carry Out the Addition for Subroutines                         MOF60
     F*           GLZADD, GLZSUB, GLZCMP                                                       MOF60
     F*  ZDATE2 - To Convert a Day Number to Date Formats                                      MOF60
     F*  TRLR   - Trailer Processing                                                           MOF60
     F*  UPDATE - If Controls Balance, Update Trailer Record                                   MOF60
     F*  *PSSR  - Subroutine to Handle Abnormal Error Conditions                               MOF60
     F*                                                                                        MOF60
     F*****************************************************************                        MOF60
     F/EJECT                                                                                   MOF60
     D ARELIG          S              6    DIM(133)                                           CLE039
      ** Array to contain the Eligible Customers                                              CLE039
      *                                                                                       CLE039
     D ACG             S              1    DIM(20)                                            CLE039
      ** Array to contain the Customer Group (per character)                                  CLE039
      *                                                                                       CLE039
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)                             MOF60
     D/COPY ZSRSRC,ZDATE2Z1LE                                                                CER073D
     D/COPY ZSRSRC,ZEDITZ1LE                                                                 CER073D
     D*
     D****CLIENT*FILE*-*CUSTOMER*STANDING*DATA*RECORD                                         S01194
     D*
     D*CLINT***NS  09   1 CD   8 CA                                                           S01194
     D**********                              1   1 RECI                                      S01194
     D**********                              2   70CNUM                                      S01194
     D**********                              8   8 RCDT                                      S01194
     D**********                              9  28 CRNM                                      S01194
     D**********                             29  38 CTWN                                      S01194
     D**********                             39  48 CSNM                                      S01194
     D**********                             49  56 CASK                                      S01194
     D**********                             57  68 TELX                                      S01194
     D**********                             69  80 CSID                                      S01194
     D**********                             81  82 ACOC                                      S01194
     D**********                             83  83 CBSI                                      S01194
     D**********                             84  85 CCTZ                                      S01194
     D**********                             86  87 CLOC                                      S01194
     D**********                             88  930CPAR                                      S01194
     D**********                             97  980LINS                                      S01194
     D**********                             99 1010LIND                                      S01194
     D**********                          P 102 1040DASU                                      S01194
     D**********                          P 105 1070CDIC                                      S01194
     D**********                          P 108 1100DADE                                      S01194
     D**********                            111 111 CMIN                                      S01194
     D**********                            112 112 CTYP                                      S01194
     D**********                            113 124 TELF                                      S01194
     D**********                            125 133 CHID                                      S01194
     D**********                            134 136 CHAB                                      S01194
     D**********                          P 250 2520LCD                                       S01194
     D**********                            253 253 CHTP                                      S01194
     D**********                          P 254 2560TNLU                                      S01194
     D*
     D*****CLIENT*FILE*-*CATCHALL                                                             S01194
     D*
     D********NS       1NCD                                                                   S01194
     D**********                              1   1 RECI                                      S01194
     D*
     D*****TABLE*FILE*-*INSTALLATION*CONTROL*DATA*RECORD*1.                                   S01194
     D*
     D*TABLE***NS  10   2 C0   3 C1  12 C1                                                    S01194
     D*******AND      13 C0                                                                   S01194
     D**********                              1   1 RECI                                      S01194
     D**********                              2   30RECT                                      S01194
     D**********                             12  130RCDE                                      S01194
     D**********                             14  66 TITL                                      S01194
     D**********                             67  67 DATF                                      S01194
     D***********                            68  700DFBR                                      S01194
     D**********                             74  74 MODI1                                     S01194
     D**********                             75  75 MODI2                                     S01194
     D**********                             76  76 MODI3                                     S01194
     D**********                          P  77  790RUND                                      S01194
     D**********                             80  86 RUNA                                      S01194
     D**********                             87  870SFLG                                      S01194
     D**********                          P  90  920LCD                                       S01194
     D**********                             93  93 CHTP                                      S01194
     D**********                          P  94  960TNLU                                      S01194
     D*
     D*
     D*****TABLE*FILE*-*CURRENCIES*RECORD*1.                                                  S01194
     D*
     D*TABLE***NS  11   1 CD   2 C2   3 C0                                                    S01194
     D*******AND      13 C1                                                                   S01194
     D**********                              1   1 RECI                                      S01194
     D**********                              2   30RECT                                      S01194
     D**********                             10  12 CCY                                       S01194
     D**********                             13  130SREC                                      S01194
     D**********                             14  27 CCNM                                      S01194
     D**********                          P  28  348SPOT                                      S01194
     D**********                             35  37 CCYS                                      S01194
     D**********                             38  380CDP                                       S01194
     D**********                             39  390TNOT                                      S01194
     D**********                             40  40 DCCY                                      S01194
     D**********                             41  44 SRC1                                      S01194
     D**********                             45  48 SRC2                                      S01194
     D**********                             49  520TACC                                      S01194
     D**********                             53  560TEQV                                      S01194
     D**********                             57  600SWQV                                      S01194
     D**********                             61  640TAC4                                      S01194
     D**********                             65  680TAC5                                      S01194
     D**********                             69  69 HIND                                      S01194
     D**********                          P  70  768PART                                      S01194
     D**********                             77  780SSNO                                      S01194
     D**********                          P  79  858ERLC                                      S01194
     D**********                             86  860MDIN                                      S01194
     D**********                             87  870MDIA                                      S01194
     D**********                             88  880MDIB                                      S01194
     D**********                             93  93 CHTP                                      S01194
     D**********                          P  94  960TNLU                                      S01194
     D*
     D*****TABLE*FILE*-*CATCH-ALL                                                             S01194
     D*
     D********NS       1NCD                                                                   S01194
     D**********                              1   1 RECI                                      S01194
     D**********                                                                               MOF60
     D*****LOCAL DATA AREA FOR DATABASE ERROR REFERENCES                                       MOF60
     D**********                                                                               MOF60
     D*LDA********UDS                            256                                           MOF60
     D***********                           134 138 DBFILE                                    S01117
     D***********                           139 167 DBKEY                                     S01117
     D***********                           168 175 DBPGM                                     S01117
     D***********                           176 177 DBASE                                     S01117
     D***********                           134 141 DBFILE                              S01117 MOF60
     D***********                           142 170 DBKEY                               S01117 MOF60
     D***********                           171 180 DBPGM                               S01117 MOF60
     D***********                           181 1830DBASE                               S01117 MOF60
     D**                                                                                      S01117
     D SPOOL           DS                                                                     S01117
     D**   FILE INFORMATION DATA STRUCTURE                                                    S01117
     D**                                                                                      S01117
     D  SFILE                 83     92                                                       S01117
     D  SFNUM                123    124B 0                                                    S01117
     D**                                                                                      S01117
     D SPOOL2          DS                                                                     CLE004
      ** File information data structure for LE0300P2                                         CLE004
      *                                                                                       CLE004
     D  OPEN2                  9      9                                                       CLE004
     D  SFILE2                83     92                                                       CLE004
     D  SFNUM2               123    124B 0                                                    CLE004
     D  OFLLN2               188    189B 0                                                    140832
     D  PRTLN2               367    368B 0                                                    140832
      *                                                                                       CLE041
     D SPOOL3          DS                                                                     CLE041
      ** File Information Data Structure                                                      CLE041
      *                                                                                       CLE041
     D  SFILE3                83     92                                                       CLE041
     D  SFNUM3               123    124B 0                                                    CLE041
      *                                                                                       CLE041
     D SPOOLU          DS                                                                     S01117
     D**   FILE INFORMATION DATA STRUCTURE                                                    S01117
     D**                                                                                      S01117
     D  SFILEU                83     92                                                       S01117
     D  SFNUMU               123    124B 0                                                    S01117
     D**                                                                                      S01117
     D**********  DS                                                                    S01117 MOF60
     D**********                              1  12 DSA1                                S01117 MOF60
     D**********                              1   1 RECIA                               S01117 MOF60
     D**********                              2   70CNUMA                               S01117 MOF60
     D**********                              8  100FACTA                               S01117 MOF60
     D**********                             11  120FCNOA                               S01117 MOF60
     D**********                                                                        S01117 MOF60
     D**********  DS                                                                    S01117 MOF60
     D**********                              1  12 DSB1                                S01117 MOF60
     D**********                              1   1 RECIB                               S01117 MOF60
     D**********                              2   70CNUMB                               S01117 MOF60
     D**********                              8  100FACTB                               S01117 MOF60
     D**********                             11  120FCNOB                               S01117 MOF60
      *                                                                                       S01117
     D                 DS                                                                      MOF60
     D  FCLTY                  1      5  0                                                     MOF60
     D  HFACT                  1      3  0                                                     MOF60
     D  HFCNO                  4      5  0                                                     MOF60
     D PSDS           SDS                                                                      MOF60
     D** PROGRAM STATUS DATA STRUCTURE - REQUIRED FOR DUMP                                     MOF60
     D  JOB                  244    253                                                        MOF60
     D  USER                 254    263                                                        MOF60
      *                                                                                       CLE004
      ** Format amount returned by standard subroutine                                        CLE004
     D  ZOUT22                 1     22                                                       CLE004
     D  ZOUT18                 4     21                                                       CLE004
     D  ZOUT17                 4     20                                                       CLE004
     D  ZNEG                  21     21                                                       CLE004
     D*/COPY*ZSRSRC,ZFRPEDZ2*********                                                 CLE004 CER073D
      *                                                                                      CER073D
     D ANACDS        E DS                  EXTNAME(FCANACQD)                                 CER073D
      ** ** Midas LE Loans AnaCredit Reporint details DS                                     CER073D
      *                                                                                      CER073D
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                 CER073D
     D  QQACCT       E                     EXTFLD(QQACCD)                                    CER073D
      ** ** Midas LE Loans AnaCredit Reporint details DS                                     CER073D
      **                                                                                       MOF60
     D RUNDT         E DS                  EXTNAME(RUNDAT)                                     MOF60
      **  DATA AREA RUNDAT                                                                     MOF60
     D  RUNA         E                     EXTFLD(AGMRDT)                                      MOF60
     D  RUND         E                     EXTFLD(AGRDNB)                                      MOF60
     D  SSF          E                     EXTFLD(AGSUC)                                       MOF60
     D  DATF         E                     EXTFLD(AGDFF)                                       MOF60
     D  MBIN         E                     EXTFLD(AGMBIN)                                      MOF60
     D*                                                                                        MOF60
     D**                                                                                       MOF60
     D LDA           E DS                  EXTNAME(LDA)                                        MOF60
      **  DATA AREA LDA                                                                        MOF60
      *                                                                                        MOF60
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  S01117
      **  EXTERNAL DS FOR BRANCH CODE DETAILS                                                 S01117
     D  BRNM         E                     EXTFLD(A8BRNM)                                     S01194
      **                                                                                      S01117
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                                  S01117
      **  EXTERNAL DS FOR GENERAL LEDGER DETAILS                                              S01117
     D  QQACC2       E                     EXTFLD(QQACCD)                                    CER073D
     D  PFCU         E                     EXTFLD(BKPRCU)                                     S01194
     D  OBRU         E                     EXTFLD(BKOBRU)                                     S01194
      *                                                                                       S01194
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  S01194
      **  EXTERNAL DS FOR CUSTOMER DETAILS                                                    S01194
     D  CRNM         E                     EXTFLD(BBCRNM)                                     S01194
     D  #DFAC1       E                     EXTFLD(QQDFAC)                                     CGL029
     D*                                                                                       S01194
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  S01194
      **  EXTERNAL DS FOR CURRENCY DETAILS                                                    S01194
     D  CDP          E                     EXTFLD(A6NBDP)                                     S01194
      *                                                                                       S01194
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  S01194
      **  EXTERNAL DS FOR BANK DETAILS                                                        S01194
     D  TITL         E                     EXTFLD(BJURPT)                                     S01194
     D*                                                                                       S01194
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     S01194
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                                    S01194
     D*                                                                                       S01194
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     S01194
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE                                    S01194
     D*                                                                                       S01194
     D*                                                                                       S01408
     D***/COPY*WNCPYSRC,LE0300IIPG***                                                  S01408 CFC006
     D/COPY WNCPYSRC,LE0300IIPG                                                             MD020563
     D SECTN           C                   CONST('LE0300001')                                 CFC006
     D*                                                                                       S01408
      *                                                                                       CER001
      ** Data structure for key of LEFCX2PD file                                              CER001
      *                                                                                       CER001
     D                 DS                                                                     CER001
     D**********                              1   60KCNUM                             CER001 CSD027A
     D  KCNUM                  1      6                                                      CSD027A
     D  WWFIL1                 7      7                                                       CER001
     D  KFACT                  8     10  0                                                    CER001
     D  WWFIL2                11     11                                                       CER001
     D  KFCNO                 12     13  0                                                    CER001
     D  WWKEY                  1     13                                                       CER001
      **                                                                                S01117 MOF60
     D*RUNDT*******DS                                                                   S01117 MOF60
      ****DATA*AREA*RUNDAT*****************************************                     S01117 MOF60
     D****************************************1   7 RUNA                                S01117 MOF60
     D************************************P***8  100RUND                                S01117 MOF60
     D***************************************11  11 SSF                                 S01117 MOF60
     D***************************************12  12 DATF                                S01117 MOF60
     D***************************************13  13 MBIN                                S01117 MOF60
     D**                                                                                S01117 MOF60
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CLE004
      **  Switchable Features File                                                            CLE004
      *                                                                                       CLE004
     D DSELIG        E DS                  EXTNAME(DSSDY)                                     CLE039
      ** For Eligible Customers                                                               CLE039
     D  SDY1B        E                     EXTFLD(SDY1)                                       CLE039
     D  SDY2B        E                     EXTFLD(SDY2)                                       CLE039
     D  SDY3B        E                     EXTFLD(SDY3)                                       CLE039
     D  SDY4B        E                     EXTFLD(SDY4)                                       CLE039
     I*/COPY*ZSRSRC,ZDATE2Z1*********                                                 S01392 CER073D
      *                                                                                       CLE004
     I*/COPY*ZSRSRC,ZFRPEDZ1*********                                                 CLE004 CER073D
     D/COPY ZSRSRC,ZFRPEDZ1LE                                                                CER073D
      ** Arrays to contain the input and output fields.                                       CLE004
      *                                                                                       CLE004
     I*/COPY*ZSRSRC,ZEDITZ1**********                                                 CLE004 CER073D
      ** Arrays to contain the input and output fields.                                       CLE004
      *                                                                                       CLE004
     I********************CPY@    1   1 80                                                     MOF60
     I**
     F/EJECT                                                                                   MOF60
     I*
     I*****FACILITIES FILE - HEADER RECORD                                                    S01117
     I***********                                                                             S01117
     I*CLTY***NS* 01   1 CH                                                                   S01117
     I***********                             1   1 RECI                                      S01117
     I***********                                                                             S01117
     I*****FACILITIES FILE - DETAIL RECORD 1                                                  S01117
     I***********                                                                             S01117
     I********NS* 02   1 CD  13 CA                                                            S01117
     I*******OR** 03   1 CR  13 CA                                                            S01117
     I*******OR**      1 CC  13 CA                                                            S01117
     I*******OR** 04   1 CE  13 CA                                                            S01117
     I***********                             1   1 RECI                                      S01117
     I***********                             2   70CNUM                                      S01117
     I***********                             8  100FACT                                      S01117
     I***********                            11  120FCNO                                      S01117
     I***********                            13  13 RCTP                                      S01117
     I***********                            14  160BRCD                                      S01117
     I***********                            17  17 FCTI                                      S01117
     I***********                            18  20 FCCY                                      S01117
     I***********                         P  21  270FAMT                                      S01117
     I***********                         P  28  303OVPC                                      S01117
     I***********                         P  31  330DTAP                                      S01117
     I***********                         P  34  360DTEX                                      S01117
     I***********                            37  37 RVCR                                      S01117
     I***********                            38  38 SECI                                      S01117
     I***********                            39  39 MCCY                                      S01117
     I***********                            40  40 MCSI                                      S01117
     I***********                            41  41 NACD                                      S01117
     I***********                            42  43 CRSK                                      S01117
     I***********                         P  44  460DLFS                                      S01117
     I***********                         P  47  527NOMR                                      S01117
     I***********                         P  53  550RVDT                                      S01117
     I***********                            56  56 RVFR                                      S01117
     I***********                            57  580RVDY                                      S01117
     I***********                            59  93 NAR1                                      S01117
     I***********                            94 128 NAR2                                      S01117
     I***********                           129 163 NAR3                                      S01117
     I***********                           164 198 NAR4                                      S01117
     I***********                         P 199 2050MTDH                                      S01117
     I***********                         P 206 2120MTDL                                      S01117
     I***********                         P 213 2190MTDA                                      S01117
     I***********                         P 220 2270QTDA                                      S01117
     I***********                         P 228 2350YTDA                                      S01117
     I***********                           236 237 ACOF                                      S01117
     I***********                           238 240 ORBR                                      S01117
     I***********                         P 247 2490ORED                                      S01117
     I***********                         P 250 2520LCD                                       S01117
     I***********                           253 253 CHTP                                      S01117
     I***********                         P 254 2560TNLU                                      S01117
     I***********                             1  12 DSA1                                      S01117
     I***********                                                                             S01117
     I*****FACILITIES FILE - DETAIL RECORD 2                                                  S01117
     I***********                                                                             S01117
     I********NS* 05   1 CD  13 CB                                                            S01117
     I*******OR** 06   1 CR  13 CB                                                            S01117
     I*******OR**      1 CC  13 CB                                                            S01117
     I*******OR** 07   1 CE  13 CB                                                            S01117
     I***********                             1   1 RECI                                      S01117
     I***********                             2   70CNUM                                      S01117
     I***********                             8  100FACT                                      S01117
     I***********                            11  120FCNO                                      S01117
     I***********                            13  13 RCTP                                      S01117
     I***********                            14  14 CMFT                                      S01117
     I***********                            15  150CALC                                      S01117
     I***********                         P  16  217SPRD                                      S01117
     I***********                            22  230BCOD                                      S01117
     I***********                         P  24  297BRAT                                      S01117
     I***********                         P  30  320STDT                                      S01117
     I***********                         P  33  350EDDT                                      S01117
     I***********                         P  36  380DUDT                                      S01117
     I***********                            39  39 BLFR                                      S01117
     I***********                            40  410BLDN                                      S01117
     I***********                            42  42 BTIN                                      S01117
     I***********                            43  440BLDY                                      S01117
     I***********                            45  460SETT                                      S01117
     I***********                            47  58 OBAC                                      S01117
     I***********                            59  68 TNAC                                      S01117
     I***********                         P  69  710SLCD                                      S01117
     I***********                         P  72  740ACCD                                      S01117
     I***********                         P  75  810ADNP                                      S01117
     I***********                         P  82  880PDTD                                      S01117
     I***********                         P  89  950AFPD                                      S01117
     I***********                         P  96 1020ADJP                                      S01117
     I***********                         P 103 1090ADJN                                      S01117
     I***********                         P 110 1160TOTD                                      S01117
     I***********                         P 117 1230CAMD                                      S01117
     I***********                         P 124 1300HFAM                                      S01117
     I***********                         P 147 1490RUN0                                      S01117
     I***********                         P 150 1520RUN1                                      S01117
     I***********                         P 153 1550RUN2                                      S01117
     I***********                         P 156 1580RUN3                                      S01117
     I***********                         P 159 1610RUN4                                      S01117
     I***********                         P 162 1640RUN5                                      S01117
     I***********                         P 165 1670RUN6                                      S01117
     I***********                         P 168 1700RUN7                                      S01117
     I***********                         P 171 1730RUN8                                      S01117
     I***********                         P 174 1760RUN9                                      S01117
     I***********                         P 177 1830OAM1                                      S01117
     I***********                         P 184 1900OAM2                                      S01117
     I***********                         P 191 1970OAM3                                      S01117
     I***********                         P 198 2040OAM4                                      S01117
     I***********                         P 205 2110OAM5                                      S01117
     I***********                         P 212 2180OAM6                                      S01117
     I***********                         P 219 2250OAM7                                      S01117
     I***********                         P 226 2320OAM8                                      S01117
     I***********                         P 233 2390OAM9                                      S01117
     I***********                         P 240 2460OA10                                      S01117
     I***********                         P 247 2490ORED                                      S01117
     I***********                         P 250 2520LCD                                       S01117
     I***********                           253 253 CHTP                                      S01117
     I***********                         P 254 2560TNLU                                      S01117
     I***********                             1  12 DSB1                                      S01117
     I*                                                                                       S01117
     IFCLTYF                                                                                  S01117
     I***  FACILITIES FILE - DETAILS                                                          S01117
     I                                          BRCA          L1                              S01117
     I              LCD                         LCDA                                          S01117
     I              CHTP                        CHTPA                                         S01117
     I              RECI                        RECIA                                         S01117
     I              CNUM                        CNUMA                                         S01117
     I              FACT                        FACTA                                         S01117
     I              FCNO                        FCNOA                                         S01117
     ILEPARTD0                                                                                CLE004
      ** Participant Details File.                                                            CLE004
     I*                                                                                       CLE004
     I              PCRF                        PCRF2                                         CLE004
     I              PRTR                        PRTR2                                         CLE106
     I*
     I********NS* 08   1 CT                                                                   S01117
     IFCLTYZZ   NS  08    1 CT                                                                S01117
     I***  FACILITIES FILE - TRAILER RECORD
     I*
     I                                  1    1  RECI
     I                             P   17   19 0NORE
     I                             P   20   22 0FLSZ
     I                             P   23   25 0NLRB
     I                             P   26   28 0NINS
     I                             P   29   31 0NDEL
     I                             P   32   34 0NLRA
     I                             P   35   42 0VLBF
     I                             P   43   44 0VLBL
     I                             P   45   52 0VRIF
     I                             P   53   54 0VRIL
     I                             P   55   62 0VRDF
     I                             P   63   64 0VRDL
     I                             P   65   72 0VRAF
     I                             P   73   74 0VRAL
     I                             P   75   82 0VLAF
     I                             P   83   84 0VLAL
     I                             P  250  252 0LCD
     I                                253  253  CHTP
     I                             P  254  256 0TNLU
     I*
     I*
     I          NS
     I***  FACILITIES FILE - CATCH-ALL
     I*
     IAGFCLTYF      09                                                                        CLE041
      ** Aggregate Facility File - detail                                                     CLE041
      *                                                                                       CLE041
     I                                          BRCA          L1                              CLE041
     I              LCD                         LCDA                                          CLE041
     I              CHTP                        CHTPA                                         CLE041
     I              RECI                        RECIA                                         CLE041
     I              CNUM                        CNUMA                                         CLE041
     I              FACT                        FACTA                                         CLE041
     I              FCNO                        FCNOA                                         CLE041
      *                                                                                       CLE041
     IAGFCTYZF                                                                                CLE041
      ** Aggregate Facilities File - Trailer Record                                           CLE041
      *                                                                                       CLE041
     I              RECI                        AGRECI                                        CLE041
     I              NORE                        AGNORE                                        CLE041
     I              NLRB                        AGNLRB                                        CLE041
     I              NINS                        AGNINS                                        CLE041
     I              NDEL                        AGNDEL                                        CLE041
     I              NLRA                        AGNLRA                                        CLE041
     I              VLBF                        AGVLBF                                        CLE041
     I              VLBL                        AGVLBL                                        CLE041
     I              VRIF                        AGVRIF                                        CLE041
     I              VRIL                        AGVRIL                                        CLE041
     I              VRDF                        AGVRDF                                        CLE041
     I              VRDL                        AGVRDL                                        CLE041
     I              VRAF                        AGVRAF                                        CLE041
     I              VRAL                        AGVRAL                                        CLE041
     I              VLAF                        AGVLAF                                        CLE041
     I              VLAL                        AGVLAL                                        CLE041
     I              LCD                         AGLCD                                         CLE041
     I              CHTP                        AGCHTP                                        CLE041
     I              TNLU                        AGTNLU                                        CLE041
     I/COPY WNCPYSRC,LEH00126
      *                                                                                       CLE039
     C                   MOVEA     CPY@          BIS@             80
     C*
     C** PARAMETER LIST FOR PROGRAM 'AOCUSTR0'                                                S01194
     C*                                                                                       S01194
     C     PLIST1        PLIST                                                                S01194
     C                   PARM      '*MSG   '     @RTCD                                        S01194
     C                   PARM      '*KEY   '     @OPTN                                        S01194
     C                   PARM                    CKEY             10                          S01194
     C                   PARM                    KEYSTS            7                          S01194
     C     SDCUST        PARM      SDCUST        DSSDY                                        S01194
     C*                                                                                       S01194
     C** PARAMETER LIST FOR PROGRAM 'AOCURRR0'                                                S01194
     C*                                                                                       S01194
     C     PLIST2        PLIST                                                                S01194
     C                   PARM      '*MSG   '     @RTCD                                        S01194
     C                   PARM      '*KEY   '     @OPTN                                        S01194
     C                   PARM                    CURKEY            3                        A S01194
     C     SDCURR        PARM      SDCURR        DSSDY                                      B S01194
     C*                                                                                       S01194
     C** PARAMETER LIST FOR PROGRAM 'AOBANKR0'                                                S01194
     C     PLISTA        PLIST                                                                S01194
     C                   PARM      '*MSG   '     @RTCD             7                          S01194
     C                   PARM      '*FIRST '     @OPTN             7                          S01194
     C     SDBANK        PARM      SDBANK        DSFDY                                        S01194
     C*                                                                                        MOF60
     C** KLIST FOR HISACT FILE                                                                 MOF60
     C     KEY001        KLIST                                                                 MOF60
     C                   KFLD                    BRCA                                          MOF60
     C                   KFLD                    CNUMA                                         MOF60
     C                   KFLD                    FCLTY                                         MOF60
      *                                                                                       CLE004
      ** KLIST for LEPARTL3                                                                   CLE004
     C     KPART         KLIST                                                                CLE004
     C                   KFLD                    BRCA                                         CLE004
     C                   KFLD                    CNUMA                                        CLE004
     C                   KFLD                    FACTA                                        CLE004
     C                   KFLD                    FCNOA                                        CLE004
      *                                                                                       CLE024
      ** Key fields for LE Facility Extension File LEFCLTLG                                   CLE024
      *                                                                                       CLE024
     C     KFCLT         KLIST                                                                CLE024
     C                   KFLD                    KBRCA             3                          CLE024
     C                   KFLD                    KCNUMA            6                          CLE024
     C                   KFLD                    KFACTA            3                          CLE024
     C                   KFLD                    KFCNOA            2                          CLE024
     C**                                                                                      S01117
     C**   DETERMINE TYPE OF FCLTY RECORD READ                                                S01117
     C**                                                                                      S01117
     C                   SETOFF                                       020304                  S01117
     C                   SETOFF                                       050607                  S01117
     C**                                                                                      S01117
     C     *IN08         IFEQ      '0'                                                        S01117
     C**                                                                                      S01117
     C     RCTP          IFEQ      'A'                                                        S01117
     C     RECIA         COMP      'D'                                    02                  S01117
     C     RECIA         COMP      'R'                                    03                  S01117
     C  N03RECIA         COMP      'C'                                    03                  S01117
     C     RECIA         COMP      'E'                                    04                  S01117
     C/COPY WNCPYSRC,LE0300C001
     C                   END                                                                  S01117
     C**                                                                                      S01117
     C     RCTPB         IFEQ      'B'                                                        S01117
     C     RECIB         COMP      'D'                                    05                  S01117
     C     RECIB         COMP      'R'                                    06                  S01117
     C  N06RECIB         COMP      'C'                                    06                  S01117
     C     RECIB         COMP      'E'                                    07                  S01117
     C                   END                                                                  S01117
     C*                                                                                        MOF60
     C***  IF REC TYPE OR ID IS BLANK MEANS ONLY HAVE 'A' REC                                  MOF60
     C***  (IE NO MATCHING 'B' REC)                                                            MOF60
     C***  NB - IF NO 'A' REC FOR A 'B' REC, WON'T APPEAR IN JOINT LF                          MOF60
     C*                                                                                        MOF60
     C     RCTPB         IFEQ      ' '                                                         MOF60
     C     RECIB         OREQ      ' '                                                         MOF60
     C                   SETON                                        U7U8LR                   MOF60
     C     *LOCK         IN        LDA                                                         MOF60
     C                   MOVE      *BLANKS       DBKEY                                         MOF60
     C                   MOVEL     CNUMA         KEY1              9                           MOF60
     C                   MOVE      FACTA         KEY1                                          MOF60
     C                   MOVEL     KEY1          KEY2                                          MOF60
     C                   MOVE      FCNOA         KEY2             11                           MOF60
     C                   MOVEL     KEY2          DBKEY                          ************   MOF60
     C                   Z-ADD     6             DBASE                          * DBERR 06 *   MOF60
     C                   MOVE      'FCLTY   '    DBFILE                         ************   MOF60
     C                   MOVE      'LE0300  '    DBPGM                                         MOF60
     C                   OUT       LDA                                                         MOF60
     C                   GOTO      ENDT                                                        MOF60
     C                   END                                                                   MOF60
     C*                                                                                        MOF60
     C                   END                                                                  S01117
     C*
     C*    FIRST CYCLE PROCESSING
     C*
     C   20              GOTO      ENDFC
     C                   SETON                                        20
      *                                                                                       196066
      ** Check if SAR is switched ON                                                          196066
      *                                                                                       196066
     C                   MOVE      'N'           CLE002            1                          196066
     C                   CALL      'AOSARDR0'                                                 196066
     C                   PARM      *BLANKS       @RTCD                                        196066
     C                   PARM      '*VERIFY'     @OPTN                                        196066
     C                   PARM      'CLE002'      @SARD             6                          196066
     C     SCSARD        PARM      SCSARD        DSFDY                                        196066
      *                                                                                       196066
     C     @RTCD         IFEQ      *BLANKS                                                    196066
     C                   MOVE      'Y'           CLE002                                       196066
     C                   MOVE      '1'           *IN39                                        196066
     C                   END                                                                  196066
      *                                                                                       196066
     C     @RTCD         IFNE      *BLANKS                                                    196066
     C     @RTCD         ANDNE     '*NRF   '                                                  196066
      *                                                                                       196066
      ** Call to program ended in error                                                       196066
      *                                                                                       196066
     C     *LOCK         IN        LDA                                                        196066
     C                   MOVEL     'CLE002'      DBKEY                          **************196066
     C                   MOVE      'SCSARDPD'    DBFILE                         * DB ERROR 20 196066
     C                   Z-ADD     20            DBASE                          **************196066
     C                   MOVEL     'LE0300'      DBPGM                                        196066
     C                   OUT       LDA                                                        196066
     C                   SETON                                        U7U8LR                  196066
     C                   EXSR      *PSSR                                                      196066
     C                   GOTO      ENDT                                                       196066
     C                   ENDIF                                                                196066
      *                                                                                       CLE004
      ** Check if SAR is switched ON                                                          CLE004
      *                                                                                       CLE004
     C                   MOVE      'N'           CLE004            1                          CLE004
     C                   CALL      'AOSARDR0'                                                 CLE004
     C                   PARM      *BLANKS       @RTCD                                        CLE004
     C                   PARM      '*VERIFY'     @OPTN                                        CLE004
     C                   PARM      'CLE004'      @SARD             6                          CLE004
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE004
      *                                                                                       CLE004
     C     @RTCD         IFEQ      *BLANKS                                                    CLE004
     C                   MOVE      'Y'           CLE004                                       CLE004
     C                   END                                                                  CLE004
      *                                                                                       CLE004
     C     @RTCD         IFNE      *BLANKS                                                    CLE004
     C     @RTCD         ANDNE     '*NRF   '                                                  CLE004
      *                                                                                       CLE004
      ** Call to program ended in error                                                       CLE004
      *                                                                                       CLE004
     C     *LOCK         IN        LDA                                                        CLE004
     C                   MOVEL     'CLE004'      DBKEY                          **************CLE004
     C                   MOVE      'SCSARDPD'    DBFILE                         * DB ERROR 48 CLE004
     C                   Z-ADD     48            DBASE                          **************CLE004
     C                   MOVEL     'LE0300'      DBPGM                                        CLE004
     C                   OUT       LDA                                                        CLE004
     C                   SETON                                        U7U8LR                  CLE004
     C                   EXSR      *PSSR                                                      CLE004
     C                   GOTO      ENDT                                                       CLE004
     C                   ENDIF                                                                CLE004
      *                                                                                       CLE005
     C                   MOVE      'N'           CLE005            1                          CLE005
     C                   CALL      'AOSARDR0'                                                 CLE005
     C                   PARM      *BLANKS       @RTCD                                        CLE005
     C                   PARM      '*VERIFY'     @OPTN                                        CLE005
     C                   PARM      'CLE005'      @SARD             6                          CLE005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE005
      *                                                                                       CLE005
     C     @RTCD         IFEQ      *BLANKS                                                    CLE005
     C                   MOVE      'Y'           CLE005                                       CLE005
     C                   MOVE      '1'           *IN28                                        CLE005
     C                   END                                                                  CLE005
      *                                                                                       CLE005
     C     @RTCD         IFNE      *BLANKS                                                    CLE005
     C     @RTCD         ANDNE     '*NRF   '                                                  CLE005
      *                                                                                       CLE005
      ** Call to program ended in error                                                       CLE005
      *                                                                                       CLE005
     C     *LOCK         IN        LDA                                                        CLE005
     C                   MOVEL     'CLE005'      DBKEY                          **************CLE005
     C                   MOVE      'SCSARDPD'    DBFILE                         * DB ERROR 49 CLE005
     C                   Z-ADD     49            DBASE                          **************CLE005
     C                   MOVEL     'LE0300'      DBPGM                                        CLE005
     C                   OUT       LDA                                                        CLE005
     C                   SETON                                        U7U8LR                  CLE005
     C                   EXSR      *PSSR                                                      CLE005
     C                   GOTO      ENDT                                                       CLE005
     C                   ENDIF                                                                CLE005
      *                                                                                       CLE004
     C                   MOVE      'N'           CLE006            1                          CLE006
     C                   SETOFF                                       11                     246031A
     C                   CALL      'AOSARDR0'                                                 CLE006
     C                   PARM      *BLANKS       @RTCD                                        CLE006
     C                   PARM      '*VERIFY'     @OPTN                                        CLE006
     C                   PARM      'CLE006'      @SARD             6                          CLE006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE006
      *                                                                                       CLE006
     C     @RTCD         IFEQ      *BLANKS                                                    CLE006
     C                   MOVE      'Y'           CLE006                                       CLE006
     C                   SETON                                        11                     246031A
     C                   END                                                                  CLE006
      *                                                                                       CLE006
     C     @RTCD         IFNE      *BLANKS                                                    CLE006
     C     @RTCD         ANDNE     '*NRF   '                                                  CLE006
      *                                                                                       CLE006
      ** Call to program ended in error                                                       CLE006
      *                                                                                       CLE006
     C     *LOCK         IN        LDA                                                        CLE006
     C                   MOVEL     'CLE006'      DBKEY                          **************CLE006
     C                   MOVE      'SCSARDPD'    DBFILE                         * DB ERROR 47 CLE006
     C                   Z-ADD     47            DBASE                          **************CLE006
     C                   MOVEL     'LE0300'      DBPGM                                        CLE006
     C                   OUT       LDA                                                        CLE006
     C                   SETON                                        U7U8LR                  CLE006
     C                   EXSR      *PSSR                                                      CLE006
     C                   GOTO      ENDT                                                       CLE006
     C                   ENDIF                                                                CLE006
      *                                                                                       CLE007
     C                   MOVE      'N'           CLE007            1                          CLE007
     C                   CALL      'AOSARDR0'                                                 CLE007
     C                   PARM      *BLANKS       @RTCD                                        CLE007
     C                   PARM      '*VERIFY'     @OPTN                                        CLE007
     C                   PARM      'CLE007'      @SARD             6                          CLE007
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE007
      *                                                                                       CLE007
     C     @RTCD         IFEQ      *BLANKS                                                    CLE007
     C                   MOVE      'Y'           CLE007                                       CLE007
     C                   MOVE      '1'           *IN29                                        CLE007
     C                   END                                                                  CLE007
      *                                                                                       CLE007
     C     @RTCD         IFNE      *BLANKS                                                    CLE007
     C     @RTCD         ANDNE     '*NRF   '                                                  CLE007
      *                                                                                       CLE007
      ** Call to program ended in error                                                       CLE007
      *                                                                                       CLE007
     C     *LOCK         IN        LDA                                                        CLE007
     C                   MOVEL     'CLE007'      DBKEY                          **************CLE007
     C                   MOVE      'SCSARDPD'    DBFILE                         * DB ERROR 50 CLE007
     C                   Z-ADD     50            DBASE                          **************CLE007
     C                   MOVEL     'LE0300'      DBPGM                                        CLE007
     C                   OUT       LDA                                                        CLE007
     C                   SETON                                        U7U8LR                  CLE007
     C                   EXSR      *PSSR                                                      CLE007
     C                   GOTO      ENDT                                                       CLE007
     C                   ENDIF                                                                CLE007
      *                                                                                       CLE008
     C                   MOVE      'N'           CLE008            1                          CLE008
     C                   CALL      'AOSARDR0'                                                 CLE008
     C                   PARM      *BLANKS       @RTCD                                        CLE008
     C                   PARM      '*VERIFY'     @OPTN                                        CLE008
     C                   PARM      'CLE008'      @SARD             6                          CLE008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE008
      *                                                                                       CLE008
     C     @RTCD         IFEQ      *BLANKS                                                    CLE008
     C                   MOVE      'Y'           CLE008                                       CLE008
     C                   MOVE      '1'           *IN61                                        CLE008
     C                   END                                                                  CLE008
      *                                                                                       CLE008
     C     @RTCD         IFNE      *BLANKS                                                    CLE008
     C     @RTCD         ANDNE     '*NRF   '                                                  CLE008
      *                                                                                       CLE008
      ** Call to program ended in error                                                       CLE008
      *                                                                                       CLE008
     C     *LOCK         IN        LDA                                                        CLE008
     C                   MOVEL     'CLE008'      DBKEY                          **************CLE008
     C                   MOVE      'SCSARDPD'    DBFILE                         * DB ERROR 51 CLE008
     C                   Z-ADD     51            DBASE                          **************CLE008
     C                   MOVEL     'LE0300'      DBPGM                                        CLE008
     C                   OUT       LDA                                                        CLE008
     C                   SETON                                        U7U8LR                  CLE008
     C                   EXSR      *PSSR                                                      CLE008
     C                   GOTO      ENDT                                                       CLE008
     C                   ENDIF                                                                CLE008
      *                                                                                       CLE008
     C                   MOVE      'N'           CLE028            1                          CLE028
     C                   CALL      'AOSARDR0'                                                 CLE028
     C                   PARM      *BLANKS       @RTCD                                        CLE028
     C                   PARM      '*VERIFY'     @OPTN                                        CLE028
     C                   PARM      'CLE028'      @SARD                                        CLE028
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE028
      *                                                                                       CLE028
     C     @RTCD         IFEQ      *BLANKS                                                    CLE028
     C                   MOVE      'Y'           CLE028                                       CLE028
     C                   ENDIF                                                                CLE028
      *                                                                                       CLE028
     C     @RTCD         IFNE      *BLANKS                                                    CLE028
     C     @RTCD         ANDNE     '*NRF   '                                                  CLE028
      *                                                                                       CLE028
      ** Call to program ended in error                                                       CLE028
      *                                                                                       CLE028
     C     *LOCK         IN        LDA                                                        CLE028
     C                   MOVEL     'CLE028'      DBKEY                                        CLE028
     C                   MOVE      'SCSARDPD'    DBFILE                                       CLE028
     C                   Z-ADD     52            DBASE                                        CLE028
     C                   MOVEL     'LE0300'      DBPGM                                        CLE028
     C                   OUT       LDA                                                        CLE028
     C                   SETON                                        U7U8LR                  CLE028
     C                   EXSR      *PSSR                                                      CLE028
     C                   GOTO      ENDT                                                       CLE028
     C                   ENDIF                                                                CLE028
      *                                                                                       CLE028
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALL      'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE031
      *                                                                                       CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   MOVE      *ON           *IN42                                        CLE031
     C                   END                                                                  CLE031
      *                                                                                       CLE031
     C     @RTCD         IFNE      *BLANKS                                                    CLE031
     C     @RTCD         ANDNE     '*NRF   '                                                  CLE031
      *                                                                                       CLE031
      ** Call to program ended in error                                                       CLE031
      *                                                                                       CLE031
     C     *LOCK         IN        LDA                                                        CLE031
     C                   MOVEL     'CLE008'      DBKEY                                        CLE031
     C                   MOVE      'SCSARDPD'    DBFILE                                       CLE031
     C                   Z-ADD     52            DBASE                                        CLE031
     C                   MOVEL     'LE0300'      DBPGM                                        CLE031
     C                   OUT       LDA                                                        CLE031
     C                   SETON                                        U7U8LR                  CLE031
     C                   EXSR      *PSSR                                                      CLE031
     C                   ENDIF                                                                CLE031
     C*                                                                                       S01408
     C                   MOVE      'N'           CLE034            1                          CLE034
     C                   MOVE      *OFF          *IN13                                        CLE034
     C                   CALL      'AOSARDR0'                                                 CLE034
     C                   PARM      *BLANKS       @RTCD                                        CLE034
     C                   PARM      '*VERIFY'     @OPTN                                        CLE034
     C                   PARM      'CLE034'      @SARD                                        CLE034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE034
      *                                                                                       CLE034
     C     @RTCD         IFEQ      *BLANKS                                                    CLE034
     C                   MOVE      'Y'           CLE034                                       CLE034
     C                   MOVE      *ON           *IN13                                        CLE034
     C                   END                                                                  CLE034
      *                                                                                       CLE034
     C     @RTCD         IFNE      *BLANKS                                                    CLE034
     C     @RTCD         ANDNE     '*NRF   '                                                  CLE034
      *                                                                                       CLE034
      ** Call to program ended in error                                                       CLE034
      *                                                                                       CLE034
     C     *LOCK         IN        LDA                                                        CLE034
     C                   MOVEL     'CLE034'      DBKEY                                        CLE034
     C                   MOVE      'SCSARDPD'    DBFILE                                       CLE034
     C                   Z-ADD     53            DBASE                                        CLE034
     C                   MOVEL     'LE0300'      DBPGM                                        CLE034
     C                   OUT       LDA                                                        CLE034
     C                   SETON                                        U7U8LR                  CLE034
     C                   EXSR      *PSSR                                                      CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE034
      ** Check if enhancement CLE039 (General LE Enhancements) is on                          CLE039
      *                                                                                       CLE039
     C                   CALL      'AOSARDR0'                                                 CLE039
     C                   PARM      *BLANKS       PRTCD             7                          CLE039
     C                   PARM      '*VERIFY'     POPTN             7                          CLE039
     C                   PARM      'CLE039'      PSARD             6                          CLE039
     C     SCSARD        PARM      SCSARD        DSSDY                                        CLE039
      *                                                                                       CLE039
     C     PRTCD         IFNE      *BLANKS                                                    CLE039
     C     PRTCD         ANDNE     '*NRF   '                                                  CLE039
     C     *LOCK         IN        LDA                                                        CLE039
     C                   MOVEL     'LE0300'      DBPGM                                        CLE039
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CLE039
     C                   MOVEL     'CLE039'      DBKEY                                        CLE039
     C                   Z-ADD     52            DBASE                                        CLE039
     C                   OUT       LDA                                                        CLE039
     C                   MOVE      *ON           *INU7                                        CLE039
     C                   MOVE      *ON           *INU8                                        CLE039
     C                   MOVE      *ON           *INLR                                        CLE039
     C                   EXSR      *PSSR                                                      CLE039
     C                   GOTO      ENDT                                                       CLE039
     C                   ENDIF                                                                CLE039
      *                                                                                       CLE039
     C     PRTCD         IFEQ      *BLANKS                                                    CLE039
     C                   MOVE      'Y'           CLE039            1                          CLE039
     C                   MOVE      *ON           *IN16                                        CLE039
     C                   ELSE                                                                 CLE039
     C                   MOVE      'N'           CLE039                                       CLE039
     C                   MOVE      *OFF          *IN16                                        CLE039
     C                   ENDIF                                                                CLE039
      *                                                                                       CLE039
      ** Check if enhancement CLE024 (Collateralised Lending) is on                           CLE024
      *                                                                                       CLE024
     C                   CALL      'AOSARDR0'                                                 CLE024
     C                   PARM      *BLANKS       PRTCD                                        CLE024
     C                   PARM      '*VERIFY'     POPTN                                        CLE024
     C                   PARM      'CLE024'      PSARD                                        CLE024
     C     SCSARD        PARM      SCSARD        DSSDY                                        CLE024
      *                                                                                       CLE024
     C     PRTCD         IFNE      *BLANKS                                                    CLE024
     C     PRTCD         ANDNE     '*NRF   '                                                  CLE024
     C     *LOCK         IN        LDA                                                        CLE024
     C                   MOVEL     'LE0300'      DBPGM                                        CLE024
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CLE024
     C                   MOVEL     'CLE024'      DBKEY                                        CLE024
     C                   Z-ADD     53            DBASE                                        CLE024
     C                   OUT       LDA                                                        CLE024
     C                   MOVE      *ON           *INU7                                        CLE024
     C                   MOVE      *ON           *INU8                                        CLE024
     C                   MOVE      *ON           *INLR                                        CLE024
     C                   EXSR      *PSSR                                                      CLE024
     C                   GOTO      ENDT                                                       CLE024
     C                   ENDIF                                                                CLE024
      *                                                                                       CLE024
     C                   MOVE      'N'           CLE024            1                          CLE024
     C                   MOVE      *OFF          *IN17                                        CLE024
     C     PRTCD         IFEQ      *BLANKS                                                    CLE024
     C                   MOVE      'Y'           CLE024                                       CLE024
     C                   MOVE      *ON           *IN17                                        CLE024
     C                   ENDIF                                                                CLE024
      *                                                                                       CLE024
      ** Check if enhancement CLE025 (Credit Lines) is on                                     CLE025
      **   (Indicator *IN18 is seton if CLE025 or CFX001 is on)                               CLE025
      *                                                                                       CLE025
     C                   CALL      'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       PRTCD                                        CLE025
     C                   PARM      '*VERIFY'     POPTN                                        CLE025
     C                   PARM      'CLE025'      PSARD                                        CLE025
     C     SCSARD        PARM      SCSARD        DSSDY                                        CLE025
      *                                                                                       CLE025
     C     PRTCD         IFNE      *BLANKS                                                    CLE025
     C     PRTCD         ANDNE     '*NRF   '                                                  CLE025
     C     *LOCK         IN        LDA                                                        CLE025
     C                   MOVEL     'LE0300'      DBPGM                                        CLE025
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CLE025
     C                   MOVEL     'CLE025'      DBKEY                                        CLE025
     C                   Z-ADD     55            DBASE                                        CLE025
     C                   OUT       LDA                                                        CLE025
     C                   MOVE      *ON           *INU7                                        CLE025
     C                   MOVE      *ON           *INU8                                        CLE025
     C                   MOVE      *ON           *INLR                                        CLE025
     C                   EXSR      *PSSR                                                      CLE025
     C                   GOTO      ENDT                                                       CLE025
     C                   ENDIF                                                                CLE025
      *                                                                                       CLE025
     C     PRTCD         IFEQ      *BLANKS                                                    CLE025
     C                   MOVE      'Y'           CLE025            1                          CLE025
     C                   MOVE      *ON           *IN18                                        CLE025
     C                   ELSE                                                                 CLE025
     C                   MOVE      'N'           CLE025                                       CLE025
     C                   MOVE      *OFF          *IN18                                        CLE025
     C                   ENDIF                                                                CLE025
     C/COPY WNCPYSRC,LEH00090
      *                                                                                       CLE025
      ** Check if enhancement CFX001 (FX Margin Trading) is on                                CFX001
      **   (Indicator *IN18 is seton if CLE025 or CFX001 is on)                               CFX001
      *                                                                                       CFX001
     C                   CALL      'AOSARDR0'                                                 CFX001
     C                   PARM      *BLANKS       PRTCD                                        CFX001
     C                   PARM      '*VERIFY'     POPTN                                        CFX001
     C                   PARM      'CFX001'      PSARD                                        CFX001
     C     SCSARD        PARM      SCSARD        DSSDY                                        CFX001
      *                                                                                       CFX001
     C     PRTCD         IFNE      *BLANKS                                                    CFX001
     C     PRTCD         ANDNE     '*NRF   '                                                  CFX001
     C     *LOCK         IN        LDA                                                        CFX001
     C                   MOVEL     'LE0300'      DBPGM                                        CFX001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CFX001
     C                   MOVEL     'CFX001'      DBKEY                                        CFX001
     C                   Z-ADD     54            DBASE                                        CFX001
     C                   OUT       LDA                                                        CFX001
     C                   MOVE      *ON           *INU7                                        CFX001
     C                   MOVE      *ON           *INU8                                        CFX001
     C                   MOVE      *ON           *INLR                                        CFX001
     C                   EXSR      *PSSR                                                      CFX001
     C                   GOTO      ENDT                                                       CFX001
     C                   ENDIF                                                                CFX001
      *                                                                                       CFX001
     C                   MOVE      'N'           CFX001            1                          CFX001
     C     PRTCD         IFEQ      *BLANKS                                                    CFX001
     C                   MOVE      'Y'           CFX001                                       CFX001
     C                   MOVE      *ON           *IN18                                        CFX001
     C                   ENDIF                                                                CFX001
      *                                                                                       CFX001
     C     *LIKE         DEFINE    NDEL          WNDEL                                        CLE041
     C     *LIKE         DEFINE    NINS          WNINS                                        CLE041
     C     *LIKE         DEFINE    NLRA          WNLRA                                        CLE041
     C     *LIKE         DEFINE    NLRB          WNLRB                                        CLE041
     C     *LIKE         DEFINE    VLAF          WVLAF                                        CLE041
     C     *LIKE         DEFINE    VLAL          WVLAL                                        CLE041
     C     *LIKE         DEFINE    VLBF          WVLBF                                        CLE041
     C     *LIKE         DEFINE    VLBL          WVLBL                                        CLE041
     C     *LIKE         DEFINE    VRAF          WVRAF                                        CLE041
     C     *LIKE         DEFINE    VRAL          WVRAL                                        CLE041
     C     *LIKE         DEFINE    VRDF          WVRDF                                        CLE041
     C     *LIKE         DEFINE    VRDL          WVRDL                                        CLE041
     C     *LIKE         DEFINE    VRIF          WVRIF                                        CLE041
     C     *LIKE         DEFINE    VRIL          WVRIL                                        CLE041
      *                                                                                       CLE041
     C***/COPY*WNCPYSRC,LE0300CCP1***                                                  S01408 CFC006
     C/COPY WNCPYSRC,LE0300CCP1                                                             MD020563
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
     C**********           MOVEL'LE0300'  DBPGM                                   AR1097176 MD020563
     C**********           MOVEL'SCSARDPD'DBFILE                                  AR1097176 MD020563
     C**********           MOVEL'CFC006'  DBKEY                                   AR1097176 MD020563
     C**********           Z-ADD66        DBASE                                   AR1097176 MD020563
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
      ** Enable output indicator for LE0300P1                                                 CFC006
      *                                                                                       CFC006
     C                   MOVE      *ON           *IN97                                        CFC006
     C                   MOVEL     'N'           SUPFLG            1                          CFC006
     C********** CFC006    IFEQ 'Y'                                               AR1097176 MD020563
     C                   CALL      'AOCOMR0'                                                  CFC006
     C                   PARM      'LEC06  '     PNAME            10                          CFC006
     C                   PARM      '*ALL '       PCSEQ             5                          CFC006
     C                   PARM      SECTN         PSCTN            50                          CFC006
     C                   PARM      *BLANKS       PRTCD                                        CFC006
      *                                                                                       CFC006
     C     PRTCD         IFEQ      'Y      '                                                  CFC006
     C                   MOVEL     'Y'           SUPFLG                                       CFC006
     C                   MOVE      *OFF          *IN97                                        CFC006
     C                   ENDIF                                                                CFC006
     C**********           ENDIF                                                  AR1097176 MD020563
      *                                                                                       CFC006
     C                   MOVE      *OFF          *IN80                                        CER020
      *                                                                                       CER020
     C                   CALL      'AOSARDR0'                                                 CER020
     C                   PARM      *BLANKS       PRTCD                                        CER020
     C                   PARM      '*VERIFY'     POPTN                                        CER020
     C                   PARM      'CER020'      PSARD             6                          CER020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER020
      *                                                                                       CER020
     C     PRTCD         IFEQ      *BLANKS                                                    CER020
      *                                                                                       CER020
     C                   MOVE      'Y'           CER020            1                          CER020
     C                   MOVE      *ON           *IN80                                        CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C     PRTCD         IFNE      *BLANKS                                                    CER020
     C     PRTCD         ANDNE     '*NRF   '                                                  CER020
      *                                                                                       CER020
      ** Call to program ended in error                                                       CER020
      *                                                                                       CER020
     C     *LOCK         IN        LDA                                                        CER020
     C                   MOVEL     'CER020'      DBKEY                                        CER020
     C                   MOVE      'SCSARDPD'    DBFILE                                       CER020
     C                   Z-ADD     65            DBASE                                        CER020
     C                   MOVE      *ON           *INU7                                        CER020
     C                   MOVE      *ON           *INU8                                        CER020
     C                   MOVE      *ON           *INLR                                        CER020
     C                   OUT       LDA                                                        CER020
     C                   EXSR      *PSSR                                                      CER020
      *                                                                                       CER020
     C                   GOTO      ENDT                                                       CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
     C*                                                                                       S01408
      *                                                                                       CER001
      ** Define key of LEFCX2PD file                                                          CER001
      *                                                                                       CER001
     C     KEYMX6        KLIST                                                                CER001
     C                   KFLD                    KCNUM                                        CER001
     C                   KFLD                    KFACT                                        CER001
     C                   KFLD                    KFCNO                                        CER001
      ***  Check if CLE029 is set to on.                                                      CLE029
      *                                                                                       CLE029
     C                   MOVEL     'N'           CLE029            1                          CLE029
     C                   MOVE      *OFF          *IN40                                        CLE029
     C                   CALL      'AOSARDR0'                                                 CLE029
     C                   PARM      *BLANKS       @RTCD                                        CLE029
     C                   PARM      '*VERIFY'     @OPTN                                        CLE029
     C                   PARM      'CLE029'      @SARD                                        CLE029
      *                                                                                       CLE029
     C     @RTCD         IFEQ      *BLANKS                                                    CLE029
     C                   MOVEL     'Y'           CLE029                                       CLE029
     C                   MOVE      *ON           *IN40                                        CLE029
     C                   ENDIF                                                                CLE029
      *                                                                                       CLE029
     C     @RTCD         IFNE      *BLANKS                                                    CLE029
     C     @RTCD         ANDNE     '*NRF   '                                                  CLE029
      *                                                                                       CLE029
      ** Call to program ended in error                                                       CLE029
      *                                                                                       CLE029
     C     *LOCK         IN        LDA                                                        CLE029
     C                   MOVEL     'CLE029'      DBKEY                          **************CLE029
     C                   MOVE      'SCSARDPD'    DBFILE                         * DB ERROR 52 CLE029
     C                   Z-ADD     52            DBASE                          **************CLE029
     C                   MOVEL     'LE0300'      DBPGM                                        CLE029
     C                   OUT       LDA                                                        CLE029
     C                   SETON                                        U7U8LR                  CLE029
     C                   EXSR      *PSSR                                                      CLE029
     C                   GOTO      ENDT                                                       CLE029
     C                   ENDIF                                                                CLE029
      *                                                                                       CER001
      ** Determine if ULX004 is installed.                                                    CER001
      *                                                                                       CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX004'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVE      'Y'           ULX004            1                          CER001
     C**********           MOVE *ON       *IN60                                      CER001 BUG10267
     C                   MOVE      *ON           *IN62                                      BUG10267
     C                   ELSE                                                                 CER001
     C                   MOVE      'N'           ULX004                                       CER001
     C     @RTCD         IFNE      '*NRF    '                                                 CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   Z-ADD     57            DBASE                                        CER001
     C                   MOVEL     'ULX004'      DBKEY                                        CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CLE029
      ***  Check if CLE106 is set to on.                                                      CLE106
      *                                                                                       CLE106
     C                   MOVEL     'N'           CLE106            1                          CLE106
     C                   CALL      'AOSARDR0'                                                 CLE106
     C                   PARM      *BLANKS       @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
      *                                                                                       CLE106
     C     @RTCD         IFEQ      *BLANKS                                                    CLE106
     C                   MOVEL     'Y'           CLE106                                       CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C     @RTCD         IFNE      *BLANKS                                                    CLE106
     C     @RTCD         ANDNE     '*NRF   '                                                  CLE106
      *                                                                                       CLE106
      ** Call to program ended in error                                                       CLE106
     C     *LOCK         IN        LDA                                                        CLE106
     C                   MOVEL     'CLE106'      DBKEY                          **************CLE106
     C                   MOVE      'SCSARDPD'    DBFILE                         * DB ERROR 56 CLE106
     C                   Z-ADD     56            DBASE                          **************CLE106
     C                   MOVEL     'LE0300'      DBPGM                                        CLE106
     C                   OUT       LDA                                                        CLE106
     C                   SETON                                        U7U8LR                  CLE106
     C                   EXSR      *PSSR                                                      CLE106
     C                   GOTO      ENDT                                                       CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                      BUG8943
      ** Determine if Nordea LE Enh. Phase 1 Pty 2 - Income Splits                           BUG8943
      ** is installed                                                                        BUG8943
      *                                                                                      BUG8943
     C                   MOVEL     'N'           CLE035            1                         BUG8943
     C                   MOVE      *OFF          *IN14                                       BUG8943
     C                   CALL      'AOSARDR0'                                                BUG8943
     C                   PARM      *BLANKS       @RTCD                                       BUG8943
     C                   PARM      '*VERIFY'     @OPTN                                       BUG8943
     C                   PARM      'CLE035'      @SARD                                       BUG8943
      *                                                                                      BUG8943
     C     @RTCD         IFEQ      *BLANKS                                                   BUG8943
     C                   MOVEL     'Y'           CLE035                                      BUG8943
     C                   MOVE      *ON           *IN14                                       BUG8943
     C                   ENDIF                                                               BUG8943
      *                                                                                      BUG8943
     C     @RTCD         IFNE      *BLANKS                                                   BUG8943
     C     @RTCD         ANDNE     '*NRF   '                                                 BUG8943
      *                                                                                      BUG8943
      ** Call to program ended in error                                                      BUG8943
     C     *LOCK         IN        LDA                                                       BUG8943
     C                   MOVEL     'CLE035'      DBKEY                          *************BUG8943
     C                   MOVE      'SCSARDPD'    DBFILE                         * DB ERROR 57BUG8943
     C                   Z-ADD     57            DBASE                          *************BUG8943
     C                   MOVEL     'LE0300'      DBPGM                                       BUG8943
     C                   OUT       LDA                                                       BUG8943
     C                   SETON                                        U7U8LR                 BUG8943
     C                   EXSR      *PSSR                                                     BUG8943
     C                   GOTO      ENDT                                                      BUG8943
     C                   ENDIF                                                               BUG8943
      *                                                                                      CER073D
      ** Check if EML014 is switched ON                                                      CER073D
      *                                                                                      CER073D
     C                   MOVE      'N'           CER073            1                         CER073D
     C                   CALL      'AOSARDR0'                                                CER073D
     C                   PARM      *BLANKS       @RTCD                                       CER073D
     C                   PARM      '*VERIFY'     @OPTN                                       CER073D
     C                   PARM      'CER073'      @SARD                                       CER073D
      *                                                                                      CER073D
     C     @RTCD         IFEQ      *BLANKS                                                   CER073D
     C                   MOVE      'Y'           CER073                                      CER073D
     C                   ENDIF                                                               CER073D
      **                                                                                      S01117
      **   IN THE DATAAREA RUNDAT                                                             S01117
      **                                                                                      S01117
     C     *DTAARA       DEFINE    RUNDAT        RUNDT                                        S01117
     C                   IN        RUNDT                                                      S01117
     C*    DEFINE LDA                                                                         S01117
     C     *DTAARA       DEFINE                  LDA                                          S01117
     C********** *LOCK     IN   LDA                                                     S01117 MOF60
     C*
     C*    SET UP DATABASE ERROR REFERENCE
     C*
     C                   MOVE      'LE0300  '    DBPGM
     C                   MOVE      ' '           BLANKS           29
     C                   MOVE      BLANKS        DBKEY
     C***********                                                                              MOF60
     C*****ACCESS*ICD-1*FOR*DATE*FORMAT,*DATABASE*ERROR*IF*NOT*FOUND***                        MOF60
     C***********                                                                              MOF60
     C***  ACCESS BANK DETAILS                                                                 MOF60
     C*                                                                                        MOF60
     C                   CALL      'AOBANKR0'    PLISTA                                        MOF60
     C**                                                                                       MOF60
     C     @RTCD         IFNE      *BLANKS                                                     MOF60
     C                   SETON                                        U7U8LR                   MOF60
     C     *LOCK         IN        LDA                                                         MOF60
     C                   MOVE      *BLANKS       DBKEY                                         MOF60
     C                   MOVE      '01'          DBASE                                         MOF60
     C                   MOVE      'SDBANKPD'    DBFILE                                        MOF60
     C                   MOVE      'LE0300  '    DBPGM                                         MOF60
     C                   OUT       LDA                                                         MOF60
     C                   GOTO      ENDT                                                        MOF60
     C                   END                                                                   MOF60
     C***99*****           SETON                     U7U8LR                                    MOF60
     C***99*****           MOVE '01'      DBASE                                                MOF60
     C***99*****           MOVE 'TABLE'   DBFILE                                        S01194 MOF60
     C***99*****           MOVE 'SDBANKPD'DBFILE                                        S01194 MOF60
     C***99*****           MOVELZTABKY    DBKEY                                                MOF60
     C***99*****           GOTO ENDT                                                           MOF60
     C*                                                                                        MOF60
     C***  CHECK SYSTEM DATE FORMAT, DDMMYY OR MMDDYY.                                         MOF60
     C*                                                                                        MOF60
     C     DATF          IFEQ      'M'                                                         MOF60
     C                   MOVE      '1'           *IN98                                         MOF60
     C                   END                                                                   MOF60
      **                                                                                      S01117
      **   ACCESS GENERAL LEDGER DETAILS                                                      S01117
      **                                                                                      S01117
     C**********           CALL 'AOGELRR0'                                             S01117 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*MSG   '     @RTCD                                         MOF60
     C                   PARM      '*FIRST '     @OPTN                                         MOF60
     C********** SDGELR    PARM SDGELR    DSFDY                                        S01117 CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
     C*********************PARM '*MSG   ' @RTCD   7                                     S01117 MOF60
     C*********************PARM '*FIRST ' @OPTN   7                                     S01117 MOF60
     C*                                                                                       S01117
     C     @RTCD         IFNE      *BLANK                                                     S01117
     C                   SETON                                        U7U8LR                  S01117
     C     *LOCK         IN        LDA                                                         MOF60
     C                   MOVEL     'SDGELRPD'    DBFILE                         **************S01117
     C                   MOVE      *BLANKS       DBKEY                                         MOF60
     C                   MOVEL     @OPTN         DBKEY                          * DBERROR 05  S01117
     C                   Z-ADD     5             DBASE                          **************S01117
     C                   MOVE      'LE0300  '    DBPGM                                         MOF60
     C                   OUT       LDA                                                         MOF60
     C                   EXSR      *PSSR                                                      S01117
     C                   GOTO      ENDT                                                       S01117
     C                   END                                                                  S01117
      ** Access Dealing details                                                              CER073D
     C                   CALL      'AODEALR1'                                                CER073D
     C                   PARM      '*DBERR '     @RTCD                                       CER073D
     C                   PARM      '*FIRST '     @OPTN                                       CER073D
     C     SDDEAL        PARM      SDDEAL        DSSDY                                       CER073D
      *                                                                                      CER073D
     C     @RTCD         IFNE      *BLANKS                                                   CER073D
     C                   SETON                                        U7U8LR                 CER073D
     C     *LOCK         IN        LDA                                                       CER073D
     C                   MOVEL     'SDDEALPD'    DBFILE                                      CER073D
     C                   Z-ADD     900           DBASE                                       CER073D
     C                   MOVEL     @OPTN         DBKEY                                       CER073D
     C                   OUT       LDA                                                       CER073D
     C                   EXSR      *PSSR                                                     CER073D
     C                   GOTO      ENDT                                                      CER073D
     C                   ENDIF                                                               CER073D
     C*
     C*    SETON INDICATOR FOR NO PRINTING, IF MULTIBRANCHING = NO                            S01117
     C*                                                                                       S01117
     C     MBIN          IFNE      'Y'                                                        S01117
     C                   SETON                                        3376                    S01117
     C                   ELSE                                                                 S01117
     C     OBRU          IFNE      'Y'                                                        S01117
     C                   SETON                                        76                      S01117
     C                   END                                                                  S01117
     C                   END                                                                  S01117
      **                                                                                      S01117
      **   SETON INDICATOR FOR NO PRINTING, PROFIT CENTRE FIELD                               S01117
      **                                                                                      S01117
     C     PFCU          IFNE      'Y'                                                        S01117
     C                   SETON                                        77                      S01117
     C                   END                                                                  S01117
     C*                                                                                        MOF60
     C***  SET OFF A FLAG FOR FILE OPENING PROCESSING                                          MOF60
     C*                                                                                        MOF60
     C                   MOVE      *BLANKS       OPENP1            1                           MOF60
     C                   MOVE      *BLANKS       OPENP3            1                          CLE041
      *                                                                                       140832
      ***  Report Work fields.                                                                140832
      *                                                                                       140832
     C                   Z-ADD     0             RQDLN2            3 0                        140832
     C                   Z-ADD     0             DIFLN2            3 0                        140832
     C*                                                                                       S01117
     C*                                                                                       S01408
     C/COPY WNCPYSRC,LE0300CEIP                                                               S01408
     C*                                                                                       S01408
     C     ENDFC         TAG                                                    ** ENDFC TAG **
     C*
     C*                                                                                       S01408
     C/COPY WNCPYSRC,LE0300CCPG                                                               S01408
     C*                                                                                       S01408
     C                   SETOFF                                       30
     C                   SETOFF                                       15                      CLE015
     C***********          SETOF                     242526                                   S01117
     C*
     C*****IF*HEADER*RECORD*READ****                                                          S01117
     C***01******          GOTO ENDT                                                          S01117
      ** IF MBIN=YES, AND A LEVEL BREAK,                                                      S01117
      ** OPEN LE0300P1                                                                        S01117
     C     *INL1         IFEQ      '1'                                                        S01117
     C     MBIN          ANDEQ     'Y'                                                         MOF60
     C     *IN09         IFEQ      *OFF                                                       CLE041
     C                   CLOSE     LE0300P1                                                   S01117
     C                   MOVE      ' '           P1OP                                          MOF60
     C                   ELSE                                                                 CLE041
     C                   CLOSE     LE0300P3                                                   CLE041
     C                   MOVE      ' '           P3OP                                         CLE041
     C                   ENDIF                                                                CLE041
     C                   SETOFF                                       75                      S01117
      *                                                                                       CLE004
     C***********CLE004    IFEQ 'Y'                                                    CLE004 187663
     C     CLE006        IFEQ      'Y'                                                        187663
     C     OPEN2         ANDEQ     '1'                                                        CLE004
     C                   CLOSE     LE0300P2                                                   CLE004
     C                   MOVE      *OFF          *IN71                                        CLE004
     C                   ENDIF                                                                CLE004
      *                                                                                       CLE004
     C**********           MOVE 'Y'       P1OP    1                                            MOF60
     C**********           OPEN LE0300P1                                                       MOF60
     C*                                                                                        MOF60
     C***  SET ON A FLAG FOR FILE OPENING PROCESSING.                                          MOF60
     C***  IF IT IS ON, IT MEANS WE SHOULD OPEN A NEW P1, BUT IT IS                            MOF60
     C***  DELAYED TILL MORE DETAILS ARE DUE TO BE PUT OUT.                                    MOF60
     C***  THIS IS TO PREVENT OUTPUT OF 'NO DETAIL' PAGES.                                     MOF60
     C*                                                                                        MOF60
     C                   MOVE      'Y'           OPENP1                                        MOF60
     C                   MOVE      'Y'           OPENP3                                       CLE041
     C*                                                                                        MOF60
     C**********           Z-ADD0         PAGE                                                 MOF60
      ** ENSURE REPORT SPOOL FILE RECORDED BY RCF                                              MOF60
     C**********           Z-ADDSFNUM     ZSNUM   60                                           MOF60
     C*********************OUT  LDA                                                            MOF60
     C**********           CALL 'ZSFILE'                                                       MOF60
     C**********           PARM           SEQ                                                  MOF60
     C**********           PARM BRCA      SENTY   3                                            MOF60
     C**********           PARM           SFILE                                                MOF60
     C**********           PARM           ZSNUM                                                MOF60
     C**********           PARM           ZSERR   1                                            MOF60
      *                                                                                       S01117
     C************LOCK     IN   LDA                                                            MOF60
     C********** ZSERR     IFEQ 'Y'                                                            MOF60
      ****ERROR*DURING*ZSFILE*PROCESSING,*RETURN*TO*CALLING*PROGRAM****                        MOF60
     C**********           SETON                     U7U8LR                                    MOF60
     C**********           RETRN                                                               MOF60
     C**********           END                                                                 MOF60
     C**                                                                                      S01117
      **                                                                                      S01117
      ** GET BRANCH NAME, ONLY WHEN MBIN = 'Y'                                                S01117
      **                                                                                      S01117
     C     MBIN          IFEQ      'Y'                                                        S01117
      *                                                                                       S01117
     C**********           CALL 'AOBRCHR0'                                             S01117 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*MSG   '     @RTCD                                         MOF60
     C                   PARM      '*KEY   '     @OPTN                                         MOF60
     C                   PARM      BRCA          @DSNB             3                          S01117
     C********** SDBRCH    PARM SDBRCH    DSFDY                                        S01117 CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
     C***********          PARM '*MSG   ' @RTCD   7                                     S01117 MOF60
     C***********          PARM '*KEY   ' @OPTN   7                                     S01117 MOF60
     C     @RTCD         IFNE      *BLANKS                                                    S01117
     C     *LOCK         IN        LDA                                                         MOF60
     C                   MOVE      *BLANKS       DBKEY                                         MOF60
     C                   MOVEL     @DSNB         DBKEY                          **************S01117
     C                   MOVEL     'SDBRCHPD'    DBFILE                         * DBERROR 12  S01117
     C                   Z-ADD     12            DBASE                          **************S01117
     C                   MOVE      'LE0300  '    DBPGM                                         MOF60
     C                   OUT       LDA                                                         MOF60
     C                   SETON                                        U7U8LR                  S01117
     C                   EXSR      *PSSR                                                      S01117
     C                   GOTO      ENDT                                                       S01117
     C                   END                                                                  S01117
      *                                                                                       S01117
     C                   END                                                                  S01117
      *                                                                                       S01117
     C                   END                                                                  S01117
     C*
     C/COPY WNCPYSRC,LE0300C005
     C*    IF DETAIL 'A' RECORD READ
     C*
     C   02
     COR 03
     COR 04              EXSR      DETA
     C*                                                                                        MOF60
     C***  GET OUT IF ERROR                                                                    MOF60
     C*                                                                                        MOF60
     C     *INU7         IFEQ      '1'                                                         MOF60
     C                   GOTO      ENDT                                                        MOF60
     C                   END                                                                   MOF60
     C*
     C*    IF DETAIL 'B' RECORD READ,
     C*
     C   05
     COR 06
     COR 07              EXSR      DETB
     C*                                                                                       S01408
     C/COPY WNCPYSRC,LE0300CPDR                                                               S01408
     C*                                                                                       S01408
     C*                                                                                        MOF60
     C***  GET OUT IF ERROR                                                                    MOF60
     C*                                                                                        MOF60
     C     *INU7         IFEQ      '1'                                                         MOF60
     C                   GOTO      ENDT                                                        MOF60
     C                   END                                                                   MOF60
     C*
     C*    IF TRAILER RECORD READ
     C*          AND CONTROL CHECKING NOT SUPPRESSED                                          S01117
     C*
     C   08              EXSR      TRLR
      **                                                                                      S01117
      **   IF DETAIL PAGE PRINTED, SET ON APPROPIATE INDICATORS                               S01117
      **                                                                                      S01117
     C     *IN30         IFEQ      '1'                                                        S01117
     C                   SETON                                        7475                    S01117
     C                   END                                                                  S01117
     C*
     C*
     C     ENDT          TAG                                                    ** ENDT TAG **
      *                                                                                       CLE024
      ** Access the Facility Extension detail file                                            CLE024
      *                                                                                       CLE024
     CL0                 MOVE      *BLANKS       WXDEA             1                          CLE039
     CL0                 MOVE      *BLANKS       WXPOR             4                          CLE024
     CL0                 Z-ADD     *ZERO         WXLVR             3 0                        CLE024
     CL0                 Z-ADD     *ZERO         WXALV             3 0                        CLE024
     CL0                 Z-ADD     *ZERO         WXLVA             3 0                        CLE024
     CL0                 Z-ADD     *ZERO         WXLVW             3 0                        CLE024
     CL0                 MOVE      *BLANKS       WXSTC             1                          CLE024
     CL0                 Z-ADD     *ZERO         WXPWF             3 0                        CLE024
     CL0                 Z-ADD     *ZERO         WXPIS             3 0                        CLE024
     CL0                 MOVE      *BLANKS       WXOML            13 0                        CFX001
     CL0                 MOVE      *BLANKS       WXMST             3                          CFX001
     CL0                 MOVE      *BLANKS       WCGRP            20                          CLE039
     CL0                 MOVEA     *BLANKS       ARELIG                                       CLE039
     CL0                 MOVEA     *BLANKS       ACG                                          CLE039
      *                                                                                       CLE024
     CL0                 MOVE      BRCA          KBRCA                                        CLE024
     CL0                 MOVE      CNUMA         KCNUMA                                       CLE024
     CL0                 MOVE      FACTA         KFACTA                                       CLE024
     CL0                 MOVE      FCNOA         KFCNOA                                       CLE024
     CL0   *IN09         IFEQ      *OFF                                                       CLE041
     CL0   KFCLT         CHAIN     LEFCLTLG                           57                      CLE024
     CL0                 ELSE                                                                 CLE041
     CL0   KFCLT         CHAIN     LEAGFYL4                           57                      CLE041
     CL0                 ENDIF                                                                CLE041
      *                                                                                       CLE039
      ** If CLE039 is installed...                                                            CLE039
      *                                                                                       CLE039
     CL0   CLE039        IFEQ      'Y'                                                        CLE039
     CL0   *IN30         ANDEQ     *ON                                                        CLE039
     CL0                 MOVE      *ON           *IN43                                        CLE039
     CL0                 MOVE      *OFF          *IN45                                        CLE039
     CL0                 MOVE      *OFF          *IN47                                        CLE039
     CL0                 Z-ADD     1             WCOLUM            1 0                        CLE039
      *                                                                                       CLE039
     CL0   *IN57         IFEQ      *OFF                                                       CLE039
     CL0   FCXCGP        IFNE      *ZERO                                                      248525
     CL0                 CALL      'LE000020'                                                 CLE039
     CL0                 PARM      *BLANKS       PRTCD                                        CLE039
     CL0                 PARM                    FCXCGP                                       CLE039
     CL0                 PARM      *BLANKS       DSELIG                                       CLE039
     CL0                 ENDIF                                                                248525
     CL0                 ENDIF                                                                CLE039
      *                                                                                       CLE039
      ** Report the Customer Group                                                            CLE039
      *                                                                                       CLE039
     CL0   FCXCGP        IFNE      *ZERO                                                      CLE039
     CL0   *IN57         ANDEQ     *OFF                                                       CLE041
     CL0                 MOVE      FCXCGP        WCGRP                                        CLE039
     CL0                 MOVEA     WCGRP         ACG                                          CLE039
     CL0                 Z-ADD     1             I                 2 0                        CLE039
     CL0   ACG(I)        DOWEQ     '0'                                                        CLE039
     CL0                 MOVE      ' '           ACG(I)                                       CLE039
     CL0                 ADD       1             I                                            CLE039
     CL0                 ENDDO                                                                CLE039
     CL0                 MOVEA     ACG           WCGRP                                        CLE039
     CL0                 MOVE      *ON           *IN45                                        CLE039
     CL0                 MOVE      *ON           *IN47                                        CLE039
     CL0   *IN09         IFEQ      *OFF                                                       CLE041
     CL0   P1OP          IFEQ      'Y'                                                        CLE041
     CL0                 EXCEPT    CUSGRP                                                     CLE039
     CL0                 ENDIF                                                                CLE041
     CL0                 ELSE                                                                 CLE041
     CL0   P3OP          IFEQ      'Y'                                                        CLE041
     CL0                 EXCEPT    CUSGR3                                                     CLE041
     CL0                 ENDIF                                                                CLE041
     CL0                 ENDIF                                                                CLE041
     CL0                 MOVE      *OFF          *IN47                                        CLE039
     CL0                 ENDIF                                                                CLE039
      *                                                                                       CLE039
     CL0                 MOVE      CRNM          WCRNM            20                          CLE039
     CL0                 MOVE      BBCUST        WCUST             6                          CLE039
     CL0                 Z-ADD     1             X                 3 0                        CLE039
     CL0                 MOVEA     DSELIG        ARELIG                                       CLE039
      *                                                                                       CLE039
      ** Report the Eligible Customers                                                        CLE039
      *                                                                                       CLE039
     CL0   ARELIG(X)     DOWNE     *BLANKS                                                    CLE039
     CL0                 MOVE      *BLANKS       WECUS            10                          CLE039
     CL0                 MOVEL     ARELIG(X)     WECUS                                        CLE039
      *                                                                                       CLE039
     CL0                 CALL      'AOCUSTR0'                                                 CLE039
     CL0                 PARM      *BLANKS       PRTCD                                        CLE039
     CL0                 PARM      '*KEY   '     POPTN                                        CLE039
     CL0                 PARM      WECUS         PCUST            10                          CLE039
     CL0                 PARM      *BLANKS       PKYST             7                          CLE039
     CL0   SDCUST        PARM      SDCUST        DSSDY                                        CLE039
      *                                                                                       CLE039
     CL0   PRTCD         IFNE      *BLANKS                                                    CLE039
     CL0   *LOCK         IN        LDA                                                        CLE039
     CL0                 MOVEL     'SDCUSTPD'    DBFILE                                       CLE039
     CL0                 MOVEL     WECUS         DBKEY                                        CLE039
     CL0                 Z-ADD     54            DBASE                                        CLE039
     CL0                 OUT       LDA                                                        CLE039
     CL0                 MOVE      *ON           *INU7                                        CLE039
     CL0                 MOVE      *ON           *INU8                                        CLE039
     CL0                 MOVE      *ON           *INLR                                        CLE039
     CL0                 EXSR      *PSSR                                                      CLE039
     CL0                 ENDIF                                                                CLE039
      *                                                                                       CLE039
     CL0   WCOLUM        IFEQ      1                                                          CLE039
     C*L0*******           MOVE ARELIG,X  WCUST1  60                                   CLE039 CSD027
     CL0                 MOVE      ARELIG(X)     WCUST1            6                          CSD027
     CL0                 MOVEL     BBCSSN        WCSSN1           10                          CLE039
     CL0                 MOVEL     CRNM          WCRNM1           20                          CLE039
     CL0                 Z-ADD     2             WCOLUM                                       CLE039
      *                                                                                       CLE039
     CL0                 ELSE                                                                 CLE039
     C*L0*******           MOVE ARELIG,X  WCUST2  60                                   CLE039 CSD027
     CL0                 MOVE      ARELIG(X)     WCUST2            6                          CSD027
     CL0                 MOVE      BBCSSN        WCSSN2           10                          CLE039
     CL0                 MOVE      CRNM          WCRNM2           20                          CLE039
     CL0                 Z-ADD     1             WCOLUM                                       CLE039
      *                                                                                       CLE039
      ** Continue printing on next page when overflow occurs                                  CLE039
      *                                                                                       CLE039
     CL0   *INOF         IFEQ      *ON                                                        CLE039
     CL0   *INOG         OREQ      *ON                                                        CLE041
     CL0                 MOVE      WCRNM         CRNM                                         CLE039
     CL0                 MOVE      WCUST         BBCUST                                       CLE039
     CL0                 MOVE      *ON           *IN43                                        CLE039
     CL0   *IN09         IFEQ      *OFF                                                       CLE041
     CL0   P1OP          IFEQ      'Y'                                                        CLE041
     CL0                 EXCEPT    TOTOU1                                                     CLE039
     CL0                 ENDIF                                                                CLE041
     CL0                 ELSE                                                                 CLE041
     CL0   P3OP          IFEQ      'Y'                                                        CLE041
     CL0                 EXCEPT    TOTO31                                                     CLE041
     CL0                 ENDIF                                                                CLE041
     CL0                 ENDIF                                                                CLE041
     CL0                 ENDIF                                                                CLE039
      *                                                                                       CLE039
     CL0                 MOVE      *ON           *IN44                                        CLE039
      *                                                                                       242371
      ** If multi-customer and  no specific eligible customer                                 242371
      ** print 'ALL' instead of 'NONE'.                                                       242371
      *                                                                                       242371
     CL0                 MOVE      'NONE'        WNONE             4                          242371
     CL0   MCSI          IFEQ      'Y'                                                        242371
     CL0   *IN45         ANDEQ     *OFF                                                       242371
     CL0                 MOVE      'ALL '        WNONE                                        242371
     CL0                 ENDIF                                                                242371
      *                                                                                       242371
     CL0   *IN09         IFEQ      *OFF                                                       CLE041
     CL0   P1OP          IFEQ      'Y'                                                        CLE041
     CL0                 EXCEPT    ELICUS                                                     CLE039
     CL0                 ENDIF                                                                CLE041
     CL0                 ELSE                                                                 CLE041
     CL0   P3OP          IFEQ      'Y'                                                        CLE041
     CL0                 EXCEPT    ELICU3                                                     CLE041
     CL0                 ENDIF                                                                CLE041
     CL0                 ENDIF                                                                CLE041
     CL0                 MOVE      *OFF          *IN43                                        CLE039
     CL0                 ENDIF                                                                CLE039
      *                                                                                       CLE039
     CL0                 ADD       1             X                                            CLE039
     CL0                 ENDDO                                                                CLE039
      *                                                                                       CLE039
     CL0                 MOVE      WCRNM         CRNM                                         CLE039
     CL0                 MOVE      WCUST         BBCUST                                       CLE039
      *                                                                                       CLE039
      ** If WCOLUM is 2, still need to print the customer written in column 1                 CLE039
      ***If**IN45*is*off,*there*are*no*eligible*customers*so*print*'NONE'              CLE039 242371
      ** If *IN45 is off, check if multi-customer, then print 'ALL'                           242371
      ** if multi-customer, if not, print 'NONE'.                                             242371
      *                                                                                       CLE039
     CL0   WCOLUM        IFEQ      2                                                          CLE039
     CL0   *IN45         OREQ      *OFF                                                       CLE039
      *                                                                                       CLE039
     CL0   *INOF         IFEQ      *ON                                                        CLE039
     CL0   *INOG         OREQ      *ON                                                        CLE041
     CL0                 MOVE      *ON           *IN43                                        CLE039
     CL0   *IN09         IFEQ      *OFF                                                       CLE041
     CL0   P1OP          IFEQ      'Y'                                                        CLE041
     CL0                 EXCEPT    TOTOU1                                                     CLE039
     CL0                 ENDIF                                                                CLE041
     CL0                 ELSE                                                                 CLE041
     CL0   P3OP          IFEQ      'Y'                                                        CLE041
     CL0                 EXCEPT    TOTO31                                                     CLE041
     CL0                 ENDIF                                                                CLE041
     CL0                 ENDIF                                                                CLE041
     CL0                 ENDIF                                                                CLE039
      *                                                                                       CLE039
     CL0                 MOVE      *OFF          *IN44                                        CLE039
     CL0   *IN09         IFEQ      *OFF                                                       CLE041
     CL0   P1OP          IFEQ      'Y'                                                        CLE041
     CL0                 EXCEPT    ELICUS                                                     CLE039
     CL0                 ENDIF                                                                CLE041
     CL0                 ELSE                                                                 CLE041
     CL0   P3OP          IFEQ      'Y'                                                        CLE041
     CL0                 EXCEPT    ELICU3                                                     CLE041
     CL0                 ENDIF                                                                CLE041
     CL0                 ENDIF                                                                CLE041
     CL0                 ENDIF                                                                CLE039
      *                                                                                       CLE039
     CL0                 MOVE      *OFF          *IN43                                        CLE039
      *                                                                                       CLE039
      ** <End> If CLE039 is installed                                                         CLE039
      *                                                                                       CLE039
     CL0                 ENDIF                                                                CLE039
      *                                                                                       CLE024
      ** Print the Collateralised Lending fields                                              CLE024
      *                                                                                       CLE024
     CL0   CLE039        IFEQ      'Y'                                                        CLE039
     CL0   *IN30         ANDEQ     *ON                                                        CLE039
     CL0   CLE025        OREQ      'Y'                                                        CLE025
     CL0   *IN30         ANDEQ     *ON                                                        CLE025
     CL0   CLE024        OREQ      'Y'                                                        CLE024
     CL0   *IN30         ANDEQ     *ON                                                        CLE024
     CL0   CFX001        OREQ      'Y'                                                        CFX001
     CL0   *IN30         ANDEQ     *ON                                                        CFX001
      *                                                                                       CLE039
     CL0   CLE039        IFEQ      'Y'                                                        CLE039
     CL0                 MOVEL     FCXDEA        WXDEA                                        CLE039
     CL0                 ENDIF                                                                CLE039
      *                                                                                       CLE024
     CL0   CLE024        IFEQ      'Y'                                                        CLE024
     CL0                 MOVE      FCXPOR        WXPOR                                        CLE024
     CL0                 MOVE      FCXLVR        WXLVR                                        CLE024
     CL0                 MOVE      FCXALV        WXALV                                        CLE024
     CL0                 MOVE      FCXLVA        WXLVA                                        CLE024
     CL0                 MOVE      FCXLVW        WXLVW                                        CLE024
     CL0                 MOVE      FCXSTC        WXSTC                                        CLE024
     CL0                 MOVE      FCXPWF        WXPWF                                        CLE024
     CL0                 MOVE      FCXPIS        WXPIS                                        CLE024
     CL0                 ENDIF                                                                CLE024
      *                                                                                       CFX001
     CL0   CFX001        IFEQ      'Y'                                                        CFX001
     CL0   CLE025        OREQ      'Y'                                                        CLE025
     CL0                 MOVE      FCXOML        WXOML                                        CFX001
     CL0                 MOVEL     FCXMST        WXMST                                        CFX001
     CL0                 ENDIF                                                                CFX001
      *                                                                                       CLE039
      ** Write facility extension details to LE0300P1.                                        CLE039
      ** Continue printing on next page when overflow occurs                                  CLE039
      *                                                                                       CLE039
     CL0   *IN09         IFEQ      *OFF                                                       CLE041
     CL0   P1OP          IFEQ      'Y'                                                        CLE041
     CL0   *INOF         IFEQ      *ON                                                        CLE039
     CL0                 MOVE      *ON           *IN43                                        CLE039
     CL0                 EXCEPT    TOTOU1                                                     CLE039
     CL0                 ENDIF                                                                CLE039
     CL0                 EXCEPT    XFCLT1                                                     CLE039
      *                                                                                       CLE024
     CL0   *INOF         IFEQ      *ON                                                        CLE024
     CL0                 MOVE      *ON           *IN43                                        CLE024
     CL0                 EXCEPT    TOTOU1                                                     CLE024
     CL0                 ENDIF                                                                CLE024
     CL0                 EXCEPT    XFCLT2                                                     CLE024
      *                                                                                       CLE024
     CL0   *INOF         IFEQ      *ON                                                        CLE024
     CL0                 MOVE      *ON           *IN43                                        CLE024
     CL0                 EXCEPT    TOTOU1                                                     CLE024
     CL0                 ENDIF                                                                CLE024
     CL0                 EXCEPT    XFCLT3                                                     CLE024
      *                                                                                       CLE024
     CL0   *INOF         IFEQ      *ON                                                        CLE024
     CL0                 MOVE      *ON           *IN43                                        CLE024
     CL0                 EXCEPT    TOTOU1                                                     CLE024
     CL0                 ENDIF                                                                CLE024
     CL0                 EXCEPT    XFCLT4                                                     CLE024
      *                                                                                       CLE024
     CL0   *INOF         IFEQ      *ON                                                        CLE024
     CL0                 MOVE      *ON           *IN43                                        CLE024
     CL0                 EXCEPT    TOTOU1                                                     CLE024
     CL0                 ENDIF                                                                CLE024
     CL0                 EXCEPT    XFCLT5                                                     CLE024
      *                                                                                       CFX001
     CL0   *INOF         IFEQ      *ON                                                        CFX001
     CL0                 MOVE      *ON           *IN43                                        CFX001
     CL0                 EXCEPT    TOTOU1                                                     CFX001
     CL0                 ENDIF                                                                CFX001
     CL0                 EXCEPT    XFCLT6                                                     CFX001
     CL0                 ENDIF                                                                CLE041
      *                                                                                       CLE039
     CL0                 ELSE                                                                 CLE041
      *                                                                                       CLE041
     CL0   P3OP          IFEQ      'Y'                                                        CLE041
     CL0   *INOG         IFEQ      *ON                                                        CLE041
     CL0                 MOVE      *ON           *IN43                                        CLE041
     CL0                 EXCEPT    TOTO31                                                     CLE041
     CL0                 ENDIF                                                                CLE041
     CL0                 EXCEPT    XFCL31                                                     CLE041
      *                                                                                       CLE041
     CL0   *INOG         IFEQ      *ON                                                        CLE041
     CL0                 MOVE      *ON           *IN43                                        CLE041
     CL0                 EXCEPT    TOTO31                                                     CLE041
     CL0                 ENDIF                                                                CLE041
     CL0                 EXCEPT    XFCL32                                                     CLE041
      *                                                                                       CLE041
     CL0   *INOG         IFEQ      *ON                                                        CLE041
     CL0                 MOVE      *ON           *IN43                                        CLE041
     CL0                 EXCEPT    TOTO31                                                     CLE041
     CL0                 ENDIF                                                                CLE041
     CL0                 EXCEPT    XFCL33                                                     CLE041
      *                                                                                       CLE041
     CL0   *INOG         IFEQ      *ON                                                        CLE041
     CL0                 MOVE      *ON           *IN43                                        CLE041
     CL0                 EXCEPT    TOTO31                                                     CLE041
     CL0                 ENDIF                                                                CLE041
     CL0                 EXCEPT    XFCL34                                                     CLE041
      *                                                                                       CLE041
     CL0   *INOG         IFEQ      *ON                                                        CLE041
     CL0                 MOVE      *ON           *IN43                                        CLE041
     CL0                 EXCEPT    TOTO31                                                     CLE041
     CL0                 ENDIF                                                                CLE041
     CL0                 EXCEPT    XFCL35                                                     CLE041
      *                                                                                       CLE041
     CL0   *INOG         IFEQ      *ON                                                        CLE041
     CL0                 MOVE      *ON           *IN43                                        CLE041
     CL0                 EXCEPT    TOTO31                                                     CLE041
     CL0                 ENDIF                                                                CLE041
     CL0                 EXCEPT    XFCL36                                                     CLE041
     CL0                 ENDIF                                                                CLE041
     CL0                 ENDIF                                                                CLE041
     CL0                 MOVE      *OFF          *IN43                                        CLE039
     CL0                 MOVE      *OFF          *INOF                                        CLE039
     CL0                 MOVE      *OFF          *INOG                                        CLE041
     CL0                 ENDIF                                                                CLE039
     C*                                                                                        MOF60
     C***  ENSURE END OF BRANCH OUTPUT                                                         MOF60
     C*                                                                                        MOF60
     CL1   *IN33         IFEQ      '0'                                                         MOF60
     CL1   *INU7         ANDEQ     '0'                                                         MOF60
     CL1   P1OP          ANDEQ     'Y'                                                         MOF60
     CL1   *IN33         OREQ      '0'                                                        CLE041
     CL1   *INU7         ANDEQ     '0'                                                        CLE041
     CL1   P3OP          ANDEQ     'Y'                                                        CLE041
     CL1   *IN09         ANDEQ     *ON                                                        CLE041
     CL1   *IN75         IFEQ      '0'                                                         13835
     CL1   *IN09         IFEQ      *OFF
     CL1   P1OP          IFEQ      'Y'
     CL1                 EXCEPT    TOTOU1                                                      13835
     CL1                 ENDIF
     CL1                 ELSE
     CL1   P3OP          IFEQ      'Y'
     CL1                 EXCEPT    TOTO31
     CL1                 ENDIF
     CL1                 ENDIF
     CL1                 ELSE                                                                  13835
     CL1   *IN09         IFEQ      *OFF
     CL0   P1OP          IFEQ      'Y'
     CL1                 EXCEPT    TOTOU2                                                      MOF60
     CL1                 ENDIF
     CL1                 ELSE
     CL0   P3OP          IFEQ      'Y'
     CL1                 EXCEPT    TOTO32
     CL1                 ENDIF
     CL1                 ENDIF
     CL0                 MOVE      *OFF          *INOF
     CL1                 MOVE      *OFF          *INOG
     CL1                 ENDIF                                                                 13835
     C***L1******CLE004    IFEQ 'Y'                                CLE004 187663
     CL1   CLE006        IFEQ      'Y'                                                         18766
     CL1   OPEN2         ANDEQ     '1'                                                         CLE00
     CL1   *IN71         IFEQ      *OFF                                                        CLE00
     CL1                 WRITE     HEADP2                                                      CLE00
     CL1                 ENDIF                                                                 CLE00
     CL1                 WRITE     TRAIL2                                                      CLE00
     CL1                 ENDIF                                                                 CLE00
     CL1                 END                                                                   MOF60
      **                                                                  S01117
      **   EXECUTE ERROR ROUTINE IF DATABASE ERROR EXISTS                 S01117
      **                                                                  S01117
     CLR   *INU7         IFEQ      '1'                                                         S0111
     CLR   *INU8         ANDEQ     '1'                                                         S0111
     CLR                 EXSR      *PSSR                                                       S0111
     CLR                 END                                                                   S0111
      **                                                                  S01117
      **   LAST RECORD PROCESSING                                         S01117
      ** ENSURE TOTALS SPOOL FILE RECORDED BY RCF                         S01117
     CLR                 Z-ADD     SFNUMU        ZSNUMU            6 0                         S0111
     C*R********           OUT  LDA                                S01117 MOF60
     CLR                 CALL      'ZSFILE'                                                    S0111
     CLR                 PARM                    SEQ               5                           S0111
     C*R*********          PARM *BLANKS   SENTY   3                S01117 MOF60
     CLR                 PARM      *BLANKS       SENTY                                         MOF60
     CLR                 PARM                    SFILEU                                        S0111
     CLR                 PARM                    ZSNUMU                                        S0111
     CLR                 PARM                    ZSERR                                         S0111
      **                                                                  S01117
     C*R******** *LOCK     IN   LDA                                       MOF60
     CLR   ZSERR         IFEQ      'Y'                                                         S0111
      **  ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAM       S01117
     CLR                 SETON                                        U7U8LR                   S0111
     CLR                 RETURN                                                                S0111
     CLR                 END                                                                   S0111
     C**                                                                  S01117
      **                                                                  S01117
      **  OUTPUT THE FILE CONTROL, IF NOT ALREADY OUTPUT                  S01117
     CLR   *IN67         IFNE      '1'                                                         S0111
     CLR                 SETON                                        66                       S0111
     CLR                 EXCEPT                                                                S0111
     CLR                 SETOFF                                       66                       S0111
     CLR                 END                                                                   S0111
      **********                                                   S01117 MOF60
      ***WHEN*LR*INDICATOR*SET*ON*WITHOUT*EXECUTING*THE*FIRST***   S01117 MOF60
      ***CYCLE**                                                   S01117 MOF60
     C*R******** P1OP      IFNE 'Y'                                S01117 MOF60
     C*R********           EXSR #ZZ                                S01117 MOF60
     C*R********           END                                     S01117 MOF60
     C*                                                                   MOF60
     C***  IF NOT MULTIBRANCH, OUTPUT END OF REPORT MESSAGE               MOF60
     C*                                                                   MOF60
     CLR   MBIN          IFEQ      'N'                                                         MOF60
     CLR   P1OP          ANDEQ     'Y'                                                         MOF60
     CLR   MBIN          OREQ      'N'
     CLR   P3OP          ANDEQ     'Y'
     CLR   *IN09         ANDEQ     *ON
     CLR   *IN75         IFEQ      '0'                                                         13835
     CLR   *IN09         IFEQ      *OFF
     CL0   P1OP          IFEQ      'Y'
     CLR                 EXCEPT    TOTOU1                                                      13835
     CLR                 ENDIF
     CLR                 ELSE
     CL0   P3OP          IFEQ      'Y'
     CLR                 EXCEPT    TOTO31
     CLR                 ENDIF
     CLR                 ENDIF
     CLR                 ELSE                                                                  13835
     CLR   *IN09         IFEQ      *OFF
     CL0   P1OP          IFEQ      'Y'
     CLR                 EXCEPT    TOTOU3                                                      MOF60
     CLR                 ENDIF
     CLR                 ELSE
     CL0   P3OP          IFEQ      'Y'
     CLR                 EXCEPT    TOTO33
     CLR                 ENDIF
     CLR                 ENDIF
     CLR                 ENDIF                                                                 13835
     CLR                 END                                                                   MOF60
     C***LR******CLE004    IFEQ 'Y'                                CLE004 187663
     CLR   CLE006        IFEQ      'Y'                                                         18766
     CLR   MBIN          ANDEQ     'N'                                                         CLE00
     CLR   OPEN2         ANDEQ     '1'                                                         CLE00
     CLR   *INU7         ANDNE     *ON                                                         CLE00
     CLR                 WRITE     TRAIL2                                                      CLE00
     CLR                 END                                                                   CLE00
     C*                                                                   MOF60
     C***  IF ERROR AND P1 OPEN, REPORT IT                                MOF60
     C*                                                                   MOF60
     CLR   P1OP          IFEQ      'Y'                                                         MOF60
     CLR   *IN09         ANDEQ     *OFF
     CLR                 EXCEPT    TOTOUT                                                      MOF60
     CLR                 END                                                                   MOF60
      *                                                                                       CLE041
     CLR   P3OP          IFEQ      'Y'
     CLR   *IN09         ANDEQ     *ON
     CLR                 EXCEPT    TOTO3T
     CLR                 ENDIF
     C***LR******CLE004    IFEQ 'Y'                                CLE004 187663
     CLR   CLE006        IFEQ      'Y'                                                         18766
     CLR   OPEN2         ANDEQ     '1'                                                         CLE00
     CLR   *INU7         ANDEQ     *ON                                                         CLE00
     CLR                 MOVE      *ON           *IN70                                         CLE00
     CLR                 WRITE     TRAIL2                                                      CLE00
     CLR                 END                                                                   CLE00
     C*
     C********************************************************************
     C*
     C*    DETAIL 'A' RECORD PROCESSING
     C*
     C     DETA          BEGSR                                                  *** DETA ***
     C*
     C                   MOVE      *OFF          *IN59
     C                   MOVE      *OFF          *IN60
     C                   MOVE      *OFF          *IN19
     C***********          SETOF                     22                   MOF60
     C***********          SETOF                     282935               MOF60
     C                   SETOFF                                       2235                     MOF60
     C                   SETOFF                                       363738
     C*
     C*    RECORDS D,R,C - CHECK IF ACTIONED TODAY
     C*
     C   02
     COR 03
     C*R*04******LCD       COMP RUND                     22               S01117
     COR 04LCDA          COMP      RUND                                   22                   S0111
     C*
     C*    EXECUTE SUBROUTINE TO COUNT RECORDS READ
     C*
     C                   SETOFF                                       72                       S0111
     C                   EXSR      COUNT
     C*
     C*
     C*    FOR EACH LIVE RECORD (ID = 'D' OR 'E'), MAINTAIN HASH TOTAL
     C*
     C   02
     COR 04              SETON                                        12
     C   12              MOVE      BLANKS        ZZAMT
     C   12              MOVE      FAMT          ZZAMT
     C     *IN12         IFEQ      '1'
     C     FAMT          ANDLT     0
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   END
     C   12              Z-ADD     LVTOTI        ZZTOTI
     C   12              Z-ADD     LVTOTD        ZZTOTD
     C   12              EXSR      GLZADD
     C   12              Z-ADD     ZZTOTI        LVTOTI           15 0
     C   12              Z-ADD     ZZTOTD        LVTOTD            3 0
     C                   SETOFF                                       12
     C*
     C*    IF NOT ACTIONED TODAY, NO FURTHER PROCESSING
     C*
     C  N22              GOTO      ENDA
     C*
     C*    STORE CHANGE TYPE OF 'A' RECORD FOR OUTPUT
     C*
     C***********          MOVE CHTP      ACTN    1                       S01117
     C                   MOVE      CHTPA         ACTN              1                           S0111
     C*
     C*****CHAIN*TO*CUSTOMER*FILE*FOR*CUSTOMER*NAME                       S01194
     C*
     C******               MOVELCNUM      CLINKY  7                       S01117
     C**********           MOVE 'A'       CLINKY                          S01194
     C********** CLINKY    CHAINCLINT                40                   S01194
     C                   MOVEL     CNUMA         CKEY                                          S0119
     C                   MOVEL     *BLANKS       KEYSTS                                        S0119
     C                   CALL      'AOCUSTR0'    PLIST1                                        S0119
     C     @RTCD         IFNE      *BLANKS                                                     S0119
     C     RECIA         ANDNE     'R'                                                         05979
     C                   SETON                                        U7U8LR                   S0119
     C     *LOCK         IN        LDA                                                         MOF60
     C                   MOVE      '02'          DBASE                                         S0119
     C                   MOVE      'SDCUSTPD'    DBFILE                                        S0119
     C                   MOVE      *BLANKS       DBKEY                                         MOF60
     C                   MOVEL     CKEY          DBKEY                                         S0119
     C                   MOVE      'LE0300  '    DBPGM                                         MOF60
     C                   OUT       LDA                                                         MOF60
     C                   GOTO      ENDA                                                        S0119
     C                   END                                                                   S0119
      *                                                                                      BUG3781
     C                   MOVE      BBCUST        FCCUST            6
     C                   MOVE      CRNM          FCCRNM           20
      *                                                                   141486
     C                   MOVEL     *BLANKS       TNAM             20                           14148
     C                   MOVEL     *BLANKS       TANM              6                           14148
     C                   MOVEL     *BLANKS       TAFT              3                           14148
     C                   MOVEL     *BLANKS       TAFN              2                           14148
     C                   MOVEL     *BLANKS       RCAXR            14                           18954
     C                   MOVEL     *BLANKS       RCMDI             1                           18954
     C                   MOVEL     *BLANKS       RCOMD             7                           18954
     C/COPY WNCPYSRC,LEH00127
      *                                                                   CLE029
     C                   MOVEL     *BLANKS       RSVCD             9                           CLE02
     C     CLE029        IFEQ      'Y'                                                         CLE02
     C     SVCD          IFEQ      *BLANKS                                                     CLE02
     C     '*MISS'       CAT       'ING*':0      RSVCD                                         CLE02
     C                   ELSE                                                                  CLE02
     C                   MOVEL     SVCD          RSVCD                                         CLE02
     C                   ENDIF                                                                 CLE02
     C                   ENDIF                                                                 CLE02
      *                                                                   CLE029
     C***********CLE004    IFEQ 'Y'                                141486 187663
     C********** CLE006    IFEQ 'Y'                                187663 189544
     C     CLE005        IFEQ      'Y'                                                         18954
     C     SYIN          ANDNE     'Y'                                                         14148
     C********** CANM      IFNE 0                                                      141486 CSD027
     C     CANM          IFNE      *BLANKS
     C     TRCA          ANDEQ     'TR'                                                        14148
     C                   MOVE      *BLANKS       CKEY                                          14148
     C                   MOVEL     CANM          CKEY                                          14148
     C                   MOVEL     *BLANKS       KEYSTS                                        14148
     C                   CALL      'AOCUSTR0'    PLIST1                                        14148
     C     @RTCD         IFNE      *BLANKS                                                     14148
     C     RECIA         ANDNE     'R'                                                         14148
     C     *LOCK         IN        LDA                                                         14148
     C                   MOVE      '11'          DBASE                          ***************14148
     C                   MOVE      'SDCUSTPD'    DBFILE                         * DB ERROR 11 *14148
     C                   MOVE      *BLANKS       DBKEY                          ***************14148
     C                   MOVEL     CKEY          DBKEY                                         14148
     C                   MOVE      'LE0300  '    DBPGM                                         14148
     C                   OUT       LDA                                                         14148
     C                   SETON                                        U7U8LR                   14148
     C                   EXSR      *PSSR                                                       14148
     C                   GOTO      ENDA                                                        14148
     C                   ENDIF                                                                 14148
     C                   MOVEL     CRNM          TNAM                                          14148
     C                   MOVEL     CANM          TANM                                          14148
     C                   MOVEL     CAFT          TAFT                                          14148
     C                   MOVEL     CAFN          TAFN                                          14148
     C/COPY WNCPYSRC,LEH00128
      *                                                                   189544
      ** Format C/A exchange rate                                         189544
      *                                                                   189544
     C                   Z-ADD     8             ZADEC                                         18954
     C                   MOVEL     *BLANKS       ZFIELD                                        18954
     C                   MOVE      CAXR          ZFIELD                                        18954
     C                   EXSR      ZEDIT                                                       18954
     C                   MOVE      ZFIELD        RCAXR            14                           18954
      *                                                                   189544
      * Move cmdi to rcmdi                                                189544
      *                                                                   189544
     C                   MOVEL     CMDI          RCMDI             1                           18954
      ******************************************************************               189544 246031
      **Format*COMD*to*ddmmyy*******************************************               189544 246031
      ******************************************************************               189544 246031
     C********** COMD      IFGT 0                                                      189544 246031
     C**********           MOVE *ON       *IN81                                        189544 246031
     C**********           Z-ADDCOMD      ZDAYNO                                       189544 246031
     C**********           EXSR ZDATE2                                                 189544 246031
     C**********           MOVE ZADATE    WCOMC   7                                    189544 246031
     C**********           MOVELWCOMC     RCOMD                                        189544 246031
     C**********           ENDIF                                                       189544 246031
      *                                                                   189544
     C                   ENDIF                                                                 14148
     C                   ENDIF                                                                 14148
      *                                                                                       246031
      * Format COMD to ddmmyy                                                                 246031
      *                                                                                       246031
     C     COMD          IFGT      0
     C                   MOVE      *ON           *IN81
     C                   Z-ADD     COMD          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        WCOMC             7
     C                   MOVEL     WCOMC         RCOMD
     C                   ENDIF
     C*                                                                   S01194
     C*    DATABASE ERROR IF LIVE RECORD NOT FOUND
     C*
     C**N40***** RECI      COMP 'D'                  4040                 S01194
     C***40*****           SETON                     U7U8LR               S01194
     C***40*****           MOVE '02'      DBASE                           S01194
     C***40*****           MOVE 'CLINT'   DBFILE                          S01194
     C***40*****           MOVELCLINKY    DBKEY                           S01194
     C***40*****           GOTO ENDA                                      S01194
     C*
     C*****CHAIN*TO*TABLE*FILE*FOR*CCY*DECIMAL*PLACES                     S01194
     C*    OBTAIN CCY DECIMAL PLACES FROM AOCURRR0                        S01194
     C*
     C**********           MOVEL'20      'TABKEY 12                       S01194
     C**********           MOVELFCCY      TKEY    4                       S01194
     C**********           MOVE '1'       TKEY                            S01194
     C**********           MOVE TKEY      TABKEY                          S01194
     C********** TABKEY    CHAINTABLE                41                   S01194
     C                   MOVEL     FCCY          CURKEY                                        S0119
     C                   CALL      'AOCURRR0'    PLIST2                                        S0119
     C     @RTCD         IFNE      *BLANKS                                                     S0119
     C                   SETON                                        U7U8LR                   S0119
     C     *LOCK         IN        LDA                                                         MOF60
     C                   MOVE      '03'          DBASE                                         S0119
     C**********           MOVE 'SDCURRR0'DBFILE                   S01194 MOF60
     C                   MOVE      'SDCURRPD'    DBFILE                                        MOF60
     C                   MOVE      *BLANKS       DBKEY                                         MOF60
     C                   MOVEL     CURKEY        DBKEY                                         S0119
     C                   MOVE      'LE0300  '    DBPGM                                         MOF60
     C                   OUT       LDA                                                         MOF60
     C                   GOTO      ENDA                                                        S0119
     C                   END                                                                   S0119
     C*
     C*    DATABASE ERROR IF LIVE RECORD NOT FOUND
     C*
     C**N41***** RECI      COMP 'D'                  4141                 S01194
     C***41*****           SETON                     U7U8LR               S01194
     C***41*****           MOVE '03'      DBASE                           S01194
     C***41*****           MOVE 'TABLE'   DBFILE                          S01194
     C***41*****           MOVELTABKEY    DBKEY                           S01194
     C***41*****           GOTO ENDA                                      S01194
     C*
     C*   DETERMINE NO. DECIMAL PLACES                       35=0
     C*                                                      36=1
     C     CDP           COMP      1                                    3536      37=2
     C  N35
     CANN36CDP           COMP      3                                    3738      38=3
     C*
     C*****SET*INDICATOR*IF*CMMT*FEE*DETAILS*TO*BE*PRINTED******          MOF60
     C***********                                                         MOF60
     C***********FCTI      COMP 'C'                  292928               MOF60
     C*
     C     CLE007        IFEQ      'Y'
     C     SYIN          ANDNE     'Y'
     C                   EXSR      SRREIN
     C                   EXSR      FILCRD
     C                   ENDIF
     C*                                                                   S01408
     C/COPY WNCPYSRC,LE0300CCP2                                           S01408
     C*                                                                   S01408
     C     ULX004        IFEQ      'Y'
     C**********           Z-ADDCNUMA     KCNUM                                       CER001 CSD027A
     C                   MOVE      CNUMA         KCNUM
     C                   Z-ADD     FACTA         KFACT
     C                   Z-ADD     FCNOA         KFCNO
      *                                                                                       CER001
      ** Chian to LEFCX2L0 file for european reporting details                                CER001
      *                                                                                       CER001
     C     KEYMX6        CHAIN     LEFCX2L0                           43
     C     *IN43         IFEQ      '1'
     C**********           Z-ADDCNUMA     VNCNUM                                      CER001 CSD027A
     C                   MOVE      CNUMA         VNCNUM
     C                   Z-ADD     FACTA         VNFACT
     C                   Z-ADD     FCNOA         VNFCNO
     C                   MOVE      'N'           VNSUBR
     C                   MOVE      *BLANKS       VNMOBL
     C                   WRITE     FCLTYMF6
     C                   ENDIF
     C                   ENDIF
      *                                                                                      CER073D
      ** Get AnaCredit Details                                                               CER073D
      *                                                                                      CER073D
     C     CER073        IFEQ      'Y'                                                       CER073D
      *                                                                                      CER073D
      ** AnaCredit Reporting indicator for printing                                          CER073D
      *                                                                                      CER073D
     C                   MOVEL     '1'           *IN21                                       CER073D
     C                   CLEAR                   ANACDS                                      CER073D
     C                   MOVE      *BLANKS       ADTPS                                       CER073D
     C                   MOVE      *BLANKS       DTRS                                        CER073D
     C                   MOVE      *BLANKS       DDSI                                        CER073D
     C                   MOVE      CNUMA         CNUMAA                                      CER073D
     C                   EXSR      FCANAC                                                    CER073D
     C                   ENDIF                                                               CER073D
      *                                                                   138352
      ** Open Printer File LE0300P2 if not yet opened                     138352
      *                                                                   138352
     C***********CLE004    IFEQ 'Y'                                138352 187663
     C     CLE006        IFEQ      'Y'                                                         18766
     C     *IN09         ANDEQ     *OFF
     C     OPEN2         IFNE      '1'                                                         13835
     C                   OPEN      LE0300P2                                                    13835
     C                   Z-ADD     SFNUM2        ZSNUM                                         13835
     C                   CALL      'ZSFILE'                                                    13835
     C                   PARM                    SEQ                                           13835
     C                   PARM      BRCA          SENTY             3                           13835
     C                   PARM                    SFILE2                                        13835
     C                   PARM                    ZSNUM                                         13835
     C                   PARM                    ZSERR             1                           13835
      *                                                                   138352
      ** Error during ZSFILE processing, return to calling program        138352
      *                                                                   138352
     C     ZSERR         IFEQ      'Y'                                                         13835
     C                   SETON                                        U7U8LR                   13835
     C                   RETURN                                                                13835
     C                   ENDIF                                                                 13835
     C                   ENDIF                                                                 13835
     C                   ENDIF                                                                 13835
      *                                                                   138352
     C*
      ** Call routines to format and write to printer file.               CLE004
      *                                                                   CLE004
     C***********CLE004    IFEQ 'Y'                                CLE004 187663
     C     CLE006        IFEQ      'Y'                                                         18766
     C     SYIN          ANDEQ     'Y'                                                         CLE00
     C     OPEN2         ANDEQ     '1'                                                         CLE00
     C     *IN09         ANDEQ     *OFF
     C                   EXSR      REINP2                                                      CLE00
     C                   EXSR      FILLP2                                                      CLE00
     C                   END                                                                   CLE00
      *                                                                   CLE004
     C     ENDA          ENDSR                                                  ** ENDA TAG **
     C*
     C*
     C********************************************************************
     C*
     C*    DETAIL 'B' RECORD PROCESSING
     C*
     C     DETB          BEGSR                                                  *** DETB ***
     C*
     C/COPY WNCPYSRC,LE0300C002
     C*
     C                   SETOFF                                       27
     C*
     C*    EXECUTE SUBROUTINE TO COUNT RECORDS READ
     C*
     C                   SETON                                        72                       S0111
     C                   EXSR      COUNT
     C*
     C*    IF NO INPUT TODAY, NO FURTHER PROCESSING
     C*
     C  N22              GOTO      ENDB
     C*                                                                   MOF60
     C***  THIS NEXT BIT IS NEVER EXECUTED AS IF DO NOT HAVE AN 'A'       MOF60
     C***  REC WITH 'B' REC, THE 'B' WON'T GET ON THE JOINT LF.           MOF60
     C***  SIMILARILY, IF DO NOT HAVE A 'B' WITH AN 'A', THEN RECIB       MOF60
     C***  AND RCTPB ARE BLANK, AND SR/DETB WILL NOT BE EXECUTED.         MOF60
     C***  IF AN 'A' OR 'B' REC IS MISSING, THERE IS NOW ERROR            MOF60
     C***  PROCESSING AT THE START OF MAIN PROCESSING.                    MOF60
     C*                                                                   MOF60
     C**********                                                          MOF60
     C*****CHECK FOLLOWS CORRECT 'A' RECORD                               MOF60
     C**********                                                          MOF60
     C**********                                                          MOF60
     C********** DSA1      COMP DSB1                     27               MOF60
     C**********                                                          MOF60
     C*****IF*NOT SAME, DATABASE ERROR                                    MOF60
     C**********                                                          MOF60
     C**N27******          SETON                     U7U8LR               MOF60
     C**N27******          MOVE '04'      DBASE                           MOF60
     C**N27******          MOVE 'FCLTY'   DBFILE                          MOF60
     C***********                                                         MOF60
     C**N27******          MOVELCNUM      KEY1    9                S01117 MOF60
     C**N27******          MOVE FACT      KEY1                     S01117 MOF60
     C**N27******          MOVELCNUMA     KEY1    9                S01117 MOF60
     C**N27******          MOVE FACTA     KEY1                     S01117 MOF60
     C**N27******          MOVELKEY1      KEY2   11                       MOF60
     C**N27******          MOVE FCNO      KEY2                     S01117 MOF60
     C**N27******          MOVE FCNOA     KEY2                     S01117 MOF60
     C**N27******          MOVELKEY2      DBKEY                           MOF60
     C***********                                                         MOF60
     C*****CHECK*C/FEE*INDICATOR*AND*DETERMINE*WHETHER****                MOF60
     C*****C/FEE*DETAILS*TO*BE*PRINTED*******                             MOF60
     C***********                                                         MOF60
     C***28******CMFT      COMP ' '                      29  C/FEE BLANK  MOF60
     C*
     C*    CONVERT DAYNOS TO DATE FORMAT WHERE APPLICABLE
     C/COPY WNCPYSRC,LE0300C003
     C*
     C     DTAP          COMP      0                                  50
     C   50              Z-ADD     DTAP          ZDAYNO
     C   50              EXSR      ZDATE2
     C   50              MOVE      ZADATE        DTAPO             7
     C*
     C     DTEX          COMP      0                                  51
     C   51              Z-ADD     DTEX          ZDAYNO
     C   51              EXSR      ZDATE2
     C   51              MOVE      ZADATE        DTEXO             7
     C*
     C     DLFS          COMP      0                                  52
     C   52              Z-ADD     DLFS          ZDAYNO
     C   52              EXSR      ZDATE2
     C   52              MOVE      ZADATE        DLFSO             7
     C*
     C     RVDT          COMP      0                                  53
     C   53              Z-ADD     RVDT          ZDAYNO
     C   53              EXSR      ZDATE2
     C   53              MOVE      ZADATE        RVDTO             7
     C*                                                                                      246031A
     C                   MOVE      *BLANKS       WCDTC
     C     CDTE          COMP      0                                  63
     C     *IN63         IFEQ      '1'
     C     *IN11         ANDEQ     '1'
     C                   Z-ADD     CDTE          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        WCDTC
     C                   ENDIF
      *                                                                                       CER020
      ** Check if Feature CER020 is ON                                                        CER020
      *                                                                                       CER020
     C     CER020        IFEQ      'Y'
      *                                                                                       CER020
      ** Initialize fields to BLANKS                                                          CER020
      *                                                                                       CER020
     C                   MOVE      *BLANKS       RPEXD
     C                   MOVE      *BLANKS       RPNXD
      *                                                                                       CER020
      ** Move file field to printer field                                                     CER020
      *                                                                                       CER020
     C     PEXD          IFNE      *ZEROS
      *                                                                                       CER020
     C                   MOVE      PEXD          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        RPEXD
      *                                                                                       CER020
     C                   ENDIF
      *                                                                                       CER020
     C     PNXD          IFNE      *ZEROS
      *                                                                                       CER020
     C                   MOVE      PNXD          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        RPNXD
      *                                                                                       CER020
     C                   ENDIF
      *                                                                                       CER020
     C                   ENDIF
      *                                                                                       CER020
     C*
     C***********STDT      COMP 0                    54                   MOF60
     C**N29*54***          Z-ADDSTDT      ZDAYNO                          MOF60
     C**N29*54***          EXSR ZDATE2                                    MOF60
     C**N29*54***          MOVE ZADATE    STDTO   7                       MOF60
     C***********                                                         MOF60
     C***********EDDT      COMP 0                    55                   MOF60
     C**N29*55***          Z-ADDEDDT      ZDAYNO                          MOF60
     C**N29*55***          EXSR ZDATE2                                    MOF60
     C**N29*55***          MOVE ZADATE    EDDTO   7                       MOF60
     C***********                                                         MOF60
     C***********DUDT      COMP 0                    56                   MOF60
     C**N29*56***          Z-ADDDUDT      ZDAYNO                          MOF60
     C**N29*56***          EXSR ZDATE2                                    MOF60
     C**N29*56***          MOVE ZADATE    DUDTO   7                       MOF60
     C***********                                                         MOF60
     C*****CHECK*BILLING DAYS,*BASE*RATE,*DAYNOS.****                     MOF60
     C*****IF*ZERO*ON*FILE,*PRINT*BLANK*ON*REPORT.***                     MOF60
     C***********BLDY      COMP 0                    57                   MOF60
     C     RVDY          COMP      0                                  58                       MOF60
     C**N29******BCOD      COMP 0                    59                   MOF60
     C**N29******BLDN      COMP 0                    60                   MOF60
     C*                                                                   MOF60
     C** TO OUTPUT PREVIOUS FACILITY AMOUNT OBTAIN DETAILS FROM LAST      MOF60
     C** RECORD ON HISTORY FILE                                           MOF60
     C*                                                                   MOF60
     C                   Z-ADD     FACTA         HFACT                                         MOF60
     C                   Z-ADD     FCNOA         HFCNO                                         MOF60
     C                   MOVE      '0'           *IN78                                         MOF60
     C     *IN09         IFEQ      *OFF
     C     KEY001        SETGT     HISUPD                                                      MOF60
     C     KEY001        READPE    HISUPD                                 88                   MOF60
     C                   ELSE
     C     KEY001        SETGT     LEAGHSL0
     C     KEY001        READPE    LEAGHSL0                               88
     C                   ENDIF
     C** RECORD FOUND ON HISTORY FILE                                     MOF60
     C     *IN88         IFEQ      '0'                                                         MOF60
     C     FAMT          ANDNE     FACFAM                                                      06097
     C     *IN09         ANDEQ     *OFF
     C***********FAMT      ANDNEHAAAMT                             MOF60  060978
     C***********          Z-ADDHAAAMT    PRVAMT 130               MOF60  060978
     C                   Z-ADD     FACFAM        PRVAMT           13 0                         06097
     C                   MOVE      '1'           *IN78                                         MOF60
     C                   END                                                                   MOF60
      *                                                                                       CLE041
     C     *IN88         IFEQ      *OFF
     C     FAMT          ANDNE     AIFCAM
     C     *IN09         ANDEQ     *ON
     C                   Z-ADD     AIFCAM        PRVAMT
     C                   MOVE      *ON           *IN78
     C                   ENDIF
     C*                                                                   MOF60
     C** IF LAST CHANGE DATE FOR REVOLVING CREDIT INDICATOR IS NOT        MOF60
     C** BLANK THEN OUTPUT THIS DATE FOR REFERENCE.                       MOF60
     C*                                                                   058449
     C                   MOVE      '0'           *IN79                                         05844
     C*                                                                   058449
     C     RVCD          IFNE      0                                                           MOF60
     C                   Z-ADD     RVCD          ZDAYNO                                        MOF60
     C                   EXSR      ZDATE2                                                      MOF60
     C                   MOVE      ZADATE        RVCDO             7                           MOF60
     C                   MOVE      '1'           *IN79                                         MOF60
     C                   END                                                                   MOF60
     C*                                                                   MOF60
     C/COPY WNCPYSRC,LE0300C004
     C*    MAINTAIN COUNT NUMBER FACILITIES PRINTED
     C*
     C     NFAC          ADD       1             NFAC              5 0
     C*                                                                   MOF60
     C***  OPEN FILE IF NOT OPEN ALREADY                                  MOF60
     C*                                                                   MOF60
     C     OPENP1        IFEQ      'Y'                                                         MOF60
     C     MBIN          ANDEQ     'Y'                                                         MOF60
     C     *IN09         ANDEQ     *OFF
     C     P1OP          OREQ      ' '                                                         MOF60
     C     MBIN          ANDNE     'Y'                                                         MOF60
     C     *IN09         ANDEQ     *OFF
     C**********                                                                       CLE015 208458
     C**If*CLE007*is*on*populate*the*Currency*Rollover*Details*********                CLE015 208458
     C********** CLE007    IFEQ 'Y'                                                    CLE015 208458
     C**********           EXSR FILCRD                                                 CLE015 208458
     C**********           ENDIF                                                       CLE015 208458
     C                   OPEN      LE0300P1                                                    MOF60
     C*                                                                   MOF60
     C***  SET OFF A FLAG FOR FILE OPENING PROCESSING                     MOF60
     C*                                                                   MOF60
     C                   MOVE      *BLANKS       OPENP1            1                           MOF60
      **                                                                  MOF60
     C                   MOVE      'Y'           P1OP              1                           MOF60
     C*                                                                   MOF60
     C                   Z-ADD     0             PAGE                                          MOF60
     C** ENSURE REPORT SPOOL FILE RECORDED BY RCF                         MOF60
     C                   Z-ADD     SFNUM         ZSNUM             6 0                         MOF60
     C                   CALL      'ZSFILE'                                                    MOF60
     C                   PARM                    SEQ                                           MOF60
     C                   PARM      BRCA          SENTY             3                           MOF60
     C                   PARM                    SFILE                                         MOF60
     C                   PARM                    ZSNUM                                         MOF60
     C                   PARM                    ZSERR             1                           MOF60
     C*                                                                   MOF60
     C     ZSERR         IFEQ      'Y'                                                         MOF60
     C**  ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAM       MOF60
     C                   SETON                                        U7U8LR                   MOF60
     C                   RETURN                                                                MOF60
     C                   END                                                                   MOF60
      *                                                                   CLE004
     C***********CLE004    IFEQ 'Y'                                CLE004 187663
     C     CLE006        IFEQ      'Y'                                                         18766
     C     *IN09         ANDEQ     *OFF
     C     OPEN2         IFNE      '1'                                                         CLE00
     C                   OPEN      LE0300P2                                                    CLE00
     C                   Z-ADD     SFNUM2        ZSNUM                                         CLE00
     C                   CALL      'ZSFILE'                                                    CLE00
     C                   PARM                    SEQ                                           CLE00
     C                   PARM      BRCA          SENTY             3                           CLE00
     C                   PARM                    SFILE2                                        CLE00
     C                   PARM                    ZSNUM                                         CLE00
     C                   PARM                    ZSERR             1                           CLE00
      *                                                                   CLE004
      ** Error during ZSFILE processing, return to calling program        CLE004
      *                                                                   CLE004
     C     ZSERR         IFEQ      'Y'                                                         CLE00
     C                   SETON                                        U7U8LR                   CLE00
     C                   RETURN                                                                CLE00
     C                   ENDIF                                                                 CLE00
     C                   ENDIF                                                                 CLE00
     C                   ENDIF                                                                 CLE00
     C*                                                                   MOF60
     C                   END                                                                   MOF60
      *                                                                                       CLE041
     C     OPENP3        IFEQ      'Y'
     C     MBIN          ANDEQ     'Y'
     C     *IN09         ANDEQ     *ON
     C     P3OP          OREQ      ' '
     C     MBIN          ANDNE     'Y'
     C     *IN09         ANDEQ     *ON
      *                                                                                       CLE041
     C                   OPEN      LE0300P3
      *                                                                                       CLE041
      ** Set off a flag for file opening proccessing                                          CLE041
      *                                                                                       CLE041
     C                   MOVE      *BLANKS       OPENP3            1
      *                                                                                       CLE041
     C                   MOVE      'Y'           P3OP              1
     C                   Z-ADD     0             PAGE
      *                                                                                       CLE041
      ** Ensure report SPOOL3 file recorded by RCF                                            CLE041
      *                                                                                       CLE041
     C                   Z-ADD     SFNUM3        ZSNUM             6 0
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQ
     C                   PARM      BRCA          SENTY
     C                   PARM                    SFILE3
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
      *                                                                                       CLE041
      ** Error during ZSFILE proccessing, return to calling program                           CLE041
      *                                                                                       CLE041
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
     C*
     C*    SET ON INDICATOR FOR OUTPUT TO PRINTER
     C*
     C     SYIN          IFNE      'Y'                                                         13835
     C***/COPY*WNCPYSRC,LEH01005***                                                           CFC006
     C/COPY WNCPYSRC,LEH01005                                                               MD020563
     C     SUPFLG        IFNE      'Y'
     C                   SETON                                        30
     C     CLE007        IFEQ      'Y'                                                         CLE01
     C                   SETON                                        15                       CLE01
     C                   ENDIF                                                                 CLE01
     C***/COPY*WNCPYSRC,LEH01006***                                                           CFC006
     C/COPY WNCPYSRC,LEH01006                                                               MD020563
     C                   ENDIF
     C                   ENDIF                                                                 13835
     C*
     C/COPY WNCPYSRC,LE0300CCP3                                           S01408
     C*
     C     ENDB          ENDSR                                                  ** ENDB TAG **
     C*
     C********************************************************************
     C*
     C*    SUBROUTINE TO COUNT RECORDS INPUT (A & B)
     C*
     C     COUNT         BEGSR                                                  *** COUNT ***
     C*
     C                   SETOFF                                       242526                   S0111
     C*
     C*    FOR EACH LIVE RECORD (ID = 'D' OR 'E'), MAINTAIN COUNT
     C   02
     COR 04
     COR 05
     COR 07NROF          ADD       1             NROF              5 0
     C*
     C*
     C*    IF 'A' RECORD SHOWED NO INPUT TODAY, NO FURTHER PROCESSING
     C*
     C  N22              GOTO      ENDSR
     C*
     C*    DETERMINE CHANGE TYPE
     C*
     C***********CHTP      COMP 'I'                      24               S01117
     C**N24******CHTP      COMP 'A'                      25               S01117
     C**N24N25***CHTP      COMP 'R'                      26               S01117
     C**N24N25N26CHTP      COMP 'C'                      26               S01117
     C*                                                                   S01117
     C*    FOR 'A' PART OF RECORD                                         S01117
     C     *IN72         IFEQ      '0'                                                         S0111
     C     CHTPA         COMP      'I'                                    24                   S0111
     C  N24CHTPA         COMP      'A'                                    25                   S0111
     C  N24
     CANN25CHTPA         COMP      'R'                                    26                   S0111
     C  N24
     CANN25
     CANN26CHTPA         COMP      'C'                                    26                   S0111
     C                   END                                                                   S0111
     C*                                                                   S01117
     C*    FOR 'B' PART OF RECORD                                         S01117
     C     *IN72         IFEQ      '1'                                                         S0111
     C     CHTPB         COMP      'I'                                    24                   S0111
     C  N24CHTPB         COMP      'A'                                    25                   S0111
     C  N24
     CANN25CHTPB         COMP      'R'                                    26                   S0111
     C  N24
     CANN25
     CANN26CHTPB         COMP      'C'                                    26                   S0111
     C                   END                                                                   S0111
     C*
     C*    FOR EACH RECORD AMENDED REVERSED OR CLOSED TODAY,
     C*    CHECK IF ALSO INSERTED TODAY
     C*
     C   25
     COR 26ORED          COMP      RUND                                   24
     C*
     C*    MAINTAIN COUNT NUMBER RECORDS INSERTED
     C*
     C   24NRINS         ADD       1             NRINS             5 0
     C*
     C*    MAINTAIN COUNT NUMBER RECORDS REVERSED/CLOSED
     C*
     C   26NRDEL         ADD       1             NRDEL             5 0
     C*
     C*
     C     ENDSR         ENDSR                                                  ** ENDSR TAG **
     C*
     C*
     C********************************************************************
     C* SUBROUTINE TO ADD AN AMOUNT (ZZAMT) TO THE TOTAL (ZZTOTI,ZZTOTD)
     C*   IND '99' IS SET BY AN OVERFLOW ERROR
     C*
     CSR   GLZADD        BEGSR                                                  *** GLZADD ****
     C*
     CSR                 Z-ADD     ZZAMT         ZZAMT            15 3    91    -DEFINE ZZAMT
     CSR 91              GOTO      ZZAEND                                       AMT = 0.BYPASS
     C*
     C* SPLIT ZZAMT INTO INTEGER AND DECIMAL FIELDS
     CSR                 Z-ADD     ZZAMT         ZZAMTI           15 0          INTEGER FIELD
     CSR                 MOVE      ZZAMT         ZZAMTD            3 0          DECIMAL FIELD
     C* BOTH ZZAMTI AND ZZAMTD CONTAIN A 'SIGN' ZONE NOW
     C*
     CSR                 EXSR      GLZSUM
     CSR   ZZAEND        ENDSR                                                  ** ZZAEND TAG *
     C*
     C********************************************************************
     C* SUBROUTINE TO CARRY OUT THE ADDITION FOR SUBROUTINES -
     C*                        GLZADD, GLZSUB, GLZCMP.
     C*          PARAMETERS PASSED -
     C*                     I/P ZZAMTI ZZAMTD
     C*                     O/P ZZTOTI ZZTOTD ZZNEGD IND 96 IND 99.
     C*
     CSR   GLZSUM        BEGSR                                                  *** GLZSUM ****
     C*
     CSR                 Z-ADD     ZZTOTI        ZZTOTI           15 0          DEFINE ZZTOTI
     CSR                 Z-ADD     ZZTOTD        ZZTOTD            3 0          DEFINE ZZTOTD
     CSR                 SETOFF                                       919293
     CSR                 SETOFF                                       949599
     C*
     C*    DETERMINE SIGN OF ZZAMTI & D,   92 IF NEG
     CSR   ZZAMTI        COMP      0                                    9293
     CSR 93ZZAMTD        COMP      0                                    9293
     CSR 93              GOTO      ZZSEND                                       ZERO BYPASS
     C*
     C*    DETERMINE SIGN OF ZZTOTI & D, 91 IF NEG.
     CSR   ZZTOTI        COMP      0                                    9193
     CSR 93ZZTOTD        COMP      0                                    9193
     C*
     C*    IF ZZTOTAL IS ZERO, RETURN ZZAMOUNT.
     CSR 93              Z-ADD     ZZAMTI        ZZTOTI
     CSR 93              Z-ADD     ZZAMTD        ZZTOTD
     CSR 93              GOTO      ZZSEND                                       ZERO BYPASS
     C*    IF SIGNS DIFFER BYPASS OVERFLOW CHECKS.
     CSR 91
     CANN92
     CORN91
     CAN 92              GOTO      ZZOFPS
     C*
     CSR   ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
     CSR   ZZWK2         COMP      999                                93        '93' = CARRY
     CSRN93ZZWK2         COMP      -999                                 93        INTO INTEGER.
     C*
     CSR 93
     CANN92ZZAMTI        ADD       1             ZZWK3            15 0          ADD 'CARRY' +VE
     CSR 93
     CAN 92ZZAMTI        SUB       1             ZZWK3                          SUB 'CARRY' -VE
     CSR 93ZZTOTI        ADD       ZZWK3         ZZWK3
     CSRN93ZZTOTI        ADD       ZZAMTI        ZZWK3
     C*
     C* IF THE MODULUS OF ZZWK3 IS LT MOD. ZZTOTI THEN O/F HAS OCCURED
     CSRN92ZZWK3         COMP      ZZTOTI                               99      -92 MEANS NOS.
     CSR 92ZZWK3         COMP      ZZTOTI                             99         NEGATIVE
     CSRN99              Z-ADD     ZZWK2         ZZTOTD
     CSRN99              Z-ADD     ZZWK3         ZZTOTI
     C*
     C* IF O/F ZEROIZE ZZAMT , IND '99' SET AND ZZTOT FIELDS LEFT INTACT.
     CSR 99              Z-ADD     0             ZZAMT            15 3
     CSR                 GOTO      ZZSEND
     C*
     C* THE 'SIGNS' ARE DIFFERENT
     CSR   ZZOFPS        TAG                                                    ** ZZOFPS TAG**
     C* IF ZZAMT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZTOT
     C*
     CSR 92              Z-SUB     ZZAMTI        ZZAMTI           15 0
     CSR 92              Z-SUB     ZZAMTD        ZZAMTD            3 0
     C*
     C* IF ZZTOT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZAMT.
     C*
     CSR 91              Z-SUB     ZZTOTI        ZZTOTI
     CSR 91              Z-SUB     ZZTOTD        ZZTOTD
     C* BOTH ZZAMT AND ZZTOT ARE NOW POSITIVE.
     C*
     CSR   ZZTOTI        COMP      ZZAMTI                             93  95
     CSR 95ZZTOTD        COMP      ZZAMTD                             93  95
     C*
     C* IF ZZTOT EQ. ZZAMT RETURN ZERO.
     CSR 95              Z-ADD     0             ZZTOTI
     CSR 95              Z-ADD     0             ZZTOTD
     CSR 95              GOTO      ZZSEND
     C*
     C* IF ZZTOT GT. ZZAMT.
     CSR 93ZZAMTD        COMP      ZZTOTD                             94
     CSR 93
     CAN 94ZZTOTI        SUB       1             ZZTOTI
     CSR 93
     CAN 94ZZTOTD        ADD       1000          ZZWK2
     CSR 93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     CSR 93
     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     CSR 93
     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
     C*
     C*
     C* IF ZZAMT GT. ZZTOT.
     CSRN93ZZTOTD        COMP      ZZAMTD                             94
     CSRN93
     CAN 94ZZAMTI        SUB       1             ZZWK3            15 0
     CSRN93
     CAN 94ZZAMTD        ADD       1000          ZZWK2
     CSRN93
     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     CSRN93
     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
     CSRN93
     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     CSRN93
     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
     C*
     C* REVERSE SIGN OF ZZTOT IF LARGER I/P FIELDS WERE NEGATIVE
     CSR                 SETOFF                                       94
     CSR 93
     CAN 91
     CORN93
     CAN 92              SETON                                        94
     CSR 94              Z-SUB     ZZTOTI        ZZTOTI
     CSR 94              Z-SUB     ZZTOTD        ZZTOTD
     C**
     C**   RESTORE SIGN OF ZZAMTI & ZZAMTD IF IT WAS REVERSED.
     CSR 92              Z-SUB     ZZAMTI        ZZAMTI
     CSR 92              Z-SUB     ZZAMTD        ZZAMTD
     CSR   ZZSEND        TAG                                                    ** ZZSEND TAG *
     C**
     C**   IF ZZTOTD IS ZERO, AND ZZTOTI IS NEG. SET UP ZZNEGD.
     CSR                 SETOFF                                       96
     CSR   ZZTOTD        COMP      0                                      91
     CSR 91ZZTOTI        COMP      0                                    96
     CSR 96              MOVE      '.000-'       ZZNEGD            5
     CSR                 ENDSR                                                    ** ENDSR **
     C*
     C********************************************************************
     C*
     C*    TRAILER PROCESSING
     C*
     C     TRLR          BEGSR                                                  *** TRLR ***
     C*
     C*****IF*NO*FACILITIES*TO*PRINT,*OUTPUT*MESSAGE****                  S01117
     C*
     C     NFAC          COMP      0                                      34
     C***34******          SETON                     67OF                 S01117
     C***67******          EXCPT                                          S01117
     C***********          SETOF                     67                   S01117
     C*
     C*    VERIFY TOTAL NUMBER RECORDS ON FILE CONTROLS
     C*
     C     NLRB          ADD       NINS          FCONT             5 0
     C     FCONT         SUB       NDEL          FCONT
     C     FCONT         COMP      NLRA                                   31
      *                                                                                       CLE041
     C     CLE025        IFEQ      'Y'
     C                   READ      LEAGFZPD                               10
     C                   ENDIF
      *                                                                                       CLE041
      ** Verify total number of reocrds on file controls                                      CLE041
      *                                                                                       CLE041
     C     CLE025        IFEQ      'Y'
     C     *IN10         ANDEQ     *OFF
     C     AGNLRB        ADD       AGNINS        WFCONT            5 0
     C     WFCONT        SUB       AGNDEL        WFCONT
     C     WFCONT        COMP      AGNLRA                                 31
      *                                                                                       CLE041
     C     NINS          ADD       AGNINS        WNINS
     C     NDEL          ADD       AGNDEL        WNDEL
      *                                                                                       CLE041
     C                   ELSE
     C                   Z-ADD     NINS          WNINS
     C                   Z-ADD     NDEL          WNDEL
     C                   ENDIF
     C*
     C*    IF NOT EQUAL SET SWITCH AND SKIP FURTHER CHECKS
     C*
     C**N31*****           SETON                     U8                                       236008
     C***U8*****           GOTO EXCPT                                                         236008
     C     *IN31         IFEQ      '0'
     C                   SETON                                        11
     C                   ENDIF
     C*
     C*    VERIFY HASH TOTALS ON FILE CONTROLS
     C*
     C*    VALUE LIVE RECORDS BEFORE INPUT:
     C                   Z-ADD     VLBF          ZZAMTI
     C                   MOVE      VLBL          ZZAMTD
     C                   Z-ADD     0             ZZTOTI
     C                   Z-ADD     0             ZZTOTD
     C                   EXSR      GLZSUM
     C                   Z-ADD     VLBF          WVLBF
     C                   Z-ADD     VLBL          WVLBL
     C     CLE025        IFEQ      'Y'
     C     *IN10         ANDEQ     *OFF
     C                   Z-ADD     AGVLBF        ZZAMTI
     C                   Z-ADD     AGVLBL        ZZAMTD
     C                   EXSR      GLZSUM
     C                   ADD       AGVLBF        WVLBF
     C     VLBL          ADD       AGVLBL        WTMP40            4 0
     C     WTMP40        IFGT      999
     C                   ADD       1             WVLBF
     C                   ENDIF
     C                   MOVE      WTMP40        WVLBL
     C                   ENDIF
     C*
     C*    ADD VALUE INSERTIONS:
     C                   Z-ADD     VRIF          ZZAMTI
     C                   MOVE      VRIL          ZZAMTD
     C                   EXSR      GLZSUM
     C                   Z-ADD     VRIF          WVRIF
     C                   Z-ADD     VRIL          WVRIL
     C     CLE025        IFEQ      'Y'
     C     *IN10         ANDEQ     *OFF
     C                   Z-ADD     AGVRIF        ZZAMTI
     C                   Z-ADD     AGVRIL        ZZAMTD
     C                   EXSR      GLZSUM
     C                   ADD       AGVRIF        WVRIF
     C     VRIL          ADD       AGVRIL        WTMP40
     C     WTMP40        IFGT      999
     C                   ADD       1             WVRIF
     C                   ENDIF
     C                   MOVE      WTMP40        WVRIL
     C                   ENDIF
     C*
     C*    ADD VALUE AMENDMENTS:
     C                   Z-ADD     VRAF          ZZAMTI
     C                   MOVE      VRAL          ZZAMTD
     C                   EXSR      GLZSUM
     C     CLE025        IFEQ      'Y'
     C     *IN10         ANDEQ     *OFF
     C                   Z-ADD     AGVRAF        ZZAMTI
     C                   Z-ADD     AGVRAL        ZZAMTD
     C                   EXSR      GLZSUM
     C                   ENDIF
     C*
     C*    CHANGE SIGN OF VALUE DELETIONS, AND ADD
     C                   Z-SUB     VRDF          VRDF
     C                   Z-SUB     VRDL          VRDL
     C                   Z-ADD     VRDF          ZZAMTI
     C                   MOVE      VRDL          ZZAMTD
     C                   EXSR      GLZSUM
     C*
     C*    RESTORE SIGN OF VALUE DELETIONS
     C                   Z-SUB     VRDF          VRDF
     C                   Z-SUB     VRDL          VRDL
      *                                                                                       CLE041
     C                   Z-ADD     VRDF          WVRDF
     C                   Z-ADD     VRDL          WVRDL
     C     CLE025        IFEQ      'Y'
     C     *IN10         ANDEQ     *OFF
     C                   Z-SUB     AGVRDF        ZZAMTI
     C                   Z-SUB     AGVRDL        ZZAMTD
     C                   EXSR      GLZSUM
     C                   ADD       AGVRDF        WVRDF
     C     VRDL          ADD       AGVRDL        WTMP40
     C     WTMP40        IFGT      999
     C                   ADD       1             WVRDF
     C                   ENDIF
     C                   MOVE      WTMP40        WVRDL
     C                   ENDIF
      *                                                                                       CLE041
     C     CLE025        IFEQ      'Y'
     C     *IN10         ANDEQ     *OFF
      *                                                                                       CLE041
      ** Compare above hash totals with file controls                                         CLE041
      *                                                                                       CLE041
     C     VLAF          ADD       AGVLAF        WVLAF
     C     VLAL          ADD       AGVLAL        WTMP40
     C     WTMP40        IFGT      999
     C                   ADD       1             WVLAF
     C                   ENDIF
     C                   MOVE      WTMP40        WVLAL
     C     NLRA          ADD       AGNLRA        WNLRA
     C     NLRB          ADD       AGNLRB        WNLRB
      *                                                                                       CLE041
     C     ZZTOTI        COMP      WVLAF                                  31
     C   31ZZTOTD        COMP      WVLAL                                  31
      *                                                                                       CLE041
      ** If equal,compare with report hash totals                                             CLE041
      *                                                                                       CLE041
     C   31NROF          COMP      WNLRA                                  31
     C   31LVTOTI        COMP      WVLAF                                  31
     C   31LVTOTD        COMP      WVLAL                                  31
      *                                                                                       CLE041
     C                   ELSE
     C*
     C*    COMPARE ABOVE HASH TOTALS WITH FILE CONTROLS
     C*
     C     ZZTOTI        COMP      VLAF                                   31
     C   31ZZTOTD        COMP      VLAL                                   31
     C*
     C*    IF EQUAL, COMPARE WITH REPORT HASH TOTALS
     C*
     C   31NROF          COMP      NLRA                                   31
     C   31LVTOTI        COMP      VLAF                                   31
     C   31LVTOTD        COMP      VLAL                                   31
      *                                                                                       CLE041
     C                   Z-ADD     NLRA          WNLRA
     C                   Z-ADD     NLRB          WNLRB
     C                   Z-ADD     VLAF          WVLAF
     C                   Z-ADD     VLAL          WVLAL
     C                   ENDIF
     C*
     C**N31*****           SETON                     U8                                       236008
     C     *IN31         IFEQ      '0'
     C                   SETON                                        11
     C                   ENDIF
     C*
     C     EXCPT         TAG                                                    ** EXCPT TAG **
     C*
     C*    CHECK VALUE FOR EDITING ON REPORT
     C*
     C     VRAF          COMP      0                                    65
     C  N65VRAL          COMP      0                                    65
     C   65              Z-SUB     VRAL          VRAL
      *                                                                                       CLE041
     C                   Z-ADD     VRAF          WVRAF
     C                   Z-ADD     VRAL          WVRAL
      *                                                                                       CLE041
     C     CLE025        IFEQ      'Y'
     C     *IN10         ANDEQ     *OFF
      *                                                                                       CLE041
      ** Check value for editing on report  for AGFCLTZZ                                      CLE041
      *                                                                                       CLE041
     C     AGVRAF        COMP      0                                    65
     C  N65AGVRAL        COMP      0                                    65
     C   65              Z-SUB     AGVRAL        AGVRAL
      *                                                                                       CLE041
     C                   ADD       AGVRAF        WVRAF
     C     VRAL          ADD       AGVRAL        WTMP40
     C     WTMP40        IFGT      999
     C                   ADD       1             WVRAF
     C                   ENDIF
     C                   MOVE      WTMP40        WVRAL
     C                   ENDIF
     C*
     C*    EXCEPTION OUTPUT FOR FILE CONTROLS
     C*
     C***********          SETON                     66OF                 S01117
     C                   SETON                                        6667                     S0111
     C                   EXCEPT
     C                   SETOFF                                       66
     C                   SETON                                        31
     C*
     C*    IF FILE CONTROLS BALANCE, UPDATE FACILITY TRAILER
     C*   ALSO CHECK FOR PREVIOUS DATABASE ERROR                          S01117
     C*
     C***31N34*************EXSR UPDATE                                    S01117
     C   31
     CANN34
     CANNU8              EXSR      UPDATE                                                      S0111
     C*
     C                   ENDSR
     C*
     C*
     C********************************************************************MOF60
     C***********                                                         MOF60
     C*****ZSYSTM*SR.*TO*CHAIN*TO*THE*INSTALLATION*CONTROL*DATA*RECORD.***MOF60
     C***********                                                         MOF60
     C***********ZSYSTM    BEGSR                           *** ZSYSTM *** MOF60
     C***********                                                         MOF60
     C*****SET*UP*KEY*FOR*INSTALLATION*CONTROL*RECORD.********************MOF60
     C***********          MOVEL'01      'ZTABKY 12                S01194 MOF60
     C***********          MOVE '  10'    ZTABKY                   S01194 MOF60
     C***********ZTABKY    CHAINTABLE                99    ON NOT THERE   MOF60
     C*****ACCESS*BANK*DETAILS*************************************S01194 MOF60
     C***********                                                  S01194 MOF60
     C***********          CALL 'AOBANKR0'PLISTA                   S01194 MOF60
     C***********@RTCD     COMP *BLANKS              9999          S01194 MOF60
     C***********                                                  S01194 MOF60
     C**N99******RECI      COMP 'D'                  9999  ON, DEL S01194 MOF60
     C***********                                                         MOF60
     C*****CHECK*SYSTEM*DATE*FORMAT,*DDMMYY*OR*MMDDYY.********************MOF60
     C***********DATF      COMP 'M'                      98MMDDYY  S01194 MOF60
     C***********BJDFIN    COMP 'M'                      98MMDDYY  S01194 MOF60
     C***********                                                         MOF60
     C***********          ENDSR                                          MOF60
     C***********                                                         MOF60
     C***********                                                         MOF60
     C********************************************************************
     C*
     C*    IF CONTROLS BALANCE, UPDATE TRAILER RECORD
     C*
     C     UPDATE        BEGSR                                                  *** UPDATE ***
     C*
     C                   Z-ADD     0             NINS
     C                   Z-ADD     0             NDEL
     C                   Z-ADD     0             VRIF
     C                   Z-ADD     0             VRIL
     C                   Z-ADD     0             VRDF
     C                   Z-ADD     0             VRDL
     C                   Z-ADD     0             VRAF
     C                   Z-ADD     0             VRAL
     C                   Z-ADD     NLRA          NLRB
     C                   Z-ADD     VLAF          VLBF
     C                   Z-ADD     VLAL          VLBL
     C*
     C     CLE025        IFEQ      'Y'
     C                   Z-ADD     0             AGNINS
     C                   Z-ADD     0             AGNDEL
     C                   Z-ADD     0             AGVRIF
     C                   Z-ADD     0             AGVRIL
     C                   Z-ADD     0             AGVRDF
     C                   Z-ADD     0             AGVRDL
     C                   Z-ADD     0             AGVRAF
     C                   Z-ADD     0             AGVRAL
     C                   Z-ADD     AGNLRA        AGNLRB
     C                   Z-ADD     AGVLAF        AGVLBF
     C                   Z-ADD     AGVLAL        AGVLBL
     C                   UPDATE    AGFCTYZF
     C                   ENDIF
     C*
     C                   ENDSR
     C*
     C*
     C********************************************************************
     C*                                                                   S01117
     C* *PSSR  --- SUBROUTINE TO HANDLE ABNORMAL ERROR CONDITIONS         S01117
     C*                                                                   S01117
     C* CALLED FROM: AFTER ABNORNAL OPERATION OCCURS                      S01117
     C*                                                                   S01117
     C* CALLS: NOTHING                                                    S01117
     C*                                                                   S01117
     C********************************************************************S01117
     C*                                                                   S01117
     C     *PSSR         BEGSR                                                  ** *PSSR **    S0111
     C*                                                                   S01117
     C     WRUN          IFEQ      *BLANKS                                                     S0111
     C                   MOVE      'Y'           WRUN              1                           S0111
     C                   DUMP                                                                  S0111
     C                   END                                                                   S0111
     C*                                                                   S01117
     C                   ENDSR                                                  ** *PSSR **    S0111
      *                                                                   CLE004
      /EJECT                                                              CLE004
     C*/COPY*ZSRSRC,ZFRPEDZ3*********                                                 CLE004 CER073D
     C/COPY ZSRSRC,ZFRPEDZ2LE                                                                CER073D
      ** Sub-routine to insert decimal point.                             CLE004
      *                                                                   CLE004
      /EJECT                                                              CLE004
     C**/COPY ZSRSRC,ZEDITZ2                                       CLE004 149037
     C*/COPY*ZSRSRC,ZEDITZ2L*********                                                 149037 CER073D
     C/COPY ZSRSRC,ZEDITZ2LE                                                                 CER073D
      ** Sub-routine to format rate.                                      CLE004
      *                                                                   CLE004
      /EJECT                                                              CLE004
      *****************************************************************   CLE004
      *  FILLP2 - subroutine to fill up the report details in LE0300P2*   CLE004
      *                                                               *   CLE004
      *  Called by: DETA                                              *   CLE004
      *  Calls: *PSSR                                                 *   CLE004
      *                                                               *   CLE004
      *****************************************************************   CLE004
      *                                                                   CLE004
     C     FILLP2        BEGSR                                                  *** FILLP2 *** CLE00
      *                                                                   CLE004
     C                   MOVE      *ON           *IN71                                         CLE00
      *                                                                   CLE004
      ** Format principal amount                                          CLE004
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
     C                   Z-ADD     PRVAMT        ZFLD15                                        CLE00
     C                   EXSR      ZFRPED                                                      CLE00
     C     ZNEG          IFEQ      '-'                                                         CLE00
     C                   MOVEL     ZOUT18        RPRV0                                         CLE00
     C                   ELSE                                                                  CLE00
     C                   MOVEL     ZOUT17        RPRV0                                         CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
      ** Format Over Line %                                               CLE004
      *                                                                   CLE004
     C                   Z-ADD     3             ZADEC                                         CLE00
     C                   MOVEL     *BLANKS       ZFIELD                                        CLE00
     C                   MOVE      OVPC          ZFIELD                                        CLE00
     C                   EXSR      ZEDIT                                                       CLE00
     C                   MOVE      ZFIELD        ROVPC                                         CLE00
      *                                                                                       CLE034
      ** Format Over Line Amount                                                              CLE034
      *                                                                                       CLE034
     C     CLE034        IFEQ      'Y'
     C                   Z-ADD     OVAM          ZFLD15
     C                   EXSR      ZFRPED
     C     ZNEG          IFEQ      '-'
     C                   MOVEL     ZOUT18        ROVAM
     C                   ELSE
     C                   MOVEL     ZOUT17        ROVAM
     C                   ENDIF
     C                   ENDIF
      *                                                                   CLE004
      ** Format Nominal Rate                                              CLE004
      *                                                                   CLE004
     C                   Z-ADD     7             ZADEC                                         CLE00
     C                   MOVEL     *BLANKS       ZFIELD                                        CLE00
     C                   MOVE      NOMR          ZFIELD                                        CLE00
     C                   EXSR      ZEDIT                                                       CLE00
     C                   MOVE      ZFIELD        RNOMR                                         CLE00
      *                                                                   CLE004
      ** Format new amount                                                CLE004
      *                                                                   CLE004
     C                   Z-ADD     FAMT          ZFLD15                                        CLE00
     C                   EXSR      ZFRPED                                                      CLE00
     C     ZNEG          IFEQ      '-'                                                         CLE00
     C                   MOVEL     ZOUT18        RFAM0                                         CLE00
     C                   ELSE                                                                  CLE00
     C                   MOVEL     ZOUT17        RFAM0                                         CLE00
     C                   ENDIF                                                                 CLE00
     C                   MOVE      RFAM0         RFA20                                         CLE00
      *                                                                   CLE004
      ** Convert dates to ddmmmyy format                                  CLE004
      *                                                                   CLE004
     C     RVCD          IFGT      0                                                           CLE00
     C                   Z-ADD     RVCD          ZDAYNO                                        CLE00
     C                   EXSR      ZDATE2                                                      CLE00
     C                   MOVE      ZADATE        RRVCD                                         CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
     C     COMD          IFGT      0                                                           CLE00
     C                   MOVE      *ON           *IN81                                         CLE00
     C                   Z-ADD     COMD          ZDAYNO                                        CLE00
     C                   EXSR      ZDATE2                                                      CLE00
     C                   MOVE      ZADATE        WCOMC             7                           CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
     C     CDTE          IFGT      0                                                           CLE00
     C                   MOVE      *ON           *IN82                                         CLE00
     C*********************Z-ADDCOMD      ZDAYNO                   CLE004 140832
     C                   Z-ADD     CDTE          ZDAYNO                                        14083
     C                   EXSR      ZDATE2                                                      CLE00
     C                   MOVE      ZADATE        WCDTC             7                           CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
     C     AVLD          IFGT      0                                                           CLE00
     C                   MOVE      *ON           *IN83                                         CLE00
     C*********************Z-ADDCOMD      ZDAYNO                   CLE004 140832
     C                   Z-ADD     AVLD          ZDAYNO                                        14083
     C                   EXSR      ZDATE2                                                      CLE00
     C                   MOVE      ZADATE        WAVLC             7                           CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
     C     JDTE          IFGT      0                                                           CLE00
     C                   MOVE      *ON           *IN84                                         CLE00
     C*********************Z-ADDCOMD      ZDAYNO                   CLE004 140832
     C                   Z-ADD     JDTE          ZDAYNO                                        14083
     C                   EXSR      ZDATE2                                                      CLE00
     C                   MOVE      ZADATE        WJDTC             7                           CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
     C     DTAP          IFGT      0                                                           CLE00
     C                   MOVE      *ON           *IN50                                         CLE00
     C                   Z-ADD     DTAP          ZDAYNO                                        CLE00
     C                   EXSR      ZDATE2                                                      CLE00
     C                   MOVE      ZADATE        RDTAP                                         CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
     C     DTEX          IFGT      0                                                           CLE00
     C                   MOVE      *ON           *IN51                                         CLE00
     C                   Z-ADD     DTEX          ZDAYNO                                        CLE00
     C                   EXSR      ZDATE2                                                      CLE00
     C                   MOVE      ZADATE        RDTEX                                         CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
      ** Check if Feature CER020 is ON                                                        CER020
      *                                                                                       CER020
     C     CER020        IFEQ      'Y'
      *                                                                                       CER020
      ** Initialize fields to BLANKS                                                          CER020
      *                                                                                       CER020
     C                   MOVE      *BLANKS       RPEXD
     C                   MOVE      *BLANKS       RPNXD
      *                                                                                       CER020
      ** Move file field to printer field                                                     CER020
      *                                                                                       CER020
     C     PEXD          IFNE      *ZEROS
      *                                                                                       CER020
     C                   MOVE      PEXD          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        RPEXD
      *                                                                                       CER020
     C                   ENDIF
      *                                                                                       CER020
     C     PNXD          IFNE      *ZEROS
      *                                                                                       CER020
     C                   MOVE      PNXD          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        RPNXD
      *                                                                                       CER020
     C                   ENDIF
      *                                                                                       CER020
     C                   ENDIF
      *                                                                                       CER020
     C     DLFS          IFGT      0                                                           CLE00
     C                   MOVE      *ON           *IN52                                         CLE00
     C                   Z-ADD     DLFS          ZDAYNO                                        CLE00
     C                   EXSR      ZDATE2                                                      CLE00
     C                   MOVE      ZADATE        RDLFS                                         CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
     C     RVDT          IFGT      0                                                           CLE00
     C                   MOVE      *ON           *IN53                                         CLE00
     C                   Z-ADD     RVDT          ZDAYNO                                        CLE00
     C                   EXSR      ZDATE2                                                      CLE00
     C                   MOVE      ZADATE        RRVDT                                         CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
      ** Write Report Header.                                             CLE004
      *                                                                   CLE004
     C                   WRITE     HEADP2                                                      CLE00
      *                                                                   CLE004
     C                   MOVEL     ACOF          RACOF                                         CLE00
     C                   MOVEL     CRNM          RCNAM                                         CLE00
     C                   MOVEL     BBCUST        RCNUM                                         CLE00
     C                   MOVEL     FCTI          RFCTI                                         CLE00
     C                   MOVEL     FCCY          RFCCY                                         CLE00
     C                   MOVEL     RVCR          RRVCR                                         CLE00
     C                   MOVEL     MCCY          RMCCY                                         CLE00
     C                   MOVEL     CRSK          RCRSK                                         CLE00
     C                   MOVEL     ORBR          RORBR                                         CLE00
     C                   MOVEL     MBFC          RMBFC                                         CLE00
      *                                                                   CLE004
     C     *IN39         IFEQ      '1'
     C                   MOVEL     IUSR          RIUSR                                         14793
     C                   MOVEL     AUSR          RAUSR                                         14793
     C                   MOVEL     XUSR          RXUSR                                         14793
     C                   ENDIF
      *                                                                   147935
     C                   MOVEL     FACTA         RFACT                                         CLE00
     C                   MOVEL     FCNOA         RFCNO                                         CLE00
     C                   MOVEL     MCSI          RMCSI                                         CLE00
     C                   MOVEL     NACD          RNACD                                         CLE00
     C                   MOVEL     BTIN          RBTIN                                         CLE00
     C                   MOVEL     RVFR          RRVFR                                         CLE00
     C                   MOVEL     ORBR          RORBR                                         CLE00
     C                   MOVEL     LAID          RLAID                                         CLE00
      *                                                                   CLE004
     C                   MOVEL     SECI          RSECI                                         CLE00
     C                   MOVEL     NAR1          RNAR1                                         CLE00
     C                   MOVEL     NAR2          RNAR2                                         CLE00
     C                   MOVEL     NAR3          RNAR3                                         CLE00
     C                   MOVEL     NAR4          RNAR4                                         CLE00
     C                   Z-ADD     BLDY          RBLDY                                         CLE00
     C/COPY WNCPYSRC,LEH00091
      *                                                                                     BUG12715
      ** Save current value of indicator 58                                                 BUG12715
      *                                                                                     BUG12715
     C                   MOVE      *IN58         WIN58             1
     C     RVDY          COMP      0                                  58
     C                   Z-ADD     RVDY          RRVDY                                         CLE00
     C                   MOVE      ACTN          RACTN                                         CLE00
      *                                                                   CLE004
      ** Syndicate details                                                CLE004
      *                                                                   CLE004
     C********** ANUM      IFNE 0                                                      CLE004 CSD027
     C     ANUM          IFNE      *BLANKS
     C                   MOVE      *BLANKS       CKEY                                          CLE00
     C                   MOVEL     ANUM          CKEY                                          CLE00
     C                   MOVEL     *BLANKS       KEYSTS                                        CLE00
     C                   CALL      'AOCUSTR0'    PLIST1                                        CLE00
     C     @RTCD         IFNE      *BLANKS                                                     CLE00
     C     RECIA         ANDNE     'R'                                                         CLE00
     C     *LOCK         IN        LDA                                                         CLE00
     C                   MOVE      '09'          DBASE                          ***************CLE00
     C                   MOVE      'SDCUSTPD'    DBFILE                         * DB ERROR 09 *CLE00
     C                   MOVE      *BLANKS       DBKEY                          ***************CLE00
     C                   MOVEL     CKEY          DBKEY                                         CLE00
     C                   MOVE      'LE0300  '    DBPGM                                         CLE00
     C                   OUT       LDA                                                         CLE00
     C                   SETON                                        U7U8LR                   CLE00
     C                   EXSR      *PSSR                                                       CLE00
     C                   GOTO      ENDF                                                        CLE00
     C                   END                                                                   CLE00
     C                   MOVEL     CRNM          RSNAM                                         CLE00
     C                   END                                                                   CLE00
      *                                                                   CLE004
     C                   MOVEL     ANUM          RANUM                                         CLE00
     C                   Z-ADD     DICB          RDICB                                         CLE00
      *                                                                   CLE004
      ***Output*currency*rollover details if CLE006 is *ON.        CLE006 189544
      ** Output currency rollover details if CLE005 is *ON.               189544
      *                                                                   CLE006
     C********** CLE006    IFEQ 'N'                                CLE006 189544
     C     CLE005        IFEQ      'N'                                                         18954
     C                   MOVE      *OFF          *IN48                                         CLE00
      *                                                                   CLE006
     C                   ELSE                                                                  CLE00
     C                   MOVE      *ON           *IN48                                         CLE00
     C                   Z-ADD     0             WICTR             2 0                         CLE00
     C     1             DO        6             WICTR                                         CLE00
     C                   Z-ADD     WICTR         WINDX             2 0                         CLE00
     C     WINDX         IFNE      6                                                           CLE00
     C     CLE028        OREQ      'Y'
     C     CLE028        IFEQ      'Y'
     C                   SUBST     DTPX:WINDX    WCVAR
     C                   ELSE
     C                   SUBST     DTPS:WINDX    WCVAR             1                           CLE00
     C                   ENDIF
     C                   SELECT                                                                CLE00
     C     WINDX         WHENEQ    1                                                           CLE00
     C                   CAT       WCVAR:0       RDTPS                                         CLE00
     C     WINDX         WHENNE    1                                                           CLE00
     C                   CAT       WCVAR:1       RDTPS                                         CLE00
     C                   ENDSL                                                                 CLE00
     C                   ENDIF                                                                 CLE00
     C                   SUBST     RTPS:WINDX    WCVAR                                         CLE00
     C                   SELECT                                                                CLE00
     C     WINDX         WHENEQ    1                                                           CLE00
     C                   CAT       WCVAR:0       RRTPS                                         CLE00
     C     WINDX         WHENNE    1                                                           CLE00
     C                   CAT       WCVAR:1       RRTPS                                         CLE00
     C                   ENDSL                                                                 CLE00
      *                                                                   CLE006
     C     WINDX         IFGT      1                                                           CLE00
     C                   MULT      3             WINDX                                         CLE00
     C                   SUB       2             WINDX                                         CLE00
     C                   ENDIF                                                                 CLE00
     C                   SUBST     ALCY:WINDX    WYVAR             3                           CLE00
     C                   SELECT                                                                CLE00
     C     WINDX         WHENEQ    1                                                           CLE00
     C                   CAT       WYVAR:0       RALC1                                         CLE00
     C     WINDX         WHENNE    1                                                           CLE00
     C                   CAT       WYVAR:1       RALC1                                         CLE00
     C                   ENDSL                                                                 CLE00
     C                   ADD       18            WINDX                                         CLE00
     C                   SUBST     ALCY:WINDX    WYVAR                                         CLE00
     C                   SELECT                                                                CLE00
     C     WINDX         WHENEQ    19                                                          CLE00
     C                   CAT       WYVAR:0       RALC2                                         CLE00
     C     WINDX         WHENNE    19                                                          CLE00
     C                   CAT       WYVAR:1       RALC2                                         CLE00
     C                   ENDSL                                                                 CLE00
     C                   ENDDO                                                                 CLE00
      *                                                                   CLE006
     C                   Z-ADD     RLPD          RRLPD                                         CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE006
     C                   MOVEL     WCOMC         RCOMD                                         CLE00
     C                   MOVEL     LPBR          RLPBR                                         CLE00
     C                   MOVEL     DFTP          RDFTP                                         CLE00
     C                   MOVEL     DFST          RDFST                                         CLE00
     C                   MOVEL     DFCL          RDFCL
     C                   MOVEL     CSEL          RCSEL                                         CLE00
      *                                                                   CLE006
     C                   MOVEL     WCDTC         RCDTE                                         CLE00
     C                   MOVEL     LPTP          RLPTP                                         CLE00
     C                   MOVEL     WAVLC         RAVLD                                         CLE00
      *                                                                   CLE004
      ** Format late payment penalty amount.                              CLE004
      *                                                                   CLE004
     C     LPTP          IFEQ      'A'
      *                                                                                      BUG4166
     C                   Z-ADD     LPAM          ZFLD15                                        CLE00
     C                   EXSR      ZFRPED                                                      CLE00
     C     ZNEG          IFEQ      '-'                                                         CLE00
     C                   MOVEL     ZOUT18        RLPA0                                         CLE00
     C                   ELSE                                                                  CLE00
     C                   MOVEL     ZOUT17        RLPA0                                         CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                                      BUG4166
      ** Else, rate was used                                                                 BUG4166
      *                                                                                      BUG4166
     C                   ELSE
      *                                                                                      BUG4166
     C     LPTP          IFEQ      'P'
     C                   Z-ADD     7             ZADEC
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      LPAM          ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        RLPA0
     C                   ENDIF
     C                   ENDIF
      *                                                                   CLE004
     C********** CANM      IFNE 0                                                      CLE004 CSD027
     C     CANM          IFNE      *BLANKS
     C                   MOVE      *BLANKS       CKEY                                          CLE00
     C                   MOVEL     CANM          CKEY                                          CLE00
     C                   MOVEL     *BLANKS       KEYSTS                                        CLE00
     C                   CALL      'AOCUSTR0'    PLIST1                                        CLE00
     C     @RTCD         IFNE      *BLANKS                                                     CLE00
     C     RECIA         ANDNE     'R'                                                         CLE00
     C     *LOCK         IN        LDA                                                         CLE00
     C                   MOVE      '10'          DBASE                          ***************CLE00
     C                   MOVE      'SDCUSTPD'    DBFILE                         * DB ERROR 10 *CLE00
     C                   MOVE      *BLANKS       DBKEY                          ***************CLE00
     C                   MOVEL     CKEY          DBKEY                                         CLE00
     C                   MOVE      'LE0300  '    DBPGM                                         CLE00
     C                   OUT       LDA                                                         CLE00
     C                   SETON                                        U7U8LR                   CLE00
     C                   EXSR      *PSSR                                                       CLE00
     C                   GOTO      ENDF                                                        CLE00
     C                   END                                                                   CLE00
     C                   MOVEL     CRNM          RTNAM                                         CLE00
     C                   END                                                                   CLE00
      *                                                                   CLE004
     C                   MOVEL     TRCA          RTRCA                                         CLE00
     C                   MOVE      CANM          RCANM                                         CLE00
     C                   MOVEL     ACSQ          RACSQ                                         CLE00
     C                   Z-ADD     CAFT          RCAFT                                         CLE00
     C                   Z-ADD     CAFN          RCAFN                                         CLE00
     C/COPY WNCPYSRC,LEH00129
      *                                                                   CLE004
     C     PRTR          IFNE      'A'                                                         CLE00
     C     PRTR          ANDNE     *BLANKS                                                     14083
     C                   MOVE      *ON           *IN49                                         CLE00
     C                   ENDIF                                                                 CLE00
      ** Distinguish between Funding, Internal, Risk & Sub Participants                       CLE106
      *                                                                                       CLE106
     C     CLE106        IFEQ      'Y'
     C     PRTR          ANDEQ     'I'
     C                   MOVE      *ON           *IN59
     C                   ENDIF
      *                                                                                       CLE106
     C     CLE106        IFEQ      'Y'
     C     PRTR          ANDEQ     'S'
     C                   MOVE      *ON           *IN60
     C                   ENDIF
      *                                                                                       CLE106
      ** Risk Participants have extra details on the Extension File                           CLE106
      *                                                                                       CLE106
     C     CLE106        IFEQ      'Y'
     C     PRTR          ANDEQ     'R'
     C                   MOVE      *ON           *IN19
     C                   ENDIF
      *                                                                                       CLE106
     C                   WRITE     DETAL1                                                      CLE00
      *                                                                                     BUG12715
      ** Restore value of indicator 58                                                      BUG12715
      *                                                                                     BUG12715
     C                   MOVE      WIN58         *IN58
      *                                                                                       CLE024
      ** Access the facility extension detail file                                            CLE024
      *                                                                                       CLE024
     C                   MOVE      *BLANKS       RXDEA
     C                   MOVE      *BLANKS       RXPOR
     C                   Z-ADD     *ZERO         RXLVR
     C                   Z-ADD     *ZERO         RXALV
     C                   Z-ADD     *ZERO         RXLVA
     C                   Z-ADD     *ZERO         RXLVW
     C                   MOVE      *BLANKS       RXSTC
     C                   Z-ADD     *ZERO         RXPWF
     C                   Z-ADD     *ZERO         RXPIS
     C                   MOVE      *BLANKS       RXOMLT           20
     C                   MOVE      *BLANKS       RXOML
     C                   MOVE      *BLANKS       RXMST
     C                   MOVEA     *BLANKS       ARELIG
     C                   MOVEA     *BLANKS       ACG
      *                                                                                       CLE024
     C                   MOVE      BRCA          KBRCA
     C                   MOVE      CNUMA         KCNUMA
     C                   MOVE      FACTA         KFACTA
     C                   MOVE      FCNOA         KFCNOA
     C     KFCLT         CHAIN     LEFCLTLG                           57
      *                                                                                       CLE024
      ** If CLE039 is installed... (for LE0300P2)                                             CLE039
      *                                                                                       CLE039
     C     CLE039        IFEQ      'Y'
     C     *IN22         ANDEQ     *ON
     C                   MOVE      *ON           *IN54
     C                   MOVE      *OFF          *IN45
     C                   MOVE      *OFF          *IN47
     C                   Z-ADD     1             WCOLUM
      *                                                                                       CLE039
     C     *IN57         IFEQ      *OFF
     C     FCXCGP        IFNE      *ZERO
     C                   CALL      'LE000020'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    FCXCGP
     C                   PARM      *BLANKS       DSELIG
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE039
      ** Report the Customer Group                                                            CLE039
      *                                                                                       CLE039
     C     FCXCGP        IFNE      *ZERO
     C                   MOVE      FCXCGP        RCGRP
     C                   MOVEA     RCGRP         ACG
     C                   Z-ADD     1             I
     C     ACG(I)        DOWEQ     '0'
     C                   MOVE      ' '           ACG(I)
     C                   ADD       1             I
     C                   ENDDO
     C                   MOVEA     ACG           RCGRP
     C                   MOVE      *ON           *IN45
     C                   MOVE      *ON           *IN47
     C                   ENDIF
      *                                                                                       CLE039
      ** If multi-customer and  no specific eligible customer                                 242371
      ** print 'ALL' instead of 'NONE'.                                                       242371
     C                   MOVE      'NONE'        RNONE
     C     MCSI          IFEQ      'Y'
     C     *IN45         ANDEQ     *OFF
     C                   MOVE      'ALL '        RNONE
     C                   ENDIF
      *
     C                   Z-ADD     1             X                 3 0
     C                   MOVEA     DSELIG        ARELIG
      *                                                                                       CLE039
      ** Report the Eligible Customers                                                        CLE039
      *                                                                                       CLE039
     C     ARELIG(X)     DOWNE     *BLANKS
     C                   MOVE      *BLANKS       WECUS
     C                   MOVEL     ARELIG(X)     WECUS
      *                                                                                       CLE039
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WECUS         PCUST
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *                                                                                       CLE039
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     WECUS         DBKEY
     C                   Z-ADD     53            DBASE
     C                   OUT       LDA
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   GOTO      ENDF
     C                   ENDIF
      *                                                                                       CLE039
     C     WCOLUM        IFEQ      1
     C                   MOVE      ARELIG(X)     RCUST1
     C                   MOVEL     BBCSSN        RCSSN1
     C                   MOVEL     CRNM          RCRNM1
     C                   Z-ADD     2             WCOLUM
      *                                                                                       CLE039
     C                   ELSE
     C                   MOVE      ARELIG(X)     RCUST2
     C                   MOVEL     BBCSSN        RCSSN2
     C                   MOVEL     CRNM          RCRNM2
     C                   Z-ADD     1             WCOLUM
      *                                                                                       CLE039
      ** Continue printing on next page when overflow occurs                                  CLE039
      *                                                                                       CLE039
     C     *IN55         IFEQ      *ON
     C                   WRITE     HEADP2
     C                   WRITE     HEADCU
     C                   MOVE      *ON           *IN54
     C                   MOVE      *OFF          *IN55
     C                   ENDIF
      *                                                                                       CLE039
     C                   MOVE      *ON           *IN56
     C                   WRITE     DETAL5
     C                   MOVE      *OFF          *IN54
     C                   MOVE      *OFF          *IN47
     C                   ENDIF
      *                                                                                       CLE039
     C                   ADD       1             X
     C                   ENDDO
      *                                                                                       CLE039
      ** If WCOLUM is 2, still need to print the customer written in column 1                 CLE039
      ***If**IN45*is*off,*there*are*no*eligible*customers*so*print*'NONE'              CLE039 242371
      ** If *IN45 is off, check if multi-customer, then print 'ALL'                           242371
      ** if multi-customer, if not, print 'NONE'.                                             242371
      *                                                                                       CLE039
     C     WCOLUM        IFEQ      2
     C     *IN45         OREQ      *OFF
      *                                                                                       CLE039
     C     *IN55         IFEQ      *ON
     C                   WRITE     HEADP2
     C                   WRITE     HEADCU
     C                   MOVE      *ON           *IN54
     C                   MOVE      *OFF          *IN55
     C                   ENDIF
      *                                                                                       CLE039
     C                   MOVE      *OFF          *IN56
     C                   WRITE     DETAL5
     C                   MOVE      *OFF          *IN54
     C                   ENDIF
      *                                                                                       CLE039
      ** <End> If CLE039 is installed (for LE0300P2)                                          CLE039
      *                                                                                       CLE039
     C                   ENDIF
      *                                                                                       CLE039
     C     CLE039        IFEQ      'Y'
     C     CLE025        OREQ      'Y'
     C     CLE024        OREQ      'Y'
     C     CFX001        OREQ      'Y'
     C     CLE106        OREQ      'Y'
      *                                                                                       CLE039
     C     CLE039        IFEQ      'Y'
     C                   MOVEL     FCXDEA        RXDEA
     C                   ENDIF
      *                                                                                       CLE039
     C     CLE024        IFEQ      'Y'
     C                   MOVE      FCXPOR        RXPOR
     C                   MOVE      FCXLVR        RXLVR
     C                   MOVE      FCXALV        RXALV
     C                   MOVE      FCXLVA        RXLVA
     C                   MOVE      FCXLVW        RXLVW
     C                   MOVE      FCXSTC        RXSTC
     C                   MOVE      FCXPWF        RXPWF
     C                   MOVE      FCXPIS        RXPIS
     C                   ENDIF
      *                                                                                       CLE024
     C     CFX001        IFEQ      'Y'
     C     CLE025        OREQ      'Y'
      *                                                                                       CFX001
      ** Format overall margin dealing limit                                                  CFX001
      *                                                                                       CFX001
     C                   Z-ADD     FCXOML        ZFLD15
     C                   EXSR      ZFRPED
     C     ZNEG          IFEQ      '-'
     C                   MOVEL     ZOUT18        RXOMLT
     C                   ELSE
     C                   MOVEL     ZOUT17        RXOMLT
     C                   ENDIF
     C                   MOVE      RXOMLT        RXOML
      *                                                                                       CFX001
     C                   MOVEL     FCXMST        RXMST
     C                   ENDIF
      *                                                                                       CLE106
      ** Risk Participants have extra details on the Extension File                           CLE106
      *                                                                                       CLE106
     C     CLE106        IFEQ      'Y'
     C     *IN19         ANDEQ     *ON
      *                                                                                       CLE106
      ** Default Risk Loan Type / Subtype:                                                    CLE106
     C                   MOVEL     FCXRLT        RDRTP
     C                   MOVEL     FCXRLS        RDRST
     C                   MOVEL     FCXRLC        RDRCL
      *                                                                                       CLE106
      ** Fee Base Rate Code:                                                                  CLE106
      *                                                                                       CLE106
     C                   MOVEL     FCXFBC        RFBCD
      *                                                                                       CLE106
      ** Format Fee Base Rate:                                                                CLE106
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      FCXFBR        ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        RFBRT
      *                                                                                       CLE106
      ** Format Fee Spread                                                                    CLE106
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      FCXFSR        ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        RFERA
      *                                                                                       CLE106
      ** Fee Spread Sign (+ or -)                                                             CLE106
     C                   MOVEL     FCXSRS        RFERS
      *                                                                                       CLE106
     C                   ENDIF
      *                                                                                       CFX001
      ** Continue printing on next page when overflow occurs                                  CLE039
      *                                                                                       CLE039
     C     *IN55         IFEQ      *ON
     C                   WRITE     HEADP2
     C                   WRITE     HEADCU
     C                   MOVE      *ON           *IN54
     C                   MOVE      *OFF          *IN55
     C                   ENDIF
      *                                                                                       CLE039
      ** Write the facility extension details to LE0300P2                                     CLE039
      *                                                                                       CLE039
     C                   WRITE     DETAL6
      *                                                                                       CLE039
     C                   ENDIF
      *                                                                   CLE004
      ** Participant details                                              CLE004
      *                                                                   CLE004
     C     PRTR          IFNE      'A'                                                         CLE00
     C     PRTR          ANDNE     *BLANKS                                                     14083
     C***********KPART     CHAINLEPARTL3             46            CLE004 140832
      *                                                                   CLE004
     C************IN46     IFEQ *OFF                               CLE004 140832
     C**********           Z-ADDPMFC      RPMFC                                        CLE004 CSD027
     C                   MOVE      PMFC          RPMFC
     C                   Z-ADD     PMFT          RPMFT                                         CLE00
     C                   Z-ADD     PMFN          RPMFN                                         CLE00
     C/COPY WNCPYSRC,LEH00125
      *                                                                   CLE004
     C                   MOVE      INUM          RINUM                                         CLE00
     C                   MOVEL     WJDTC         RJDTE                                         CLE00
     C***********          MOVELDRTP      RDRTP                    CLE004 140832
     C***********          MOVELDRST      RDRST                    CLE004 140832
      *                                                                   CLE004
      ***Format*Share*amount                                       CLE004 140832
      ***********                                                  CLE004 140832
     C***********          Z-ADDSHAM      ZFLD15                   CLE004 140832
     C***********          EXSR ZFRPED                             CLE004 140832
     C***********ZNEG      IFEQ '-'                                CLE004 140832
     C***********          MOVELZOUT18    RSHA0                    CLE004 140832
     C***********          ELSE                                    CLE004 140832
     C***********          MOVELZOUT17    RSHA0                    CLE004 140832
     C***********          ENDIF                                   CLE004 140832
      *                                                                   CLE004
      ** Format Share Percentage                                          CLE004
      *                                                                   CLE004
     C***********          Z-ADD8         ZADEC                    CLE004 149037
     C                   Z-ADD     12            ZADEC                                         14903
     C                   MOVEL     *BLANKS       ZFIELD                                        CLE00
     C                   MOVE      SHPC          ZFIELD                                        CLE00
     C                   EXSR      ZEDIT                                                       CLE00
     C                   MOVE      ZFIELD        RSHPC                                         CLE00
      *                                                                   CLE004
      ** Format Skim Interest Rate                                        CLE004
      *                                                                   CLE004
     C                   Z-ADD     7             ZADEC                                         CLE00
     C                   MOVEL     *BLANKS       ZFIELD                                        CLE00
     C                   MOVE      SKIR          ZFIELD                                        CLE00
     C                   EXSR      ZEDIT                                                       CLE00
     C                   MOVE      ZFIELD        RSKIR                                         CLE00
      *                                                                   CLE004
      ** Format Skim Fees Rate                                            CLE004
      *                                                                   CLE004
     C                   MOVEL     *BLANKS       ZFIELD                                        CLE00
     C                   MOVE      SKFR          ZFIELD                                        CLE00
     C                   EXSR      ZEDIT                                                       CLE00
     C                   MOVE      ZFIELD        RSKFR                                         CLE00
      *                                                                   CLE004
      ** Format Fee Spread                                                CLE004
      *                                                                   CLE004
     C***********          MOVEL*BLANKS   ZFIELD                   CLE004 140832
     C***********          MOVE FERA      ZFIELD                   CLE004 140832
     C***********          EXSR ZEDIT                              CLE004 140832
     C***********          MOVE ZFIELD    RFERA                    CLE004 140832
      *                                                                   CLE004
     C                   MOVEL     SHTP          RSHTP                                         CLE00
     C                   MOVEL     RCSI          RRCSI                                         CLE00
     C                   MOVEL     PASI          RPASI                                         14726
     C***********          MOVELPTAI      RPTAI                    CLE004 140832
      *                                                                   CLE004
     C                   MOVEL     SKIS          RSKIS                                         CLE00
     C                   MOVEL     SKFS          RSKFS                                         CLE00
     C***********          Z-ADDFEBR      RFEBR                    CLE004 140832
     C***********          MOVELFERS      RFERS                    CLE004 140832
     C                   MOVEL     PRTR          RPRTR
      *                                                                   CLE004
     C     CLE031        IFEQ      'Y'
     C                   MOVE      COAG          RCOAG
     C                   MOVE      FCAG          RFCAG
     C                   MOVE      PHAG          RPHAG
     C                   MOVE      SCAG          RSCAG
     C                   ENDIF
      *                                                                   140832
      ***  Check that sufficient lines remain for the Format. If not,     140832
      ***  write out the Main Headings on a new page.                     140832
      *                                                                   140832
     C                   Z-ADD     33            RQDLN2                                        14083
     C     OFLLN2        SUB       PRTLN2        DIFLN2                                        14083
     C     DIFLN2        IFLE      RQDLN2                                                      14083
     C                   WRITE     HEADP2                                                      14083
     C                   WRITE     HEADCU                                                      14083
     C                   ENDIF                                                                 14083
     C                   WRITE     DETAL2                                                      CLE00
     C***********          ENDIF                                   CLE004 140832
      *                                                                   140832
      ** Receipt settlement instructions                                  140832
      *                                                                   140832
     C                   Z-ADD     RSTM          RRSTM                                         14083
     C                   MOVE      RONS          RRONS                                         14083
     C**********           Z-ADDROCN      RROCN                                        140832 CSD027
     C**********           Z-ADDROBN      RROBN                                        140832 CSD027
     C                   MOVE      ROCN          RROCN
     C                   MOVE      ROBN          RROBN
     C                   MOVE      RIBN          RRIBN                                         14083
     C                   MOVE      RIBA          RRIBA                                         14083
      *                                                                   140832
      ** Payment settlement instructions                                  140832
      *                                                                   140832
     C                   Z-ADD     PSTM          RPSTM                                         14083
     C                   MOVE      PONS          RPONS                                         14083
     C                   MOVE      CVMR          RCVMR                                         14083
     C                   MOVE      RVNO          RRVNO                                         14083
     C**********           Z-ADDPOCN      RPOCN                                        140832 CSD027
     C**********           Z-ADDPOBN      RPOBN                                        140832 CSD027
     C                   MOVE      POCN          RPOCN
     C                   MOVE      POBN          RPOBN
     C                   MOVEL     RCRN          RRCRN                                         14083
     C                   MOVEL     RCRA          RRCRA                                         14083
     C                   MOVEL     PIBN          RPIBN                                         14083
     C                   MOVEL     PIBA          RPIBA                                         14083
     C                   MOVEL     AWBN          RAWBN                                         14083
     C                   MOVEL     AWBA          RAWBA                                         14083
     C                   MOVEL     BENN          RBENN                                         14083
     C                   MOVEL     BENA          RBENA                                         14083
     C                   MOVEL     DTP1          RDTP1                                         14083
     C                   MOVEL     DTP2          RDTP2                                         14083
     C                   MOVEL     DTP3          RDTP3                                         14083
     C                   MOVEL     DTP4          RDTP4                                         14083
     C                   MOVEL     DCHG          RDCHG                                         14083
     C                   MOVEL     BTB1          RBTB1                                         14083
     C                   MOVEL     BTB2          RBTB2                                         14083
     C                   MOVEL     BTB3          RBTB3                                         14083
     C                   MOVEL     BTB4          RBTB4                                         14083
     C                   MOVEL     BTB5          RBTB5                                         14083
     C                   MOVEL     BTB6          RBTB6                                         14083
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'
     C                   MOVE      SCCY          RRSCY
     C                   MOVE      PSCY          RPSCY
      *                                                                                       CLE031
     C     REXR          IFEQ      0
     C                   MOVE      *BLANKS       RREXR
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      REXR          ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        RREXR
     C                   ENDIF
      *                                                                                       CLE031
     C                   MOVE      REXI          RREXI
      *                                                                                       CLE031
     C     PEXR          IFEQ      0
     C                   MOVE      *BLANKS       RPEXR
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      PEXR          ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        RPEXR
     C                   ENDIF
      *                                                                                       CLE031
     C                   MOVE      PEXI          RPEXI
     C                   ENDIF
      *                                                                   140832
     C                   WRITE     DETAL4                                                      14083
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE004
      *                                                                   140832
     C     PRTR          IFEQ      'A'                                                         14083
     C     PRTR          OREQ      *BLANKS                                                     14083
      *                                                                   140832
     C     SYIN          IFEQ      'Y'                                                         14083
     C     KPART         SETLL     LEPARTL3                                                    14083
     C     KPART         READE     LEPARTL3                               46                   14083
     C     *IN46         DOWEQ     *OFF                                                        14083
      *                                                                   140832
     C                   MOVEL     MNUM          RMNUM                                         14083
     C                   MOVEL     INUM          RINUM                                         14083
     C                   MOVEL     DRTP          RDRTP                                         14083
     C                   MOVEL     DRST          RDRST                                         14083
     C                   MOVEL     DRCL          RDRCL
     C                   MOVEL     SHTP          RSHTP                                         14083
     C                   Z-ADD     FEBR          RFEBR                                         14083
     C                   MOVEL     FERS          RFERS                                         14083
     C                   MOVEL     PRTR2         RPRTR
     C                   MOVEL     SEQN          RSEQN
      *                                                                   140832
      *  Format Share amount                                              140832
      *                                                                   140832
     C                   Z-ADD     SHAM          ZFLD15                                        14083
     C                   EXSR      ZFRPED                                                      14083
     C     ZNEG          IFEQ      '-'                                                         14083
     C                   MOVEL     ZOUT18        RSHA0                                         14083
     C                   ELSE                                                                  14083
     C                   MOVEL     ZOUT17        RSHA0                                         14083
     C                   ENDIF                                                                 14083
      *                                                                   140832
      ** Format Share Percentage                                          140832
      *                                                                   140832
     C***********          Z-ADD8         ZADEC                    140832 149037
     C                   Z-ADD     12            ZADEC                                         14903
     C                   MOVEL     *BLANKS       ZFIELD                                        14083
     C                   MOVE      SHPC          ZFIELD                                        14083
     C                   EXSR      ZEDIT                                                       14083
     C                   MOVE      ZFIELD        RSHPC                                         14083
      *                                                                   140832
      ** Format Fee Spread                                                140832
      *                                                                   140832
     C                   MOVEL     *BLANKS       ZFIELD                                        14083
     C                   MOVE      FERA          ZFIELD                                        14083
     C                   Z-ADD     7             ZADEC                                         14903
     C                   EXSR      ZEDIT                                                       14083
     C                   MOVE      ZFIELD        RFERA                                         14083
      *                                                                   140832
     C                   MOVE      *BLANKS       CKEY                                          14083
     C                   MOVEL     MNUM          CKEY                                          14083
     C                   MOVEL     *BLANKS       KEYSTS                                        14083
     C                   CALL      'AOCUSTR0'    PLIST1                                        14083
     C     @RTCD         IFNE      *BLANKS                                                     14083
     C     RECIA         ANDNE     'R'                                                         14083
     C     *LOCK         IN        LDA                                                         14083
     C                   MOVE      '13'          DBASE                          ***************14083
     C                   MOVE      'SDCUSTPD'    DBFILE                         * DB ERROR 13 *14083
     C                   MOVE      *BLANKS       DBKEY                          ***************14083
     C                   MOVEL     CKEY          DBKEY                                         14083
     C                   MOVE      'LE0300  '    DBPGM                                         14083
     C                   OUT       LDA                                                         14083
     C                   SETON                                        U7U8LR                   14083
     C                   EXSR      *PSSR                                                       14083
     C                   GOTO      ENDF                                                        14083
     C                   ENDIF                                                                 14083
      *                                                                   140832
     C                   MOVEL     BBCSSN        RMNAM                                         14083
      *                                                                   140832
     C                   MOVE      *BLANKS       CKEY                                          14083
     C                   MOVEL     INUM          CKEY                                          14083
     C                   MOVEL     *BLANKS       KEYSTS                                        14083
     C                   CALL      'AOCUSTR0'    PLIST1                                        14083
     C     @RTCD         IFNE      *BLANKS                                                     14083
     C     RECIA         ANDNE     'R'                                                         14083
     C     *LOCK         IN        LDA                                                         14083
     C                   MOVE      '14'          DBASE                          ***************14083
     C                   MOVE      'SDCUSTPD'    DBFILE                         * DB ERROR 14 *14083
     C                   MOVE      *BLANKS       DBKEY                          ***************14083
     C                   MOVEL     CKEY          DBKEY                                         14083
     C                   MOVE      'LE0300  '    DBPGM                                         14083
     C                   OUT       LDA                                                         14083
     C                   SETON                                        U7U8LR                   14083
     C                   EXSR      *PSSR                                                       14083
     C                   GOTO      ENDF                                                        14083
     C                   ENDIF                                                                 14083
      *                                                                   140832
     C                   MOVEL     BBCSSN        RINAM                                         14083
      *                                                                   140832
     C     JDTE          IFGT      0                                                           14083
     C                   MOVE      *ON           *IN84                                         14083
     C                   Z-ADD     JDTE          ZDAYNO                                        14083
     C                   EXSR      ZDATE2                                                      14083
     C                   MOVEL     ZADATE        WJDTC                                         14083
     C                   MOVEL     WJDTC         RJDTE                                         14083
     C                   ENDIF                                                                 14083
      *                                                                   140832
     C     PTAI          IFEQ      'R'                                                         14083
     C                   MOVE      *ON           *IN85                                         14083
     C                   ELSE                                                                  14903
     C                   MOVE      *OFF          *IN85                                         14903
     C                   ENDIF                                                                 14083
      *                                                                   140832
      ***  Check that sufficient lines remain for the Format. If not,     140832
      ***  write out the Main Headings on a new page.                     140832
      *                                                                   140832
     C                   Z-ADD     34            RQDLN2                                        14083
     C     OFLLN2        SUB       PRTLN2        DIFLN2                                        14083
     C     DIFLN2        IFLE      RQDLN2                                                      14083
     C                   WRITE     HEADP2                                                      14083
     C                   WRITE     HEADCU                                                      14083
     C                   ENDIF                                                                 14083
     C                   WRITE     DETAL3                                                      14083
      *                                                                   140832
      ** Receipt settlement instructions                                  140832
      *                                                                   140832
     C                   Z-ADD     RSTM          RRSTM                                         14083
     C                   MOVE      RONS          RRONS                                         14083
     C**********           Z-ADDROCN      RROCN                                        140832 CSD027
     C**********           Z-ADDROBN      RROBN                                        140832 CSD027
     C                   MOVE      ROCN          RROCN
     C                   MOVE      ROBN          RROBN
     C                   MOVE      RIBN          RRIBN                                         14083
     C                   MOVE      RIBA          RRIBA                                         14083
      *                                                                   140832
      ** Payment settlement instructions                                  140832
      *                                                                   140832
     C                   Z-ADD     PSTM          RPSTM                                         14083
     C                   MOVE      PONS          RPONS                                         14083
     C                   MOVE      CVMR          RCVMR                                         14083
     C                   MOVE      RVNO          RRVNO                                         14083
     C**********           Z-ADDPOCN      RPOCN                                        140832 CSD027
     C**********           Z-ADDPOBN      RPOBN                                        140832 CSD027
     C                   MOVE      POCN          RPOCN
     C                   MOVE      POBN          RPOBN
     C                   MOVEL     RCRN          RRCRN                                         14083
     C                   MOVEL     RCRA          RRCRA                                         14083
     C                   MOVEL     PIBN          RPIBN                                         14083
     C                   MOVEL     PIBA          RPIBA                                         14083
     C                   MOVEL     AWBN          RAWBN                                         14083
     C                   MOVEL     AWBA          RAWBA                                         14083
     C                   MOVEL     BENN          RBENN                                         14083
     C                   MOVEL     BENA          RBENA                                         14083
     C                   MOVEL     DTP1          RDTP1                                         14083
     C                   MOVEL     DTP2          RDTP2                                         14083
     C                   MOVEL     DTP3          RDTP3                                         14083
     C                   MOVEL     DTP4          RDTP4                                         14083
     C                   MOVEL     DCHG          RDCHG                                         14083
     C                   MOVEL     BTB1          RBTB1                                         14083
     C                   MOVEL     BTB2          RBTB2                                         14083
     C                   MOVEL     BTB3          RBTB3                                         14083
     C                   MOVEL     BTB4          RBTB4                                         14083
     C                   MOVEL     BTB5          RBTB5                                         14083
     C                   MOVEL     BTB6          RBTB6                                         14083
      *                                                                   140832
     C                   WRITE     DETAL4                                                      14083
      *                                                                   140832
     C     KPART         READE     LEPARTL3                               46                   14083
     C                   ENDDO                                                                 14083
     C                   ENDIF                                                                 14083
     C                   ENDIF                                                                 14083
      *                                                                   140832
     C                   MOVE      RCNAM         CRNM                                          CLE00
     C                   MOVE      RCNUM         BBCUST                                        CLE00
     C                   MOVE      RCRSK         CRSK                                          CLE00
     C                   MOVE      RACOF         ACOF                                          CLE00
      *                                                                   CLE004
     C     ENDF          ENDSR                                                  *** FILLP2 *** CLE00
      *                                                                   CLE004
      /EJECT                                                              CLE004
      *****************************************************************   CLE015
      *  FILCRD - subroutine to fill the currency rollover details in *   CLE015
      *           LE0300P1                                            *   CLE015
      *                                                               *   CLE015
      *  Called by: DETB                                              *   CLE015
      *  Calls:                                                       *   CLE015
      *                                                               *   CLE015
      *****************************************************************   CLE015
      *                                                                   CLE015
     C     FILCRD        BEGSR                                                  *** FILCRD *** CLE01
      *                                                                   CLE015
      *                                                                                       208458
      ** Format amount                                                                        208458
      *                                                                                       208458
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
      *                                                                   CLE015
     C                   Z-ADD     0             WICTR             2 0                         CLE01
     C     1             DO        6             WICTR                                         CLE01
     C                   Z-ADD     WICTR         WINDX             2 0                         CLE01
     C     WINDX         IFNE      6                                                           CLE01
     C     CLE028        OREQ      'Y'
     C     CLE028        IFEQ      'Y'
     C                   SUBST     DTPX:WINDX    WCVAR
     C                   ELSE
     C                   SUBST     DTPS:WINDX    WCVAR             1                           CLE01
     C                   ENDIF
     C                   SELECT                                                                CLE01
     C     WINDX         WHENEQ    1                                                           CLE01
     C**********           CAT  WCVAR:0   DTPS                                         CLE015 208458
     C                   CAT       WCVAR:0       RDTPS1           11
     C     WINDX         WHENNE    1                                                           CLE01
     C**********           CAT  WCVAR:1   DTPS                                         CLE015 208458
     C                   CAT       WCVAR:1       RDTPS1
     C                   ENDSL                                                                 CLE01
     C                   ENDIF                                                                 CLE01
     C                   SUBST     RTPS:WINDX    WCVAR                                         CLE01
     C                   SELECT                                                                CLE01
     C     WINDX         WHENEQ    1                                                           CLE01
     C**********           CAT  WCVAR:0   RTPS                                         CLE015 208458
     C**********           CAT  WCVAR:0   RRTPS1 11                                  208458 AR750770
     C                   CAT       WCVAR:0       RRTPS1           41
     C     WINDX         WHENNE    1                                                           CLE01
     C     RRTPS1        IFEQ      *BLANKS
     C                   CAT       WCVAR:0       RRTPS1
     C                   ELSE
     C**********           CAT  WCVAR:1   RTPS                                         CLE015 208458
     C                   CAT       WCVAR:1       RRTPS1
     C                   ENDIF
     C                   ENDSL                                                                 CLE01
      *                                                                   CLE015
     C     WINDX         IFGT      1                                                           CLE01
     C                   MULT      3             WINDX                                         CLE01
     C                   SUB       2             WINDX                                         CLE01
     C                   ENDIF                                                                 CLE01
     C                   SUBST     ALCY:WINDX    WYVAR             3                           CLE01
     C                   SELECT                                                                CLE01
     C     WINDX         WHENEQ    1                                                           CLE01
     C                   CAT       WYVAR:0       ALC1             23                           CLE01
     C     WINDX         WHENNE    1                                                           CLE01
     C                   CAT       WYVAR:1       ALC1                                          CLE01
     C                   ENDSL                                                                 CLE01
     C                   ADD       18            WINDX                                         CLE01
     C                   SUBST     ALCY:WINDX    WYVAR                                         CLE01
     C                   SELECT                                                                CLE01
     C     WINDX         WHENEQ    19                                                          CLE01
     C                   CAT       WYVAR:0       ALC2             23                           CLE01
     C     WINDX         WHENNE    19                                                          CLE01
     C                   CAT       WYVAR:1       ALC2                                          CLE01
     C                   ENDSL                                                                 CLE01
     C                   ENDDO                                                                 CLE01
      *                                                                   CLE015
     C                   Z-ADD     0             WICTR             2 0
     C     1             DO        15            WICTR
     C                   Z-ADD     WICTR         WNDX              2 0
     C     WNDX          IFNE      15
     C     CLE028        OREQ      'Y'
     C                   SUBST     RTS15:WNDX    WCVAR
     C                   SELECT
     C     WNDX          WHENEQ    1
     C     RRTPS1        IFEQ      *BLANKS
     C                   CAT       WCVAR:0       RRTPS1
     C                   ELSE
     C                   CAT       WCVAR:1       RRTPS1
     C                   ENDIF
     C     WNDX          WHENNE    1
     C     RRTPS1        IFEQ      *BLANKS
     C                   CAT       WCVAR:0       RRTPS1
     C                   ELSE
     C                   CAT       WCVAR:1       RRTPS1
     C                   ENDIF
     C                   ENDSL
     C                   ENDIF
     C                   ENDDO
      *                                                                                     AR750770
     C**********           MOVELWCOMC     COMD                                         CLE015 208458
      *                                                                   CLE015
     C     AVLD          IFGT      0                                                           CLE01
     C                   MOVE      *ON           *IN83                                         CLE01
     C                   Z-ADD     AVLD          ZDAYNO                                        CLE01
     C                   EXSR      ZDATE2                                                      CLE01
     C                   MOVE      ZADATE        WAVLD             7                           CLE01
     C                   ENDIF                                                                 CLE01
      *                                                                   CLE015
     C     COMD          IFGT      0                                                           CLE01
     C                   MOVE      *ON           *IN81                                         CLE01
     C                   Z-ADD     COMD          ZDAYNO                                        CLE01
     C                   EXSR      ZDATE2                                                      CLE01
     C                   MOVE      ZADATE        WCOMD             7                           CLE01
     C                   ENDIF                                                                 CLE01
      *                                                                   CLE015
      ** Format late payment penalty amount.                              CLE015
      *                                                                   CLE015
     C     LPTP          IFEQ      'A'
      *                                                                                      BUG4166
     C                   Z-ADD     LPAM          ZFLD15                                        CLE01
     C                   EXSR      ZFRPED                                                      CLE01
     C     ZNEG          IFEQ      '-'                                                         CLE01
     C                   MOVEL     ZOUT18        LPA0             17                           CLE01
     C                   ELSE                                                                  CLE01
     C                   MOVEL     ZOUT17        LPA0                                          CLE01
     C                   ENDIF                                                                 CLE01
      *                                                                                      BUG4166
      ** Else, rate was used                                                                 BUG4166
      *                                                                                      BUG4166
     C                   ELSE
      *                                                                                      BUG4166
     C     LPTP          IFEQ      'P'
     C                   Z-ADD     7             ZADEC
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      LPAM          ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        LPA0
     C                   ENDIF
     C                   ENDIF
      *                                                                   CLE015
      ** Get Base Rate in Facility extension file                                            BUG8943
      *                                                                                      BUG8943
     C     CLE035        IFEQ      'Y'
     C                   MOVE      BRCA          KBRCA
     C                   MOVE      CNUMA         KCNUMA
     C                   MOVE      FACTA         KFACTA
     C                   MOVE      FCNOA         KFCNOA
     C                   MOVE      *BLANKS       WXPRT            11 7
     C     KFCLT         CHAIN     LEFCLTLG                           57
     C     *IN57         IFEQ      *OFF
     C                   MOVE      FCXPRT        WXPRT
     C                   ENDIF
     C                   ENDIF
      *                                                                                      BUG8943
     C                   ENDSR                                                  *** FILCRD *** CLE01
      *                                                                   CLE015
      /EJECT                                                              CLE015
      *****************************************************************   CLE004
      *  REINP2 - subroutine to reinitialize report fields.           *   CLE004
      *                                                               *   CLE004
      *  Called by: DETA                                              *   CLE004
      *  Calls: None                                                  *   CLE004
      *                                                               *   CLE004
      *****************************************************************   CLE004
      *                                                                   CLE004
     C     REINP2        BEGSR                                                  *** REINP2 *** CLE00
      *                                                                   CLE004
     C                   MOVE      *OFF          *IN49                                         CLE00
     C                   MOVE      *OFF          *IN53                                         CLE00
     C                   MOVE      *OFF          *IN58                                         CLE00
     C                   MOVE      *OFF          *IN48                                         CLE00
     C                   MOVE      *OFF          *IN81                                         CLE00
     C                   MOVE      *OFF          *IN82                                         CLE00
     C                   MOVE      *OFF          *IN83                                         CLE00
     C                   MOVE      *OFF          *IN84                                         CLE00
     C                   MOVE      *OFF          *IN71                                         CLE00
      *                                                                   CLE004
     C                   MOVE      *BLANKS       RRVCD                                         CLE00
     C                   MOVE      *BLANKS       RPRV0                                         CLE00
     C                   MOVE      *BLANKS       ROVPC                                         CLE00
     C                   MOVE      *BLANKS       RNOMR                                         CLE00
     C                   MOVE      *BLANKS       RFAM0                                         CLE00
     C                   MOVE      *BLANKS       RACOF                                         CLE00
     C                   MOVE      *BLANKS       RCNAM                                         CLE00
     C                   MOVE      *BLANKS       RCNUM                                         CLE00
     C                   MOVE      *BLANKS       RFCTI                                         CLE00
     C                   MOVE      *BLANKS       RFCCY                                         CLE00
     C                   MOVE      *BLANKS       RDTAP                                         CLE00
     C                   MOVE      *BLANKS       RRVCR                                         CLE00
     C                   MOVE      *BLANKS       RMCCY                                         CLE00
     C                   MOVE      *BLANKS       RCRSK                                         CLE00
     C                   MOVE      *BLANKS       RRVDT                                         CLE00
     C                   MOVE      *BLANKS       RORBR                                         CLE00
     C                   MOVE      *BLANKS       RMBFC                                         CLE00
     C                   MOVE      *BLANKS       RFACT                                         CLE00
     C                   MOVE      *BLANKS       RFCNO                                         CLE00
     C                   MOVE      *BLANKS       RDTEX                                         CLE00
     C                   MOVE      *BLANKS       RMCSI                                         CLE00
     C                   MOVE      *BLANKS       RNACD                                         CLE00
     C                   MOVE      *BLANKS       RBTIN                                         CLE00
     C                   MOVE      *BLANKS       RRVFR                                         CLE00
     C                   MOVE      *BLANKS       RORBR                                         CLE00
     C                   MOVE      *BLANKS       RSECI                                         CLE00
     C                   MOVE      *BLANKS       RNAR1                                         CLE00
     C                   MOVE      *BLANKS       RNAR2                                         CLE00
     C                   MOVE      *BLANKS       RNAR3                                         CLE00
     C                   MOVE      *BLANKS       RNAR4                                         CLE00
     C                   MOVE      *BLANKS       RDLFS                                         CLE00
     C                   MOVE      *BLANKS       RACTN                                         CLE00
     C                   MOVE      *BLANKS       RSNAM                                         CLE00
     C                   MOVE      *BLANKS       RANUM                                         CLE00
     C                   MOVE      *BLANKS       RDTPS                                         CLE00
     C                   MOVE      *BLANKS       RRTPS                                         CLE00
     C                   MOVE      *BLANKS       RALC1                                         CLE00
     C                   MOVE      *BLANKS       RALC2                                         CLE00
     C                   MOVE      *BLANKS       RCOMD                                         CLE00
     C                   MOVE      *BLANKS       RLPBR                                         CLE00
     C                   MOVE      *BLANKS       RDFTP                                         CLE00
     C                   MOVE      *BLANKS       RDFST                                         CLE00
     C                   MOVE      *BLANKS       RDFCL
     C                   MOVE      *BLANKS       RCSEL                                         CLE00
     C                   MOVE      *BLANKS       RCDTE                                         CLE00
     C                   MOVE      *BLANKS       RLPTP                                         CLE00
     C                   MOVE      *BLANKS       RAVLD                                         CLE00
     C                   MOVE      *BLANKS       RLPA0                                         CLE00
     C                   MOVE      *BLANKS       RTNAM                                         CLE00
     C                   MOVE      *BLANKS       RTRCA                                         CLE00
     C                   MOVE      *BLANKS       RCANM                                         CLE00
     C                   MOVE      *BLANKS       RACSQ                                         CLE00
     C                   MOVE      *BLANKS       RINUM                                         CLE00
     C                   MOVE      *BLANKS       RJDTE                                         CLE00
     C                   MOVE      *BLANKS       RDRTP                                         CLE00
     C                   MOVE      *BLANKS       RDRST                                         CLE00
     C                   MOVE      *BLANKS       RDRCL
     C                   MOVE      *BLANKS       RSHA0                                         CLE00
     C                   MOVE      *BLANKS       RSHPC                                         CLE00
     C                   MOVE      *BLANKS       RSKIR                                         CLE00
     C                   MOVE      *BLANKS       RSKFR                                         CLE00
     C                   MOVE      *BLANKS       RFERA                                         CLE00
     C                   MOVE      *BLANKS       RSHTP                                         CLE00
     C                   MOVE      *BLANKS       RRCSI                                         CLE00
     C                   MOVE      *BLANKS       RPASI                                         14726
     C*********************MOVE *BLANKS   RPTAI                    CLE004 140832
     C                   MOVE      *BLANKS       RSKIS                                         CLE00
     C                   MOVE      *BLANKS       RSKFS                                         CLE00
     C                   MOVE      *BLANKS       RFERS                                         CLE00
     C                   MOVE      *BLANKS       RLAID                                         CLE00
      *                                                                   CLE004
     C                   Z-ADD     0             RFEBR                                         CLE00
     C                   Z-ADD     0             RCAFT                                         CLE00
     C                   Z-ADD     0             RCAFN                                         CLE00
     C**********           Z-ADD0         RPMFC                                        CLE004 CSD027
     C                   MOVE      *BLANKS       RPMFC
     C                   Z-ADD     0             RPMFT                                         CLE00
     C                   Z-ADD     0             RPMFN                                         CLE00
     C                   Z-ADD     0             RBLDY                                         CLE00
     C                   Z-ADD     0             RRVDY                                         CLE00
     C                   Z-ADD     0             RDICB                                         CLE00
     C                   Z-ADD     0             RRLPD                                         CLE00
     C                   Z-ADD     0             RSEQN
     C                   MOVE      *BLANKS       RFBRT
     C                   MOVE      *BLANKS       RPRTR
     C                   MOVE      *BLANKS       RFBCD
     C/COPY WNCPYSRC,LEH00094
      *                                                                   CLE004
     C     CER020        IFEQ      'Y'
      *                                                                                       CER020
     C                   MOVE      *BLANKS       RPEXD
     C                   MOVE      *BLANKS       RPNXD
      *                                                                                       CER020
     C                   ENDIF
      *                                                                                       CER020
     C                   ENDSR                                                  *** REINP2 *** CLE00
     C********************************************************************S01117
      /EJECT                                                                                  208458
      *****************************************************************                       208458
      *                                                               *                       208458
      *  SRREIN - Subroutine to reinitialize report fields.           *                       208458
      *                                                               *                       208458
      *  Called By : DETA                                             *                       208458
      *                                                               *                       208458
      *  Calls     : NONE                                             *                       208458
      *                                                               *                       208458
      *****************************************************************                       208458
      *                                                                                       208458
     C     SRREIN        BEGSR
     C                   MOVE      *BLANKS       RDTPS1
     C                   MOVE      *BLANKS       RRTPS1
     C                   MOVE      *BLANKS       ALC1
     C                   MOVE      *BLANKS       ALC2
     C                   MOVE      *BLANKS       WCOMD
     C                   MOVE      *BLANKS       WAVLD
     C                   MOVE      *BLANKS       LPA0
      *                                                                                       208458
     C                   ENDSR
      *****************************************************************                       208458
      * FCANAC    : Output AnaCredit Reporting from FCANACQD            *                    CER073D
      * ---                                                             *                    CER073D
      * Called By : DETA                                                *                    CER073D
      * Calls     : None                                                *                    CER073D
      *******************************************************************                    CER073D
     C     FCANAC        BEGSR                                                               CER073D
      *                                                                                      CER073D
     C     KANAC         KLIST                                                               CER073D
     C                   KFLD                    BRCA                                        CER073D
     C                   KFLD                    CNUMAA            6                         CER073D
     C                   KFLD                    FACTA                                       CER073D
     C                   KFLD                    FCNOA                                       CER073D
     C     KANAC         CHAIN     FCANACI1                           32                     CER073D
      *                                                                                      CER073D
     C     *IN32         IFEQ      *OFF                                                      CER073D
      *                                                                                      CER073D
      ** Convert Date of the Performing Status of the instrument to DDMMMYY                  CER073D
      *                                                                                      CER073D
     C     ACDTPS        IFEQ      0                                                         CER073D
     C                   MOVE      *BLANK        ADTPS             7                         CER073D
     C                   ELSE                                                                CER073D
     C                   Z-ADD     ACDTPS        ZDAYNO                                      CER073D
     C                   EXSR      ZDATE2                                                    CER073D
     C                   MOVE      ZADATE        ADTPS                                       CER073D
     C                   ENDIF                                                               CER073D
      *                                                                                      CER073D
      ** Convert Date of Forbearance and Renegotiation to DDMMCCYY                           CER073D
      *                                                                                      CER073D
     C     ACDTRS        IFEQ      0                                                         CER073D
     C                   MOVE      *BLANK        DTRS              7                         CER073D
     C                   ELSE                                                                CER073D
     C                   Z-ADD     ACDTRS        ZDAYNO                                      CER073D
     C                   EXSR      ZDATE2                                                    CER073D
     C                   MOVE      ZADATE        DTRS                                        CER073D
     C                   ENDIF                                                               CER073D
      *                                                                                      CER073D
      ** Convert Date of the Default Status of the Instruments                               CER073D
      *                                                                                      CER073D
     C     ACDDSI        IFEQ      0                                                         CER073D
     C                   MOVE      *BLANK        DDSI              7                         CER073D
     C                   ELSE                                                                CER073D
     C                   Z-ADD     ACDDSI        ZDAYNO                                      CER073D
     C                   EXSR      ZDATE2                                                    CER073D
     C                   MOVE      ZADATE        DDSI                                        CER073D
     C                   ENDIF                                                               CER073D
     C                   ENDIF                                                               CER073D
      *                                                                                      CER073D
     C                   ENDSR                                                               CER073D
      *****************************************************************                      CER073D
     C*/COPY*ZSRSRC,ZDATE2Z4*********                                                 S01392 CER073D
     C/COPY ZSRSRC,ZDATE2Z4LE                                                                CER073D
     C********************************************************************S01392
     OLE0300P1  D    30                     2 03                                S01124
     O         AND  N09
     O*******OR**      66                                                 S01117
     O*******OR**      U7 U8                                              S01117
     O         OR    OF
     O         AND  N09
     O***********                        22 'REFERENCE  LE0300'           S01117
     O                                           24 'REFERENCE  LE0300P1'       S01117
     O                       TITL                89
     O                                          104 'DATE'
     O                       RUNA               112
     O                                          122 'PAGE'
     O                       PAGE          Z    127
     O          D    30                     1
     O         AND  N09
     O*******OR**      66                                                 S01117
     O         OR    OF
     O         AND  N09
     O*******OR**      U7 U8                                              S01117
     O                                           59 'FACILITIES '
     O                                           76 'MAINTENANCE TODAY'
     O                    N33                    86 'BRANCH'                    S01117
     O                    N33BRCA                90                             S01117
     O                    N33                    91 '-'                         S01117
     O                    N33BRNM               121                             S01117
     O          D    30                     3
     O         AND  N09
     O*******OR**      66                                                 S01117
     O         OR    OF
     O         AND  N09
     O*******OR**      U7 U8                                              S01117
     O                                           59 '-----------'
     O                                           76 '-----------------'
     O          D    30                     2
     O         AND  N09
     O         OR    OF
     O         AND  N09
     O                                           13 'CUSTOMER'
     O**********               CRNM      36                                                  BUG3781
     O                       FCCRNM              36                                                B
     O**********               CNUM      46                               S01194
     O**********               BBCSSN    46                         S01194BHF064
     O**********               BBCUST    46                                           BHF064 BUG3781
     O                       FCCUST              46                                                B
     O                                           67 'FACILITY TYPE'
     O***********              FACT      72                               S01117
     O                       FACTA               72                             S01117
     O                                           79 'NO.'
     O***********              FCNO      83                               S01117
     O                       FCNOA               83                             S01117
     O***********                        94 'BRANCH'                      S01117
     O***********              BRCD      99                               S01117
     O/COPY WNCPYSRC,LEH00092
     O                                          122 'ACTION'
     O                       ACTN               125
     O          D    30                     2
     O         AND  N09
     O                                           14 'FCLT/CMMT'
     O                       FCTI                17
     O                                           27 'CCY'
     O                       FCCY                32
     O***********                        46 'AMOUNT'                      MOF60
     O***********      38      FAMT      65 ' ,   ,   , 0 .   '           MOF60
     O***********      37      FAMT      65 '  ,   ,   , 0 .  '           MOF60
     O***********      36      FAMT      65 '   ,   ,   , 0 . '           MOF60
     O***********      35      FAMT      65 ' ,   ,   ,   , 0 '           MOF60
     O              N78                          46 'AMOUNT'                    MOF60
     O***********     N78 38   FAMT      65 ' ,   ,   , 0 .   '     MOF60 171784
     O***********     N78 37   FAMT      65 '  ,   ,   , 0 .  '     MOF60 171784
     O***********     N78 36   FAMT      65 '   ,   ,   , 0 . '     MOF60 171784
     O***********     N78 35   FAMT      65 ' ,   ,   ,   , 0 '     MOF60 171784
     O              N78 38   FAMT                65 ' ,   ,   , 0 .   -'        171784
     O              N78 37   FAMT                65 '  ,   ,   , 0 .  -'        171784
     O              N78 36   FAMT                65 '   ,   ,   , 0 . -'        171784
     O              N78 35   FAMT                65 ' ,   ,   ,   , 0 -'        171784
     O               78                          55 'PREVIOUS AMOUNT'           MOF60
     O***********      78 38   PRVAMT    73 ' ,   ,   , 0 .   '     MOF60 171784
     O***********      78 37   PRVAMT    73 '  ,   ,   , 0 .  '     MOF60 171784
     O***********      78 36   PRVAMT    73 '   ,   ,   , 0 . '     MOF60 171784
     O***********      78 35   PRVAMT    73 ' ,   ,   ,   , 0 '     MOF60 171784
     O               78 38   PRVAMT              73 ' ,   ,   , 0 .   -'        171784
     O               78 37   PRVAMT              73 '  ,   ,   , 0 .  -'        171784
     O               78 36   PRVAMT              73 '   ,   ,   , 0 . -'        171784
     O               78 35   PRVAMT              73 ' ,   ,   ,   , 0 -'        171784
     O               78                          89 'NEW AMOUNT'                MOF60
     O***********      78 38   FAMT     107 ' ,   ,   , 0 .   '     MOF60 171784
     O***********      78 37   FAMT     107 '  ,   ,   , 0 .  '     MOF60 171784
     O***********      78 36   FAMT     107 '   ,   ,   , 0 . '     MOF60 171784
     O***********      78 35   FAMT     107 ' ,   ,   ,   , 0 '     MOF60 171784
     O               78 38   FAMT               107 ' ,   ,   , 0 .   -'        171784
     O               78 37   FAMT               107 '  ,   ,   , 0 .  -'        171784
     O               78 36   FAMT               107 '   ,   ,   , 0 . -'        171784
     O               78 35   FAMT               107 ' ,   ,   ,   , 0 -'        171784
     O/COPY WNCPYSRC,LE0300O001
     O*
     O          D    30                     2
     O         AND  N09
     O                                           16 'A/C OFFICER'
     O                       ACOF                35
     O                                           51 'OVER LINE %'
     O                       OVPC                63 '0 .   '
     O               13                          92 'OVER LINE AMT'
     O               13 38   OVAM               112 ' ,   ,   , 0 .   -'
     O               13 37   OVAM               112 '  ,   ,   , 0 .  -'
     O               13 36   OVAM               112 '   ,   ,   , 0 . -'
     O               13 35   OVAM               112 ' ,   ,   ,   , 0 -'
     O**********                         86 'SECURED'                                   MOF60 CLE034
     O**********               SECI      88                                             MOF60 CLE034
     O                                          123 'SECURED'
     O                       SECI               125
     O          D    30                     1
     O         AND  N09
     O**********                         18 'DATE APPROVED'                                   201127
     O                                           15 'START DATE'
     O               50      DTAPO               35
     O                                           52 'DATE EXPIRES'
     O               51      DTEXO               69
     O                                           88 'NARRATIVE'
     O                       NAR1               125
     O/COPY WNCPYSRC,LE0300O002
     O          D    30                     1
     O         AND  N09
     O                       NAR2               125
      *                                                                                       CER020
     O          D    30 80                  1
     O         AND  N09                                                                           AR
     O                                           25 'PREVIOUS EXPIRY DATE'
     O                       RPEXD               35
     O                                           62 'PENULTIMATE EXPIRY DATE'
     O                       RPNXD               72
     O          D    30                     1
     O         AND  N09
     O                                           21 'REVOLVING CREDIT'          MOF60
     O                       RVCR                35                             MOF60
     O               79                          58 'DATE REV. CR. IND.'        MOF60
     O               79                          66 'CHANGED'
     O               79      RVCDO               74
     O***********                        47 'SECURED'                     MOF60
     O***********              SECI      69                               MOF60
     O                       NAR3               125
     O          D    30                     1
     O         AND  N09
     O                       NAR4               125
     O          D    30                     2
     O         AND  N09
     O                                           19 'MULTI CURRENCY'
     O                       MCCY                35
     O                                           54 'MULTI CUSTOMER'
     O                       MCSI                69
     O*                                                                   S01408
     O/COPY WNCPYSRC,LE0300OOPG                                           S01408
     O*                                                                   S01408
     O          D    30                     2
     O         AND  N09
     O                                           20 'COUNTRY OF RISK'
     O                       CRSK                35
     O                                           55 'ALTERNATIVE N/A'
     O                       NACD                69
     O                                           97 'DATE LAST FIN STMT'
     O               52      DLFSO              111
     O          D    30                     2
     O         AND  N09
     O                                           17 'NOMINAL RATE'
     O                       NOMR                35 '  0 .       '
     O***********                        57 'BILLING/TELEX IND'           MOF60
     O***********              BTIN      69                               MOF60
     O***********                        91 'BILLING DAYS'                MOF60
     O***********      57      BLDY     111                               MOF60
     O                                           57 'BILLING/TELEX IND'         072062
     O                       BTIN                69                             072062
     O                                           91 'BILLING DAYS'              072062
     O/COPY WNCPYSRC,LE0300O004
     O                       BLDY               111 '0 '                        072062
     O/COPY WNCPYSRC,LE0300O005
     O          D    30                     2
     O         AND  N09
     O                                           16 'REVIEW DATE'
     O               53      RVDTO               35
     O                                           49 'FREQUENCY'
     O                       RVFR                69
     O                                           85 'DAY NO'
     O               58      RVDY               111
     O********D**2     30                                                 MOF60
     O***********                        14 'C/FEE IND'                   MOF60
     O***********     N29      CMFT      35                               MOF60
     O***********                        49 'BASE RATE'                   MOF60
     O***********     N29 59   BCOD      69                               MOF60
     O***********                        90 'RATE/SPREAD'                 MOF60
     O***********     N29      SPRD     111 '  0 .       '                MOF60
     O********D**2     30                                                 MOF60
     O***********                        15 'START DATE'                  MOF60
     O***********     N29 54   STDTO     35                               MOF60
     O***********                        48 'END DATE'                    MOF60
     O***********     N29 55   EDDTO     69                               MOF60
     O***********                        93 'NEXT BILL DATE'              MOF60
     O***********     N29 56   DUDTO    111                               MOF60
     O********D**2     30                                                 MOF60
     O***********                        14 'BILL FREQ'                   MOF60
     O***********     N29      BLFR      35                               MOF60
     O***********                        46 'DAY NO'                      MOF60
     O***********     N29 60   BLDN      69                               MOF60
     O********D**2     30                                                 MOF60
     O***********                        20 'SETTLEMENT TYPE'             MOF60
     O***********     N29      SETT      35                               MOF60
     O***********                        44 'OURS'                        MOF60
     O***********     N29      OBAC      69                         S01117MOF60
     O***********     N29      OBAC      65                         S01117MOF60
     O***********     N29N33   CFBR      69                         S01117MOF60
     O***********                        85 'THEIRS'                      MOF60
     O***********     N29      TNAC     111                               MOF60
     O********D**2     30                                                 MOF60
     O***********                        15 'CALC BASIS'                  MOF60
     O***********     N29      CALC      35                               MOF60
     O/COPY WNCPYSRC,LE0300O003
     O*                                                                   S01117
     O          D    30                     2                                   S01117
     O         AND  N09
     O                    N77                    17 'PROFIT CENT.'              S01117
     O                    N77PRFC                35                             S01117
     O                    N76                    58 'ORIGINATING BRANCH'        S01117
     O                    N76ORBR                69                             S01117
     O********D**1     30                                                 141486
     O          D    30                     2                                   141486
     O         AND  N09
     O                    N33                    17 'MULTI BRANCH'              S01117
     O                    N33MBFC                35                             S01117
     O                     61                    58 'LOAN ADMINISTRATOR'        CLE008
     O                     61LAID                69                             CLE008
     O          D    15                     2                                   CLE015
     O         AND  N09
     O                     15                    18 'DRAWING TYPES'             CLE015
     O**********             15DTPS      35                                            CLE015 208458
     O                     15RDTPS1              35
     O                     15                    95 'DEFAULT INTEREST'          CLE015
     O                     15                   101 'BASIS'                     CLE015
     O                     15DICB               111                             CLE015
     O          D    15                     2                                   CLE015
     O         AND  N09
     O                     15                    19 'ROLLOVER TYPES'            CLE015
     O**********             15RTPS      35                                            CLE015 208458
     O**********             15RRTPS1    35                                          208458 AR750770
     O                     15RRTPS1              65                                               AR
     O                     15                    97 'IRREGULAR ROLLOVER'        CLE015
     O                     15                   104 'PERIOD'                    CLE015
     O                     15RLPD               111                             CLE015
     O          D    15                     2                                   CLE015
     O         AND  N09
     O                     15                    23 'CURRENCY SELECTION'        CLE015
     O                     15CSEL                35                             CLE015
     O                     15                    99 'ALLOWABLE CURRENCIES'      CLE015
     O          D    15                     1                                   CLE015
     O         AND  N09
     O                     15ALC1               101                             CLE015
     O          D    15                     1                                   CLE015
     O         AND  N09
     O                     15ALC2               101                             CLE015
     O          D    15                     2                                   CLE015
     O         AND  N09
     O**********             15          19 'DATE COMMITTED'                          CLE015 246031A
     O**********             15WCOMD     35                                           CLE015 246031A
     O                  11 15                    17 'CLOSING DATE'                                 2
     O                  11 15WCDTC               35                                                2
     O                     15                   101 'LAST AVAILABILITY DATE'    CLE015
     O                     15WAVLD              111                             CLE015
     O          D    15                     2                                   CLE015
     O         AND  N09
     O**********             15          14 'BASE RATE'                               CLE015 BUG8943
     O                     15                    19 'BASE RATE CODE'                               B
     O                     15LPBR                35                             CLE015
     O                     15                    60 'LAST PAYMENT PENALTY'      CLE015
     O                     15                    65 'TYPE'                      CLE015
     O                     15LPTP                69                             CLE015
     O                     15                    85 'AMOUNT'                    CLE015
     O                     15LPA0               111                             CLE015
     O          D    15 14                  2                                                      B
     O         AND  N09                                                                            B
     O                     15                    14 'BASE RATE'                                    B
     O                     15WXPRT               35 '  0 .       '                                 B
     O          D    30 28                  2                                   141486
     O         AND  N09
     O                                           20 'TR/CA INDICATOR'           141486
     O                       TRCA                35                             141486
     O          D    30 28                  2                                   141486
     O         AND  N09
     O                                           26 'CR AGREEMENT CUSTOMER'     141486
     O                       TNAM                48                             141486
     O                       TANM                56                             141486
     O                                           91 'FCTY TYPE/NO'              141486
     O                       TAFT                96                             141486
     O                       TAFN                99                             141486
     O/COPY WNCPYSRC,LEH00130
     O          D    15                     2                                   CLE015
     O         AND  N09
     O                                           28 'ACCOUNT SEQUENCE NUMBER'   CLE015
     O                     15ACSQ                35                             CLE015
     O*                                                                   147935
     O          D    30 28                  2                                   189544
     O         AND  N09
     O                                           18 'APPROVAL DATE'             189544
     O                       RCOMD               35                             189544
     O                                           52 'CR AGREEMENT'              189544
     O                                           66 'EXCHANGE RATE'             189544
     O                       RCAXR               69                             189544
     O                                           92 'EXCH RATE IND'             189544
     O                       RCMDI              111                             189544
     O*                                                                   189544
     O********D* 2     30                                                              147935 196066
     O          D    30 39                  2
     O         AND  N09
     O                                           19 'INSERTING USER'            147935
     O                       IUSR                35                             147935
     O                                           53 'AMENDING USER'             147935
     O                       AUSR                69                             147935
     O                                           95 'AUTHORISING USER'          147935
     O                       XUSR               111                             147935
      *                                                                                      CER073D
     O          D    21 30                  1                                                CER073D
     O                                           23 'ANACREDIT DETAILS'                      CER073D
     O          D    21 30                  1                                                CER073D
     O                                           27 'COUNTERPARTY ROLE-CRE'                  CER073D
     O                                           32 'DITOR'                                  CER073D
     O                       ACCRC1              40                                          CER073D
     O                       ACCRC2              47                                          CER073D
     O                       ACCRC3              54                                          CER073D
     O                       ACCRC4              61                                          CER073D
     O                       ACCRC5              68                                          CER073D
     O                                           90 'COUNTERPARTY ROLE-SER'                  CER073D
     O                                           95 'VICER'                                  CER073D
     O                       ACCPRS             102                                          CER073D
     O                                          125 'COUNTERPARTY ROLE-ORIG'                 CER073D
     O                       ACCPRO             132                                          CER073D
     O          D    21 30                  1                                                CER073D
     O                                           23 'INTEREST RATE CAP'                      CER073D
     O                       ACINRC              56 ' 0 .       -'                           CER073D
     O                                           76 'INTEREST RATE FLOOR'                    CER073D
     O                       ACINRF             101 ' 0 .       -'                           CER073D
     O                                          109 'PURPOSE'                                CER073D
     O                       ACPURP             132                                          CER073D
     O          D    21 30                  1                                                CER073D
     O                                           29 'FV CHANGES BEFORE PURCH'                CER073D
     O                                           32 'ASE'                                    CER073D
     O                       ACFVCH              56 ' ,   ,   ,   , 0 .  '                   CER073D
     O                                           79 'TYPE OF SECURITISATION'                 CER073D
     O                       ACTYOS             101                                          CER073D
     O                                          119 'SUBORDINATED DEBT'                      CER073D
     O                       ACSUBD             132                                          CER073D
     O          D    21 30                  1                                                CER073D
     O                                           29 'DEFAULT STATUS OF THE I'                CER073D
     O                                           38 'NSTRUMENT'                              CER073D
     O                       ACDFSI              50                                          CER073D
     O                                           73 'DATE OF THE DEFAULT'                    CER073D
     O                                           80 'STATUS'                                 CER073D
     O                       DDSI                89                                          CER073D
     O          D    21 30                  1                                                CER073D
     O                                           28 'SOURCES OF ENCUMBRANCE'                 CER073D
     O                       ACSOEN              36                                          CER073D
     O                                           61 'DATE OF THE PERFORMING'                 CER073D
     O                                           68 'STATUS'                                 CER073D
     O                       ADTPS               76                                          CER073D
     O                                          100 'IMPAIRMENT ASSESSMENT'                  CER073D
     O                                          107 'METHOD'                                 CER073D
     O                       ACIAMD             109                                          CER073D
     O          D    21 30                  1                                                CER073D
     O                                           29 'ACC.CHANGES IN FV(CREDI'                CER073D
     O                                           35 'T RISK)'                                CER073D
     O                       ACACFV              56 ' ,   ,   ,   , 0 .  '                   CER073D
     O                                           76 'DATE OF FORBEARANCE'                    CER073D
     O                                           83 'STATUS'                                 CER073D
     O                       DTRS               101                                          CER073D
     O                                          123 'STATUS OF FORBEARANCE'                  CER073D
     O                       ACSFAR             132                                          CER073D
     O          D    21 30                  1                                                CER073D
     O                                           29 'OFF-BALANCE SHEET PROVI'                CER073D
     O                                           34 'SIONS'                                  CER073D
     O                       ACPASE              56 ' ,   ,   ,   , 0 .  '                   CER073D
     O                                           77 'TYPE OF IMPAIRMENT'                     CER073D
     O                       ACTOIM              79                                          CER073D
     O          D    21 30                  1                                                CER073D
     O                                           17 'CONTRACT ID'                            CER073D
     O                       ACSCID              81                                          CER073D
     O          D    21 30                  1                                                CER073D
     O                                           28 'LINKED FACILITY NUMBER'                 CER073D
     O                       ACLFNO              90                                          CER073D
      *                                                                                       CLE039
     O          E    47      CUSGRP         1
     O                                           19 'CUSTOMER GROUP'
     O                       WCGRP               45
     O          E    43      ELICUS         1
     O                                           24 'ELIGIBLE CUSTOMERS:'
     O**********      N45                35 'NONE'                                     CLE039 242371
     O              N45      WNONE               35
     O          E    45      ELICUS         1
     O                       WCUST1              15
     O                       WCSSN1              29
     O                       WCRNM1              53
     O               44      WCUST2              85
     O               44      WCSSN2              99
     O               44      WCRNM2             123
      *                                                                                       CLE039
     O          E    16      XFCLT1         1
     O                                           27 'DRAWDOWN CANNOT EXCEED'
     O                                           37 'AVAILABLE'
     O                       WXDEA               39
      *                                                                                       CLE024
     O          E    17      XFCLT2         1
     O                                           14 'PORTFOLIO'
     O                       WXPOR               19
     O                                           60 'REQUIRED LOAN TO VALUE'
     O                                           66 'RATIO'
     O                       WXLVR               70
     O                                           99 'ADVANCE LOAN TO VALUE'
     O                                          105 'RATIO'
     O                       WXALV              109
      *                                                                                       CLE024
     O          E    17      XFCLT3         1
     O                                           24 'LOAN TO VALUE RATIO'
     O                                           36 'ALERT LEVEL'
     O                       WXLVA               40
     O                                           97 'LOAN TO VALUE RATIO'
     O                                          111 'WARNING LEVEL'
     O                       WXLVW              115
      *                                                                                       CLE024
     O          E    17      XFCLT4         1
     O                                           20 'SUBJECT TO CALL'
     O                       WXSTC               22
     O                                           61 'PERCENTAGE OVER WARNING'
     O                                           76 'FOR FIRST CALL'
     O                       WXPWF               82
      *                                                                                       CLE024
     O          E    17      XFCLT5         1
     O                                           62 'PERCENTAGE INCREMENT FOR'
     O                                           78 'SUBSEQUENT CALL'
     O                       WXPIS               82
      *                                                                                       CFX001
     O          E    18      XFCLT6         1
     O                                           27 'OVERALL MARGIN DEALING'
     O                                           33 'LIMIT'
     O                  38   WXOML               65 ' ,   ,   , 0 .   -'
     O                  37   WXOML               65 '  ,   ,   , 0 .  -'
     O                  36   WXOML               65 '   ,   ,   , 0 . -'
     O                  35   WXOML               65 ' ,   ,   ,   , 0 -'
     O                                           98 'MARGIN SCHEDULE TYPE'
     O                       WXMST              102
     O********D  2     40 75                                                         CLE029 BUG11201
     O********D  2     30 40                                                         BUG11201 242326
     O          D    40 75 30               2
     O*******AND      N09                                                              CLE041 242053
     O         AND  N09 30
     O                                           18 'SEVERITY CODE'             CLE029
     O                       RSVCD               43                             CLE029
     O*
     O*                                                                   S01408
     O/COPY WNCPYSRC,LE0300OOP1                                           S01408
     O*                                                                   S01408
     O********D**2     30 60                                                         CER001 BUG10267
     O          D    30 62                  2                                                     BU
     O*******AND      N09                                                            BUG10505 CFC006
     O         AND  N09 97
     O                                           16 'SUBORDINATE'
     O                       VNSUBR              35
     O                                           61 'MOBILISATION CUSTOMER'
     O                       VNMOBL              78
     O********D**2     30 60                                                         CER001 BUG10267
     O          D    30 62                  2                                                     BU
     O*******AND      N09                                                            BUG10505 CFC006
     O         AND  N09 97
     O                                           14 'RISK CODE'
     O                       VNDGRI              35
     O********D**240   U7 U8                                              S01117
     O***********                        51 '*** REFERENCE LE0300'        S01117
     O***********                        71 'DATABASE ERROR AT'           S01117
     O***********              DBASE     74                               S01117
     O********D**      U7 U8                                              S01117
     O***********                        37 'FILENAME'                    S01117
     O***********              DBFILE    43                               S01117
     O***********                        48 'KEY'                         S01117
     O***********              DBKEY     78                               S01117
     O********EF* 17   08 67                                              S01117
     O***********                        71 '***   NO INPUT TODAY'        S01117
     O***********                        77 '***'                         S01117
     O********T* 203   L1   N75                                    S01117 MOF60
     O**********                                                          MOF60
     O*******AND         NU7N33                                    S01117 MOF60
     O*******OR*       LR   N75                                    S01117 MOF60
     O*******AND         NU7 33                                    S01117 MOF60
     O*******OR*       U7 U8                                       S01117 MOF60
     O**********                         24 'REFERENCE  LE0300P1'  S01117 MOF60
     O**********               TITL      89                        S01117 MOF60
     O**********                        104 'DATE'                 S01117 MOF60
     O**********               RUNA     112                        S01117 MOF60
     O**********                        122 'PAGE'                 S01117 MOF60
     O**********               PAGE  Z  127                        S01117 MOF60
     O********T* 1     L1   N75                                    S01117 MOF60
     O*******AND         NU7N33                                    S01117 MOF60
     O*******OR*       LR   N75                                    S01117 MOF60
     O*******AND         NU7 33                                    S01117 MOF60
     O*******OR*       U7 U8                                       S01117 MOF60
     O**********                         59 'FACILITIES '          S01117 MOF60
     O**********                         76 'MAINTENANCE TODAY'    S01117 MOF60
     O**********            N33          86 'BRANCH'               S01117 MOF60
     O**********            N33BRCA      90                        S01117 MOF60
     O**********            N33          91 '-'                    S01117 MOF60
     O**********            N33BRNM     121                        S01117 MOF60
     O********T* 3     L1   N75                                    S01117 MOF60
     O*******AND         NU7N33                                    S01117 MOF60
     O*******OR*       LR   N75                                    S01117 MOF60
     O*******AND         NU7 33                                    S01117 MOF60
     O*******OR*       U7 U8                                       S01117 MOF60
     O**********                         59 '-----------'          S01117 MOF60
     O**********                         76 '-----------------'    S01117 MOF60
     O********T* 240   U7 U8                                       S01117 MOF60
     O          E    U7 U8   TOTOUT         2 40                                MOF60
     O         AND      97
     O                                           51 '*** REFERENCE LE0300'      S01117
     O                                           72 'DATABASE ERROR ***'        S01117
      *                                                                   138352
     O          E    L1   N75TOTOU1         2 03                                138352
     O         AND     NU7N33                                                   138352
     O         AND      97
     O         OR    LR   N75                                                   138352
     O*******AND         NU7 33                                                        138352 CFC006
     O         AND   97NU7 33
     O*******OR*       43                                                              CLE039 CFC006
     O         OR    43 97
     O                                           24 'REFERENCE  LE0300P1'       138352
     O                       TITL                89                             138352
     O                                          104 'DATE'                      138352
     O                       RUNA               112                             138352
     O                                          122 'PAGE'                      138352
     O                       PAGE          Z    127                             138352
      *                                                                   138352
     O********E* 1     L1   N75TOTOU1                                                  138352 CFC006
     O          E    L1 97N75TOTOU1         1
     O         AND     NU7N33                                                   138352
     O*******OR*       LR   N75                                                        138352 CFC006
     O         OR    LR 97N75
     O         AND     NU7 33                                                   138352
     O*******OR*       43                                                              CLE039 CFC006
     O         OR    43 97
     O                                           59 'FACILITIES '               138352
     O                                           76 'MAINTENANCE TODAY'         138352
     O                    N33                    86 'BRANCH'                    138352
     O                    N33BRCA                90                             138352
     O                    N33                    91 '-'                         138352
     O                    N33BRNM               121                             138352
      *                                                                   138352
     O********E* 3     L1   N75TOTOU1                                                  138352 CFC006
     O          E    L1 97N75TOTOU1         3
     O         AND     NU7N33                                                   138352
     O*******OR*       LR   N75                                                        138352 CFC006
     O         OR    LR 97N75
     O         AND     NU7 33                                                   138352
     O*******OR*       43                                                              CLE039 CFC006
     O         OR    43 97
     O                                           59 '-----------'               138352
     O                                           76 '-----------------'         138352
      *                                                                   138352
     O********E*23     L1   N75TOTOU1                                                  138352 CFC006
     O          E    L1 97N75TOTOU1      2  3
     O*******AND         NU7N33                                                        138352 CLE039
     O         AND  N43NU7N33
     O*******OR*       LR   N75                                                        138352 CFC006
     O         OR    LR 97N75
     O*******AND         NU7 33                                                        138352 CLE039
     O         AND  N43NU7 33
     O                                           76 '*** NO DETAILS TO REPORT'  138352
     O                                           80 '***'                       138352
     O********E* 2     43      TOTOU1                                                  CLE039 CFC006
     O          E    43 97   TOTOU1         2
     O                                           13 'CUSTOMER'
     O                       CRNM                36
     O                       BBCUST              46
     O                                           67 'FACILITY TYPE'
     O                       FACTA               72
     O                                           79 'NO.'
     O                       FCNOA               83
     O/COPY WNCPYSRC,LEH00095
     O                                          122 'ACTION'
     O                       ACTN               125
      *                                                                                       CLE039
      *                                                                   138352
     O********T* 326   L1   N75                                    S01117 MOF60
     O*******AND         NU7N33                                    S01117 MOF60
     O*******OR*       LR   N75                                    S01117 MOF60
     O*******AND         NU7 33                                    S01117 MOF60
     O**********                     76 '*** NO DETAILS TO REPORT' S01117 MOF60
     O**********                         80 '***'                  S01117 MOF60
     O********T*3      L1N33NU7                                    S01117 MOF60
     O          E    L1N33NU7TOTOU2      3                                      MOF60
     O         AND      97
     O                                           66 '*** END OF REPORT FOR'     MOF60
     O                                           74 ' BRANCH '                  MOF60
     O                       BRCA                77                             MOF60
     O                                           81 ' ***'                      MOF60
     O********T*3      LR 33NU7                                    S01117 MOF60
     O          E    LR 33NU7TOTOU3      3                                      MOF60
     O         AND      97
     O                                           76 '*** END OF REPORT ***'     S01117
     O*
     O/COPY WNCPYSRC,LEH01007
     OLE0300P3  D    30 09                  2 03
     O         OR    OG
     O                                           24 'REFERENCE  LE0300P3'
     O                       TITL                89
     O                                          104 'DATE'
     O                       RUNA               112
     O                                          122 'PAGE'
     O                       PAGE          Z    127
     O          D    30 09                  1
     O         OR    OG
     O                                           48 'AGGREGATE '
     O                                           59 'FACILITIES '
     O                                           76 'MAINTENANCE TODAY'
     O                    N33                    86 'BRANCH'
     O                    N33BRCA                90
     O                    N33                    91 '-'
     O                    N33BRNM               121
     O          D    30 09                  3
     O         OR    OG
     O               09                          48 '----------'
     O                                           59 '-----------'
     O                                           76 '-----------------'
     O          D    30 09                  2
     O         OR    OG
     O                                           13 'CUSTOMER'
     O                       FCCRNM              36
     O                       FCCUST              46
     O                                           67 'FACILITY TYPE'
     O                       FACTA               72
     O                                           79 'NO.'
     O                       FCNOA               83
     O/COPY WNCPYSRC,LEH00093
     O                                          122 'ACTION'
     O                       ACTN               125
     O          D    30 09                  2
     O                                           14 'FCLT/CMMT'
     O                       FCTI                17
     O                                           27 'CCY'
     O                       FCCY                32
     O              N78 38   FAMT                65 ' ,   ,   , 0 .   -'
     O              N78 37   FAMT                65 '  ,   ,   , 0 .  -'
     O              N78 36   FAMT                65 '   ,   ,   , 0 . -'
     O              N78 35   FAMT                65 ' ,   ,   ,   , 0 -'
     O               78                          55 'PREVIOUS AMOUNT'
     O               78 38   PRVAMT              73 ' ,   ,   , 0 .   -'
     O               78 37   PRVAMT              73 '  ,   ,   , 0 .  -'
     O               78 36   PRVAMT              73 '   ,   ,   , 0 . -'
     O               78 35   PRVAMT              73 ' ,   ,   ,   , 0 -'
     O               78                          89 'NEW AMOUNT'
     O               78 38   FAMT               107 ' ,   ,   , 0 .   -'
     O               78 37   FAMT               107 '  ,   ,   , 0 .  -'
     O               78 36   FAMT               107 '   ,   ,   , 0 . -'
     O               78 35   FAMT               107 ' ,   ,   ,   , 0 -'
     O          D    30 09                  2
     O                                           16 'A/C OFFICER'
     O                       ACOF                35
     O                                           51 'OVER LINE %'
     O                       OVPC                63 '0 .   '
     O               13                          92 'OVER LINE AMT'
     O               13 38   OVAM               112 ' ,   ,   , 0 .   -'
     O               13 37   OVAM               112 '  ,   ,   , 0 .  -'
     O               13 36   OVAM               112 '   ,   ,   , 0 . -'
     O               13 35   OVAM               112 ' ,   ,   ,   , 0 -'
     O                                          123 'SECURED'
     O                       SECI               125
     O          D    30 09                  1
     O                                           15 'START DATE'
     O               50      DTAPO               35
     O                                           52 'DATE EXPIRES'
     O               51      DTEXO               69
     O                                           88 'NARRATIVE'
     O                       NAR1               125
     O          D    30 09                  1
     O                       NAR2               125
     O          D    30 09                  1
     O                                           21 'REVOLVING CREDIT'
     O                       RVCR                35
     O               79                          58 'DATE REV. CR. IND.'
     O               79                          66 'CHANGED'
     O               79      RVCDO               74
     O                       NAR3               125
     O          D    30 09                  1
     O                       NAR4               125
     O          D    30 09                  2
     O                                           19 'MULTI CURRENCY'
     O                       MCCY                35
     O                                           54 'MULTI CUSTOMER'
     O                       MCSI                69
     O          D    30 09                  2
     O                                           20 'COUNTRY OF RISK'
     O                       CRSK                35
     O                                           55 'ALTERNATIVE N/A'
     O                       NACD                69
     O                                           97 'DATE LAST FIN STMT'
     O               52      DLFSO              111
     O          D    30 09                  2
     O                                           17 'NOMINAL RATE'
     O                       NOMR                35 '  0 .       '
     O                                           57 'BILLING/TELEX IND'
     O                       BTIN                69
     O                                           91 'BILLING DAYS'
     O                       BLDY               111 '0 '
     O          D    30 09                  2
     O                                           16 'REVIEW DATE'
     O               53      RVDTO               35
     O                                           49 'FREQUENCY'
     O                       RVFR                69
     O                                           85 'DAY NO'
     O               58      RVDY               111
     O          D    30 09                  2
     O                    N77                    17 'PROFIT CENT.'
     O                    N77PRFC                35
     O                    N76                    58 'ORIGINATING BRANCH'
     O                    N76ORBR                69
     O          D    30 09                  2
     O                    N33                    17 'MULTI BRANCH'
     O                    N33MBFC                35
     O                     61                    58 'LOAN ADMINISTRATOR'
     O                     61LAID                69
     O          D    15 09                  2
     O                     15                    18 'DRAWING TYPES'
     O                     15RDTPS1              35
     O                     15                    95 'DEFAULT INTEREST'
     O                     15                   101 'BASIS'
     O                     15DICB               111
     O          D    15 09                  2
     O                     15                    19 'ROLLOVER TYPES'
     O**********             15RRTPS1    35                                          CLE041 AR750770
     O                     15RRTPS1              65                                               AR
     O                     15                    97 'IRREGULAR ROLLOVER'
     O                     15                   104 'PERIOD'
     O                     15RLPD               111
     O          D    15 09                  2
     O                     15                    23 'CURRENCY SELECTION'
     O                     15CSEL                35
     O                     15                    99 'ALLOWABLE CURRENCIES'
     O          D    15 09                  1
     O                     15ALC1               101
     O          D    15 09                  1
     O                     15ALC2               101
     O          D    15 09                  2
     O**********             15          19 'DATE COMMITTED'                          CLE041 246031A
     O**********             15WCOMD     35                                           CLE041 246031A
     O                  11 15                    17 'CLOSING DATE'                                 2
     O                  11 15WCDTC               35                                                2
     O                     15                   101 'LAST AVAILABILITY DATE'
     O                     15WAVLD              111
     O          D    15 09                  2
     O*********              15          14 'BASE RATE'                               CLE041 BUG8943
     O                     15                    19 'BASE RAT CODE'                         CLE041 B
     O                     15LPBR                35
     O                     15                    60 'LAST PAYMENT PENALTY'
     O                     15                    65 'TYPE'
     O                     15LPTP                69
     O                     15                    85 'AMOUNT'
     O                     15LPA0               111
     O          D    15 14                  2                                                      B
     O         AND   09                                                                            B
     O                     15                    14 'BASE RATE'                                    B
     O                     15WXPRT               35 '  0 .       '                                 B
     O          D    30 28 09               2
     O                                           20 'TR/CA INDICATOR'
     O                       TRCA                35
     O          D    30 28 09               2
     O                                           26 'CR AGREEMENT CUSTOMER'
     O                       TNAM                48
     O                       TANM                56
     O                                           91 'FCTY TYPE/NO'
     O                       TAFT                96
     O                       TAFN                99
     O/COPY WNCPYSRC,LEH00131
     O          D    15 09                  2
     O                                           28 'ACCOUNT SEQUENCE NUMBER'
     O                     15ACSQ                35
      *                                                                                       CLE041
     O          D    30 28 09               2
     O                                           18 'APPROVAL DATE'
     O                       RCOMD               35
     O                                           52 'CR AGREEMENT'
     O                                           66 'EXCHANGE RATE'
     O                       RCAXR               69
     O                                           92 'EXCH RATE IND'
     O                       RCMDI              111
     O          D    30 39 09               2
     O                                           19 'INSERTING USER'
     O                       IUSR                35
     O                                           53 'AMENDING USER'
     O                       AUSR                69
     O                                           95 'AUTHORISING USER'
     O                       XUSR               111
      *                                                                                       CLE041
     O          E    47 09   CUSGR3         1
     O                                           19 'CUSTOMER GROUP'
     O                       WCGRP               45
     O          E    43 09   ELICU3         1
     O                                           24 'ELIGIBLE CUSTOMERS:'
     O**********      N45                35 'NONE'                                     CLE041 242371
     O              N45      WNONE               35
     O          E    45 09   ELICU3         1
     O                       WCUST1              15
     O                       WCSSN1              29
     O                       WCRNM1              53
     O               44      WCUST2              85
     O               44      WCSSN2              99
     O               44      WCRNM2             123
      *                                                                                       CLE041
     O          E    16 09   XFCL31         1
     O                                           27 'DRAWDOWN CANNOT EXCEED'
     O                                           37 'AVAILABLE'
     O                       WXDEA               39
      *                                                                                       CLE041
     O          E    17 09   XFCL32         1
     O                                           14 'PORTFOLIO'
     O                       WXPOR               19
     O                                           60 'REQUIRED LOAN TO VALUE'
     O                                           66 'RATIO'
     O                       WXLVR               70
     O                                           99 'ADVANCE LOAN TO VALUE'
     O                                          105 'RATIO'
     O                       WXALV              109
      *                                                                                       CLE041
     O          E    17 09   XFCL33         1
     O                                           24 'LOAN TO VALUE RATIO'
     O                                           36 'ALERT LEVEL'
     O                       WXLVA               40
     O                                           97 'LOAN TO VALUE RATIO'
     O                                          111 'WARNING LEVEL'
     O                       WXLVW              115
      *                                                                                       CLE041
     O          E    17 09   XFCL34         1
     O                                           20 'SUBJECT TO CALL'
     O                       WXSTC               22
     O                                           61 'PERCENTAGE OVER WARNING'
     O                                           76 'FOR FIRST CALL'
     O                       WXPWF               82
      *                                                                                       CLE041
     O          E    17 09   XFCL35         1
     O                                           62 'PERCENTAGE INCREMENT FOR'
     O                                           78 'SUBSEQUENT CALL'
     O                       WXPIS               82
      *                                                                                       CLE041
     O          E    18 09   XFCL36         1
     O                                           27 'OVERALL MARGIN DEALING'
     O                                           33 'LIMIT'
     O                  38   WXOML               65 ' ,   ,   , 0 .   -'
     O                  37   WXOML               65 '  ,   ,   , 0 .  -'
     O                  36   WXOML               65 '   ,   ,   , 0 . -'
     O                  35   WXOML               65 ' ,   ,   ,   , 0 -'
     O                                           98 'MARGIN SCHEDULE TYPE'
     O                       WXMST              102
     O          D    40 75 09               2
     O         AND   30
     O                                           18 'SEVERITY CODE'
     O                       RSVCD               43
     O          E    U7 U8 09TOTO3T         2 40
     O                                           51 '*** REFERENCE LE0300'
     O                                           72 'DATABASE ERROR ***'
      *                                                                                       CLE041
     O          E    L1 09N75TOTO31         2 03
     O         AND     NU7N33
     O         OR    LR 09N75
     O         AND     NU7 33
     O         OR    43 09
     O                                           24 'REFERENCE  LE0300P3'
     O                       TITL                89
     O                                          104 'DATE'
     O                       RUNA               112
     O                                          122 'PAGE'
     O                       PAGE          Z    127
      *                                                                                       CLE041
     O          E    L1 09N75TOTO31         1
     O         AND     NU7N33
     O         OR    LR 09N75
     O         AND     NU7 33
     O         OR    43 09
     O                                           59 'FACILITIES '
     O                                           76 'MAINTENANCE TODAY'
     O                    N33                    86 'BRANCH'
     O                    N33BRCA                90
     O                    N33                    91 '-'
     O                    N33BRNM               121
      *                                                                                       CLE041
     O          E    L1 09N75TOTO31         3
     O         AND     NU7N33
     O         OR    LR 09N75
     O         AND     NU7 33
     O         OR    43 09
     O                                           59 '-----------'
     O                                           76 '-----------------'
      *                                                                                       CLE041
     O          E    L1 09N75TOTO31      2  3
     O         AND  N43NU7N33
     O         OR    LR 09N75
     O         AND  N43NU7 33
     O                                           76 '*** NO DETAILS TO REPORT'
     O                                           80 '***'
     O          E    43 09   TOTO31         2
     O                                           13 'CUSTOMER'
     O                       CRNM                36
     O                       BBCUST              46
     O                                           67 'FACILITY TYPE'
     O                       FACTA               72
     O                                           79 'NO.'
     O                       FCNOA               83
     O/COPY WNCPYSRC,LEH00096
     O                                          122 'ACTION'
     O                       ACTN               125
      *                                                                                       CLE041
     O          E    L1N33NU7TOTO32      3
     O         AND   09
     O                                           66 '*** END OF REPORT FOR'
     O                                           74 ' BRANCH '
     O                       BRCA                77
     O                                           81 ' ***'
     O          E    LR 33NU7TOTO33      3
     O         AND   09
     O                                           76 '*** END OF REPORT ***'
      *                                                                                       CLE041
     O/COPY WNCPYSRC,LEH01008
     OLE0300AU  E    66                     2 03                                S01117
     O                                           24 'REFERENCE  LE0300AU'       S01117
     O                       TITL                89                             S01117
     O                                          104 'DATE'                      S01117
     O                       RUNA               112                             S01117
     O                                          122 'PAGE'                      S01117
     O                       PAGE1         Z    127                             S01117
     O          E    66                     1                                   S01117
     O                                           59 'FACILITIES '               S01117
     O                                           76 'MAINTENANCE TODAY'         S01117
     O                                           92 'RUN CONTROLS'              S01117
     O          E    66                     3                                   S01117
     O                                           59 '-----------'               S01117
     O                                           76 '-----------------'         S01117
     O*                                                                   S01117
     O********EF*217** 08 66                                              S01117
     O          EF   66                     2 17                                S01117
     O                                           18 'RUN CONTROLS'
     O                                           65 '------------'
     O                                           84 'REPORT -----------'
     O***********                       102 '---------'                   S01117
     O***********                       124 'FILE CONTROL --------'       S01117
     O                  08                      102 '---------'                 S01117
     O                  08                      124 'FILE CONTROL --------'     S01117
     O********E**2*    08 66                                              S01117
     O          E    66                     2                                   S01117
     O                                           59 'NUMBER'
     O***********                        84 'VALUE'                       S01117
     O***********                        99 'NUMBER'                      S01117
     O***********                       124 'VALUE'                       S01117
     O                  08                       84 'VALUE'                     S01117
     O                  08                       99 'NUMBER'                    S01117
     O                  08                      124 'VALUE'                     S01117
     O********E**2*    08 66                                              S01117
     O          E    66                     2                                   S01117
     O                                           28 'FACILITIES LISTED IN'
     O                                           40 'THIS REPORT'
     O                       NFAC                59 '   0 '
     O          E    08 66                  2
     O                                           28 'RECORDS BEFORE INPUT'
     O                                           34 'CYCLE'
     O**********               NLRB  3   99                                                   CLE041
     O**********               VLBF  Z  121                                                   CLE041
     O**********               VLBL     124                                                   CLE041
     O                       WNLRB         3     99
     O                       WVLBF         Z    121
     O                       WVLBL              124
     O          E    08 66                  2
     O                                           24 'RECORDS INSERTED'
     O                       NRINS         3     59
     O**********               NINS  3   99                                                   CLE041
     O**********               VRIF  Z  121                                                   CLE041
     O**********               VRIL     124                                                   CLE041
     O                       WNINS         3     99
     O                       WVRIF         Z    121
     O                       WVRIL              124
     O          E    08 66                  1
     O                                           23 'RECORDS DELETED'
     O                       NRDEL         3     59
     O**********               NDEL  3   99                                                   CLE041
     O**********               VRDF  Z  121                                                   CLE041
     O**********               VRDL     124                                                   CLE041
     O                       WNDEL         3     99
     O                       WVRDF         Z    121
     O                       WVRDL              124
     O          E    08 66                  2
     O                                           23 'RECORDS AMENDED'
     O**********               VRAF  Z  121                                                   CLE041
     O**********               VRAL     124                                                   CLE041
     O                       WVRAF         Z    121
     O                       WVRAL              124
     O               65                         125 '-'
     O          E    08 66                  2
     O                                           27 'RECORDS AFTER INPUT'
     O                                           33 'CYCLE'
     O                       NROF          3     59
     O                       LVTOTI        Z     81
     O                       LVTOTD              84
     O**********               NLRA  3   99                                                   CLE041
     O**********               VLAF  Z  121                                                   CLE041
     O**********               VLAL     124                                                   CLE041
     O                       WNLRA         3     99
     O                       WVLAF         Z    121
     O                       WVLAL              124
     O**********       U8               128 '***'                                             236008
     O               11                         128 '***'
     O********E*23*    08 66 U8                                           S01117
     O          E    08 66               2  3                                   S01117
     O*******AND***    U8NU7                                                           S01117 236008
     O         AND   11NU7
     O                                          128 '***   DIFFERENCE   ***'
     O          T    U7 U8 LR               2 40                                S01117
     O                                           51 '*** REFERENCE LE0300'      S01117
     O                                           71 'DATABASE ERROR AT'         S01117
     O                       DBASE               75                             S01117
     O********T*       U7 U8 LR                                    S01117 MOF60
     O          T    U7 U8 LR               1                                   MOF60
     O                                           39 'FILENAME'                  S01117
     O                       DBFILE              48                             S01117
     O                                           52 'KEY'                       S01117
     O                       DBKEY               82                             S01117
      *                                                                   S01117
     O********T*23    NU7NU8 LR                                    S01117 138352
     O*******AND*     N74                                          S01117 138352
     O***********                        76 '*** NO DETAILS TO REPORT'117 138352
     O***********                        80 '***'                  S01117 138352
     O********E**2     08 66                                              S01117
     O***********                        68 '***   END OF REPORT'         S01117
     O***********                        74 '***'                         S01117
     O*
     O*CLTY***D**      31N34                                              S01117
     OFCLTYZZ   D    31N34                                                      S01117
     O                       NLRB                25P
     O                       NINS                28P
     O                       NDEL                31P
     O                       VLBF                42P
     O                       VLBL                44P
     O                       VRIF                52P
     O                       VRIL                54P
     O                       VRDF                62P
     O                       VRDL                64P
     O                       VRAF                72P
     O                       VRAL                74P
** CPY@   **      OBJECT COPYRIGHT
(c) Finastra International Limited 2001
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
