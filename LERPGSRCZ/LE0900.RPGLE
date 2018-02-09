     H DEBUG
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       CLE137
/*STD *  RPGBASEBNC                                                   *                       CLE137
/*EXI *  TEXT('Midas LE Matured Loans History Processing')            *
0001 H***********
0002 F*****************************************************************
0003 F*                                                               *
     F*  Midas  -  Customer Lending Module                            *
0005 F*                                                               *
0006 F*  LE0900  -  PROCESS MATURED LOANS HISTORY                     *
0007 F*                                                               *
      *  (c) Finastra International Limited 2001                      *
0009 F*                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE154             Date 07Aug12               *
      *                 MD024133           Date 30Apr14               *
      *                 MD023534           Date 30Apr14               *
      *                 MD023031           Date 22Apr14               *
      *                 MD024318           Date 13Jan14               *
      *                 CLE137             Date 06Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 262540             Date 16Dec08               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG7415            Date 14Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE028             Date 27Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 193947             Date 31May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 157669             Date 07Dec00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD007             Date 28Aug00               *
      *                 182576             Date 28Sep00               *
      *                 180667             Date 19Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 159255             Date 10May99               *
     F*                 CLE005             DATE 22MAY97               *
     F*                 CLE004             DATE 16MAY97               *
     F*                 115248             DATE 17FEB97               *
     F*                 CAC001             DATE 13AUG96               *
     F*                 S01408             DATE 13JUN96               *
     F*                 071533             DATE 14JUL94               *
     F*                 070340             DATE 14JUN94               *
     F*                 060423             DATE 11AUG94               *
     F*                 059865             DATE 25AUG93               *
     F*                 E39485             DATE 13OCT92               *
     F*                 S01392             DATE 05OCT92               *
     F*                 BHF821             DATE 31MAR92               *
     F*                 S10227             DATE 11JUN91               *
     F*                 LN0788             DATE 28SEP90               *
     F*                 S01270             DATE 17SEP90               *
     F*                 BHF114             DATE 08JUN90               *
     F*                 BHF111             DATE 08JUN90               *
     F*                 S01194             DATE 17JAN90               *
     F*                 S01117             DATE 08/11/89              *
0009 F*                 E47241             DATE 23/10/86              *
0009 F*                                                               *
0009 F*---------------------------------------------------------------*
0009 F*                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  MD024133 - LEC06A failed due to FOOB in BoM CoB              *
      *  MD023534 - LEMAT is access with previous loan number avoiding*
      *             drop to occur and overwrite RECI so no loan are   *
      *             matured.                                          *
      *           - Only HMF is read causing event to not be dropped  *
      *             and monthly figures to be incorrect.              *
      *           - Ensure commit trailer update, and change of key   *
      *             is processed at correct time.                     *
      *  MD023031  - Prevent Decimal Data Errors and Null Audit Rpts  *
      *  MD024318 - COB Component LEC1001 00001 ends in error         *
      *  CLE137 - LE History Monthly Processing (task split)          *
      *         - Incorporate AR858124                                *
      *  CLE148 - Alpha Loan Reference                                *
      *  CRE073 - Interest Rate Rounding                              *
      *  262540 - Incorrect accrual due to incorrect value of fields  *
      *           added by CAS005. Increase lenght of HISTS* files.   *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  BUG7415 - History Card printing of loans transferred to      *
      *            LE0901. Print matured loans on month-end of        *
      *            maturing month.                                    *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
     F*  193947 - Customer town being overwritten                     *
     F*  157669 - Cost of Funds are being reported incorrectly        *
     F*           Record lengths increased by additional Cost of Fund *
     F*           fields in HISTS*                                    *
      *  CSD007 - Customer Closing                                    *
     F*  182576 - Recompile over changed version of HISTS             *
      *  180667 - Users cannot change printer file length - remove    *
      *           L-specs and amend printer file definitions.         *
      *  159255 - Show the original borrower name on the loan         *
      *           activity enquiry & on the loan history cards        *
     F*  CLE005 - Customer Lending Enhancements - Others (T3)         *
     F*  CLE004 - Syndications and Authorisation                      *
     F*  115248 - Record lengths increased by CLE003 development      *
     F*           must be taken into account here                     *
     F*  CAC001 - Profit Centre Accounting Development:               *
     F*           Output Funding Information fields to history files. *
     F*           Spread/Rate change ('SC') & Manual Adjustment ('MI')*
     F*           only reported for interest.  No funding details     *
     F*           are shown on the report.                            *
     F*  S01408 - Core hook LE0900FFP1 added.                        *
     F*           Core hook LE0900CCP1 added.                         *
     F*           Core hook LE0900CCP2 added.                         *
     F*           Core hook LE0900CCP3 added.                         *
     F*           Core hook LE0900CCP4 added.                         *
     F*           Note Hooks LE0900EEP1 , LE0900EEP2 & LE0900EEP3 are *
     F*           required for correct installation).                 *
     F*  071533  -  BHF821 forgot to change the position of one of    *
     F*             the CNUMH to be written in MNHSTMN, this results  *
     F*             to incorrect values reported in LE0870P1.         *
     F*  070340  -  Wrong currency is used on history card.  Program  *
     F*             should output CCYH from History Loan Header       *
     F*             instead of CCY.                                   *
     F*  060423 - Processing type from wrong file being used          *
     F*           (Applied fix 057262)                                *
     F*  059865 - PROCESSING TYPE SHOULD TAKE FROM FILE HISTS FIELD   *
     F*           PTYPH INSTEAD OF PTYP.                              *
     F*  E39485 - SPACING INCORRECT ON HISTORY CARDS                  *
0009 F*  BHF821 - CUSTOMER OF LOAN FIELD OUTPUT AT WRONG PLACE        *
0009 F*  S10227 - RETAIN MATURED LOAN HISTORY                         *
0009 F*  LN0788 - ACCESS SDBANKPD WHEN NO DETAILS TO REPORT           *
0009 F*           ALSE REMOVE REFERENCE 'NO DETAILS TO REPORT'        *
     F*           FROM LE0900AU                                       *
     F*  S01270 - CUSTOMER LENDING AMENDMENTS                         *
     F*  BHF114 - DOES NOT NEED SEQ AS A PASSED PARAMETER             *
     F*  BHF111 - RUNDAT DATA STRUCTURE DOES NOT INCLUDE DATA         *
     F*         - STRUCTURE FOR LENDING HEADER                        *
     F*  S01194 - STANDING DATA CHANGES                               *
     F*  S01117 - MULTIBRANCHING                                      *
0009 F*  E47241 - DATABASE ERROR ARISES DUE TO CHANGES MADE IN        *
0009 F*           LE0450 BY PREVIOUS FIX E47212 WHENEVER LOAN         *
0009 F*           HAS MATURED WITH OUTSTANDING PARTS SOLD.            *
     F*                                                               *
0011 F*****************************************************************
0012 F***MATLS** IP AF     128 15AI     2 DISK                                                CER020
     F***MATLS**   IP   F  135     7AIDISK    KEYLOC(2)                                CER020 CLE137
     FLEHISUPD  UF   E           K DISK    COMMIT USROPN                                      CLE137
     FLEMATXL0  IF   F  128     6AIDISK    KEYLOC(11)                                         CLE137
0013 F***HISTS***IS*AF     100 25AI     2 DISK                            CAC001
     F****HISTS   IS AF     118 25AI     2 DISK                    CAC001 115248
     F****HISTS   IS AF     152 25AI     2 DISK                    115248 157669
     F***HISTS** IS AF     179 25AI     2 DISK                                         157669 CLE028
     F***HISTS** IS AF     185 25AI     2 DISK                                        CLE028 BUG7415
     F*HISTS***IS*AF*****179 25AI     2 DISK                                          BUG7415 CLE042
     F***HISTS   IS AF     231 25AI     2 DISK                                         CLE042 CRE073
     F***HISTS**   IS  AF  247    25AIDISK    KEYLOC(2)                                CRE073 CLE137
     FHISTS     UF   E           K DISK    COMMIT IGNORE(HISTSHHF:HISTSZXF)                   CLE137
0014 F*TABLE***IF**F      96 12AI     2 DISK                              S01194
0015 F*CLINT***IF**F     256  7AI     2 DISK                              S01194
0016 F***HIUPDHH   O    F  100        DISK                                                    CLE137
     F***HIUPDHM*O***F     100            DISK                            CAC001
     F***HIUPDHN*O***F     100            DISK                            CAC001
     F***HIUPDHP*O***F     100            DISK                            CAC001
     F***HIUPDHQ*O***F     100            DISK                            CAC001
     F****HIUPDHM O   F     118            DISK                    CAC001 115248
     F****HIUPDHM O   F     152            DISK                    115248 157669
     F*HIUPDHM*O***F*****179            DISK                                           157669 CLE042
     F***HIUPDHM O   F     218            DISK                                         CLE042 CRE073
     F***HIUPDHM   O    F  247        DISK                                             CRE073 CLE137
     F***HIUPDHN O   F     118            DISK                                         CAC001 262540
     F***HIUPDHN O   F     132            DISK                                         262540 CRE073
     F***HIUPDHN   O    F  161        DISK                                             CRE073 CLE137
     F****HIUPDHP O   F     107            DISK                    CAC001 115248
     F****HIUPDHP O   F     141            DISK                    115248 CLE004
     F****HIUPDHP O   F     150            DISK                    CLE004 157669
     F***HIUPDHP O   F     177            DISK                                         157669 CLE028
     F***HIUPDHP O   F     185            DISK                                        CLE028 BUG7415
     F*HIUPDHP*O***F*****177            DISK                                          BUG7415 CLE042
     F***HIUPDHP   O    F  231        DISK                                             CLE042 CLE137
     F****HIUPDHQ O   F     113            DISK                    CAC001 115248
     F****HIUPDHQ O   F     147            DISK                    115248 CLE004
     F****HIUPDHQ O   F     151            DISK                    CLE004 157669
     F***HIUPDHQ O   F     178            DISK                                         157669 262540
     F***HIUPDHQ O   F     206            DISK                                         262540 CRE073
     F***HIUPDHQ   O    F  235        DISK                                             CRE073 CLE137
     F***HIUPDZX   O    F  100        DISK                                                    CLE137
     F***MHISTHM*O***F     100            DISK                     S10227 CAC001
     F***MHISTHN*O***F     100            DISK                     S10227 CAC001
     F***MHISTHP*O***F     100            DISK                     S10227 CAC001
     F***MHISTHQ*O***F     100            DISK                     S10227 CAC001
     F****MHISTHM O   F     118            DISK                    CAC001 115248
     F****MHISTHM O   F     152            DISK                    115248 157669
     F*MHISTHM*O***F*****179            DISK                                           157669 CLE042
     F***MHISTHM O   F     218            DISK                                         CLE042 CRE073
     F***MHISTHM   O    F  247        DISK                                             CRE073 CLE137
     FMHISTHM   O    E             DISK    COMMIT RENAME(HISTSHMF:MHISTSHMF)                  CLE137
     F***MHISTHN O   F     118            DISK                                         CAC001 262540
     F***MHISTHN O   F     132            DISK                                         262540 CRE073
     F***MHISTHN   O    F  161        DISK                                             CRE073 CLE137
     FMHISTHN   O    E             DISK    COMMIT RENAME(HISTSHNF:MHISTSHNF)                  CLE137
     F****MHISTHP O   F     107            DISK                    CAC001 115248
     F****MHISTHP O   F     141            DISK                    115248 CLE004
     F****MHISTHP O   F     150            DISK                    CLE004 157669
     F*MHISTHP*O***F*****177            DISK                                           157669 CLE042
     F***MHISTHP   O    F  231        DISK                                             CLE042 CLE137
     FMHISTHP   O    E             DISK    COMMIT RENAME(HISTSHPF:MHISTSHPF)                  CLE137
     F****MHISTHQ O   F     113            DISK                    CAC001 115248
     F****MHISTHQ O   F     147            DISK                    115248 CLE004
     F****MHISTHQ O   F     151            DISK                    CLE004 157669
     F***MHISTHQ O   F     178            DISK                                         157669 262540
     F***MHISTHQ O   F     206            DISK                                         262540 CRE073
     F***MHISTHQ   O    F  235        DISK                                             CRE073 CLE137
     FMHISTHQ   O    E             DISK    COMMIT RENAME(HISTSHQF:MHISTSHQF)                  CLE137
0017 F***MNHSTHH   O    F   64        DISK                                                    CLE137
     F***MNHSTMN   O    F   64        DISK                                                    CLE137
     FMNHSTMN   O    F   64        DISK    COMMIT                                             CLE137
     F/COPY WNCPYSRC,LE0900F002
     F***MNHSTT2   O    F   64        DISK                                                    CLE137
     FLEHISTPD  UF A E             DISK    COMMIT                                             CLE137
     FLEHIDTPD  UF A E             DISK    COMMIT                                             CLE137
     F/COPY WNCPYSRC,LE0900FFP1                                           S01408
     F***LE0900AU  O    F  132        PRINTER INFDS(SPOOLU)                          180667 MD023031
     F***LE0900P1O   F     132     OF     PRINTER      KINFDS SPOOL      UC           180667 BUG7415
0018 F*E0900P2O** F     132           LPRINTER                  S01124    S01117
0018 F*E0900AUO***F     132           LPRINTER      KINFDS SPOOLU  S01117 180667
0018 F*E0900P1O** F      90     OF    LPRINTER                  S01124    S01117
0018 F*E0900P1O***F      90     OF    LPRINTER      KINFDS SPOOL      UC  180667
0019 F* ID F  C  H  L    FUNCTION OF INDICATORS
0020 F* 01            MATURED LOANS FILE - HEADER
0021 F* 02            HISTORY FILE HEADER
0022 F* 03            MATURED LOAN DETAIL
0023 F* 04            HISTORY LOAN HEADER LIVE
0024 F* 05               "     "      "   MATURED
0025 F* 06               "     "   AMOUNT RECORD LIVE
0026 F* 07               "     "     "      "    MATURED
0027 F* 08            MATURED LOAN TRAILER
0028 F* 09            HISTORY TRAILER
0029 F**11**********  TALBE FILE ICDR1                                    S01194
0030 F**12**********  TABLE FILE CURRENCIES 1                             S01194
0031 F* 13            HISTORY RATES DETAIL LIVE
0032 F* 14            HISTORY RATES DETAIL MATURED
0033 F* 15            HISTORY RATES CATCHALL
0034 F* 16            HISTORY BV/INT HEADER LIVE
0035 F* 17            HISTORY BV/INT HEADER MATURED
0036 F*
     F*       20      END OF BRANCH REPORT OUTPUT INDICATOR               S01117
     F*       21      MULTIBRANCHING OUTPUT                               S01117
0037 F*       22      PREMIUM LOAN
0038 F*       23      DISCOUNTED LOAN
0039 F*       24      0 DECIMAL PLACE CURRENCY
0040 F*       25      1 DECIMAL
0041 F*       26      2 DECIMALS
0042 F*       27      3 DECIMALS
     F*    30           CLE005 is installed                           *   CLE005
0043 F*       33      HISTORY FILE CONTROLS DIFFER
0044 F*       34      MATLN FILE CONTROLS DIFFER
     F*       35      MULTIBRANCHING IS YES                               S01117
0044 F*       37      NO DETAILS TO REPORT                                S01117
     F/COPY WNCPYSRC,LE0900F001
0045 F*       40      MONTH ARRAY LOKUP
0046 F*       41      LOAN STARTED BEFORE THIS MONTH CALC START BAL
0047 F*       42      LOAN STARTED THIS MONTH
0048 F*       43      BEGINNING BALANCE REACHED FOR LOAN THIS MONTH
0049 F*       44      AMENDMENT WILL INCREASE BALANCE
0050 F*       45      LOAN BALANCE FORCED BY NEWLOAN READ
0051 F*       46      OUTPUT HEADINGS
0052 F********47****  DATABASE ERROR - TABLE FILE                         S01194
0053 F*       48      VALUE DATE > ZERO (HEADER)
0054 F*       49      MATURITY DATE > ZERO
0055 F*       50      EXPECTED DATE > ZERO
0056 F*       51      VALUE DATE > ZERO (DETAIL)
0057 F*       52      'ADD' SPREAD INDICATOR
0058 F*       53      'SUBTRACT'
0059 F*       54      'PERCENTAGE'
0060 F*       55      'AMOUNT' ON OUTPUT LINE EDITED FOR RATES - 7 DEC,
0061 F*       56      SORTS OUT AMENDMENT TYPE
0062 F*       57      PRINT A DETAIL LINE BY EXCEPTION
0063 F*       58      PRINCIPAL AMOUNT - ZERO
0064 F*       59      PRINCIPAL AMOUNT - > ZERO
0065 F*       60      INTEREST AMOUNT  - > ZERO
0066 F*       61      WITHOLDING TAX AMOUNT - > ZERO
0067 F*       62      PRINCIPAL AMOUNT - > ZERO
0068 F*       63      REPAYMENT IS PAST DUE
0069 F*       64      PRINT EXTRA FIELDS FOR MATURITY REPAYMENT
0070 F*       65      INTEREST AMOUNT - > ZERO
0071 F*       66      WITHOLDING TAX  - > ZERO
0072 F*       67      FEE AMOUNT - > ZERO
0073 F*       68      PRINCIPAL AMOUNT - > ZERO
0074 F*       69      INTEREST AMOUNT - > ZERO
0075 F*       70      WITHOLDING TAX - > ZERO
0076 F*       71      BASE RATE - > ZERO
0077 F*       72      BASE RATE - ZERO
0078 F*       73      SPREAD - > OR = ZERO
0079 F*       74      SPREAD - > ZERO
0080 F*       75      ST ACCRUAL IND IS 'Y'
0081 F*       76      ST ACCRUAL IND IS BLANK
0082 F*       77      BASE RATE IS > ZERO
0083 F*       78      BASE RATE IS = ZERO
0084 F*       79      SPREAD - > ZERO
0085 F*       80      SPREAD - > ZERO
0086 F********81****  CLIENT FILE CHAIN FILE - DATABASE ERROR             S01194
0087 F*       82      REC > LAST DAY IN MONTH ... IGNORE
0088 F*       83      INTEREST CAPITALISATION IS USED ON THIS LOAN
      *  84 - Print the Original Borrower                             *   159255
     D***/COPY*ZSRSRC,ZDATE2Z1                                                         S01392 CLE137
     D/COPY ZSRSRC,ZDATE2Z1LE                                                                 CLE137
0092 D ZFMD            S              2    DIM(12) CTDATA PERRCD(12)            ZFREQ SR ARRAY
0093 D******************  NARR    1  35 30               NARRATIVES       S01270
     D***/COPY*WNCPYSRC,LE0900E001                                                           BUG7415
     D**********          NARR    1  36 30               NARRATIVES                    S01270 CLE028
     D**********          NARR    1  38 30               NARRATIVES                   CLE028 BUG7415
     D***/COPY*WNCPYSRC,LE0900E002                                                           BUG7415
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D RUNDT           DS                                                       S01117
      **  DATA AREA RUNDAT                                                S01117
     D  RUNA                   1      7                                         S01117
0376 D  WDAY                   1      2  0                                      S01117
0377 D  WMNT                   3      5                                         S01117
0378 D  WYER                   6      7  0                                      S01117
     D  RUND                   8     10P 0                                      S01117
     D  SSF                   11     11                                         S01117
     D  DATF                  12     12                                         S01117
     D  MBIN                  13     13                                         S01117
     D ENDKEY          DS                                                                     CLE137
      ** End Record Key Data Structure                                                        CLE137
     D  EBRCA                  1      3                                                       CLE137
     D  ECNUM                  4      9                                                       CLE137
     D  ELNRF                 10     15                                                       CLE137
     D NXTKEY          DS                                                                     CLE137
      ** Next Record Key Data Structure                                                       CLE137
     D  BRCAK                  1      3                                                       CLE137
     D  CNUMK                  4      9                                                       CLE137
     D  LNRFK                 10     15                                                       CLE137
     D LSTKEY          DS                                                                     CLE137
      ** Last Record Key Data Structure                                                       CLE137
     D  LBRCA                  1      3                                                       CLE137
     D  LCNUM                  4      9                                                       CLE137
     D  LLNRF                 10     15                                                       CLE137
0369 D***DATA*STRUCTURE FOR                                               S01194
0370 D************CUSTOMER FILE KEY                                       S01194
0371 D************DS                                                      S01194
0372 D**************                         18  230CNUMH                 S01194
0373 D**************                         24  24 AY                    S01194
0374 D**************                         18  24 CLIKEY                S01194
0375 D*********** RUN DATE                                                S01117
0376 D***********                            25  260WDAY                  S01117
0377 D***********                            27  29 WMNT                  S01117
0378 D***********                            30  310WYER                  S01117
0379 D***********                            25  31 RUNA                  S01117
0380 D**         LOAN HEADER
     D                 DS                                                       BHF111
0381 D**********                             32  370FCUSH                                     CSD027
0381 D  FCUSH                 32     37
0382 D  FTYPH                 38     40  0
0383 D  FSEQH                 41     42  0
0384 D***********                            43  450BRCDH                 S01117
0384 D  BRCAH                 43     45                                         S01117
0385 D  ZEROS                 46     57  0
0386 D**********                             58  630LNRFH                                     CLE148
     D  LNRFH                 58     63
