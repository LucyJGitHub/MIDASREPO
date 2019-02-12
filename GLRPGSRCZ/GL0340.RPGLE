     H DEBUG                                                                                  S01194
      *****************************************************************
/*S*D ***RPGBASE*******************************************************                       CGL120
/*STD *  RPGBASEMOD                                                   *                       CGL120
/*EXI *  TEXT('Midas GL Daily journal')                               *
      *****************************************************************
      *                                                               *
      *  Midas - GENERAL LEDGER MODULE                                *
      *                                                               *
      *     GL0340  -  DAILY JOURNAL                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. LUC110             Date 23Jan19               *
      *  Prev Amend No. MD037383           Date 25May16               *
      *                 CGL049             Date 17Feb15               *
      *                 CGL160             Date 11Nov14               *
      *                 MD024553           Date 30Jan14               *
      *                 CGL120             Date 06Aug12               *
      *                 AR1004821          Date 30Jul12               *
      *                 AR659760           Date 20Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CGL030             Date 18Dec09               *
      *                 CAP204             Date 17Feb10               *
      *                 CGL047             Date 30Jun06               *
      *                 CSC042             Date 16Feb09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG9203            Date 01Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CGL050             Date 30Jan06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 209478             Date 09Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CGL007             Date 26Mar99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSD005             Date 22Feb99               *
      *                 CTI002             Date 23Sep98               *
     F*                 134018             Date 24Apr98               *
     F*                 127973             Date 08Dec98               *
     F*                 CRE004             Date 20Jan97               *
     F*                 120830             Date 06Jul97               *
     F*                 S01408             DATE 14NOV96               *
     F*                 S01408             DATE 07AUG96               *
     F*                 S01408             DATE 15APR96               *
     F*                 S01408             DATE 23JUN95                  *
     F*                 CRT001             DATE 28FEB95                  *
0009 F*                 S01408             DATE 15MAR95                  *
0009 F*                 069461             DATE 13APR94                  *
     F*                    S01464             DATE 04APR94               *
0009 F*                    S01421             DATE 01JUL93               *
     F*                    048147             DATE 25AUG93
0009 F*                    S01427             DATE 23JUL91
0009 F*                    S01290             DATE 05JUL90               *
0009 F*                    E16448             DATE 14FEB90               *
0009 F*                    S01117             DATE 07/03/89              *
0009 F*                    S01194             DATE 07/03/89              *
0009 F*                    S01196             DATE 07/03/89              *
0009 F*                    S01127             DATE 03/06/88              *
0009 F*                    S03220             DATE 10/05/87              *
     F*                    E10125             DATE 19/01/87              *
0009 F*                    E47289             DATE 21/12/86              *
0009 F*                    S01099             DATE 05/08/86              *
0010 F*                    S01102             DATE 05/08/86              *
     F*                                                                  *
      ********************************************************************
      *                                                               *
      *  LUC110 - Extended Narratives (Upgrade NUC002 to FBM 2.1)     *
      *           Use of core hook GL0340CCP1                         *
      *           Use of core hook GL0340I001                         *
      *           Use of core hook GL0340IIP1                         *
      *           Use of core hook GL0340IIPG                         *
      *           Use of core hook GL0340O004                         *
      *           Use of core hook GL0340O009                         *
      *           Use of core hook GL0340O012                         *
      *           Use of core hook GL0340OOP5                         *
      *           Use of core hook GL0340OOP7                         *
      *           Use of core hook GL0340OOP9                         *
      *           Addition of hook LUC110_053                         *
      *           Addition of hook LUC110_054                         *
      *           Addition of hook LUC110_055                         *
      *           Addition of hook LUC110_056                         *
      *           Addition of hook LUC110_057                         *
      *           Addition of hook LUC110_058                         *
      *           Addition of hook LUC110_059                         *
      *           Addition of hook LUC110_060                         *
      *           Addition of hook LUC110_061                         *
      *           Addition of hook LUC110_062                         *
      *           Addition of hook LUC110_063                         *
      *           Addition of hook LUC110_064                         *
      *           Addition of hook LUC110_065                         *
      *           Addition of hook LUC110_066                         *
      *           Addition of hook LUC110_067                         *
      *           Addition of hook LUC110_068                         *
      *           Addition of hook LUC110_069                         *
      *           Addition of hook LUC110_070                         *
      *           Addition of hook LUC110_071                         *
      *           Addition of hook LUC110_072                         *
      *           Addition of hook LUC110_073                         *
      *           Addition of hook LUC110_074                         *
      *  MD037383 - ACCNTAB blank after COB component GLC008140 00001 *
      *             Stamp Tax (CER049) processing.                    *
      *             Rework that component to make it 'Task Split'     *
      *             compliant.                                        *
      *  CGL049   - Separate Out Processing of Spot Reval and FX Tfr  *
      *  CGL160 - Cheque Details Upload via Generic Posting Interface *
      *             (Recompile)                                       *
      *  MD024553 - No posting found for Account used in GL0340P1     *
      *  CGL120 - GL COB Components Task Split                        *
      *  AR1004821 - Program GL0340 calls AOSARDR0 every time.        *
      *  AR659760 - Applied fix AR656202                              *
      *  AR656202 - Error message overlaps with Header line           *
      *             (Recompile)                                       *
      *  CGL030 - Sundry Postings                                     *
      *  CAP204 - Retail Account Transfer                             *
      *  CGL047 - Generic Posting Interface                           *
      *  CSC042 - Attempt to cut down on number of AOCUST accesses by *
      *           reusing data if current lookup is same as previous  *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  BUG9203 - Daily Journal Report not labelled properly         *
      *            Applied E44644 fixes from HEL-NYK                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CGL050 - Upgrade LBV028 to Midas Plus.                       *
      *           Daily Journal to include retail postings,           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  209478 - Print the Customer Report name in GL0340P1.         *
      *  CGL007 - Account Postings Enquiry (Recompile)                *
     F*  CSD005 - Switchable feature- if account narrative feature    *  *
     F*           is active the current account description shall be  *  *
     F*           replaced with the account narrative.                *  *
      *  CTI002 - Recompiled : File SDACODPD changed                  *
     F*  134018 - Array size has been increased but one of the checks *
     F*           on the index has not been changed. Error in Sweeps. *
     F*  127973 - Highlight postings with blank or default profit     *
     F*           centre.                                             *
     F*  CRE004 - Sweep Accounting:                                   *
     F*           Amended to process new Sweep Accounting Generated   *
     F*           Entries and associated Generated Entry Type('V').   *
     F*  120830 - Provide posting summaries by profit centre within   *
     F*           financial accounts.                                 *
     F*     S01408  -  Addition of Core Hook GL0340OOP5                  *
     F*                Addition of Core Hook GL0340OOP6                  *
     F*                Addition of Core Hook GL0340OOP7                  *
     F*                Addition of Core Hook GL0340OOP8                  *
     F*                Addition of Core Hook GL0340OOP9                  *
     F*                Addition of Core Hook GL0340OP10                  *
     F*                Addition of Core Hook GL0340OP11                  *
     F*                Addition of Core Hook GL0340OP12                  *
     F*     S01408  -  Addition of Core Hook GL0340CP13                  *
     F*             -  Addition of Core Hook GL0340IIP1                  *
     F*             -  Addition of Core Hook GL0340IIP2                  *
     F*             -  Addition of Core Hook GL0340OOP4                  *
     F*             -  Addition of Core Hook GL0340OOP3                  *
     F*     S01408  -  Addition of Core Hook GL0340EEP2                  *
     F*             -  Addition of Core Hook GL0340CP12                  *
     F*             -  Addition of Core Hook GL0340CP11                  *
     F*             -  Addition of Core Hook GL0340CP10                  *
     F*             -  Addition of Core Hook GL0340CCP9                  *
     F*             -  Addition of Core Hook GL0340CCP8                  *
     F*             -  Addition of Core Hook GL0340CCP7                  *
     F*             -  Addition of Core Hook GL0340CCP6                  *
     F*             -  Addition of Core Hook GL0340CCP5                  *
     F*             -  Addition of Core Hook GL0340CCP4                  *
     F*     S01408  -  Addition of Core Hook GL0340EEP1                  *
     F*             -  Addition of Core Hook GL0340CCP2                  *
     F*             -  Addition of Core Hook GL0340CCP3                  *
     F*             -  Addition of Core Hook GL0340CPL2                  *
     F*     CRT001  -  Retail Teller System                              *
     F*     S01408  -  Addition of Core Hook GL0340EEPG                  *
     F*             -  Addition of Core Hook GL0340IIPG                  *
     F*             -  Addition of Core Hook GL0340CCPG                  *
     F*             -  Addition of Core Hook GL0340CCP1                  *
     F*             -  Addition of Core Hook GL0340CPLT                  *
     F*             -  Addition of Core Hook GL0340CPL1                  *
     F*             -  Addition of Core Hook GL0340OOPG                  *
     F*             -  Addition of Core Hook GL0340OOP1                  *
     F*             -  Addition of Core Hook GL0340OOP2                  *
     F*     069461  -  Process new generated entry types for fixed a/c*
     F*                and statement charge postings.                 *
     F*     S01464  -  Safe Custody Fees                                 *
     F*     S01421  -  PROCESS ENTRIES FOR NUMBERED ACCOUNTS AND HOLD    *
     F*                MAIL. BLI STEP 1 DEVELOPMENT                      *
     F*                CHANGE FOR S01423 - CUSTOMER SERVICE FEES
     F*     048147  -  GL0340 did not set on U7 and U8 when database
     F*                error occurred.
     F*     S01427  -  R10 CHIPS INCORPORATION                         S01427
     F*     S01290  -  MIS GL REPORTING CHANGES                          *
     F*     E16448  -  SHOW POSTING FILE CONTROLS AS CALCULATED AND INPUT*
     F*     S01117  -  MULTI-BRANCHING                                   *
     F*     S01194  -  NEW STANDING DATA                                 *
     F*     S01196  -  REMOVAL OF LETTERS OF CREDIT MODULE CODING        *
     F*     S01127  -  INTERFACE FUTURES AND OPTIONS                     *
     F*     S03220  -  INTERFACE FUNDS TRANSFER                          *
     F*                                                                  *
     F*     E10125  -  IF OF AND L5 ARE ON AT THE SAME TIME UNWANTED     *
     F*                HEADINGS ARE OUTPUT.                              *
     F*     E47289  -  IF NUMBER OF POSTINGS EXCEED 9999 THEN REPORT     *
     F*                MISSES MOST SIGNIFICANT DIGIT.                    *
     F*     S01099  -  INCLUSION BASE CCY I/E XFER                       *
     F*     S01102  -  INCLUSION OF AMOUNT ACCRUALS                      *
0011 F*                                                                  *
0012 F********************************************************************
0013 F/SPACE 3
0014 F*                                                                  *
0015 F* ID F  C  M  L    FUNCTION OF INDICATORS                          *
0016 F*
0017 F* 01             ACCOUNT BALANCES EXTRACT - DETAIL
0018 F* 02                                      - TOTAL
0019 F**03*******                               - CATCHALL                                    CGL120
      * 03                                      - DUMMY (UNMATCHED POSTINGS)                  CGL120
0020 F* 04             ACCOUNT POSTINGS - NON-RETAIL
0021 F* 05                              - RETAIL
0022 F* 06                              - CATCHALL
0023 F**07*******      CLINT - STANDING DATA                              S01194
0024 F**08*******            - CATCHALL                                   S01194
0025 F**09*******      TABLE - A/C CODES                                  S01194
0026 F**10*******            - ICR 1                                      S01194
      * 10             End of Posting Records on ACJND                                        CGL120
0027 F**
      *       11       Posting Records for Profit Centre                                      CGL120
      *       12       Posting Records for Account Sequence                                   CGL120
      *       13       Posting Records for Retail Indicator                                   CGL120
      *       14       POSTING RECORDS FOR ACCOUNT CODE                                       CGL120
     F*       15       TYPE OF REPORT = SUMMARY REPORT                    S01290
     F*       16       TOTAL OF CREDITS (PSTACR) = 0                      S01290
     F*       17       TOTAL OF DEBITS (PSTADR) = 0                       S01290
     F*       18       TOTAL OF RETAIL CREDITS (TPSTCR) = 0               S01290
     F*       19       TOTAL OF RETAIL DEBITS (TPSTDR) = 0                S01290
0028 F*       20       EOF FOR ABEXZY
0029 F*       21       EOF FOR ACJNT
     F*       22       TRANSACTION TYPE NON-ZERO                          S01099
     F*       23       GEFP RECORDS READ SAR 3220                         S03220
     F*       25       MULTIBRANCHING OUTPUT INDICATOR                    S01117
     F*       27       Analytical Accounting is installed                 120830
     F*       28       Posting to blank or default profit centre          127973
     F*       29       At least 1 posting to blank/default profit centr   127973
0028 F*       30       0 DECIMAL PLACES FOR CCY
0029 F*       31       1 DECIMAL PLACE FOR CCY
0030 F*       32       2 DECIMAL PLACES FOR CCY
0031 F*       33       3 DECIMAL PLACES FOR CCY
0033 F*       35       POSTING TO CREDIT
0034 F*       36       POSTING TO DEBIT
0035 F*       37      ASSOC. CUST. ZERO
0036 F********38      NO POSTING RECORDS                                                      CGL120
      *       38      No Posting Records for Branch                                           CGL120
0037 F*
0038 F*       40       ON - BYPASS FIRST CYCLE PROCESSING.
0039 F*       41       ON - FIRST CYCLE PROCESSING
0040 F*       42      CREDIT BALANCE ZERO
0041 F*       44      DEBIT BALANCE ZERO
0042 F*
0043 F*       48       GLZADD LOOP FINISHED
0044 F*       49       CCY CHANGE
0045 F*       50       GETP LOKUP FAILED
0046 F*       51       OUTPUT - BRANCH HASH TOTALS-HEADING
0047 F*       52              -                   -DETAILS
0048 F*       53      CREDIT BALANCE PRESENT
0049 F**
0050 F*       55       NO.OF POSTING FOR BRANCH TOTAL  S ZERO
0051 F*       56       'OVERALL' HASH TOTALS BEING PROCESSED
     F*       57       ALL BRANCHES ARE REQUESTED FOR REPORTING           S01117
     F*       58       CONSOLIDATED REPORT REQUESTED                      S01117
     F*       59       MULTIBRANCH INDICATOR = 'Y'                        S01117
0052 F*
0053 F*       61       CHANGE OF A/C CODE
0054 F*       62       NO TOTAL EXTRACT RECORD FOR A/C CODE
0055 F********63*      TABLE CHAIN FAILED                                 S01194
0055 F*       63       DATABASE ERROR                                     S01194
0056 F*       65       CUSTOMER CHANGE
0057 F*       67       A/C SEQ. CHANGE
0058 F*       69       RETAIL CHANGE
0059 F*       73       SWITCHABLE FEATURE CSD005 ACTIVE                   S01290
0059 F********76*******RETAIL TOTALS                                      S01290
0059 F*       76       NON-RETAIL TOTALS                                  S01290
0060 F********77*******NON-RETAIL TOTALS                                  S01290
0060 F*       77       RETAIL TOTALS                                      S01290
0061 F********78******FETCHED HEADINGS PREVIOUS CYCLE                     S01290
0061 F*       78       FETCHED HEADINGS PREVIOUS CYCLE                    S01290
0062 F*       79       OUTPUT - CCY TOTAL IF NOT ZERO
0063 F*       80       OUTPUT - HEADINGS
0064 F*       81              - A/C OPENING BALANCE
0065 F*       82              - CLIENT & A/C SEQ OPENING BALANCE
0066 F*       83              - A/C SEQ OPENING BALANCE
0067 F*       84              - POSTING DETAILS
0068 F*       85              - A/C SEQ C/B
0069 F*       86              - RETAIL A/C  O/B & C/B
0070 F*       87              - A/C CODE C/B
0071 F*       88              - END OF REPORT HASH TOTALS - HEADING
0072 F*       89                                        - DETAIL
0073 F*
     F*             U6 GEFPZZ RECORDS READ SAR 3220                       S03220
0074 F*             U7 FILE CONTROLS OUT OF BALANCE
0075 F*             U8 CCY OUT OF BALANCE
0076 F*
0077 F**************L1*ACSQ                                               120830
0078 F**************L2*CNUM                                               120830
0079 F**************L3*RIND                                               120830
0080 F**************L4*ACOD                                               120830
0081 F**************L5*CCY                                                120830
0082 F**************L6*BRCD                                               120830
     F*             L1 PRFC                                               120830
     F*             L2 ACSQ                                               120830
     F*             L3 CNUM                                               120830
     F*             L4 RIND                                               120830
     F*             L5 ACOD                                               120830
     F*             L6 CCY                                                120830
     F*             L7 BRCD                                               120830
0083 F*
0084 F/SPACE 3
0085 F*
0086 F*
0087 F***ACBL*** IPEAF      40 19AI     2 DISK                                                CGL029
     F***ACBL***   IPE AF   50    25AIDISK    KEYLOC(2)                                CGL029 CGL120
     FGLDLYPPD  IPE AF   54    25AIDISK    KEYLOC(2)                                          CGL120
0087 FABEXZY    IF   F   40        DISK
0088 F*
     FSACBL     IF   E           K DISK    PREFIX(S_)                                         CGL120
0089 F***ACJND***ISEAF     160 19AI     2 DISK                            CGL007
0089 F***ACJND** ISEAF     331 19AI     2 DISK                                         CGL007 CGL029
     F***ACJND**   ISE AF  620    19AIDISK    KEYLOC(2)                                CGL029 CGL120
     FACJND     IF   F  620    29AIDISK    KEYLOC(2)                                          CGL120
0089 FACJNT     IF   F  160     1AIDISK    KEYLOC(1)
     FGLGPICL1  IF   E           K DISK                                         CGL047
0090 F*
0091 F*LINT***IF* F     256  7AI     2 DISK                               S01194
0092 F*
0093 F*ABLE***IF* F      96 12AI     2 DISK                               S01194
0094 F*
0095 F*L0340P1O   F     132     OF     PRINTER                      S01124S01117
0095 FGL0340P1  O    F  132        PRINTER INFDS(SPOOL)                         S01117
     F                                     OFLIND(*INOF)
     F                                     USROPN
0095 FGL0340AU  O    F  132        PRINTER INFDS(SPOOLU)                        S01117
     F                                     OFLIND(*INOA)
0096 F*
0097 F*
     F/COPY WNCPYSRC,LUC110_053                                                               LUC110
      *                                                                                       CGL030
     D ARL1            S             29    DIM(2) CTDATA PERRCD(1)                            CGL030
     D ARG1            S              1    DIM(2) CTDATA PERRCD(2)                            CGL030
     D ARN1            S              6  0 DIM(2)                                             CGL030
     D BRN1            S              6  0 DIM(2)                                             CGL030
     D AR1I            S             15  0 DIM(2)                                             CGL030
     D BR1I            S             15  0 DIM(2)                                             CGL030
     D AR1D            S              3  0 DIM(2)                                             CGL030
     D BR1D            S              3  0 DIM(2)                                             CGL030
      *                                                                                       CGL030
     F/COPY WNCPYSRC,GL0340F001
     D/COPY WNCPYSRC,GL0340EKUT                                           S01408
     D*                                                                   S01408
     D/COPY WNCPYSRC,GL0340EEPG                                           S01408
     D*                                                                   S01408
0098 D**
0099 D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)              ZDATE1/2 SR.ARRAY
0100 D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)            ZDATE1/2 SR.ARRAY
0101 D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)            ZDATE2 SR. ARRAY
     D***
0102 D********AMENDMENT*TO*INCLUDE*SECURITIES*TRADING*******              S01102
0103 D******              ARGP   15  15  1                                S01102
0104 D******              ARLT    1  15 29                                S01102
0103 D***********         ARGP   17  17  1                         S01102 S03320
0104 D***********         ARLT    1  17 29                         S01102 S03320
0103 D***                 ARGP   18  18  1                         S03320 S01127
0104 D***                 ARLT    1  18 29                         S03220 S01127
0103 D***********         ARGP   19  19  1                         S01127 S01196
0104 D***********         ARLT    1  19 29                         S01127 S01196
0103 D*************       ARGP   17  17  1                         S01196 S01427
0104 D*************       ARLT    1  17 29                         S01196 S01427
0103 D************        ARGP   18  18  1                          S01427S01421
0104 D************        ARLT    1  18 29                          S01427S01421
0103 D***********         ARGP   20  20  1                         S01421 069461
0104 D***********         ARLT    1  20 29                         S01421 069461
0103 D***********         ARGP   21  21  1                          069461S01464
0104 D***********         ARLT    1  21 29                          069461S01464
0105 D******              ARNP       16  4 0                              S01102
0106 D******              BRNP       16  4 0                              S01102
0107 D******              ARTI       16 15 0                              S01102
0108 D******              BRTI       16 15 0                              S01102
0109 D******              ARTD       16  3 0                              S01102
0110 D******              BRTD       16  3 0                              S01102
0105 D******              ARNP       18  4 0                       S01102 E47289
0106 D******              BRNP       18  4 0                       S01102 E47289
0105 D***********         ARNP       18  6 0                       E47289 S03220
0106 D***********         BRNP       18  6 0                       E47289 S03220
0107 D***********         ARTI       18 15 0                       S01102 S03220
0108 D***********         BRTI       18 15 0                       S01102 S03220
0109 D***********         ARTD       18  3 0                       S01102 S03220
0110 D***********         BRTD       18  3 0                       S01102 S03220
0105 D***                 ARNP       19  6 0                       S03220 S01127
0106 D***                 BRNP       19  6 0                       S03220 S01127
0107 D***                 ARTI       19 15 0                       S03220 S01127
0108 D***                 BRTI       19 15 0                       S03220 S01127
0109 D***                 ARTD       19  3 0                       S03220 S01127
0110 D***                 BRTD       19  3 0                       S03220 S01127
0105 D***********         ARNP       20  6 0                       S01127 S01196
0106 D***********         BRNP       20  6 0                       S01127 S01196
0107 D***********         ARTI       20 15 0                       S01127 S01196
0108 D***********         BRTI       20 15 0                       S01127 S01196
0109 D***********         ARTD       20  3 0                       S01127 S01196
0110 D***********         BRTD       20  3 0                       S01127 S01196
0105 D********            ARNP       18  6 0                        S01196S01421
0106 D********            BRNP       18  6 0                        S01196S01421
0107 D********            ARTI       18 15 0                        S01196S01421
0108 D********            BRTI       18 15 0                        S01196S01421
0109 D********            ARTD       18  3 0                        S01196S01421
0110 D********            BRTD       18  3 0                        S01196S01421
0105 D*********           ARNP       19  6 0                        S01427S01421
0106 D*********           BRNP       19  6 0                        S01427S01421
0107 D*********           ARTI       19 15 0                        S01427S01421
0108 D*********           BRTI       19 15 0                        S01427S01421
0109 D*********           ARTD       19  3 0                        S01427S01421
0110 D*********           BRTD       19  3 0                        S01427S01421
0105 D***********         ARNP       21  6 0                        S01421S01464
0106 D***********         BRNP       21  6 0                        S01421S01464
0107 D***********         ARTI       21 15 0                        S01421S01464
0108 D***********         BRTI       21 15 0                        S01421S01464
0109 D***********         ARTD       21  3 0                        S01421S01464
0110 D***********         BRTD       21  3 0                        S01421S01464
     D***********         ARGP   22  22  1                         S01464 CRT001
     D***********         ARLT    1  22 29                         S01464 CRT001
     D***********         ARNP       23  6 0                       S01464 CRT001
     D***********         BRNP       23  6 0                       S01464 CRT001
     D***********         ARTI       23 15 0                       S01464 CRT001
     D***********         BRTI       23 15 0                       S01464 CRT001
     D***********         ARTD       23  3 0                       S01464 CRT001
     D***********         BRTD       23  3 0                       S01464 CRT001
     D*                                                                   S01408
     D/COPY WNCPYSRC,GL0340EEP2                                           S01408
     D*                                                                   S01408
     D***********         ARGP   23  23  1                         CRT001 CRE004
     D***********         ARLT    1  23 29                         CRT001 CRE004
     D/COPY WNCPYSRC,GL0340E001
     D***********         ARNP       24  6 0                       CRT001 CRE004
     D***********         BRNP       24  6 0                       CRT001 CRE004
     D***********         ARTI       24 15 0                       CRT001 CRE004
     D***********         BRTI       24 15 0                       CRT001 CRE004
     D***********         ARTD       24  3 0                       CRT001 CRE004
     D***********         BRTD       24  3 0                       CRT001 CRE004
     D**********          ARGP   24  24  1                                             CRE004 CGL047
     D**********          ARGP   25  25  1                                             CGL047 CAP204
     D ARGP            S              1    DIM(26) CTDATA PERRCD(26)                          CAP204
     D**********          ARLT    1  24 29                                             CRE004 CGL047
     D**********          ARLT    1  25 29                                             CGL047 CAP204
     D ARLT            S             29    DIM(26) CTDATA PERRCD(1)                           CAP204
     D*POST*****       S             16    DIM(5) CTDATA PERRCD(1)                    BUG9203 CGL049
     D*POST*****       S             16    DIM(6) CTDATA PERRCD(1)                   CGL049 MD037383
     D POST            S             16    DIM(7) CTDATA PERRCD(1)                          MD037383
     D**********          ARNP       25  6 0                                           CRE004 CGL047
     D**********          BRNP       25  6 0                                           CRE004 CGL047
     D**********          ARTI       25 15 0                                           CRE004 CGL047
     D**********          BRTI       25 15 0                                           CRE004 CGL047
     D**********          ARTD       25  3 0                                           CRE004 CGL047
     D**********          BRTD       25  3 0                                           CRE004 CGL047
     D ARNP            S              6  0 DIM(26)                                            CGL047
     D BRNP            S              6  0 DIM(26)                                            CGL047
     D ARTI            S             15  0 DIM(26)                                            CGL047
     D BRTI            S             15  0 DIM(26)                                            CGL047
     D ARTD            S              3  0 DIM(26)                                            CGL047
     D BRTD            S              3  0 DIM(26)                                            CGL047
     D*                                                                   S01408
     D/COPY WNCPYSRC,GL0340EEP1                                           S01408
     D*                                                                   S01408
0111 D**
0112 D INT             S             15  0 DIM(6)
0113 D DEC             S              3  0 DIM(6)
     D*                                                                   S01408
0204 D/SPACE 2
0205 D*****CLIENT*FILE*-*CUSTOMER*STANDING*DATA*RECORD                    S01194
0206 D***
0207 D*LINT***NS* 07   1 CD   8 CA                                        S01194
0208 D***********                             1   1 RECI                  S01194
0209 D***********                             2   70CNUM                  S01194
0210 D***********                             8   8 RECTC                 S01194
0211 D***********                             9  28 CRNM                  S01194
0212 D***********                            29  38 CTWN                  S01194
0213 D***********                            39  48 CSNM                  S01194
0214 D***********                            49  56 CASK                  S01194
0215 D***********                            57  68 TELX                  S01194
0216 D***********                            69  80 CSID                  S01194
0217 D***********                            81  82 ACOC                  S01194
0218 D***********                            83  83 CBSI                  S01194
0219 D***********                            84  85 CCTZ                  S01194
0220 D***********                            86  87 CLOC                  S01194
0221 D***********                            88  930CPAR                  S01194
0222 D***********                            94  960BRCD                  S01194
0223 D***********                            97  98 LINS                  S01194
0224 D***********                            99 101 LIND                  S01194
0225 D***********                         P 102 1040DASUS                 S01194
0226 D***********                         P 105 1070CDIC                  S01194
0227 D***********                         P 108 1100DADE                  S01194
0228 D***********                           111 111 CMIN                  S01194
0229 D***********                           112 112 CTYP                  S01194
0230 D***********                           113 124 TELF                  S01194
0231 D***********                         P 250 2520LCD                   S01194
0232 D***********                           253 253 CHTP                  S01194
0233 D***********                         P 254 2560TNLU                  S01194
0234 D**                                      1 256 LOT
0235 D**
0236 D*****CATCHALL*FOR*DELETED*RECORDS                                   S01194
0237 D********NS*                                                         S01194
0238 D**
0239 D/SPACE 2
0240 D**
0241 D*****TABLE*FILE*-*ACCOUNT*CODES                                     S01194
0242 D**
0243 D*ABLE***NS* 09   1 CD   2 C3   3 C0                                 S01194
0244 D*******AND*     13 C1                                               S01194
0245 D***********                             1   1 RECI                  S01194
0246 D***********                             2   30RECTT                 S01194
0247 D***********                             9  120ACOD                  S01194
0248 D***********                            13  130SREC                  S01194
0249 D***********                            14  38 ACKN                  S01194
0250 D***********                            39  39 ATYP                  S01194
0251 D***********                            40  430SHLC                  S01194
0252 D***********                            44  470SHFC                  S01194
0253 D***********                            48  48 TITO                  S01194
0254 D***********                            49  520BSDR                  S01194
0255 D***********                            53  560BSCR                  S01194
0256 D***********                            57  600PLDR                  S01194
0257 D***********                            61  640PLCR                  S01194
0258 D***********                            65  740RPCD                  S01194
0259 D***********                            75  75 ACCS                  S01194
0260 D***********                         P  90  920LCD                   S01194
0261 D***********                            93  93 CHTP                  S01194
0262 D***********                         P  94  960TNLU                  S01194
0263 D**                                      1  96 LOT
0264 D*****TABLE*FILE*-*INSTALLATION*CONTROL*RECORD*1                     S01194
0265 D**
0266 D********NS*      1 CD   2 C0   3 C1                                 S01194
0267 D*******AND*     12 C1  13 C0                                        S01194
0268 D***********                             1   1 RECI                  S01194
0269 D***********                             2   30RECTT                 S01194
0270 D***********                            12  13 RCDE                  S01194
0271 D***********                            14  66 TITL                  S01194
0272 D***********                            67  67 DATF                  S01194
0273 D***********                            68  730DFBR                  S01194
0274 D***********                            74  74 MODI1                 S01194
0275 D***********                            75  75 MODI2                 S01194
0276 D***********                            76  76 MODI3                 S01194
0277 D***********                         P  77  790RUND                  S01194
0278 D***********                            80  86 RUNA                  S01194
0279 D***********                            87  870SFLG                  S01194
     D***********                            88  88 MODI4         S03220  S01194
0280 D***********                         P  90  920LCD                   S01194
0281 D***********                            93  93 CHTP                  S01194
0282 D***********                         P  94  960TNLU                  S01194
0283 D**                                      1  96 LOT
0284 D*****TABLE*FILE*-*CURRENCIES*RECORD*1.                              S01194
0285 D**
0286 D*
0287 D*****TABLE*FILE*-*CURRENCIES*RECORD*1.                              S01194
0288 D**
0289 D********NS*      1 CD   2 C2   3 C0                                 S01194
0290 D*******AND*     13 C1                                               S01194
0291 D***********                             1   1 RECIX                 S01194
0292 D***********                             2   30RECTX                 S01194
0293 D***********                            10  12 CCYX                  S01194
0294 D***********                            13  130SRECX                 S01194
0295 D***********                            38  380CDPX                  S01194
0296 D**
     D*
0297 D*****CATCHALL.                                                      S01194
0298 D********NS*                                                         S01194
0299 D***********                             1   1 RECDX                 S01194
0300 D***********                             2   30RECTX                 S01194
0301 D***********                            13  130SRECX                 S01194
0302 D**
0303 D**
0304 D/SPACE 2
0305 D***
     D*     LOCAL DATA AREA                                               S01117
     D LDA            UDS           256                                         S01117
     D  DBFILE               134    141                                         S01117
     D  DBKEY                142    170                                         S01117
     D  DBPGM                171    180                                         S01117
     D  DBASE                181    183  0                                      S01117
0306 D*
0307 D ACJK            DS
0308 D***********                             1   30BRCDJ                 S01117
0308 D  BRCDJ                  1      3                                         S01117
0309 D  CCYJ                   4      6
0310 D**********                              7  100ACODJ                                     CGL029
0311 D**********                             11  110RINDJ                                     CGL029
0312 D**********                             12  170CNUMJ                                     CGL029
0313 D**********                             18  190ACSQJ                                     CGL029
     D  ACODJ                  7     16  0                                                    CGL029
     D  RINDJ                 17     17  0                                                    CGL029
     D**********                             18  230CNUMJ                              CGL029 CSD027
     D  CNUMJ                 18     23                                                       CSD027
     D  ACSQJ                 24     25  0                                                    CGL029
0314 D**
0315 D**********                              1  10 ACJK1                                     CGL029
0316 D**********                              1  19 ACJK2                                     CGL029
     D  ACJK2                  1     25                                                       CGL029
     D ACBK            DS                                                                     CGL029
     D  BRCDB                  1      3                                                       CGL029
     D  CCYB                   4      6                                                       CGL029
     D  ACODB                  7     16  0                                                    CGL029
     D  RINDB                 17     17  0                                                    CGL029
     D**********                             18  230CNUMB                              CGL029 CSD027
     D  CNUMB                 18     23                                                       CSD027
     D  ACSQB                 24     25  0                                                    CGL029
      *                                                                                       CGL120
     D AJNKY           DS                                                                     CGL120
     D  BRCDK                  1      3                                                       CGL120
     D  CCYK                   4      6                                                       CGL120
     D  ACODK                  7     16  0                                                    CGL120
     D  RINDK                 17     17  0                                                    CGL120
     D  CNUMK                 18     23                                                       CGL120
     D  ACSQK                 24     25  0                                                    CGL120
     D  PRFCK                 26     29                                                       CGL120
     D*CJK1       DS                                                                          CGL029
     D*                                       1   3 BRCDJ                                     CGL029
     D*                                       4   6 CCYJ                                      CGL029
     D*                                       7  160ACODJ                                     CGL029
     D*CBLT       DS                                                                          CGL029
     D*                                       1   3 BRCDB                                     CGL029
     D*                                       4   6 CCYB                                      CGL029
     D*                                       7  160ACODB                                     CGL029
0317 D**
0318 D/SPACE 2
0319 D***
0320 D*
0321 D*CDKEY***** DS                                                      S01194
0322 D***********                             1   20TTYPA                 S01194
0323 D***********                             3   7 BLNKA                 S01194
0324 D***********                             8  110ACDK                  S01194
0325 D***********                            12  120RNUMA                 S01194
0326 D***********                             1  12 ACDKY                 S01194
0327 D**
0328 D/SPACE 2
0329 D***
0330 D*
0331 D*CYKEY***** DS                                                      S01194
0332 D***********                             1   20TTYPC                 S01194
0333 D***********                             3   8 BLNKC                 S01194
0334 D***********                             9  11 CCYK                  S01194
0335 D***********                            12  120RNUMC                 S01194
0336 D***********                             1  12 CCYKY                 S01194
0337 D**
0147 D**
0148 D**   TRAILER
0149 D**
0150 D ABEXDS          DS            40
0151 D  INT#1                  5     12P 0
0152 D  DEC#1                 13     14P 0
0153 D  INT#2                 15     22P 0
0154 D  DEC#2                 23     24P 0
0188 D*
0189 D ACJNDS          DS           160
     D  RECI                   1      1
0192 D  NOREP#                 2      6  0
0192 D  INT#3                  7     14P 0
0193 D  DEC#3                 15     16P 0
     D*  DATA STRUCTURE FOR COMPILATION  - COPYRIGHT INSERTION            S03220
     D CPYR@#          DS                                                       S03220
     D  CPY@                   1     80                                         S03220
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20                                         S03220
     D**                                                                  S01117
     D**   FILE INFORMATION DATA STRUCTURE                                S01117
     D**                                                                  S01117
     D SPOOL           DS                                                       S01117
     D  SFILE                 83     90                                         S01117
     D  SFNUM                123    124B 0                                      S01117
     D*                                                                   S01117
     D SPOOLU          DS                                                       S01117
     D**   FILE INFORMATION DATA STRUCTURE                                S01117
     D  SFILEU                83     90                                         S01117
     D  SFNUMU               123    124B 0                                      S01117
     D*                                                                   S01194
     D RUNDT           DS                                                       S01194
     D** DATA AREA RUNDAT                                                 S01194
     D  RUNA                   1      7                                         S01194
     D  RUND                   8     10P 0                                      S01194
     D  SSF                   11     11                                         S01194
     D  DATF                  12     12                                         S01194
     D  MBIN                  13     13                                         S01194
     D*                                                                   S01194
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                    S01194
     D**   BRANCH DETAILS                                                 S01194
     D*                                                                   S01194
     D SDACOD        E DS                  EXTNAME(SDACODPD)                    S01194
     D**   ACCOUNT CODES                                                  S01194
     D*                                                                   S01194
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                    S01194
     D**   CURRENCIES CODES                                               S01194
     D*                                                                   S01194
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                    S01194
     D**   MIDAS MOD FLAGS                                                S01194
     D*                                                                   S01194
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                    S01194
     D**   BANK DETAILS                                                   S01194
     D*                                                                   S01194
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    S01194
     D**   CLINT DETAILS                                                  S01194
     D  QQDFAX       E                     EXTFLD(QQDFAC)                                     CGL029
     D*                                                                   127973
     D SDPCAC        E DS                  EXTNAME(SDPCACPD)                    127973
     D**   PCA ICD Details                                                127973
     D  QQFNAX       E                     EXTFLD(QQFNAA)                                     CGL029
     D  QQFNIX       E                     EXTFLD(QQFNIC)                                     CGL029
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01194
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                S01194
     D*                                                                   S01117
     D DSSDY         E DS                  EXTNAME(DSSDY)                       S01194
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE                S01194
      *                                                                   CSD005
     D*                                                                   CSD005
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CSD005
     D** MIDAS Switchable Features Accessed Via Access Program            CSD005
     D*                                                                   CSD005
     D*                                                                   S01194
     D*                                                                   S01408
      *                                                                                       CGL030
     D WWARLT          DS          4000                                                       CGL030
      ** Entire contents of array ARLT (used to find nbr of elements)                         CGL030
     D WWARL1          DS          4000                                                       CGL030
0114 I/SPACE 2
0115 I**
0116 I*    ACCOUNT BALANCES EXTRACT DETAIL RECORD
0117 I**
0118 I***ACBL***   NS  01    1 CD                                                             CGL120
0119 I**********                        1    1  RECI                                          CGL120
0120 I**********                                                                              CGL120
0121 I**********                              2  20 ACBK                                      CGL029
0122 I*
0123 I***********                             2   40BRCDB   M6            S01117
0123 I**********                        2    4  BRCDB           M6                     S01117 CGL120
0124 I**********                        5    7  CCYB            M5                            CGL120
0125 I**********                              8  110ACODB   M4                                CGL029
     I**********                        8   11 0ACODQQ                                 CGL029 CGL120
0126 I**********                       12   12 0RINDB           M3                            CGL120
0127 I**********                             13  180CNUMB   M2                                CSD027
0127 I**********                       13   18  CNUMB           M2                     CSD027 CGL120
0128 I**********                       19   20 0ACSQB           M1                            CGL120
0129 I**********                   P   21   28 0CRBL                  5342                    CGL120
0130 I**********                   P   29   36 0DRBL                    44                    CGL120
     I**********                       41   50 0ACODB           M4                     CGL029 CGL120
0131 I**
0132 I*    TOTAL EXTRACT RECORD
0133 I**
0134 I**********NS  02    1 CE                                                                CGL120
0135 I**********                        1    1  RECI                                          CGL120
0136 I*
0137 I**********                              2  11 ACBLT                                     CGL029
0138 I*
0139 I***********                             2   40BRCDB   M6            S01117
0139 I**********                        2    4  BRCDB           M6                     S01117 CGL120
0140 I**********                        5    7  CCYB            M5                            CGL120
0141 I**********                              8  110ACODB   M4                                CGL029
     I**********                        8   11 0ACODQQ                                 CGL029 CGL120
0142 I**********                       12   12 0RINDB           M3                            CGL120
0143 I**********                             13  180CNUMB   M2                                CSD027
0143 I**********                       13   18  CNUMB           M2                     CSD027 CGL120
0144 I**********                       19   20 0ACSQB           M1                            CGL120
0145 I**********                   P   21   28 0CRBL                  5342                    CGL120
0146 I**********                   P   29   36 0DRBL                54  44                    CGL120
     I**********                       41   50 0ACODB           M4                     CGL029 CGL120
     IGLDLYPPD  NS  01    1 CD                                                                CGL120
     I                                  1    1  RECI                                          CGL120
     I                                  2    4  BRCDB         L7                              CGL120
     I                                  5    7  CCYB          L6                              CGL120
     I                                  8   11 0ACODQQ                                        CGL120
     I                                 12   12 0RINDB         L4                              CGL120
     I                                 13   18  CNUMB         L3                              CGL120
     I                                 19   20 0ACSQB         L2                              CGL120
     I                             P   21   28 0CRBL                  5342                    CGL120
     I                             P   29   36 0DRBL                    44                    CGL120
     I                                 41   50 0ACODB         L5                              CGL120
     I                                 51   54  PRFCB         L1                              CGL120
     I          NS  03    1 CX                                                                CGL120
     I                                  1    1  RECI                                          CGL120
     I                                  2    4  BRCDB         L7                              CGL120
     I                                  5    7  CCYB          L6                              CGL120
     I                                  8   11 0ACODQQ                                        CGL120
     I                                 12   12 0RINDB         L4                              CGL120
     I                                 13   18  CNUMB         L3                              CGL120
     I                                 19   20 0ACSQB         L2                              CGL120
     I                             P   21   28 0CRBL                  5342                    CGL120
     I                             P   29   36 0DRBL                    44                    CGL120
     I                                 41   50 0ACODB         L5                              CGL120
     I                                 51   54  PRFCB         L1                              CGL120
0155 I**
0156 I*    CATCHALL FOR DELETED RECORDS
0157 I**
0158 I          NS
0159 I**
0160 I/SPACE 2
0161 I*    ACCOUNT POSTING
0162 I**
0163 IACJND     NS  04    1 CP  106 C0
     I         OR   05    1 CP  106 C1
     I                                  1    1  RECI
     I***********                             2   70CNUMJ L2M2            120830
     I***********                             8  10 CCYJ  L5M5            120830
     I***********                            11  140ACODJ L4M4            120830
     I***********                            15  160ACSQJ L1M1            120830
     I**********                              2   70CNUMJ L3M2                         120830 CSD027
     I**********                        2    7  CNUMJ         L3M2                     CSD027 CGL120
     I                                  2    7  CNUMJ                                         CGL120
     I**********                        8   10  CCYJ          L6M5                     120830 CGL120
     I                                  8   10  CCYJ                                          CGL120
     I**********                             11  140ACODJ L5M4                         120830 CGL029
     I                                 11   14 0ACODQQ                                        CGL029
     I**********                       15   16 0ACSQJ         L2M1                     120830 CGL120
     I                                 15   16 0ACSQJ                                         CGL120
     I                                 23   32  ACNO
     I                             P   33   35 0PSTD
     I                             P   36   38 0VALD
     I******                                 39  43 TRAT                  S01099
     I                                 39   43 0TRAT                22          S01099
     I                                 44   73  PNAR
     I                             P   74   80 0PSTA
     I                                 81   81 0DRCR                353536
     I**********                             82  870ASOC            37                        CSD027
     I                                 82   87  ASOC                    37                    CSD027
     I                                 88   95  CHQN
     I                                 96  102  SPOS
     I*                                                                   S01408
     I/COPY WNCPYSRC,GL0340IIP2                                           S01408
     I*                                                                   S01408
     I***********                           103 1050BRCDJ L6M6            S01117
     I***********                           103 1050BRCDJ L6M6      S01117120830
     I***********                           106 1060RINDJ L3M3            120830
     I**********                      103  105  BRCDJ         L7M6                     120830 CGL120
     I**********                      106  106 0RINDJ         L4M3                     120830 CGL120
     I                                103  105  BRCDJ                                         CGL120
     I                                106  106 0RINDJ                                         CGL120
     I                             P  107  108 0REJC
     I                                109  111  DPMT
     I/COPY WNCPYSRC,GL0340I001
     I                                124  124  ATYP
     I                                128  128  CUOR
     I                                129  129  GETP
     I                                130  130 0ACUM
     I**********                      131  134  PRFCJ         L1                       120830 CGL120
     I**********                      590  599 0ACODJ         L5M4                     CGL029 CGL120
     I                                131  134  PRFCJ                                         CGL120
     I                                590  599 0ACODJ                                         CGL120
0194 I**
0195 I*    CATCHALL FOR DELETED RECORDS
0196 I**
0237 I          NS
0203 I**
     I*                                                                   S01408
     I/COPY WNCPYSRC,GL0340IIP1                                           S01408
      ** Entire contents of array ARL1 (used to find nbr of elements)                         CGL030
     I/COPY WNCPYSRC,GL0340IIPG                                           S01408
     I*                                                                   S01408
0338 I/EJECT
     C**                                                                  S01290
     C     *ENTRY        PLIST                                                                S01290
     C                   PARM                    RTYP              1                          S01290
     C                   PARM                    XPOST             1                         BUG9203
     C                   MOVE      XPOST         Z                 1 0                       BUG9203
                                                                                              CGL120
     C     KLSACBL       KLIST                                                                CGL120
     C                   KFLD                    S_BRCA                                       CGL120
     C                   KFLD                    S_CCY                                        CGL120
     C                   KFLD                    S_ACOD                                       CGL120
     C                   KFLD                    S_RIND                                       CGL120
     C                   KFLD                    S_CNUM                                       CGL120
     C                   KFLD                    S_ACSQ                                       CGL120
     C/COPY WNCPYSRC,GL0340C005
      *                                                                                    AR1004821
      ** First Cycle Processing                                                            AR1004821
      *                                                                                    AR1004821
     C   40              GOTO      T1                                                      AR1004821
      ** Access CAR details file to determine if feature is installed                         CGL050
      *                                                                                       CGL050
     C                   CALL      'AOSARDR0'                                                 CGL050
     C                   PARM      *BLANKS       @RTCD             7                          CGL050
     C                   PARM      '*VERIFY'     @OPTN             7                          CGL050
     C                   PARM      'CGL050'      @SARD             6                          CGL050
     C                   PARM      *BLANKS       DSFDY                                        CGL050
      *                                                                                       CGL050
     C     @RTCD         IFEQ      *BLANKS                                                    CGL050
     C                   MOVEL     'Y'           CGL050            1                          CGL050
     C                   ELSE                                                                 CGL050
     C                   MOVEL     'N'           CGL050                                       CGL050
     C                   ENDIF                                                                CGL050
      *                                                                                       CGL050
     C**                                                                  S01117
0339 C***04******                                                         S01117
0340 C*R*05******          SETOF                     38    POSTING REC.   S01117
0341 C*****FIRST*CYCLE*PROCESSING**************************************                    AR1004821
0342 C*****************************************************************                    AR1004821
0343 C***40*****           GOTO T1                                                         AR1004821
     C                   MOVEA     CPY@          BIS@             80
      *                                                                   CSD005
      * Obtain switchable feature CSD005 status.                          CSD005
      *                                                                   CSD005
     C                   CALL      'AOSARDR0'                                                 CSD005
     C                   PARM      *BLANKS       @RTCD             7                          CSD005
     C                   PARM      '*VERIFY'     @OPTN             7                          CSD005
     C                   PARM      'CSD005'      @SARD             6                          CSD005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD005
      *                                                                   CSD005
     C                   SELECT                                                               CSD005
     C     @RTCD         WHENEQ    *BLANK                                                     CSD005
     C                   MOVE      *ON           *IN73                                        CSD005
     C     @RTCD         WHENEQ    '*NRF'                                                     CSD005
     C                   MOVE      *OFF          *IN73                                        CSD005
     C                   OTHER                                                                CSD005
     C     *LOCK         IN        LDA                                                        CSD005
     C                   MOVEL     'SCSARDPD'    DBFILE                          ************* CSD00
     C                   MOVEL     '005'         DBASE                           *DBERROR 005* CSD00
     C                   MOVEL     @OPTN         DBKEY                           ************* CSD00
     C                   SETON                                        U7U8LR                  CSD005
     C                   OUT       LDA                                                        CSD005
     C                   EXSR      *PSSR                                                      CSD005
     C                   ENDSL                                                                CSD005
      *                                                                   CSD005
     C*                                                                   S01290
     C*  CHECK REPORT TYPE PARAMETER FOR SUMMARY REPORT                   S01290
     C*                                                                   S01290
     C     RTYP          IFEQ      'S'                                                        S01290
     C                   SETON                                        15                      S01290
     C                   END                                                                  S01290
     C*                                                                   S01290
     C     *DTAARA       DEFINE                  LDA                                          S01194
0344 C                   SETON                                        384041
0345 C*
0346 C***********          EXSR ZSYSTM                                    S01194
     C                   MOVEL     'GL0340'      DBPGM            10                          S01194
     C     *DTAARA       DEFINE    RUNDAT        RUNDT                                        S01194
     C                   IN        RUNDT                                                      S01194
0183 C**   CHECK SYSTEM DATE FORMAT, DDMMYY OR MMDDYY.                    S01194
     C     DATF          IFEQ      'M'                                                        S01194
     C                   SETON                                        98                      S01194
     C                   ELSE                                                                 S01194
     C                   SETOFF                                       98                      S01194
     C                   END                                                                  S01194
     C*                                                                   S01194
     C**   CHECK MULTIBRANCHING INDICATOR AND TYPE OF REPORT REQUESTED    S01194
     C                   SETOFF                                       575859                  S01194
     C*                                                                   S01194
     C     MBIN          IFEQ      'Y'                                          B1             S0119
     C                   SETON                                        59        1             S01194
     C                   SETON                                        57        2             S01194
     C                   END                                                    E1             S0119
     C*                                                                   S01194
     C**  OBTAIN BANK TITLE VIA BANK DETAILS                              S01194
     C                   CALL      'AOBANKR0'                                                 S01194
     C                   PARM      '*MSG   '     @RTCD             7                          S01194
     C                   PARM      '*FIRST '     @OPTN             7                          S01194
     C     SDBANK        PARM      SDBANK        DSFDY                                        S01194
     C     @RTCD         IFNE      *BLANK                                                     S01194
     C                   MOVEL     'SDBANKPD'    DBFILE                           *************S0119
     C                   MOVEL     '001'         DBASE                            * DBERR 001 *S0119
     C                   MOVEL     @OPTN         DBOPTN            7              *************S0119
     C                   MOVEL     @OPTN         DBKEY            29                          S01194
     C                   EXSR      *PSSR                                                      S01194
     C                   SETON                                        63LR                    S01194
     C                   GOTO      ENDF                                                       S01194
     C                   END                                                                  S01194
0347 C*                                                                   S01194
     C** GET MIDAS MODULE FLAGS                                           S01194
     C                   CALL      'AOMMODR0'                                                 S01194
     C                   PARM      '*MSG   '     @RTCD             7                          S01194
     C                   PARM      '*FIRST '     @OPTN             7                          S01194
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        S01194
     C     @RTCD         IFNE      *BLANKS                                                    S01194
     C                   MOVEL     'SDMMODPD'    DBFILE                           *************S0119
     C                   MOVEL     '002'         DBASE                            * DBERR 002 *S0119
     C                   MOVEL     @OPTN         DBOPTN            7              *************S0119
     C                   MOVEL     @OPTN         DBKEY            29                          S01194
     C                   EXSR      *PSSR                                                      S01194
     C                   SETON                                        63LR                    S01194
     C                   GOTO      ENDF                                                       S01194
     C                   END                                                                  S01194
0347 C*                                                                   S01194
     C* IF FUNDS TRANSFER IS INSTALLED SETON 23                           S03220
     C***********          TESTB'4'       MODI4          23        S03220 S01194
     C     BGFDTR        IFEQ      'Y'                                                        S01194
     C                   SETON                                        23                      S01194
     C                   ELSE                                                                 S01194
     C                   SETOFF                                       23                      S01194
     C                   END                                                                  S01194
     C*                                                                   120830
     C** Check if Analytical Accounting is installed...                   120830
     C*                                                                   120830
     C     BGN0ST        IFEQ      'Y'                                                        120830
     C                   SETON                                        27                      120830
     C*                                                                   127973
     C** Access PCA ICD Details.                                          127973
     C                   CALL      'AOPCACR0'                                                 127973
     C                   PARM      '*MSG   '     @RTCD                                        127973
     C                   PARM      '*FIRST '     @OPTN                                        127973
     C     SDPCAC        PARM      SDPCAC        DSFDY                                        127973
     C*                                                                   127973
     C     @RTCD         IFNE      *BLANKS                                                    127973
     C                   MOVEL     'SDPCACPD'    DBFILE                         *************  12797
     C                   MOVEL     '007'         DBASE                          * DBERRR007 *  12797
     C                   MOVEL     '*FIRST'      DBOPTN                         *************  12797
     C                   MOVEL     '*FIRST'      DBKEY                                        127973
     C                   EXSR      *PSSR                                                      127973
     C                   SETON                                        63LR                    127973
     C                   GOTO      ENDF                                                       127973
     C                   ENDIF                                                                127973
     C*                                                                   127973
     C                   ELSE                                                                 120830
     C                   SETOFF                                       27                      120830
     C                   ENDIF                                                                120830
     C*                                                                   S01408
      *                                                                                       CGL030
      ** Count nbr of elements in ARLT                                                        CGL030
      *                                                                                       CGL030
     C                   MOVEL     *ALL'?'       WWARLT                                       CGL030
     C                   MOVEA     ARLT          WWARLT                                       CGL030
     C                   Z-ADD     1             WNARLT            4 0                        CGL030
     C     '????????'    SCAN      WWARLT:1      WNARLT                                       CGL030
     C     WNARLT        SUB       1             WNARLT                                       CGL030
     C     WNARLT        DIV       29            WNARLT                                       CGL030
      *                                                                                       CGL030
      ** Count nbr of elements in ARL1                                                        CGL030
      *                                                                                       CGL030
     C                   MOVEL     *ALL'?'       WWARL1                                       CGL030
     C                   MOVEA     ARL1          WWARL1                                       CGL030
     C                   Z-ADD     1             WNARL1            4 0                        CGL030
     C     '????????'    SCAN      WWARL1:1      WNARL1                                       CGL030
     C     WNARL1        SUB       1             WNARL1                                       CGL030
     C     WNARL1        DIV       29            WNARL1                                       CGL030
      *                                                                                       CGL030
      ** Check for feature                                                                    CGL030
      *                                                                                       CGL030
     C                   CALL      'AOSARDR0'                                                 CGL030
     C                   PARM      *BLANKS       @RTCD                                        CGL030
     C                   PARM      '*VERIFY'     @OPTN                                        CGL030
     C                   PARM      'CGL030'      @KEY              6                          CGL030
     C                   PARM                    DSFDY                                        CGL030
      *                                                                                       CGL030
     C     @RTCD         IFEQ      *BLANKS                                                    CGL030
     C                   MOVE      'Y'           CGL030            1                          CGL030
      *                                                                                       CGL030
      ** Initial new arrays and define arrray index                                           CGL030
      *                                                                                       CGL030
     C                   MOVEA     *ZEROS        ARN1                                         CGL030
     C                   MOVEA     *ZEROS        BRN1                                         CGL030
     C                   MOVEA     *ZEROS        AR1I                                         CGL030
     C                   MOVEA     *ZEROS        BR1I                                         CGL030
     C                   MOVEA     *ZEROS        AR1D                                         CGL030
     C                   MOVEA     *ZEROS        BR1D                                         CGL030
      *                                                                                       CGL030
     C                   END                                                                  CGL030
      *                                                                                       CGL030
     C/COPY WNCPYSRC,GL0340CCP1                                           S01408
     C*                                                                   S01408
0347 C*
0348 C***********          MOVE 'A'       CLTKEY  7                       S01194
0349 C*
     C                   MOVE      *BLANKS       WPRFC             4                          120830
     C                   Z-ADD     0             TPRFC            15 0                        120830
0350 C                   Z-ADD     0             TACOD            15 0
0351 C                   Z-ADD     0             TCCY             15 0
0352 C                   Z-ADD     0             TACSQ            15 0
0353 C***********          Z-ADD0         TPSTA  150                      S01290
     C                   Z-ADD     0             TPSTDR           15 0                        S01290
     C                   Z-ADD     0             TPSTCR           15 0                        S01290
0354 C                   Z-ADD     0             TLDBE            15 0
0355 C*
0356 C                   Z-ADD     0             TNOP              6 0
     C*                                                                   S01290
     C                   Z-ADD     0             PSTACR           15 0                        S01290
     C                   Z-ADD     0             PSTADR           15 0                        S01290
0357 C*
0358 C***********          Z-ADD30        TTYPA                           S01194
0359 C***********          Z-ADD20        TTYPC                           S01194
0360 C***********          Z-ADD1         RNUMA                           S01194
0361 C***********          Z-ADD1         RNUMC                           S01194
0362 C***********          MOVE '      '  BLNKA                           S01194
0363 C***********          MOVE '      '  BLNKC                           S01194
0364 C*
0365 C                   Z-ADD     0             ARNP
0366 C                   Z-ADD     0             ARTI
0367 C                   Z-ADD     0             ARTD
0368 C*
0369 C                   Z-ADD     0             BRNP
0370 C                   Z-ADD     0             BRTI
0371 C                   Z-ADD     0             BRTD
0372 C*
0373 C                   Z-ADD     1             Y                 2 0
0374 C                   Z-ADD     1             X                 2 0
0375 C                   MOVEL     '*ERROR*'     ERR              30
0343 C***04*****                                                                              CGL120
0343 C***OR*05**            GOTO      T1                                                      CGL120
     C***********          Z-ADD*ZERO     BRCDJ                           S01117
     C                   MOVE      *BLANKS       BRCDJ                                        S01117
     C                   Z-ADD     *ZERO         ACODJ
     C                   Z-ADD     *ZERO         RINDJ
     C**********           Z-ADD*ZERO     CNUMJ                                               CSD027
     C                   MOVE      *BLANKS       CNUMJ                                        CSD027
     C                   Z-ADD     *ZERO         ACSQJ
0376 C*
0377 C/SPACE 2
0378 C***  SETOF OUTPUT INDS. & BYPASS CALCS FOR NON-VALID RECORDS
0379 C*
0380 C     T1            TAG                                                    ** T1 TAG **
     C/COPY WNCPYSRC,GL0340C004
0381 C***L3******          SETOF                     66                   120830
     C   L4              SETOFF                                       66                      120830
     C   L1              SETOFF                                       11                      CGL120
     C   L2              SETOFF                                       12                      CGL120
     C   L4              SETOFF                                       13                      CGL120
     C   L5              SETOFF                                       14                      CGL120
     C   L7              SETON                                        38                      CGL120
0382 C*
0383 C**********         SETOFF                                       808182                  CGL120
0384 C**********         SETOFF                                       838485                  CGL120
0385 C**********         SETOFF                                       868788                  CGL120
0386 C**********         SETOFF                                       897879                  CGL120
     C/COPY WNCPYSRC,GL0340C001
     C*****CGL050        IFEQ      'Y'                                               CGL050 MD024553
      *****************************************************************              CGL050 MD024553
     C******IN05         IFEQ      '1'                                               CGL050 MD024553
      *****************************************************************              CGL050 MD024553
      *****BYPASS*IF*POSTING*IND*ON************************************              CGL050 MD024553
     C**********         MOVE      '0'           *IN39                               CGL050 MD024553
     C**********         TESTB     '4'           CUOR                     39         CGL050 MD024553
     C******IN39         IFEQ      '0'                                               CGL050 MD024553
      *****************************************************************              CGL050 MD024553
     C**********         MOVE      '0'           *IN05                               CGL050 MD024553
     C**********         MOVE      '1'           *IN04                               CGL050 MD024553
      *****************************************************************              CGL050 MD024553
     C**********         ELSE                                                        CGL050 MD024553
     C**********         GOTO      END                                               CGL050 MD024553
     C**********         ENDIF                                                       CGL050 MD024553
      *****************************************************************              CGL050 MD024553
     C**********         ENDIF                                                       CGL050 MD024553
      *****************************************************************              CGL050 MD024553
     C******IN04         IFEQ      '1'                                               CGL050 MD024553
     C**********         MOVE      '1'           *IN66                               CGL050 MD024553
     C**********         ENDIF                                                       CGL050 MD024553
      *****************************************************************              CGL050 MD024553
     C**********         ENDIF                                                       CGL050 MD024553
      *****************************************************************              CGL050 MD024553
0097 C**                                                                  S01117
     C************INL6     IFEQ '1'                        IF 1    S01117 120830
     C     *INL7         IFEQ      '1'                                          IF 1           12083
      *                                                                   S01117
      ** CONSOLIDATED REPORT OPENS OUTPUT FILE ONCE AND ONLY ONCE         S01117
     C     *IN58         IFEQ      '0'                                          IF 2           S0111
     C     *IN25         OREQ      '0'                                                        S01117
      *                                                                   S01117
     C                   CLOSE     GL0340P1                                                   S01117
     C                   SETON                                        25        ALLOW OUTPUT   S0111
     C*                                                                   S01194
      ** GET BRANCH NAME WHEN MULTIBRANCHING INDICATOR IS Y               S01194
     C     *IN59         IFEQ      '1'                                                        S01194
     C**********           CALL 'AOBRCHR0'                                S01194              CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*MSG   '     @RTCD             7                          S01194
     C                   PARM      '*KEY   '     @OPTN             7                          S01194
     C**********         PARM      BRCDJ         @DSNB             3                   S01194 CGL120
     C                   PARM      BRCDB         @DSNB             3                          CGL120
     C********** SDBRCH    PARM SDBRCH    DSFDY                           S01194              CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS                                                    S01194
     C                   MOVEL     'SDBRCHPD'    DBFILE                           *************S0119
     C                   MOVEL     '003'         DBASE                            * DBERR 003 *S0119
     C                   MOVEL     @OPTN         DBOPTN            7              *************S0119
     C**********         MOVEL     BRCDJ         DBKEY            29                   S01194 CGL120
     C                   MOVEL     BRCDB         DBKEY            29                          CGL120
     C                   EXSR      *PSSR                                                      S01194
     C                   SETON                                        63LR                    S01194
     C                   SETOFF                                       25                      S01194
     C                   GOTO      END                                                        S01194
     C                   END                                                                  S01194
     C                   END                                                                  S01194
      *                                                                   S01117
     C**********         MOVE      BRCDJ         SENTY             3                   S01117 CGL120
     C                   MOVE      BRCDB         SENTY             3                          CGL120
      *                                                                   S01117
     C                   OPEN      GL0340P1                                                   S01117
     C                   Z-ADD     0             PAGE                                         S01117
      *                                                                   S01117
      ** ENSURE REPORT SPOOL FILE RECORDED BY RCF                         S01117
     C                   Z-ADD     SFNUM         SFNUM1            6 0                        S01117
     C                   OUT       LDA                                                        S01194
     C                   CALL      'ZSFILE'                                                   S01117
     C                   PARM                    SEQ               5                          S01117
     C                   PARM                    SENTY                                        S01117
     C                   PARM                    SFILE                                        S01117
     C                   PARM                    SFNUM1                                       S01117
     C                   PARM                    ZSERR             1                          S01117
     C     *LOCK         IN        LDA                                                        S01194
     C*                                                                   S01117
     C     ZSERR         IFEQ      'Y'                                                        S01117
     C*                                                                   S01117
     C* ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAMME       S01117
     C*                                                                   S01117
     C                   SETON                                        U7U8LR                  S01117
     C                   RETURN                                                               S01117
     C                   END                                                                  S01117
      *                                                                   S01117
     C                   END                                                    FI 2           S0111
     C                   END                                                    FI 1           S0111
      *                                                                   S01117
     C******IN04         IFEQ      '1'                                                 S01117 CGL120
     C******IN05         OREQ      '1'                                                 S01117 CGL120
     C**********         SETOFF                                       38               S01117 CGL120
     C**********         END                                                           S01117 CGL120
      **********                                                                       S01117 CGL120
0387 C**N05*****         GOTO      REST                                                       CGL120
0388 C**********                                                                              CGL120
0389 C*****BYPASS*IF*POSTING*IND*ON*                                                          CGL120
0390 C**********         TESTB     '4'           CUOR                     39                  CGL120
0391 C***39*****         GOTO      END                                                        CGL120
0392 C**********         SETON                                        66                      CGL120
     C/COPY WNCPYSRC,GL0340C006
0393 C     REST          TAG
     C   01
0394 CAN 53              Z-ADD     CRBL          LDBE             15 0
     C   01
0395 CANN53              Z-ADD     DRBL          LDBE
0396 C***02*****         Z-ADD     0             LDBL             15 0                        CGL120
     C***02*****                                                                              CGL120
0397 C***AN*53LDBL          ADD       CRBL          LDBL                                      CGL120
     C***02*****                                                                              CGL120
0398 C***AN*54LDBL          ADD       DRBL          LDBL                                      CGL120
     C   03              Z-ADD     *ZERO         LDBE                                         CGL120
     C   03                                                                                   CGL120
     CAN L5              Z-ADD     *ZERO         LDBL             15 0                        CGL120
     C   01                                                                                   CGL120
     CAN L5              Z-ADD     *ZERO         LDBL             15 0                        CGL120
      *                                                                                       CGL120
      ** Obtain O/B at Account Level                                                          CGL120
      *                                                                                       CGL120
     C                   IF        (*IN03 = *ON OR *IN01 = *ON) AND *INL5 = *ON               CGL120
     C                   EVAL      S_BRCA = BRCDB                                             CGL120
     C                   EVAL      S_CCY  = CCYB                                              CGL120
     C                   EVAL      S_ACOD = ACODB                                             CGL120
     C                   EVAL      S_RIND = *ZERO                                             CGL120
     C                   EVAL      S_CNUM = '000000'                                          CGL120
     C                   EVAL      S_ACSQ = *ZERO                                             CGL120
     C     KLSACBL       CHAIN(E)  SACBL                                                      CGL120
      *                                                                                       CGL120
     C                   IF        %FOUND                                                     CGL120
     C                   EVAL      LDBL = S_CRBL + S_DRBL                                     CGL120
     C                   ENDIF                                                                CGL120
     C                   ENDIF                                                                CGL120
0399 C*
     C**N04*****                                                                              CGL120
0400 C***ANN05**            GOTO      END                                                     CGL120
     C/COPY WNCPYSRC,GL0340C007
0401 C*
0402 C***  PRINT HEADING
0403 C*
0404 C***41*****         SETON                                        8078                    CGL120
0405 C**********         EXCEPT                                                               CGL120
0406 C**********         SETOFF                                       8041                    CGL120
      *                                                                                       CGL120
      *** Process Postings for Account (if any)                                               CGL120
      *                                                                                       CGL120
     C                   MOVE      BRCDB         BRCDK                                        CGL120
     C                   MOVE      CCYB          CCYK                                         CGL120
     C                   MOVE      ACODB         ACODK                                        CGL120
     C                   MOVE      RINDB         RINDK                                        CGL120
     C                   MOVE      CNUMB         CNUMK                                        CGL120
     C                   MOVE      ACSQB         ACSQK                                        CGL120
     C                   MOVE      PRFCB         PRFCK                                        CGL120
     C     AJNKY         SETLL     ACJND                                                      CGL120
      *                                                                                       CGL120
     C                   SETOFF                                       10                      CGL120
     C                   SETOFF                                       0405                    CGL120
     C     AJNKY         READE     ACJND                                  10                  CGL120
      *                                                                                       CGL120
     C     *IN10         DOWNE     *ON                                                        CGL120
      *                                                                                       CGL120
     C  N04                                                                                   CGL120
     CANN05              GOTO      NXTPST                                                     CGL120
      *                                                                                       CGL120
     C     CGL050        IFEQ      'Y'                                                      MD024553
                                                                                            MD024553
     C     *IN05         IFEQ      '1'                                                      MD024553
                                                                                            MD024553
      ***  BYPASS IF POSTING IND ON                                                         MD024553
                                                                                            MD024553
     C                   MOVE      '0'           *IN39                                      MD024553
     C                   TESTB     '4'           CUOR                     39                MD024553
     C     *IN39         IFEQ      '0'                                                      MD024553
                                                                                            MD024553
     C                   MOVE      '0'           *IN05                                      MD024553
     C                   MOVE      '1'           *IN04                                      MD024553
                                                                                            MD024553
     C                   ELSE                                                               MD024553
     C                   GOTO      END                                                      MD024553
     C                   ENDIF                                                              MD024553
                                                                                            MD024553
     C                   ENDIF                                                              MD024553
      *                                                                                     MD024553
     C     *IN04         IFEQ      '1'                                                      MD024553
     C                   MOVE      '1'           *IN66                                      MD024553
     C                   ENDIF                                                              MD024553
      *                                                                                     MD024553
     C                   ENDIF                                                              MD024553
      *                                                                                     MD024553
     C                   SETOFF                                       808182                  CGL120
     C                   SETOFF                                       838485                  CGL120
     C                   SETOFF                                       868788                  CGL120
     C                   SETOFF                                       897879                  CGL120
      *                                                                                       CGL120
     C   41              SETON                                        8078                    CGL120
     C                   EXCEPT                                                               CGL120
     C*********          SETOFF                                       8041             CGL120 CGL120
     C                   SETOFF                                       804178                  CGL120
      *                                                                                       CGL120
     C     *IN04         IFEQ      '1'                                                        CGL120
     C     *IN05         OREQ      '1'                                                        CGL120
     C                   SETOFF                                       38                      CGL120
     C                   SETON                                        111213                  CGL120
     C                   SETON                                        14                      CGL120
     C                   END                                                                  CGL120
      *                                                                                       CGL120
      ** Bypass if Posting Ind is on                                                          CGL120
      *                                                                                       CGL120
     C     *IN05         IFEQ      *ON                                                        CGL120
     C                   TESTB     '4'           CUOR                     39                  CGL120
     C***39*****           GOTO END                                                           CGL120
     C   39              GOTO      ENDPST                                                     CGL120
     C                   SETON                                        66                      CGL120
     C                   ENDIF                                                                CGL120
0407 C*
0408 C/SPACE 2
0409 C***  CCY CHANGE - FIND NO. OF DECIMAL PLACES
0410 C*
0411 C   49              GOTO      T2
0412 C                   SETON                                        49
0413 C*
0414 C***********          MOVE CCYJ      CCYK                            S01194
0415 C***********CCYKY     CHAINTABLE                63                   S01194
     C**********         CALL      'AOCURRR0'                                          S01194 CGL120
     C                   CALLB     'AOCURRR0'                                                 CGL120
     C                   PARM      '*MSG   '     @RTCD             7                          S01194
     C                   PARM      '*KEY   '     @OPTN             7                          S01194
     C**********         PARM      CCYJ          @AJCD             3                   S01194 CGL120
     C                   PARM      CCYB          @AJCD             3                          CGL120
     C     SDCURR        PARM      SDCURR        DSSDY                                        S01194
     C     @RTCD         IFNE      *BLANKS                                                    S01194
     C                   MOVEL     'SDCURRPD'    DBFILE                           *************S0119
     C                   MOVEL     '004'         DBASE                            * DBERR 004 *S0119
     C                   MOVEL     @OPTN         DBOPTN            7              *************S0119
     C**********         MOVEL     CCYJ          DBKEY            29                   S01194 CGL120
     C                   MOVEL     CCYB          DBKEY            29                          CGL120
     C                   EXSR      *PSSR                                                      S01194
     C                   SETON                                        63LR                    S01194
     C                   SETOFF                                       25                      S01194
     C                   EXCEPT    DBERR                                                      S01194
     C                   GOTO      END                                                        S01194
     C                   END                                                                  S01194
0416 C*
0417 C***********CDPX      COMP 1                      3031               S01194
0418 C***********CDPX      COMP 2                    33  32               S01194
     C*                                                                   S01194
     C** COMPARE CCY DECIMAL POINT AND SET INDICATOR.                     S01194
     C/COPY WNCPYSRC,GL0340C010
     C     A6NBDP        COMP      1                                    3031                  S01194
     C     A6NBDP        COMP      2                                  33  32                  S01194
0419 C*
     C  N30
     CANN31
0420 CANN32
0421 CANN33              SETON                                        30
0422 C*
0423 C/SPACE 2
0424 C***
0425 C*
0426 C     T2            TAG                                                    ** T2 TAG **
0427 C*
0428 C   61              GOTO      T3
0429 C                   SETON                                        61
0430 C*
0431 C***  PRINT A/C CODE O/B
0432 C*
0433 C********** ACBLT     COMP ACJK1                6262                                     CGL029
     C*****BRCDJ         COMP      BRCDB                              6262             CGL029 CGL120
     C**N62CCYJ*         COMP      CCYB                               6262             CGL029 CGL120
     C**N62ACODJ         COMP      ACODB                              6262             CGL029 CGL120
0434 C***62*****         Z-ADD     0             LDBL                                         CGL120
0435 C     TACOD         ADD       LDBL          TACOD
0436 C*
0437 C***********          Z-ADDACODJ     ACDK                            S01194
0438 C***********ACDKY     CHAINTABLE                63                   S01194
0439 C**N09******                                                         S01194
0440 C*R*63******          MOVELERR       ACKN                            S01194
0436 C*                                                                   S01194
     C**********           MOVE ACODJ     @AFNB   4                                    S01194 CGL029
     C                   MOVE      ACODJ         @AFNB            10                          CGL029
     C**********         CALL      'AOACODR0'                                          S01194 CGL120
     C                   CALLB     'AOACODR0'                                                 CGL120
     C                   PARM      *BLANKS       @RTCD             7                          S01194
     C                   PARM      '*KEY   '     @OPTN             7                          S01194
     C**********           PARM           @AFNB   4                                    S01194 CGL029
     C********** SDACOD    PARM SDACOD    DSFDY                                        S01194 CGL029
     C                   PARM                    @AFNB                                        CGL029
     C     SDACOD        PARM      SDACOD        DSSDY                                        CGL029
     C*                                                                   S01194
     C** IF ERROR, MOVE ERR TO ACCOUNT CODE NAME                          S01194
     C     @RTCD         IFNE      *BLANKS                                                    S01194
     C                   MOVEL     ERR           A5ACCN                                       S01194
     C                   MOVEL     ERR           A5NARR                                       CSD005
     C                   END                                                                  S01194
0441 C*
0442 C                   SETON                                        81
0443 C**
0444 C**   SAVE L BAL FOR RET AC OP BAL LINE
0445 C                   Z-ADD     LDBL          REBAL            15 0
0446 C/SPACE 2
0447 C***  CUSTOMER NAME
0448 C*
0449 C     T3            TAG                                                    ** T3 TAG **
0450 C*
     C   65
0451 CAN 05              GOTO      T5
0452 C   65              GOTO      T4
0453 C                   SETON                                        6567
0454 C*
0455 C***  PRINT CUSTOMER NAME & A/C SEQ NO O/B
0456 C*
0457 C***********          MOVELCNUMJ     CLTKEY                          S01194
0458 C***********CLTKEY    CHAINCLINT                63                   S01194
0459 C**N07******                                                         S01194
0460 C*R*63******          MOVELERR       CRNM                            S01194
0456 C*                                                                   S01194
     C                   MOVE      *BLANKS       @KEY1            10                          S01194
     C                   MOVEL     CNUMJ         @KEY1                                        S01194
      * If the CUST we are looking for is same as the one just processed                      CSC042
      * then reuse the details rather than call AOCUSTR yet again                             CSC042
     C     *LIKE         DEFINE    BBCUST        ##CUS6                                       CSC042
     C     *LIKE         DEFINE    BBCUST        ##LCUS                                       CSC042
     C     *LIKE         DEFINE    BBCRNM        ##LCCR                                       CSC042
     C     *LIKE         DEFINE    BBDTDL        ##LDTD                                       CSC042
     C                   MOVEL     @KEY1         ##CUS6                                       CSC042
     C     ##CUS6        IFEQ      ##LCUS                                                     CSC042
     C                   MOVEL     ##LCCR        BBCRNM                                       CSC042
     C                   MOVEL     ##LDTD        BBDTDL                                       CSC042
     C                   MOVEL     *BLANKS       @RTCD                                        CSC042
     C                   ELSE                                                                 CSC042
     C**********         CALL      'AOCUSTR0'                                          S01194 CGL120
     C                   CALLB     'AOCUSTR0'                                                 CGL120
     C                   PARM      *BLANKS       @RTCD             7                          S01194
     C                   PARM      '*KEY   '     @OPTN             7                          S01194
     C                   PARM                    @KEY1            10                          S01194
     C                   PARM                    @KYST             7                          S01194
     C     SDCUST        PARM      SDCUST        DSSDY                                        S01194
     C     @RTCD         IFEQ      *BLANKS                                                    CSC042
     C                   MOVEL     BBCUST        ##LCUS                                       CSC042
     C                   MOVEL     BBCRNM        ##LCCR                                       CSC042
     C                   MOVEL     BBDTDL        ##LDTD                                       CSC042
     C                   END                                                                  CSC042
     C                   END                                                                  CSC042
     C*                                                                   S01194
     C** IF ERROR OR DELETED, MOVE ERR TO CUSTOMER REPORT NAME            S01194
     C*                                                                   S01194
     C     @RTCD         IFNE      *BLANKS                                                    S01194
     C     BBDTDL        ORNE      *ZEROS                                                     S01194
     C                   MOVEL     ERR           BBCRNM                                       S01194
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0340CP13                                           S01408
     C*                                                                   S01408
     C                   END                                                                  S01194
0456 C*                                                                   S01194
0461 C*
0462 C     ACBK          COMP      ACJK2                              6262
0463 C   62              Z-ADD     0             LDBE
0464 C*
0465 C   04TACSQ         ADD       LDBE          TACSQ
0466 C   05TLDBE         ADD       LDBE          TLDBE
0467 C*
0468 C   04              SETON                                        82
0469 C*
0470 C                   GOTO      T5
0471 C**
0472 C/SPACE 2
0473 C***  A/C SEQ NO.
0474 C*
0475 C     T4            TAG                                                    ** T4 TAG **
0476 C*
0477 C   67              GOTO      T5
0478 C                   SETON                                        67
0479 C*
0480 C***  PRINT A/C SEQ O/B
0481 C*
0482 C     ACBK          COMP      ACJK2                              6262
0483 C   62              Z-ADD     0             LDBE
0484 C*
0485 C   04TACSQ         ADD       LDBE          TACSQ
0486 C   05TLDBE         ADD       LDBE          TLDBE
0487 C*
0488 C   04              SETON                                        83
0489 C*
0490 C**
0491 C/SPACE 2
0492 C**
0493 C***  KEEP TOTALS
0494 C**
0495 C***
0496 C     T5            TAG                                                    ** T5 TAG **
0497 C*
0498 C                   Z-ADD     PSTA          PSTAS            13 0
0499 C   35              Z-SUB     PSTA          PSTAS
     C*                                                                   S01290
     C*  IF NON-RETAIL SUMMARY REPORT, SEPARATE DEBIT AND CREDIT TOTALS   S01290
     C*                                                                   S01290
     C     *IN15         IFEQ      '1'                                                        S01290
     C     *IN04         ANDEQ     '1'                                                        S01290
     C  N35              ADD       PSTA          PSTADR                                       S01290
     C   35              SUB       PSTA          PSTACR                                       S01290
     C                   END                                                                  S01290
     C*                                                                   120830
     C     BGN0ST        IFEQ      'Y'                                                        120830
     C/COPY WNCPYSRC,GLH00666
     C                   ADD       PSTAS         TPRFC                                        120830
     C                   ENDIF                                                                120830
0500 C*
0501 C     TNOP          ADD       1             TNOP
0502 C*
0503 C     TCCY          ADD       PSTAS         TCCY
0504 C     TACOD         ADD       PSTAS         TACOD
0505 C   04TACSQ         ADD       PSTAS         TACSQ
0506 C**
0507 C***  KEEP HASH TOTALS FOR EACH TYPE OF 'SOURCE OF POSTING'
0508 C**
0509 C                   Z-ADD     1             X
0510 C**
0511 C     GETP          LOOKUP    ARGP(X)                                50
      *                                                                                       CGL047
      ** If generated entry type not recognised check if posting                              CGL047
      ** originates from Generic Posting Interface                                            CGL047
     C     *IN50         IFEQ      *OFF                                                       CGL047
     C     GETP          CHAIN     GLGPICL1                           90                      CGL047
     C     *IN90         IFEQ      *OFF                                                       CGL047
     C                   MOVE      *ON           *IN50                                        CGL047
     C                   Z-ADD     25            X                                            CGL047
     C                   ENDIF                                                                CGL047
     C                   ENDIF                                                                CGL047
      *                                                                                       CGL047
0512 C  N50              Z-ADD     1             X
0513 C**
     C*                                                                   S01408
     C     CGL030        IFNE      'Y'                                                        CGL030
     C/COPY WNCPYSRC,GL0340CCPG                                           S01408
     C*                                                                   S01408
0514 C     T5A           TAG                                                    ** T5A TAG **
0515 C**
0516 C     ARNP(X)       ADD       1             ARNP(X)
0517 C*
0518 C                   Z-ADD     ARTI(X)       ZZTOTI
0519 C                   Z-ADD     ARTD(X)       ZZTOTD
0520 C*
0521 C     PSTA          DIV       1000          ZZAMT
0522 C**
0523 C                   EXSR      GLZADD
0524 C*
0525 C                   Z-ADD     ZZTOTI        ARTI(X)
0526 C                   Z-ADD     ZZTOTD        ARTD(X)
0527 C**
0528 C     BRNP(X)       ADD       1             BRNP(X)
0529 C*
0530 C                   Z-ADD     BRTI(X)       ZZTOTI
0531 C                   Z-ADD     BRTD(X)       ZZTOTD
0532 C*
0533 C     PSTA          DIV       1000          ZZAMT
0534 C**
0535 C                   EXSR      GLZADD
0536 C*
0537 C                   Z-ADD     ZZTOTI        BRTI(X)
0538 C                   Z-ADD     ZZTOTD        BRTD(X)
0539 C*
0540 C*******    X         COMP 16                   4848                 S01102
0540 C***********X         COMP 18                   4848          S01102 S03220
0540 C****       X         COMP 19                   4848          S03220 S01127
     C***********X         COMP 20                   4848          S01127 S01196
     C***********X         IFNE 18                                  S01196S01427
     C***********X         IFNE 19                                  S01427S01421
     C***********X         IFNE 21                                  S01421S01464
     C***********X         IFNE 23                                 S01464 CRT001
     C*                                                                   S01408
     C                   ELSE                                                                 CGL030
      *                                                                                       CGL030
      ** IF previous LOKUPEfailed set file controls using arrays                              CGL030
      ** ARN1, BRN1, AR1I,EBR1I, AR1D and BR1D.                                               CGL030
      *                                                                                       CGL030
     C                   MOVEL     'N'           IGNCOR            1                          CGL030
      *                                                                                       CGL030
     C     *IN50         IFEQ      '0'                                                        CGL030
      *                                                                                       CGL030
     C                   Z-ADD     1             X                                            CGL030
      *                                                                                       CGL030
     C     GETP          LOOKUP    ARG1(X)                                50                  CGL030
      *                                                                                       CGL030
     C     *IN50         IFEQ      '1'                                                        CGL030
     C                   MOVEL     'Y'           IGNCOR                                       CGL030
      *                                                                                       CGL030
     C     ARN1(X)       ADD       1             ARN1(X)                                      CGL030
      *                                                                                       CGL030
     C                   Z-ADD     AR1I(X)       ZZTOTI                                       CGL030
     C                   Z-ADD     AR1D(X)       ZZTOTD                                       CGL030
      *                                                                                       CGL030
     C     PSTA          DIV       1000          ZZAMT                                        CGL030
      *                                                                                       CGL030
     C                   EXSR      GLZADD                                                     CGL030
      *                                                                                       CGL030
     C                   Z-ADD     ZZTOTI        AR1I(X)                                      CGL030
     C                   Z-ADD     ZZTOTD        AR1D(X)                                      CGL030
      *                                                                                       CGL030
     C     BRN1(X)       ADD       1             BRN1(X)                                      CGL030
      *                                                                                       CGL030
     C                   Z-ADD     BR1I(X)       ZZTOTI                                       CGL030
     C                   Z-ADD     BR1D(X)       ZZTOTD                                       CGL030
      *                                                                                       CGL030
     C     PSTA          DIV       1000          ZZAMT                                        CGL030
      *                                                                                       CGL030
     C                   EXSR      GLZADD                                                     CGL030
      *                                                                                       CGL030
     C                   Z-ADD     ZZTOTI        BR1I(X)                                      CGL030
     C                   Z-ADD     ZZTOTD        BR1D(X)                                      CGL030
      *                                                                                       CGL030
     C                   Z-ADD     1             X                                            CGL030
     C                   END                                                                  CGL030
     C                   END                                                                  CGL030
      *                                                                                       CGL030
      ** Ignore core hash totals when enhancement lookup used                                 CGL030
      *                                                                                       CGL030
     C     IGNCOR        IFEQ      'N'                                                        CGL030
     C  N50              Z-ADD     1             X                                            CGL030
      *                                                                                       CGL030
     C     T5B           TAG                                                    ** T5B TAG **
      *                                                                                       CGL030
     C     ARNP(X)       ADD       1             ARNP(X)                                      CGL030
      *                                                                                       CGL030
     C                   Z-ADD     ARTI(X)       ZZTOTI                                       CGL030
     C                   Z-ADD     ARTD(X)       ZZTOTD                                       CGL030
      *                                                                                       CGL030
     C     PSTA          DIV       1000          ZZAMT                                        CGL030
      *                                                                                       CGL030
     C                   EXSR      GLZADD                                                     CGL030
      *                                                                                       CGL030
     C                   Z-ADD     ZZTOTI        ARTI(X)                                      CGL030
     C                   Z-ADD     ZZTOTD        ARTD(X)                                      CGL030
      *                                                                                       CGL030
     C     BRNP(X)       ADD       1             BRNP(X)                                      CGL030
      *                                                                                       CGL030
     C                   Z-ADD     BRTI(X)       ZZTOTI                                       CGL030
     C                   Z-ADD     BRTD(X)       ZZTOTD                                       CGL030
      *                                                                                       CGL030
     C     PSTA          DIV       1000          ZZAMT                                        CGL030
      *                                                                                       CGL030
     C                   EXSR      GLZADD                                                     CGL030
      *                                                                                       CGL030
     C                   Z-ADD     ZZTOTI        BRTI(X)                                      CGL030
     C                   Z-ADD     ZZTOTD        BRTD(X)                                      CGL030
      *                                                                                       CGL030
     C                   END                                                                  CGL030
     C                   END                                                                  CGL030
     C/COPY WNCPYSRC,GL0340CCP4                                           S01408
     C*                                                                   S01408
     C***********X         IFNE 24                                 CRT001 CRE004
     C********** X         IFNE 25                                                     CRE004 CGL047
     C     X             IFNE      26                                                         CGL047
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0340CCP5                                           S01408
     C*                                                                   S01408
     C                   SETON                                        48                      S01196
     C                   ELSE                                                                 S01196
     C                   SETOFF                                       48                      S01196
     C                   END                                                                  S01196
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0340CCP3                                           S01408
     C*                                                                   S01408
0541 C**
0542 C*******              Z-ADD16        X                               S01102
0542 C***********          Z-ADD18        X                        S01102 S03220
0542 C****                 Z-ADD19        X                        S03220 S01127
     C***********          Z-ADD20        X                        S01127 S01196
     C*********************Z-ADD18        X                        S01196 S01427
     C*********************Z-ADD19        X                         S01427S01421
     C***********          Z-ADD21        X                         S01421S01464
     C***********          Z-ADD23        X                        S01464 CRT001
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0340CCP6                                           S01408
     C*                                                                   S01408
     C***********          Z-ADD24        X                        CRT001 CRE004
     C**********           Z-ADD25        X                                            CRE004 CGL047
     C                   Z-ADD     26            X                                            CGL047
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0340CCP2                                           S01408
     C*                                                                   S01408
0543 C*
     C     CGL030        IFNE      'Y'                                                        CGL030
0544 C   48              GOTO      T5A
     C                   ELSE                                                                 CGL030
     C   48              GOTO      T5B                                                        CGL030
     C                   END                                                                  CGL030
0545 C**
0546 C   05              GOTO      T6
0547 C**
0548 C***
0549 C/SPACE 2
0550 C***  PROCESS DETAILS - NON-RETAIL A/C'S
0551 C*
0552 C*
     C/COPY WNCPYSRC,LUC110_054                                                               LUC110
0553 C                   Z-ADD     VALD          ZDAYNO
0554 C                   EXSR      ZDATE2
0555 C                   Z-ADD     ZDATE         VALDO             6 0
0556 C*
0557 C                   SETON                                        84
0558 C*
0559 C**********         GOTO      END                                                        CGL120
     C                   GOTO      ENDPST                                                     CGL120
0560 C*
0561 C**
0562 C/SPACE 2
0563 C***  PROCESS RETAIL A/C'S
0564 C*
0565 C     T6            TAG                                                    ** T6 TAG **
0566 C*
0567 C***********TPSTA     ADD  PSTAS     TPSTA                           S01290
     C*                                                                   S01290
     C*** SEPARATE DEBIT AND CREDIT DETAILS                               S01290
     C*                                                                   S01290
     C  N35              ADD       PSTA          TPSTDR                                       S01290
     C   35              SUB       PSTA          TPSTCR                                       S01290
      *                                                                                       CGL120
     C     ENDPST        TAG                                                                  CGL120
     C     *IN04         IFEQ      *ON                                                        CGL120
     C     *IN05         OREQ      *ON                                                        CGL120
     C                   Z-ADD     4             X                                            CGL120
     C     PSTA          DIV       1000          ZZAMT                                        CGL120
     C                   EXSR      HASH                                                       CGL120
     C                   ENDIF                                                                CGL120
      *                                                                                       CGL120
      *** Output Posting Lines to Report                                                      CGL120
     C   81                                                                                   CGL120
     CAN 25              EXCEPT    EXACOB                                                     CGL120
     C   82                                                                                   CGL120
     CAN 25              EXCEPT    EXCLOB                                                     CGL120
     C   83                                                                                   CGL120
     CAN 25              EXCEPT    EXASOB                                                     CGL120
     C   84                                                                                   CGL120
     CAN 25                                                                                   CGL120
     CANN15                                                                                   CGL120
     CAN 04              EXCEPT    EXPSDT                                                     CGL120
     C   84                                                                                   CGL120
     CAN 25                                                                                   CGL120
     CANN15                                                                                   CGL120
     CAN 04              SETOFF                                       L6                      CGL120
      *                                                                                       CGL120
      *** Read Next Posting Record                                                            CGL120
     C     NXTPST        TAG                                                                  CGL120
      *                                                                                       CGL120
     C                   SETOFF                                       0405                    CGL120
     C     AJNKY         READE     ACJND                                  10                  CGL120
     C                   ENDDO                                                                CGL120
0568 C**
0569 C/SPACE 3
0570 C***
0571 C     END           TAG                                                    ** END TAG **
     C/COPY WNCPYSRC,GL0340C009
0576 C***
0577 C/SPACE 2
0578 C**   F I L E    C O N T R O L S
0579 C*
     C**N01*****                                                                              CGL120
     C***ANN02**                                                                              CGL120
0580 C***ANN04**                                                                              CGL120
0581 C***ANN05**            GOTO      ENDF                                                    CGL120
     C  N01                                                                                   CGL120
     CANN03              GOTO      ENDF                                                       CGL120
0582 C*
0583 C***01*****                                                                              CGL120
0584 C***OR*02**            GOTO      T7                                                      CGL120
0585 C**********                                                                              CGL120
0586 C**********         Z-ADD     4             X                                            CGL120
0587 C*****PSTA*         DIV       1000          ZZAMT                                        CGL120
0588 C**********         EXSR      HASH                                                       CGL120
0589 C**********         GOTO      ENDF                                                       CGL120
0590 C*
0591 C     T7            TAG                                                    ** T7 TAG **
0592 C*
0593 C                   Z-ADD     6             X
0594 C     CRBL          DIV       1000          ZZAMT
0595 C                   Z-SUB     ZZAMT         ZZAMT
0596 C  N42              EXSR      HASH
0597 C                   Z-ADD     5             X
0598 C     DRBL          DIV       1000          ZZAMT
0599 C  N44              EXSR      HASH
0600 C*
0601 C     ENDF          TAG                                                    ** ENDF TAG **
0602 C*
0603 C/EJECT
0604 C********************************************************************
0605 C****                                                            ****
0606 C****  S U B R O U T I N E S  &  C O N T R O L   B R E A K S     ****
0607 C****                                                            ****
0608 C********************************************************************
0609 C/SPACE 2
0610 C********************************************************************
     C*                                                                   120830
     C** Profit Centre level break...                                     120830
     C*                                                                   120830
     CL1   BGN0ST        IFEQ      'Y'                                                        120830
     C***L1****IN38         ANDEQ     '0'                                              120830 CGL120
     CL1   *IN11         ANDEQ     '1'                                                        CGL120
     C***L1***RINDJ         ANDEQ     0                                                120830 CGL120
     CL1   RINDB         ANDEQ     0                                                          CGL120
     C/COPY WNCPYSRC,GLH00667
     C*                                                                   127973
     C***L1***PRFCJ         IFEQ      *BLANKS                                          127973 CGL120
     C***L1***PRFCJ         OREQ      FTUAPC                                           127973 CGL120
     CL1   PRFCB         IFEQ      *BLANKS                                                    CGL120
     CL1   PRFCB         OREQ      FTUAPC                                                     CGL120
     CL1                 SETON                                        2829                    127973
     CL1                 ELSE                                                                 127973
     CL1                 SETOFF                                       28                      127973
     CL1                 ENDIF                                                                127973
     C*                                                                   127973
     C***L1*****            MOVE      PRFCJ         WPRFC                              120830 CGL120
     CL1                 MOVE      PRFCB         WPRFC                                        CGL120
     CL1                 EXCEPT    EXPRFC                                                     120830
     CL1                 Z-ADD     0             TPRFC                                        120830
     CL1                 ENDIF                                                                120830
0611 C*** A/C SEQ NO  LEVEL BREAK,PRINT C/B
0612 C**
0613 C***L1******   RINDJ     COMP 0                    777776            120830
     C/COPY WNCPYSRC,GL0340C002
      *                                                                                       CGL050
     CL1   CGL050        IFEQ      'Y'                                                        CGL050
      *                                                                                       CGL050
     CL1   *IN77         IFEQ      '1'                                                        CGL050
     CL1                 MOVE      '0'           *IN77                                        CGL050
     CL1                 MOVE      '1'           *IN76                                        CGL050
     CL1                 ENDIF                                                                CGL050
      *                                                                                       CGL050
     CL1N66              GOTO      MISS                                                       CGL050
      *                                                                                       CGL050
     CL1                 ENDIF                                                                CGL050
      *                                                                                       CGL050
0614 C***********                                                         120830
     C***L1 76      PSTACR    COMP 0                        16     S01290 120830
     C***L1 76      PSTADR    COMP 0                        17     S01290 120830
     C***********                                                  S01290 120830
0615 C***L1 76                SETON                     85                120830
0616 C***L1 76N38             EXCPT                                       120830
0617 C***L1                   SETOF                     85  67            120830
     C***********                                                  S01290 120830
     C***L1                   SETOF                     1617       S01290 120830
0618 C***********                                                         120830
0619 C***L1 76                Z-ADD0         TACSQ                        120830
0619 C***L1 76                Z-ADD0         PSTACR                S01290 120830
0619 C***L1 76                Z-ADD0         PSTADR                S01290 120830
     C*                                                                   120830
     C***L2***RINDJ         COMP      0                                  777776        120830 CGL120
     CL2   RINDB         COMP      0                                  777776                  CGL120
     C/COPY WNCPYSRC,GL0340C008
     C*                                                                   120830
     CL2 76PSTACR        COMP      0                                      16                  120830
     CL2 76PSTADR        COMP      0                                      17                  120830
     C*                                                                   120830
     CL2 76              SETON                                        85                      120830
     C***L2*76**                                                                              CGL120
     C***ANN38**            EXCEPT                                                     120830 CGL120
     CL2 76                                                                                   CGL120
     CAN 12              EXCEPT                                                               CGL120
     CL2                 SETOFF                                       85  67                  120830
     C*                                                                   120830
     CL2                 SETOFF                                       1617                    120830
     C*                                                                   120830
     CL2 76              Z-ADD     0             TACSQ                                        120830
     CL2 76              Z-ADD     0             PSTACR                                       120830
     CL2 76              Z-ADD     0             PSTADR                                       120830
0620 C***
0621 C********************************************************************
0622 C/SPACE 3
0623 C********************************************************************
0624 C*** CUSTOMER NO  LEVEL BREAK,SETOF IND-65
0625 C**
0626 C***L2******             SETOF                     65                120830
     CL3                 SETOFF                                       65                      120830
0627 C**
0628 C********************************************************************
0629 C/SPACE 3
0630 C********************************************************************
0631 C*** RETAIL LEVEL BREAK,PRINT C/B
0632 C**
0633 C**
0634 C***L3*77N66             GOTO MISS                                   120830
0635 C***L3*77***             SETON                     86                120830
     C***L3*77***   TPSTCR    COMP 0                        18      S01290120830
     C***L3*77***   TPSTDR    COMP 0                        19      S01290120830
0636 C***L3*86N38             EXCPT                                       120830
0637 C***********                                                         120830
0638 C*3*77******          Z-ADD0         TPSTA                           S01290
0638 C***L3*77***             Z-ADD0         TPSTDR                 S01290120830
0638 C***L3*77***             Z-ADD0         TPSTCR                 S01290120830
0639 C***L3*77***             Z-ADD0         TLDBE                        120830
0640 C***L3*77***             Z-ADD0         TACSQ                        120830
0641 C***********                                                         120830
0642 C***L3*77***             SETOF                     867769            120830
     C***L3*77***             SETOF                     1819        S01290120830
     C*                                                                   120830
     CL4 77
     CANN66              GOTO      MISS                                                       120830
     CL4 77              SETON                                        86                      120830
     CL4 77TPSTCR        COMP      0                                      18                  120830
     CL4 77TPSTDR        COMP      0                                      19                  120830
     C*                                                                   127973
     C***L4*77PRFCJ         IFEQ      *BLANKS                                          127973 CGL120
     C***L4***PRFCJ         OREQ      FTUAPC                                           127973 CGL120
     CL4 77PRFCB         IFEQ      *BLANKS                                                    CGL120
     CL4   PRFCB         OREQ      FTUAPC                                                     CGL120
     CL4 77              SETON                                        2829                    127973
     CL4                 ELSE                                                                 127973
     CL4 77              SETOFF                                       28                      127973
     CL4                 ENDIF                                                                127973
     C*                                                                   127973
     C***L4*77**            MOVE      PRFCJ         WPRFC                              120830 CGL120
     CL4 77              MOVE      PRFCB         WPRFC                                        CGL120
     C***L4*86**                                                                              CGL120
     C***ANN38**            EXCEPT                                                     120830 CGL120
     CL4 86                                                                                   CGL120
     CAN 13              EXCEPT                                                               CGL120
     C*                                                                   120830
     CL4 77              Z-ADD     0             TPSTDR                                       120830
     CL4 77              Z-ADD     0             TPSTCR                                       120830
     CL4 77              Z-ADD     0             TLDBE                                        120830
     CL4 77              Z-ADD     0             TACSQ                                        120830
     CL4 77              Z-ADD     0             TPRFC                                        120830
     C*                                                                   120830
     CL4 77              SETOFF                                       867769                  120830
     CL4 77              SETOFF                                       1819                    120830
0643 C***
0644 C********************************************************************
0645 C/SPACE 3
0646 C***********
0647 C***  A/C CODE LEVEL BREAK
0648 C**
0649 C***  PRINT A/C CLOSING BALANCE
0650 C**
     C/COPY WNCPYSRC,GL0340C003
     CL4   CGL050        IFEQ      'Y'                                                        CGL050
      *                                                                                       CGL050
     CL4N66              GOTO      MISS                                                       CGL050
      *                                                                                       CGL050
     CL4                 ENDIF                                                                CGL050
0651 C***L4******             SETON                     87                120830
0652 C***L4N38***             EXCPT                                       120830
0653 C***L4******             SETOF                     87                120830
0654 C***********                                                         120830
0655 C***L4******             Z-ADD0         TACOD                        120830
0656 C***L4******             SETOF                     61                120830
     CL5                 SETON                                        87                      120830
     C***L5N38**            EXCEPT                                                     120830 CGL120
     CL5 14              EXCEPT                                                               CGL120
     CL5                 SETOFF                                       87                      120830
     C*                                                                   120830
     CL5                 Z-ADD     0             TACOD                                        120830
     CL5                 SETOFF                                       61                      120830
0657 C**
0658 C***
0659 C***********
0660 C/SPACE 2
0661 C***********
0662 C***  CURRENCY CHANGE
0663 C**
0664 C***L5******   MISS      TAG                                         120830
0665 C***L5******   TCCY      COMP 0                    7979              120830
0666 C***********                                                         120830
0667 C*****PRINT*CURRENCY*TOTAL*IF*OUT*OF*BALANCE                         120830
0668 C***********                                                         120830
0669 C***L5******             SETON                     41                120830
0670 C***L5*79***             SETON                     U8                120830
0671 C***L5*79***             EXCPT                                       120830
0672 C***L5******             SETOF                     79  49            120830
0673 C***********                                                         120830
0674 C***L5******             Z-ADD0         TCCY                         120830
     C*                                                                   120830
     CL6   MISS          TAG                                                                  120830
     CL6   TCCY          COMP      0                                  7979                    120830
     C*                                                                   120830
     C***  PRINT CURRENCY TOTAL IF OUT OF BALANCE                         120830
     C*                                                                   120830
     CL6                 SETON                                        41                      120830
     CL6 79              SETON                                        U8                      120830
     CL6 79              EXCEPT                                                               120830
     CL6                 SETOFF                                       79  49                  120830
     C*                                                                   120830
     CL6                 Z-ADD     0             TCCY                                         120830
0675 C**
0676 C***********
0677 C/SPACE 2
0678 C***********
0679 C***  PRINT HASH TOTALS FOR EACH KIND OF 'SOURCE OF POSTING'
     C***L6******   *IN58     CABEQ'1'       ENDL6                 S01117 120830
0680 C***L6*38***             GOTO ENDL6                                  120830
0681 C***L6******             SETON                     517880            120830
0682 C***L6******             EXCPT                                       120830
0683 C***L6******             SETOF                     517880            120830
0684 C***********                                                         120830
0685 C***L6******             Z-ADD0         X                            120830
0686 C***********                                                         120830
0687 C***L6******   L6T1      TAG                           ** L6T1 TAG** 120830
0688 C***********                                                         120830
0689 C***L6******   X         ADD  1         X                            120830
     C*                                                                   120830
     CL7   *IN58         CABEQ     '1'           ENDL6                                        120830
     CL7 38              GOTO      ENDL6                                                      120830
     CL7                 SETON                                        517880                  120830
     CL7                 EXCEPT                                                               120830
     CL7                 SETOFF                                       517880                  120830
     C*                                                                   120830
     CL7                 Z-ADD     0             X                                            120830
     C*                                                                   120830
     CL7   L6T1          TAG                                                    ** L6T1 TAG ** 12083
     C*                                                                   120830
     CL7   X             ADD       1             X                                            120830
     C*                                                                   120830
0690 C*6*********X         COMP 15                   56                   S01102
0690 C*6*********X         COMP 17                   56            S01102 S03220
0690 C*6*********X         COMP 18                   56            S03220 S01127
0690 C*6*********X         COMP 19                   56            S01127 S01196
     C*6         X         IFGT 17                                  S01196S01427
     C*6*********X         IFGT 18                                  S01427S01421
     C***L6******X         IFGT 20                                  S01421S01464
     C***L6******X         IFGT 22                                 S01464 CRT001
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0340CCP7                                           S01408
     C*                                                                   S01408
     C***L6******   X         IFGT 23                              CRT001 120830
     C*7*********X         IFGT 23                                 120830 134018
     C*7*********X         IFGT 24                                                     134018 CGL030
     C***L7***X*            IFGT      25                                               CGL030 CGL120
     CL7   X             IFGT      24                                                         CGL120
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0340CCP8                                           S01408
     C*                                                                   S01408
     C***L6******             SETON                     56         S01196 120830
     C***L6******             ELSE                                 S01196 120830
     C***L6******             SETOF                     56         S01196 120830
     C***L6******             END                                  S01196 120830
     CL7                 SETON                                        56                      120830
     CL7                 ELSE                                                                 120830
     CL7                 SETOFF                                       56                      120830
     CL7                 END                                                                  120830
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0340CPL2                                           S01408
     C*                                                                   S01408
0691 C**
0692 C**
0693 C***L6N56***   BRNP,X    COMP 0                        55            120830
     CL7N56BRNP(X)       COMP      0                                      55                  120830
0694 C*
0695 C***L6*55N56             GOTO L6T1                                   120830
     CL7 55
     CANN56              GOTO      L6T1                                                       120830
0696 C**
     C*                                                                   S01408
      *                                                                                       CGL030
      ** Only process if feature is present                                                   CGL030
      *                                                                                       CGL030
     CL6 56CGL030        IFEQ      'Y'                                                        CGL030
      *                                                                                       CGL030
      ** Only process if indicators L6 and 56 are ON                                          CGL030
      *                                                                                       CGL030
     CL6 56              Z-ADD     1             Y                                            CGL030
      *                                                                                       CGL030
     CL6 56Y             DOWLE     WNARL1                                                     CGL030
      *                                                                                       CGL030
     CL6 56BRN1(Y)       IFNE      0                                                          CGL030
     CL6 56              EXCEPT    EECCC1                                                     CGL030
     CL6                 END                                                                  CGL030
      *                                                                                       CGL030
     CL6 56              ADD       1             Y                                            CGL030
     CL6 56              ENDDO                                                                CGL030
      *                                                                                       CGL030
     CL6 56              MOVEA     *ZEROS        BRN1                                         CGL030
     CL6 56              MOVEA     *ZEROS        BR1I                                         CGL030
     CL6 56              MOVEA     *ZEROS        BR1D                                         CGL030
      *                                                                                       CGL030
     CL6                 END                                                                  CGL030
     C/COPY WNCPYSRC,GL0340CPLT                                           S01408
     C*                                                                   S01408
0697 C***L6******             SETON                     52                120830
0698 C***L6******             EXCPT                                       120830
0699 C***L6******             SETOF                     52                120830
0700 C***********                                                         120830
0701 C***L6N56***             GOTO L6T1                                   120830
0702 C***********                                                         120830
0703 C***L6******             Z-ADD0         BRTI                         120830
0704 C***L6******             Z-ADD0         BRTD                         120830
0705 C***L6******             Z-ADD0         BRNP                         120830
0706 C***L6******             SETOF                     56                120830
0707 C***********                                                         120830
0708 C***L6******             SETON                     41                120830
0709 C***L6******   ENDL6     TAG                          ** ENDL6 TAG **120830
     C*                                                                   120830
     CL7                 SETON                                        52                      120830
     CL7                 EXCEPT                                                               120830
     CL7                 SETOFF                                       52                      120830
     C*                                                                   120830
     CL7N56              GOTO      L6T1                                                       120830
     C*                                                                   120830
     CL7                 Z-ADD     0             BRTI                                         120830
     CL7                 Z-ADD     0             BRTD                                         120830
     CL7                 Z-ADD     0             BRNP                                         120830
     CL7                 SETOFF                                       56                      120830
     C*                                                                   120830
     CL7                 SETON                                        41                      120830
     CL7   ENDL6         TAG                                                    ** ENDL6 TAG **12083
0710 C/SPACE 2
      *                                                                   S01117
      ** ENSURE TOTALS SPOOL FILE RECORDED BY RCF                         S01117
     CLR                 Z-ADD     SFNUMU        SFNUM2            6 0                        S01117
     CLR                 OUT       LDA                                                        S01194
     CLR                 CALL      'ZSFILE'                                                   S01117
     CLR                 PARM                    SEQ                                          S01117
     CLR                 PARM      *BLANKS       SENTY                                        S01117
     CLR                 PARM                    SFILEU                                       S01117
     CLR                 PARM                    SFNUM2                                       S01117
     CLR                 PARM                    ZSERR             1                          S01117
     CLR   *LOCK         IN        LDA                                                        S01194
     C*                                                                   S01117
     CLR   ZSERR         IFEQ      'Y'                                                        S01117
     C*                                                                   S01117
     C* ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAMME       S01117
     C*                                                                   S01117
     CLR                 SETON                                        U7U8                    S01117
     CLR                 RETURN                                                               S01117
     CLR                 END                                                                  S01117
      *                                                                   S01194
      ** OBTAIN BANK DETAILS HERE WHEN INPUT FILES EMPTY                  S01194
     CLR   *IN40         IFEQ      '0'                                                        S01194
     CLR                 SETON                                        38                      S01194
     CLR                 MOVEL     'GL0340'      DBPGM            10                          S01194
     CLR                 IN        RUNDT                                                      S01194
      *                                                                   S01194
      **   CHECK MULTIBRANCHING INDICATOR AND TYPE OF REPORT REQUESTED    S01194
     CLR                 SETOFF                                       5759                    S01194
     CLR   MBIN          IFEQ      'Y'                                                        S01194
     CLR                 SETON                                        59                      S01194
     CLR                 SETON                                        57                      S01194
     CLR                 END                                                                  S01194
      *                                                                   S01194
      **  OBTAIN BANK TITLE VIA BANK DETAILS                              S01194
     CLR                 CALL      'AOBANKR0'                                                 S01194
     CLR                 PARM      '*MSG   '     @RTCD             7                          S01194
     CLR                 PARM      '*FIRST '     @OPTN             7                          S01194
     CLR   SDBANK        PARM      SDBANK        DSFDY                                        S01194
     CLR   @RTCD         IFNE      *BLANK                                                     S01194
     CLR                 MOVEL     'SDBANKPD'    DBFILE                           *************S0119
     CLR                 MOVEL     '006'         DBASE                            * DBERR 006 *S0119
     CLR                 MOVEL     @OPTN         DBOPTN            7              *************S0119
     CLR                 MOVEL     @OPTN         DBKEY            29                          S01194
     CLR                 EXSR      *PSSR                                                      S01194
     CLR                 SETON                                        63                      S01194
     CLR                 END                                                                  S01194
     CLR                 END                                                    FI             S0119
      *                                                                   S01117
0711 C***  PRINT HASH TOTALS FOR EACH KIND OF 'SOURCE OF POSTING'
0712 C**
0713 C*R*********          SETON                     888078               S01117
0713 CLR                 SETON                                        88  78                  S01117
     CLR                 MOVE      XPOST         Z                                            CGL120
0714 CLR                 EXCEPT
0715 CLR                 SETOFF                                       88  80
0716 C**
0717 CLR                 Z-ADD     0             X
0718 C**
0719 CLR   LRT1          TAG                                                    ** LRT1 TAG **
0720 C**
0721 CLR   X             ADD       1             X
0722 C*R*********X         COMP 15                   56                   S01102
0722 C*R*********X         COMP 17                   56            S01102 S03220
0722 C*R*********X         COMP 18                   56            S03220 S01127
0722 C*R*********X         COMP 19                   56            S01127 S01196
     C*R         X         IFGT 17                                  S01196S01427
     C*R*********X         IFGT 18                                  S01427S01421
     C***LR******X         IFGT 20                                  S01196S01464
     C***LR******X         IFGT 22                                 S01464 CRT001
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0340CCP9                                           S01408
     C*                                                                   S01408
     C*LR********X         IFGT 23                                 CRT001 CRE004
     C*LR********X         IFGT 24                                                     CRE004 CGL047
     CLR   X             IFGT      25                                                         CGL047
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0340CP10                                           S01408
     C*                                                                   S01408
     CLR                 SETON                                        56                      S01196
     CLR                 ELSE                                                                 S01196
     CLR                 SETOFF                                       56                      S01196
     CLR                 END                                                                  S01196
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0340CPL2                                           S01408
     C*                                                                   S01408
0723 C**
0724 CLRN56ARNP(X)       COMP      0                                      55
0725 C*
     CLR 55
0726 CANN56              GOTO      LRT1
0727 C**
     C*                                                                   S01408
      *                                                                                       CGL030
      ** Only process if feature is present                                                   CGL030
      *                                                                                       CGL030
     CLR 56CGL030        IFEQ      'Y'                                                        CGL030
      *                                                                                       CGL030
      ** Only process if indicators L6 and 56 are ON                                          CGL030
      *                                                                                       CGL030
     CLR 56              Z-ADD     1             Y                                            CGL030
      *                                                                                       CGL030
     CLR 56Y             DOWLE     WNARL1                                                     CGL030
      *                                                                                       CGL030
     CLR 56ARN1(Y)       IFNE      0                                                          CGL030
     CLR 56              EXCEPT    EECCC2                                                     CGL030
     CLR                 END                                                                  CGL030
      *                                                                                       CGL030
     CLR 56              ADD       1             Y                                            CGL030
     CLR 56              ENDDO                                                                CGL030
      *                                                                                       CGL030
     CLR                 END                                                                  CGL030
      *                                                                                       CGL030
     C/COPY WNCPYSRC,GL0340CPL1                                           S01408
     C*                                                                   S01408
0728 CLR                 SETON                                        89
0729 CLR                 EXCEPT
0730 CLR                 SETOFF                                         89
0731 C**
0732 CLRN56              GOTO      LRT1
0733 C**
0734 C/SPACE 2
0735 C**   F I L E    C O N T R O L S
0736 C*
      ** SKIP THE FOLLOWING PROCESSING WHEN THERE IS A DATABASE ERROR     S01117
     CLR   *IN63         CABEQ     '1'           LREND                                        S01117
      *                                                                   S01117
      ** SUPPRESS RUN CONTROL CHECK WHEN ONLY A BRANCH IS REQUESTED       S01117
     CLR   *IN59         IFEQ      '0'                                          IF             S0111
     CLR   *IN57         OREQ      '1'                                                        S01117
     CLR   *IN58         OREQ      '1'                                                        S01117
      *                                                                   S01117
     CLR                 READ      ABEXZY        ABEXDS                   20
     CLR                 Z-ADD     INT#1         INT(1)
     CLR                 Z-ADD     INT#2         INT(2)
     CLR                 Z-ADD     DEC#1         DEC(1)
     CLR                 Z-ADD     DEC#2         DEC(2)
     CLR                 Z-ADD     0             ZZTOTI
     CLR                 Z-ADD     0             ZZTOTD
     CLR   TAG001        TAG
     CLR                 READ      ACJNT         ACJNDS                   21
     CLR   *IN21         IFEQ      '0'
     CLR   NOREP         ADD       NOREP#        NOREP             5 0
     CLR   NOREP         SUB       2             NOREP
     CLR                 Z-ADD     INT#3         ZZAMTI
     CLR                 Z-ADD     DEC#3         ZZAMTD
     CLR                 EXSR      GLZSUM
     CLR                 GOTO      TAG001
     CLR                 END
     CLR   NOREP         ADD       2             NOREP
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0340CP11                                           S01408
     C*                                                                   S01408
     CLR 23
     CAN U6NOREP         ADD       2             NOREP                                        S03220
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0340CP12                                           S01408
     C*                                                                   S01408
     CLR                 Z-ADD     ZZTOTD        DEC(3)
     CLR                 Z-ADD     ZZTOTI        INT(3)
0738 C*
0737 CLR                 SETOFF                                       434647
0739 CLR                 Z-ADD     1             X
0740 CLR                 Z-ADD     5             Y
0741 C*
0742 CLR                 EXSR      COMP
0743 C*
0744 C***LR*45**            SETON                                        47U7                 CGL120
0745 C*
0746 CLR                 Z-ADD     2             X                 2 0
0747 CLR                 Z-ADD     6             Y                 2 0
0748 CLR                 EXSR      COMP
0749 C*
0750 C***LR*45**            SETON                                        43U7                 CGL120
0751 C*
0752 CLR                 Z-ADD     3             X
0753 CLR                 Z-ADD     4             Y
0754 C*
0755 CLR                 EXSR      COMP
0756 C*
0757 C***LR*45**            SETON                                        46U7                 CGL120
0758 C*
     CLR                 END                                                    FI             S0111
     CLR   LREND         TAG                                                    ** LREND TAG **S0111
0759 C*
0760 C***********
0761 C/SPACE 2
0169 C********************************************************************S01194
     C**                                                                  S01194
     C**   *PSSR  SR TO DUMP PROGRAM WHEN DATABASE ERROR OCCURS           S01194
     C**                                                                  S01194
     C     *PSSR         BEGSR                                                                S01194
     C     @RUN          IFEQ      *BLANKS                                                    S01194
     C                   MOVE      'Y'           @RUN              1                          S01194
     C                   MOVE      '1'           *INU7                                        048147
     C                   MOVE      '1'           *INU8                                        048147
     C                   DUMP                                                                 S01194
     C                   END                                                                  S01194
     C                   ENDSR                                                                S01194
     C**                                                                  S01194
0762 C********************************************************************
0763 C*
0764 C     HASH          BEGSR
0765 C*
0766 C                   Z-ADD     INT(X)        ZZTOTI
0767 C                   Z-ADD     DEC(X)        ZZTOTD
0768 C*
0769 C                   EXSR      GLZADD
0770 C*
0771 C                   Z-ADD     ZZTOTI        INT(X)
0772 C                   Z-ADD     ZZTOTD        DEC(X)
0773 C*
0774 C                   ENDSR
0775 C*
0776 C********************************************************************
0777 C/SPACE 2
0778 C********************************************************************
0779 C*
0780 C     COMP          BEGSR
0781 C*
0782 C                   Z-ADD     INT(X)        ZZTOTI
0783 C                   Z-ADD     DEC(X)        ZZTOTD
0784 C*
0785 C                   Z-ADD     INT(Y)        ZZINT
0786 C                   Z-ADD     DEC(Y)        ZZDEC
0787 C*
0788 C                   EXSR      GLZCMP
0789 C*
0790 C     ZZDIFI        COMP      0                                  4545
0791 C  N45ZZDIFD        COMP      0                                  4545
0792 C**
0793 C                   ENDSR
     C/COPY WNCPYSRC,GL0340C011
0794 C*
0795 C********************************************************************
0796 C/SPACE 2
0797 C********************************************************************
0798 C**
0799 C**   ZDATE2 SR. TO CONVERT A DAY NUMBER TO DATE FORMATS.
0800 C**
0801 C     ZDATE2        BEGSR                                                  *** ZDATE2 ***
0802 C**
0803 C**   CLEAR DATE FIELDS.
0804 C                   Z-ADD     0             ZDATE             6 0
0805 C                   MOVEL     '       '     ZADATE            7
0806 C**
0807 C**   CALCULATION TO DEFINE INPUT DAY NUMBER.
0808 C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
0809 C**
0810 C**   DETERMINE YEAR NUMBER.
0811 C**
0812 C**   ADJUST DAY NUMBER IN CASE LAST DAY OF YEAR.
0813 C     ZDAYNO        SUB       1             ZDAYN1            5 0  99
0814 C   99              GOTO      ZDEND2
0815 C**
0816 C**   CALCULATE NUMBER OF 4 YEAR SPANS SINCE 31/12/1971.
0817 C     ZDAYN1        DIV       1461          ZLYR              2 0
0818 C                   MVR                     ZDAYN1                         SAVE REMAINING
0819 C**                                                   DAYS
0820 C**   CALCULATE NUMBER OF REMAINING YEARS.
0821 C                   Z-ADD     1             ZWRK2             2 0
0822 C     ZDTAG1        TAG                                                    ** ZDTAG1 TAG *
0823 C     ZDAYN1        COMP      ZYDY(ZWRK2)                          90
0824 C  N90ZWRK2         ADD       1             ZWRK2
0825 C  N90              GOTO      ZDTAG1
0826 C     ZWRK2         SUB       1             ZWRK2                    91    LEAP YR, 91 ON
0827 C**
0828 C**   DECREMENT DAY NO. BY DAYS IN REMAINING YEARS.
0829 C  N91ZDAYN1        SUB       ZYDY(ZWRK2)   ZDAYN1
0830 C**
0831 C**   CALCULATE ACTUAL YEAR NUMBER.
0832 C     ZLYR          MULT      4             ZWRK3             3 0
0833 C     ZWRK3         ADD       72            ZWRK3                          BASE IS 1972
0834 C                   Z-ADD     ZWRK3         ZYEAR             2 0
0835 C     ZYEAR         ADD       ZWRK2         ZYEAR                          YEAR
0836 C**
0837 C**   DETERMINE MONTH NUMBER.
0838 C**
0839 C**   ADJUST DAY NO. IN CASE LAST DAY OF LEAP YEAR FEBRUARY.
0840 C                   SETOFF                                       9293
0841 C   91ZDAYN1        COMP      59                                   9293
     C   91
0842 CANN92ZDAYN1        SUB       1             ZDAYN1
0843 C**
0844 C**   CALCULATE MONTH NUMBER.
0845 C                   Z-ADD     2             ZWRK2
0846 C     ZDTAG2        TAG                                                    ** ZDTAG2 TAG *
0847 C     ZDAYN1        COMP      ZMDY(ZWRK2)                          94
0848 C  N94ZWRK2         ADD       1             ZWRK2
0849 C  N94              GOTO      ZDTAG2
0850 C     ZWRK2         SUB       1             ZWRK2
0851 C**
0852 C                   Z-ADD     ZWRK2         ZMTH              2 0          MONTH
0853 C**
0854 C**   DETERMINE DAY OF MONTH.
0855 C**
0856 C**   ADD BACK LAST DAY OF YEAR ADJUSTMENT.
0857 C     ZDAYN1        ADD       1             ZDAYN1
0858 C**
0859 C**   CALCULATE DAY OF MONTH.
0860 C     ZDAYN1        SUB       ZMDY(ZWRK2)   ZDAY              2 0          DAY
0861 C**
0862 C**   ADD BACK LEAP YEAR 29TH FEBUARY ADJUSTMENT, IF REQUIRED.
0863 C   93ZDAY          ADD       1             ZDAY
0864 C**
0865 C**   FORMAT DATE, DDMMYY OR MMDDYY.
0866 C  N98              MOVEL     ZDAY          ZWRK4             4 0
0867 C   98              MOVE      ZDAY          ZWRK4
0868 C  N98              MOVE      ZMTH          ZWRK4
0869 C   98              MOVEL     ZMTH          ZWRK4
0870 C                   MOVEL     ZWRK4         ZDATE
0871 C                   MOVE      ZYEAR         ZDATE
0872 C**
0873 C**   FORMAT ALPHA DATE, DDMMMYY.
0874 C     ZDAY          COMP      10                                   95
0875 C                   MOVEL     ZDAY          ZWRK5             5
0876 C   95              MOVEL     ' '           ZWRK5
0877 C                   MOVE      ZMNM(ZMTH)    ZWRK5
0878 C                   MOVEL     ZWRK5         ZADATE
0879 C                   MOVE      ZYEAR         ZADATE
0880 C**
0881 C     ZDEND2        ENDSR                                                  * ZDEND2 ENDSR*
0882 C**
0883 C**
0884 C********************************************************************
0885 C/SPACE 2
0886 C********************************************************************
0887 C* SUBROUTINE TO ADD AN AMOUNT (ZZAMT) TO THE TOTAL (ZZTOTI,ZZTOTD)
0888 C*   IND '99' IS SET BY AN OVERFLOW ERROR
0889 C*
0890 C     GLZADD        BEGSR                                                  *** GLZADD ****
0891 C*
0892 C                   Z-ADD     ZZAMT         ZZAMT            15 3    91    -DEFINE ZZAMT
0893 C   91              GOTO      ZZAEND                                       AMT = 0.BYPASS
0894 C*
0895 C* SPLIT ZZAMT INTO INTEGER AND DECIMAL FIELDS
0896 C                   Z-ADD     ZZAMT         ZZAMTI           15 0          INTEGER FIELD
0897 C                   Z-ADD     ZZAMT         ZZWK1             3 3
0898 C                   MOVE      ZZWK1         ZZAMTD            3 0          DECIMAL FIELD
0899 C* BOTH ZZAMTI AND ZZAMTD CONTAIN A 'SIGN' ZONE NOW
0900 C*
0901 C                   EXSR      GLZSUM
0902 C     ZZAEND        ENDSR                                                  ** ZZAEND TAG *
0903 C*
0904 C********************************************************************
0905 C/SPACE 2
0906 C********************************************************************
0907 C* SUBROUTINE TO CARRY OUT THE ADDITION FOR SUBROUTINES -
0908 C*                        GLZADD, GLZSUB, GLZCMP.
0909 C*          PARAMETERS PASSED -
0910 C*                     I/P ZZAMTI ZZAMTD
0911 C*                     O/P ZZTOTI ZZTOTD ZZNEGD IND 96 IND 99.
0912 C*
0913 C     GLZSUM        BEGSR                                                  *** GLZSUM ****
0914 C*
0915 C                   Z-ADD     ZZTOTI        ZZTOTI           15 0          DEFINE ZZTOTI
0916 C                   Z-ADD     ZZTOTD        ZZTOTD            3 0          DEFINE ZZTOTD
0917 C                   SETOFF                                       919293
0918 C                   SETOFF                                       949599
0919 C*
0920 C*    DETERMINE SIGN OF ZZAMTI & D,   92 IF NEG
0921 C     ZZAMTI        COMP      0                                    9293
0922 C   93ZZAMTD        COMP      0                                    9293
0923 C   93              GOTO      ZZSEND                                       ZERO BYPASS
0924 C*
0925 C*    DETERMINE SIGN OF ZZTOTI & D, 91 IF NEG.
0926 C     ZZTOTI        COMP      0                                    9193
0927 C   93ZZTOTD        COMP      0                                    9193
0928 C*
0929 C*    IF ZZTOTAL IS ZERO, RETURN ZZAMOUNT.
0930 C   93              Z-ADD     ZZAMTI        ZZTOTI
0931 C   93              Z-ADD     ZZAMTD        ZZTOTD
0932 C   93              GOTO      ZZSEND                                       ZERO BYPASS
0933 C*    IF SIGNS DIFFER BYPASS OVERFLOW CHECKS.
     C   91
0934 CANN92
     CORN91
0935 CAN 92              GOTO      ZZOFPS
0936 C*
0937 C     ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
0938 C     ZZWK2         COMP      999                                93        '93' = CARRY
0939 C  N93ZZWK2         COMP      -999                                 93             INTO INTEGER.
0940 C*
     C   93
0941 CANN92ZZAMTI        ADD       1             ZZWK3            15 0          ADD 'CARRY' +VE
     C   93
0942 CAN 92ZZAMTI        SUB       1             ZZWK3                          SUB 'CARRY' -VE
0943 C   93ZZTOTI        ADD       ZZWK3         ZZWK3
0944 C  N93ZZTOTI        ADD       ZZAMTI        ZZWK3
0945 C*
0946 C* IF THE MODULUS OF ZZWK3 IS LT MOD. ZZTOTI THEN O/F HAS OCCURED
0947 C  N92ZZWK3         COMP      ZZTOTI                               99      -92 MEANS NOS.
0948 C   92ZZWK3         COMP      ZZTOTI                             99                    NEGATIVE
0949 C  N99              Z-ADD     ZZWK2         ZZTOTD
0950 C  N99              Z-ADD     ZZWK3         ZZTOTI
0951 C*
0952 C* IF O/F ZEROIZE ZZAMT , IND '99' SET AND ZZTOT FIELDS LEFT INTACT.
0953 C   99              Z-ADD     0             ZZAMT            15 3
0954 C                   GOTO      ZZSEND
0955 C*
0956 C* THE 'SIGNS' ARE DIFFERENT
0957 C     ZZOFPS        TAG                                                    ** ZZOFPS TAG**
0958 C* IF ZZAMT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZTOT
0959 C*
0960 C   92              Z-SUB     ZZAMTI        ZZAMTI           15 0
0961 C   92              Z-SUB     ZZAMTD        ZZAMTD            3 0
0962 C*
0963 C* IF ZZTOT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZAMT.
0964 C*
0965 C   91              Z-SUB     ZZTOTI        ZZTOTI
0966 C   91              Z-SUB     ZZTOTD        ZZTOTD
0967 C* BOTH ZZAMT AND ZZTOT ARE NOW POSITIVE.
0968 C*
0969 C     ZZTOTI        COMP      ZZAMTI                             93  95
0970 C   95ZZTOTD        COMP      ZZAMTD                             93  95
0971 C*
0972 C* IF ZZTOT EQ. ZZAMT RETURN ZERO.
0973 C   95              Z-ADD     0             ZZTOTI
0974 C   95              Z-ADD     0             ZZTOTD
0975 C   95              GOTO      ZZSEND
0976 C*
0977 C* IF ZZTOT GT. ZZAMT.
0978 C   93ZZAMTD        COMP      ZZTOTD                             94
     C   93
0979 CAN 94ZZTOTI        SUB       1             ZZTOTI
     C   93
0980 CAN 94ZZTOTD        ADD       1000          ZZWK2
0981 C   93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C   93
0982 CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     C   93
0983 CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
0984 C*
0985 C*
0986 C* IF ZZAMT GT. ZZTOT.
0987 C  N93ZZTOTD        COMP      ZZAMTD                             94
     C  N93
0988 CAN 94ZZAMTI        SUB       1             ZZWK3            15 0
     C  N93
0989 CAN 94ZZAMTD        ADD       1000          ZZWK2
     C  N93
0990 CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     C  N93
0991 CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
     C  N93
0992 CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     C  N93
0993 CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
0994 C*
0995 C* REVERSE SIGN OF ZZTOT IF LARGER I/P FIELDS WERE NEGATIVE
0996 C                   SETOFF                                       94
     C   93
0997 CAN 91
     CORN93
0998 CAN 92              SETON                                        94
0999 C   94              Z-SUB     ZZTOTI        ZZTOTI
1000 C   94              Z-SUB     ZZTOTD        ZZTOTD
1001 C**
1002 C**   RESTORE SIGN OF ZZAMTI & ZZAMTD IF IT WAS REVERSED.
1003 C   92              Z-SUB     ZZAMTI        ZZAMTI
1004 C   92              Z-SUB     ZZAMTD        ZZAMTD
1005 C     ZZSEND        TAG                                                    ** ZZSEND TAG *
1006 C**
1007 C**   IF ZZTOTD IS ZERO, AND ZZTOTI IS NEG. SET UP ZZNEGD.
1008 C                   SETOFF                                       96
1009 C     ZZTOTD        COMP      0                                      91
1010 C   91ZZTOTI        COMP      0                                    96
1011 C   96              MOVE      '.000-'       ZZNEGD            5
1012 C                   ENDSR                                                    ** ENDSR **
1013 C********************************************************************
1014 C/SPACE 2
1015 C********************************************************************
1016 C* SUBROUTINE TO COMPARE AN AMOUNT TO THE TOTAL.
1017 C*      PARAMETERS. I/P - ZZINT - THE INTEGER PORTION OF THE NUMBER.
1018 C*                  I/P - ZZDEC - THE DECIMAL PORTION OF THE NUMBER.
1019 C*                  O/P - ZZDIFI - IS THE INTEGER DIFFERENCE.
1020 C*                  O/P - ZZDIFD - IS THE DECIMAL DIFFERENCE.
1021 C*                  O/P - ZZNEGD - FOR IMMEDIATE PRINTING ONLY.
1022 C*                  O/P - 96 IS SET IF DIFFERENCE IS NEGATIVE.
1023 C*
1024 C*    IF AN ERROR HAS OCCURED ZZDIFI AND ZZDIFD WILL BE ZERO.
1025 C*        '99' - OVERFLOW ERROR
1026 C*        '97' - THE 'SIGN' ZONES OF ZZINT AND ZZDEC ARE DIFFERENT
1027 C*
1028 C     GLZCMP        BEGSR                                                  *** GLZCMP ****
1029 C                   SETOFF                                       9799
1030 C                   Z-ADD     ZZDEC         ZZDEC             3 0919293    DEFINE ZZDEC
1031 C                   Z-ADD     ZZINT         ZZINT            15 0949596    DEFINE ZZINT
1032 C* IF SIGN ZONES DIFFER, SET 97, & RETURN ZERO.
     C   91
1033 CAN 95
     COR 92
1034 CAN 94              SETON                                        97        ERROR -MIXED
1035 C*                                                           STATUS
1036 C   97              GOTO      ZZQUIT                                       BRANCH TO ADMIT
1037 C*
1038 C*  SPECIAL CASES DEALT WITH FIRST
1039 C*      EITHER AMOUNTS EQ '0' OR BOTH AMOUNTS 'EQ'
1040 C                   SETOFF                                       9192
1041 C                   SETOFF                                       9495
     C   93
1042 CAN 96              SETON                                        91        * IF I/P FIELD
1043 C   91              Z-ADD     ZZTOTI        ZZDIFI           15 0          *    ZERO
1044 C   91              Z-ADD     ZZTOTD        ZZDIFD            3 0          *
1045 C   91              GOTO      ZZSIGN
1046 C*
1047 C     ZZTOTI        COMP      ZZINT                                  91    * IF FIELDS EQ
1048 C   91ZZTOTD        COMP      ZZDEC                                  91    *
1049 C   91              Z-ADD     0             ZZDIFI                         *
1050 C   91              Z-ADD     0             ZZDIFD                         *
1051 C   91              GOTO      ZZCEND
1052 C*
1053 C     ZZTOTI        COMP      0                                      91    * IF TOTAL
1054 C   91ZZTOTD        COMP      0                                      91    *    ZERO
1055 C   91              Z-SUB     ZZINT         ZZDIFI                         *
1056 C   91              Z-SUB     ZZDEC         ZZDIFD                         *
1057 C**
1058 C     ZZSIGN        TAG                                                    *** ZZSIGN ****
1059 C*
1060 C**   IF ZZDIFD IS ZERO, AND ZZDIFI IS NEG. SET UP ZZNEGD.
1061 C                   SETOFF                                       96
1062 C   91ZZDIFD        COMP      0                                      94
1063 C   94ZZDIFI        COMP      0                                    96
1064 C   96              MOVE      '.000-'       ZZNEGD            5
1065 C   91              GOTO      ZZCEND
1066 C*      END OF SPECIAL CASES
1067 C*
1068 C* IF ZZTOTALS EQ 'B' AND ZZINT,ZZDEC EQ 'A'   THEN -
1069 C*  TO COMPARE 'A' WITH 'B'
1070 C*     1. STORE ORIGINAL VALUE OF 'B'.
1071 C*     2. NEGATE 'A'.
1072 C*     3. ADD 'A' TO 'B'.
1073 C*     4. 'B' IS NOW THE DIFFERENCE. STORE 'B' IN FIELD 'C'.
1074 C*     5. RESTORE 'B'.
1075 C*            N.B. 'A' EQ ZZINT AND ZZDEC
1076 C*                 'B' EQ ZZTOTI AND ZZTOTD
1077 C*                 'C' EQ ZZDIFI AND ZZDIFD
1078 C*
1079 C*    STEP #1
1080 C                   Z-ADD     ZZTOTI        ZZSTRI           15 0
1081 C                   Z-ADD     ZZTOTD        ZZSTRD            3 0
1082 C*    STEP #2
1083 C                   Z-SUB     ZZINT         ZZAMTI           15 0
1084 C                   Z-SUB     ZZDEC         ZZAMTD            3 0
1085 C*    STEP #3
1086 C                   EXSR      GLZSUM
1087 C   99              GOTO      ZZQUIT
1088 C*    STEP #4
1089 C                   Z-ADD     ZZTOTI        ZZDIFI
1090 C                   MOVE      ZZTOTD        ZZDIFD
1091 C*    STEP #5
1092 C                   Z-ADD     ZZSTRI        ZZTOTI           15 0
1093 C                   Z-ADD     ZZSTRD        ZZTOTD            3 0
1094 C                   GOTO      ZZCEND                                       BYPASS ADMIT
1095 C     ZZQUIT        TAG                                                    ** ZZQUIT TAG**
1096 C                   Z-ADD     0             ZZDIFI
1097 C                   Z-ADD     0             ZZDIFD
1098 C     ZZCEND        ENDSR                                                  ** ZZCEND TAG**
1099 C*
1100 C********************************************************************
1101 C/SPACE 2
1102 C********************************************************************
1103 C**
1104 C*****ZSYSTM SR. TO CHAIN TO THE INSTALLATION CONTROL DATA RECORD.   S01194
1105 C**
1106 C***********ZSYSTM    BEGSR                           *** ZSYSTEM ***S01194
1107 C**
0175 C*****SET*UP*KEY*FOR*INSTALLATION*CONTROL*RECORD.                    S01194
0176 C*R*********          MOVEL'01      'ZTABKY 12                       S01194
0177 C*R*********          MOVE '  10'    ZTABKY                          S01194
0178 C**
1112 C***********ZTABKY    CHAINTABLE                99    ON NOT THERE   S01194
0181 C*RN99******RECI      COMP 'D'                  9999  ON, IS DELETED S01194
0182 C**
0183 C*****CHECK*SYSTEM DATE FORMAT, DDMMYY OR MMDDYY.                    S01194
0184 C*R*********DATF      COMP 'M'                      98MMDDYY, 98 ON  S01194
1117 C**
1118 C***********          ENDSR                                          S01194
1119 C**
1120 C**
1121 C********************************************************************
1122 C/EJECT
1123 O***  HEADINGS
1124 O*
1125 O*L0340P1E**203   80                                           S01124S01117
     O/COPY WNCPYSRC,GL0340O002
1125 OGL0340P1  E    80 25                  2 03                                S01117
     O/COPY WNCPYSRC,GL0340O003
1126 O***********                        22 'REFERENCE GL0340'            S01117
1126 O                                           24 'REFERENCE GL0340P1'        S01117
1127 O***********              TITL      89                               S01194
1127 O                       BJURPT              89                             S01194
1128 O                                          104 'DATE'
1129 O                       RUNA               113
1130 O                                          122 'PAGE'
1131 O                       PAGE               127
1132 O*
1133 O***
1134 O*
1135 O********E**1     80                                                 S01117
1135 O          E    80 25                  1                                   S01117
1136 O                                           69 'DAILY JOURNAL'
1137 O                 N51NLR                    73 '-'
1138 O**********       N51NLRCCYJ                77                                           CGL120
     O                 N51NLRCCYB                77                                           CGL120
1139 O***********           NLR          87 'BRANCH'                      S01117
1140 O***********           NLRBRCDJ     93                               S01117
     O                  59N58                    87 'BRANCH'                    S01117
     O**********        59N58BRCDJ               91                                    S01117 CGL120
     O                  59N58BRCDB               91                                           CGL120
     O                  59N58                    92 '-'                         S01117
     O                  59N58A8BRNM             122                             S01117
     O                  58                       93 'CONSOLIDATED'              S01117
1141 O*
1142 O***
1143 O*
1144 O********E**2     80                                                 S01117
1144 O********E**2     80 25                                              S01117             BUG9203
     O          E    80 25                  1                                                BUG9203
1145 O                                           69 '-------------'
1146 O*
     O          E    80 25                  2                                                BUG9203
     O                       POST(Z)             80                                          BUG9203
     O*                                                                                      BUG9203
1147 O**
1148 O*
1149 O          E    80N88N51               1
     O         AND   25                                                         S01117
1150 O                                            4 'ACCT'
1151 O                                           14 'CUSTOMER'
     O               27                          34 'PROFIT'                    120830
1152 O                                           41 'TRANS'
1153 O                                           49 'ITEM'
1154 O                                           56 'DEPT'
1155 O                                           64 'ASSOC'
1156 O                                           74 'VALUE'
     O/COPY WNCPYSRC,GL0340O004
1157 O                                           90 'NARRATIVE'
     O/COPY WNCPYSRC,GL0340O005
1158 O                                          126 'AMOUNT'
     O/COPY WNCPYSRC,GL0340O012
1159 O          E    80N88N51               2
     O         AND   25                                                         S01117
1160 O                                            4 'CODE'
     O               27                          34 'CENTRE'                    120830
1161 O                                           40 'TYPE'
1162 O                                           50 'IDENT'
1163 O                                           56 'CODE'
1164 O                                           63 'CUST'
1165 O                                           73 'DATE'
     O          E            DBERR       3                                      S01194
     O                                           77 '*** DATABASE ERROR ***'    S01194
     O          E            DBERR       3                                      S01194
     O                                           76 '*** END OF REPORT ***'     S01194
     O              N58 59                       69 '*** END OF REPORT FOR'     S01194
     O              N58 59                       76 ' BRANCH'                   S01194
     O**********    N58 59   BRCDJ               80                                    S01194 CGL120
     O              N58 59   BRCDB               80                                           CGL120
     O              N58 59                       84 '***'                       S01194
1166 O*
1167 O********H**203***OFN78***                                           E10125
     O********H**203   OFN78NL5                                    E10125 120830
     O/COPY WNCPYSRC,GL0340O006
     O          H    OFN78NL6               2 03                                120830
     O         AND   25                                                         S01117
1168 O***********                        22 'REFERENCE GL0340'            S01117
1168 O                                           24 'REFERENCE GL0340P1'        S01117
1169 O***********              TITL      89                               S01194
1169 O                       BJURPT              89                             S01194
1170 O                                          104 'DATE'
1171 O                       RUNA               113
1172 O                                          122 'PAGE'
1173 O                       PAGE               127
1174 O*
1175 O***
1176 O*
1177 O********H**1*****OFN78***                                           E10125
     O********H**1     OFN78NL5                                    E10125 120830
     O          H    OFN78NL6               1                                   120830
     O         AND   25                                                         S01117
1178 O                                           69 'DAILY JOURNAL'
1179 O***********                        87 'BRANCH'                      S01117
1180 O                 NLRN51                    73 '-'
1181 O**********       NLRN51CCYJ                77                                           CGL120
     O                 NLRN51CCYB                77                                           CGL120
1182 O***********              BRCDJ     92                               S01117
     O                  59N58                    87 'BRANCH'                    S01117
     O**********        59N58BRCDJ               91                                    S01117 CGL120
     O                  59N58BRCDB               91                                           CGL120
     O                  59N58                    92 '-'                         S01117
     O                  59N58A8BRNM             122                             S01117
     O                  58                       93 'CONSOLIDATED'              S01117
1183 O*
1184 O***
1185 O*
1186 O********H**2*****OFN78***                                           E10125
     O********H**2     OFN78NL5                                    E10125 120830
     O********H**2     OFN78NL6                                           120830             BUG9203
     O**********H    OFN78NL5               1                                         BUG9203 CGL120
     O          H    OFN78NL6               1                                                 CGL120
     O         AND   25                                                         S01117
1187 O                                           69 '-------------'
1188 O*
     O**********H    OFN78NL5               2                                         BUG9203 CGL120
     O          H    OFN78NL6               2                                                 CGL120
     O         AND   25                                                                      BUG9203
     O                       POST(Z)             80                                          BUG9203
1189 O**
1190 O*
1191 O          H    OFN88N51               1
1192 O*******AND******N78N41****                                          E10125
     O*******AND*     N78N41NL5                                    E10125 120830
     O         AND  N78N41NL6                                                   120830
     O         AND   25                                                         S01117
1193 O                                            4 'ACCT'
1194 O                                           14 'CUSTOMER'
     O               27                          34 'PROFIT'                    120830
1195 O                                           41 'TRANS'
1196 O                                           49 'ITEM'
1197 O                                           56 'DEPT'
1198 O                                           64 'ASSOC'
1199 O                                           74 'VALUE'
     O/COPY WNCPYSRC,GL0340O007
1200 O                                           90 'NARRATIVE'
     O/COPY WNCPYSRC,GL0340O008
1201 O                                          126 'AMOUNT'
     O/COPY WNCPYSRC,GL0340O013
1202 O          H    OFN88N51               2
1203 O*******AND******N78N41******                                        E10125
     O*******AND*     N78N41NL5                                    E10125 120830
     O         AND  N78N41NL6                                                   120830
     O         AND   25                                                         S01117
1204 O                                            4 'CODE'
     O               27                          34 'CENTRE'                    120830
1205 O                                           40 'TYPE'
1206 O                                           50 'IDENT'
1207 O                                           56 'CODE'
1208 O                                           63 'CUST'
1209 O                                           73 'DATE'
1210 O*
1211 O/SPACE 2
     O/COPY WNCPYSRC,GL0340O001
1212 O***  A/C CODE O/B
1213 O*
1214 O********D**1     81                                                 S01117
1214 O**********D    81 25                  1                                          S01117 CGL120
     O          EF           EXACOB         1                                                 CGL120
1215 O**********               ACODJ      4                                                   CGL029
     O                       ACODJ               10                                           CGL029
1216 O***********              ACKN      35                               S01194
1216 O***********              A5ACCN    35                        S01194 CSD005
1217 O***********                       106 'ACCOUNT CODE O/B'            S01290
     O**********      N73      A5ACCN    35                                            CSD005 CGL029
     O**********       73      A5NARR    56                                            CSD005 CGL029
     O              N73      A5ACCN              41                                           CGL029
     O               73      A5NARR              62                                           CGL029
     O/COPY WNCPYSRC,LUC110_055                                                               LUC110
1217 O                                          106 'O/B'                       S01290
1218 O               30      LDBL               128 '   ,   ,   ,   , 0 CR'
1219 O               31      LDBL               128 '  ,   ,   ,   , 0 . CR'
1220 O               32      LDBL               128 ' ,   ,   ,   , 0 .  CR'
1221 O               33      LDBL               128 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,LUC110_056                                                               LUC110
1222 O********D**1     81                                                 S01117
1222 O**********D    81 25                  1                                          S01117 CGL120
     O          EF           EXACOB         1                                                 CGL120
1223 O***********                        34 '------------------------'    S01290
1224 O***********                        35 '-'                           S01290
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0340OP11                                           S01408
     O*                                                                   S01408
     O                                           24 '------------------------'  S01290
     O                                           48 '------------------------'  S01290
     O                                           72 '------------------------'  S01290
     O                                           96 '------------------------'  S01290
     O                                          120 '------------------------'  S01290
     O                                          132 '------------'              S01290
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0340OP12                                           S01408
     O*                                                                   S01408
1225 O***
1226 O/SPACE 2
1227 O***  CUSTOMER NO. & NAME  AND A/C SEQ. O/B
1228 O*
1229 O********D**1     82                                                 S01117
1229 O**********D    82 25                  1                                          S01117 CGL120
     O          EF           EXCLOB         1                                                 CGL120
     O               59      BRCDJ                4                             S01117
     O               59                           5 '-'                         S01117
1230 O                       CNUMJ               11
1231 O                                           12 '-'
1232 O                       ACSQJ               14
1233 O***********              CRNM      35                               S01194
1233 O                       BBCRNM              35                             S01194
     O/COPY WNCPYSRC,LUC110_057                                                               LUC110
1234 O                                          106 'O/B'
1235 O               30      LDBE               128 '   ,   ,   ,   , 0 CR'
1236 O               31      LDBE               128 '  ,   ,   ,   , 0 . CR'
1237 O               32      LDBE               128 ' ,   ,   ,   , 0 .  CR'
1238 O               33      LDBE               128 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,LUC110_058                                                               LUC110
1239 O**
1240 O/SPACE 3
1241 O***  A/C SEQ. O/B
1242 O*
1243 O********D**1     83                                                 S01117
     O********D**1     83 25                                        S01117S01290
     O**********DF   83 25                  1                                          S01290 CGL120
     O          EF           EXASOB         1                                                 CGL120
     O               59      BRCDJ                4                             S01117
     O               59                           5 '-'                         S01117
1244 O                       CNUMJ               11
1245 O                                           12 '-'
1246 O                       ACSQJ               14
     O                       BBCRNM              35                                           209478
     O/COPY WNCPYSRC,LUC110_059                                                               LUC110
1247 O                                          106 'O/B'
1248 O               30      LDBE               128 '   ,   ,   ,   , 0 CR'
1249 O               31      LDBE               128 '  ,   ,   ,   , 0 . CR'
1250 O               32      LDBE               128 ' ,   ,   ,   , 0 .  CR'
1251 O               33      LDBE               128 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,LUC110_060                                                               LUC110
1252 O/SPACE 3
1253 O***  POSTING DETAILS
1254 O*
1255 O********DF*1     84                                                 S01117
1255 O********DF*1     84 25                                        S01117S01290
     O**********DF   84 25N15               1                                          S01290 CGL120
     O*********AND   04                                                                S01290 CGL120
     O          EF           EXPSDT         1                                                 CGL120
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0340OOP3                                           S01408
     O*                                                                   S01408
     O               27      PRFCJ               33                             120830
1256 O******                   TRAT      41                               S01099
1256 O               22      TRAT                41                             S01099
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0340OOP4                                           S01408
     O*                                                                   S01408
1257 O                       SPOS                50
1258 O                       DPMT                55
1259 O                    N37ASOC                64
1260 O                       ZADATE              75
     O/COPY WNCPYSRC,LUC110_061                                                               LUC110
1261 O                       PNAR               106
1262 O               30      PSTAS              128 ' ,   ,   ,   , 0 CR'
1263 O               31      PSTAS              128 '   ,   ,   , 0 . CR'
1264 O               32      PSTAS              128 '  ,   ,   , 0 .  CR'
1265 O               33      PSTAS              128 ' ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0340O009
     O*                                                                   120830
     O          EF           EXPRFC         1                                   120830
     O                                            6 '(NET)'                     120830
     O               30      TPRFC               28 '   ,   ,   ,   , 0 CR'     120830
     O               31      TPRFC               28 '  ,   ,   ,   , 0 . CR'    120830
     O               32      TPRFC               28 ' ,   ,   ,   , 0 .  CR'    120830
     O               33      TPRFC               28 '   ,   ,   , 0 .   CR'     120830
     O                       WPRFC               33                             120830
     O***********                        48 '-------------'        120830 127973
     O***********                        72 '--------------------- 120830 127973
     O***********                        96 '--------------------- 120830 127973
     O***********                       120 '--------------------- 120830 127973
     O***********                       132 '------------'         120830 127973
     O              N28                          48 '-------------'             127973
     O              N28                          72 '------------------------'  127973
     O              N28                          96 '------------------------'  127973
     O              N28                         120 '------------------------'  127973
     O              N28                         132 '------------'              127973
     O               28                          48 '*************'             127973
     O               28                          72 '************************'  127973
     O               28                          96 '************************'  127973
     O               28                         120 '************************'  127973
     O               28                         132 '************'              127973
     O*                                                                   S01290
     O/SPACE 2                                                            S01290
     O***  A/C SEQ. DEBIT BALANCE                                         S01290
     O*                                                                   S01290
     O          E    85 25N17               1                                   S01290
     O/COPY WNCPYSRC,LUC110_062                                                               LUC110
     O                                          106 'TOTAL OF ACCOUNT  DEBITS'  S01290
     O               30      PSTADR             128 '   ,   ,   ,   , 0 CR'     S01290
     O               31      PSTADR             128 '  ,   ,   ,   , 0 . CR'    S01290
     O               32      PSTADR             128 ' ,   ,   ,   , 0 .  CR'    S01290
     O               33      PSTADR             128 '   ,   ,   , 0 .   CR'     S01290
     O/COPY WNCPYSRC,LUC110_063                                                               LUC110
     O*                                                                   S01290
     O/SPACE 2                                                            S01290
     O***  A/C SEQ. CREDIT BALANCE                                        S01290
     O*                                                                   S01290
     O          E    85 25N16               1                                   S01290
     O/COPY WNCPYSRC,LUC110_064                                                               LUC110
     O                                          106 'TOTAL OF ACCOUNT CREDITS'  S01290
     O               30      PSTACR             128 '   ,   ,   ,   , 0 CR'     S01290
     O               31      PSTACR             128 '  ,   ,   ,   , 0 . CR'    S01290
     O               32      PSTACR             128 ' ,   ,   ,   , 0 .  CR'    S01290
     O               33      PSTACR             128 '   ,   ,   , 0 .   CR'     S01290
     O/COPY WNCPYSRC,LUC110_065                                                               LUC110
1266 O*
1267 O/SPACE 2
1268 O***  A/C SEQ. C/B
1269 O*
1270 O********E**1     85                                                 S01117
1270 O**********E    85 25                  1                                          S01117 CGL120
     O          EF   85 25                  1                                                 CGL120
     O/COPY WNCPYSRC,LUC110_066                                                               LUC110
1271 O                                          106 'C/B'
1272 O               30      TACSQ              128 '   ,   ,   ,   , 0 CR'
1273 O               31      TACSQ              128 '  ,   ,   ,   , 0 . CR'
1274 O               32      TACSQ              128 ' ,   ,   ,   , 0 .  CR'
1275 O               33      TACSQ              128 '   ,   ,   , 0 .   CR'
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0340OOP5                                           S01408
     O*                                                                   S01408
     O          E    85 25                  1                                   S01290
     O                                           24 '------------------------'  S01290
     O                                           48 '------------------------'  S01290
     O                                           72 '------------------------'  S01290
     O                                           96 '------------------------'  S01290
     O                                          120 '------------------------'  S01290
     O                                          132 '------------'              S01290
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0340OOP6                                           S01408
     O*                                                                   S01408
1276 O*
1277 O/SPACE 3
1278 O***  RETAIL A/C O/B
1279 O*
1280 O********E**1     86                                                 S01117
     O********E**1     86 25                                        S01117S01290
     O          EF   86 25                  1                                   S01290
1281 O***********                       106 'RETAIL ACCOUNT O/B'          S01290
     O/COPY WNCPYSRC,LUC110_067                                                               LUC110
     O                                           16 'RETAIL ACCOUNTS'           S01290
     O                                          106 'O/B'                       S01290
1282 O               30      REBAL              128 '   ,   ,   ,   , 0 CR'
1283 O               31      REBAL              128 '  ,   ,   ,   , 0 . CR'
1284 O               32      REBAL              128 ' ,   ,   ,   , 0 .  CR'
1285 O               33      REBAL              128 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,LUC110_068                                                               LUC110
1286 O*
1287 O**SUMMARY*OF*RETAIL*A/C'S                                           S01290
1288 O***********                                                         S01290
1289 O********E**1     86                                                 S01117
1289 O********E**1     86 25                                        S01117S01290
1290 O***********                       106 'RETAIL ACCOUNTS'             S01290
1291 O***********            30TPSTA    128 '   ,   ,   ,   , 0 CR'       S01290
1292 O***********            31TPSTA    128 '  ,   ,   ,   , 0 . CR'      S01290
1293 O***********            32TPSTA    128 ' ,   ,   ,   , 0 .  CR'      S01290
1294 O***********            33TPSTA    128 '   ,   ,   , 0 .   CR'       S01290
     O*                                                                   S01290
     O***  SUMMARY OF RETAIL ACCOUNTS (DEBIT BALANCES)                    S01290
     O*                                                                   S01290
     O          E    86 25N19               1                                   S01290
     O/COPY WNCPYSRC,LUC110_069                                                               LUC110
     O                                          106 'RETAIL ACCOUNT  DEBITS'    S01290
     O               30      TPSTDR             128 '   ,   ,   ,   , 0 CR'     S01290
     O               31      TPSTDR             128 '  ,   ,   ,   , 0 . CR'    S01290
     O               32      TPSTDR             128 ' ,   ,   ,   , 0 .  CR'    S01290
     O               33      TPSTDR             128 '   ,   ,   , 0 .   CR'     S01290
     O/COPY WNCPYSRC,LUC110_070                                                               LUC110
     O*                                                                   S01290
     O***  SUMMARY OF RETAIL ACCOUNTS (CREDIT BALANCES)                   S01290
     O*                                                                   S01290
     O          E    86 25N18               1                                   S01290
     O/COPY WNCPYSRC,LUC110_071                                                               LUC110
     O                                          106 'RETAIL ACCOUNT CREDITS'    S01290
     O               30      TPSTCR             128 '   ,   ,   ,   , 0 CR'     S01290
     O               31      TPSTCR             128 '  ,   ,   ,   , 0 . CR'    S01290
     O               32      TPSTCR             128 ' ,   ,   ,   , 0 .  CR'    S01290
     O               33      TPSTCR             128 '   ,   ,   , 0 .   CR'     S01290
     O/COPY WNCPYSRC,LUC110_072                                                               LUC110
     O*                                                                   120830
     O          E    86 25                  1                                   120830
     O                                            6 '(NET)'                     120830
     O               30      TPRFC               28 '   ,   ,   ,   , 0 CR'     120830
     O               31      TPRFC               28 '  ,   ,   ,   , 0 . CR'    120830
     O               32      TPRFC               28 ' ,   ,   ,   , 0 .  CR'    120830
     O               33      TPRFC               28 '   ,   ,   , 0 .   CR'     120830
     O                       WPRFC               33                             120830
     O***********                        48 '-------------'        120830 127973
     O***********                        72 '--------------------- 120830 127973
     O***********                        96 '--------------------- 120830 127973
     O***********                       120 '--------------------- 120830 127973
     O***********                       132 '------------'         120830 127973
     O              N28                          48 '-------------'             127973
     O              N28                          72 '------------------------'  127973
     O              N28                          96 '------------------------'  127973
     O              N28                         120 '------------------------'  127973
     O              N28                         132 '------------'              127973
     O               28                          48 '*************'             127973
     O               28                          72 '************************'  127973
     O               28                          96 '************************'  127973
     O               28                         120 '************************'  127973
     O               28                         132 '************'              127973
     O*                                                                   S01290
1295 O***  RETAIL A/C C/B
1296 O*
1297 O********E**1     86                                                 S01117
1297 O**********E    86 25                  1                                          S01117 CGL120
     O          EF   86 25                  1                                                 CGL120
     O/COPY WNCPYSRC,LUC110_073                                                               LUC110
1298 O                                          106 'C/B'
1299 O               30      TACOD              128 '   ,   ,   ,   , 0 CR'
1300 O               31      TACOD              128 '  ,   ,   ,   , 0 . CR'
1301 O               32      TACOD              128 ' ,   ,   ,   , 0 .  CR'
1302 O               33      TACOD              128 '   ,   ,   , 0 .   CR'
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0340OOP7                                           S01408
     O*                                                                   S01408
1303 O*
     O          E    86 25                  1                                   S01290
     O                                           24 '------------------------'  S01290
     O                                           48 '------------------------'  S01290
     O                                           72 '------------------------'  S01290
     O                                           96 '------------------------'  S01290
     O                                          120 '------------------------'  S01290
     O                                          132 '------------'              S01290
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0340OOP8                                           S01408
     O*                                                                   S01408
1304 O*
1305 O/SPACE 3
1306 O***  A/C CODE C/B
1307 O*
1308 O********E*12     87                                                 S01117
1308 O********E*12     87 25                                        S01117S01290
1308 O          EF   87 25               1  2                                   S01290
1309 O***********                       106 'ACCOUNT CODE C/B'            S01290
     O***********              A5ACCN   102                         S01290CSD005
     O/COPY WNCPYSRC,LUC110_074                                                               LUC110
     O              N73      A5ACCN             102                             CSD005
     O               73      A5NARR             102                             CSD005
     O                                          106 'C/B'                       S01290
1310 O               30      TACOD              128 '   ,   ,   ,   , 0 CR'
1311 O               31      TACOD              128 '  ,   ,   ,   , 0 . CR'
1312 O               32      TACOD              128 ' ,   ,   ,   , 0 .  CR'
1313 O               33      TACOD              128 '   ,   ,   , 0 .   CR'
     O*                                                                   S01290
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0340OOP9                                           S01408
     O*                                                                   S01408
     O          E    87 25                  2                                   S01290
     O                                           24 '========================'  S01290
     O                                           48 '========================'  S01290
     O                                           72 '========================'  S01290
     O                                           96 '========================'  S01290
     O                                          120 '========================'  S01290
     O                                          132 '============'              S01290
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0340OP10                                           S01408
     O*                                                                   S01408
1314 O*
1315 O/SPACE 3
1316 O***  CURRENCY TOTAL IF NOT ZERO
1317 O*
1318 O********EF3      79                                                 S01117
1318 O          EF   79 25               3                                      S01117
1319 O                                           29 '**********'
1320 O                                           53 'CURRENCY OUT OF BALANCE'
1321 O                                           56 'BY'
1322 O               30      TCCY                78 '   ,   ,   ,   , 0 CR'
1323 O               31      TCCY                78 '  ,   ,   ,   , 0 . CR'
1324 O               32      TCCY                78 ' ,   ,   ,   , 0 .  CR'
1325 O               33      TCCY                78 '   ,   ,   , 0 .   CR'
1326 O                                           89 '**********'
1327 O*
1328 O***  BRANCH CHANGE HASH TOTALS
1329 O*
1330 O*****   EF 233   51                                                 S01117
1330 O          EF   51 25                  2 33                                S01117
1331 O                                           15 'END OF BRANCH'
1332 O                                           27 'HASH TOTALS'
1333 O*
1334 O*****   E  2     51                                                 S01117
1334 O          E    51 25                  2                                   S01117
1335 O                                           36 'SOURCE OF POSTING'
1336 O                                           54 'NO.OF POSTINGS'
1337 O                                           79 'HASH TOTAL'
1338 O*
     O*                                                                   S01408
      *                                                                                       CGL030
     O          E            EECCC1         1                                                 CGL030
     O                       ARL1(Y)             42                                           CGL030
     O                       BRN1(Y)       3     48                                           CGL030
     O                       BR1I(Y)       3     76                                           CGL030
     O                       BR1D(Y)             79                                           CGL030
     O/COPY WNCPYSRC,GL0340OOPG                                           S01408
     O*                                                                   S01408
1339 O*****   E  1     52                                                 S01117
1339 O          E    52 25                  1                                   S01117
1340 O              N56      ARLT(X)             42
1341 O               56                          20 'OVERALL'
1342 O                       BRNP(X)       3     48
1343 O                       BRTI(X)       Z     76
1344 O                       BRTD(X)             79
     O*                                                                   127973
     O          T    L7 25 59            3                                      127973
     O         AND  N58 27 29                                                   127973
     O         OR    LR 25N59                                                   127973
     O         AND   27 29                                                      127973
     O         OR    LR 25 58                                                   127973
     O         AND   27 29                                                      127973
     O                                           48 '***** AT LEAST ONE ENTRY'  127973
     O                                           70 'IS POSTED TO BLANK OR'     127973
     O                                           89 'UNALLOCATED PROFIT'        127973
     O                                          102 'CENTRE *****'              127973
     O********T*3*     L6 25                                       S01117 120830
     O          T    L7 25               3                                      120830
     O         AND   59N58                                                      S01117
     O         AND  N38                                                                       CGL120
     O                                           69 '*** END OF REPORT FOR'     S01117
     O                                           76 'BRANCH'                    S01117
     O                       BRCDJ               80                             S01117
     O                                           84 '***'                       S01117
     O          T    LR 25N59            3                                      S01117
     O         OR    LR 25 58                                                   S01117
     O                                           76 '*** END OF REPORT ***'     S01117
1345 O*
1346 O*
1347 O/SPACE 2
1348 O*****END*OF*REPORT                                                  S01117
1348 O***  END OF REPORT HASH TOTALS AND FILE CONTROLS                    S01117
     O/COPY WNCPYSRC,GL0340O010
1132 O*                                                                   S01117
1125 OGL0340AU  E    88                     2 03                                S01117
     O/COPY WNCPYSRC,GL0340O011
1126 O                                           24 'REFERENCE GL0340AU'        S01117
1127 O                       BJURPT              89                             S01194
1128 O                                          104 'DATE'                      S01117
1129 O                       RUNA               113                             S01117
1130 O                                          122 'PAGE'                      S01117
1131 O                       PAGE1              127                             S01117
1132 O*                                                                   S01117
1133 O***                                                                 S01117
1134 O*                                                                   S01117
1135 O          E    88                     1                                   S01117
1136 O                                           69 'DAILY JOURNAL'             S01117
     O                                           85 'RUN CONTROLS'              S01117
1141 O*                                                                   S01117
1142 O***                                                                 S01117
1143 O*                                                                   S01117
1144 O********E**2     88                                                 S01117             BUG9203
     O          E    88                     1                                                BUG9203
1145 O                                           69 '-------------'             S01117
1349 O*
     O          E    88                     2                                                BUG9203
     O                       POST(Z)             80                                          BUG9203
      *                                                                                      BUG9203
1350 O********E**233   88                                                 S01117
1350 O          E    88                     2 13                                S01117
1351 O                                           15 'END OF REPORT'
1352 O                                           27 'HASH TOTALS'
1353 O*
1354 O          E    88                     2
1355 O                                           36 'SOURCE OF POSTING'
1356 O                                           54 'NO.OF POSTINGS'
1357 O                                           79 'HASH TOTAL'
1358 O*
     O*                                                                   S01408
     O          E            EECCC2         1                                                 CGL030
     O                       ARL1(Y)             42                                           CGL030
     O                       ARN1(Y)       3     48                                           CGL030
     O                       AR1I(Y)       3     76                                           CGL030
     O                       AR1D(Y)             79                                           CGL030
     O/COPY WNCPYSRC,GL0340OOP1                                           S01408
     O*                                                                   S01408
1359 O          E    89                     1
1360 O              N56      ARLT(X)             42
1361 O               56                          20 'OVERALL'
1362 O                       ARNP(X)       3     48
1363 O                       ARTI(X)       Z     76
1364 O                       ARTD(X)             79
     O               38   N63                   106 '*** NO DETAILS TO REPORT'  S01117
     O               38   N63                   110 '***'                       S01117
1365 O/SPACE 2
1366 O***  F I L E    C O N T R O L S
1367 O***
1368 O********T**253   LR                                                 E16448
1368 O********T**246** LR                                           E16448S01117
1368 O**********T    LR                     2 43                                       S01117 CGL120
1369 O***********                        38 'POSTING FILE CONTROLS'       E16448
1369 O**********                                 26 'POSTING FILE CONTROLS -'          E16448 CGL120
     O***********                        38 'INPUT'                       E16448
     O**********     58                          38 'INPUT'                            S01117 CGL120
     O**********     57                          38 'INPUT'                            S01117 CGL120
     O**********    N59                          38 'INPUT'                            S01117 CGL120
     O***********              NOREP 3   48                               E16448
     O**********     58      NOREP         3     48                                    S01117 CGL120
     O**********     57      NOREP         3     48                                    S01117 CGL120
     O**********    N59      NOREP         3     48                                    S01117 CGL120
     O***********              DEC,3     79 '0   '                        E16448
     O**********     58      DEC(3)              79 '0   '                             S01117 CGL120
     O**********     57      DEC(3)              79 '0   '                             S01117 CGL120
     O**********    N59      DEC(3)              79 '0   '                             S01117 CGL120
     O***********              INT,3 Z   76                               E16448
     O**********     58      INT(3)        Z     76                                    S01117 CGL120
     O**********     57      INT(3)        Z     76                                    S01117 CGL120
     O**********    N59      INT(3)        Z     76                                    S01117 CGL120
     O**********T    LR                     3                                          E16448 CGL120
     O**********                                 38 'CALCULATED'                       E16448 CGL120
1370 O***********              NOREP 3   48                               S01117
1370 O**********     58      NOREP         3     48                                    S01117 CGL120
1370 O**********     57      NOREP         3     48                                    S01117 CGL120
1370 O**********    N59      NOREP         3     48                                    S01117 CGL120
1371 O**********             DEC(4)              79 '0   '                                    CGL120
1372 O**********             INT(4)        Z     76                                           CGL120
1373 O**********     46                         106 '***  OUT OF BALANCE  ***'                CGL120
1374 O**********T    LR                     2                                                 CGL120
1375 O**********                                 27 'BALANCE FILE CONTROLS'                   CGL120
1376 O***********                        53 'INPUT'                       S01117
1376 O**********     58                          53 'INPUT'                            S01117 CGL120
1376 O**********     57                          53 'INPUT'                            S01117 CGL120
1376 O**********    N59                          53 'INPUT'                            S01117 CGL120
1377 O**********                                 79 'CALCULATED'                              CGL120
1378 O**********T    LR                     2                                                 CGL120
1379 O**********                                 28 'VALUE OF RECORDS DR'                     CGL120
1380 O***********              DEC,1     53 '0   '                        S01117
1381 O***********              INT,1 Z   50                               S01117
1380 O**********     58      DEC(1)              53 '0   '                             S01117 CGL120
1380 O**********     57      DEC(1)              53 '0   '                             S01117 CGL120
1380 O**********    N59      DEC(1)              53 '0   '                             S01117 CGL120
1381 O**********     58      INT(1)        Z     50                                    S01117 CGL120
1381 O**********     57      INT(1)        Z     50                                    S01117 CGL120
1381 O**********    N59      INT(1)        Z     50                                    S01117 CGL120
1382 O**********             DEC(5)              79 '0   '                                    CGL120
1383 O**********             INT(5)        Z     76                                           CGL120
1384 O**********     47                         106 '***  OUT OF BALANCE  ***'                CGL120
1385 O**********T    LR                     2                                                 CGL120
1386 O**********                                 28 'CR'                                      CGL120
1387 O***********              DEC,2     53 '0   '                        S01117
1388 O***********              INT,2 Z   50                               S01117
1387 O**********     58      DEC(2)              53 '0   '                             S01117 CGL120
1387 O**********     57      DEC(2)              53 '0   '                             S01117 CGL120
1387 O**********    N59      DEC(2)              53 '0   '                             S01117 CGL120
1388 O**********     57      INT(2)        Z     50                                    S01117 CGL120
1388 O**********     58      INT(2)        Z     50                                    S01117 CGL120
1388 O**********    N59      INT(2)        Z     50                                    S01117 CGL120
1389 O**********             DEC(6)              79 '0   '                                    CGL120
1390 O**********             INT(6)        Z     76                                           CGL120
1391 O**********     43                         106 '***  OUT OF BALANCE  ***'                CGL120
1392 O/SPACE 2
1393 O***  ONE CCY OUT OF BALANCE
1394 O*
1395 O          T    LR U8               2  0
1396 O                                           26 '****************'
1397 O                                           53 'AT LEAST ONE CURRENCY IS'
1398 O                                           77 'OUT OF BALANCE - DO NOT'
1399 O                                           97 'CONTINUE PROCESSING'
1400 O                                          118 '****************'
0375 O          T    LR 63               2  1                                   S01194
0376 O                                           42 '*** REFERENCE'             S01194
0377 O                       DBPGM               53                             S01194
0378 O                                           71 '-DATABASE ERROR AT'        S01194
0379 O                       DBASE               75                             S01194
0380 O          T    LR 63                  1                                   S01194
0381 O                                           37 'FILE NAME'                 S01194
0382 O                       DBFILE              48                             S01194
0383 O                                           52 'KEY'                       S01194
0384 O                       DBKEY               82                             S01194
1401 O*
1402 O********T*2*     LR                                                 S01117
1403 O***********                        70 '*** END OF REPORT ***'       S01117
      /COPY WNCPYSRC,GL0340OOP2                                           S01408
**CTDATA ARL1
SUNDRY
SBCS TRANSACTION
**CTDATA ARG1
@2
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
**CTDATA ZYDY
0366073110961461
**CTDATA ZMDY
000031059090120151181212243273304334365
**CTDATA ZMNM
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**CTDATA ARGP
 OEICDFRXPQUSMYGTHAJKBNVZL                                                      CRE004 CGL047 CAP204
**CTDATA ARLT
BATCH INPUT
STANDING ORDERS              O
CUSTOMER EXCHANGES           E
POSTING TO INCOME AND EXPENSEI
INTEREST CAPITALIZATION      C
DEALS                        D
FORWARD REVALUATIONS         F
SPOT REVALUATIONS            R
TRANSFER OF F/C INC AND EXP  X
FIXED ACCOUNT CHARGES        P
STATEMENT CHARGES            Q
CUSTOMER LENDING             U
SECURITIES TRADING           S
AMOUNT ACCRUALS              M
TRANSFER BASE CCY INC/EXP    Y
FUNDS TRANSFER               G                                            S03220
FUTURES AND OPTIONS          T                                            S01127
CHIPS/MIDAS                  H                                            S01427
NUMBERED ACCOUNTS            A                                            S01421
HOLD MAIL                    J                                            S01421
PROFIT CENTRE ACCOUNTING     K                                            S01421
SAFE CUSTODY FEES            B                                            S01464
TELLER TRANSACTION           N                                            CRT001
SWEEP ACCOUNTING             V                                            CRE004
GENERIC POSTING INTERFACE    Z                                                                CGL047
ACCOUNT TRANSFER             L                                                                CAP204
**CTDATA POST
DAILY POST                                                                                   BUG9203
SPOT REVALUATION                                                                             BUG9203
B/CCY TRANSFER                                                                               BUG9203
F/CCY TRANSFER                                                                               BUG9203
FINAL POST                                                                                   BUG9203
F/CCY TRANSFER                                                                               CGL049
STAMP TAX                                                                                   MD037383
