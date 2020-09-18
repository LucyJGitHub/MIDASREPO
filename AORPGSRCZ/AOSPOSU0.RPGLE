     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************   CAP002
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Control update to online positions')          *
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects Module                                *
      *                                                               *
      *     AOSPOSU0 - Control Update On-line Positions File          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD034505           Date 26May15               *
      *                 AR868380           Date 10Jun13               *
      *                 CLE134             Date 01Aug12               *
      *                 BUG27966A          Date 05Aug10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 19Feb10               *
      *                 CAP204             Date 15Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 248460             Date 18Jun07               *
      *                 246761             Date 30Mar07               *
      *                 CPK027             Date 16Apr07               *
      *                 243307             Date 10Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CRE026             Date 24May06               *
      *                 BUG12821           Date 11Dec06               *
      *                 241290             Date 29Aug06               *
      *                 CSD027             Date 09Dec05               *
      *                 240690             Date 29Jun06               *
      *                 BUG8796            Date 13Jun06               *
      *                 206839             Date 06Jun06               *
      *                 BUG10860           Date 21Apr06               *
      *                 BUG7370            Date 07Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 TDA100             Date 30Mar04               *
      *                 CRE020             Date 20Jan04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 210092             Date 13Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 197145             Date 23Aug01               *
      *                 187042             Date 29Jun00               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 181176             Date 13Dec00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 174470             Date 31Oct00               *
      *                 172073             Date 27Oct00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 27Jul99               *
      * Midas DBA 3.00 ---------------- Base ----------------------------*
      *                 141213             Date 23Aug98               *
      *                  CAP002             Date 01May98                 *
     F*                  125373B            DATE  18FEB98                *
     F*                  122960             DATE  15SEP97                *
     F*                  122601             DATE  04SEP97                *
     F*                  CCB002             DATE  11JUL96                *
     F*                  082738             DATE  17MAR95                *
     F*                  080050             DATE  26JAN95                *
     F*                  068347             DATE  18MAR94                *
     F*                  S01435             DATE  11SEP93                *
     F*                  053418             DATE  03JUN93                *
     F*                  S01414             DATE  29MAR93                *
     F*                  041693             DATE  05JAN93                *
     F*                  045014             DATE  07DEC92                *
     F*                  031876             DATE  28OCT92                *
     F*                                                                  *
     F*------------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034505 - Database error encountered when Ordering Customer    *
      *             is a Customer Number or Accountline                  *
      *           - Partially applied BUG19263                           *
      *           - Applied for MD-37748                                 *
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  CLE134 - Past Due Call Loan Processing                          *
      *  BUG27966A - Improve run-time performance                        *
      *            - Only occurences and array elements that were        *
      *              populated should be processed                       *
      *  CAP205 - Teller Related APIs - Account Balance Check            *
      *  CAP204 - Teller Related APIs - Account Transfer                 *
      *  248460 - Can't use CALLB, as there is a RCLRSC somewhere...     *
      *  246761 - Posting Date is incorrectly calculated.             *
      *  CPK027 - Fix 243307 applied incorrectly (NB. at this release    *
      *           only, fix is correct at later releases)                *
      *  243307 - Prevents commitment control error from occurring       *
      *           (CPF4293) during file OPEN.                            *
      *  CRE026 - Consumer Banking (Recompile)                           *
      *  BUG12821-Decimal data error occured due to wrong data        *
      *           mapping. Applied fix 241290.                        *
      *  241290 - Incorrect DR/CR indicator for sell amount of a CX   *
      *           deal.  Reversed core fix BUG10860.                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  240690 - Applied fix 232494.                                 *
      *  232494 - Database error in AOSPOSU0 when using IPN1 and FTMG *
      *  BUG8796 - Add checking on SDNOSTPD when ATYP = 'N' If no     *
      *            record found, ##NOS should not be set to 'Y'       *
      *  206839 - 172073 causes the key for chaining to SDNOSTPD not to  *
      *           be setup, leaving the values from the last time a      *
      *           nostro was processed. As a result, non-nostro accounts *
      *           are causing updates to nostro positions.               *
      *           If an account is not found, the processing should      *
      *           simply be skipped altogether.                          *
      *  BUG10860 - DR/CR indicator on account movements file not     *
      *             maintained                                        *
      *  BUG7370 - When no record is found in PRONOPN, do not zeroise *
      *            CUSN, ACDE and ASNC to prevent failure of component*
      *            LEC000030.                                         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  TDA100 - When entering Lending Transactions, no shadow       *
      *           posting records are generated.  This is due to      *
      *           the wrong field definition of data structure        *
      *           subfield W#NR (Nortro or Retail Flag).              *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  210092 - Incomplete fix 197145.  Lengthen the DS of AR#KEY   *
      *           because sequence is being concatenated for A#SEQ.   *
      *  197145 - Dumps and settlement instructions are lost for      *
      *           deals                                               *
      *  187042 - Set up the fields for the posting details to allow the *
      *           correct update of the projected account movements.     *
      *  181176 - Include Branch Code among the fields used for       *
      *           checking duplicate records in subroutine SRRPST.    *
      *  174470 - Data structure fields for posting details should be *
      *           set up if the retail account exists in ACCNTAB.     *
      *  172073 - Prevent occurrence of DB error when amending a loan *
      *           settled through closed accounts(start/maturity).    *
      *           Applied fix 147942.                                 *
     F*  CFT004 - International Bank Account Number                      *
     F*           Allow Account Type = 'I' for IBAN                      *
      *  141213 - Fix 125373B will corrupt the database if errors occur. *
      *  CAP002 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
     F*     125373B- Remove DB error if account not found: DUMP pgm and  *
     F*              continue processing                                 *
     F*     122960 - Do not rollback lending updates in batch mode.      *
     F*     122601 - Schedule repayment did not update retail projected  *
     F*              movement.                                           *
     F*     CCB002 - COB Performance Enhancements                        *
     F*              Access now via access object                        *
     F*              MEMOS is now accessed via GL/RE key rather than     *
     F*              old relative record number.                         *
     F*     082738 - Allow update of OLPOS with no settlement            *
     F*     080050 - Narrative code on RSACMTPD changed to               *
     F*              alphanumeric.                                       *
     F*     068347 - Suppress Account movement duplicates.               *
     F*     S01435 - Incoming Message Management.                        *
     F*              Add action start to improve performance             *
     F*     053418 - Incoming payments not appearing on projected        *
     F*              account movements enquiry. Add new program, FT0055, *
     F*              to control update of OLPOS, MEMOS and PRONO.        *
     F*     S01414 - Book Code and Profit Centre Incorporation.          *
     F*              Rename of profit centre field on ACCNTABF           *
     F*                                                                  *
     F*     041693 - Delivered as part of fix.                           *
     F*                                                                  *
     F*     045014 - Add call to AOCNTLR0 for access control             *
     F*              Include SDMMODL1 processing                         *
     F*              Add primary transaction                             *
     F*              Correct OLPOS processing - sign incorrect for       *
     F*              outgoing amounts                                    *
     F*                                                                  *
     F*     031876 - New program to control update to OLPOS, MEMOS       *
     F*              and PRONO.                                          *
     F*                                                                  *
     F*****************************************************************
     FACCNT     IF   E           K DISK    INFSR(SRFILE)
     F                                     USROPN
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
      *
      * Define Accounts file
      *
     F*ACNUMA****IF***E***        K DISK    INFSR(SRFILE)                                     243307
     FACNUMB    IF   E           K DISK    INFSR(SRFILE)                                      243307
     F                                     USROPN
     F                                     RENAME(ACCNTABF:REACNOF)
      *
      * Define Retail Accounts file
      *
     FSDNOSTL1  IF   E           K DISK    INFSR(SRFILE)
     F                                     USROPN
     F                                     RENAME(@A7REB9:@NOSTL1)
      *
      * Define Nostros file (Key nostro currency nostro number)
      *
     FSDNOSTL2  IF   E           K DISK    INFSR(SRFILE)
     F                                     USROPN
     F                                     RENAME(@NOSTBH:@NOSTL2)
      *
      * Define Nostros file (Key customer account number)
      *
     FPRONO     IF   E           K DISK    INFSR(SRFILE)
     F                                     INFDS(@PRONO)                                    AR868380
     F                                     USROPN
     F                                     IGNORE(PRONOHHF)
      *
      * Define Prono file (Commit control as called programs use it)
      *
     FSDBANKL1  IF   E           K DISK    INFSR(SRFILE)
     F                                     USROPN
     F                                     RENAME(@BJREEF:@BANKL1)              045014
      *
      * Define SDBANKL1 for working day & next working day
      *
     FSDGELRL1  IF   E           K DISK    INFSR(SRFILE)                                      246761
     F                                     USROPN                                             246761
     F                                     RENAME(@BKREEC:@GELRL1)                            246761
      *                                                                                       246761
      * Define SDGELRL1 for Accrual on Non-Working Day indicator                              246761
      *                                                                                       246761
     FREADVCL4  UF A E           K DISK    INFSR(SRFILE)                                      CRE020
     F                                     USROPN                                             CRE020
     FSDMMODL1  IF   E           K DISK    INFSR(SRFILE)                        045014
     F                                     USROPN
     F                                     RENAME(@BGREC8:@MMODL1)              045014
      *                                                                   045014
      * Define SDMMODL1 for modules present                               045014
     F/COPY WNCPYSRC,AOSPOSU0F1
      *                                                                   045014
     F/EJECT
      *
      *  Copyright table
      *
      *
      *  List of valid calling programs
      *
     D***********         PGM@    1   9 10                                053418
     D PGM@            S             10    DIM(10) CTDATA PERRCD(1)                              053
      *
      *  Error texts
      *
     D ERR@            S             80    DIM(8) CTDATA PERRCD(1)
     D MNTID           S             10    DIM(34) CTDATA PERRCD(1)                           CRE020
     D MNTD@           S             10    DIM(34) CTDATA PERRCD(1)                           CRE020
     D SYSV@           S             20    DIM(34) CTDATA PERRCD(1)                           CRE020
      *
      *  Subroutine stack
      *
     D @STK            S             10    DIM(20)
      *
      *  Array of Memos RRN's and occurs
      *
     D*@ME******       S             10    DIM(60)                                            197145
     D*@ME******       S             10    DIM(2000)                                   197145 210092
     D @ME             S             13    DIM(2000)                                          210092
      *
      *  Array of Nostro's and occurs
      *
     D*@NS******       S             10    DIM(60)                                            197145
     D*@NS******       S             10    DIM(2000)                                   197145 210092
     D @NS             S             13    DIM(2000)                                          210092
      *
      *  Array of Currencies and occurs
      *
     D*@CY******       S             10    DIM(60)                                            197145
     D*@CY******       S             10    DIM(2000)                                   197145 210092
     D @CY             S             13    DIM(2000)                                          210092
      *                                                                   068347
      *  Array of Entries that may be removed                             068347
      *                                                                   068347
     D*@RP******       S             10    DIM(60)                                        068 197145
     D*@RP******       S             10    DIM(2000)                                   197145 210092
     D @RP             S             13    DIM(2000)                                          210092
     D*                                                                   S01414
      *
      *  Data structure for compilation  - Copyright insertion
      *
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
     D @PRONO        E DS                  EXTNAME(Y2IUDSP)                                 AR868380
      *
      *  Program data structure
      *
     D DSPGM         ESDS                  EXTNAME(Y2PGDSP)
      *
      *  Send message data structure
      *
     D DBDTA           DS
     D  DBPGM                  1     10
     D  DBFILE                11     20
     D  DBKEY                 21     50
     D  DBERNB                51     55  0
     D  DBNARR                56    135
     D  DBSTK                136    145
     D  DBPREF               146    175                                         045014
                                                                                              CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  COMITARR               4    103                                                       CSC022
      ** The following fields are defined in the external file:                               CSC022
                                                                                              CSC022
      ** Array of Commitment Job Names                                                        CSC022
     D COMITJOB        S             10A   DIM(10)                                            CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
      * Data Structure for Midas SAR Details                                                  CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
      *                                                                                       CSC022
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSC022
      ** ZMITEM Data Area                                                                     CRE020
     D ZMITEM        E DS                  EXTNAME(ZMITEM) DTAARA(ZMITEM)                     CRE020
      *
      *  Occurrance data structure to keep posting details
      *
     D*POST*****       DS                  OCCURS(60)                                         197145
     D POST            DS                  OCCURS(2000)                                       197145
     D**W#CNUM**               1      6  0                                                    CSD027
     D  W#CNUM                 1      6                                                       CSD027
     D  W#CCY                  7      9
     D**W#ACOD**              10     13  0                                                    CGL029
     D**W#ACSQ**              14     15  0                                                    CGL029
     D**W#ACCT**               1     15                                                       CGL029
     D**W#ACNO**              16     25  0                                                    CGL029
     D**W#NOSN**              26     27  0                                                    CGL029
     D**W#IO****              28     28                                                       CGL029
     D**W#SET***              29     29                                                       CGL029
     D**W#AMT***              30     37P 0                                                    CGL029
     D**W#VDAT**              38     40P 0                                                    CGL029
     D**W#PSTD**              41     43P 0                                                    CGL029
     D**W#TRYP**              44     45                                                       CGL029
     D**W#NARR**              46     75                                                       CGL029
     D**W#CHQN**              76     83  0                                                    CGL029
     D**W#PREF**              84     98                                                       CGL029
     D**W#TRN***              99    104                                                       CGL029
     D**W#RRNM**             105    109  0                                                    CGL029
     D**W#PRON**             110    110                                                       CGL029
     D**W#OLPS**             111    111                                                       CGL029
     D**W#MEMS**             112    112                                                       CGL029
     D**W#RSAC**             113    113                                                       CGL029
     D**W#MOD***             114    115                                                       CGL029
     D**W#OLRC**             116    117                                                       CGL029
     D**W#NR****             118    118                                                       CGL029
     D**W#FTOV**             119    119                                                       CGL029
     D**W#BRCA**             120    122                                                       CGL029
     D  W#ACOD                10     19  0                                                    CGL029
     D  W#ACSQ                20     21  0                                                    CGL029
     D  W#ACCT                 1     21                                                       CGL029
     D  W#ACNO                22     31  0                                                    CGL029
     D  W#NOSN                32     33  0                                                    CGL029
     D  W#IO                  34     34                                                       CGL029
     D  W#SET                 35     35                                                       CGL029
     D  W#AMT                 36     43P 0                                                    CGL029
     D  W#VDAT                44     46P 0                                                    CGL029
     D  W#PSTD                47     49P 0                                                    CGL029
     D  W#TRYP                50     51                                                       CGL029
     D  W#NARR                52     81                                                       CGL029
     D  W#GNAR                80     80                                                       CRE020
     D  W#CHQN                82     89  0                                                    CGL029
     D  W#PREF                90    104                                                       CGL029
     D  W#TRN                105    110                                                       CGL029
     D  W#RRNM               111    115  0                                                    CGL029
     D  W#PRON               116    116                                                       CGL029
     D  W#OLPS               117    117                                                       CGL029
     D  W#MEMS               118    118                                                       CGL029
     D  W#RSAC               119    119                                                       CGL029
     D  W#MOD                120    121                                                       CGL029
     D  W#OLRC               122    123                                                       CGL029
     D**W#NR****             124    126                                                CGL029 TDA100
     D  W#NR                 124    124                                                       TDA100
     D  W#FTOV               125    125                                                       CGL029
     D  W#BRCA               126    128                                                       CGL029
      *                                                                   068347
      *  Add data about removal of duplicates                             068347
      *                                                                   068347
     D**W#RPST**             123    123                                                068347 CGL029
     D**W#RPNB**             124    126  0                                             068347 CGL029
     D**W#RTYP**             127    127                                                068347 CGL029
     D  W#RPST               129    129                                                       CGL029
     D  W#RPNB               130    132  0                                                    CGL029
     D  W#RTYP               133    133                                                       CGL029
     D  W#OTR1               134    153                                                       CAP204
     D  W#MTYP               154    154                                                       CAP205
      *                                                                                       CLE134
      ** Exception Reference Id/Number                                                        CLE134
      *                                                                                       CLE134
     D  W#XRFI               155    157                                                       CLE134
     D  W#XRFN               158    167  0                                                    CLE134
      *
      *  File structure to allow call to AORSACW0 program
      *
     D P#RSAC        E DS                  EXTNAME(RSACMTPD)
     D/COPY WNCPYSRC,AOSPOSU0D2
     D  P#DTA                  1    256
     D/COPY WNCPYSRC,AOSPOSU0D3
      *
      *  Input parameters data structure
      *
     D I#DTA           DS           256
      *  Account type N=nostro nbr F=Full nostro G=General Ledger
      *               P=Partial Ledger R= Retail Number
     D  I#ATYP                 1      1
      *               Full General Ledger - CNUM/CCY/ACOD/ACSQ
     D  I#ACCT                 2     19
     D**I#CNU1**               2      7  0                                                    CSD027
     D  I#CNU1                 2      7                                                       CSD027
     D  I#CCY1                 8     10
     D**I#ACO1**              11     14  0                                                    CGL029
     D  I#ACS1                15     16  0
     D  I#BRC1                17     19
      *               Nostro number
     D  I#NOSN                 2      3  0
      *               Full Nostro - CCY/NOSN
     D  I#NOS                  2      6
      *               Retail Number
     D  I#ACNO                 2     11  0
      *               Partial Account - CNUM/ACOD/ACSQ
     D**I#CNUM**               2      7  0                                                    CSD027
     D  I#CNUM                 2      7                                                       CSD027
     D**I#ACOD**               8     11  0                                                    CGL029
     D  I#ACSQ                12     13  0
      *               Branch of account if Partial                      '
     D  I#BRCA                14     16
      *               OLPOS Incoming/Outgoing Indicator 'I' or 'O' or ' '
      *                     ' ' no OLPOS update
     D  I#IO                  24     24
      *               Currency of transaction
     D  I#CCY                 25     27
      *               Transaction Type
     D  I#TRYP                28     29
      *               Transaction Narrative
     D  I#NARR                30     59
      *               Cheque Number
     D  I#CHQN                60     67  0
      *               FT transaction reference
     D  I#PREF                68     82
      *               DL/LE/GL/RE transaction reference
     D  I#TRN                 83     88
      *               Movement amount
     D  I#AMT                 89     96P 0
      *               Processing indicators Not blank = no update
      *                                     ' ' = Update
      *               Prono update indicator
     D  I#PRON                97     97
      *               Olpos update indicator
     D  I#OLPS                98     98
      *               Memos update indicator
     D  I#MEMS                99     99
      *               Rsacmtpd write indicator
     D  I#RSAC               100    100
      *               Module
     D  I#MOD                101    102
      *               Olpos record number to update
      *                     '01' for FX
      *                     '02' for Interest movements
      *                     '03' for MM loans and deposits
     D  I#OLRC               103    104
      *               FT Memos ledger balance override
      *                        'Y' update ledger balance irrespective of
      *                        posting date
     D  I#FTOV               105    105
      *               Value date and posting date
     D  I#VDAT               106    108P 0
     D  I#PSTD               109    111P 0
      *               Override posting date correction
      *                        for forward valued items
      *                        'Y' prevents date being changed
     D  I#PSTO               112    112
      *                                                                   068347
      *  Add data about removal of duplicates                             068347
      *                                                                   068347
      *               Indicator to show if removal allowed Y, N or " "    068347
     D  I#RPST               113    113                                         068347
      *               Removal set number                                  068347
     D  I#RPNB               114    116  0                                      068347
      *               Removal type "C" = Credit entries                   068347
      *                            "D" = Debit entries                    068347
     D  I#RTYP               117    117                                         068347
      *                                                                   082738
      *               Booking branch                                      082738
     D  I#BBRN               118    120                                         082738
     D  I#ACO1               121    130  0                                                    CGL029
     D  I#ACOD               131    140  0                                                    CGL029
     D  I#OTR1               141    160                                                       CAP204
     D  I#MTYP               161    161                                                       CAP205
      *                                                                                       CLE134
      ** Exception Reference Id/Number                                                        CLE134
      *                                                                                       CLE134
     D  I#XRFI               162    164                                                       CLE134
     D  I#XRFN               165    174  0                                                    CLE134
     D/COPY WNCPYSRC,AOSPOSU0D1
      *                                                                   045014
      *  Input parameters data structure for AOCNTLR0                     045014
      *                                                                   045014
     D P#CNTL          DS           256                                         045014
      *                                       Access Check                045014
     D  P#ACCK                 1      1                                         045014
      *
      *  Data structure for ACCNTAB key
      *
     D AC#KEY          DS
     D  K#BRCA                 1      3
     D**CNUM****               4      9  0                                                    CSD027
     D  CNUM                   4      9                                                       CSD027
     D  CCY                   10     12
     D**ACOD****              13     16  0                                                    CGL029
     D**ACSQ****              17     18  0                                                    CGL029
     D  ACOD                  13     22  0                                                    CGL029
     D  ACSQ                  23     24  0                                                    CGL029
      *
      *  Data structure for Nostro, Currencies and Retail arrays
      *
     D*AR#KEY***       DS            10                                                       210092
     D AR#KEY          DS            13                                                       210092
      *                                       Nostro Array
     D  A#NOS                  1      5
      *                                       Retail Array
     D  A#RRNM                 1      5  0
      *                                       Currency Array
     D  A#BRCA                 1      3
     D  A#CCY                  4      8
     D  A#KOLP                 1      8
      *                                                                   068347
      *  Add data about removal of duplicates                             068347
      *                                                                   068347
     D  A#RPST                 1      1                                         068347
     D  A#RPNB                 2      5  0                                      068347
     D  A#RTYP                 6      6                                         068347
      *                                       Occurs position
     D**A#SEQ***               9     10  0                                                    210092
     D  A#SEQ                  9     13  0                                                    210092
      ** Define fields used in CRE020                                                         CRE020
     D PRtcd           S              7A                                                      CRE020
     D PSysVal01       S             20A                                                      CRE020
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
                                                                                             BUG8796
      ** Nostro indicator                                                                    BUG8796
     D ##NIND          S              1A                                                     BUG8796
                                                                                             BUG8796
     I/EJECT
      *                                                                   S01414
      * Rename of ACCNTABF Profit Centre to avoid overwriting             S01414
      *                                                                   S01414
     IACCNTABF                                                                  S01414
     I              PRFC                        ACPRFC                          S01414
     IREACNOF                                                                   S01414
     I              PRFC                        ACPRFC                          S01414
     I/EJECT
      *
      *  Incoming parameter list
      *
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN             7
     C                   PARM                    W0ACT             8
     C                   PARM                    I#DTA
     C/COPY WNCPYSRC,AOSPOSU0C2
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      *                                                                   045014
      *  Reset primary transaction reference                              045014
      *                                                                   045014
     C                   MOVEL     *BLANKS       W0PREF                                        04501
     C                   MOVEL     I#DTA         W0PREF                                        04501
      *
      * Initialise program
      *
     C     *IN50         IFEQ      '0'
     C                   EXSR      SRINIT
     C                   END
      *                                                                   S01435
      * If action code start then exit                                    S01435
      *                                                                   S01435
     C     W0ACT         CABEQ     '*START'      EXMAIN                                        S0143
      *
      * Call subroutine depending on action code
      *
     C     W0ACT         CASEQ     '*CLEAR'      SRCLR
     C     W0ACT         CASEQ     '*ADD  '      SRADD
     C     W0ACT         CASEQ     '*UPDATE'     SRUPD
     C     W0ACT         CASEQ     '*COMMIT'     SRCMMT
     C                   CAS                     SRACT
     C                   END
      *
      *  Unwind subroutine stack name
      *                                                                   S01435
     C     EXMAIN        TAG                                                                   S0143
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      * Return to calling program
      *
     C                   RETURN
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCLR    : Clear data structures                             *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRCLR         BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRCLR '      @STK(Q)
      *
      *  Clear retail Memos array, occurrance data structure
      *  Nostro data array, currency array.
      *
     C                   CLEAR                   @ME
     C*****1****         DO        60            @X                5 0                        197145
     C*****1****         DO        2000          @X                5 0              197145 BUG27966A
     C*****@X***         OCCUR     POST                                                    BUG27966A
     C**********         CLEAR                   POST                                      BUG27966A
     C**********         END                                                               BUG27966A
     C                   CLEAR                   @NS
     C                   CLEAR                   @CY
     C                   CLEAR                   @RP                                          068347
     C**********         Z-ADD     0             @X                                        BUG27966A
     C                   Z-ADD     0             @X                5 0                     BUG27966A
     C                   Z-ADD     0             @N                5 0
     C                   Z-ADD     0             @R                5 0
     C                   Z-ADD     0             @C                5 0
     C                   Z-ADD     0             @P                5 0                        068347
      *
      *  Unwind subroutine stack name
      *
     C     EXCLR         TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRADD    : Add information to data structures                *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     CSR   SRADD         BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRADD '      @STK(Q)
      *
      *  Find general legder details of account passed
      *
     C                   MOVEL     *BLANKS       ##NOS             1
     C                   MOVEL     *BLANKS       ##RET             1
     C                   ADD       1             @X
      *
      *  Test to see if too many entries are being processed
      *
     C*****@X***         IFGT      60                                                         197145
     C     @X            IFGT      2000                                                       197145
     C                   MOVEL     'I#DTA   '    W0FILE
     C                   MOVEL     @X            W0KEY
     C                   Z-ADD     1             W0ERNB
     C                   MOVEL     ERR@(6)       W0NARR
     C                   EXSR      SRERR
     C                   END
      *
      *  Set position of occurrance data structure
      *
     C     @X            OCCUR     POST
     C                   CLEAR                   POST                                      BUG27966A
     C                   Z-ADD     -1            W#NOSN
      *
      *  Check that it is a valid account type
      *
     C     I#ATYP        IFEQ      'N'                                          Nostro Nbr
     C     I#ATYP        OREQ      'F'                                          Full Nostro
     C     I#ATYP        OREQ      'R'                                          Retail Nbr
     C     I#ATYP        OREQ      'G'                                          Ledger
     C     I#ATYP        OREQ      'P'                                          Partial Ldgr
     C     I#ATYP        OREQ      'C'                                                      MD034505
     C     I#ATYP        OREQ      'A'                                                      MD034505
     C     CFT004        OREQ      'Y'                                          IBAN          CFT004
     C     I#ATYP        ANDEQ     'I'                                          IBAN          CFT004
     C     I#ATYP        OREQ      'S'                                          SWIFT         232494
     C     I#ATYP        OREQ      'X'                                          No settlement  08273
     C                   ELSE
     C                   MOVEL     '*ACCOUNT'    W0FILE
     C                   MOVEL     '*INVALID'    W0KEY
     C                   Z-ADD     2             W0ERNB
     C                   MOVEL     ERR@(5)       W0NARR
     C                   EXSR      SRERR
     C                   END
      *
      *  If account is Nostro or Full nostro look up on SDNOSTL1
      *
     C     I#ATYP        IFEQ      'N'
     C     I#ATYP        OREQ      'F'
      *
     C     K#NOS1        KLIST
     C                   KFLD                    A7CYCD
     C                   KFLD                    A7NONB
      *
      *  Format key for SDNOSTL1 and read file for nostro
      *
     C     I#ATYP        IFEQ      'N'
     C                   MOVEL     I#CCY         A7CYCD
     C                   MOVEL     I#NOSN        A7NONB
     C                   ELSE
     C                   MOVEL     I#NOS         A7CYCD
     C                   MOVE      I#NOS         A7NONB
     C                   END
      *
     C     K#NOS1        CHAIN     @NOSTL1                            90
      *
     C     *IN90         IFEQ      '1'
     C     W0ACT         IFEQ      '*ADD  '                                     172073
     C                   GOTO      EXADD                                        172073
     C                   END                                                    172073
     C                   MOVEL     'SDNOSTL1'    W0FILE
     C     I#ATYP        IFEQ      'N'
     C                   MOVEL     I#CCY         A#NOS
     C                   MOVE      I#NOSN        A#NOS
     C                   MOVEL     A#NOS         W0KEY
     C                   ELSE
     C                   MOVEL     I#NOS         W0KEY
     C                   END
     C                   MOVEL     I#NOS         W0KEY
     C                   Z-ADD     3             W0ERNB
     C                   MOVEL     ERR@(3)       W0NARR
     C                   EXSR      SRERR
     C                   END
      *
      * Nostro found. Set nostro code in data structure
      *
     C                   MOVEL     'Y'           ##NOS
     C                   MOVEL     A7NONB        W#NOSN
      *
     C                   END
      *
      *  If account is not Retail look up on ACCNT
      *
     C     I#ATYP        IFNE      'R'
     C     I#ATYP        ANDNE     'S'                                                        232494
     C     I#ATYP        ANDNE     'X'                                                         08273
      *
     C     K#ACCT        KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    BRCA
      *
      * Format key to ACCNT and read file for details
      *
     C     I#ATYP        IFEQ      'N'
     C     I#ATYP        OREQ      'F'
     C                   MOVEL     A7CUST        CNUM
     C                   MOVEL     A7CYCD        CCY
     C                   MOVEL     A7ACCD        ACOD
     C                   Z-ADD     A7ACSN        ACSQ
     C                   MOVEL     A7BRCD        BRCA
     C                   END
      *
     C     I#ATYP        IFEQ      'P'
     C**********         Z-ADD     I#CNUM        CNUM                                         CSD027
     C                   EVAL      CNUM = I#CNUM                                              CSD027
     C                   MOVEL     I#CCY         CCY
     C                   Z-ADD     I#ACOD        ACOD
     C                   Z-ADD     I#ACSQ        ACSQ
      *
      *  If branch is blank then assume single branch
      *
     C     I#BRCA        IFNE      *BLANKS
     C                   MOVEL     I#BRCA        BRCA
     C                   ELSE
     C                   MOVEL     BJSBRC        BRCA
     C                   END
     C                   END
      *
     C     I#ATYP        IFEQ      'G'
     C     CFT004        OREQ      'Y'                                                        CFT004
     C     I#ATYP        ANDEQ     'I'                                                        CFT004
     C**********         Z-ADD     I#CNU1        CNUM                                         CSD027
     C                   EVAL      CNUM = I#CNU1                                              CSD027
     C                   MOVEL     I#CCY1        CCY
     C                   Z-ADD     I#ACO1        ACOD
     C                   Z-ADD     I#ACS1        ACSQ
      *
      *  If branch is blank then assume single branch
      *
     C     I#BRC1        IFNE      *BLANKS
     C                   MOVEL     I#BRC1        BRCA
     C                   ELSE
     C                   MOVEL     BJSBRC        BRCA
     C                   END
     C                   END
      *
     C     K#ACCT        CHAIN     ACCNTABF                           90
     C     *IN90         IFEQ      '1'
     C     RECI          ORNE      'D'
     C*****W0ACT         IFNE      '*ADD  '                                            172073 206839
     C                   GOTO      EXADD                                                      206839
     C                   MOVEL     'ACCNT   '    W0FILE
     C                   MOVEL     BRCA          K#BRCA
     C                   MOVEL     AC#KEY        W0KEY
     C                   Z-ADD     4             W0ERNB
     C                   MOVEL     ERR@(3)       W0NARR
     C                   EXSR      SRERR
     C**********         END                                                           172073 206839
     C                   END
      *                                                                                      BUG8796
      ** Check record in SDNOSTPD                                                            BUG8796
      *                                                                                      BUG8796
     C     ATYP          IFEQ      'N'                                                       BUG8796
     C     K#NOS3        KLIST                                                               BUG8796
     C                   KFLD                    A7CUST                                      BUG8796
     C                   KFLD                    A7CYCD                                      BUG8796
     C                   KFLD                    A7ACCD                                      BUG8796
     C                   KFLD                    A7ACSN                                      BUG8796
     C                   KFLD                    A7BRCD                                      BUG8796
      *                                                                                      BUG8796
     C                   MOVEL     CNUM          A7CUST                                      BUG8796
     C                   MOVEL     CCY           A7CYCD                                      BUG8796
     C                   MOVEL     ACOD          A7ACCD                                      BUG8796
     C                   Z-ADD     ACSQ          A7ACSN                                      BUG8796
     C                   MOVEL     BRCA          A7BRCD                                      BUG8796
     C     K#NOS3        CHAIN     @NOSTL2                            90                     BUG8796
     C                   MOVE      *BLANKS       ##NIND                                      BUG8796
     C     *IN90         IFEQ      '0'                                                       BUG8796
     C                   MOVE      'Y'           ##NIND                                      BUG8796
     C                   ENDIF                                                               BUG8796
     C                   ENDIF                                                               BUG8796
      *
      *  Set up fields in data structure
      *
     C                   MOVEL     BRCA          W#BRCA
     C**********         Z-ADD     CNUM          W#CNUM                                       CSD027
     C                   EVAL      W#CNUM = CNUM                                              CSD027
     C                   MOVEL     CCY           W#CCY
     C                   Z-ADD     ACOD          W#ACOD
     C                   Z-ADD     ACSQ          W#ACSQ
     C                   Z-ADD     ACNO          W#ACNO
     C***********          Z-ADDRRNM      W#RRNM                          CCB002
      *
      * If retail account set fields
      *
     C     ATYP          IFEQ      'R'
     C                   MOVEL     'Y'           ##RET
     C***********          Z-ADDRRNM      W#RRNM                          CCB002
     C                   Z-ADD     1             W#RRNM                                        CCB00
     C                   ELSE
     C                   Z-ADD     0             W#RRNM
     C                   END
      *
      * If nostro account set field
      *
     C     ATYP          IFEQ      'N'
     C     ##NIND        ANDEQ     'Y'                                                       BUG8796
     C                   MOVEL     'Y'           ##NOS
     C                   END
      *
     C                   END
      *
      ***If*account*is*Retail*look*up*on*ACNUMA************************                       243307
      *  If account is Retail look up on ACNUMB                                               243307
      *
     C     I#ATYP        IFEQ      'R'
      *
     C     K#RETN        KLIST
     C                   KFLD                    ACNO
     C                   MOVEL     I#ACNO        ACNO
      *
      * Read retail accounts for details
      *
     C     K#RETN        CHAIN     REACNOF                            90
     C     *IN90         IFEQ      '1'
     C     RECI          ORNE      'D'
     C*****W0ACT         IFNE      '*ADD  '                                            172073 206839
     C                   GOTO      EXADD                                                      206839
     C**********         MOVEL     'ACNUMA  '    W0FILE                                       243307
     C                   MOVEL     'ACNUMB  '    W0FILE                                       243307
     C                   MOVEL     I#ACNO        W0KEY
     C                   Z-ADD     5             W0ERNB
     C                   MOVEL     ERR@(3)       W0NARR
     C                   EXSR      SRERR
     C**********         END                                                           172073 206839
     C                   END
      *
      *  Set up fields in data structure
      *
     C******IN90         IFEQ      '1'                                                 172073 206839
     C*****RECI          ORNE      'D'                                                 172073 206839
     C*****W0ACT         IFNE      '*ADD  '                                            172073 206839
     C                   MOVEL     BRCA          W#BRCA
     C**********         Z-ADD     CNUM          W#CNUM                                       CSD027
     C                   EVAL      W#CNUM = CNUM                                              CSD027
     C                   MOVEL     CCY           W#CCY
     C                   Z-ADD     ACOD          W#ACOD
     C                   Z-ADD     ACSQ          W#ACSQ
     C                   Z-ADD     ACNO          W#ACNO
     C********             Z-ADDRRNM      W#RRNM                          CCB002
     C                   Z-ADD     1             W#RRNM                         122601
     C                   MOVEL     'Y'           ##RET
     C**********         END                                                           172073 206839
      **********                                                                       174470 206839
      ***If retail account is found, setup fields in data structure                    174470 206839
      **********                                                                       174470 206839
     C**********         ELSE                                                          174470 206839
     C**********         MOVEL     BRCA          W#BRCA                                174470 206839
     C**********         Z-ADD     CNUM          W#CNUM                                174470 206839
     C**********         MOVEL     CCY           W#CCY                                 174470 206839
     C**********         Z-ADD     ACOD          W#ACOD                                174470 206839
     C**********         Z-ADD     ACSQ          W#ACSQ                                174470 206839
     C**********         Z-ADD     ACNO          W#ACNO                                174470 206839
     C**********         Z-ADD     1             W#RRNM                                174470 206839
     C**********         MOVEL     'Y'           ##RET                                 174470 206839
      **********                                                                       174470 206839
     C**********         END                                                           172073 206839
      *
     C                   END
      *
      *  Look up account (if not a nostro) to see if a nostro
      *
     C     I#ATYP        IFNE      'N'
     C     I#ATYP        ANDNE     'F'
     C     I#ATYP        ANDNE     'S'                                                        232494
     C     I#ATYP        ANDNE     'X'                                                         08273
      *
     C     K#NOS2        KLIST
     C                   KFLD                    A7CUST
     C                   KFLD                    A7CYCD
     C                   KFLD                    A7ACCD
     C                   KFLD                    A7ACSN
     C                   KFLD                    A7BRCD
      *
     C******IN90         IFEQ      '1'                                                 172073 206839
     C*****RECI          ORNE      'D'                                                 172073 206839
     C*****W0ACT         IFNE      '*ADD  '                                            172073 206839
     C                   MOVEL     CNUM          A7CUST
     C                   MOVEL     CCY           A7CYCD
     C                   MOVEL     ACOD          A7ACCD
     C                   Z-ADD     ACSQ          A7ACSN
     C                   MOVEL     BRCA          A7BRCD
     C**********         END                                                           172073 206839
      **********                                                                       187042 206839
      ***Setup the fields for keylist K#NOS2 when the account is found.                187042 206839
      **********                                                                       187042 206839
     C**********         ELSE                                                          187042 206839
     C**********         MOVEL     CNUM          A7CUST                                187042 206839
     C**********         MOVEL     CCY           A7CYCD                                187042 206839
     C**********         MOVEL     ACOD          A7ACCD                                187042 206839
     C**********         Z-ADD     ACSQ          A7ACSN                                187042 206839
     C**********         MOVEL     BRCA          A7BRCD                                187042 206839
     C**********         END                                                           172073 206839
      *
     C     K#NOS2        CHAIN     @NOSTL2                            90
      *
      * If nostro found then set up data structure fields
      *
     C     *IN90         IFEQ      '0'
     C                   MOVEL     'Y'           ##NOS             1
     C                   MOVEL     A7NONB        W#NOSN
     C                   END
      *
     C                   END
      *
      *  If a nostro on SDNOSTPD then check if unallocated
      *
     C     ##NOS         IFEQ      'Y'
     C     W#NOSN        ANDGE     0
      *
     C     K#PRON        KLIST
     C                   KFLD                    CCY
     C                   KFLD                    NOSN
      *
     C                   MOVEL     W#CCY         CCY
     C                   Z-ADD     W#NOSN        NOSN
      *
     C     K#PRON        CHAIN     PRONOPNF                           90
     C     *IN90         IFEQ      '1'
     C     RECI          ORNE      'D'
     C     W#NOSN        IFGT      0
     C                   Z-ADD     0             NOSN
      *
      *  Check unallocated nostro has been set up
      *
     C     K#PRON        CHAIN     PRONOPNF                           90
      *
      *  If no nostro set to -1 else if unallocated set to 0
      *
     C     *IN90         IFEQ      '1'
     C     RECI          ORNE      'D'
     C                   Z-ADD     -1            W#NOSN
     C                   ELSE
     C                   Z-ADD     0             W#NOSN
     C                   END
      *
     C                   ELSE
      *
      * No prono record found and nostro number is 0. Set to -1
      * to indicate no update
      *
     C                   Z-ADD     -1            W#NOSN
     C                   END
     C                   END
      *
     C                   END
      *
      *  Set up occurrence data structure with all relevant information
      *  not already set.
      *
     C                   MOVEL     I#IO          W#IO
     C                   MOVEL     'Y'           W#SET
     C*****I#IO          IFEQ      ' '                                               BUG10860 241290
     C*****I#IO          OREQ      'I'                                               BUG10860 241290
     C                   Z-ADD     I#AMT         W#AMT
     C**********         ELSE                                                        BUG10860 241290
     C**********         Z-SUB     I#AMT         W#AMT                               BUG10860 241290
     C**********         ENDIF                                                       BUG10860 241290
     C                   Z-ADD     I#VDAT        W#VDAT
      *
      *  If posting date override is blank calculate date
      *
     C     I#PSTO        IFEQ      'Y'
     C                   Z-ADD     I#PSTD        W#PSTD
     C                   ELSE
     C                   EXSR      SRPSTD
     C                   Z-ADD     I#PSTD        W#PSTD
     C                   END
     C                   MOVEL     I#TRYP        W#TRYP
     C                   MOVEL     I#NARR        W#NARR
     C                   Z-ADD     I#CHQN        W#CHQN
     C                   MOVEL     I#TRN         W#TRN
     C                   MOVEL     I#PREF        W#PREF
     C                   MOVEL     I#PRON        W#PRON
     C                   MOVEL     I#OLPS        W#OLPS
     C                   MOVEL     I#MEMS        W#MEMS
     C                   MOVEL     I#RSAC        W#RSAC
     C                   MOVEL     I#MOD         W#MOD
     C                   MOVEL     I#OLRC        W#OLRC
     C                   MOVEL     I#FTOV        W#FTOV
      *                                                                                       CLE134
      ** Extension Reference Id/Number.                                                       CLE134
      *                                                                                       CLE134
     C                   MOVEL     I#XRFI        W#XRFI                                       CLE134
     C                   MOVEL     I#XRFN        W#XRFN                                       CLE134
     C                   MOVEL     I#OTR1        W#OTR1                                       CAP204
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     I#MTYP        W#MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
      *
      *  If a nostro add to nostro array
      *
     C     ##NOS         IFEQ      'Y'
     C     W#NOSN        ANDGE     0
     C                   MOVEL     *BLANKS       AR#KEY
     C                   ADD       1             @N
     C                   MOVEL     W#CCY         A#NOS
     C                   MOVE      W#NOSN        A#NOS
     C                   Z-ADD     @X            A#SEQ
     C                   MOVEA     AR#KEY        @NS(@N)
     C                   END
      *
      *  If to be shown on all positions add to currency array
      *
     C     I#IO          IFNE      ' '
     C                   MOVEL     *BLANKS       AR#KEY
     C                   ADD       1             @C
     C*********************MOVELW#BRCA    A#BRCA                          082738
     C*********************MOVELW#CCY     A#CCY                           082738
     C     I#BBRN        IFNE      *BLANK                                                      08273
     C                   MOVEL     I#BBRN        A#BRCA                                        08273
     C                   ELSE                                                                  08273
     C                   MOVEL     W#BRCA        A#BRCA                                        08273
     C                   END                                                                   08273
     C                   MOVEL     I#CCY         A#CCY                                         08273
     C                   MOVE      I#OLRC        A#CCY
     C                   Z-ADD     @X            A#SEQ
     C                   MOVEA     AR#KEY        @CY(@C)
     C                   END
      *
      *  If a retail add to retail array
      *
     C     ##RET         IFEQ      'Y'
      *                                                                   045014
      *  Only do this if Retail is switched on. Not checked earlier       045014
      *  because account passed should not be type retail.                045014
      *                                                                   045014
     C     BGIOAC        IFEQ      'Y'                                                         04501
     C     BGRTBN        OREQ      'Y'                                                         04501
     C                   MOVEL     *BLANKS       AR#KEY
     C                   ADD       1             @R
     C                   MOVEL     W#RRNM        A#RRNM
     C                   Z-ADD     @X            A#SEQ
     C                   MOVEA     AR#KEY        @ME(@R)
     C                   END                                                                   04501
     C                   END
      *
      *  If a nostro or retail then RSACMT should be written to
      *
     C     ##NOS         IFEQ      'Y'
     C     ##RET         OREQ      'Y'
     C                   MOVEL     'Y'           W#NR
     C                   END
      *                                                                   068347
      *  If Removal indicated store in array                              068347
      *                                                                   068347
     C     I#RPST        IFEQ      'Y'                                                       068347
     C                   MOVEL     I#RPST        W#RPST                                      068347
     C                   Z-ADD     I#RPNB        W#RPNB                                      068347
     C                   MOVEL     I#RTYP        W#RTYP                                      068347
     C                   MOVEL     *BLANKS       AR#KEY                                      068347
     C                   ADD       1             @P                                          068347
     C                   MOVEL     I#RPST        A#RPST                                      068347
     C                   Z-ADD     I#RPNB        A#RPNB                                      068347
     C                   MOVEL     I#RTYP        A#RTYP                                      068347
     C                   Z-ADD     @X            A#SEQ                                       068347
     C                   MOVEA     AR#KEY        @RP(@P)                                     068347
     C                   END                                                                 068347
      *
      *  Unwind subroutine stack name
      *
     C     EXADD         TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C/COPY WNCPYSRC,AOSPOSU0C5
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRUPD    : Update Memos, Prono and Olpos                     *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SRMEMS  - Controls call to AOMEMSU0               *
      *           : SRPRON  - Controls call to AOPRONU0               *
      *           : SROLPS  - Controls call to AOOLPSU0               *
      *           : SRRSAC  - Controls call to AORSACW0               *
      *                                                               *
      *****************************************************************
     CSR   SRUPD         BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRUPD '      @STK(Q)
      *
      *  Sort arrays into ascending order
      *
     C**********         SORTA     @ME                                                     BUG27966A
     C                   IF        @R <> 0                                                 BUG27966A
     C                   SORTA     %SUBARR(@ME:1:@R)                                       BUG27966A
     C                   ENDIF                                                             BUG27966A
     C**********         SORTA     @NS                                                     BUG27966A
     C                   IF        @N <> 0                                                 BUG27966A
     C                   SORTA     %SUBARR(@NS:1:@N)                                       BUG27966A
     C                   ENDIF                                                             BUG27966A
     C**********         SORTA     @CY                                                     BUG27966A
     C                   IF        @C <> 0                                                 BUG27966A
     C                   SORTA     %SUBARR(@CY:1:@C)                                       BUG27966A
     C                   ENDIF                                                             BUG27966A
     C**********         SORTA     @RP                                              068347 BUG27966A
     C                   IF        @P <> 0                                                 BUG27966A
     C                   SORTA     %SUBARR(@RP:1:@P)                                       BUG27966A
     C                   ENDIF                                                             BUG27966A
      *
      *  Update files in the following order:
      *
      *                    MEMOS    via AOMEMSU0
      *                    PRONO    via AOPRONU0
      *                    OLPOS    via AOOLPSU0
      *                    RSACMTPD via AORSACW0
      *
     C                   EXSR      SRMEMS
     C                   EXSR      SRPRON
     C                   EXSR      SROLPS
     C                   EXSR      SRRSAC
     C/COPY WNCPYSRC,AOSPOSU0C6
      *
      *  Unwind subroutine stack name
      *
     C     EXUPD         TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRMEMS   : Controls call to AOMEMSU0                         *
      *                                                               *
      *  CALLED BY: SRUPD   - Control update to Memos, Prono, Olpos   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *           : AOMEMSU0 program                                  *
      *                                                               *
      *****************************************************************
     CSR   SRMEMS        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRMEMS'      @STK(Q)
      *
      *  Process all twenty elements of the array
      *
     C                   MOVEL     *BLANKS       R#RTN             7
     C*****1****         DO        60            @Y                5 0                        197145
     C*****1****         DO        2000          @Y                5 0              197145 BUG27966A
     C     1             DO        @R            @Y                5 0                     BUG27966A
     C                   MOVEA     @ME(@Y)       AR#KEY
      *
      *  If an entry call AOMEMSU0
      *
     C     AR#KEY        IFNE      *BLANKS
     C     A#SEQ         OCCUR     POST
      *
      *  Only call if retail override not flagged
      *
     C     W#MEMS        IFEQ      *BLANKS
     C**********         CALLB     'AOMEMSU0'                           9090                  248460
     C                   CALL      'AOMEMSU0'                           9090                  248460
     C     R#RTN         PARM      *BLANKS       O#RTN             7
     C***********          PARM W#RRNM    O#RRN   70                      CCB002
     C                   PARM      W#ACNO        O#ACNO           10 0                         CCB00
     C**********         PARM      W#CNUM        O#CNUM            6 0                  CCB00 CSD027
     C                   PARM      W#CNUM        O#CNUM            6                          CSD027
     C                   PARM      W#CCY         O#CCY             3                           CCB00
     C**********         PARM      W#ACOD        O#ACOD            4 0                  CCB00 CGL029
     C                   PARM      W#ACOD        O#ACOD           10 0                        CGL029
     C                   PARM      W#ACSQ        O#ACSQ            2 0                         CCB00
     C                   PARM      W#BRCA        O#BRCA            3                           CCB00
     C                   PARM      W#PSTD        O#PSTD            5 0
     C                   PARM      W#VDAT        O#VDAT            5 0
     C                   PARM      W#AMT         O#AMT            15 0
     C                   PARM      W#FTOV        O#FTOV            1
      *
     C     *IN90         IFEQ      '1'
     C     R#RTN         ORNE      *BLANKS
     C                   MOVEL     '*CALL   '    W0FILE
     C                   MOVEL     'AOMEMSU0'    W0KEY
     C                   Z-ADD     1             W0ERNB
     C                   MOVEL     ERR@(7)       W0NARR
     C                   EXSR      SRERR
     C                   END
      *
     C                   END
     C                   END
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXMEMS        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRPRON   : Controls call to AOPRONU0                         *
      *                                                               *
      *  CALLED BY: SRUPD   - Control update to Memos, Prono, Olpos   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *           : AOPRONU0 program                                  *
      *                                                               *
      *****************************************************************
     CSR   SRPRON        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRPRON'      @STK(Q)
      *
      *  Process all twenty elements of the array
      *
     C                   MOVEL     *BLANKS       R#RTN             7
     C*****1****         DO        60            @Y                5 0                        197145
     C*****1****         DO        2000          @Y                5 0              197145 BUG27966A
     C     1             DO        @N            @Y                5 0                     BUG27966A
     C                   MOVEA     @NS(@Y)       AR#KEY
      *
      *  If an entry call AOPRONU0
      *
     C     A#NOS         IFNE      *BLANKS
     C     A#SEQ         OCCUR     POST
      *
      *  Only call if nostro override not flagged
      *
     C     W#PRON        IFEQ      *BLANKS
     C**********         CALLB     'AOPRONU0'                           9090                  248460
     C                   CALL      'AOPRONU0'                           9090                  248460
     C     R#RTN         PARM      *BLANKS       O#RTN             7
     C                   PARM      A#NOS         O#NOS             5            I: Nostro key
     C                   PARM      W#VDAT        O#VDAT            5 0
     C                   PARM      W#AMT         O#AMT            15 0
      *
     C     *IN90         IFEQ      '1'
     C     R#RTN         ORNE      *BLANKS
     C                   MOVEL     '*CALL   '    W0FILE
     C                   MOVEL     'AOPRONU0'    W0KEY
     C                   Z-ADD     1             W0ERNB
     C                   MOVEL     ERR@(7)       W0NARR
     C                   EXSR      SRERR
     C                   END
      *
     C                   END
     C                   END
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXPRON        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SROLPS   : Controls call to AOOLPSU0                         *
      *                                                               *
      *  CALLED BY: SRUPD   - Control update to Memos, Prono, Olpos   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *           : AOOLPSU0 program                                  *
      *                                                               *
      *****************************************************************
     CSR   SROLPS        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SROLPS'      @STK(Q)
      *
      *  Process all twenty elements of the array
      *
     C                   MOVEL     *BLANKS       R#RTN             7
     C*****1****         DO        60            @Y                5 0                        197145
     C*****1****         DO        2000          @Y                5 0              197145 BUG27966A
     C     1             DO        @C            @Y                5 0                     BUG27966A
     C                   MOVEA     @CY(@Y)       AR#KEY
      *
      *  If an entry call AOOLPSU0
      *
     C     A#CCY         IFNE      *BLANKS
     C     A#SEQ         OCCUR     POST
      *                                                                   045014
      *  Set up O#AMT depending W#IO flag - if O then invert              045014
      *                                                                   045014
     C     W#IO          IFEQ      'O'                                                         04501
     C                   Z-SUB     W#AMT         O#AMT                                         04501
     C                   ELSE                                                                  04501
     C                   Z-ADD     W#AMT         O#AMT                                         04501
     C                   END                                                                   04501
      *
      *  Only call if olpos override not flagged
      *
     C     W#OLPS        IFEQ      *BLANKS
     C**********         CALLB     'AOOLPSU0'                           9090                  248460
     C                   CALL      'AOOLPSU0'                           9090                  248460
     C     R#RTN         PARM      *BLANKS       O#RTN             7
     C                   PARM      A#KOLP        O#KOLP            8            I: Olpos key
     C                   PARM      W#VDAT        O#VDAT            5 0
     C***********          PARM W#AMT     O#AMT  150                      045014
     C                   PARM                    O#AMT            15 0                         04501
     C                   PARM      W#IO          O#IO              1            I: Incoming/Outgoing
      *
     C     *IN90         IFEQ      '1'
     C     R#RTN         ORNE      *BLANKS
     C                   MOVEL     '*CALL   '    W0FILE
     C                   MOVEL     'AOOLPSU0'    W0KEY
     C                   Z-ADD     1             W0ERNB
     C                   MOVEL     ERR@(7)       W0NARR
     C                   EXSR      SRERR
     C                   END
      *
     C                   END
     C                   END
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXOLPS        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRRSAC   : Controls call to AORSACW0                         *
      *                                                               *
      *  CALLED BY: SRUPD   - Control update to Memos, Prono, Olpos   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *           : AORSACW0 program                                  *
      *                                                               *
      *****************************************************************
     CSR   SRRSAC        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRRSAC'      @STK(Q)
      *                                                                   068347
      *  Remove duplicates from POST occurrance data structure            068347
      *                                                                   068347
     C                   EXSR      SRRPST                                                     068347
      *
      *  Process all twenty elements of the array
      *
     C                   MOVEL     *BLANKS       R#RTN             7
     C*****1****         DO        60            @Y                5 0                        197145
     C*****1****         DO        2000          @Y                5 0              197145 BUG27966A
     C     1             DO        @X            @Y                5 0                     BUG27966A
      *
      *  If an entry call AOOLPSU0
      *
     C     @Y            OCCUR     POST
     C     W#SET         IFNE      *BLANKS
      *
      *  Only call if rsacmt override not flagged
      *  and either a nostro or retail posting
      *
     C     W#RSAC        IFEQ      *BLANKS
     C     W#NR          ANDEQ     'Y'
      *
      * Set up fields for call
      *
     C                   CLEAR                   P#RSAC
     C                   MOVEL     W#BRCA        BRCA
     C                   MOVEL     W#CCY         CCYD
      *
      * If nostro exists on prono output nostro account
      * else output 000000CCY000000 - for unallocated nostro
      *
     C     W#NOSN        IFGE      0
     C     W#RRNM        ORGT      0
     C**********         Z-ADD     W#CNUM        CUSN                                         CSD027
     C                   EVAL      CUSN = W#CNUM                                              CSD027
     C                   Z-ADD     W#ACOD        ACDE
     C                   Z-ADD     W#ACSQ        ASNC
     C                   ELSE
     C**********         Z-ADD     0             CUSN                                        BUG7370
     C**********         Z-ADD     0             ACDE                                        BUG7370
     C**********         Z-ADD     0             ASNC                                        BUG7370
     C**********         Z-ADD     W#CNUM        CUSN                                 BUG7370 CSD027
     C                   EVAL      CUSN = W#CNUM                                              CSD027
     C                   Z-ADD     W#ACOD        ACDE                                        BUG7370
     C                   Z-ADD     W#ACSQ        ASNC                                        BUG7370
     C                   END
      *                                                                                       CRE020
     C                   IF        CRE020 ='Y'                                                CRE020
     C                   EXSR      SRRtlAdv                                                   CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CRE020
     C                   Z-ADD     W#PSTD        PTDT
     C                   Z-ADD     W#VDAT        VUDT
     C                   MOVEL     W#TRYP        TRYP
     C*****************    Z-ADD0         NRTC                            080050
     C*********************MOVE *BLANK    NRTC                      080050082738
     C                   MOVE      '00'          NRTC                                          08273
     C                   MOVEL     W#NARR        NRTD
     C                   MOVEL     W#TRN         TNMR
     C                   Z-ADD     W#CHQN        CQNR
     C                   MOVEL     W#PREF        FUND
      *                                                                                       CLE134
     C                   MOVE      W#XRFI        XRFI                                         CLE134
     C                   MOVE      W#XRFN        XRFN                                         CLE134
     C                   MOVEL     W#OTR1        OTR1                                         CAP204
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     W#MOD         CMOD                                         CAP205
     C                   MOVEL     *BLANKS       ETYP                                         CAP205
     C                   MOVEL     W#MTYP        MTYP                                         CAP205
     C                   ENDIF                                                                CAP205
     C/COPY WNCPYSRC,AOSPOSU0C3
      *
     C**********         CALLB     'AORSACW0'                           9090                  248460
     C                   CALL      'AORSACW0'                           9090                  248460
     C     R#RTN         PARM      *BLANKS       O#RTN             7
     C                   PARM      W#AMT         O#AMT            15 0
     C                   PARM      P#DTA         O#RSAC          256
     C/COPY WNCPYSRC,AOSPOSU0C4
      *
     C     *IN90         IFEQ      '1'
     C     R#RTN         ORNE      *BLANKS
     C                   MOVEL     '*CALL   '    W0FILE
     C                   MOVEL     'AORSACW0'    W0KEY
     C                   Z-ADD     1             W0ERNB
     C                   MOVEL     ERR@(7)       W0NARR
     C                   EXSR      SRERR
     C                   END
      *
     C                   END
     C                   END
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXRSAC        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCMMT   : Commit Updates to database                        *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     CSR   SRCMMT        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRCMMT'      @STK(Q)
      *
      *  Commit updates
      *
     C     CSC022        IFNE      'Y'                                                        CSC022
     C                   COMMIT                                         90
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   COMMIT                                         90                    CSC022
     C                   END                                                                  CSC022
     C                   ENDIF                                                                CSC022
     C     *IN90         IFEQ      '1'
     C                   MOVEL     '*COMMIT '    W0FILE
     C                   Z-ADD     1             W0ERNB
     C                   EXSR      SRERR
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXCMMT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/COPY WNCPYSRC,AOSPOSU0C7
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRPSTD   : Calculate posting date                            *
      *                                                               *
      *  CALLED BY: SRADD Add information to data structures          *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *           : SZDATE3 - Calculate next working day for ccy      *
      *                                                               *
      *****************************************************************
     CSR   SRPSTD        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRPSTD'      @STK(Q)
      *
      *  If value date is less than next working day use run date
      *
     C     I#PSTD        IFLT      BJDNWD
     C     BKANWD        ANDEQ     '1'                                                        246761
     C                   Z-ADD     BJRDNB        I#PSTD
     C                   GOTO      EXPSTD
     C                   END
      *
     C     I#PSTD        IFEQ      BJDNWD
     C                   GOTO      EXPSTD
     C                   END
      *
      *  If value date is greater than next working day
      ***use program SZDATE3 to determine correct date*****************                       246761
      ** then calculate for the correct posting date based on the                             246761
      ** Accrual on Non-Working Day indicator and the local currency                          246761
      ** holidays.                                                                            246761
      *
     C                   MOVE      BJLCCY        ZCCY              3                          246761
     C                   MOVE      BJSLCD        ZLOC              3                          246761
     C                   Z-ADD     I#PSTD        ZDAYNO            5 0                        246761
     C                   Z-ADD     I#PSTD        ZDYNBR            5 0                        246761
     C                   Z-ADD     0             ZNRDYS            2 0                        246761
      *                                                                                       246761
     C     BKANWD        IFEQ      '1'                                                        246761
     C                   CALL      'ZBKDT'                                                    246761
     C                   PARM                    ZDAYNO                                       246761
     C                   PARM                    ZCCY                                         246761
     C                   PARM                    ZLOC                                         246761
     C                   PARM                    ZNRDYS                                       246761
     C                   PARM                    ZDYNBR                                       246761
     C                   ENDIF                                                                246761
      *                                                                                       246761
     C     BKANWD        IFEQ      '2'                                                        246761
     C                   CALL      'ZFWDT'                                                    246761
     C                   PARM                    ZDAYNO                                       246761
     C                   PARM                    ZNRDYS                                       246761
     C                   PARM                    ZDYNBR                                       246761
     C                   PARM                    ZCCY                                         246761
     C                   PARM                    ZLOC                                         246761
     C                   ENDIF                                                                246761
      *                                                                                       246761
     C                   Z-ADD     ZDYNBR        I#PSTD                                       246761
      *                                                                                       246761
     C**********         Z-ADD     I#PSTD        W#NDAT            5 0                        246761
     C**********         Z-ADD     I#PSTD        P#SDAT            5 0                        246761
     C*****W#NDAT        DOUEQ     W#SDAT                                                     246761
     C**********         Z-ADD     P#SDAT        W#SDAT            5 0                        246761
     C*****P#SDAT        SUB       1             P#SDAT                                       246761
     C**********         CALL      'SZDATE3'                            9090                  246761
     C**********         PARM      P#SDAT        #DAYNO            5 0          I: Cvt. VDa te246761
     C**********         PARM      BJLCCY        #CCY              3            I: Currency   246761
     C**********         PARM      *BLANKS       #LOC              3            I: Location   246761
     C**********         PARM      1             #NRDYS            2 0          I: Nbr Days   246761
     C*****W#NDAT        PARM                    #DYNBR            5 0          O: Nbr Days   246761
      **********                                                                              246761
     C******IN90         IFEQ      '1'                                                        246761
     C**********         MOVEL     '*CALL   '    W0FILE                                       246761
     C**********         MOVEL     'SZDATE3 '    W0KEY                                        246761
     C**********         Z-ADD     1             W0ERNB                                       246761
     C**********         MOVEL     ERR@(1)       W0NARR                                       246761
     C**********         EXSR      SRERR                                                      246761
     C**********         END                                                                  246761
     C**********         END                                                                  246761
     C**********         Z-ADD     W#SDAT        I#PSTD                                       246761
      *
      *  Unwind subroutine stack name
      *
     C     EXPSTD        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT                                                              068347
      *****************************************************************   068347
      *                                                               *   068347
      *  SRRPST   : Remove duplicate analysis                         *   068347
      *                                                               *   068347
      *  CALLED BY: SRRSAC - Controls call to AORSACW0                *   068347
      *                                                               *   068347
      *  CALLS    : SRERR   - report error and close down program     *   068347
      *                                                               *   068347
      *****************************************************************   068347
     CSR   SRRPST        BEGSR                                                                068347
      *                                                                   068347
      *  Set up subroutine stack name                                     068347
      *                                                                   068347
     C                   ADD       1             Q                                            068347
     C                   MOVEL     'SRRPST'      @STK(Q)                                      068347
      *                                                                   068347
      *  Read removal array until end                                     068347
      *                                                                   068347
     C                   MOVEL     *BLANKS       R#RTN                                        068347
     C*****1****         DO        60            @Y                                    068347 197145
     C*****1****         DO        2000          @Y                                 197145 BUG27966A
     C     1             DO        @P            @Y                                        BUG27966A
     C                   MOVEA     @RP(@Y)       AR#KEY                                       068347
      *                                                                   068347
      *  If entry allows removal then process                             068347
      *                                                                   068347
     C     A#RPST        IFEQ      'Y'                                                        068347
      *                                                                   068347
      *  Get and save POST information  (if W#RSAC flag not set)          068347
      *                                                                   068347
     C     A#SEQ         OCCUR     POST                                                       06834
      *                                                                   068347
     C     W#SET         IFNE      *BLANKS                                                    068347
     C     W#RSAC        ANDEQ     *BLANKS                                                    068347
      *                                                                   068347
     C     *LIKE         DEFINE    W#ACCT        S#ACCT                                       068347
     C     *LIKE         DEFINE    W#IO          S#IO                                         068347
     C     *LIKE         DEFINE    W#CCY         S#CCY                                        068347
     C     *LIKE         DEFINE    W#TRYP        S#TRYP                                       068347
     C     *LIKE         DEFINE    W#PREF        S#PREF                                       068347
     C     *LIKE         DEFINE    W#AMT         S#AMT                                        068347
     C     *LIKE         DEFINE    W#VDAT        S#VDAT                                       068347
     C     *LIKE         DEFINE    W#PSTD        S#PSTD                                       068347
     C     *LIKE         DEFINE    A#RPNB        S#RPNB                                       068347
     C     *LIKE         DEFINE    A#RTYP        S#RTYP                                       068347
     C     *LIKE         DEFINE    W#BRCA        S#BRCA                                       181176
      *                                                                   068347
     C                   MOVEL     W#ACCT        S#ACCT                                       068347
     C                   MOVEL     W#IO          S#IO                                         068347
     C                   MOVEL     W#CCY         S#CCY                                        068347
     C                   MOVEL     W#TRYP        S#TRYP                                       068347
     C                   MOVEL     W#PREF        S#PREF                                       068347
     C                   Z-SUB     W#AMT         S#AMT                                        068347
     C                   Z-ADD     W#VDAT        S#VDAT                                       068347
     C                   Z-ADD     W#PSTD        S#PSTD                                       068347
     C                   Z-ADD     A#RPNB        S#RPNB                                       068347
     C                   MOVEL     A#RTYP        S#RTYP                                       068347
     C                   MOVEL     W#BRCA        S#BRCA                                       181176
      *                                                                   068347
      *  Now search rest of array for equivalent entries                  068347
      *                                                                   068347
     C     @Y            ADD       1             @Z1               5 0                        068347
     C*****@Z1**         DO        60            @Z2               5 0                 068347 197145
     C*****@Z1**         DO        2000          @Z2               5 0              197145 BUG27966A
     C     @Z1           DO        @P            @Z2               5 0                     BUG27966A
     C                   MOVEA     @RP(@Z2)      AR#KEY                                       068347
      *                                                                   068347
      *  If new set then leave this do loop                               068347
      *                                                                   068347
     C     A#RPNB        IFGT      S#RPNB                                                     068347
     C                   LEAVE                                                                068347
     C                   END                                                                  068347
      *                                                                   068347
      *  If not available for removal or different type repeat            068347
      *                                                                   068347
     C     A#RPST        IFNE      'Y'                                                        068347
     C     A#RTYP        ORNE      S#RTYP                                                     068347
     C     A#RPNB        ORLT      S#RPNB                                                     068347
     C                   ITER                                                                 068347
     C                   END                                                                  068347
      *                                                                   068347
      *  Get contents                                                     068347
      *                                                                   068347
     C     A#SEQ         OCCUR     POST                                                       068347
      *                                                                   068347
      *  Compare contents if equivalent then set W#RSAC to Y              068347
      *                                                                   068347
     C     W#RSAC        IFEQ      *BLANKS                                                    068347
     C     W#SET         ANDNE     *BLANKS                                                    068347
     C     W#ACCT        ANDEQ     S#ACCT                                                     068347
     C     W#IO          ANDEQ     S#IO                                                       068347
     C     W#CCY         ANDEQ     S#CCY                                                      068347
     C     W#TRYP        ANDEQ     S#TRYP                                                     068347
     C     W#PREF        ANDEQ     S#PREF                                                     068347
     C     W#AMT         ANDEQ     S#AMT                                                      068347
     C     W#VDAT        ANDEQ     S#VDAT                                                     068347
     C     W#PSTD        ANDEQ     S#PSTD                                                     068347
     C     W#BRCA        ANDEQ     S#BRCA                                                     181176
      *                                                                   068347
      *  Duplicate found make both as not to be posted and                068347
      *  leave loop                                                       068347
      *                                                                   068347
     C                   MOVEL     'Y'           W#RSAC                                       068347
     C                   MOVEA     @RP(@Y)       AR#KEY                                       068347
     C     A#SEQ         OCCUR     POST                                                       068347
     C                   MOVEL     'Y'           W#RSAC                                       068347
     C                   LEAVE                                                                068347
     C                   END                                                                  068347
      *                                                                   068347
     C                   ENDDO                                                                068347
      *                                                                   068347
     C                   END                                                                  068347
     C                   END                                                                  068347
     C                   ENDDO                                                                068347
      *                                                                   068347
      *  Unwind subroutine stack name                                     068347
      *                                                                   068347
     C     EXRPST        TAG                                                                  068347
     C                   MOVEA     *BLANKS       @STK(Q)                                      068347
     C                   SUB       1             Q                                            068347
      *                                                                   068347
     CSR                 ENDSR                                                                068347
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRACT    : Undefined action - error                          *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     CSR   SRACT         BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRACT '      @STK(Q)
      *
      *  Database error undefined action
      *
     C                   MOVEL     '*ACTION '    W0FILE
     C                   MOVEL     W0ACT         W0KEY
     C                   Z-ADD     1             W0ERNB
     C                   MOVEL     ERR@(4)       W0NARR
     C                   EXSR      SRERR
      *
      *  Unwind subroutine stack name
      *
     C     EXACT         TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRACCS   : Check for valid access                            *
      *                                                               *
      *  CALLED BY: SRINIT  - Initialise and define fields            *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     CSR   SRACCS        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRACCS'      @STK(Q)
      *                                                                   045014
      *  Call AOCNTLR0 to see if access should be checked                 045014
      *                                                                   045014
     C                   CALLB     'AOCNTLR0'                           9090                   04501
     C     R#RTN         PARM      *BLANKS       O#RTN             7                           04501
     C                   PARM                    P#CNTL                                        04501
      *                                                                   045014
     C     *IN90         IFEQ      '1'                                                         04501
     C     R#RTN         ORNE      *BLANKS                                                     04501
     C                   MOVEL     'AOCNTLR0'    W0FILE                                        04501
     C                   MOVEL     '*CALL'       W0KEY                                         04501
     C                   Z-ADD     1             W0ERNB                                        04501
     C                   MOVEL     ERR@(6)       DBNARR                                        04501
     C                   EXSR      SRERR                                                       04501
     C                   MOVEL     *BLANKS       R#RTN             7                           04501
     C                   END                                                                   04501
      *                                                                   045014
      * No access validation required                                     045014
      *                                                                   045014
     C     P#ACCK        CABEQ     'N'           EXACCS                                        04501
      *
      *  Check for valid access
      *
     C                   MOVEL     *BLANKS       @PGMF            10
     C                   MOVEL     *BLANKS       @PGMFA           10
      *
      *  If already found only test for change
      *
     C     @T            IFGE      1
     C**********         CALLB     'AOCREPT'                            9090                  248460
     C                   CALL      'AOCREPT'                            9090                  248460
     C                   PARM      'CPF9898'     #MSGID            7
     C                   PARM      'QCPFMSG'     #MSGF            10
     C                   PARM      *BLANKS       #MSGFL           10
     C                   PARM      'Check'       #MSGDT          256
     C                   PARM      '*PRV'        #MSGR             5
     C                   PARM      PGM@(@T)      #PRGM            10
     C                   PARM      *BLANKS       #MSGQ            10
     C                   PARM      '*INFO  '     #MSGT             7
      *
      *  If found set flag to stop checking of all valid programs
      *
     C     *IN90         IFEQ      '0'
     C     PGM@(1)       ANDNE     PGM@(X)
     C                   MOVEL     'PG_FND'      @PGMF
     C                   ELSE
     C                   Z-ADD     0             @T                5 0
     C                   END
     C                   END
      *
     C***********          DO   9         X       50                      053518
     C                   DO        10            X                 5 0                         05341
      *
      *  Check for program in stack
      *
     C**********         CALLB     'AOCREPT'                            9090                  248460
     C                   CALL      'AOCREPT'                            9090                  248460
     C                   PARM      'CPF9898'     #MSGID
     C                   PARM      'QCPFMSG'     #MSGF
     C                   PARM      *BLANKS       #MSGFL
     C                   PARM      'Check'       #MSGDT
     C                   PARM      '*PRV'        #MSGR
     C                   PARM      PGM@(X)       #PRGM
     C                   PARM      *BLANKS       #MSGQ
     C                   PARM      '*INFO  '     #MSGT
      *
      *  Set flag if program found
      *
     C     *IN90         IFEQ      '0'
     C     PGM@(1)       ANDNE     PGM@(X)
     C                   MOVEL     'PG_FND'      @PGMF
     C                   Z-ADD     X             @T                5 0
     C     @PGMFA        IFEQ      'PG_FND'
     C                   GOTO      ENDLOP
     C                   END
     C                   END
     C     *IN90         IFEQ      '0'
     C     PGM@(1)       ANDEQ     PGM@(X)
     C                   MOVEL     'PG_FND'      @PGMFA
     C     @PGMF         IFEQ      'PG_FND'
     C                   GOTO      ENDLOP
     C                   END
     C                   END
     C                   END
     C     ENDLOP        TAG
      *
      *  Set flag if program found
      *
     C     @PGMF         IFNE      'PG_FND'
     C     @PGMFA        ORNE      'PG_FND'
     C                   MOVEL     '*PROGRAM'    W0FILE
     C                   MOVEL     '*ONLY'       W0KEY
     C                   Z-ADD     4             W0ERNB
     C                   MOVEL     ERR@(2)       W0NARR
     C                   EXSR      SRERR
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXACCS        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRERR    : Report error and close down program               *
      *                                                               *
      *  CALLED BY: *All routines                                     *
      *                                                               *
      *  CALLS    : *NONE                                             *
      *                                                               *
      *****************************************************************
     CSR   SRERR         BEGSR
      *
      *  Dump program
      *
     C     R#RTN         IFEQ      '*RECLCK'                                                AR868380
     C                   ROLBK                                                              AR868380
     C                   SETON                                        LR                    AR868380
     C                   MOVEL     '*RECLCK'     W0RTN                                      AR868380
     C                   ELSE                                                               AR868380
      *                                                                                     AR868380
     C                   DUMP
      *
      ***Rollback any changes applied
      *******                                                             125373B
     C*******    W0RTN     IFNE '*LEBTCH'                          122960 125373B
     C*******              ROLBK                                          125373B
     C*******              ENDIF                                   122960 125373B
      *
     C     CSC022        IFNE      'Y'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   END                                                                  CSC022
     C                   ENDIF                                                                CSC022
      *
      *  Send message to MOPERQ
      *
     C                   MOVEL     *BLANKS       DBDTA
     C                   MOVEL     'AOSPOSU0'    DBPGM
     C                   MOVEL     @STK(Q)       DBSTK
     C                   MOVEL     W0KEY         DBKEY
     C                   MOVEL     W0ERNB        DBERNB
     C                   MOVEL     W0FILE        DBFILE
     C                   MOVEL     W0PREF        DBPREF                                        04501
     C     W0NARR        IFEQ      *BLANKS
     C                   MOVEL     ERR@(1)       DBNARR
     C                   ELSE
     C                   MOVEL     W0NARR        DBNARR
     C                   END
     C/COPY WNCPYSRC,AOSPOSU0C1
      *
     C**********         CALLB     'AOCREPT'                            9090                  248460
     C                   CALL      'AOCREPT'                            9090                  248460
     C                   PARM      'MEM5000'     #MSGID
     C                   PARM      'MIDAS  '     #MSGF
     C                   PARM      *BLANKS       #MSGFL
     C                   PARM      DBDTA         #MSGDT
     C                   PARM      '*PRV'        #MSGR
     C                   PARM      '*'           #PRGM
     C                   PARM      'MOPERQ '     #MSGQ
     C                   PARM      '*INFO  '     #MSGT
      *
      *  Close down program
      *
     C*******************SETON                                        LR
     C*******************MOVEL     '*ERROR*'     W0RTN                          125373B
     C                   SETON                                        LR        141213
     C     CSC022        IFEQ      'Y'                                                        CSC022
     C     COMITSKIP     ANDEQ     'Y'                                                        CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   MOVEL     '*ERROR*'     W0RTN                          141213
                                                                                            AR868380
     C                   ENDIF                                                              AR868380
                                                                                            AR868380
     C                   RETURN                                                 125373B
      *
     CSR   EXERR         ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRFILE   : *PSSR routine for all files                       *
      *                                                               *
      *  CALLED BY: IBM controlled - invalid access to file           *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     CSR   SRFILE        BEGSR
      *
      *  Dump program
      *
     C     @UMSID        IFEQ      'CPF4128'                                                AR868380
     C                   SETON                                        LR                    AR868380
     C                   MOVEL     '*RECLCK'     W0RTN                                      AR868380
     C                   ELSE                                                               AR868380
     C                   DUMP
      *
      *  If called again seton LR and return
      *
     C     @@FILE        IFNE      *BLANKS
     C                   MOVEL     '1'           *INLR
     C                   RETURN
     C                   END
     C                   MOVEL     'Y'           @@FILE            1
      *
      *  Send message to MOPERQ
      *
     C                   MOVEL     *BLANKS       DBDTA
     C                   MOVEL     'AOSPOSU0'    DBPGM
     C                   MOVEL     @STK(Q)       DBSTK
     C                   MOVEL     ##ERST        DBKEY
     C                   MOVEL     1             DBERNB
     C                   MOVEL     ##ERFL        DBFILE
     C                   MOVEL     ERR@(8)       DBNARR
     C                   MOVEL     W0PREF        DBPREF                                        04501
      *
     C**********         CALLB     'AOCREPT'                            9090                  248460
     C                   CALL      'AOCREPT'                            9090                  248460
     C                   PARM      'MEM5000'     #MSGID
     C                   PARM      'MIDAS  '     #MSGF
     C                   PARM      *BLANKS       #MSGFL
     C                   PARM      DBDTA         #MSGDT
     C                   PARM      '*PRV'        #MSGR
     C                   PARM      '*'           #PRGM
     C                   PARM      'MOPERQ '     #MSGQ
     C                   PARM      '*INFO  '     #MSGT
      *
      *  Close down program
      *
     C                   SETON                                        LR
     C                   MOVEL     '*ERROR*'     W0RTN
                                                                                            AR868380
     C                   ENDIF                                                              AR868380
                                                                                            AR868380
     C                   RETURN
      *
     CSR   EXFILE        ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT   : Initialise and define fields                      *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    : SRACCS - valid access                             *
      *           : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     CSR   SRINIT        BEGSR
      *
      *  Set up copyright statement
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      *  Define W0 database error variables
      *
     C     *LIKE         DEFINE    DBFILE        W0FILE
     C     *LIKE         DEFINE    DBKEY         W0KEY
     C     *LIKE         DEFINE    DBERNB        W0ERNB
     C     *LIKE         DEFINE    DBNARR        W0NARR
     C     *LIKE         DEFINE    DBPREF        W0PREF
      *
      *  Check for programs in stack if none found error
      *
     C                   EXSR      SRACCS
      *
      *  Open Prono file
      *
     C                   OPEN      PRONO
      *
      *  Open SDBANKL1 file for working day & next working day
      *
     C                   OPEN      SDBANKL1
      *
     C                   MOVEL     'BANK'        BJBANK
     C***********BJBANK    CHAIN@BJREEF              90                   045014
     C     BJBANK        CHAIN     @BANKL1                            90                       04501
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'SDBANKL1'    W0FILE
     C                   MOVEL     '*ONLY'       W0KEY
     C                   Z-ADD     1             W0ERNB
     C                   MOVEL     ERR@(3)       W0NARR
     C                   EXSR      SRERR
     C                   END
     C                   CLOSE     SDBANKL1
      *                                                                                       246761
      ** Open SDGELRL1 file for Accrual on Non-Working Day indicator                          246761
      *                                                                                       246761
     C                   OPEN      SDGELRL1                                                   246761
      *                                                                                       246761
     C                   MOVEL     'GELR'        BKGNLG                                       246761
     C     BKGNLG        CHAIN     @GELRL1                            90                      246761
     C     *IN90         IFEQ      '1'                                                        246761
     C                   MOVEL     'SDGELRL1'    W0FILE                                       246761
     C                   MOVEL     '*ONLY'       W0KEY                                        246761
     C                   Z-ADD     1             W0ERNB                                       246761
     C                   MOVEL     ERR@(3)       W0NARR                                       246761
     C                   EXSR      SRERR                                                      246761
     C                   END                                                                  246761
     C                   CLOSE     SDGELRL1                                                   246761
      *
      ***Open*ACCNTAfileeforrgeneral*ledgertdetailsls******************                       243307
      ***Open*ACNUMB*file for retail accounts details                                  243307 CPK027
      ** Open ACCNT file for general ledger details                                           CPK027
      *
     C**********         OPEN      ACCNTA                                                     243307
     C**********         OPEN      ACNUMB                                              243307 CPK027
     C                   OPEN      ACCNT
      *
      ***Open*ACNUMA*file*for*retail*accounts*details******************                       243307
      *  Open ACNUMB file for retail accounts details                                         243307
      *
     C**********         OPEN      ACNUMA                                                     243307
     C                   OPEN      ACNUMB                                                     243307
      *
      *  Open SDNOSTL1 file for nostro details
      *
     C                   OPEN      SDNOSTL1
      *
      *  Open ACCNT file for general ledger details
      *
     C                   OPEN      SDNOSTL2
      *                                                                   045014
      *  Open SDMMODL1 file modules present                               045014
      *                                                                   045014
     C                   OPEN      SDMMODL1                                                    04501
      *                                                                   045014
     C                   MOVEL     'MMOD'        BGMODS                                        04501
     C     BGMODS        CHAIN     @MMODL1                            90                       04501
     C     *IN90         IFEQ      '1'                                                         04501
     C                   MOVEL     'SDMMODL1'    W0FILE                                        04501
     C                   MOVEL     '*ONLY'       W0KEY                                         04501
     C                   Z-ADD     2             W0ERNB                                        04501
     C                   MOVEL     ERR@(3)       W0NARR                                        04501
     C                   EXSR      SRERR                                                       04501
     C                   END                                                                   04501
     C                   CLOSE     SDMMODL1                                                    04501
      *                                                                                       CFT004
      *** Check if CFT004 is switched on                                                      CFT004
      *                                                                                       CFT004
     C                   CALL      'AOSARDR0'                                                 CFT004
     C                   PARM      '       '     @RTCD             7                          CFT004
     C                   PARM      '*VERIFY'     @OPTN             7                          CFT004
     C                   PARM      'CFT004'      @SARD             6                          CFT004
      *                                                                                       CFT004
     C     @RTCD         IFEQ      *BLANK                                                     CFT004
     C                   MOVE      'Y'           CFT004            1                          CFT004
     C                   ELSE                                                                 CFT004
     C                   MOVE      'N'           CFT004                                       CFT004
     C                   ENDIF                                                                CFT004
      *                                                                                       CSC022
      * Access SAR details file to determine if CSC022 switchable feature                     CSC022
      * is switched on                                                                        CSC022
                                                                                              CSC022
     C**********         CALLB     'AOSARDR0'                                          CSC022 248460
     C                   CALL      'AOSARDR0'                           9090                  248460
     C                   PARM      *BLANKS       @RTCD                                        CSC022
     C                   PARM      '*VERIFY'     @OPTN                                        CSC022
     C                   PARM      'CSC022'      @SARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        @RTCD = *Blanks                                            CSC022
                                                                                              CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   IN        SCCMTJOB                                                   CSC022
     C                   Z-ADD     1             CNT               3 0                        CSC022
     C                   MOVEL     *BLANKS       COMITSKIP         1                          CSC022
     C                   MOVEA     COMITARR      COMITJOB                                     CSC022
     C     COMITNUM      IFGT      0                                                          CSC022
     C     CNT           DOWLE     COMITNUM                                                   CSC022
     C     ##JOB         IFEQ      COMITJOB(CNT)                                              CSC022
     C                   MOVEL     'Y'           COMITSKIP                                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ADD       1             CNT                                          CSC022
     C                   ENDDO                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
      *                                                                                       CRE020
     C                   CALL      'AOSARDR0'                                                 CRE020
     C                   PARM      '       '     @RTCD             7                          CRE020
     C                   PARM      '*VERIFY'     @OPTN             7                          CRE020
     C                   PARM      'CRE020'      @SARD             6                          CRE020
      *                                                                                       CRE020
     C     @RTCD         IFEQ      *BLANK                                                     CRE020
     C                   MOVE      'Y'           CRE020            1                          CRE020
     C                   ELSE                                                                 CRE020
     C                   MOVE      'N'           CRE020                                       CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CAP205
      ** Check if CAP205 is switched on                                                       CAP205
      *                                                                                       CAP205
     C                   MOVE      'N'           CAP205            1                          CAP205
     C                   CALL      'AOSARDR0'                                                 CAP205
     C                   PARM      *BLANKS       @RTCD                                        CAP205
     C                   PARM      '*VERIFY'     @OPTN                                        CAP205
     C                   PARM      'CAP205'      @SARD                                        CAP205
      *                                                                                       CAP205
     C     @RTCD         IFEQ      *BLANK                                                     CAP205
     C                   MOVE      'Y'           CAP205                                       CAP205
     C                   ELSE                                                                 CAP205
     C     @RTCD         IFNE      '*NRF   '                                                  CAP205
     C                   MOVEL     'SCSARDPD'    W0FILE                                       CAP205
     C                   MOVEL     'CAP205'      W0KEY                                        CAP205
     C                   Z-ADD     6             W0ERNB                                       CAP205
     C                   EXSR      SRERR                                                      CAP205
     C                   ENDIF                                                                CAP205
     C                   ENDIF                                                                CAP205
      *
      *  Initialise arrays
      *
     C                   EXSR      SRCLR
      *
      *  Indicate that set up is complete
      *
     C                   SETON                                        50
     C/COPY WNCPYSRC,AOSPOSU0C8
      *
      *  Unwind subroutine stack name
      *
     C     EXINIT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************                       CRE020
      *                                                               *                       CRE020
      *  SRRtlAdv : Subroutine to write records for retail advice     *                       CRE020
      *             generation file for DL and LE module.             *                       CRE020
      *                                                               *                       CRE020
      *  CALLED BY: SRRSAC                                            *                       CRE020
      *                                                               *                       CRE020
      *  CALLS    : AOSVAL0 - Validates system values                 *                       CRE020
      *                                                               *                       CRE020
      *****************************************************************                       CRE020
     CSR   SRRtlAdv      BEGSR                                                                CRE020
                                                                                              CRE020
      *                                                                                       CRE020
     C                   MOVE      *BLANKS       W#GNAR                                       CRE020
      *                                                                                       CRE020
     C                   IF        W#MOD = 'FF'                                               CRE020
     C                   EVAL      W#GNAR = 'F'                                               CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CRE020
     C                   IF        W#MOD = 'SE'                                               CRE020
     C                   EVAL      W#GNAR = 'S'                                               CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CRE020
     C                   IF        W#MOD = 'FT'                                               CRE020
     C                   EVAL      W#GNAR = 'G'                                               CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CRE020
     C                   IF        W#MOD = 'LE'                                               CRE020
     C                   EVAL      W#GNAR = 'U'                                               CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CRE020
     C                   IF        W#MOD = 'DL'                                               CRE020
     C                   EVAL      W#GNAR = 'D'                                               CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      *                                                                                       CRE020
     C                   IF        W#MOD = 'DL'  OR W#MOD = 'LE'                              CRE020
      *                                                                                       CRE020
     C                   MOVE      *BLANKS       WTRAA                                        CRE020
     C                   MOVE      *BLANKS       WTRAC                                        CRE020
     C                   MOVE      *BLANKS       WTRAN                                        CRE020
     C                   MOVE      *BLANKS       KREFNO                                       CRE020
     C                   MOVE      *BLANKS       KPRGMN                                       CRE020
     C                   MOVE      *BLANKS       KSEQNO                                       CRE020
     C                   MOVE      *BLANKS       KRENAR                                       CRE020
     C                   EVAL      WSysVal01 = 'N'                                            CRE020
      *                                                                                       CRE020
     C     KAdvc         KLIST                                                                CRE020
     C                   KFLD                    KREFNO           30                          CRE020
     C                   KFLD                    KPRGMN           10                          CRE020
     C                   KFLD                    KSEQNO            3                          CRE020
     C                   KFLD                    KRENAR           29                          CRE020
     C                   KFLD                    KVDAT                                        CRE020
      *                                                                                       CRE020
     C                   IN        ZMITEM                                                     CRE020
     C                   Z-ADD     1             Y                 2 0                        CRE020
     C                   MOVEL     INDX          ZMNT10           10                          CRE020
     C     ZMNT10        LOOKUP    MNTID(Y)                               54                  CRE020
      *                                                                                       CRE020
     C                   IF        *IN54 = '1'                                                CRE020
     C                   MOVE      MNTD@(Y)      KPRGMN                                       CRE020
     C                   MOVE      SYSV@(Y)      PSysVal01                                    CRE020
                                                                                              CRE020
      ** Check if a System Value exists for this maintenance.                                 CRE020
     C**********         CALLB     'AOSVALR0'                                          CRE020 248460
     C                   CALL      'AOSVALR0'                           9090                  248460
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
      *                                                                                       CRE020
     C                   IF        PRtCd = *BLANKS                                            CRE020
     C                   MOVEL     PCurSet01     WSysVal01                                    CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CRE020
     C                   IF        WSysVal01 = 'Y'                                            CRE020
     C                   MOVEL     W#TRN         KREFNO                                       CRE020
     C                   MOVEL     W#PREF        KSEQNO                                       CRE020
     C                   MOVEL     W#VDAT        KVDAT             5 0                        CRE020
      *                                                                                       CRE020
     C                   IF        W#MOD = 'LE' AND W#TRYP = 'F2'                             CRE020
     C                   MOVE      W#TRN         WTRAA             5                          CRE020
     C                   MOVEL     W#PREF        WTRAC             6                          CRE020
     C                   MOVE      WTRAA         WTRAN                                        CRE020
     C                   MOVEL     WTRAC         WTRAN            11                          CRE020
     C                   MOVEL     WTRAN         KREFNO                                       CRE020
     C                   EVAL      KSEQNO = %SUBST(W#NARR:1:3)                                CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CRE020
     C                   MOVEL     W#NARR        KRENAR                                       CRE020
      *                                                                                       CRE020
     C                   OPEN      READVCL4                                                   CRE020
     C     KADVC         CHAIN     READVCL4                           55                      CRE020
      *                                                                                       CRE020
     C                   MOVEL     KREFNO        RREFNO                                       CRE020
     C                   MOVEL     KPRGMN        RPRGMN                                       CRE020
     C                   MOVEL     KRENAR        RENARR                                       CRE020
     C                   MOVEL     KVDAT         RVUDT                                        CRE020
     C                   MOVEL     W#TRYP        RTRTYP                                       CRE020
     C                   MOVEL     'N'           RAUTHI                                       CRE020
     C                   MOVEL     KSEQNO        RSEQNO                                       CRE020
      *                                                                                       CRE020
     C     *IN55         IFEQ      '1'                                                        CRE020
     C                   MOVEL     'I'           RCHTYP                                       CRE020
     C                   WRITE     READVCD0                                                   CRE020
     C                   ELSE                                                                 CRE020
     C                   UPDATE    READVCD0                                                   CRE020
     C                   ENDIF                                                                CRE020
     C                   CLOSE     READVCL4                                                   CRE020
      *                                                                                       CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CRE020
     CSR                 ENDSR                                                                CRE020
      *****************************************************************                       CRE020
     C/EJECT                                                                                  CRE020
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA PGM@
AOSPOSU0      Control Update of On-line positions
FT0261        Shadow Balance control program
FT0040        Outgoing Payments Maintenance
FT0050        Incoming Payments (S.W.I.F.T. I)
FT0055        Incoming Payments (S.W.I.F.T. I - Level 2)
FT0070        Cheques for Collection
FT0080        Cheques to be Paid
FT0100        Nostro Transfers
FT1050        Incoming Payments (S.W.I.F.T. II)
QCL           Command Entry
**CTDATA ERR@
See dump for further information
Invalid Access to update object
Record not found or marked as deleted
Undefined action code not *CLEAR, *ADD, *UPDATE or *COMMIT
Invalid account type specified not N,P,F,R or G
Too many postings are held - must not exceed 2000                                             197145
Error occurred on call to program - see dumps for further details
File access error occurred - see dump for full details - see key for opcode
**CTDATA MNTID                                                                                CRE020
0000001850                                                                                    CRE020
0000001856                                                                                    CRE020
0000001995                                                                                    CRE020
0000002398                                                                                    CRE020
0000001852                                                                                    CRE020
0000001857                                                                                    CRE020
0000002399                                                                                    CRE020
0000001853                                                                                    CRE020
0000001858                                                                                    CRE020
0000002400                                                                                    CRE020
0000001847                                                                                    CRE020
O000001854                                                                                    CRE020
0000002401                                                                                    CRE020
0000002079                                                                                    CRE020
0000002408                                                                                    CRE020
0000002081                                                                                    CRE020
0000002468                                                                                    CRE020
0000002469                                                                                    CRE020
0000001921                                                                                    CRE020
0000001926                                                                                    CRE020
0000001923                                                                                    CRE020
0000001925                                                                                    CRE020
0000001922                                                                                    CRE020
0000001924                                                                                    CRE020
0000001848                                                                                    CRE020
0000001855                                                                                    CRE020
0000002397                                                                                    CRE020
0000002518                                                                                    CRE020
0000002523                                                                                    CRE020
0000002524                                                                                    CRE020
0000002520                                                                                    CRE020
0000002521                                                                                    CRE020
0000002414                                                                                    CRE020
0000001832                                                                                    CRE020
**CTDATA MNTD@                                                                                CRE020
MMLDNIUPD                                                                                     CRE020
MMLDNIUPD                                                                                     CRE020
MMLDNIUPD                                                                                     CRE020
MMLDNIUPD                                                                                     CRE020
MMNASPUPD                                                                                     CRE020
MMNASPUPD                                                                                     CRE020
MMNASPUPD                                                                                     CRE020
MMNASSUPD                                                                                     CRE020
MMNASSUPD                                                                                     CRE020
MMNASSUPD                                                                                     CRE020
MMDEAMUPD                                                                                     CRE020
MMDEAMUPD                                                                                     CRE020
MMDEAMUPD                                                                                     CRE020
MMLDNIUPD                                                                                     CRE020
MMLDNIUPD                                                                                     CRE020
MMLDNIUPD                                                                                     CRE020
IRCACFUPD                                                                                     CRE020
IRCACFUPD                                                                                     CRE020
IRCIRSUPD                                                                                     CRE020
IRCIRSUPD                                                                                     CRE020
IRSIRSUPD                                                                                     CRE020
IRSIRSUPD                                                                                     CRE020
IRFRAUPD                                                                                      CRE020
IRFRAUPD                                                                                      CRE020
FXFXDLUPD                                                                                     CRE020
FXFXDLUPD                                                                                     CRE020
FXFXDLUPD                                                                                     CRE020
LECLIPUPD                                                                                     CRE020
LELOAMUPD                                                                                     CRE020
LERPSCUPD                                                                                     CRE020
LEMAPYUPD                                                                                     CRE020
LEFEEMUPD                                                                                     CRE020
LEFESTUPD                                                                                     CRE020
LEFESTUPD                                                                                     CRE020
**CTDATA SYSV@                                                                                CRE020
LoansDeposNAsIssued                                                                           CRE020
LoansDeposNAsIssued                                                                           CRE020
LoansDeposNAsIssued                                                                           CRE020
LoansDeposNAsIssued                                                                           CRE020
NAsPurchased                                                                                  CRE020
NAsPurchased                                                                                  CRE020
NAsPurchased                                                                                  CRE020
NAsSold                                                                                       CRE020
NAsSold                                                                                       CRE020
NAsSold                                                                                       CRE020
DealAmendments                                                                                CRE020
DealAmendments                                                                                CRE020
DealAmendments                                                                                CRE020
LoansDeposNAsIssued                                                                           CRE020
LoansDeposNAsIssued                                                                           CRE020
LoansDeposNAsIssued                                                                           CRE020
CapsCollarsFloorsMnt                                                                          CRE020
CapsCollarsFloorsMnt                                                                          CRE020
CrossCcyIntRateSwaps                                                                          CRE020
CrossCcyIntRateSwaps                                                                          CRE020
SngleCcyIntRateSwaps                                                                          CRE020
SngleCcyIntRateSwaps                                                                          CRE020
ForwardRateAgreement                                                                          CRE020
ForwardRateAgreement                                                                          CRE020
ForeignExchangeDeals                                                                          CRE020
ForeignExchangeDeals                                                                          CRE020
ForeignExchangeDeals                                                                          CRE020
LoansPartPrchPartSld                                                                          CRE020
LoanAmendments                                                                                CRE020
RepaymentSchedules                                                                            CRE020
ManualRepayments                                                                              CRE020
Fees                                                                                          CRE020
Fees                                                                                          CRE020
Fees                                                                                          CRE020