0387 D  CCYH                  64     66
0388 D  PTYPH                 67     68  0
0389 D  LHED                  32     68
0390 D** LOCAL DATA AREA FOR DATABASE ERROR
0391 D LDA            UDS           256
0392 D***********                           134 138 DBFILE                S01117
0393 D***********                           139 167 DBKEY                 S01117
0394 D***********                           168 175 DBPGM                 S01117
0395 D***********                           176 1770DBASE                 S01117
     D  DBFILE               134    141                                         S01117
     D  DBKEY                142    170                                         S01117
     D  DBPGM                171    180                                         S01117
     D  DBASE                181    183  0                                      S01117
     D*                                                                   S01117
     D**   FILE INFORMATION DATA STRUCTURE                                S01117
     D*                                                                   S01117
     D SPOOL           DS                                                       S01117
     D  SFILE                 83     92                                         S01117
     D  SFNUM                123    124B 0                                      S01117
     D*                                                                   S01117
     D**   FILE INFORMATION DATA STRUCTURE                                S01117
     D*                                                                   S01117
     D SPOOLU          DS                                                       S01117
     D  SFILEU                83     92                                         S01117
     D  SFNUMU               123    124B 0                                      S01117
     D**                                                                  S01194
     D CBTASK        E DS                  EXTNAME(CBTASKSP)                                  CLE137
      **  Commitment Control Size                                                             CLE137
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                    S01194
      **  EXTERNAL DS FOR BANK DETAILS                                    S01194
     D  TITL         E                     EXTFLD(BJURPT)                       S01194
      **                                                                  S01117
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                    CAC001
      **  EXTERNAL DS FOR MODULE DETAILS                                  CAC001
      *                                                                   CAC001
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                    S01117
      **  EXTERNAL DS FOR BRANCH CODE DETAILS                             S01117
     D  BRNM         E                     EXTFLD(A8BRNM)                       S01117
     D**                                                                  S01194
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                    S01194
      **  EXTERNAL DS FOR CURRENCY DETAILS                                S01194
     D  CDP          E                     EXTFLD(A6NBDP)                       S01194
     D**                                                                  S01194
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    S01194
      **  EXTERNAL DS FOR CUSTOMER DETAILS                                S01194
     D  DFAC01       E                     EXTFLD(QQDFAC)
     D  CRNM         E                     EXTFLD(BBCRNM)                       S01194
     D  CTWN         E                     EXTFLD(BBCRTN)                       S01194
     D**                                                                  S01194
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01194
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                S01194
     D*                                                                   S01194
     D/COPY WNCPYSRC,LE0900I001
     D DSSDY         E DS                  EXTNAME(DSSDY)                       S01194
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE                S01194
     D*                                                                   S01194
     D DSLDY         E DS                  EXTNAME(DSLDY)                       CSD007
      ** Third DS for access programs, very long data structure           CSD007
      *                                                                   CSD007
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CLE005
      *                                                                                       CLE137
     D DBRCA           S                   LIKE(BRCA)                                         CLE137
     D DCNUM           S                   LIKE(CNUM)                                         CLE137
     D DLNRF           S                   LIKE(LNRF)                                         CLE137
0094 I*E0900P2*66FL 56OL                                        S01124    S01117
0094 I*E0900AU*66FL*56OL***                                         S01117180667
     I/COPY WNCPYSRC,LE0900L001
0094 I*E0900P1*66FL*56OL***                                         S01124180667
     I/COPY WNCPYSRC,LE0900L002
0095 I* MATURED LOANS FILE
0096 I*       HEADER
0097 I***MATLS**   NS  01    1 CH                                                             CLE137
0098 I**********                        1    1  RECI                                          CLE137
0099 I*
0100 I*       DETAIL
0101 I*FIELDS REDEFINED WITH SUFFIX 'M'
0102 I*
0103 I**********NS  03    1 CD                                                                CLE137
     ILEMATXL0  NS  03    1 CD                                                                CLE137
0104 I**********                        1    1  RECI                                        MD023534
0104 I                                  1    1  RECIL                                       MD023534
0105 I***********                             2   40BRCDM                 S01117
0105 I                                  2    4  BRCAM                           S01117
0106 I**********                              5  100CNUMM                                     CSD027
0106 I                                  5   10  CNUMM
0107 I**********                             11  160LNRFM                                     CLE148
     I                                 11   16  LNRFM
0108 I***********                             2  160MATCH   M1            S01117
0108 I**********                        2   16  MATCH           M1                    S01117  CLE137
     I                                  2   16  MATCH                                         CLE137
0109 I                             P   17   19 0MDATM
0110 I                             P   20   26 0TINT
0111 I                             P   27   33 0IPRD
0112 I                             P   34   40 0ICTD
0113 I                             P   41   47 0IWOD
0114 I                             P   48   53 7BRTEM
0115 I                             P   54   59 7RTSPM
0116 I                                 60   61 0BRTTM
0117 I                                 62   62  SPINM
0118 I                             P   63   69 0YPLCM
0119 I**********                   P   70   76 0YILC                                        MD023031
0120 I                             P   77   83 0YFLCM
0121 I                             P   84   90 0YWLCM
0122 I                             P   91   97 0ABLCM
0123 I                                 98   99  CRSKM
0124 I                                100  102 0LINDM
0125 I                                103  104 0PTYPM
     I                                105  107  FCLB                            S01117
     I***********                           108 1170OLNO            S01270000036
     I**********                            112 1170OLNO                  000036              CSD027
     I                                112  117  OLNO                            000036
     I                                118  118  RCSI                            S01270
     I**********                      119  121  CCYM                                   CER020 CLE137
     I**********                      122  128 0YLINM                                  CER020 CLE137
     I**********                      129  132  PTFRM                                  CER020 CLE137
     I**********                      133  135  LOICM                                  CER020 CLE137
0126 I*
0127 I*       TRAILER
0128 I*
0129 I**********NS  08    1 CT                                                                CLE137
0130 I**********                        1    1  RECI                                          CLE137
0131 I**FIELD*REDEFINED************************************************                     MD023031
0132 I**********                   P    2    4 0NORES                                       MD023031
0133 I* CATCHALL
0134 I          NS
0135 I*
0136 I*
0137 I** LOANS HISTORY FILE - FILE HEADER RECORD
0138 I*
0139 I***HISTS**   NS  02    1 CH                                                             CLE137
0140 I*    REC REDEFINED
0141 I**********                        1  100  LOTH1                                         CLE137
0142 I*
0143 I** LOANS HISTORY FILE - LOAN HEADER RECORD
0144 I*
0145 I*    FIELDS REDEFINED WITH SUFFIX 'H'
0146 I**********NS  04    1 CD    2 CA                                                        CLE137
0147 I*********OR   05    1 CM    2 CA                                                        CLE137
0148 I**********                        1    1  RECI                                          CLE137
0149 I**********                        2    2  RCDT                                          CLE137
0150 I***********                             3   50BRCDH                 S01117
0150 I**********                        3    5  BRCAH         L1                       S01117 CLE137
0151 I**********                              6  110CNUMH                                     CSD027
0151 I**********                        6   11  CNUMH                                  CSD027 CLE137
0152 I**********                             12  170LNRFH                                     CLE148
     I**********                       12   17  LNRFH                                  CLE148 CLE137
0153 I***********                             3  170MATCH   M1            S01117
0153 I**********                        3   17  MATCH           M1                     S01117 CLE137
0154 I**********                       18   22 0VDATH                                         CLE137
0155 I**********                       23   24 0PRSQ                                          CLE137
0156 I**********                       25   27 0LASN                                          CLE137
0157 I**********                             28  330FCUSH                                     CSD027
0157 I**********                       28   33  FCUSH                                  CSD027 CLE137
0158 I**********                       34   36 0FTYPH                                         CLE137
0159 I**********                       37   38 0FSEQH                                         CLE137
0160 I**********                       39   40 0PTYPH                                         CLE137
0161 I**********                       41   43  CCYH                                          CLE137
0162 I**********                       44   45  AMTP                                          CLE137
0163 I**********                   P   46   52 0PRAMH                                         CLE137
0164 I**********                       53   54 0BRTT                                          CLE137
0165 I**********                   P   55   60 7BRTEH                                         CLE137
0166 I**********                   P   61   66 7RTSP                                          CLE137
0167 I**********                       67   67  SPIN                                          CLE137
0168 I**********                       68   68 0CALC                                          CLE137
0169 I**********                       69   69  WTIN                                          CLE137
0170 I**********                       70   70 0REPT                                          CLE137
0171 I**********                       71   71  INTC                                          CLE137
0172 I**********                       72   73  LTYPH                                         CLE137
0173 I**********                       74   75  SUTPH                                         CLE137
0174 I**********                   P   76   82 0TOTI                                          CLE137
     I**********                       83   85  FCLB                                   S01117 CLE137
     I**********                      215  218  CLASH                                  CLE042 CLE137
     I**********                   P  219  221 0OCDT                                   CRE073 CLE137
     I**********                   P  222  229 8EAIR                                   CRE073 CLE137
     I**********                   P  230  235 7CNSP                                   CRE073 CLE137
     I**********                      236  236  CNSG                                   CRE073 CLE137
     I**********                      237  243  RDMT                                   CRE073 CLE137
     I**********                      244  247  RDFD                                   CRE073 CLE137
0175 I* REC REDEFINED
0176 I***********                             1 100 LOTHH                 CAC001
     I******                                  1 118 LOTHH          CAC001 115248
     I******                                  1 152 LOTHH          115248 157669
     I****************************************1 179 LOTHH                              157669 CLE042
     I*******                                 1 218 LOTHH                              CLE042 CRE073
     I**********                        1  247  LOTHH                                  CRE073 CLE137
     IHISTSHMF                                                                                CLE137
     I              BRCA                        BRCAH                                         CLE137
     I              CNUM                        CNUMH                                         CLE137
     I              LNRF                        LNRFH                                         CLE137
     I              VDAT                        VDATH                                         CLE137
     I              FCUS                        FCUSH                                         CLE137
     I              FTYP                        FTYPH                                         CLE137
     I              FSEQ                        FSEQH                                         CLE137
     I              PTYP                        PTYPH                                         CLE137
     I              CCY                         CCYH                                          CLE137
     I              PRAM                        PRAMH                                         CLE137
     I              BRTE                        BRTEH                                         CLE137
     I              LTYP                        LTYPH                                         CLE137
     I              SUTP                        SUTPH                                         CLE137
     I              CLAS                        CLASH                                         CLE137
0177 I*
0178 I*    HISTORY FILE - INTEREST AND BACKVALUE HEADER
0179 I*
0180 I**********NS  16    1 CD    2 CH                                                        CLE137
0181 I*********OR   17    1 CM    2 CH                                                        CLE137
0182 I**********                        1    1  RECI                                          CLE137
0183 I**********                        2    2  RCDT                                          CLE137
0184 I**********                              3   50BRCD                  S01117
0184 I**********                        3    5  BRCA                                   S01117 CLE137
0185 I**********                              6  110CNUM                                      CSD027
0185 I**********                        6   11  CNUM                                   CSD027 CLE137
0186 I**********                             12  170LNRF                                      CLE148
     I**********                       12   17  LNRF                                   CLE148 CLE137
0187 I***********                             3  170MATCH   M1            S01117
0187 I**********                        3   17  MATCH           M1                     S01117 CLE137
0188 I**********                       18   22 0VDAT                                          CLE137
0189 I**********                       23   24 0PRSQ                                          CLE137
0190 I**********                       25   27 0LASN                                          CLE137
0191 I**********                             28  330FCUS                                      CSD027
0191 I**********                       28   33  FCUS                                   CSD027 CLE137
0192 I**********                       34   36 0FTYP                                          CLE137
0193 I**********                       37   38 0FSEQ                                          CLE137
0194 I**********                       39   40 0PTYP                                          CLE137
0195 I**********                       41   43  CCY                                           CLE137
0196 I**********                       44   45  AMTP                                          CLE137
0197 I**********                   P   46   52 0PRAM                                          CLE137
0198 I**********                   P   53   58 7BRTE                                          CLE137
0199 I**********                   P   59   64 7RTSP                                          CLE137
0200 I**********                       65   65 0CALC                                          CLE137
0201 I**********                       66   66  SPIN                                          CLE137
0202 I**********                   P   67   73 0INTA                                          CLE137
0203 I**********                   P   74   76 0STPG                                          CLE137
0204 I**********                       77   78 0BRTT                                          CLE137
0205 I**********                   P   79   85 0PPIS                                          CLE137
0206 I**********                   P   86   92 0IPIS                                          CLE137
0207 I**********                   P   93   97 7IPPS                                          CLE137
0208 I*    REC REDEFINED
0209 I***********                             1 100 LOTHR                 CAC001
     I**********                              1 118 LOTHR                              CAC001 262540
     I**********                              1 132 LOTHR                              262540 CRE073
     I**********                        1  161  LOTHR                                  CRE073 CLE137
0210 I*
0211 I** LOANS HISTORY FILE - AMOUNT RECORD
0212 I*
0213 I**********NS  06    1 CD    2 CD                                                        CLE137
0214 I*********OR   07    1 CM    2 CD                                                        CLE137
0215 I**********                        1    1  RECI                                          CLE137
0216 I**********                        2    2  RCDT                                          CLE137
0217 I***********                             3   50BRCD                  S01117
0217 I**********                        3    5  BRCA                                   S01117 CLE137
0218 I**********                              6  110CNUM                                      CSD027
0218 I**********                        6   11  CNUM                                   CSD027 CLE137
0219 I**********                             12  170LNRF                                      CLE148
     I**********                       12   17  LNRF                                   CLE148 CLE137
0220 I***********                             3  170MATCH   M1            S01117
0220 I**********                        3   17  MATCH           M1                     S01117 CLE137
0221 I**********                       18   22 0VDAT                                          CLE137
0222 I**********                       23   24 0PRSQ                                          CLE137
0223 I**********                       25   27 0LASN                                          CLE137
0224 I**********                             28  330FCUS                                      CSD027
0224 I**********                       28   33  FCUS                                   CSD027 CLE137
0225 I**********                       34   36 0FTYP                                          CLE137
0226 I**********                       37   38 0FSEQ                                          CLE137
0227 I**********                       39   40 0PTYP                                          CLE137
0228 I**********                       41   43  CCY                                           CLE137
0229 I**********                       44   45  AMTP                                          CLE137
0230 I**********                   P   46   52 0PRAM                                          CLE137
0231 I**********                   P   53   59 0INTA                                          CLE137
0232 I**********                   P   60   66 0WTXA                                          CLE137
0233 I**********                   P   67   73 0FEAM                                          CLE137
0234 I**********                       74   75 0FECD                                          CLE137
0235 I**********                       76   76  WOIN                                          CLE137
0236 I**********                   P   77   79 0EXVD                                          CLE137
     I**********                       80   81  LTYPH                                  S01270 CLE137
     I**********                       82   83  SUTPH                                  S01270 CLE137
     I**********                      228  231  CLASH                                  CLE042 CLE137
     I**********                          P 179 1850CHDU                              CLE028 BUG7415
0237 I*    REC REDEFINED
0238 I***********                             1 100 LOTHL                 CAC001
     I******                                  1 107 LOTHL          CAC001 115248
     I******                                  1 141 LOTHL          115248 CLE004
     I******                                  1 150 LOTHL          CLE004 157669
     I****************************************1 177 LOTHL                              157669 CLE042
     I**********                        1  231  LOTHL                                  CLE042 CLE137
     IHISTSHPF                                                                                CLE137
     I              LTYP                        LTYPH                                         CLE137
     I              SUTP                        SUTPH                                         CLE137
     I              CLAS                        CLASH                                         CLE137
0239 I*
0240 I*    HISTORY FILE - DETAIL RATES
0241 I*
0242 I**********NS  13    1 CD    2 CE                                                        CLE137
0243 I*********OR   14    1 CM    2 CE                                                        CLE137
0244 I**********                        1    1  RECI                                          CLE137
0245 I**********                        2    2  RCDT                                          CLE137
0246 I***********                             3   50BRCD                  S01117
0246 I**********                        3    5  BRCA                                   S01117 CLE137
0247 I**********                              6  110CNUM                                      CSD027
0247 I**********                        6   11  CNUM                                   CSD027 CLE137
0248 I**********                             12  170LNRF                                      CLE148
     I**********                       12   17  LNRF                                   CLE148 CLE137
0249 I***********                             3  170MATCH   M1            S01117
0249 I**********                        3   17  MATCH           M1                     S01117 CLE137
0250 I**********                       18   22 0VDAT                                          CLE137
0251 I**********                       23   24 0PRSQ                                          CLE137
0252 I**********                       25   27 0LASN                                          CLE137
0253 I**********                             28  330FCUS                                      CSD027
0253 I**********                       28   33  FCUS                                   CSD027 CLE137
0254 I**********                       34   36 0FTYP                                          CLE137
0255 I**********                       37   38 0FSEQ                                          CLE137
0256 I**********                       39   40 0PTYP                                          CLE137
0257 I**********                       41   43  CCY                                           CLE137
0258 I**********                       44   45  AMTP                                          CLE137
0259 I**********                       46   47 0BRTT                                          CLE137
0260 I**********                   P   48   53 7BRTE                                          CLE137
0261 I**********                   P   54   59 7RTSP                                          CLE137
0262 I**********                       60   60  SPIN                                          CLE137
0263 I**********                       61   61 0CALC                                          CLE137
0264 I**********                       62   62  STAI                                          CLE137
     I**********                      108  108  IRCF                                   CAC001 CLE137
0265 I*    REC REDEFINED
0266 I***********                             1 100 LOTHR                 CAC001
     I*****                                   1 113 LOTHRT         CAC001 115248
     I*****                                   1 147 LOTHRT         115248 CLE004
     I*****                                   1 151 LOTHRT         CLE004 157669
     I**********                              1 178 LOTHRT                             157669 262540
     I**********                              1 206 LOTHRT                             262540 CRE073
     I**********                        1  235  LOTHRT                                 CRE073 CLE137
0267 I*
0268 I** LOANS HISTORY FILE - TRAILER RECORD
0269 I*
0270 I**********NS  09    1 CT                                                                CLE137
0271 I**********                        1    1  RECI                                          CLE137
0272 I*****FIELD*REDEFINED*********************************************                       CLE137
0273 I**********                   P    2    4 0NOREH                                         CLE137
0274 I* CATCHALL
0275 I**********NS  15                                                                        CLE137
      *                                                                                       CLE137
     ILEHISTPF                                                                                CLE137
     I              NORE                        NOREH2                                        CLE137
0276 I*
0277 I**************                                                      S01194
0278 I*****CLIENT*FILE - CUSTOMER STANDING DATA RECORD.                   S01194
0279 I**************                                                      S01194
0280 I*CLINT***NS***    1 CD   8 CA                                       S01194
0281 I**************                          1   1 RECI                  S01194
0282 I**************                          2   70CNUM                  S01194
0283 I**************                          8   8 RCDT                  S01194
0284 I**************                          9  28 CRNM                  S01194
0285 I**************                         29  38 CTWN                  S01194
0286 I**************                         39  48 CSNM                  S01194
0287 I**************                         49  56 CASK                  S01194
0288 I**************                         57  68 TELX                  S01194
0289 I**************                         69  80 CSID                  S01194
0290 I**************                         81  82 ACOC                  S01194
0291 I**************                         83  83 CBSI                  S01194
0292 I**************                         84  85 CCTZ                  S01194
0293 I**************                         86  87 CLOC                  S01194
0294 I**************                         88  930CPAR                  S01194
0295 I***********                            94  960BRCD                  S01194
0296 I**************                         97  980LINS                  S01194
0297 I**************                         99 1010LIND                  S01194
0298 I**************                      P 102 1040DASU                  S01194
0299 I**************                      P 105 1070CDIC                  S01194
0300 I**************                      P 108 1100DADE                  S01194
0301 I**************                        111 111 CMIN                  S01194
0302 I**************                        112 112 CTYP                  S01194
0303 I**************                        113 124 TELF                  S01194
0304 I**************                        125 133 CHID                  S01194
0305 I**************                        134 136 CHAB                  S01194
0306 I**************                      P 250 2520LCD                   S01194
0307 I**************                        253 253 CHTP                  S01194
0308 I**************                      P 254 2560TNLU                  S01194
0309 I*CATCHALL*****                                                      S01194
0310 I********NS****   1NCD                                               S01194
0311 I**************                          1   1 RECI                  S01194
0312 I**************                                                      S01194
0313 I**************                                                      S01194
0314 I*****TABLE*FILE - INSTALLATION CONTROL DATA RECORD 1.               S01194
0315 I**************                                                      S01194
0316 I*TABLE***NS**11   2 C0   3 C1  12 C1                                S01194
0317 I*******AND****  13 C0                                               S01194
0318 I**************                          1   1 RECI                  S01194
0319 I**************                          2   30RECT                  S01194
0320 I**************                         12  130RCDE                  S01194
0321 I**************                         14  66 TITL                  S01194
0322 I***********                            67  67 DATF                  S01194
0323 I***********                            68  700DFBR                  S01194
0324 I**************                         74  74 MODI1                 S01194
0325 I**************                         75  75 MODI2                 S01194
0326 I**************                         76  76 MODI3                 S01194
0327 I***********                         P  77  790RUND                  S01194
0328 I***********                            80  86 RUNA                  S01194
0329 I**************                         87  870SFLG                  S01194
0330 I**************                      P  90  920LCD                   S01194
0331 I**************                         93  93 CHTP                  S01194
0332 I**************                      P  94  960TNLU                  S01194
0333 I**************                                                      S01194
0334 I**************                                                      S01194
0335 I*****TABLE*FILE - CURRENCIES RECORD 1.                              S01194
0336 I**************                                                      S01194
0337 I********NS**12   1 CD   2 C2   3 C0                                 S01194
0338 I*******AND****  13 C1                                               S01194
0339 I**************                          1   1 RECI                  S01194
0340 I**************                          2   30RECT                  S01194
0341 I**************                         10  12 CCY                   S01194
0342 I**************                         13  130SREC                  S01194
0343 I**************                         14  27 CCNM                  S01194
0344 I**************                      P  28  348SPOT                  S01194
0345 I**************                         35  37 CCYS                  S01194
0346 I**************                         38  380CDP                   S01194
0347 I**************                         39  390TNOT                  S01194
0348 I**************                         40  40 DCCY                  S01194
0349 I**************                         41  44 SRC1                  S01194
0350 I**************                         45  48 SRC2                  S01194
0351 I**************                         49  520TACC                  S01194
0352 I**************                         53  560TEQV                  S01194
0353 I**************                         57  600SWQV                  S01194
0354 I**************                         61  640TAC4                  S01194
0355 I**************                         65  680TAC5                  S01194
0356 I**************                         69  69 HIND                  S01194
0357 I**************                      P  70  768PART                  S01194
0358 I**************                         77  780SSNO                  S01194
0359 I**************                      P  79  858ERLC                  S01194
0360 I**************                         86  860MDIN                  S01194
0361 I**************                         87  870MDIA                  S01194
0362 I**************                         88  880MDIB                  S01194
0363 I**************                      P  90  920LCD                   S01194
0364 I**************                         93  93 CHTP                  S01194
0365 I**************                      P  94  960TNLU                  S01194
0366 I**CATCHALL****                                                      S01194
0367 I********NS****                                                      S01194
0368 I**************                          1   1 RECI                  S01194
      **                                                                  S01117
     I/COPY WNCPYSRC,LEH01261
      **  Switchable Features File                                        CLE005
      *                                                                   CLE005
     I/EJECT                                                              S01117
     C                   MOVEA     CPY@          BIS@             80
     C***********                                                   S01117BHF114
     C************ENTRY    PLIST                                    S01117BHF114
     C***********          PARM           SEQ     5        SEQUENCE S01117BHF114
     C*    DEFINE LDA                                                     S01117
     C     *DTAARA       DEFINE                  LDA                                           S0111
      *                                                                                       CLE137
     C     KEY01         KLIST                                                                CLE137
     C                   KFLD                    DBRCA                                        CLE137
     C                   KFLD                    DCNUM                                        CLE137
     C                   KFLD                    DLNRF                                        CLE137
     C     LEHKEY        KLIST                                                                CLE137
     C                   KFLD                    BRCA                                         CLE137
     C                   KFLD                    CNUM                                         CLE137
     C                   KFLD                    LNRF                                         CLE137
      *                                                                                       CLE137
     C     #ENTRY        PLIST                                                                CLE137
     C                   PARM                    RSTART            1                          CLE137
     C                   SETOFF                                         3334                  CLE137
      *                                                                                       CLE137
     C                   OPEN      LEHISUPD                                                   CLE137
      *                                                                                       CLE137
      ** Only initialize once                                                                 CLE137
      *                                                                                       CLE137
     C     @INIT         IFEQ      ' '                                                        CLE137
     C                   MOVE      'Y'           @INIT             1                          CLE137
      *                                                                                       CLE137
     C                   EXSR      FIRCYL                                                     CLE137
      *                                                                                       CLE137
     C                   ENDIF                                                                CLE137
      *                                                                                       CLE137
      ** Initialise work fields for re-run of program.                                        CLE137
      *                                                                                       CLE137
     C                   Z-ADD     1             #COMIT                                       CLE137
      *                                                                                       CLE137
      ** Read END key from LEHISUPD                                                           CLE137
      *                                                                                       CLE137
     C                   MOVE      'Z'           IXCKEY            1                          CLE137
     C     IXCKEY        CHAIN     LEHISUPD                           38                      CLE137
     C     *IN38         IFEQ      '0'                                                        CLE137
     C                   MOVE      BRCA          EBRCA                                        CLE137
     C                   MOVE      CNUM          ECNUM                                        CLE137
     C                   MOVE      LNRF          ELNRF                                        CLE137
     C                   END                                                                  CLE137
      *                                                                                       CLE137
      ** Read START key from LEHISUPD                                                         CLE137
      *                                                                                       CLE137
     C     *IN38         IFEQ      '0'                                                        CLE137
     C                   MOVE      'A'           IXCKEY                                       CLE137
     C     IXCKEY        CHAIN     LEHISUPD                           38                      CLE137
     C                   END                                                                  CLE137
      *****************************************************************              CLE137 MD024318
     C******IN38         IFEQ      '1'                                               CLE137 MD024318
     C**********         EXSR      ERROR                                             CLE137 MD024318
     C**********         END                                                         CLE137 MD024318
      *                                                                                       CLE137
      ** Set pointer to the first record                                                      CLE137
      *                                                                                       CLE137
     C                   MOVE      BRCA          BRCAK                                        CLE137
     C                   MOVE      CNUM          CNUMK                                        CLE137
     C                   MOVE      LNRF          LNRFK                                        CLE137
     C     NXTKEY        IFGT      ENDKEY                                                     CLE137
     C     NXTKEY        OREQ      ENDKEY                                                     CLE137
     C                   MOVE      '1'           *IN19                                        CLE137
     C                   END                                                                  CLE137
      *                                                                                       CLE137
     C     *IN19         IFEQ      '0'                                                        CLE137
      *                                                                                       CLE137
     C     LEHKEY        SETLL     HISTSHMF                                                   CLE137
     C                   READ      HISTS                                  10                  CLE137
     C                   ENDIF                                                                CLE137
      *                                                                                       CLE137
     C     *IN10         DOWEQ     *OFF                                                       CLE137
      *                                                                                       CLE137
     C                   MOVE      BRCA          DBRCA                                        CLE137
     C                   MOVE      CNUM          DCNUM                                        CLE137
     C                   MOVE      LNRF          DLNRF                                        CLE137
      *                                                                                       CLE137
     C                   SETOFF                                       010308                  CLE137
     C     LNRF          CHAIN     LEMATXL0                           11                      CLE137
     C     *IN11         Ifeq      *Off                                                       CLE137
     C   03MAT           ADD       1             MAT               5 0                        CLE137
     C                   Endif                                                                CLE137
     C                   SETOFF                                       020405                  CLE137
     C                   SETOFF                                       060709                  CLE137
     C                   SETOFF                                       131415                  CLE137
     C                   SETOFF                                       1617                    CLE137
      *                                                                                       CLE137
     C                   IF        (RCDT = 'A' AND LNRFH <> DLNRF) OR                         CLE137
     C                             (RCDT <> 'A' AND LNRF <> DLNRF)                            CLE137
     C                   EVAL      *IN12 = *ON                                                CLE137
     C                   ENDIF                                                                CLE137
      *                                                                                       CLE137
     C                   SELECT                                                               CLE137
     C                   WHEN      (RECI = 'D' AND RCDT = 'A')                                CLE137
     C                   EVAL      *IN04 = *ON                                                CLE137
     C                   WHEN      (RECI = 'M' AND RCDT = 'A')                                CLE137
     C                   EVAL      *IN05 = *ON                                                CLE137
     C                   WHEN      (RECI = 'D' AND RCDT = 'H')                                CLE137
     C                   EVAL      *IN16 = *ON                                                CLE137
     C                   WHEN      (RECI = 'M' AND RCDT = 'H')                                CLE137
     C                   EVAL      *IN17 = *ON                                                CLE137
     C                   WHEN      (RECI = 'D' AND RCDT = 'D')                                CLE137
     C                   EVAL      *IN06 = *ON                                                CLE137
     C                   WHEN      (RECI = 'M' AND RCDT = 'D')                                CLE137
     C                   EVAL      *IN07 = *ON                                                CLE137
     C                   WHEN      (RECI = 'D' AND RCDT = 'E')                                CLE137
     C                   EVAL      *IN13 = *ON                                                CLE137
     C                   WHEN      (RECI = 'M' AND RCDT = 'E')                                CLE137
     C                   EVAL      *IN14 = *ON                                                CLE137
     C                   ENDSL                                                                CLE137
0397 C*ON READ OF HIST. TRAILER,CHECK HEADER REC FOR LAST...
0398 C*..LOAN WAS OUTPUT. IF NOT PASS TO HASH/OUTPUT.
     C***09*****                                                                              CLE137
0399 C*AN*41****          GOTO      MP1                                                       CLE137
0400 C* UNWANTED RECORDS TO END
0401 C***02*****                                                                              CLE137
0402 C***OR*08**                                                                              CLE137
0403 C***OR*09**                                                                              CLE137
0404 C***OR*15**           GOTO      END                                                      CLE137
0405 C***01*****           EXSR FIRCYL                                                        CLE137
0406 C*
0407 C***01*****                                                                              CLE137
     C***OR*U7**                                                                              CLE137
     C***AN*U8**                                                                              CLE137
0408 C***AN*LR**            GOTO      END                                                     CLE137
0409 C                   SETOFF                                       434482
     C* UNMATCHED MATURED HISTORY RECORDS ARE PROCESSED AS LIVE RECORDS   E47241
     C   04                                                                                    E4724
     COR 05              SETOFF                                       85                       E4724
     C***05                                                                                   CLE137
     C***ANNMR              SETON                                        85             E4724 CLE137
     C   05                                                                                   CLE137
     CAN 11              SETON                                        85                      CLE137
     C   85
     CAN 05              SETON                                        04                       E4724
     C   85
     CAN 17              SETON                                        16                       E4724
     C   85
     CAN 07              SETON                                        06                       E4724
     C   85
     CAN 14              SETON                                        13                       E4724
     C/COPY WNCPYSRC,LE0900C001
     C   85              SETOFF                                       051707                   E4724
     C   85              SETOFF                                       14                       E4724
0410 C** SET DATABASE ERROR IF MATURED LOAN + MAT.HIST DO
0411 C** NOT MATCH
0412 C***05NMR*************                                               E47241
0413 C*R*03NMR*************SETON                     U7U8LR               E47241
     C***03*****                                                                              CLE137
     C***ANNMR**            SETON                                        U7U8LR         E4724 CLE137
     C***U7*****                                                                              CLE137
     C***AN*U8**                                                                              CLE137
0414 C***AN*03**            MOVEL     LNRFM         DBKEY                      -------------- CLE137
     C***U7*****                                                                              CLE137
     C***AN*U8**                                                                              CLE137
0415 C***AN*05**            MOVEL     LNRFH         DBKEY                                     CLE137
     C***U7*****                                                                              CLE137
     C***AN*U8**                                                                              CLE137
0416 C***AN*03**            MOVE      'MATLS'       DBFILE                                    CLE137
     C***U7*****                                                                              CLE137
     C**AN*U8***                                                                              CLE137
0417 C***AN*05**            MOVE      'HISTS'       DBFILE                    --DATABASE 3 -- CLE137
     C***U7*****                                                                              CLE137
0418 C***AN*U8**            Z-ADD     3             DBASE                     --------------- CLE137
0419 C* COUNT MATLN
0420 C***03MAT**         ADD       1             MAT               5 0                        CLE137
0421 C*
0422 C***03*****         GOTO      END                                                        CLE137
     C*                                                                   S01117
     C** MULTIBRANCHING OUTPUT TEST                                       S01117
     C*                                                                   S01117
     C********** *INL1     IFEQ '1'                                                   S01117 BUG7415
     C**********           SETOF                     20                               S01117 BUG7415
     C**********           CLOSELE0900P1                                              S01117 BUG7415
     C********** BRNCH     IFEQ 'ALL'                                                 S01117 BUG7415
     C********** MBIN      ANDEQ'Y'                                                   S01117 BUG7415
     C********** BRNCH     OREQ BRCAH                                                 S01117 BUG7415
     C********** MBIN      ANDEQ'Y'                                                   S01117 BUG7415
     C********** MBIN      ORNE 'Y'                                                   S01117 BUG7415
     C**********           SETON                     21                               S01117 BUG7415
     C**********           MOVE 'Y'       P1OP    1                                   S01117 BUG7415
     C**********           OPEN LE0900P1                                              S01117 BUG7415
     C**********           Z-ADD0         PAGE                                        S01117 BUG7415
     C*                                                                   S01117
     C** ENSURE REPORT SPOOL FILE RECORDED BY RCF                         S01117
     C*                                                                   S01117
     C**********           Z-ADDSFNUM     ZSNUM   60                                  S01117 BUG7415
     C*                                                                   S01117
     C**********           OUT  LDA                                                   S01117 BUG7415
     C**********           CALL 'ZSFILE'                                              S01117 BUG7415
     C***********          PARM           SEQ                       S01117BHF114
     C**********           PARM           SEQ     5                                   BHF114 BUG7415
     C**********           PARM BRCAH     SENTY   3                                   S01117 BUG7415
     C**********           PARM           SFILE                                       S01117 BUG7415
     C**********           PARM           ZSNUM                                       S01117 BUG7415
     C**********           PARM           ZSERR   1                                   S01117 BUG7415
     C********** *LOCK     IN   LDA                                                   S01117 BUG7415
      *                                                                   S01117
     C********** ZSERR     IFEQ 'Y'                                                   S01117 BUG7415
      **  ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAM       S01117
     C**********           SETON                     U7U8LR                           S01117 BUG7415
     C**********           RETRN                                                      S01117 BUG7415
     C**********           END                                                        S01117 BUG7415
     C********** MBIN      IFEQ 'Y'                                                   S01117 BUG7415
     C**********           CALL 'AOBRCHR0'                                S01117              CGL029
     C**********           CALL 'AOBRCHR1'                                            CGL029 BUG7415
     C**********           PARM '*MSG   ' @RTCD   7                                   S01117 BUG7415
     C**********           PARM '*KEY   ' @OPTN   7                                   S01117 BUG7415
     C**********           PARM BRCAH     @DSNB   3                                   S01117 BUG7415
     C********** SDBRCH    PARM SDBRCH    DSFDY                           S01117              CGL029
     C********** SDBRCH    PARM SDBRCH    DSSDY                                       CGL029 BUG7415
     C********** @RTCD     IFNE *BLANKS                                               S01117 BUG7415
     C**********           MOVEL@DSNB     DBKEY                                       S01117 BUG7415
     C**********           MOVEL'SDBRCHPD'DBFILE           ************               S01117 BUG7415
     C**********           Z-ADD6         DBASE            * DBASE 06 *               S01117 BUG7415
     C**********           MOVEL@OPTN     DBOPTN  7        ************               S01117 BUG7415
     C**********           SETON                     U7U8LR                           S01117 BUG7415
     C**********           GOTO END                                                   S01117 BUG7415
     C**********           END                                                        S01117 BUG7415
     C**********           END                                                        S01117 BUG7415
     C*                                                                   S01117
     C**********           ELSE                                                       S01117 BUG7415
     C**********           SETOF                     21                               S01117 BUG7415
     C**********           END                                                        S01117 BUG7415
     C**********           END                                                        S01117 BUG7415
     C**                                                                  S01117
0423 C* PASS TO MAT.HISTORY PROCESS
0424 C*
0425 C***05*****           EXSR MATPRO                                                       BUG7415
     C   U7
     CAN U8
0426 CAN LR              GOTO      END
0427 C* COUNTS - FOR HISTS + HIUPD
0428 C*
0429 C* LIVE RECS
0430 C   04
0431 COR 06
0432 COR 13
0433 COR 16HIS           ADD       1             HIS
0434 C* MAT RECS
0435 C   05
0436 COR 07
0437 COR 14
0438 COR 17HIU           ADD       1             HIU
0439 C*
0440 C   16
0441 COR 13
0442 COR 17              GOTO      END
0443 C* MATURED HISTORY DETAIL PROCESS
0444 C***14*****                                                                             BUG7415
0445 C***OR*07**              EXSR CARD                                                      BUG7415
0446 C*
0447 C*
0448 C   14              GOTO      END
0449 C* PASS AMNT RECS TO PROCESSING IF VALUE DATE IS < OR =..
0450 C*..END MONTH DATE. IF NOT IGNORE REC.
0451 C   07
0452 COR 06VDAT          COMP      ENDDAT                             82
0453 C   82              GOTO      END
0454 C   07
0455 COR 06              GOTO      MP2
0456 C* PROCESS 05 &04 FOR MNTH HISTORY
0457 C*
0458 C     MP1           TAG                                                    ** MP1 TAG **
0459 C**NEW HEADER/TRAILER READ NONE YET WRITTEN OUT- EXCPT
     C***05*****                                                                              CLE137
0460 C***AN*41**                                                                              CLE137
     C***OR*09**                                                                              CLE137
0461 C***AN*41**                                                                              CLE137
     C***OR*04**                                                                              CLE137
0462 C***AN*41**            SETON                                        45                   CLE137
     C/COPY WNCPYSRC,LEH01262
0463 C***45*****         EXCEPT                                                               CLE137
0464 C***45*****         EXSR      MHASH                                                      CLE137
0465 C***09*****         GOTO      END                                                        CLE137
0466 C*
0467 C*IF LOAN START < THIS MONTH CALC START MNTH BAL
0468 C     VDATH         COMP      BEGDAT                             424142
0469 C   41              Z-ADD     PRAMH         WBEG             13 0
0470 C* SAVE HEAD FIELDS IN CASE OF OUTPUT ON READING NEW
0471 C* HEADER REC.
0472 C*
0473 C                   MOVE      LHED          WLHED            37
0473 C                   MOVE      CNUMH         WCNUMH            6                        MD023534
0474 C                   MOVE      PRAMH         WPRAMH           13 0
0475 C                   MOVE      VDATH         WVDATH            5 0
     C   42              EXCEPT    MNHST2                                                     CLE137
0476 C   42              EXSR      MHASH
0477 C***05*****           EXSR CARD                                                         BUG7415
0478 C   04
0479 COR 05              GOTO      END
0480 C     MP2           TAG                                                    ** MP2 TAG ***
0481 C* DETAIL RECS PRIOR TO THIS MNTH -CALC BALANCE
0482 C*
     C   07
0483 CAN 41
     COR 06
0484 CAN 41              EXSR      BALCAL
     C     *IN06         IFEQ      *ON                                                        CLE137
     C     *IN41         ANDEQ     *OFF                                                       CLE137
     C     *IN07         OREQ      *ON                                                        CLE137
     C     *IN41         ANDEQ     *OFF                                                       CLE137
     C                   EXCEPT    MNHST2                                                     CLE137
     C                   Endif                                                                CLE137
     C   07
0485 CANN41
     COR 06
0486 CANN41              EXSR      MHASH
0487 C     END           TAG                                                    ** END TAG ****
     C/COPY WNCPYSRC,LE0900C005
      *                                                                                       CLE137
     C     *IN11         IFEQ      *OFF                                                       CLE137
     C     *IN05         IFEQ      *ON                                                        CLE137
     C     *IN07         OREQ      *ON                                                        CLE137
     C     *IN14         OREQ      *ON                                                        CLE137
     C     *IN17         OREQ      *ON                                                        CLE137
      *                                                                                       CLE137
      ** Write recs to MHISTS* files                                                          CLE137
      *                                                                                       CLE137
     C                   IF        *IN05 = *ON                                                CLE137
0150 C                   EVAL      BRCA = BRCAH                                               CLE137
0151 C                   EVAL      CNUM = CNUMH                                               CLE137
0152 C                   EVAL      LNRF = LNRFH                                               CLE137
0154 C                   EVAL      VDAT = VDATH                                               CLE137
0157 C                   EVAL      FCUS = FCUSH                                               CLE137
0158 C                   EVAL      FTYP = FTYPH                                               CLE137
0159 C                   EVAL      FSEQ = FSEQH                                               CLE137
0160 C                   EVAL      PTYP = PTYPH                                               CLE137
0161 C                   EVAL      CCY  = CCYH                                                CLE137
0163 C                   EVAL      PRAM = PRAMH                                               CLE137
0165 C                   EVAL      BRTE = BRTEH                                               CLE137
0172 C                   EVAL      LTYP = LTYPH                                               CLE137
0173 C                   EVAL      SUTP = SUTPH                                               CLE137
     C                   EVAL      CLAS = CLASH                                               CLE137
     C                   ENDIF                                                                CLE137
      *                                                                                       CLE137
     C                   IF        *IN07 = *ON                                                CLE137
0172 C                   EVAL      LTYP = LTYPH                                               CLE137
0173 C                   EVAL      SUTP = SUTPH                                               CLE137
     C                   EVAL      CLAS = CLASH                                               CLE137
     C                   ENDIF                                                                CLE137
      *                                                                                       CLE137
     C   05              WRITE     MHISTSHMF                                                  CLE137
     C   17              WRITE     MHISTSHNF                                                  CLE137
     C   07              WRITE     MHISTSHPF                                                  CLE137
     C   14              WRITE     MHISTSHQF                                                  CLE137
      *                                                                                       CLE137
      ** Delete record from HISTS                                                             CLE137
      *                                                                                       CLE137
     C                   DELETE    HISTS                                                      CLE137
     C                   ADD       1             DELCNT                                     MD024133
     C                   ADD       1             #COMIT                                       CLE137
      *                                                                                       CLE137
      ** Commit if restart status = 'Y' or number of records processed                        CLE137
      ** has reached optimum defined in CBTASKSP                                              CLE137
      *                                                                                       CLE137
     C                   MOVE      BRCAH         BRCAK                                        CLE137
     C                   MOVE      CNUMH         CNUMK                                        CLE137
     C                   MOVE      LNRFH         LNRFK                                        CLE137
      *                                                                                       CLE137
     C                   MOVE      NXTKEY        LSTKEY                                       CLE137
     C     #COMIT        IFEQ      #OPTIM                                                     CLE137
     C                   EXSR      UPDPTR                                                     CLE137
     C                   COMMIT                                                               CLE137
     C                   ENDIF                                                                CLE137
      *                                                                                       CLE137
     C                   ENDIF                                                                CLE137
     C                   ENDIF                                                                CLE137
      *                                                                                       CLE137
     C                   SETOFF                                       020405                  CLE137
     C                   SETOFF                                       060709                  CLE137
     C                   SETOFF                                       131415                  CLE137
     C                   SETOFF                                       1617                    CLE137
      *                                                                                       CLE137
     C**********         READ      HISTSHMF                               10         CLE137 MD023534
     C                   READ      HISTS                                  10                MD023534
     C                   IF        LNRF <> LNRFH                                            MD023534
      ** If new Header read set the main key to be new  loan                                MD023534
0150 C                   EVAL      BRCA = BRCAH                                             MD023534
0151 C                   EVAL      CNUM = CNUMH                                             MD023534
0152 C                   EVAL      LNRF = LNRFH                                             MD023534
     C                   ENDIF                                                              MD023534
      *                                                                                       CLE137
     C     *IN10         IFEQ      '0'                                                        CLE137
     C                   MOVE      BRCAH         BRCAK                                        CLE137
     C                   MOVE      CNUMH         CNUMK                                        CLE137
     C                   MOVE      LNRFH         LNRFK                                        CLE137
     C     NXTKEY        IFGT      ENDKEY                                                     CLE137
     C                   MOVE      '1'           *IN10                                        CLE137
     C                   ENDIF                                                                CLE137
     C                   ENDIF                                                                CLE137
     C     *IN10         IFEQ      '1'                                                        CLE137
     C                   MOVE      BRCAH         LBRCA                                        CLE137
     C                   MOVE      CNUMH         LCNUM                                        CLE137
     C                   MOVE      LNRFH         LLNRF                                        CLE137
     C                   MOVE      LSTKEY        NXTKEY                                       CLE137
     C                   ENDIF                                                                CLE137
      ** Process EOF as a Change of  Loan                                                   MD023534
     C     *IN10         IFEQ      *ON                                                      MD023534
     C                   EVAL      *IN12 = *ON                                              MD023534
     C                   ENDIF                                                              MD023534
      *                                                                                       CLE137
     C                   IF        (RCDT = 'A' AND LNRFH <> DLNRF) OR                         CLE137
     C                             (RCDT <> 'A' AND LNRF <> DLNRF)                            CLE137
     C                   EVAL      *IN12 = *ON                                                CLE137
     C                   ENDIF                                                                CLE137
      *                                                                                       CLE137
      ** If change of loan process MNHST1                                                   MD023534
     C     *IN41         IFEQ      *ON                                                      MD023534
     C     *IN12         ANDEQ     *ON                                                      MD023534
     C                   SETON                                        45                    MD023534
     C   45              EXCEPT    MNHST1                                                   MD023534
     C   45              EXSR      MHASH                                                    MD023534
     C                   ENDIF                                                              MD023534
      ** Reset for next change of Loan                                                      MD023534
     C                   EVAL      *IN12 = *Off                                             MD023534
     C                   ENDDO                                                                CLE137
      *                                                                                       CLE137
      ** Comit if no records left in driving file and number of                               CLE137
      ** records processed is not 0                                                           CLE137
      ** EOF process is driven by *IN10 not *IN12                                           MD023534
      *                                                                                       CLE137
     C******IN12         IFEQ      '1'                                               CLE137 MD023534
     C     *IN10         IFEQ      '1'                                                      MD023534
     C     #COMIT        ANDGT     0                                                          CLE137
     C                   EXSR      UPDPTR                                                     CLE137
     C                   COMMIT                                                               CLE137
     C                   ENDIF                                                                CLE137
      *                                                                                       CLE137
      ** Release record lock and close file.                                                  CLE137
      *                                                                                       CLE137
     C     @INIT         IFEQ      'Y'                                                        CLE137
     C                   MOVE      ' '           @INIT                                        CLE137
     C                   ENDIF                                                                CLE137
     C                   UNLOCK    HISTS                                                      CLE137
     C                   CLOSE     LEHISUPD                                                   CLE137
      *                                                                                       CLE137
     C******IN41         IFEQ      *ON                                               CLE137 MD023534
     C**********         SETON                                        45             CLE137 MD023534
     C***45*****         EXCEPT    MNHST1                                            CLE137 MD023534
     C***45*****         EXSR      MHASH                                             CLE137 MD023534
     C**********         ENDIF                                                       CLE137 MD023534
      *                                                                                       CLE137
      ** Update trailer LEHISTPD                                                              CLE137
      *                                                                                       CLE137
     C     1             CHAIN     LEHISTPD                           18                      CLE137
     C     MNH           ADD       NOREH2        NOREH2                                       CLE137
     C                   Z-ADD     0             ZZAMTADD         18 0                        CLE137
     C                   EVAL      ZZAMTADD = (VLRF * 1000) + VLRL                            CLE137
     C                   Z-ADD     0             WRK18N0          18 0                        CLE137
     C                   EVAL      WRK18N0  = (ZZTOTI * 1000) + ZZTOTD                        CLE137
     C                   EVAL      WRK18N0 = WRK18N0 + ZZAMTADD                               CLE137
     C                   EVAL      VLRF = WRK18N0 / 1000                                      CLE137
     C                   EVAL      VLRL = WRK18N0 - (VLRF * 1000)                             CLE137
     C     *IN18         IFEQ      *OFF                                                       CLE137
     C                   UPDATE    LEHISTPF                                                   CLE137
     C                   ELSE                                                                 CLE137
     C                   WRITE     LEHISTPF                                                   CLE137
     C                   ENDIF                                                                CLE137
      *                                                                                       CLE137
     C                   Z-ADD     0             MNH               5 0                        CLE137
     C                   Z-ADD     0             ZZTOTI                                       CLE137
     C                   Z-ADD     0             ZZTOTD                                       CLE137
      *                                                                                       CLE137
      ** Update trailer LEHIDTPD                                                              CLE137
      *                                                                                       CLE137
     C     1             CHAIN     LEHIDTPD                           18                      CLE137
      *                                                                                       CLE137
      *                                                                                       CLE137
     C                   ADD       DELCNT        NOREDL                                       CLE137
     C     *IN18         IFEQ      *OFF                                                       CLE137
     C                   UPDATE    LEHIDTPF                                                   CLE137
     C                   ELSE                                                                 CLE137
     C                   WRITE     LEHIDTPF                                                   CLE137
     C                   ENDIF                                                                CLE137
      *                                                                                       CLE137
     C                   Z-ADD     0             DELCNT            5 0                        CLE137
      *                                                                                       CLE137
0488 C* COMPARE TOTALS
0489 C***LRNU7**    HIS       ADD  HIU       HIT     50                                       CLE137
     C  NU7HIS           ADD       HIU           HIT               5 0                        CLE137
     C***LR*****  BRNCH     IFEQ 'ALL'                                                 S01117 CLE137
     C***LR*****  MBIN      OREQ 'N'                                                   S01117 CLE137
0490 C***LRNU7HIT           COMP      NOREH                              3333                 CLE137
0491 C***LRNU7MAT           COMP      NORES                              3434                 CLE137
     C***LR*****            END                                                        S01117 CLE137
0492 C***LR*33**                                                                              CLE137
0493 C***OR*34**            SETON                                        U8                   CLE137
     C*                                                                   S01117
     C**   ENSURE TOTALS SPOOL FILE RECORDED BY RCF                       S01117
     C*                                                                   S01117
     C***LR*****              Z-ADDSFNUMU    ZSNUMU                                   S01117 BUG7415
      *                                                                   S01117
     C***LR*****              OUT  LDA                                                S01117 BUG7415
     C***LR*****              CALL 'ZSFILE'                                           S01117 BUG7415
     C***LR*****              PARM           SEQ                                      S01117 BUG7415
     C***LR*****              PARM *BLANKS   SENTY   3                                S01117 BUG7415
     C***LR*****              PARM           SFILEU                                   S01117 BUG7415
     C***LR*****              PARM           ZSNUMU  60                               S01117 BUG7415
     C***LR*****              PARM           ZSERR   1                                S01117 BUG7415
     C***LR*****    *LOCK     IN   LDA                                                S01117 BUG7415
      *                                                                   S01117
     C***LR*****    ZSERR     IFEQ 'Y'                                                S01117 BUG7415
      **  ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAM       S01117
     C***LR*****              SETON                     U7U8                          S01117 BUG7415
     C***LR*****              RETRN                                                   S01117 BUG7415
     C***LR*****              END                                                     S01117 BUG7415
      **                                                                  S01117
      **    WHEN LR INDICATOR SET ON WITHOUT EXECUTING THE FIRST          S01117
      **    CYCLE                                                         S01117
      **                                                                  S01117
     C***LR*****    P1OP      IFNE 'Y'                                                S01117 BUG7415
     C***LR*****              EXSR #ZZ                                                S01117 BUG7415
     C***LR*****              END                                                     S01117 BUG7415
      **                                                                  S01117
      **    OR P1 OPENED BUT NO DETAILS TO REPORT                         S01117
      **                                                                  S01117
     C***LR*****    P1WR      IFNE 'Y'                                                S01117 BUG7415
     C***LR*****              SETON                     37                            S01117 BUG7415
     C***LR*****              END                                                     S01117 BUG7415
      **                                                                  S01117
     C***LR*U7**                                                                              CLE137
     C***AN*U8**            EXSR      *PSSR                                            S01117 CLE137
     C  NU7                                                                                 MD023534
     CANNU8              COMMIT                                                             MD023534
     C                   RETURN                                                               CLE137
0494 C********************************************************************
0495 C* SR TO HASH MONTH HISTORY FILE
0496 C*
0497 C* CALLED BY MP (3 TIMES)
0498 C*  CALLS : GLZADD
0499 C*
0500 C     MHASH         BEGSR                                                  *** MHASH ***
0501 C*
0502 C*  BALANCE BEGINNING IN MONTH
     C   05
0503 CAN 42
     COR 04
0504 CAN 42              MOVE      WPRAMH        ZZAMT
0505 C* NEW LOAN READ-BALANCE OF PREVIOUS TOTALLED TO NOW
0506 C*
0507 C   45              MOVE      WBEG          ZZAMT
0508 C* AMOUNT RECORD NOT IN BALANCE CALC
0509 C*
     C   07
0510 CANN41
     COR 06
0511 CANN41              MOVE      PRAM          ZZAMT
0512 C* FIRST AMOUNT REC NOT ADDING INTO BEGINNING BALANCE-
0513 C* HASH BOTH BALANCE AND AMOUNT
     C   07
0514 CAN 43
     COR 06
0515 CAN 43WBEG          ADD       PRAM          WBOTH            13 0
     C   07
0516 CAN 43
     COR 06
0517 CAN 43              MOVE      WBOTH         ZZAMT
0518 C*
0519 C                   EXSR      GLZADD
0520 C* COUNT
0521 C     MNH           ADD       1             MNH
     C   07
0522 CAN 43
     COR 06
0523 CAN 43MNH           ADD       1             MNH
0524 C                   SETOFF                                       45
0525 C                   ENDSR
0526 C********************************************************************
0527 C* BALANCE AS AT 1ST THIS MONTH
0528 C*
0529 C* CALLED BY:MP
0530 C*
0531 C     BALCAL        BEGSR                                                  **  BALCAL  **
0532 C* CHECK VALUE DATE
0533 C     VDAT          COMP      BEGDAT                             434143
0534 C   43              GOTO      BALEND
0535 C     AMTP          COMP      'PI'                                   44
0536 C  N44AMTP          COMP      'IN'                                   44
0537 C  N44WBEG          SUB       PRAM          WBEG
0538 C   44WBEG          ADD       PRAM          WBEG
0539 C     BALEND        TAG                                                    **BALEND TAG **
0540 C                   ENDSR
0541 C********************************************************************
0542 C** ON READ OF MAT.HISTORY HEAD.CHAIN IN CLINT
0543 C*
0544 C* CALLED BY: MP
0545 C* CALLS : ZDATE2
0546 C********** MATPRO    BEGSR                           *** MATPRO ***                    BUG7415
0547 C* SET IND. IF INT.CAPITALISATION INDIC IS-
0548 C* Y,FOR MA DETAIL LINES ON CARD
0549 C********** INTC      COMP 'Y'                      83                                  BUG7415
0550 C*
0551 C***05******CLIKEY    CHAINCLINT                81                   S01194
     C********** *IN05     IFEQ '1'                                       S01194             BUG7415
     C*                                                                   S01270
     C** CHECK FOR PARTS PURCH WITHOUT RECOURSE AND ENTER CUSTOMER NUMBER S01270
     C** ACCORDINGLY IE OLNO IF PP W/O RECOURSE                           S01270
     C*                                                                   S01270
     C********** PTYP      IFEQ 64                                 S01270 059865
     C***********PTYPH     IFEQ 64                                 059865 060423
     C********** PTYPM     IFEQ 64                                                    060423 BUG7415
     C********** RCSI      ANDNE'Y'                                                   S01270 BUG7415
     C********** PTYP      OREQ 65                                 S01270 059865
     C***********PTYPH     OREQ 65                                 059865 060423
     C********** PTYPM     OREQ 65                                                    060423 BUG7415
     C********** RCSI      ANDNE'Y'                                                   S01270 BUG7415
      *                                                                   CLE005
      ** If CLE005 is *ON, include new Parts Purchased-processing types   CLE005
      *                                                                   CLE005
     C********** CLE005    OREQ 'Y'                                                   CLE005 BUG7415
     C********** PTYPM     ANDEQ68                                                    CLE005 BUG7415
     C********** RCSI      ANDNE'Y'                                                   CLE005 BUG7415
     C********** CLE005    OREQ 'Y'                                                   CLE005 BUG7415
     C********** PTYPM     ANDEQ71                                                    CLE005 BUG7415
     C********** RCSI      ANDNE'Y'                                                   CLE005 BUG7415
      *                                                                   CLE005
     C**********           MOVELOLNO      CLIKEY 10                                   S01270 BUG7415
     C**********           ELSE                                                       S01270 BUG7415
     C**********           MOVELCNUMH     CLIKEY 10                                   S01194 BUG7415
     C**********           END                                                        S01270 BUG7415
     C***********          CALL 'AOCUSTR0'                         S01194 CSD007
     C**********           CALL 'AOCUSTR2'                                            CSD007 BUG7415
     C**********           PARM '*MSG   ' @RTCD                                       S01194 BUG7415
     C**********           PARM '*KEY   ' @OPTN                                       S01194 BUG7415
     C**********           PARM           CLIKEY                                      S01194 BUG7415
     C**********           PARM '*CNUM  ' KEYSTS  7                                   S01194 BUG7415
     C***********SDCUST    PARM SDCUST    DSSDY                    S01194 CSD007
     C********** SDCUST    PARM SDCUST    DSLDY                                       CSD007 BUG7415
0552 C*
0553 C**N81******RECI      COMP 'D'                  8181                 S01194
     C********** @RTCD     IFNE *BLANKS                                               S01194 BUG7415
     C********** CSD007    ANDNE'Y'                                                   CSD007 BUG7415
      *                                                                   CSD007
     C********** @RTCD     ORNE *BLANKS                                               CSD007 BUG7415
     C********** @RTCD     ANDEQ'*NRF   '                                             CSD007 BUG7415
     C********** BBDTDL    ANDNE*ZEROS                                                CSD007 BUG7415
     C********** CSD007    ANDEQ'Y'                                                   CSD007 BUG7415
      *                                                                   CSD007
     C********** @RTCD     ORNE *BLANKS                                               CSD007 BUG7415
     C********** @RTCD     ANDNE'*NRF   '                                             CSD007 BUG7415
     C********** CSD007    ANDEQ'Y'                                                   CSD007 BUG7415
      *                                                                   CSD007
     C**********           SETON                     U7U8LR                           S01194 BUG7415
     C**********           MOVE 'SDCUSTPD'DBFILE           ***************            S01194 BUG7415
     C**********           Z-ADD4         DBASE            * DBERROR 04  *            S01194 BUG7415
     C**********           MOVELCLIKEY    DBKEY            ***************            S01194 BUG7415
     C**********           GOTO ENDPRO                                                S01194 BUG7415
     C**********           END                                                        S01194 BUG7415
      *                                                                   159255
      ** If participations purchase with recourse, print original         159255
      ** borrower                                                         159255
      *                                                                   159255
     C********** PTYP      IFEQ 64                                                    159255 BUG7415
     C********** PTYP      OREQ 65                                                    159255 BUG7415
     C********** PTYP      OREQ 68                                                    159255 BUG7415
     C********** CLE005    ANDEQ'Y'                                                   159255 BUG7415
     C********** PTYP      OREQ 71                                                    159255 BUG7415
     C********** CLE005    ANDEQ'Y'                                                   159255 BUG7415
     C********** RCSI      IFEQ 'Y'                                                   159255 BUG7415
     C**********           MOVE *ON       *IN84                                       159255 BUG7415
     C**********           MOVELOLNO      CLIKEY                                      159255 BUG7415
      *                                                                   159255
     C***********          CALL 'AOCUSTR0'                         159255 CSD007
     C**********           CALL 'AOCUSTR2'                                            CSD007 BUG7415
     C**********           PARM '*MSG   ' @RTCD                                       159255 BUG7415
     C**********           PARM '*KEY   ' @OPTN                                       159255 BUG7415
     C**********           PARM           CLIKEY                                      159255 BUG7415
     C**********           PARM '*CNUM  ' KEYSTS  7                                   159255 BUG7415
     C***********SDCUST    PARM SDCUST    DSSDY                    159255 CSD007
     C********** SDCUST    PARM SDCUST    DSLDY                                       CSD007 BUG7415
      *                                                                   159255
     C**********           MOVELCRNM      CRNM2  20                                   159255 BUG7415
     C**********           MOVELCTWN      CTWN2  10                                   159255 BUG7415
     C**********           ENDIF                                                      159255 BUG7415
     C**********           ENDIF                                                      159255 BUG7415
      *                                                                   159255
0554 C**************       SETON                     U7U8LR               S01194
0555 C***81*********       MOVE 'CLINT'   DBFILE           ---------------S01194
0556 C***81*********       Z-ADD4         DBASE            --DATABASE 4 --S01194
0557 C***81*********       MOVELCLIKEY    DBKEY            ---------------S01194
0558 C***81*********       GOTO ENDPRO                                    S01194
0559 C* ZEROISE CARD PAGE COUNT
0560 C***05*****           Z-ADD0         PAGE2                                              BUG7415
     C**********           END                                                        S01194 BUG7415
0561 C*
0562 C*
0563 C***********CHAIN*TABLE*FILE*FOR*DECIMAL*PLACES*               TABLE S01194
0563 C**       ACCESS SDCURRPD FILE FOR DECIMAL PLACES                    S01194
0564 C*
0565 C**************       MOVEL'20      'TABKEY 12                       S01194
0566 C**************       MOVELCCYH      TKEY    4                       S01194
0567 C**************       MOVE '1'       TKEY                            S01194
0568 C**************       MOVE TKEY      TABKEY                          S01194
0569 C***********TABKEY    CHAINTABLE                47                   S01194
     C**********           MOVELCCYH      TKEY    3                                   S01194 BUG7415
     C**********           CALL 'AOCURRR0'                                            S01194 BUG7415
     C**********           PARM '*MSG   ' @RTCD   7                                   S01194 BUG7415
     C**********           PARM '*KEY   ' @OPTN   7                                   S01194 BUG7415
     C**********           PARM           TKEY                         A              S01194 BUG7415
     C********** SDCURR    PARM SDCURR    DSSDY                        B              S01194 BUG7415
0570 C*
0571 C*          DATABASE ERROR IF LIVE RECORD NOT FOUND
0572 C*
0573 C**N47******RECI      COMP 'D'                  4747                 S01194
     C********** @RTCD     IFNE *BLANK                                                S01194 BUG7415
     C**********           SETON                     LRU7U8                           S01194 BUG7415
     C**********           MOVE 'SDCURRPD'DBFILE           ***************            S01194 BUG7415
     C**********           Z-ADD5         DBASE            * DBERROR 05  *            S01194 BUG7415
     C**********           MOVE TKEY      DBKEY            ***************            S01194 BUG7415
     C**********           MOVE @OPTN     DBOPTN  7                                   S01194 BUG7415
     C**********           GOTO ENDPRO                                                S01194 BUG7415
     C**********           END                                                        S01194 BUG7415
0574 C***47*********       SETON                     U7U8LR               S01194
0575 C***47*********       MOVE '05'      DBASE            ---------------S01194
0576 C***47*********       MOVE 'TABLE'   DBFILE           -- DATABASE 5--S01194
0577 C***47*********       MOVELTABKEY    DBKEY            ---------------S01194
0578 C***47*********       GOTO ENDPRO                                    S01194
0579 C*
0580 C*          DETERMINE NO OF DECIMALS                    24=0
0581 C*                                                      25=1
0582 C**********           SETOF                     242627                                  BUG7415
0583 C********** CDP       COMP 1                      2425  26=2                            BUG7415
     C********** CDP       COMP 2                    27  26  27=3                            BUG7415
0586 C*
0587 C*         CONVERT HEADER DATES
0588 C*
0589 C********** VDATH     COMP 0                    48                                      BUG7415
0590 C***48*****           Z-ADDVDATH     ZDAYNO                                             BUG7415
0591 C***48*****           EXSR ZDATE2                                                       BUG7415
0592 C**N48*****           MOVE BLANKS    VDATE                                              BUG7415
0593 C***48*****           MOVE ZADATE    VDATE   7                                          BUG7415
0594 C*
0595 C********** MDATM     COMP 0                    49                                      BUG7415
0596 C***49*****           Z-ADDMDATM     ZDAYNO                                             BUG7415
0597 C***49*****           EXSR ZDATE2                                                       BUG7415
0598 C**N49*****           MOVE BLANKS    MATDE                                              BUG7415
0599 C***49*****           MOVE ZADATE    MATDE   7                                          BUG7415
0600 C*
0601 C*
0602 C**         ASSIGN SPREAD IND. AND CALC INTEREST RATE        SPREAD
0603 C*
0604 C********** SPINM     COMP 'A'                      52                                  BUG7415
0605 C********** SPINM     COMP 'S'                      53                                  BUG7415
0606 C********** SPINM     COMP 'P'                      54                                  BUG7415
0607 C**********           Z-ADDBRTEM     INTRC  117             INT RATE                    BUG7415
0608 C***52***** INTRC     ADD  RTSPM     INTRC                                              BUG7415
0609 C***53***** INTRC     SUB  RTSPM     INTRC                                              BUG7415
0610 C***54***** INTRC     DIV  100       WRK    119H                                        BUG7415
0611 C***54***** WRK       MULT RTSPM     INTRC     H                                        BUG7415
0612 C**
0613 C**   OUTPUT HEADINGS
0614 C**
0615 C**********           SETON                     46                                      BUG7415
     C**********           SETON                     20                               S01117 BUG7415
0616 C**********           EXCPT                                                             BUG7415
0617 C**********           SETOF                     46                                      BUG7415
      *                                                                   159255
      ** Set off Original Borrower Field                                  159255
      *                                                                   159255
     C**********           MOVE *OFF      *IN84                                       159255 BUG7415
      **                                                                  S01117
      **  SETOF 'NO DETAILS TO REPORT' IN AU                              S01117
      **  SINCE AT LEAST ONE RECORD IS SELECTED BY THE PGM                S01117
      **                                                                  S01117
     C***21*****           MOVE 'Y'       P1WR    1                                   S01117 BUG7415
      **                                                                  S01117
0618 C********** ENDPRO    ENDSR                                                             BUG7415
0619 C*
0620 C********************************************************************
0621 C*        MATURED  LOAN AMOUNT/RATES LINES
0622 C*
0623 C********** CARD      BEGSR                           *** CARD ******                   BUG7415
0624 C*          CALLED BY:MP
0625 C*
0626 C*          CALLS: ZDATE2(2)
0627 C**         CONVERT DATES
0628 C*
0629 C********** EXVD      COMP 0                    50                                      BUG7415
0630 C***50*****           Z-ADDEXVD      ZDAYNO                                             BUG7415
0631 C***50*****           EXSR ZDATE2                                                       BUG7415
0632 C**N50*****           MOVE BLANKS    EXVDE                                              BUG7415
0633 C***50*****           MOVE ZADATE    EXVDE   7                                          BUG7415
0634 C*
0635 C********** VDAT      COMP 0                    51                                      BUG7415
0636 C***51*****           Z-ADDVDAT      ZDAYNO                                             BUG7415
0637 C***51*****           EXSR ZDATE2                                                       BUG7415
0638 C**N51*****           MOVE BLANKS    VDATD                                              BUG7415
0639 C***51*****           MOVE ZADATE    VDATD   7                                          BUG7415
     C***/COPY*WNCPYSRC,LE0900CCP1                                                    S01408 BUG7415
0640 C*
0641 C**         PROCESS ACCORDING TO AMENDMENT TYPE
0642 C*
0643 C********** AMTP      COMP 'BC'                     56                                  BUG7415
0644 C***56*****           GOTO BCT                                                          BUG7415
0645 C********** AMTP      COMP 'BR'                     56                                  BUG7415
0646 C***56*****           GOTO BRT                                                          BUG7415
0647 C********** AMTP      COMP 'IN'                     56                                  BUG7415
0648 C***56*****           GOTO INT                                                          BUG7415
0649 C********** AMTP      COMP 'MA'                     56                                  BUG7415
0650 C***56*****           GOTO QMAT                                                         BUG7415
0651 C********** AMTP      COMP 'MI'                     56                                  BUG7415
      *                                                                   CAC001
      **  If Analytical Accounting is present - only report 'MI'          CAC001
      **  amendments when interest adjustment amount is not Zero          CAC001
      *                                                                   CAC001
     C********** BGN0ST    IFEQ 'Y'                                                   CAC001 BUG7415
     C********** *IN56     IFEQ '1'                                                   CAC001 BUG7415
     C********** INTA      ANDEQ*ZERO                                                 CAC001 BUG7415
     C**********           MOVE '0'       *IN56                                       CAC001 BUG7415
     C**********           GOTO RECHAI                                                CAC001 BUG7415
     C**********           ENDIF                                                      CAC001 BUG7415
     C**********           ENDIF                                                      CAC001 BUG7415
      *                                                                   CAC001
0652 C***56*****           GOTO MIT                                                          BUG7415
0653 C********** AMTP      COMP 'MR'                     56                                  BUG7415
0654 C***56*****           GOTO MRT                                                          BUG7415
0655 C********** AMTP      COMP 'PI'                     56                                  BUG7415
0656 C***56*****           GOTO PIT                                                          BUG7415
0657 C********** AMTP      COMP 'RE'                     56                                  BUG7415
0658 C***56*****           GOTO RET                                                          BUG7415
0659 C********** AMTP      COMP 'RO'                     56                                  BUG7415
0660 C***56*****           GOTO ROT                                                          BUG7415
0661 C********** AMTP      COMP 'SA'                     56                                  BUG7415
0662 C***56*****           GOTO SAT                                                          BUG7415
0663 C********** AMTP      COMP 'SC'                     56                                  BUG7415
      *                                                                   CAC001
      **  If Analytical Accounting is present - only report 'SC'          CAC001
      **  amendments w/ a change to the interest rate/spread (flag = Y)   CAC001
      *                                                                   CAC001
     C********** BGN0ST    IFEQ 'Y'                                                   CAC001 BUG7415
     C********** *IN56     IFEQ '1'                                                   CAC001 BUG7415
     C********** IRCF      ANDNE'Y'                                                   CAC001 BUG7415
     C**********           MOVE '0'       *IN56                                       CAC001 BUG7415
     C**********           GOTO RECHAI                                                CAC001 BUG7415
     C**********           ENDIF                                                      CAC001 BUG7415
     C**********           ENDIF                                                      CAC001 BUG7415
      *                                                                   CAC001
0664 C***56*****           GOTO SCT                                                          BUG7415
0665 C********** AMTP      COMP 'ST'                     56                                  BUG7415
0666 C***56*****           GOTO STT                                                   S01270 BUG7415
      *                                                                                       CLE028
      ** If processing type is 'CH', report charges added-on                                  CLE028
      *                                                                                       CLE028
     C********** CLE028    IFEQ 'Y'                                                   CLE028 BUG7415
     C********** AMTP      ANDEQ'CH'                                                  CLE028 BUG7415
     C********** PTYP      ANDEQ80                                                    CLE028 BUG7415
     C**********           MOVE *ON       *IN56                                       CLE028 BUG7415
     C**********           MOVE NARR,37   NARRA                                       CLE028 BUG7415
     C**********           Z-ADDCHDU      PAMT                                        CLE028 BUG7415
     C**********           MOVE *ON       *IN57                                       CLE028 BUG7415
     C**********           EXCPT                                                      CLE028 BUG7415
     C**********           MOVE *OFF      *IN57                                       CLE028 BUG7415
     C**********           GOTO RECHAI                                                CLE028 BUG7415
     C**********           ENDIF                                                      CLE028 BUG7415
     C*                                                                   S01270
     C** CHECK FOR LOAN SUB-TYPE CHANGE AND CONDITION OUTPUT              S01270
     C** FOR REPORT                                                       S01270
     C*                                                                   S01270
     C********** AMTP      IFEQ 'LS'                                                  S01270 BUG7415
     C**********           MOVE '1'       *IN10                                       S01270 BUG7415
     C**********           MOVE NARR,36   NARRA                                       S01270 BUG7415
     C**********           END                                                        S01270 BUG7415
     C**********           GOTO RECHAI                                                S01270 BUG7415
     C***/COPY*WNCPYSRC,LE0900C004                                                           BUG7415
     C*                                                                   S01270
0667 C********************** BASE RATE CODE CHANGE **********************
0668 C********** BCT       TAG                                      *BCT                     BUG7415
0669 C**********           MOVE NARR,1    NARRA  30                                          BUG7415
0670 C**********           Z-ADDBRTE      PRATE  117                                         BUG7415
0671 C**********           SETON                     5557                                    BUG7415
0672 C**********           EXCPT                                                             BUG7415
0673 C**********           SETOF                     5557                                    BUG7415
0674 C**********           GOTO RECHAI                                                       BUG7415
0675 C*
0676 C********************** BASE RATE CHANGE ***************************
0677 C********** BRT       TAG                                      *BRT                     BUG7415
0678 C**********           MOVE NARR,2    NARRA                                              BUG7415
0679 C**********           Z-ADDBRTE      PRATE                                              BUG7415
0680 C**********           SETON                     5557                                    BUG7415
0681 C**********           EXCPT                                                             BUG7415
0682 C**********           SETOF                     5557                                    BUG7415
0683 C**********           GOTO RECHAI                                                       BUG7415
0684 C*
0685 C********************** INTEREST PAYMENT ,OR CAPITALISED ***********
0686 C********** INT       TAG                                       *INT                    BUG7415
0687 C********** PRAM      COMP 0                    595958                                  BUG7415
     C********** CLE028    IFEQ 'Y'                                                   CLE028 BUG7415
     C********** PTYP      ANDEQ80                                                    CLE028 BUG7415
     C**********           MOVE NARR,38   NARRA                                       CLE028 BUG7415
     C**********           ELSE                                                       CLE028 BUG7415
0688 C******58**           MOVE NARR,3    NARRA                                              BUG7415
0689 C***59*****           MOVE NARR,4    NARRA                                              BUG7415
     C**********           ENDIF                                                      CLE028 BUG7415
0690 C**********           Z-ADDINTA      PAMT   130                                         BUG7415
0691 C**********           SETON                     57                                      BUG7415
0692 C**********           EXCPT                                                             BUG7415
0693 C**********           SETOF                     57                                      BUG7415
0694 C**********           GOTO RECHAI                                                       BUG7415
0695 C*
0696 C********************** MATURITY - PRINCIPAL ***********************
0697 C****                            - INTEREST
0698 C*****                           - WITHHOLDING TAX
0699 C********** QMAT      TAG                                      *QMAT                    BUG7415
0700 C**N23*****           MOVE NARR,5    NARRA                                              BUG7415
0701 C***23*****           MOVE NARR,32   NARRA                                              BUG7415
0702 C**********           Z-ADDPRAM      PAMT                                               BUG7415
0703 C**********           SETON                     57                                      BUG7415
0704 C**********           EXCPT                                                             BUG7415
0705 C**********           SETOF                     57                                      BUG7415
0706 C********** INTA      COMP 0                    6060                                    BUG7415
0707 C**N60*****           GOTO NOT60                                                        BUG7415
0708 C* IF INT. CAPITALISED,MOVE IN RELEVANT NARRATIVE
0709 C***83*****           MOVE NARR,31   NARRA                                              BUG7415
0710 C**N83*****           MOVE NARR,6    NARRA                                              BUG7415
0711 C**********           Z-ADDINTA      PAMT                                               BUG7415
0712 C**********           SETON                     57                                      BUG7415
0713 C**********           EXCPT                                                             BUG7415
0714 C********** NOT60     TAG                             *NOT60*                           BUG7415
     C***/COPY*WNCPYSRC,LE0900CCP4                                                    S01408 BUG7415
0715 C**********           SETOF                     576061                                  BUG7415
0716 C********** WTXA      COMP 0                    6161                                    BUG7415
0717 C**N61*****           GOTO RECHAI                                                       BUG7415
0718 C**********           MOVE NARR,7    NARRA                                              BUG7415
0719 C**********           Z-ADDWTXA      PAMT                                               BUG7415
0720 C**********           SETON                     57                                      BUG7415
0721 C**********           EXCPT                                                             BUG7415
0722 C**********           SETOF                     5761                                    BUG7415
0723 C**
0724 C**   IF INEREST IS CAPITALISED ONLY OUTPUT PRINCIPAL PORTION
0725 C**   TO MONTH'S HISTORY FILE.
0726 C**
0727 C***83***** PRAM      SUB  INTA      PRAM                                               BUG7415
0728 C**********           GOTO RECHAI                                                       BUG7415
0729 C********************** MANUAL INTEREST ADJUSTMENT *****************
0730 C********** MIT       TAG                                       *MIT                    BUG7415
0731 C**********           MOVE NARR,8    NARRA                                              BUG7415
0732 C**********           Z-ADDINTA      PAMT                                               BUG7415
0733 C**********           SETON                     57                                      BUG7415
0734 C**********           EXCPT                                                             BUG7415
0735 C**********           SETOF                     57                                      BUG7415
0736 C**********           GOTO RECHAI                                                       BUG7415
0737 C********************** MANUAL REPAYMENT - PRINCIPAL ***************
0738 C*****                                   - INTEREST
0739 C******                                  - WITHHOLDING TAX
0740 C*******                                 - FEE
0741 C********** MRT       TAG                                       *MRT                    BUG7415
0742 C********** PRAM      COMP 0                    6262                                    BUG7415
0743 C**N62*****           GOTO NOT62                                                        BUG7415
0744 C**********           MOVE NARR,9    NARRA                                              BUG7415
0745 C**********           Z-ADDPRAM      PAMT                                               BUG7415
0746 C**********           SETOF                       62                                    BUG7415
0747 C***50***** VDAT      SUB  EXVD      DPDU    30 63                                      BUG7415
0748 C**N50*****           MOVEL'   -'    EXVDE                                              BUG7415
0749 C**********           SETON                     5764                                    BUG7415
0750 C**********           EXCPT                                                             BUG7415
0751 C**********           SETOF                     576463                                  BUG7415
0752 C********** NOT62     TAG                                    *NOT62                     BUG7415
0753 C********** INTA      COMP 0                    6565                                    BUG7415
0754 C**N65*****           GOTO NOT65                                                        BUG7415
0755 C**********           MOVE NARR,10   NARRA                                              BUG7415
0756 C**********           Z-ADDINTA      PAMT                                               BUG7415
0757 C**********           SETOF                     65                                      BUG7415
0758 C***50***** VDAT      SUB  EXVD      DPDU       63                                      BUG7415
0759 C**N50*****           MOVEL'   -'    EXVDE                                              BUG7415
0760 C**********           SETON                     5764                                    BUG7415
0761 C**********           EXCPT                                                             BUG7415
0762 C**********           SETOF                     576463                                  BUG7415
0763 C********** NOT65     TAG                                   *NOT65                      BUG7415
     C***/COPY*WNCPYSRC,LE0900CCP2                                                    S01408 BUG7415
0764 C********** WTXA      COMP 0                    6666                                    BUG7415
0765 C**N66*****           GOTO NOT66                                                        BUG7415
0766 C**********           MOVE NARR,11   NARRA                                              BUG7415
0767 C**********           Z-ADDWTXA      PAMT                                               BUG7415
0768 C**********           SETOF                     66                                      BUG7415
0769 C***50***** VDAT      SUB  EXVD      DPDU       63                                      BUG7415
0770 C**N50*****           MOVEL'   -'    EXVDE                                              BUG7415
0771 C**********           SETON                     5764                                    BUG7415
0772 C**********           EXCPT                                                             BUG7415
0773 C**********           SETOF                     576463                                  BUG7415
0774 C********** NOT66     TAG                                    *NOT66                     BUG7415
0775 C********** FEAM      COMP 0                    6767                                    BUG7415
0776 C**N67*****           GOTO RECHAI                                                       BUG7415
0777 C**********           Z-ADDFEAM      PAMT                                               BUG7415
0778 C**********           MOVE NARR,12   NARRA                                              BUG7415
0779 C**********           MOVE FECD      NARRA                                              BUG7415
0780 C**********           SETOF                     67                                      BUG7415
0781 C***50***** VDAT      SUB  EXVD      DPDU       63                                      BUG7415
0782 C**N50*****           MOVEL'   -'    EXVDE                                              BUG7415
0783 C**********           SETON                     5764                                    BUG7415
0784 C**********           EXCPT                                                             BUG7415
0785 C**********           SETOF                     576463                                  BUG7415
0786 C**********           GOTO RECHAI                                                       BUG7415
0787 C*
0788 C********************** PRINCIPAL INCREASE *************************
0789 C********** PIT       TAG                                     *PIT                      BUG7415
0790 C**********           MOVE NARR,13   NARRA                                              BUG7415
0791 C**********           Z-ADDPRAM      PAMT                                               BUG7415
0792 C**********           SETON                     57                                      BUG7415
0793 C**********           EXCPT                                                             BUG7415
0794 C**********           SETOF                     57                                      BUG7415
0795 C**********           GOTO RECHAI                                                       BUG7415
0796 C********************** REPAYMENT - PRINCIPAL **********************
0797 C*****                            - INTEREST
0798 C*******                          - WITHHOLDING TAX
0799 C********** RET       TAG                                     *RET                      BUG7415
0800 C********** PRAM      COMP 0                    6868                                    BUG7415
0801 C**N68*****           GOTO NOT68                                                        BUG7415
0802 C**********           MOVE NARR,14   NARRA                                              BUG7415
0803 C**********           Z-ADDPRAM      PAMT                                               BUG7415
0804 C**********           SETON                     57                                      BUG7415
0805 C**********           EXCPT                                                             BUG7415
0806 C**********           SETOF                     5768                                    BUG7415
0807 C********** NOT68     TAG                                     *NOT68                    BUG7415
0808 C********** INTA      COMP 0                    6969                                    BUG7415
0809 C**N69*****           GOTO NOT69                                                        BUG7415
0810 C**********           MOVE NARR,15   NARRA                REPAY INT                     BUG7415
0811 C**********           Z-ADDINTA      PAMT                                               BUG7415
0812 C**********           SETON                     57                                      BUG7415
0813 C**********           EXCPT                                                             BUG7415
0814 C**********           SETOF                     5769                                    BUG7415
0815 C********** NOT69     TAG                                    *NOT69                     BUG7415
     C***/COPY*WNCPYSRC,LE0900CCP3                                                    S01408 BUG7415
0816 C********** WTXA      COMP 0                    7070                                    BUG7415
0817 C**N70*****           GOTO RECHAI                                                       BUG7415
0818 C**********           MOVE NARR,16   NARRA                                              BUG7415
0819 C**********           Z-ADDWTXA      PAMT                                               BUG7415
0820 C**********           SETON                     57                                      BUG7415
0821 C**********           EXCPT                                                             BUG7415
0822 C**********           SETOF                     5770                                    BUG7415
0823 C**********           GOTO RECHAI                                                       BUG7415
0824 C*
0825 C********************** ROLLOVER - BASE RATE ***********************
0826 C******                         - RATE
0827 C******                         - SPREAD-ADD
0828 C******                         - SPREAD-SUBTRACT
0829 C*******                        - SPREAD-PERCENTAGE
0830 C********** ROT       TAG                                      *ROT                     BUG7415
0831 C********** BRTE      COMP 0                    71  72                                  BUG7415
0832 C***72***** RTSP      COMP 0                    73                                      BUG7415
0833 C***71*****           MOVE NARR,17   NARRA                                              BUG7415
0834 C***71*****           Z-ADDBRTE      PRATE                                              BUG7415
0835 C***73*****           MOVE NARR,18   NARRA                                              BUG7415
0836 C***73*****           Z-ADDRTSP      PRATE                                              BUG7415
0837 C**********           SETON                     5557                                    BUG7415
0838 C***71*****                                                                             BUG7415
0839 C***OR*73**              EXCPT                                                          BUG7415
0840 C**********           SETOF                     5557                                    BUG7415
0841 C***71***** RTSP      COMP 0                    74                                      BUG7415
0842 C***74*52**           MOVE NARR,19   NARRA                                              BUG7415
0843 C***74*53**           MOVE NARR,20   NARRA                                              BUG7415
0844 C***74*54**           MOVE NARR,21   NARRA                                              BUG7415
0845 C***74*****           Z-ADDRTSP      PRATE                                              BUG7415
0846 C***74*****           SETON                     5557                                    BUG7415
0847 C***74*****           EXCPT                                                             BUG7415
     C***/COPY*WNCPYSRC,LE0900C003                                                           BUG7415
0848 C**********           SETOF                     555771                                  BUG7415
0849 C**********           SETOF                     727374                                  BUG7415
0850 C**********           GOTO RECHAI                                                       BUG7415
0851 C*
0852 C********************** STOP ACCRUALS ******************************
0853 C*******                START ACCRUALS
0854 C********** SAT       TAG                                      *SAT                     BUG7415
0855 C********** STAI      COMP 'Y'                      75                                  BUG7415
0856 C********** STAI      COMP ' '                      76                                  BUG7415
0857 C***75*****           MOVE NARR,22   NARRA                                              BUG7415
0858 C***76*****           MOVE NARR,23   NARRA                                              BUG7415
0859 C**********           Z-ADD0         PRATE                                              BUG7415
0860 C**********           SETON                     5557                                    BUG7415
0861 C**********           EXCPT                                                             BUG7415
0862 C**********           SETOF                     555775                                  BUG7415
0863 C**********           SETOF                     76                                      BUG7415
0864 C**********           GOTO RECHAI                                                       BUG7415
0865 C*
0866 C********************** SPREAD CHANGE ******************************
0867 C********** SCT       TAG                                       *SCT                    BUG7415
0868 C**********           MOVE NARR,24   NARRA                                              BUG7415
0869 C**********           Z-ADDRTSP      PRATE                                              BUG7415
0870 C**********           SETON                     5557                                    BUG7415
0871 C**********           EXCPT                                                             BUG7415
0872 C**********           SETOF                     5557                                    BUG7415
0873 C**********           GOTO RECHAI                                                       BUG7415
0874 C********************** START - PRINCIPAL **************************
0875 C******                       - BASE RATE
0876 C******                       - RATE
0877 C******                       - SPREAD-ADD
0878 C*****                        - SPREAD-SUBTRACT
0879 C******                       - SPREAD-PERCENTAGE
0880 C********** STT       TAG                                       *STT                    BUG7415
     C**********           MOVE VDATE     VDATD                                              BUG7415
0881 C********** TOTI      COMP 0                    2322                                    BUG7415
0882 C**N23N22**           MOVE NARR,25   NARRA                                              BUG7415
0883 C***22*****                                                                             BUG7415
0884 C***OR*23**              MOVE NARR,33   NARRA                                           BUG7415
     C**********           Z-ADDPRAMH     PAMT                                               BUG7415
0886 C**********           SETON                     57                                      BUG7415
0887 C**********           EXCPT                                                             BUG7415
0888 C**********           SETOF                     57
0889 C*
0890 C***22*****           MOVE NARR,34   NARRA                                              BUG7415
0891 C***23*****           MOVE NARR,35   NARRA                                              BUG7415
0892 C***22*****           Z-SUBTOTI      PAMT                                               BUG7415
0893 C***23*****           Z-ADDTOTI      PAMT                                               BUG7415
0894 C***22*****           SETON                     23                                      BUG7415
0895 C***23*****           SETON                     57                                      BUG7415
0896 C**********           EXCPT                                                             BUG7415
0897 C**********           SETOF                     57                                      BUG7415
     C********** BRTEH     COMP 0                    77  78                                  BUG7415
0899 C***77*****           MOVE NARR,26   NARRA                                              BUG7415
     C***77*****           Z-ADDBRTEH     PRATE                                              BUG7415
0901 C***77*****           SETON                     5557                                    BUG7415
0902 C***77*****           EXCPT                                                             BUG7415
0903 C**********           SETOF                     5557                                    BUG7415
0904 C***78***** RTSP      COMP 0                    79                                      BUG7415
0905 C***79*****           MOVE NARR,27   NARRA                                              BUG7415
0906 C***79*****           Z-ADDRTSP      PRATE                                              BUG7415
0907 C***79*****           SETON                     5557                                    BUG7415
0908 C***79*****           EXCPT                                                             BUG7415
0909 C**********           SETOF                     5557                                    BUG7415
0910 C***77***** RTSP      COMP 0                    80                                      BUG7415
0911 C***80*****           Z-ADDRTSP      PRATE                                              BUG7415
0912 C***80*52**           MOVE NARR,28   NARRA                                              BUG7415
0913 C***80*53**           MOVE NARR,29   NARRA                                              BUG7415
0914 C***80*54**           MOVE NARR,30   NARRA                                              BUG7415
0915 C***80*****           SETON                     5557                                    BUG7415
0916 C***80*****           EXCPT                                                             BUG7415
0917 C**********           SETOF                     555777                                  BUG7415
0918 C**********           SETOF                     787980                                  BUG7415
0919 C*
0920 C********** RECHAI    ENDSR                           ** RECHAI TAG *                   BUG7415
0921 C********************************************************************
0922 C* SR FOR FIRST CYCLE PROCESSING
0923 C*
0924 C* CALLED BY  MP
0925 C* CALLS  ZSYSTM ZDATE1
0926 C*
0927 C     FIRCYL        BEGSR                                                  *** FIRCYL ***
      *                                                                                       CLE137
      ** Access data area CBTASKSP for commit block size                                      CLE137
      *                                                                                       CLE137
     C     *DTAARA       DEFINE    CBTASKSP      CBTASK                                       CLE137
     C                   IN        CBTASK                                                     CLE137
     C                   MOVE      CMTBLK        #OPTIM           10 0                        CLE137
      *                                                                                       CLE137
      ** Set commit counter to 1                                                              CLE137
      *                                                                                       CLE137
     C                   Z-ADD     1             #COMIT            6 0                        CLE137
     C**                                                                  S01117
     C*     Hard code program to process 'ALL' branches                   S01117
     C**                                                                  S01117
     C                   MOVE      'ALL'         BRNCH             3                           S0111
0928 C*
0929 C                   EXSR      ZSYSTM                                       ---------------
0930 C***99*********       Z-ADD1         DBASE            ---DATABASE 1--S01194
0931 C***99*********       MOVELZTABKY    DBKEY            ---------------S01194
0932 C   99              GOTO      FIREND
      *                                                                   CAC001
      **  Access Module Details                                           CAC001
      *                                                                   CAC001
     C                   CALL      'AOMMODR0'                                                  CAC00
     C                   PARM      '*MSG   '     @RTCD                                         CAC00
     C                   PARM      '*FIRST '     @OPTN                                         CAC00
     C     SDMMOD        PARM      SDMMOD        DSFDY                                         CAC00
      *                                                                   CAC001
     C     @RTCD         IFNE      *BLANKS                                                     CAC00
     C                   SETON                                        U7U8LR                   CAC00
     C                   SETON                                        99                       CAC00
     C                   MOVEL     'SDMMODPD'    DBFILE                                        CAC00
     C                   MOVEL     @OPTN         DBKEY                          ************   CAC00
     C                   MOVEL     @OPTN         DBOPTN                         * DBERR 15 *   CAC00
     C                   Z-ADD     15            DBASE                          ************   CAC00
     C                   GOTO      FIREND                                                      CAC00
     C                   ENDIF                                                                 CAC00
      *                                                                   CLE005
      ** Check if CLE005 is switched *ON                                  CLE005
      *                                                                   CLE005
     C                   MOVE      'N'           CLE005            1                           CLE00
     C                   CALL      'AOSARDR0'                                                  CLE00
     C                   PARM      *BLANKS       WRTCD             7                           CLE00
     C                   PARM      '*VERIFY'     WOPTN             7                           CLE00
     C                   PARM      'CLE005'      WSARD             6                           CLE00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CLE00
      *                                                                   CLE005
     C     WRTCD         IFEQ      *BLANKS                                                     CLE00
     C                   MOVE      'Y'           CLE005                                        CLE00
     C                   ELSE                                                                  CLE00
      *                                                                   CLE005
      ** Call to program ended in error                                   CLE005
      *                                                                   CLE005
     C     WRTCD         IFNE      '*NRF   '                                                   CLE00
     C                   SETON                                          U7U8    LR             CLE00
     C                   SETON                                          99                     CLE00
     C                   MOVEL     'CLE005'      DBKEY                          ***************CLE00
     C                   MOVEL     WOPTN         DBOPTN                         * DB ERROR 07 *CLE00
     C                   Z-ADD     007           DBASE                          ***************CLE00
     C                   MOVE      'SCSARDPD'    DBFILE                                        CLE00
     C                   GOTO      FIREND                                                      CLE00
     C                   ENDIF                                                                 CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE005
     C********** CLE005    IFEQ 'Y'                                                   CLE005 BUG7415
     C**********           MOVE '1'       *IN30                                       CLE005 BUG7415
     C**********           ENDIF                                                      CLE005 BUG7415
      *                                                                   CSD007
      ** Access SAR details to check if 'Customer Closing' is             CSD007
      ** installed.                                                       CSD007
      *                                                                   CSD007
     C                   MOVE      'N'           CSD007            1                           CSD00
     C                   CALL      'AOSARDR0'                                                  CSD00
     C                   PARM      *BLANKS       WRTCD                                         CSD00
     C                   PARM      '*VERIFY'     WOPTN                                         CSD00
     C                   PARM      'CSD007'      WSARD                                         CSD00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CSD00
      *                                                                   CSD007
     C     WRTCD         IFEQ      *BLANKS                                                     CSD00
     C                   MOVE      'Y'           CSD007                                        CSD00
     C                   ELSE                                                                  CSD00
      *                                                                   CSD007
      ** Call to program ended in error                                   CSD007
      *                                                                   CSD007
     C     WRTCD         IFNE      '*NRF   '                                                   CSD00
     C                   SETON                                          U7U8    LR             CSD00
     C                   SETON                                          99                     CSD00
     C                   MOVEL     'CSD007'      DBKEY                                         CSD00
     C                   MOVEL     WOPTN         DBOPTN                                        CSD00
     C                   Z-ADD     008           DBASE                                         CSD00
     C                   MOVE      'SCSARDPD'    DBFILE                                        CSD00
     C                   GOTO      FIREND                                                      CSD00
     C                   ENDIF                                                                 CSD00
     C                   ENDIF                                                                 CSD00
     C/COPY WNCPYSRC,LEH01214
      *                                                                                       CLE028
      ** Check if CLE028 is switched *ON                                                      CLE028
      *                                                                                       CLE028
     C**********           MOVE 'N'       CLE028  1                                   CLE028 BUG7415
     C**********           CALL 'AOSARDR0'                                            CLE028 BUG7415
     C**********           PARM *BLANKS   PRTCD   7                                   CLE028 BUG7415
     C**********           PARM '*VERIFY' POPTN   7                                   CLE028 BUG7415
     C**********           PARM 'CLE028'  PSARD   6                                   CLE028 BUG7415
     C********** SCSARD    PARM SCSARD    DSFDY                                       CLE028 BUG7415
      *                                                                                       CLE028
     C********** PRTCD     IFEQ *BLANKS                                               CLE028 BUG7415
     C**********           MOVE 'Y'       CLE028                                      CLE028 BUG7415
     C**********           ELSE                                                       CLE028 BUG7415
      *                                                                                       CLE028
      ** Call to program ended in error                                                       CLE028
      *                                                                                       CLE028
     C********** PRTCD     IFNE '*NRF   '                                             CLE028 BUG7415
     C**********           MOVE *ON       *INU7                                       CLE028 BUG7415
     C**********           MOVE *ON       *INU8                                       CLE028 BUG7415
     C**********           MOVE *ON       *INLR                                       CLE028 BUG7415
     C**********           MOVE *ON       *IN99                                       CLE028 BUG7415
     C**********           MOVELPSARD     DBKEY                                       CLE028 BUG7415
     C**********           MOVELPOPTN     DBOPTN                                      CLE028 BUG7415
     C**********           Z-ADD009       DBASE                                       CLE028 BUG7415
     C**********           MOVE 'SCSARDPD'DBFILE                                      CLE028 BUG7415
     C**********           GOTO FIREND                                                CLE028 BUG7415
     C**********           ENDIF                                                      CLE028 BUG7415
     C**********           ENDIF                                                      CLE028 BUG7415
     C**                                                                  S01117
     C**   IN THE DATAAREA RUNDAT                                         S01117
     C**                                                                  S01117
     C     *DTAARA       DEFINE    RUNDAT        RUNDT                                         S0111
     C                   IN        RUNDT                                                       S0111
     C**                                                                  S01117
     C********** MBIN      IFEQ 'Y'                                                   S01117 BUG7415
     C**********           SETON                     35                               S01117 BUG7415
     C**********           END                                                        S01117 BUG7415
     C**                                                                  S01117
0933 C** OBTAIN FIVE FIGURE DAY NO. OF FIRST AND LAST DAY
0934 C** IN THIS MONTH
0935 C                   Z-ADD     1             X                 2 0
0936 C     WMNT          LOOKUP    ZMNM(X)                                40
0937 C   40              MOVEL     X             WOR               4 0
0938 C   40              MOVE      WYER          WOR
0939 C                   MOVE      WOR           WOR1              6 0
0940 C                   MOVEL     '01'          WOR1
0941 C** CONVERT FIRST OF MONTH TO DAY NO.
0942 C                   SETOFF                                       98
0943 C                   MOVE      WOR1          ZDATE
0944 C*
0945 C                   EXSR      ZDATE1
0946 C   99              GOTO      FIR1
0947 C                   Z-ADD     ZDAYNO        BEGDAT            5 0
0948 C* 91 +92 FROM ZDATE1 INDICATES FEB IN LEAP YR
0949 C                   MOVEL     ZFMD(X)       WOR1
     C   91
0950 CAN 92              MOVEL     '29'          WOR1
0951 C                   MOVE      WOR1          ZDATE
0952 C                   EXSR      ZDATE1
0953 C                   Z-ADD     ZDAYNO        ENDDAT            5 0
0954 C     FIR1          TAG                                                    ++ FIR1 TAG ++
0955 C   99              MOVEL     ZDAYNO        DBKEY                          ---------------
0956 C   99              Z-ADD     2             DBASE                          ---DATABASE 2--
0957 C   99              GOTO      FIREND                                       ---------------
0958 C** SETUP RECORD COUNTS (INCL HEAD +TRAIL)
0959 C                   Z-ADD     2             MAT               5 0
0960 C**********         Z-ADD     2             MNH               5 0                        CLE137
0961 C                   Z-ADD     2             HIS               5 0
0962 C                   Z-ADD     0             HIU               5 0
0963 C** RESET DATE FORMAT INDICATOR
0964 C     DATF          COMP      'M'                                    98
0965 C* SETUP WORKFIELD(S)
0966 C*
0967 C                   MOVE      ' '           BLANKS            7
0968 C**************       MOVE 'A'       AY                              S01194
0969 C     FIREND        TAG                                                    ***FIREND TAG**
0970 C   99              SETON                                        U7U8LR
0971 C***99*********       MOVE 'TABLE'   DBFILE                          S01194
0972 C                   MOVE      'LE0900'      DBPGM
     C/COPY WNCPYSRC,LE0900C002
0973 C                   ENDSR
     C/COPY WNCPYSRC,LE0900C006
0974 C********************************************************************
0975 C**
0976 C**   ZSYSTM SR. TO CHAIN TO THE INSTALLATION CONTROL DATA RECORD.
0977 C**
0978 C     ZSYSTM        BEGSR                                                  *** ZSYSTM ***
0979 C**************                                                      S01194
0980 C*****SET*UP*KEY FOR INSTALLATION CONTROL RECORD.                    S01194
0981 C**************       MOVEL'01      'ZTABKY 12                       S01194
0982 C**************       MOVE '  10'    ZTABKY                          S01194
0983 C**************                                                      S01194
0984 C***********ZTABKY    CHAINTABLE                99    ON NOT THERE   S01194
0985 C**N99******RECI      COMP 'D'                  9999  ON, IS DELETED S01194
     C**                                                                  S01194
     C**   ACCESS BANK DETAILS                                            S01194
     C**                                                                  S01194
     C                   CALL      'AOBANKR0'                                                  S0119
     C                   PARM      '*MSG   '     @RTCD             7                           S0119
     C                   PARM      '*FIRST '     @OPTN             7                           S0119
     C     SDBANK        PARM      SDBANK        DSFDY                                         S0119
     C*                                                                   S01194
     C     @RTCD         IFNE      *BLANK                                                      S0119
     C                   SETON                                        U7U8LR                   S0119
     C                   SETON                                        99                       S0119
     C                   MOVEL     'SDBANKPD'    DBFILE                                        S0119
     C                   MOVEL     @OPTN         DBKEY                          ***************S0119
     C                   MOVEL     @OPTN         DBOPTN            7            * DBERROR 001 *S0119
     C                   Z-ADD     1             DBASE                          ***************S0119
     C                   ELSE                                                                  S0119
0986 C**
0987 C**   CHECK SYSTEM DATE FORMAT, DDMMYY OR MMDDYY.
0988 C     DATF          COMP      'M'                                    98    MMDDYY, 98 ON
     C                   END                                                                   S0119
0989 C**
0990 C                   ENDSR
0991 C**
0992 C**
0993 C********************************************************************
0994 C********************************************************************
0995 C* SUBROUTINE TO ADD AN AMOUNT (ZZAMT) TO THE TOTAL (ZZTOTI,ZZTOTD)
0996 C*   IND '99' IS SET BY AN OVERFLOW ERROR
0997 C*
0998 CSR   GLZADD        BEGSR                                                  *** GLZADD ****
0999 C*
1000 CSR                 Z-ADD     ZZAMT         ZZAMT            15 3    91    -DEFINE ZZAMT
1001 CSR 91              GOTO      ZZAEND                                       AMT = 0.BYPASS
1002 C*
1003 C* SPLIT ZZAMT INTO INTEGER AND DECIMAL FIELDS
1004 CSR                 Z-ADD     ZZAMT         ZZAMTI           15 0          INTEGER FIELD
1005 CSR                 MOVE      ZZAMT         ZZAMTD            3 0          DECIMAL FIELD
1006 C* BOTH ZZAMTI AND ZZAMTD CONTAIN A 'SIGN' ZONE NOW
1007 C*
1008 CSR                 EXSR      GLZSUM
1009 CSR   ZZAEND        ENDSR                                                  ** ZZAEND TAG *
1010 C*
1011 C********************************************************************
1012 C* SUBROUTINE TO CARRY OUT THE ADDITION FOR SUBROUTINES -
1013 C*                        GLZADD, GLZSUB, GLZCMP.
1014 C*          PARAMETERS PASSED -
1015 C*                     I/P ZZAMTI ZZAMTD
1016 C*                     O/P ZZTOTI ZZTOTD ZZNEGD IND 96 IND 99.
1017 C*
1018 CSR   GLZSUM        BEGSR                                                  *** GLZSUM ****
1019 C*
1020 CSR                 Z-ADD     ZZTOTI        ZZTOTI           15 0          DEFINE ZZTOTI
1021 CSR                 Z-ADD     ZZTOTD        ZZTOTD            3 0          DEFINE ZZTOTD
1022 CSR                 SETOFF                                       919293
1023 CSR                 SETOFF                                       949599
1024 C*
1025 C*    DETERMINE SIGN OF ZZAMTI & D,   92 IF NEG
1026 CSR   ZZAMTI        COMP      0                                    9293
1027 CSR 93ZZAMTD        COMP      0                                    9293
1028 CSR 93              GOTO      ZZSEND                                       ZERO BYPASS
1029 C*
1030 C*    DETERMINE SIGN OF ZZTOTI & D, 91 IF NEG.
1031 CSR   ZZTOTI        COMP      0                                    9193
1032 CSR 93ZZTOTD        COMP      0                                    9193
1033 C*
1034 C*    IF ZZTOTAL IS ZERO, RETURN ZZAMOUNT.
1035 CSR 93              Z-ADD     ZZAMTI        ZZTOTI
1036 CSR 93              Z-ADD     ZZAMTD        ZZTOTD
1037 CSR 93              GOTO      ZZSEND                                       ZERO BYPASS
1038 C*    IF SIGNS DIFFER BYPASS OVERFLOW CHECKS.
     CSR 91
1039 CANN92
     CORN91
1040 CAN 92              GOTO      ZZOFPS
1041 C*
1042 CSR   ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
1043 CSR   ZZWK2         COMP      999                                93        '93' = CARRY
1044 CSRN93ZZWK2         COMP      -999                                 93        INTO INTEGER.
1045 C*
     CSR 93
1046 CANN92ZZAMTI        ADD       1             ZZWK3            15 0          ADD 'CARRY' +VE
     CSR 93
1047 CAN 92ZZAMTI        SUB       1             ZZWK3                          SUB 'CARRY' -VE
1048 CSR 93ZZTOTI        ADD       ZZWK3         ZZWK3
1049 CSRN93ZZTOTI        ADD       ZZAMTI        ZZWK3
1050 C*
1051 C* IF THE MODULUS OF ZZWK3 IS LT MOD. ZZTOTI THEN O/F HAS OCCURED
1052 CSRN92ZZWK3         COMP      ZZTOTI                               99      -92 MEANS NOS.
1053 CSR 92ZZWK3         COMP      ZZTOTI                             99         NEGATIVE
1054 CSRN99              Z-ADD     ZZWK2         ZZTOTD
1055 CSRN99              Z-ADD     ZZWK3         ZZTOTI
1056 C*
1057 C* IF O/F ZEROIZE ZZAMT , IND '99' SET AND ZZTOT FIELDS LEFT INTACT.
1058 CSR 99              Z-ADD     0             ZZAMT            15 3
1059 CSR                 GOTO      ZZSEND
1060 C*
1061 C* THE 'SIGNS' ARE DIFFERENT
1062 CSR   ZZOFPS        TAG                                                    ** ZZOFPS TAG**
1063 C* IF ZZAMT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZTOT
1064 C*
1065 CSR 92              Z-SUB     ZZAMTI        ZZAMTI           15 0
1066 CSR 92              Z-SUB     ZZAMTD        ZZAMTD            3 0
1067 C*
1068 C* IF ZZTOT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZAMT.
1069 C*
1070 CSR 91              Z-SUB     ZZTOTI        ZZTOTI
1071 CSR 91              Z-SUB     ZZTOTD        ZZTOTD
1072 C* BOTH ZZAMT AND ZZTOT ARE NOW POSITIVE.
1073 C*
1074 CSR   ZZTOTI        COMP      ZZAMTI                             93  95
1075 CSR 95ZZTOTD        COMP      ZZAMTD                             93  95
1076 C*
1077 C* IF ZZTOT EQ. ZZAMT RETURN ZERO.
1078 CSR 95              Z-ADD     0             ZZTOTI
1079 CSR 95              Z-ADD     0             ZZTOTD
1080 CSR 95              GOTO      ZZSEND
1081 C*
1082 C* IF ZZTOT GT. ZZAMT.
1083 CSR 93ZZAMTD        COMP      ZZTOTD                             94
     CSR 93
1084 CAN 94ZZTOTI        SUB       1             ZZTOTI
     CSR 93
1085 CAN 94ZZTOTD        ADD       1000          ZZWK2
1086 CSR 93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     CSR 93
1087 CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     CSR 93
1088 CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
1089 C*
1090 C*
1091 C* IF ZZAMT GT. ZZTOT.
1092 CSRN93ZZTOTD        COMP      ZZAMTD                             94
     CSRN93
1093 CAN 94ZZAMTI        SUB       1             ZZWK3            15 0
     CSRN93
1094 CAN 94ZZAMTD        ADD       1000          ZZWK2
     CSRN93
1095 CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     CSRN93
1096 CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
     CSRN93
1097 CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     CSRN93
1098 CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
1099 C*
1100 C* REVERSE SIGN OF ZZTOT IF LARGER I/P FIELDS WERE NEGATIVE
1101 CSR                 SETOFF                                       94
     CSR 93
1102 CAN 91
     CORN93
1103 CAN 92              SETON                                        94
1104 CSR 94              Z-SUB     ZZTOTI        ZZTOTI
1105 CSR 94              Z-SUB     ZZTOTD        ZZTOTD
1106 C**
1107 C**   RESTORE SIGN OF ZZAMTI & ZZAMTD IF IT WAS REVERSED.
1108 CSR 92              Z-SUB     ZZAMTI        ZZAMTI
1109 CSR 92              Z-SUB     ZZAMTD        ZZAMTD
1110 CSR   ZZSEND        TAG                                                    ** ZZSEND TAG *
1111 C**
1112 C**   IF ZZTOTD IS ZERO, AND ZZTOTI IS NEG. SET UP ZZNEGD.
1113 CSR                 SETOFF                                       96
1114 CSR   ZZTOTD        COMP      0                                      91
1115 CSR 91ZZTOTI        COMP      0                                    96
1116 CSR 96              MOVE      '.000-'       ZZNEGD            5
1117 CSR                 ENDSR                                                    ** ENDSR **
     C*****************************************************************                       CLE137
     C**                                                                 *                    CLE137
     C**  UPDPTR subroutine updates LEHISUPD with Start Key.             *                    CLE137
     C**                                                                 *                    CLE137
     C**  Called By:  Mainline code.                                     *                    CLE137
     C**  Calls:      -                                                  *                    CLE137
     C**                                                                 *                    CLE137
     C**  Indicators: -                                                  *                    CLE137
     C**                                                                 *                    CLE137
     C**  Arrays:     -                                                  *                    CLE137
     C**                                                                 *                    CLE137
     C**  Fields:                                                        *                    CLE137
     C**                                                                 *                    CLE137
      ******************************************************************                      CLE137
     C     UPDPTR        BEGSR                                                                CLE137
      *                                                                                       CLE137
     C                   MOVE      'A'           IXCKEY                                       CLE137
     C                   MOVE      NXTKEY        LSTKEY                                       CLE137
     C     IXCKEY        CHAIN     LEHISUPD                           38                      CLE137
     C     *IN38         IFEQ      '0'                                                        CLE137
     C                   MOVE      LBRCA         BRCA                                         CLE137
     C                   MOVE      LCNUM         CNUM                                         CLE137
     C                   MOVE      LLNRF         LNRF                                         CLE137
     C                   UPDATE    LEHISUF                                                    CLE137
     C                   END                                                                  CLE137
      *                                                                                       CLE137
     C                   ENDSR                                                                CLE137
      ********************************************************************                    CLE137
     C*****************************************************************                       CLE137
     C*****************************************************************              CLE137 MD024318
     C****ERROR*subroutine*performs*a*dump*of*LE0900*and*the*aborts.***              CLE137 MD024318
     C*****************************************************************              CLE137 MD024318
     C****Called*By:**Various******************************************              CLE137 MD024318
     C****Calls:******-************************************************              CLE137 MD024318
     C*****************************************************************              CLE137 MD024318
     C****Indicators:*-************************************************              CLE137 MD024318
     C*****************************************************************              CLE137 MD024318
     C****Arrays:*****-************************************************              CLE137 MD024318
     C*****************************************************************              CLE137 MD024318
     C****Fields:******************************************************              CLE137 MD024318
     C*****************************************************************              CLE137 MD024318
      *****************************************************************                       CLE137
     C*****ERROR         BEGSR                                                       CLE137 MD024318
      *****************************************************************              CLE137 MD024318
     C**********         MOVEL     'LE0900'      DBPGM                               CLE137 MD024318
     C**********         OUT       LDA                                               CLE137 MD024318
     C**********         SETON                                        U7U8LR         CLE137 MD024318
     C*****************************************************************              CLE137 MD024318
     C**********         DUMP                                                        CLE137 MD024318
     C**********         RETURN                                                      CLE137 MD024318
      *****************************************************************              CLE137 MD024318
     C**********         ENDSR                                                       CLE137 MD024318
1118 C********************************************************************
     C***/SPACE*3                                                                     S01117 BUG7415
     C********************************************************************S01117
     C*                                                                   S01117
     C* SUBROUTINE : #ZZ                                                  S01117
     C*                                                                   S01117
     C* CALLED BY MAIN PROCESSING DURING TOTAL TIME CALCULATIONS IF       S01117
     C* THE P1 FILES HAVE NOT ALREADY BEEN OPENED (IE, IF THERE ARE       S01117
     C* NO RECORDS READ AND THEREFORE FILES OPENING NOT PERFORMED)        S01117
     C*                                                                   S01117
     C********** #ZZ       BEGSR                                                      S01117 BUG7415
      *                                                                   S01117
     C**********           EXSR ZSYSTM                                                LN0788 BUG7415
     C**********           OPEN LE0900P1                                              S01117 BUG7415
     C**********           MOVE BRNCH     BRCAH                                       S01117 BUG7415
     C**********           MOVE *BLANKS   BRNM                                        S01117 BUG7415
      *                                                                   S01117
      *                                                                   S01117
      ** ENSURE REPORT SPOOL FILE RECORDED BY RCF                         S01117
      *                                                                   S01117
     C**********           Z-ADDSFNUM     ZSNUM   60                                  S01117 BUG7415
      *                                                                   S01117
      ** IF REPORT FOR ALL ENTITIES CALL ZSFILE WITH BLANK SENTY          S01117
      *                                                                   S01117
     C**********           OUT  LDA                                                   S01117 BUG7415
      *                                                                   S01117
     C********** BRNCH     IFEQ 'ALL'                                                 S01117 BUG7415
     C**********           CALL 'ZSFILE'                                              S01117 BUG7415
     C**********           PARM           SEQ                                         S01117 BUG7415
     C**********           PARM *BLANKS   SENTY   3                                   S01117 BUG7415
     C**********           PARM           SFILE                                       S01117 BUG7415
     C**********           PARM           ZSNUM                                       S01117 BUG7415
     C**********           PARM           ZSERR   1                                   S01117 BUG7415
      *                                                                   S01117
      ** ELSE REPORT BY ENTITY SO CALL ZSFILE WITH ENTITY REQUESTED       S01117
      *                                                                   S01117
     C**********           ELSE                            X1                         S01117 BUG7415
     C**********           CALL 'ZSFILE'                                              S01117 BUG7415
     C**********           PARM           SEQ                                         S01117 BUG7415
     C**********           PARM BRNCH     SENTY   3                                   S01117 BUG7415
     C**********           PARM           SFILE                                       S01117 BUG7415
     C**********           PARM           ZSNUM                                       S01117 BUG7415
     C**********           PARM           ZSERR   1                                   S01117 BUG7415
     C**********           END                                                        S01117 BUG7415
      *                                                                   S01117
     C********** *LOCK     IN   LDA                                                   S01117 BUG7415
      *                                                                   S01117
     C********** ZSERR     IFEQ 'Y'                                                   S01117 BUG7415
      **  ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAM       S01117
     C**********           SETON                     U7U8LR                           S01117 BUG7415
     C**********           RETRN                                                      S01117 BUG7415
     C**********           END                                                        S01117 BUG7415
      *                                                                   S01117
      ** AND GET ENTITY DETAILS FOR REPORT HEADINGS WHEN MULTIBRANCHING   S01117
      *                                                                   S01117
     C********** BRNCH     IFNE 'ALL'                                                 S01117
     C**********           CALL 'AOBRCHR0'                                S01117              CGL029
     C**********           CALL 'AOBRCHR1'                                            CGL029 BUG7415
     C**********           PARM '*MSG   ' @RTCD   7                                   S01117 BUG7415
     C**********           PARM '*KEY   ' @OPTN   7                                   S01117 BUG7415
     C**********           PARM BRNCH     @DSNB   3                                   S01117 BUG7415
     C********** SDBRCH    PARM SDBRCH    DSFDY                           S01117              CGL029
     C********** SDBRCH    PARM SDBRCH    DSSDY                                       CGL029 BUG7415
     C********** @RTCD     IFNE *BLANKS                                               S01117 BUG7415
     C**********           MOVE *BLANKS   DBKEY                                       S01117 BUG7415
     C**********           MOVEL@DSNB     DBKEY                                       S01117 BUG7415
     C**********           MOVEL'SDBRCHPD'DBFILE           ************               S01117 BUG7415
     C**********           Z-ADD18        DBASE            * DBASE 18 *               S01117 BUG7415
     C**********           MOVEL@OPTN     DBOPTN  7        ************               S01117 BUG7415
     C**********           SETON                     U7U8LR                           S01117 BUG7415
     C**********           GOTO #ZZ9                                                  S01117 BUG7415
     C**********           END                                                        S01117 BUG7415
     C**********           END                                                        S01117 BUG7415
      *                                                                   S01117
      ** OUTPUT 'NO DETAILS TO REPORT' IN P1                              S01117
      *                                                                   S01117
     C**********           SETOF                     20                               S01117 BUG7415
     C**********           SETON                     21                               S01117 BUG7415
      *                                                                   S01117
     C********** #ZZ9      ENDSR                                                      S01117 BUG7415
      *                                                                   S01117
     C********************************************************************S01117
1043 C/SPACE 3                                                            S01117
     C********************************************************************S01117
     C*                                                                   S01117
     C*  *PSSR --- SUBROUTINE TO HANDLE ABNORMAL ERROR CONDITIONS         S01117
     C*                                                                   S01117
     C*  CALLED FROM: AFTER ABNORMAL OPERATION OCCURS                     S01117
     C*                                                                   S01117
     C*  CALLS: NOTHING                                                   S01117
     C*                                                                   S01117
     C********************************************************************S01117
     C*                                                                   S01117
     C     *PSSR         BEGSR                                                  ** *PSSR **    S0111
     C*                                                                   S01117
     C     @RUN          IFEQ      *BLANKS                                                     S0111
     C                   MOVE      'Y'           @RUN              1                           S0111
     C                   DUMP                                                                  S0111
     C                   END                                                                   S0111
     C                   ENDSR                                                  ** *PSSR **    S0111
     C*                                                                   S01117
     C********************************************************************S01117
     C***/COPY*ZSRSRC,ZDATE1Z2                                                         S01392 CLE137
     C***/COPY*ZSRSRC,ZDATE2Z4                                                         S01392 CLE137
     C/COPY ZSRSRC,ZDATE1Z2LE                                                                 CLE137
     C/COPY ZSRSRC,ZDATE2Z2LE                                                                 CLE137
1270 O********************************************************************
1271 O*
1272 O*E0900P1D**203   OF                                       S01124    S01117
     O***/COPY*WNCPYSRC,LE0900O001                                                           BUG7415
1272 O***LE0900P1D  203   OF 21                                                       S01117 BUG7415
     O***/COPY*WNCPYSRC,LE0900O002                                                           BUG7415
1273 O***********                        11 'REF  LE0900'                 S01117
1273 O**********                         13 'REF  LE0900P1'                           S01117 BUG7415
1274 O***********              TITL      66                               E39485
1274 O***********              TITL      68                        E39485 159255
1274 O**********               TITL      67                                           159255 BUG7415
1275 O**********                         71 'DATE'                                           BUG7415
1276 O**********               RUNA      79                                                  BUG7415
1277 O**********                         84 'PAGE'                                           BUG7415
1278 O**********               PAGE      89                                                  BUG7415
1279 O*
1280 O********D**1     OF                                                 S01117
1280 O********D* 1     OF 21                                                          S01117 BUG7415
1281 O***********                         6 'BRANCH'                      S01117
1282 O***********              BRCDH     10                               S01117
1283 O**********                         46 'HISTORY CARD'                                   BUG7415
1281 O**********       35                55 'BRANCH'                                  S01117 BUG7415
1282 O**********       35      BRCAH     59                                           S01117 BUG7415
     O**********       35                60 '-'                                       S01117 BUG7415
     O**********       35      BRNM      90                                           S01117 BUG7415
1284 O*
1285 O********D**2     OF                                                 S01117
1285 O********D* 2     OF 21                                                          S01117 BUG7415
1286 O**********                         46 '------------'                                   BUG7415
1287 O*
1288 O********D**2     OF                                                 S01117
1288 O********D* 2     OF 21                                                          S01117 BUG7415
1289 O**********                          7 'LOAN NO'                                        BUG7415
1290 O**********               LNRFH     15                                                  BUG7415
1291 O**********                         26 'PAGE NO'                                        BUG7415
1292 O**********               PAGE2     33                                                  BUG7415
1293 O********D**1     OF                                                 S01117
1293 O********D* 1     OF 21                                                          S01117 BUG7415
1294 O**********                          8 'CUSTOMER'                                       BUG7415
1295 O**********               CRNM      30                                                  BUG7415
     O**********       84                56 'ORIG BORROWER'                           159255 BUG7415
     O**********       84      CRNM2     78                                           159255 BUG7415
1296 O*
1297 O********D**1     OF                                                 S01117
1297 O********D* 1     OF 21                                                          S01117 BUG7415
1298 O**********               CTWN      20                                                  BUG7415
1299 O***********              CNUMH     30                               CLE005
1299 O**********      N30      CNUMH     30                                           CLE005 BUG7415
1299 O**********       30      CLIKEY    30                        CLE005 193947
1299 O**********       30      CLIKEY    35                                           193947 BUG7415
     O**********       84      CTWN2     53                                           159255 BUG7415
     O**********       84      OLNO      78                                           159255 BUG7415
1300 O*
1301 O********D*11     OF                                                 S01117
1301 O********D*11     OF 21                                                          S01117 BUG7415
1302 O**********                         87 'NO. OF'                                         BUG7415
1303 O********D**1     OF                                                 S01117
1303 O********D* 1     OF 21                                                          S01117 BUG7415
1304 O**********                          8 'DUE DATE'                                       BUG7415
1305 O**********                         24 'EFFECTIVE DATE'                                 BUG7415
1306 O**********                         42 'NARRATIVE'                                      BUG7415
1307 O**********                         71 'AMOUNT'                                         BUG7415
1308 O**********                         86 'DAYS'                                           BUG7415
1309 O********D**2     OF                                                 S01117
1309 O********D* 2     OF 21                                                          S01117 BUG7415
1310 O**********                         88 'PAST DUE'                                       BUG7415
1311 O*
1312 O********E**203   46                                                 S01117
     O***/COPY*WNCPYSRC,LE0900O003                                                           BUG7415
1312 O********E* 203   46 21                                                          S01117 BUG7415
     O***/COPY*WNCPYSRC,LE0900O004                                                           BUG7415
1313 O***********                        11 'REF  LE0900'                 S01117
1313 O**********                         13 'REF  LE0900P1'                           S01117 BUG7415
1314 O**********               TITL      66                                                  BUG7415
1315 O**********                         71 'DATE'                                           BUG7415
1316 O**********               RUNA      79                                                  BUG7415
1317 O**********                         84 'PAGE'                                           BUG7415
1318 O**********               PAGE      89                                                  BUG7415
1319 O*
1320 O********E**1     46                                                 S01117
1320 O********E* 1     46 21                                                          S01117 BUG7415
1321 O***********                         6 'BRANCH'                      S01117
1322 O***********              BRCDH     10                               S01117
1323 O**********                         46 'HISTORY CARD'                                   BUG7415
1281 O**********       35                55 'BRANCH'                                  S01117 BUG7415
1282 O**********       35      BRCAH     59                                           S01117 BUG7415
     O**********       35                60 '-'                                       S01117 BUG7415
     O**********       35      BRNM      90                                           S01117 BUG7415
1324 O*
1325 O********E**2     46                                                 S01117
1325 O********E* 2     46 21                                                          S01117 BUG7415
1326 O**********                         46 '------------'                                   BUG7415
1327 O*
1328 O********E**2     46                                                 S01117
1328 O********E* 2     46 21                                                          S01117 BUG7415
1329 O**********                          7 'LOAN NO'                                        BUG7415
1330 O**********               LNRFH     15                                                  BUG7415
1331 O**********                         26 'PAGE NO'                                        BUG7415
1332 O**********               PAGE2     33                                                  BUG7415
1333 O********E**1     46                                                 S01117
1333 O********E* 1     46 21                                                          S01117 BUG7415
1334 O**********                          8 'CUSTOMER'                                       BUG7415
1335 O***********              CRNM      30                               159255
1335 O**********               CRNM      34                                           159255 BUG7415
1336 O**********                         59 'CMMT/FACILITY NO'                               BUG7415
1337 O**********               FTYPH     85                                                  BUG7415
1338 O**********                         86 '/'                                              BUG7415
1339 O**********               FSEQH     88                                                  BUG7415
1340 O*
1341 O********E**1     46                                                 S01117
1341 O********E* 1     46 21                                                          S01117 BUG7415
1342 O***********              CTWN      20                               159255
1342 O**********               CTWN      24                                           159255 BUG7415
1343 O***********              CNUMH     30                               CLE005
1299 O***********     N30      CNUMH     30                        CLE005 159255
1299 O***********      30      CLIKEY    30                        CLE005 159255
1299 O**********      N30      CNUMH     31                                           159255 BUG7415
1299 O**********       30      CLIKEY    31                        159255 193947
1299 O**********       30      CLIKEY    35                                           193947 BUG7415
1344 O**********                         51 'INT RATE'                                       BUG7415
1345 O**********               INTRC     88 '  0 .       '
1346 O*
     O********E* 1     46 21 84                                                       159255 BUG7415
     O**********                         13 'ORIG BORROWER'                           159255 BUG7415
     O**********               CRNM2     34                                           159255 BUG7415
      *                                                                   159255
     O********E* 1     46 21 84                                                       159255 BUG7415
     O**********               CTWN2     24                                           159255 BUG7415
     O**********               OLNO      31                                           159255 BUG7415
1347 O********E**1     46                                                 S01117
1347 O********E* 1     46 21                                                          S01117 BUG7415
1348 O**********                         18 'LOAN TYPE/SUB TYPE'                             BUG7415
1349 O**********               LTYPH     27                                                  BUG7415
1350 O**********                         28 '-'                                              BUG7415
1351 O**********               SUTPH     30                                                  BUG7415
1352 O**********                         57 'BASE RATE CODE'                                 BUG7415
1353 O**********               BRTTM     88                                                  BUG7415
1354 O********E**1     46                                                 S01117
1354 O********E* 1     46 21                                                          S01117 BUG7415
1355 O**********                         49 'SPREAD'                                         BUG7415
1356 O**********               RTSPM     87 '  0 .       '                                   BUG7415
1357 O**********       52                88 '+'                                              BUG7415
1358 O**********       53                88 '-'                                              BUG7415
1359 O**********          54             88 '%'                                              BUG7415
1360 O*
1361 O********E**1     46                                                 S01117
1361 O********E* 1     46 21                                                          S01117 BUG7415
1362 O**********                         11 'ORIG AMOUNT'                                    BUG7415
1363 O**********          24   PRAMH     40 ' ,   ,   ,   , 0 '                              BUG7415
1364 O**********          25   PRAMH     40 '   ,   ,   , 0 . '                              BUG7415
1365 O**********          26   PRAMH     40 '  ,   ,   , 0 .  '                              BUG7415
1366 O**********          27   PRAMH     40 ' ,   ,   , 0 .   '                              BUG7415
1367 O********E**1     46                                                 S01117
1367 O********E* 1     46 21                                                          S01117 BUG7415
1368 O**********                          3 'CCY'                                            BUG7415
1369 O***********              CCY       40                               070340
     O**********               CCYH      40                                           070340 BUG7415
1370 O**********                         65 'TOTAL ACCRUED INTEREST'                         BUG7415
1371 O**********          24   TINT      88 ' ,   ,   ,   , 0 '                              BUG7415
1372 O**********          25   TINT      88 '   ,   ,   , 0 . '                              BUG7415
1373 O**********          26   TINT      88 '  ,   ,   , 0 .  '                              BUG7415
1374 O**********          27   TINT      88 ' ,   ,   , 0 .   '                              BUG7415
1375 O********E**1     46                                                 S01117
1375 O********E* 1     46 21                                                          S01117 BUG7415
1376 O**********                         56 'INTEREST PAID'                                  BUG7415
1377 O**********          24   IPRD      88 ' ,   ,   ,   , 0 '                              BUG7415
1378 O**********          25   IPRD      88 '   ,   ,   , 0 . '                              BUG7415
1379 O**********          26   IPRD      88 '  ,   ,   , 0 .  '                              BUG7415
1380 O**********          27   IPRD      88 ' ,   ,   , 0 .   '                              BUG7415
1381 O********E**1     46                                                 S01117
1381 O********E* 1     46 21                                                          S01117 BUG7415
1382 O**********                         10 'START DATE'                                     BUG7415
1383 O**********               VDATE     40                                                  BUG7415
1384 O**********                         63 'INTEREST CAPITALISED'                           BUG7415
1385 O**********          24   ICTD      88 ' ,   ,   ,   , 0 '                              BUG7415
1386 O**********          25   ICTD      88 '   ,   ,   , 0 . '                              BUG7415
1387 O**********          26   ICTD      88 '  ,   ,   , 0 .  '                              BUG7415
1388 O**********          27   ICTD      88 ' ,   ,   , 0 .   '                              BUG7415
1389 O********E**1     46                                                 S01117
1389 O********E* 1     46 21                                                          S01117 BUG7415
1390 O**********                         13 'MATURITY DATE'                                  BUG7415
1391 O**********               MATDE     40                                                  BUG7415
1392 O**********                         63 'INTEREST WRITTEN OFF'                           BUG7415
1393 O**********          24   IWOD      88 ' ,   ,   ,   , 0 '                              BUG7415
1394 O**********          25   IWOD      88 '   ,   ,   , 0 . '                              BUG7415
1395 O**********          26   IWOD      88 '  ,   ,   , 0 .  '                              BUG7415
1396 O**********          27   IWOD      88 ' ,   ,   , 0 .   '                              BUG7415
1397 O*
1389 O********E* 1     46 21                                                          S01117 BUG7415
1390 O**********       35                15 'FACILITY BRANCH'                         S01117 BUG7415
1000 O**********       35      FCLB      40                                           S01117 BUG7415
     O*                                                                   S01117
1398 O********E*11     46                                                 S01117
1398 O********E*11     46 21                                                          S01117 BUG7415
1399 O**********                         87 'NO. OF'                                         BUG7415
1400 O********E**1     46                                                 S01117
1400 O********E* 1     46 21                                                          S01117 BUG7415
1401 O**********                          8 'DUE DATE'                                       BUG7415
1402 O**********                         24 'EFFECTIVE DATE'                                 BUG7415
1403 O**********                         42 'NARRATIVE'                                      BUG7415
1404 O**********                         71 'AMOUNT'                                         BUG7415
1405 O**********                         86 'DAYS'                                           BUG7415
1406 O********E**2     46                                                 S01117
1406 O********E* 2     46 21                                                          S01117 BUG7415
1407 O**********                         88 'PAST DUE'                                       BUG7415
1408 O*
1409 O********E**1     14 57                                              S01117
1409 O********E* 1     14 57 21                                                       S01117 BUG7415
1410 O*******OR**      07 57                                              S01117
1410 O*******OR*       07 57 21                                                       S01117 BUG7415
1411 O*******OR**      05 57                                              S01117
1411 O*******OR*       05 57 21                                                       S01117 BUG7415
1412 O**********          64   EXVDE      7                                                  BUG7415
1413 O**********               VDATD     19                                                  BUG7415
1414 O**********               NARRA     59                                                  BUG7415
1415 O**********          24N55PAMT      79 ' ,   ,   ,   , 0 -'                             BUG7415
1416 O**********          25N55PAMT      79 '   ,   ,   , 0 . -'                             BUG7415
1417 O**********          26N55PAMT      79 '  ,   ,   , 0 .  -'                             BUG7415
1418 O**********          27N55PAMT      79 ' ,   ,   , 0 .   -'                             BUG7415
1419 O**********      N75N76 55PRATE     79 '  0 .       '                                   BUG7415
1420 O**********          64 63DPDU  Z   85                                                  BUG7415
     O***/COPY*WNCPYSRC,LE0900O005                                                           BUG7415
1272 O********T* 203  N20 21 L1                                                       S01117 BUG7415
     O***/COPY*WNCPYSRC,LE0900O006                                                           BUG7415
1273 O**********                         13 'REF  LE0900P1'                           S01117 BUG7415
1274 O**********               TITL      66                                           S01117 BUG7415
1275 O**********                         71 'DATE'                                    S01117 BUG7415
1276 O**********               RUNA      79                                           S01117 BUG7415
1277 O**********                         84 'PAGE'                                    S01117 BUG7415
1278 O**********               PAGE      89                                           S01117 BUG7415
1279 O*                                                                   S01117
1280 O********T* 1    N20 21 L1                                                       S01117 BUG7415
1283 O**********                         46 'HISTORY CARD'                            S01117 BUG7415
1281 O**********       35                55 'BRANCH'                                  S01117 BUG7415
1282 O**********       35      BRCAH     59                                           S01117 BUG7415
     O**********       35                60 '-'                                       S01117 BUG7415
     O**********       35      BRNM      90                                           S01117 BUG7415
1284 O*                                                                   S01117
1285 O********T* 2    N20 21 L1                                                       S01117 BUG7415
1286 O**********                         46 '------------'                            S01117 BUG7415
1562 O********T*32     LR U7 U8                                                       S01117 BUG7415
     O*******AND       21                                                             S01117 BUG7415
1563 O**********                         37 '*** REFERENCE'                           S01117 BUG7415
     O**********               DBPGM     51                                           S01117 BUG7415
     O**********                         75 'DATABASE ERROR ***'                      S01117 BUG7415
1320 O********T* 2    N20 21 L1                                                       S01117 BUG7415
1320 O*******OR*      N20 21 LR                                                       S01117 BUG7415
     O**********      NU7                46 '*** NO DETAILS'                          S01117 BUG7415
     O**********      NU7                60 'TO REPORT ***'                           S01117 BUG7415
     O********T*3      L1 21 20                                                       S01117 BUG7415
     O*******OR*       L1 21N20                                                       S01117 BUG7415
     O*******OR*       LR 21N20                                                       S01117 BUG7415
     O**********       35                46 '*** END OF REPORT FOR'                   S01117 BUG7415
     O**********       35                54 'BRANCH '                                 S01117 BUG7415
     O**********       35      BRCAH     57                                           S01117 BUG7415
     O**********       35                61 ' ***'                                    S01117 BUG7415
1223 O**********      N35                57 '*** END OF REPORT ***'                   S01117 BUG7415
1421 O*
1422 O* UPDATED LOANS HISTORY FILE.
1423 O*    HEADER
1424 O*
1425 O***HIUPDHH   D    02                                                                    CLE137
1426 O**********               LOTH1    100                                                   CLE137
1427 O*
1428 O*    LOAN HEADER
1429 O*
1430 O***HIUPDHM   D    04                                                                    CLE137
1431 O***********              LOTHH    100                               CAC001
     O****                     LOTHH    118                        CAC001 115248
     O****                     LOTHH    152                        115248 157669
     O*************************LOTHH    179                                            157669 CLE042
     O***********              LOTHH    218                                            CLE042 CRE073
     O**********             LOTHH              247                                    CRE073 CLE137
1432 O*
1433 O*    LOAN AMOUNT
1434 O*
1435 O***HIUPDHP   D    06                                                                    CLE137
1436 O***********              LOTHL    100                               CAC001
     O****                     LOTHL    107                        CAC001 115248
     O****                     LOTHL    141                        115248 CLE004
     O****                     LOTHL    150                        CLE004 157669
     O*************************LOTHL    177                                            157669 CLE042
     O**********             LOTHL              231                                    CLE042 CLE137
1437 O*
1438 O*    BV/INT HEAD + RATE RECS
1439 O*
1440 O***HIUPDHQ   D    13                                                                    CLE137
1442 O***********              LOTHR    100                               CAC001
     O****                     LOTHRT   113                        CAC001 115248
     O****                     LOTHRT   147                        115248 CLE004
     O****                     LOTHRT   151                        CLE004 157669
     O**********               LOTHRT   178                                            157669 262540
     O**********               LOTHRT   206                                            262540 CRE073
     O**********             LOTHRT             235                                    CRE073 CLE137
1441 O***HIUPDHN   D    16                                                                    CLE137
1442 O***********              LOTHR    100                               CAC001
     O**********               LOTHR    118                                            CAC001 262540
     O**********               LOTHR    132                                            262540 CRE073
     O**********             LOTHR              161                                    CRE073 CLE137
1443 O*
1444 O*    TRAILER
1445 O*
1446 O***HIUPDZX   T    LR                                                                    CLE137
1447 O**********                                  1 'T'                                       CLE137
1448 O**********             HIS                  4P                                          CLE137
1449 O*
1450 O*
1451 O*
1452 O*
1422 O* MATURED LOANS HISTORY FILE.                                       S10227
1428 O*    LOAN HEADER                                                    S10227
1429 O*                                                                   S10227
1430 O***MHISTHM   D    05                                                             S10227 CLE137
1431 O***********              LOTHH    100                        S10227 CAC001
     O****                     LOTHH    118                        CAC001 115248
     O****                     LOTHH    152                        115248 157669
     O*************************LOTHH    179                                            157669 CLE042
     O***********              LOTHH    218                                            CLE042 CRE073
     O**********             LOTHH              247                                    CRE073 CLE137
     O/COPY WNCPYSRC,LEH01215
1432 O*                                                                   S10227
1433 O*    LOAN AMOUNT                                                    S10227
1434 O*                                                                   S10227
1435 O***MHISTHP   D    07                                                             S10227 CLE137
1436 O***********              LOTHL    100                        S10227 CAC001
     O****                     LOTHL    107                        CAC001 115248
     O****                     LOTHL    141                        115248 CLE004
     O****                     LOTHL    150                        CLE004 157669
     O*************************LOTHL    177                                            157669 CLE042
     O**********             LOTHL              231                                           CLE137
     O/COPY WNCPYSRC,LEH01216
1437 O*                                                                   S10227
1438 O*    BV/INT HEAD + RATE RECS                                        S10227
1439 O*                                                                   S10227
1440 O***MHISTHQ   D    14                                                             S10227 CLE137
1442 O***********              LOTHR    100                        S10227 CAC001
     O****                     LOTHRT   113                        CAC001 115248
     O****                     LOTHRT   147                        115248 CLE004
     O****                     LOTHRT   151                        CLE004 157669
     O**********               LOTHRT   178                                            157669 262540
     O**********               LOTHRT   206                                            262540 CRE073
     O**********             LOTHRT             235                                    CRE073 CLE137
     O/COPY WNCPYSRC,LEH01217
1441 O***MHISTHN   D    17                                                             S10227 CLE137
1442 O***********              LOTHR    100                        S10227 CAC001
     O**********               LOTHR    118                                            CAC001 262540
     O**********               LOTHR    132                                            262540 CRE073
     O**********             LOTHR              161                                    CRE073 CLE137
     O/COPY WNCPYSRC,LEH01263
1453 O** ONE MONTHS HISTORY FILE
1454 O*    HEADER
1455 O*
1456 O***MNHSTHH   D    02                                                                    CLE137
1457 O**********                                  1 'H'                                       CLE137
1458 O*
1474 O*    DETAIL REC
1475 O*
1459 O*    START RECORD
1460 O*
1461 O***MNHSTMN   D    04 42                                                                 CLE137
1461 OMNHSTMN   E    04 42   MNHST2                                                           CLE137
1462 O         OR    05 42
1463 O         OR    07 43
1464 O         OR    06 43
1465 O                                            1 'D'
1466 O                       WLHED               38
1467 O                     42                    17 'ST'
1468 O                     42WPRAMH              24P
1469 O                     42WVDATH              27P
1470 O                     43                    17 'BA'
1471 O                     43WBEG                24P
1472 O                     43BEGDAT              27P
     O**********               CNUMH     44                         S01117BHF821
     O**********             CNUMH               64                                  BHF821 MD023534
     O                       WCNUMH              64                                         MD023534
1473 O*
1476 O**********D    06N41N82                                                                 CLE137
     O          E    06N41N82MNHST2                                                           CLE137
1477 O         OR    07N41N82
1478 O                                            1 'D'
1479 O                       WLHED               38
1480 O                       AMTP                17
1481 O                       PRAM                24P
1482 O                       VDAT                27P
     O**********             CNUMH               64                                  BHF821 MD023534
     O                       WCNUMH              64                                         MD023534
1483 O*
1484 O*   MNHST START REC (ONLY REC)
1485 O*
1486 O**********E    45                                                                       CLE137
     O          E    45      MNHST1                                                           CLE137
1487 O                                            1 'D'
1488 O                       WLHED               38
1489 O                                           17 'BA'
1490 O                       WBEG                24P
1491 O                       BEGDAT              27P
     O***********              CNUMH     44                        S01117 071533
     O**********             CNUMH               64                                  071533 MD023534
     O                       WCNUMH              64                                         MD023534
1492 O*
1493 O*    TRAILER
1494 O*
1495 O***MNHSTT2 T        LR                                                                  CLE137
1496 O**********                          1 'T'                                               CLE137
1497 O**********               MNH        4P                                                  CLE137
1498 O**********               ZZTOTI    12P                                                  CLE137
1499 O**********               ZZTOTD    14P                                                  CLE137
1500 O*
1501 O*
1502 O*
1503 O* CONTROL REPORT
1504 O*E0900P2T** 03   LR                                       S01124    S01117
1504 O***LE0900AU  T    LR                       03                                  S01117 MD023031
1505 O***********                        22 'REFERENCE LE0900'            S01117
1505 O**********                                 24 'REFERENCE LE0900AU'             S01117 MD023031
1506 O**********             TITL                89                                         MD023031
1507 O**********                                122 'DATE              PAGE'                MD023031
1508 O**********             RUNA               112                                         MD023031
1509 O***********              PAGE  Z  127                               S01117
1509 O**********             PAGE1         Z    127                                  S01117 MD023031
1510 O**********T    LR                  2                                                  MD023031
1511 O**********                                 52 'PROCESS MATURED LOANS HI'              MD023031
1512 O**********                                 73 'STORY - FILE CONTROLS'                 MD023031
1513 O**********T    LR                  1  3                                               MD023031
1514 O**********                                 52 '------------------------'              MD023031
1515 O**********                                 73 '---------------------'                 MD023031
1516 O**********T    LR                  1                                                  MD023031
1517 O**********                                 28 'S/HISTS - RUN CONTROLS'                MD023031
1518 O**********                                 59 'NUMBER'                                MD023031
1519 O**********                                 84 'VALUE'                                 MD023031
1520 O**********T    LR                  1                                                  MD023031
1521 O**********                                 28 '----------------------'                MD023031
1522 O**********                                 59 'OF RECORDS'                            MD023031
1523 O**********                                 84 'OF RECORDS'                            MD023031
1524 O**********T    LR                  2                                                  MD023031
1525 O**********                                 29 'TOTAL RECORDS ON FILE'                 MD023031
1526 O**********          NU7NOREH         3     59                                           CLE137
1527 O**********T    LR                  2                                                  MD023031
1528 O**********                                 32 'TOTAL RECORDS ON FILE -C'              MD023031
1529 O**********                                 41 'ALCULATED'                             MD023031
1530 O**********             HIT           3     59                                         MD023031
1531 O**********           33                   111 '***   DIFFERENCE   ***'                MD023031
1532 O* MATLS FILE                                                                          MD023031
1533 O**********T    LR                  3                                                  MD023031
1534 O**********                                 28 'S/MATLS - RUN CONTROLS'                MD023031
1535 O**********T    LR                  1                                                  MD023031
1536 O**********                                 28 '----------------------'                MD023031
1537 O**********T    LR                  2                                                  MD023031
1538 O**********                                 29 'TOTAL RECORDS ON FILE'                 MD023031
1539 O**********          NU7NORES         3     59                                         MD023031
1540 O**********T    LR                  2                                                  MD023031
1541 O**********                                 32 'TOTAL RECORDS ON FILE -C'              MD023031
1542 O**********                                 41 'ALCULATED'                             MD023031
1543 O**********             MAT           3     59                                         MD023031
1544 O**********        34                      111 '***   DIFFERENCE   ***'                MD023031
1545 O* HIUPD FILE
1546 O**********T    LR                  3                                                  MD023031
1547 O**********                                 28 'S/HIUPD - RUN CONTROLS'                MD023031
1548 O**********T    LR                  1                                                  MD023031
1549 O**********                                 28 '----------------------'                MD023031
1550 O**********T    LR                  2                                                  MD023031
1551 O**********                                 29 'TOTAL RECORDS ON FILE'                 MD023031
1552 O**********             HIS           3     59                                         MD023031
1553 O**********T    LR                  3                                                  MD023031
1554 O**********                                 28 'S/MNHST - RUN CONTROLS'                MD023031
1555 O**********T    LR                  1                                                  MD023031
1556 O**********                                 28 '----------------------'                MD023031
1557 O**********T    LR                  2  3                                               MD023031
1558 O**********                                 29 'TOTAL RECORDS ON FILE'                 MD023031
1559 O**********             MNH           3     59                                         MD023031
1560 O**********             ZZTOTI        Z     81                                         MD023031
1561 O**********             ZZTOTD              84                                         MD023031
     O********T  2    N20 21 LR                                     S01117LN0788
     O*******OR        37                                           S01117LN0788
     O*********       NU7                66 '*** NO DETAILS'        S01117LN0788
     O*********       NU7                80 'TO REPORT ***'         S01117LN0788
1562 O**********T    LR U7 U8            3                                                  MD023031
1563 O**********                                 37 '*** REFERENCE'                  S01117 MD023031
1563 O***********                        42 '*** REFERENCE'               S01117
1564 O***********              DBPGM     51                               S01117
1565 O***********                        71 '-DATABASE ERROR AT'          S01117
1566 O***********              DBASE     74                               S01117
1564 O**********             DBPGM               53                                  S01117 MD023031
1565 O**********                                 72 'DATABASE ERROR AT'              S01117 MD023031
1566 O**********             DBASE               77                                  S01117 MD023031
1567 O**********T    LR U7 U8            2  3                                               MD023031
1568 O**********                                 37 'FILENAME'                              MD023031
1569 O***********              DBFILE    43                               S01117
1570 O***********                        48 'KEY'                         S01117
1571 O***********              DBKEY     78                               S01117
1569 O**********             DBFILE              48                                  S01117 MD023031
1570 O**********                                 52 'KEY'                            S01117 MD023031
1571 O**********             DBKEY               82                                  S01117 MD023031
1572 O********T*3         LR                                              S01117
1573 O***********                        68 '***   END OF REPORT'         S01117
1574 O***********                        74 '***'                         S01117
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
** ZFMD - NUMBER OF DAYS IN THIS MONTH
312831303130313130313031
     X/COPY WNCPYSRC,LE0900X001
** CPY@   **      OBJECT COPYRIGHT
(c) Finastra International Limited 2001
