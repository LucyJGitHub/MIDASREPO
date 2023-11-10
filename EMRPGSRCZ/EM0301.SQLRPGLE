     H
     F*****************************************************************
/**** *  RPGBASE                                                      *                     MD058079
/*STD *  RPGSQLBND                                                    *                     MD058079
/*EXI *  TEXT('Midas EM Limits/exposure/available by customer')       *
     F*****************************************************************
     F*                                                               *
     F*  Midas  EXPOSURE MANAGEMENT MODULE                            *
     F*                                                               *
     F*  EM0301 - DISPLAY CUSTOMER LIMITS/EXPOSURE/AVAILABILITIES     *
     F*                                                               *
     F*  Function: This enquiry shows up to date limits, exposure,    *
     F*  (I/C)     availability and offset details for any selected   *
     F*            customer or parent set up in the system.           *
     F*                                                               *
     F*            For each selected customer or parent, the limits,  *
     F*            exposures, availability and offset amounts are     *
     F*            shown split across the business areas of FX, MM,   *
     F*            SE, LE, FRA, IRS, FF and Retail.                   *
     F*                                                               *
     F*            Overall customer or parent totals are shown. The   *
     F*            exposure and offset totals will exclude any        *
     F*            business area that the user specifies on the       *
     F*            exposure scaling file.                             *
     F*                                                               *
     F*            For all business areas with limits i.e. FX, MM,    *
     F*            Loans, Securities (Issuer and Counterparty) and    *
     F*            Retail, two sets of limits (and corresponding      *
     F*            availability details) are shown. These are         *
     F*            MANAGEMENT limits and GRANTED limits.              *
     F*                                                               *
     F*            The MANAGEMENT limits are those entered through the*
     F*            Exposure Management module via limits maintenance. *
     F*                                                               *
     F*            The GRANTED limits are the relevant modular limits *
     F*            except in the following cases:                     *
     F*                                                               *
     F*            Loans   - The sum of all outstanding customer      *
     F*                      lending facility amounts.                *
     F*            Retail  - The sum of all overdraft limits granted. *
     F*            Futures - Always Blank.                            *
     F*            Options - Always Blank.                            *
     F*                                                               *
     F*            The information shown is correct as at the time of *
     F*            the last transaction or granted limit entered prior*
     F*            to the details being displayed, subject to the     *
     F*            'Update Wait Time' specified on the Installation   *
     F*            control data.                                      *
     F*                                                               *
     F*            If the dubious indicator has been set on,          *
     F*            referenced on EMCEXX1, there has been an error on  *
     F*            the exposure update. A message will be displayed   *
     F*            warning that the figures may not be accurate.      *
     F*                                                               *
     F*            All amounts are shown in the Exposure Management   *
     F*            limit currency specified by the user.              *
     F*                                                               *
     F*            Transactions entered into the system during the    *
     F*            current input cycle will use the spot rates        *
     F*            effective at time of input to convert to the       *
     F*            Exposure Management limit currency. Transactions   *
     F*            entered prior to the current input cycle will have *
     F*            used the overnight spot rates to convert to this   *
     F*            currency.                                          *
     F*                                                               *
     F*            All amounts are calculated rounded to the nearest  *
     F*            whole unit of currency, but are displayed rounded  *
     F*            to the nearest thousand whole units of currency.   *
     F*                                                               *
     F*  Called By: Main Menu                                         *
     F*                                                               *
     F*  Calls: EMC0120A -  Customer FX Deals Enquiry                 *
     F*         EMC0120B -  Customer MM Deals Enquiry                 *
     F*         EMC0120C -  Customer FRA Deals Enquiry                *
     F*         EMC0120D -  Customer IRS Deals Enquiry                *
     F*         EMC0120E -  Customer Options Deals Enquiry            *
     F*         EMC1500  -  Child by Parent with Business Line        *
     F*                     Exposure                                  *
     F*         EMC1600  -  Parent Detail Enquiry                     *
     F*         FFC0301  -  FF Customer/Broker Holdings Enquiry       *
     F*         GLC06    -  Customer Account Balances Enquiry         *
     F*         DL0130   -  Customer/Parent Exposure against limits   *
     F*         LE0201   -  Customer Portfolio Enquiry                *
     F*         SE0235   -  Customer Trades By Security Enquiry       *
     F*         SE0265   -  Positions By Issuer Enquiry               *
     F*         SE0215   -  Customer Portfolio Valuation Enquiry      *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. AR832484           Date 10Nov23               *
      *  Prev Amend No. MD058079           Date 11May21               *
      *                 MD046248           Date 27Oct17               *
      *                 MD030956           Date 09Oct14               *
      *                 AR967121           Date 19Aug14               *
      *                 MD029260           Date 06Aug14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 253255 (BUG16388)  Date 11Mar08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG11442           Date 05Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CAAA03             Date 26Apr04               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD007             Date 28Aug00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 148314             Date 12Oct99               *
      *                 147370             Date 12Oct99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 133355             Date 29Apr99               *
      *                 CTI002             Date 25Mar99               *
     F*                 094276             DATE 22JAN98               *
     F*                 083490             DATE 21JAN98               *
     F*                 109454             DATE 24SEP97               *
     F*                 S01408             DATE 15AUG96               *
     F*                 S01408             DATE 02MAY96               *
     F*                 090890             DATE 19FEB96               *
     F*                 091220             DATE 01AUG95               *
     F*                 085261             DATE 02APR95               *
     F*                 083857             DATE 06MAR95               *
     F*                 S01474             DATE 06SEP94               *
     F*                 075353             DATE 14OCT94               *
     F*                 073353             DATE 14OCT94               *
     F*                 072775             DATE 14OCT94               *
     F*                 067378             DATE 07MAR94               *
     F*                 056426 (FB0119)    DATE 03FEB94               *
     F*                 E28697             DATE 19SEP91               *
     F*                 E28696             DATE 17SEP91               *
     F*                 E21293             DATE 20JUN91               *
     F*                 E22940             DATE 30MAY91               *
     F*                 S01332             DATE 25APR91               *
     F*                 S01220             DATE 25JUN91               *
     F*                 RT0152             DATE 16JUN91               *
     F*                 S01314             DATE 27MAR91               *
     F*                 S01311             DATE 19MAR91               *
     F*                 E21212             DATE 06SEP90               *
     F*                 E22634             DATE 09AUG90               *
     F*                 E23127             DATE 09AUG90               *
     F*                 E21176             DATE 19MAR90               *
     F*                 E21191             DATE 27FEB90               *
     F*                 E17292             DATE 08JAN90               *
     F*                 LN0071             DATE 02JUN90               *
     F*                 LN0252             DATE 24MAY90               *
     F*                 LN0124             DATE 08MAY90               *
     F*                 S01196             DATE 18NOV89               *
     F*                 S01199             DATE 06/11/89              *
     F*                 S01117             DATE 24/10/89              *
     F*                 E18716             DATE 05JUL89               *
     F*                 E16059             DATE 19JUN89               *
     F*                 E14606             DATE 17/03/89              *
     F*                 E16158             DATE 17/03/89              *
     F*                 E16005             DATE 01/12/88              *
     F*                 E15671             DATE 01/12/88              *
     F*                 S01179             DATE 04/11/88              *
     F*                 E15481             DATE 13/10/88              *
     F*                 S01129             DATE 17/11/87              *
     F*                 E12080             DATE 04/05/88              *
     F*                 E12570             DATE 08/03/88              *
     F*                 S01128             DATE 18/02/87              *
     F*                 E10855             DATE 08/12/86              *
     F*                 E10633             DATE 08/12/86              *
     F*                 E81176             DATE 05/12/86              *
     F*                 E81252             DATE 05/12/86              *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  AR832484 - Enclosure shows the difference between On-screen  *
      *             checking and EM0600P1.  Recompiled over fixed     *
      *             logical file TABEM.  (Child: AR832485)            *
      *  MD058079 - Deliverable Data Split for sundry files           *
      *  MD046248 - Finastra Rebranding                               *
      *  MD030956 - Additional changes to BFM-TI enhancement          *
      *  AR967121 - Recompiled due to changes in EMCEJ, EMCEJ2 and    *
      *             EMCEJ3. (Child: AR967122)                         *
      *  MD029260 - Incorrect overall exposure shown when TF exposure *
      *             is non-zero.                                      *
      *  253255 - Show exposure by customer/parents details even if   *
      *           there is a warning message. (BUG16388)              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11442 - Incorrect validation of customer number/shortname *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAAA03 - Webfacing Changes (Recompile)                       *
      *  CSD007 - Customer Closing                                    *
     F*  148314 - Recompiled due to changes in EMCEJ, EMCEJ2 and      *
     F*           EMCEJ3.                                             *
     F*  147370 - 'Lending' line shown instead of 'MM' line.  Fix is  *
     F*           to call program DL0130A instead of DL0130 if S01433 *
     F*           is present in the system. Applied fix 118437.       *
     F*  133355 - MM limits not showing - reverse part of 109454      *
     F*  CTI002 - TRADE INNOVATION PHASE II                           *
     F*  094276 - When the base currency for limits is different to   *
     F*           limit currency, the granted limits are shown as     *
     F*           limit ccy amount in a base currency screen, for     *
     F*           FRA/IRS's.  Fix is to convert the limit amount from *
     F*           limit to base currency for FRA/IRS as per FX/MM.    *
     F*         - If currency other than dealing currency was input,  *
     F*           and was then blanked out, currency was being left   *
     F*           as the last currency used - fix is to amend pgm to  *
     F*           output Limit currency name correctly in this case.  *
     F*  083490 - Limits/Exposure values are not displayed if limits  *
     F*           are entered at Branch or Company level and not at   *
     F*           system level. Fix is to create join logicals based  *
     F*           on EMCEJ - EMCEJ2 to obtain exposure when limits are*
     F*           input at Company level, and EMCEJ3 where limits are *
     F*           entered at Branch level.                            *
     F*         - Call to Access Object AOCLLMR0 has incorrect        *
     F*           parameters - amend program to pass correct parms.   *
     F*  109454 - Customer/Parent Exposure Enquiry shows FX and       *
     F*           MM limits incorrectly. Applied fix 108950.          *
     F*  S01408 - Addition of core hook EM0301CCP5                    *
     F*         - Addition of core hook EM0301CCP4                    *
     F*  S01408 - Addition of core hook EM0301CCP3                    *
     F*           Addition of core hook EM0301CCP2                    *
     F*           Addition of core hook EM0301CCP1                    *
     F*           Addition of core hook EM0301IIP1                    *
     F*  090890 - PROBLEM WITH MIDAS/LEO INTERFACE.                   *
     F*           IT USES *LDA FOR TRANFERRING LIBRARY NAMES BUT      *
     F*           THE POSITIONS IT USED IN *LDA ARE ALSO USED BY THE  *
     F*           CALLED PROGRAM GL4443 FOR OTHER INFORMATION!        *
     F*           DEFINITION OF *LDA IS MODIFIED SO THAT OVERLAPPING  *
     F*           OF USAGE (OF *LDA) IS AVOIDED.                      *
     F*  091220 - 083857 applied a call to a Leo program, but did     *
     F*           not condition it on the Leo interface being         *
     F*           switched on.                                        *
     F*  085261 - Fix: error in conversion between EM Limit currency  *
     F*           & base currency.                                    *
     F*                                                               *
     F*  083857 - Get EM credit line code by calling CAOUSC.          *
     F*           Use EM credit line code to get credit line details  *
     F*           instead of using 'EML'.                             *
     F*                                                               *
     F*  S01474 - Midas/Leo Interface - Add line of Leo Exposure      *
     F*                                                               *
     F*  075353 - DO NOT ALLOW CHANGE OF CUSTOMER IF AN OPTION HAS    *
     F*           BEEN REQUESTED.                                     *
     F*                                                               *
     F*  073353 - AMENDMENT TO THE FIRST DETAIL SCREEN PROCESSING.    *
     F*           IF AN OPTION IS ENTERED AGAINST SUBFILE RECORD AND  *
     F*           ALSO A NUMBER/SHORTNAME ENTERED IN THE NEXT         *
     F*           CUSTOMER FIELD AND/OR ANOTHER CURRENCY ENTERED IN   *
     F*           CURRENCY FIELD, THE NEXT SCREEN GIVES A BREAKDOWN   *
     F*           FOR THE OPTION SELECTED FOR THE ORIGINAL CUSTOMER.  *
     F*                                                               *
     F*           CMD F1 IS AVAILABLE TO RETURN TO INITIAL ENQUIRY,   *
     F*           BUT THIS RETURNS WITH THE NEXT CUSTOMER/            *
     F*           NEW CURRENCY DETAILS.                               *
     F*                                                               *
     F*           THIS CHANGE ENSURES THAT IN THIS INSTANCE THE       *
     F*           ORIGINAL CUSTOMER/CURRENCY DETAILS ARE REDISPLAYED. *
     F*                                                               *
     F*  072775 - CHANGE VALIDATION OF SCREEN FIELDS                  *
     F*  067378 - If ENTER key is pressed, program should refresh     *
     F*           even if selection details not changed.              *
     F*  056426 - DATABASE ERROR OCCURS BECAUSE KEY CKEY NOT BLANKED  *
     F*           BEFORE BEING SET UP TO CHAIN WITH PARENT CUST NUM   *
     F*  E28697 - EXPOSURE AND OFF-SETTING BALANCE FOR PARENTS BEING  *
     F*           SUMMED INCORRECTLY                                  *
     F*  E28696 - EXTRA PARAMETER PASSED TO EM1600 IF F4 TAKEN FOR A  *
     F*           CHILD                                               *
     F*           CHECK FOR JUST F3 NOT ALL COMMAND KEYS TAKEN FROM   *
     F*           INITIAL SCREEN                                      *
     F*  E21293 - ACCUMULATE CHILDREN'S FX AND MM GRANTED LIMITS IF   *
     F*           GRANTED LIMIT FOR PARENT NOT FOUND                  *
     F*  E22940 - Program incorrectly displaying deleted limits       *
     F*           This fix supercedes part of fix for E21212          *
     F*  S01332 - EM REL 10 ENHANCEMENTS                              *
     F*  S01220 - RECOMPILE FOR DUE TO RISK MANAGEMENT CHANGE TO      *
     F*           SESDS                                               *
     F*  RT0152 - CORRECT THE ORDER OF LIMIT DATA STRUCTURE           *
     F*         - ALSO REMOVE TWO LINES THAT PUT LIMITS INTO EXPOSURE *
     F*  S01314 - CHGS MADE DURING PTF INCORPORATION                  *
     F*  S01311 - Amended for Exposure Management Release 10 to call  *
     F*           Modular programs                                    *
     F*  E21212 - FIX TO ENSURE DELETED AND EXPIRED LIMITS FROM       *
     F*           DEALING ARE CORRECTLY DISPLAYED AS ZEROS WHEN       *
     F*           DOING AN 'EM' LIMIT ENQUIRY - RELEASED PREMATURELY| *
     F*  E22634 - ANY REFERENCE TO 'FUTURES AND OPTIONS' AND          *
     F*           'FRA / IRS' REMOVED COMPLETELY.                     *
     F*  E23127 - INCORRECT USAGE OF DTAARA SESDS DUE TO E16158       *
     F*  E21176 - LIST OF INDICATORS NOT AMENDED BY FIX E17208 -      *
     F*           INCORRECT INDICATOR SPECIFIED.                      *
     F*  E21191 - PROGRAM SHOULD ZEROISE VALUES FROM EXPOSURE DETAIL  *
     F*           RECORD IF IT HAS BEEN DELETED (* IN RECI)           *
     F*  E17292 - Change array AEM to differentiate between the three *
     F*           SE Outputs, and make the Linked Enquiries consistant*
     F*           with the Functional Specification.                  *
     F*  LN0071 - FIELD REMAME IN FILE REQUIRED CHANGE TO I SPEC      *
     F*  LN0252 - RECOMPILE TO MATCH SOURCE                           *
     F*  LN0124 - (C) ARRAY IN WRONG SEQ IN E SPECS AND AT END OF     *
     F*           SOURCE - S/BE THE LAST COMPILE TIME ARRAY           *
     F*  S01196 - DROP LETTERS OF CREDIT MODULE                       *
     F*  S01199 - HELP CHANGES                                        *
     F*  E18716 - WHEN THE BASE CURRENCY FOR LIMIT IS DIFFERENT FROM  *
     F*           THE LIMIT CURRENCY IN EM MODULE THE GRANTED LIMITS  *
     F*           ARE INCORRECT.                                      *
     F*  E16059 - IF THERE ARE 9 FILLED LINES ON FIRST PAGE, THEN     *
     F*           OPTIONS ON SECOND PAGE DO NOT WORK.                 *
     F*  E14606 - ACCESS OF CUSTOMER LIMITS FOR SE FROM SLIMH NOT     *
     F*           CORRECT AND CALCULATION FOR C/P LIMITS AMENDED.     *
     F*           (ERRORS FROM DEVELOPMENT)                           *
     F*  E16158 - SECURITIES TRADING ENQUIRY NOT WORKING.             *
     F*  E16005 - TRUNCATION IN THE LIMITS CALCULATION INTRODUCES     *
     F*           UNACCEPTABLE ROUNDING ERRORS.                       *
     F*  E15671 - CONVERSION FROM EM CURRENCY TO BASE CURRENCY , THEN *
     F*           TO REQUESTED CURRENCY IS INCORRECT.                 *
     F*           THE CONVERSION BETWEEN CURRENCY SHOULD BE ROUND UP  *
     F*           (I.E HALF ADJ.) INSTEAD OF ROUND DOWN (I.E          *
     F*           TRUNCATION).                                        *
     F*           WHEN THE BASE CURRENCY FOR LIMIT IS DIFFERENT FROM  *
     F*           THE LIMIT CURRENCY IN EM MODULE THE MANAGEMENT      *
     F*           AND GRANTED LIMITS ARE INCORRECT.                   *
     F*  S01179 - AS400 CONVERSION                                    *
     F*  E15481 - PROGRAM CHAINS TO TABTB36 , THE SE ICD RECORD ,     *
     F*           WHETHER SE IS INSTALLED OR NOT. ALSO,COMMENT IN     *
     F*           PROGRAM REFERS TO 'TABTB36' AS 'EM' ICD RECORD      *
     F*           INSTEAD OF 'SE' ICD RECORD.                         *
     F*  S01129 - SECURITIES TRADING II INCORPORATION                 *
     F*  E12080 - SYSTEM DOES NOT CHECK THE MULTIPLY/DIVIDE INDICATOR *
     F*           WHEN A DIFFERENT CURRENCY IS REQUESTED IN THE       *
     F*           CUSTOMER EXPOSURE ENQUIRY.                          *
     F*  E12570 - LENGTH OF DATA AREA MMOD HAS BEEN INCREASED         *
     F*           AND MUST BE CHANGED IN THE PROGRAM AS WELL.         *
     F*  E10855 - INVALID SHORT NAME ENTERED SHOULD ONLY DISPLAY      *
     F*           BOTTOM LAST 4 LINES OF DISPLAY FORMAT               *
     F*  E10633 - MESSAGE 'WARNING - THESE FIGURES MAY NOT BE UP TO   *
     F*           DATE'                                               *
     F*  E81176 - PARENT NO/SHORT NAME DISPLAYED INCORRECTLY          *
     F*  E81252 - EXPOSURE FIGURES DOUBLED IF RETURN FROM CUST ENQRY  *
     F*  S01128 - CHANGE 'TOTAL' TO 'OVERALL' ON DISPLAY SCREEN       *
     F*         - ADD SHORT NAME FIELD ON SCREEN                      *
     F*         - CHANGE DISPLAY FILE TO EXTERNALLY DESCRIBED         *
     F*         - USE NEW JOIN LOGICAL FILE EMCEJ INSTEAD OF EMCEX    *
     F*           AND SEPARATE HEADER AND TRAILER FILES FOR EMCEX     *
     F*  S01129 - SECURITIES TRADING RELEASE 2                        *
     F*                                                               *
     F*****************************************************************
     F*****  EM0301FMCF  F     536            WORKSTN                     S01128
     F**** EM0301FMCF  F     543            WORKSTN                       S01128
     FEM0301FM  CF   E             WORKSTN                                      S01128
     F                                     SFILE(EM0301S1:RRN)                  S01332
     F/COPY WNCPYSRC,EM0301F003
     F**** EMCEX   IF  E           K        DISK                          S01128
     FEMCEJ     IF   E           K DISK                                         S01128
     F****        EMCEXX3F                          KIGNORE               S01128
     FEMCEJ2    IF   E           K DISK                                         083490
     F                                     RENAME(EMCEJF1:EMCEJF2)              083490
     FEMCEJ3    IF   E           K DISK                                         083490
     F                                     RENAME(EMCEJF1:EMCEJF3)              083490
     FEMCEX     IF   E           K DISK                                         S01128
0018 FEMLIM     IF   E           K DISK
     F                                     IGNORE(EMLIML1F)
     F                                     IGNORE(EMLIML3F)
0017 F*EMCON**** IF   E           K DISK                                                    MD058079
     F**********                           RENAME(EMCONPFF:EMCONF)                          MD058079
     FSLIMH     IF   E           K DISK                                         S01129
0019 F****TABLE   IF  E           K        DISK                           S01129
     FTABEM     IF   E           K DISK                                         S01129
     F                                     IGNORE(TABTE10F)
     F                                     IGNORE(TABLETHF)
     F                                     IGNORE(TABLETIF)
     F                                     IGNORE(TABLETNF)
     F                                     IGNORE(TABLETTF)
0020 FCLINT     IF   E           K DISK
     F                                     IGNORE(CLINTCAF)
     F                                     IGNORE(CLINTCCF)
     F/COPY WNCPYSRC,EM0301F001
0021 FPACUS     IF   E           K DISK
     F                                     RENAME(CLINTCBF:PACUSCBF)
0022 F****SNAME***IF**E           K        DISK                           S01332
     F************CLINTCBF                          KRENAMESNAMECBF       S01332
0021 F****EMCUP   IF  E           K        DISK                           S01332
     FEMEXSCL1  IF   E           K DISK                                         S01332
0021 F*LIMIT****IF**F******96  6AI     2 DISK                       E21212S01314
0023 F*
     F/COPY WNCPYSRC,EM0301F002
0024 F* ID F  C  H  L    FUNCTION OF INDICATORS
0025 F**
0026 F* 01          WORKSTN - WORKSTATION INPUT RECORD.
0028 F* 07      command 3                                                 S01179
0028 F* 05      command 5
0027 F**04******command 4                                                 E21176
0027 F* 03      command 4                                                 E21176
0031 F* 06            EMLIM - DETAIL RECORD.
0033 F*
0035 F* 10                  - INSTALATION CONTROL RECORD 2.
0036 F* 12                  - CURRENCY RECORD.
0036 F* 13                  - 'SE' MODULE IS INSTALLED.                   E15481
     F* 14                  - NO RECORD FOUND                             S01474
0038 F*
0031 F* 17            upper level link enquiry option
0040 F****19****************-*HELP*REQUEST                                S01199
     F****20-29************- NON-DISPLAY FIELDS ON SCREEN           S01129S01332
0041 F****    29           - SHORTNAME ENTERED ON SCREEN.                 S01129
     F*       20           - CHAIN FAIL ON EMEXSCL1                       S01332
     F*       21-23        - SUBFILE INDICATORS                           S01332
0042 F*       30           - CUSTOMER NUMBER ENTERED ON SCREEN.
0043 F*       31           - DUBIOS INDICATOR ON.
0041 F*       32           - SHORTNAME ENTERED ON SCREEN.                 S01129
     F*       33           - COMMAND KEY TEXT INDICATOR                   S01332
     F*       35           - OPTION IN ERROR INDICATOR                    S01332
0044 F*       41           - BLANK ENTERED ON SCREEN
0045 F*       43           - NON-DISPLAY DETAILS ON SCREEN
0046 F*       44           - NON-DISPLAY DETAILS ON SCREEN
     F*       45           - NON-DISPLAY 'EXCLUDES' TEXT                  S01332
0048 F*       47           - EMLIM RECORD NOT FOUND
     F*       48           - SLIMH RECORD NOT FOUND                       S01129
0049 F*       49           - TABLE RECORD NOT FOUND
0050 F*       51           - CHILD OR LONER ENTERED.
0051 F*       52           - PARENT NUMBER ENTERED.
0052 F*       53           - LONER ( N53 = CHILD).
0053 F*       54           - LIMIT DUE TO EXPIRE IN FUTURE.
0054 F*       55           - LIMIT HAS EXPIRED.
0055 F*       56           - LIMIT EXPIRES TODAY.
0057 F*       57           - END OF EMCEJ, OR NEXT RECORD DIFFERENT
     F*****60-70***********-*NO LEGENDS ON DETAIL SCREEN*           S01129E22634
     F*****60-68***********-*NO LEGENDS ON DETAIL SCREEN            E22634S01332
     F*       60           - SUBFILE END INDICATOR                        S01332
     F*       61           - READ CHANGE INDICATOR ON SUBFILE             S01332
     F*       65           - MODIFIED DATA INDICATOR                      S01332
0058 F********70***********- CHAIN FAIL ON LIMITS FILE              E21212S01314
0058 F*       71           - CHILD NO. ON PACUS = 0 OR
0060 F*       72           - EOF ON PACUS.
     F********73***********- ROLLUP USED                            S01129S01332
     F********74***********- ROLLDOWN USED                          S01129S01332
     F*       75           - ON IF FIRST SCREEN IS ON DISPLAY             S01129
0061 F*       80           - NEGATIVE EXPOSURE.
0062 F*       81           - ALL EXPOSURES CHECKED FOR REC.
0062 F*       82           - CHAIN FAIL
0062 F*       85           - MAIN PROCESSING LOOP
0062 F*       86           - MAIN PROCESSING LOOP for detsr
0062 F********87***********-*DETAILS*PROCESSING*LOOP*******************   067378
0063 F*       89           - NON-DISPLAY ERROR BAND, LINE 22
0064 F**
0065 F*       90-97   USED BY Z - SUBROUTINES.
0066 F*       99      Z -SUBROUTINES, ERROR FOUND.
0067 F*                     (DATABASE ERROR)
0068 F**
0069 F*               EXTERNAL INDICATOR MEANINGS-
0070 F*       U7+U8   DATABASE ERROR.
0071 F**
0072 F*            LR RELEASE TO END PROGRAM
      *COPY*ZSRSRC,ZSEDITZ1                                                                 MD058079
      /COPY ZSRSRC,ZSEDITZ1LE                                                               MD058079
0073 F**
0074 D***                 LM          4 11 0             LIMITS           S01129
     D***                 LMG         4 11 0             LIMITS GRANTED   S01129
0075 D***                 XP          4 15 0             EXPOSURE         S01129
0076 D***                 XPA         4 15 0             EXP. ACCUMULATED S01129
0077 D***                 XPO         4 12 0             EXP. OUTPUT      S01129
0078 D***                 AV          4 12 0             AVAILABLE        S01129
     D***                 AVG         4 12 0             AVAILABLE GRTD   S01129
0079 D***                 OB          4 15 0             OFF-SET BALANCES S01129
0080 D***                 OBA         4 15 0             O-S BALS ACCUMULDS01129
0081 D***                 OBO         4 12 0             O-S BALS OUTPUT  S01129
     D* ACCUMULATION ARRAYS                                               S01129
     D***********         LIM        10 11 0             LIMITS     S01129E22634
     D***********         LMG        10 11 0          LIMITS GRANTEDS01129E22634
     D**********          LIM        08 11 0             LIMITS     E22634S01314
     D***********         LIM        09 11 0             LIMITS     S01314S01332
     D**********          LMG        08 11 0             LIMITS GRANE22634S01314
     D***********         LMG        09 11 0             LIMITS GRANS01314S01332
     D***********         XPA        10 15 0             EXP. ACCUMUS01129S01332
     D***********         XPO        10 12 0             EXP. OUTPUTS01129S01332
     D***********         AV         10 12 0             AVAILABLE  S01129S01332
     D***********         AVG        10 12 0             AVAILABLE GS01129S01332
     D***********         OBA        10 15 0             O-S BALS ACS01129S01332
     D***********         OBO        10 12 0             O-S BALS OUS01129S01332
     D***********         LIM        11 11 0             LIMITS     S01332CTI002
     D***********         LMG        11 11 0             LIMITS GRANS01332CTI002
     D***********         XPA        11 15 0             EXP. ACCUMUS01332CTI002
     D***********         XPO        11 12 0             EXP. OUTPUTS01332CTI002
     D***********         AV         11 12 0             AVAILABLE  S01332CTI002
     D***********         AVG        11 12 0             AVAILABLE GS01332CTI002
     D***********         OBA        11 15 0             O-S BALS ACS01332CTI002
     D***********         OBO        11 12 0             O-S BALS OUS01332CTI002
     D LMG             S             11  0 DIM(12)                              LIMITS GRANTED   CTI
     D XPA             S             15  0 DIM(12)                              EXP. ACCUMULATED CTI
     D XPO             S             12  0 DIM(12)                              EXP. OUTPUT      CTI
     D AV              S             12  0 DIM(12)                              AVAILABLE        CTI
     D AVG             S             12  0 DIM(12)                              AVAILABLE GRNTED CTI
     D OBA             S             15  0 DIM(12)                              O-S BALS ACCUMED CTI
     D OBO             S             12  0 DIM(12)                              O-S BALS OUTPUT  CTI
     D* STORE OF DETAILS TO BE OUTPUT                                     S01129
     D LES             S              7    DIM(16)                              LEGENDS          S01
     D LMS             S             11    DIM(16)                              LIMITS           S01
     D XPS             S             12    DIM(16)                              EXP. OUTPUT      S01
     D AVS             S             12    DIM(16)                              AVAILABLE        S01
     D OBS             S             15    DIM(16)                              O-S BALS OUTPUT  S01
     D LGS             S             11    DIM(16)                              LIMITS GRANTED   S01
     D AGS             S             12    DIM(16)                              AVAILABLE GRNTED S01
     D* ARRAYS FOR OUTPUT TO SCREEN                                       S01129
     D***********         LEG    10  10  7               LEGENDS    S01129E22634
     D**********          LEG    08  10  7               LEGENDS    E22634S01314
     D***********         LEG    09  10  7               LEGENDS    S01314S01332
     D***********         LGG        10  7               LEGENDS    S01129S01332
     D***********         LMO        10 15               LIMITS     S01129S01332
     D***********         XPAO       10 16               EXP. ACCUMUS01129S01332
     D***********         AVO        10 16               AVAILABLE  S01129S01332
     D***********         OBAO       10 16               0-S BALS OUS01129S01332
     D***********         LGO        10 15               LIMITS GRANS01129S01332
     D***********         AGO        10 16               AVAILABLE GS01129S01332
     D***********         LEG    11  11  7               LEGENDS    S01332CTI002
     D LEG             S              7    DIM(12) CTDATA PERRCD(1)             LEGENDS          CTI
     D*                                                                   S01129
     D************        CPY@    1   1 80               COPYRIGHT STMT   LN0124
0083 D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)              ZDATE1/2 SR.ARRAY
0084 D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)            ZDATE1/2 SR.ARRAY
0085 D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)            ZDATE2 SR. ARRAY
0086 D****                MSG     1  13 79               ERROR MSG. ARRAY S01129
     D******              MSG     1  14 79               ERROR MSG. S01129075353
     D MSG             S             79    DIM(15) CTDATA PERRCD(1)             ERROR MSG. ARRAY 075
     D***********         AEM    10  10  1               EM LINK ARRS01129S01332
     D***********         AEM    11  11  1               EM LINK ARRS01332CTI002
     D AEM             S              1    DIM(12) CTDATA PERRCD(12)            EM LINK ARRAY    CTI
     D* ARRAYS FOR EXCLUDE NARRATIVE                                      S01332
     D XCN             S              1    DIM(56)                                               S01
0086 D****                LAR         7  1               REQ. OPT.  ARRAY
     D**ARRAY*OVER*TABTB95*MODULE*SEQUENCES                         S01129S01332
     D************        MSQ        10  4 0                        S01129E22634
     D**********          MSQ        08  4 0                        E22634S01314
     D***********         MSQ        09  4 0                        S01314S01332
     D* ARRAY OVER SDEXPMPD MODULE SEQUENCES                              S01332
     D***********         MSQ        11  4 0                        S01332CTI002
     D* ARRAYS FOR INPUT OPTIONS ON SCREEN                                S01129
     D***********         OPI        10  1               OPTIONS INPS01129S01332
     D OPL             S              1    DIM(16)                              MODULE NUMBERS   S01
     D***********         OPS        16  1               STORED OPTSS01129S01332
     D @WRK            S              1    DIM(17)                              LIB/PGM NAME     S01
0244 D**   DATA STRUCTURE FOR LIMITS ARRAY
0245 D                 DS
0246 D***                                     1  44 LM                    S01129
     D***********                             1 110 LIM             S01129E22634
     D**********                              1  88 LIM             E22634S01314
     D***********                             1  99 LIM             S01314S01332
     D*                                       1 121 LIM             S01332CTI002
     D  LIM                    1    132  0                                      CTI002
     D                                     DIM(12)                              LIMITS           CTI
0247 D  MFXL                   1     11  0
0248 D  MMML                  12     22  0
0249 D**********                             34  440MLEL                  RT0152
0249 D**********                             23  330MLEL            RT0152S01332
0250 D**********                             45  550MREL                  RT0152
0250 D**********                             34  440MREL            RT0152S01332
     D  MFRL                  23     33  0                                      S01332
0249 D  MLEL                  34     44  0                                      S01332
0250 D  MREL                  45     55  0                                      S01332
     D*************                          56  660MBCL          S01129  S01196
     D***********                            56  660MFIL            S01314RT0152
     D***********                            45  550MFIL            RT0152S01332
     D  MIRL                  56     66  0                                      S01332
     D  MSCL                  67     77  0                                      S01129
     D  MSLI                  78     88  0                                      S01129
     D***********                           100 1100MFFL            S01129E22634
     D***********                           100 1100MFFL            S01314RT0152
     D***********                            89  990MFFL            RT0152S01332
     D  MFUL                 100    110  0                                      S01332
     D  MOPL                 111    121  0                                      S01332
     D  TFLI                 122    132  0                                      CTI002
     D*****DATA*STRUCTURE*FOR*LIMITS*OUTPUT                         S01128S01332
0245 D*********** DS                                                      S01332
     D***********                             1 150 LMO             S01129S01332
     D***********                             1  15 LMO1            S01128S01332
     D***********                            16  30 LMO2            S01128S01332
     D***********                            31  45 LMO3            S01128S01332
     D***********                            46  60 LMO4            S01128S01332
     D***********                            61  75 LMO5            S01129S01332
     D***********                            76  90 LMO6            S01129S01332
     D***********                            91 105 LMO7            S01129S01332
     D***********                           106 120 LMO8            S01129S01332
     D***********                           121 135 LMO9            S01129S01332
     D***********                           136 150 LM10            S01129S01332
     D*                                                                   S01129
     D**DATA*STRUCTURE*FOR*LEGEND*ARRAY                             S01129S01332
     D***********                                                   S01129S01332
     D*********** DS                                                S01128S01332
     D***********                             1  70 LGG             S01129S01332
     D***********                             1   7 LGG1            S01129S01332
     D***********                             8  14 LGG2            S01129S01332
     D***********                            15  21 LGG3            S01129S01332
     D***********                            22  28 LGG4            S01129S01332
     D***********                            29  35 LGG5            S01129S01332
     D***********                            36  42 LGG6            S01129S01332
     D***********                            43  49 LGG7            S01129S01332
     D***********                            50  56 LGG8            S01129S01332
     D***********                            57  63 LGG9            S01129S01332
     D***********                            64  70 LGG10           S01129S01332
     D*****DATA*STRUCTURE*FOR*LIMITS*GRANTED*ARRAY                  S01128S01332
     D*********** DS                                                S01128S01332
     D***                                     1  44 LMG                   S01129
     D***********                             1 150 LGO             S01129S01332
     D***********                             1  15 LMO1G           S01128S01332
     D***********                            16  30 LMO2G           S01128S01332
     D***********                            31  45 LMO3G           S01128S01332
     D***********                            46  60 LMO4G           S01128S01332
     D***********                            61  75 LMO5G           S01129S01332
     D***********                            76  90 LMO6G           S01129S01332
     D***********                            91 105 LMO7G           S01129S01332
     D***********                           106 120 LMO8G           S01129S01332
     D***********                           121 135 LMO9G           S01129S01332
     D***********                           136 150 LM10G           S01129S01332
     D*****DATA*STRUCTURE*FOR*EXPOSURE*ARRAY*OUTPUT                 S01128S01332
     D*********** DS                                                S01128S01332
     D***                                     1  48 XPO                   S01128
     D***********                             1 160 XPAO            S01129S01332
     D***********                             1  16 XPAO1           S01128S01332
     D***********                            17  32 XPAO2           S01128S01332
     D***********                            33  48 XPAO3           S01128S01332
     D***********                            49  64 XPAO4           S01128S01332
     D***********                            65  80 XPAO5           S01129S01332
     D***********                            81  96 XPAO6           S01129S01332
     D***********                            97 112 XPAO7           S01129S01332
     D***********                           113 128 XPAO8           S01129S01332
     D***********                           129 144 XPAO9           S01129S01332
     D***********                           145 160 XPA10           S01129S01332
     D*****DATA*STRUCTURE*FOR*AVAILABLE*ARRAY*OUTPUT                S01128S01332
     D*********** DS                                                S01128S01332
     D***                                     1  48 AV                    S01129
     D***********                             1 160 AVO             S01129S01332
     D***********                             1  16 AVO1            S01128S01332
     D***********                            17  32 AVO2            S01128S01332
     D***********                            33  48 AVO3            S01128S01332
     D***********                            49  64 AVO4            S01128S01332
     D***********                            65  80 AVO5            S01129S01332
     D***********                            81  96 AVO6            S01129S01332
     D***********                            97 112 AVO7            S01129S01332
     D***********                           113 128 AVO8            S01129S01332
     D***********                           129 144 AVO9            S01129S01332
     D***********                           145 160 AV10            S01129S01332
     D*****DATA*STRUCTURE*FOR*AVAILABLE*GRANTED*OUTPUT              S01128S01332
     D*********** DS                                                S01128S01332
     D***                                     1  48 AVG                   S01129
     D***********                             1 160 AGO             S01129S01332
     D***********                             1  16 AVO1G           S01128S01332
     D***********                            17  32 AVO2G           S01128S01332
     D***********                            33  48 AVO3G           S01128S01332
     D***********                            49  64 AVO4G           S01128S01332
     D***********                            65  80 AVO5G           S01129S01332
     D***********                            81  96 AVO6G           S01129S01332
     D***********                            97 112 AVO7G           S01129S01332
     D***********                           113 128 AVO8G           S01129S01332
     D***********                           129 144 AVO9G           S01129S01332
     D***********                           145 160 AV10G           S01129S01332
     D*****DATA*STRUCTURE*FOR*EXPOSURE*ARRAY*OUTPUT                 S01128S01332
     D*********** DS                                                S01128S01332
     D***                                     1  48 OBO                   S01129
     D***********                             1 160 OBAO            S01129S01332
     D***********                             1  16 OBAO1           S01128S01332
     D***********                            17  32 OBAO2           S01128S01332
     D***********                            33  48 OBAO3           S01128S01332
     D***********                            49  64 OBAO4           S01128S01332
     D***********                            65  80 OBAO5           S01129S01332
     D***********                            81  96 OBAO6           S01129S01332
     D***********                            97 112 OBAO7           S01129S01332
     D***********                           113 128 OBAO8           S01129S01332
     D***********                           129 144 OBAO9           S01129S01332
     D***********                           145 160 OBA10           S01129S01332
0256 D*****DATA*STRUCTURE*FOR*CLKEY                                       S01332
0257 D*********** DS                                                      S01332
0258 D***********                             1   7 CLKEYA                S01332
0259 D***********                             1   60CNUM                  S01332
0260 D***********                             7   7 RCDT                  S01332
0261 D**   DATA STRUCTURE FOR PACKEY
0262 D*           DS
0263 D*                                       1   8 PACKEY
0264 D*                                       1   60CPAR
0265 D*                                       7   80RECN
0266 D**   DATA STRUCTURE FOR CURKEY
0267 D                 DS
0268 D  CURKEY                 1     12
0269 D  RECT                   1      2
0270 D  CCY                    9     11
0271 D  SREC                  12     12
0272 D**   DATA STRUCTURE FOR SNUMI (INPUT NUMBER OR S/NAME)
0273 D                 DS
0274 D  SNUMI                  1     10
0275 D  SCSNMA                 1      6
0276 D  SCSNMB                 7     10
0205 D**   DATA STRUCTURE FOR MODULE SEQUENCES
0206 D                 DS                                                       S01129
0207 D  MSEQ                   1      4                                         S01129
0208 D  MS                     1      2  0                                      S01129
0208 D  MB                     3      4  0                                      S01129
0205 D**   DATA STRUCTURE FOR MODULE SEQUENCES
0206 D                 DS                                                       S01129
0207 D***********                             1  40 MSQ             S01129E22634
0207 D***********                             1  32 MSQ             E22634S01314
0207 D***********                             1  36 MSQ             S01314S01332
0208 D***********                             1   20MSFXS           S01129S01332
0208 D***********                             5   60MSMMS           S01129S01332
0208 D***********                             9  100MSIFS           S01129E22634
0208 D***********                            13  140MSLNS           S01129E22634
0208 D***********                            17  180MSRES           S01129E22634
0208 D***********                            21  220MSLCS           S01129E22634
0208 D***********                            25  260MSSCS           S01129E22634
0208 D***********                            29  300MSSIS           S01129E22634
0208 D***********                            33  340MSSPS           S01129E22634
0208 D***********                            37  380MSFIS           S01129E22634
0208 D***********                             9  100MSLNS           E22634S01332
0208 D***********                            13  140MSRES           E22634S01332
0208 D***********                            17  180MSLCS           E22634S01314
0208 D***********                            17  180MSIFS           S01314S01332
0208 D***********                            21  220MSSCS           E22634S01332
0208 D***********                            25  260MSSIS           E22634S01332
0208 D***********                            29  300MSSPS           E22634S01332
0208 D***********                            33  340MSFIS           S01314S01332
0207 D*                                       1  44 MSQ             S01332CTI002
     D  MSQ                    1     48  0                                      CTI002
     D                                     DIM(12)                                               CTI
0208 D  BMSFX                  1      2  0                                      S01332
0208 D  BMSMM                  5      6  0                                      S01332
0208 D  BMSFR                  9     10  0                                      S01332
0208 D  BMSLN                 13     14  0                                      S01332
0208 D  BMSRT                 17     18  0                                      S01332
0208 D  BMSIR                 21     22  0                                      S01332
0208 D  BMSSC                 25     26  0                                      S01332
0208 D  BMSSI                 29     30  0                                      S01332
0208 D  BMSSP                 33     34  0                                      S01332
0208 D  BMSFU                 37     38  0                                      S01332
0208 D  BMSOP                 41     42  0                                      S01332
0208 D  BMSTF                 45     46  0                                      CTI002
0208 D  MS01                   3      4  0                                      S01129
0208 D  MS02                   7      8  0                                      S01129
0208 D  MS03                  11     12  0                                      S01129
0208 D  MS04                  15     16  0                                      S01129
0208 D  MS05                  19     20  0                                      S01129
0208 D  MS06                  23     24  0                                      S01129
0208 D  MS07                  27     28  0                                      S01129
0208 D  MS08                  31     32  0                                      S01129
0208 D***********                            35  360MS09            S01129E22634
0208 D***********                            39  400MS10            S01129E22634
0208 D  MS09                  35     36  0                                      S01314
0208 D  MS10                  39     40  0                                      S01332
0208 D  MS11                  43     44  0                                      S01332
     D  MS12                  47     48  0                                      CTI002
0154 D*
0155 D*    EM LINK ENQUIRY CONTROL FILE
0098 D                 DS
0099 D  EMCONT                 1    140
0258 D  RECI                   1      1
0258 D  PGN1                   2      9
0258 D  PGT1                  10     69
0258 D  PGL1                  70     70
0258 D  PGO1                  71     72
0258 D  PGN2                  73     80
0258 D  PGT2                  81    140
0256 D*****DATA*STRUCTURE*DETAIL*REQUEST*FIELDS                           S01332
0257 D*********** DS                                                      S01332
0258 D***                                     1   7 LEALL                 S01129
     D***********                             1  10 OPTINP          S01129S01332
     D***********                             1  10 OPI             S01129S01332
0259 D***********                             1   1 LEO1                  S01332
0259 D***********                             2   2 LEO2                  S01332
0259 D***********                             3   3 LEO3                  S01332
0259 D***********                             4   4 LEO4                  S01332
0259 D***********                             5   5 LEO5                  S01332
0259 D***********                             6   6 LEO6                  S01332
0259 D***********                             7   7 LEO7                  S01332
     D***********                             8   8 LEO8            S01129S01332
     D***********                             9   9 LEO9            S01129S01332
     D***********                            10  10 LE10            S01129S01332
     D*********** DS                                                S01129S01332
     D***********                             1  16 OPS             S01129S01332
     D***********                             1  16 OPTALL          S01129S01332
0277 D**  LOCAL DATA AREA FOR DATABASE RECORD
0278 D LDA            UDS           256
0279 D**********                            134 138 DBFILE                S01117
0280 D**********                            139 167 DBKEY                 S01117
0281 D**********                            168 175 DBPGM                 S01117
0282 D**********                            176 1770DBASE                 S01117
     D  DBFILE               134    141                                         S01117
     D  DBKEY                142    170                                         S01117
     D  DBPGM                171    180                                         S01117
     D  DBASE                181    183  0                                      S01117
0277 D**  MIDAS MODULES DATA AREA
0278 D*MOD*******UDS                             64                       E12570
0278 D****MMOD       UDS                            256            E12570 S01129
0279 D***                                     2   2 DLMODL                S01129
0280 D***                                     3   3 RTMODL                S01129
0281 D***                                     4   4 CLMODL                S01129
0282 D***                                     5   5 STMODL                S01129
0282 D***                                     6   6 BCMODL                S01129
0282 D***                                    10  10 LEMODL                S01129
0282 D***                                    16  16 REMODL                S01129
0282 D***                                    24  24 BGMODL                S01129
     D**
     D IPSDS          SDS
     D  WSID                 244    246
     D  WSID2                245    246
     D                 DS                                                                   MD058079
     D  WORK15                 1     15  0                                                  MD058079
     D/COPY WNCPYSRC,EMH00001
     D SDCLLM        E DS                  EXTNAME(SDCLLMPD)                    S01314
      *                                                                   S01332
     D SDEXPM        E DS                  EXTNAME(SDEXPMPD)                    S01332
      * DATA STRUCTURE FOR EXPOSURE MANAGEMENT ICD                        S01332
      *                                                                   S01332
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    S01332
      * DATA STRUCTURE FOR CUSTOMER DETAILS                               S01332
     D*                                                                   S01332
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                    S01332
      * DATA STRUCTURE FOR CURRENCY DETAILS                               S01332
     D*                                                                   S01332
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    S01474
      ***  Switchable Features File Details                               S01474
      *                                                                   S01474
     D ZMUSER          DS            17                                         S01332
     D* DATA AREA OF MENU USER                                            S01332
     D/COPY WNCPYSRC,EM0301I001
     D  DFTBR                 11     13                                         S01332
      *                                                                   CTI002
      * MODULE DETAILS ACCESSED VIA ACCESS PROGRAM                        CTI002
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                    CTI002
      *                                                                   CTI002
     D*                                                                   S01314
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01314
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                S01314
     D*                                                                   S01314
     D DSSDY         E DS                  EXTNAME(DSSDY)                       S01314
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE                S01314
     D*                                                                   S01314
     D DSLDY         E DS                  EXTNAME(DSLDY)                       CSD007
      ** Third DS for access programs, very long data structure           CSD007
      *                                                                   CSD007
     D EMCONF        E DS                  EXTNAME(EMCOFJW0)                                MD058079
     D                                     PREFIX(X)                                        MD058079
     D** LINK ENQUIRY DATA AREA
     D EMSDS         E DS                  EXTNAME(EMDTA)
     D SESDS         E DS                                                       E16158
     D*                                                                   S01408
     D/COPY WNCPYSRC,EM0301IIP1                                           S01408
     D*                                                                   S01408
     D*                                                                   S01474
     D** Data Structure for *LDA                                          S01474
     D                UDS                                                       S01474
     D***********                            51  60 LIB1            S01474090890
     D***********                            61  70 LIB2            S01474090890
     D***********                            71  80 LIB3            S01474090890
     D***********                            91 100 LIB4            083857090890
     D  LIB1                  61     70                                         090890
     D  LIB2                  71     80                                         090890
     D  LIB3                  91    100                                         090890
     D  LIB4                 101    110                                         090890
     D/COPY WNCPYSRC,EM0301I002
     D                 DS                                                       083857
     D  WUFMT                  1     89                                         083857
     D  WULNC                 87     89                                         083857
     D*                                                                   S01474
     D                 DS                                                       S01474
     D** Data Structure to set up Leo Customer Number                     S01474
     D  CUSZER                 1      2  0                                      S01474
     D**********                              3   80CNUM                  S01474              CSD027
     D  CNUM                   3      8
     D  LEOCUS                 1      8  0                                      S01474
     D  LEOCSA                 1      8                                         S01474
     D*                                                                   S01474
     D** Data Structures Leo exposure fields for output                   S01474
     D                 DS                                                       S01474
     D  LEOAVL                 1     15  0                                      S01474
     D  LEOAVA                 1     15                                         S01474
     D                 DS                                                       S01474
     D  TOTDED                 1     15  0                                      S01474
     D  TTDEDA                 1     15                                         S01474
     D                 DS                                                       S01474
     D  TOTLEO                 1     15  0                                      S01474
     D  TOTLEA                 1     15                                         S01474
     D*                                                                   S01474
     D CPPARM          DS                                                       S01474
     D** Data structures for fields from CUSPRO                           S01474
     D  CPCNO                  1      8  0                                      S01474
     D  CPUPD                  9     12P 0                                      S01474
     D  CPUSR                 13     20                                         S01474
     D  CPACR                 21     28                                         S01474
     D  CPSTAT                29     29                                         S01474
     D  CPNAM                 30     64                                         S01474
     D  CPBCOD                65     68                                         S01474
     D  CPRES                 69     73                                         S01474
     D  CPRIS                 74     78                                         S01474
     D  CPRESP                79     84                                         S01474
     D  CPACNO                85     96                                         S01474
     D  CPTAX                 97    108                                         S01474
     D  CPBANK               109    109                                         S01474
     D  CPFL01               110    118                                         S01474
     D  CPCD                 119    122P 0                                      S01474
     D  CPOF1                123    126                                         S01474
     D  CPOF2                127    130                                         S01474
     D  CPALT                131    142                                         S01474
     D  CPFL02               143    256                                         S01474
     D*                                                                   S01474
     D LIPARM          DS                                                       S01474
     D** Data structures for fields from LIACRN                           S01474
     D  LIGACR                 1      8                                         S01474
     D  LILTYP                 9      9                                         S01474
     D  LICACR                10     17                                         S01474
     D  LICOD                 18     20                                         S01474
     D  LICCY                 21     23                                         S01474
     D  LIBRN                 24     25                                         S01474
     D  LIUPD                 26     29P 0                                      S01474
     D  LIUSR                 30     37                                         S01474
     D  LIAMTL                38     44P 0                                      S01474
     D  LIAMTS                45     51P 0                                      S01474
     D  LIUNAP                52     58P 0                                      S01474
     D  LISYS                 59     59                                         S01474
     D  LIRDT                 60     63P 0                                      S01474
     D  LIRES                 64     64                                         S01474
     D P@FMT           DS                                                       S01474
     D***  Data structure to hold the outgoing rcd format of the file     S01474
     D*                                                                   S01474
     D  W@DS1                  1    256                                         S01474
     D*                                                                   S01474
     D*  DATA STRUCTURE FOR COMPILATION  - COPYRIGHT INSERTION
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              COPYRIGHT STMT   LN0
     D  CPY@##                 1     20
     I/COPY WNCPYSRC,EM0301E001
0088 I*                                                                   E21212
0124 I*                         LIMITS FILE - DETAIL RECORD               E21212
0125 I*                                                                   E21212
     I*LIMIT   NS                                                   E21212S01314
     I**********                              1   1 RECIL           E21212S01314
     I**********                              2  96 LOTL            E21212S01314
0088 I*                                                                   EM0300
0089 I*  EXPOSURE MANAGEMENT    WORKSTATION FILE                          EM0300
0090 I*                                                                   EM0300
     IEM0301F1      01                                                          S01128
     I**** EM0301FMNS  01   1 CS   2 CF                                   S01128
     I**                                      3   3 LEO1                  S01128
     I**                                      4   4 LEO2                  S01128
     I**                                      5   5 LEO3                  S01128
     I**                                      6   6 LEO4                  S01128
     I**                                      7   7 LEO5                  S01128
     I**                                      8   8 LEO6                  S01128
     I**                                      9   9 LEO7                  S01128
     I**                                     10  19 SNUMI                 S01128
     I**                                     20  22 SCCYI                 S01128
     I**                                                                  S01128
0238 IEMCEXX1F
0098 I********      MCUN                            MCUNAA                E81176
0098 I**************MCUO                            MCUN                  LN0071
0098 I              MCUOA                       MCUN                            LN0071
     I/COPY WNCPYSRC,EM0301I003
0123 I*
0124 I*     EXPOSURE MANAGEMENT LIMITS FILE - DETAIL RECORD
0125 I*
0126 IEMLIML2F      06
0154 I*
0155 I*****CLIENT*FILE*-*CUSTOMER*STANDING*DATA*RECORD.                   S01332
0156 I***********                                                         S01332
0157 I**CLINTCBF****06                                                    S01332
0098 I***********   CPAR                            CPRN                  S01332
0204 I***********                                                         S01332
0205 I*****CUSTOMER*SHORTNAMES*FILE*-*DETAIL*RECORD.                      S01332
0206 I***********                                                         S01332
0207 I**SNAMECBF*                                                         S01332
0098 I***********   CNUM                            CNMB                  S01332
0098 I***********   CRNM                            CRNMS                 S01332
0098 I***********   CTWN                            CTWNS                 S01332
     I***********                                                   E81176S01332
     I********CORRECT*PARENTS*NUMBER*FOR*S/NAME*REQUEST             E81176S01332
     I***********                                                   E81176S01332
     I***********   CPAR                            CPRNS           E81176S01332
0219 I**
0205 I*    PARENT/CUSTOMER     FILE - DETAIL RECORD.
0206 I*
0207 IPACUSCBF
0098 I              CNUM                        CNUMP
0098 I              CRNM                        CRNMP
0098 I              CTWN                        CTWNP
0098 I              CSNM                        CSNMP
0219 I**
0220 I**   TABLE FILE - INSTALLATION CONTROL DATA RECORD 1.
0221 I**
0222 ITABTB10F
0229 I**
0230 I**   TABLE FILE - INSTALLATION CONTROL DATA RECORD 2.
0231 I**
0232 ITABTB11F      10
0235 I**
0236 I*******TABLE*FILE*-*CURRENCY*RECORD                                 S01332
0237 I***********                                                         S01332
0238 I**TABTG10F****12                                                    S01332
0098 I***********   KEY                             CURKEY                S01332
0098 I*             ZZ0089                          ZZYY89
      *COPY*ZSRSRC,ZSEDITZ2                                                                 MD058079
0283 C/EJECT
     C**
     C                   MOVEA     CPY@          BIS@             80
     C*
0284 C********************************************************************
     C     *DTAARA       DEFINE                  EMSDS
     C     *DTAARA       DEFINE                  SESDS                                         E1615
     C     *DTAARA       DEFINE                  LDA
     C****       *NAMVAR   DEFN           MMOD                            S01129
     C***********CLKEY     KLIST                                          S01332
     C***********          KFLD           CNUM                            S01332
     C***********          KFLD           RCDT                            S01332
     C     LIMKEY        KLIST
     C                   KFLD                    RECJ
     C                   KFLD                    MLC
0281 C* KLIST FOR SLIMH FILE                                              S01129
0281 C     SLMKEY        KLIST                                                                 S0112
0281 C                   KFLD                    CNUM                                          S0112
0281 C                   KFLD                    BOKH                                          S0112
0281 C                   KFLD                    LVLH                                          S0112
0281 C                   KFLD                    ETYH                                          S0112
     C**
     C***********EMUPKY    KLIST                                          S01332
     C***********          KFLD           PGN2                            S01332
     C***********          KFLD           PGL1                            S01332
     C***********EMCNKY    KLIST                                          S01332
     C***********          KFLD           PGN1                            S01332
     C***********          KFLD           PGO1                            S01332
     C*                                                                   S01332
     C* PARAMETER LIST FOR PROGRAM 'AOCUSTR0'                             S01332
     C*                                                                   S01332
     C     PLIST1        PLIST                                                                 S0133
     C**********           PARM '*BLANKS' @RTCD                                        S01332 253255
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN                                         S0133
     C                   PARM                    CKEY             10                           S0133
     C                   PARM                    KEYSTS            7                           S0133
     C***********SDCUST    PARM SDCUST    DSSDY                    S01332 CSD007
     C     SDCUST        PARM      SDCUST        DSLDY                                         CSD00
     C*                                                                   S01332
     C* PARAMETER LIST FOR PROGRAM 'AOCURRR0'                             S01332
     C*                                                                   S01332
     C     PLIST2        PLIST                                                                 S0133
     C**********           PARM '*BLANKS' @RTCD                                        S01332 253255
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN                                         S0133
     C                   PARM                    @CYCD             3                           S0133
     C     SDCURR        PARM      SDCURR        DSSDY                                         S0133
     C********************************************************************
     C**
     C*    FIRST  CYCLE CALCULATIONS.
     C*
     C*   FIRST CYCLE ONLY
     C                   EXSR      FICYC
     C**
     C***********RQDTD     IFEQ *BLANKS                                 **S01332
     C****IF*NO*INITIAL*CUSTOMER*IN*DATA*AREA*EMSDS*THEN*CALL             S01332
     C*******CUSTOMER*SHORTNAME*ENQUIRY                                   S01332
     C***********                                                         S01332
     C***********          EXSR SHNSR                                     S01332
     C***********          ELSE                                           S01332
     C***********                                                         S01332
     C****ELSE*USE*REQUEST*DATA                                           S01332
     C***********          MOVELRQDTD     CNUM                          **S01332
     C***********          END                                            S01332
     C*                                                                   S01332
     C*                                                                   S01408
     C/COPY WNCPYSRC,EM0301CCP1                                           S01408
     C*                                                                   S01408
     C**    WRITE HEADINGS                                                S01332
     C                   TIME                    STIME                                         S0133
     C                   WRITE     EM0301F1                                                    S0133
     C*                                                                   S01332
     C**    SET SUBFILE INDICATORS                                        S01332
     C                   MOVEA     '001'         *IN(21)                                       S0133
     C                   Z-ADD     1             RRN               3 0                         S0133
     C                   Z-ADD     RRN           DSPREC                                        S0133
     C                   WRITE     EM0301C1                                                    S0133
     C                   MOVEA     '011'         *IN(21)                                       S0133
     C*                                                                   S01408
     C/COPY WNCPYSRC,EM0301CCP2                                           S01408
     C*                                                                   S01408
     C                   EXFMT     EM0301C1                                                    S0133
     C*                                                                   S01408
     C/COPY WNCPYSRC,EM0301CCP3                                           S01408
     C*                                                                   S01408
     C**
     C*   MAIN PROCESSING LOOP -
     C                   SETON                                        85
     C     *IN85         DOWEQ     '1'                                                       **
     C*
     C*******IF*CMD/5*THEN*CALL*CUSTOMER*SHORTNAME*ENQUIRY                S01332
     C*******AND*RESET*CURRENCY*FIELD                                     S01332
     C***05******          MOVE LCCY      CCY                             S01332
     C***05******          MOVE *BLANKS   SCCYI                           S01332
     C***05******          MOVE EMCCNM    CCNM                            S01332
     C***05******          EXSR SHNSR                                     S01332
     C***********                                                   E10855S01332
     C***AVOID*ZERO*DETAILS*FOR*WRONG*CLIENT/CCY*INPUT*IN*DETAILS,  E10855S01332
     C***FOLLOWED*BY*CMD*5*AND*ANOTHER*CLIENT*NUMBER*SELECTED       E10855S01332
     C***********                                                   E10855S01332
     C***05******          SETOF                     4149LR         E10855S01332
     C*                                                             E10855S01332
     C*      GET DETAILS FOR CUSTOMER - DISPLAY
     C                   EXSR      DETSR
     C                   END
     C/COPY WNCPYSRC,EM0301C006
     C***
     C********************************************************************
     C*
     C********************************************************************
     C**
     C**    DETSR SR TO GET DETAILS OF CUSTOMER AND WRITE TO SCREEN
     C**
     C**   CALLED FROM   MAIN PROCESSING
     C*****CALLS*SR******RETSR,MAINSR,CMDSR1,DTRQS1,                      S01332
     C**   CALLS SR      CMDSR1,CUSTS1,CURRS1,MAINSR,DTRQS1,              S01332
     C*****CALLS*PROG.***EMC999
0418 C*    This subroutine controls the detail processing.
0418 C*    First  we access the customer details. Then we call mainsr
     C*       to get the exposure/limit/availability information.
     C*    Then we write/read the details screen,and perform the relevant
     C*       processing
     C*   If program called from menu then process the upper link enquiry
     C*      option. - in LEOPS2
     C*
0418 C*    Indicators used
0418 C*    05  on - call shortname enquiry
0418 C*    17  off- upper level link enquiry available                     L0120
     C*****19**on*-*HELP*requested                                        S01199
0418 C*    20  on - display subfile
0418 C*    31  on - display dubious message
0418 C*    44  on - non-display details
0418 C*    84  on - deals found
0418 C*    86  on - details processing loop
0418 C*    87  on - details display loop
0418 C*    89  off- display error messages
0418 C*    99  on - database error end program
0418 C*    U7  on - database error end program
0418 C*    U8  on - database error end program
0418 C*    LR  on - end program
     C     DETSR         BEGSR                                                  *** DETSR  ***
     C**
     C**    SR PROCESSING LOOP
     C                   SETON                                        86
     C     *IN86         DOWEQ     '1'
     C*                                                                   S01332
     C**    SET SUBFILE INDICATORS                                        S01332
     C                   MOVEA     '001'         *IN(21)                                       S0133
     C                   Z-ADD     1             RRN               3 0                         S0133
     C                   Z-ADD     RRN           DSPREC                                        S0133
     C                   WRITE     EM0301C1                                                    S0133
     C                   MOVEA     '011'         *IN(21)                                       S0133
     C*                                                                   S01332
     C                   SETON                                        89
     C*
     C*********GET CUSTOMER DETIALS                                       S01332
0528 C***********          MOVE 'A'       RCDT                            S01332
0530 C***********CLKEY     CHAINCLINT                99                   S01332
     C************IN99     IFEQ '1'                                       S01332
0531 C***********          MOVE 'CLINT'   DBFILE                          S01332
0532 C***********          MOVE CLKEYA    DBKEY                           S01332
0533 C***********          MOVE 'EM0301'  DBPGM                           S01332
0534 C***********          Z-ADD01        DBASE            DATABASE 01    S01332
0535 C***********          SETON                     LRU7U8               S01332
0536 C***********          EXSR RETSR                                     S01332
0536 C***********          END                                            S01332
     C***********                                                   S01311S01332
     C***CUSTOMER*INVALID*IF*HAS*BEEN*DELETED                       S01311S01332
     C************IN99     IFEQ '0'                                 S01311S01332
     C***********CHTP      ANDEQ'D'                                 S01311S01332
     C***********          SETON                     494443         S01311S01332
     C***********          SETOF                     89             S01311S01332
     C***********          MOVELMSG,10    ERMSG                     S01311S01332
     C***********          GOTO DELCUS                              S01311S01332
     C***********          END                                      S01311S01332
     C*                                                                   S01332
     C*********CHECK*COMMAND*KEYS                                   S01332E28696
     C***********          EXSR CMDSR1                              S01332E28696
     C*                                                                   E28696
     C**       CHECK FOR F3 TAKEN FROM INITIAL SCREEN                     E28696
     C     *INKC         IFEQ      '1'                                                         E2869
     C                   SETON                                        LR                       E2869
     C                   MOVE      '7'           RETNWF            1                           E2869
     C                   EXSR      RETSR                                                       E2869
     C                   END                                                                   E2869
     C*                                                                   S01332
     C**       VALIDATE CUSTOMER                                          S01332
     C                   EXSR      CUSTS1                                                      S0133
     C*                                                                   S01332
     C**       IF CUSTOMER VALID, VALIDATE CURRENCY                       S01332
     C     *IN41         IFEQ      '0'                                                         S0133
     C     *IN49         ANDEQ     '0'                                                         S0133
     C     SCCYI         IFNE      *BLANKS                                                     S0133
     C                   EXSR      CURRS1                                                      S0133
     C                   ELSE                                                                  S0133
     C                   MOVE      EMCCNM        CCNMWF                                        S0133
     C                   MOVE      EMCCNM        A6CYNM                                        09427
     C                   END                                                                   S0133
     C                   END                                                                   S0133
     C*                                                                   S01332
     C**       DO WHILE INPUT INVALID                                     S01332
     C     *IN89         DOWEQ     '0'                                                         S0133
     C                   WRITE     EM0301F1                                                    S0133
     C                   EXFMT     EM0301C1                                                    S0133
     C                   EXSR      CMDSR1                                                      S0133
     C                   EXSR      CUSTS1                                                      S0133
     C     *IN41         IFEQ      '0'                                                         S0133
     C     *IN49         ANDEQ     '0'                                                         S0133
     C     SCCYI         IFNE      *BLANKS                                                     S0133
     C                   EXSR      CURRS1                                                      S0133
     C                   ELSE                                                                  S0133
     C                   MOVE      EMCCNM        CCNMWF                                        S0133
     C                   MOVE      EMCCNM        A6CYNM                                        09427
     C                   END                                                                   S0133
     C                   END                                                                   S0133
     C                   END                                                                   S0133
     C*                                                                   S01332
     C*     SAVE SCREEN FIELDS                                            S01332
     C                   MOVE      SNUMI         SNUMO                                         07535
     C                   MOVE      SNUMI         SSNUMI           10                           S0133
     C                   MOVE      SCCYI         SSCCYI            3                           S0133
0415 C***********                                                         S01332
0416 C*********STORE*CUSTOMER*NAME*&*TOWN                                 S01332
0417 C***********                                                         S01332
     C***********                                                   S01128S01332
     C***ADD*SHORT*NAME                                             S01128S01332
     C***********                                                   S01128S01332
     C***********          MOVELCSNM      SHRTNM                    S01128S01332
     C***********          MOVELCNUM      CUSNO                     S01128S01332
     C***********                                                   S01128S01332
0418 C***********          MOVE CRNM      CHLNM  20                       S01332
0419 C***********          MOVE CTWN      CHLTW  10                       S01332
0418 C***********          MOVE CNUM      CNUMWF  60                      S01332
0418 C***********          MOVE CPRN      CPRNWF  60                      S01332
     C***********                                                   E81176S01332
     C***IF*PARENTS*NUMBER*IS*ZERO*-*DO*NOT*DISPLAY                 E81176S01332
     C***********                                                   E81176S01332
     C***********CPRNWF    IFEQ 0                                   E81176S01332
     C***********          SETON                     43             E81176S01332
     C***********          ELSE                                     E81176S01332
     C***********          SETOF                     43             E81176S01332
     C***********          END                                      E81176S01332
     C*                                                                   E81176
     C/COPY WNCPYSRC,EMH00002
     C                   TIME                    STIME             6 0                         S0133
0366 C                   SETOFF                                       44
0366 C                   EXSR      MAINSR
     C**
     C*     OUTPUT CUSTOMER DETAILS
     C**
     C***********DELCUS    TAG                                      S01311S01332
     C***********          TIME           STIME   60                      S01332
     C*
     C**   SCREEN PROCESSING VALIDITY LOOP
     C***********          SETOF                     19                   S01332
     C                   SETON                                        87
     C     *IN31         IFEQ      '1'
     C     *IN89         IFEQ      '1'
0369 C                   MOVEL     MSG(3)        ERMSG
     C                   SETOFF                                       89
     C                   END
     C                   END
     C*                                                                   S01332
     C**    IF RECORDS DISPLAYED ON SUBFILE, SET SUBFILE INDICATORS       S01332
     C     *IN23         IFEQ      '0'                                                         S0133
     C                   MOVEA     '11'          *IN(21)                                       S0133
     C                   END                                                                   S0133
     C*                                                                   S01332
     C     *IN87         DOWEQ     '1'
     C****                 EXCPT                                          S01128
     C***********          WRITEEM0301F1                            S01128S01332
     C***********                                                         S01332
     C******PROCESS*DETAILS*SCREEN                                  S01199S01332
     C***********          SETON                     19                   S01199
     C************IN19     DOWEQ'1'                                       S01199
     C**********           SETOF                     1982                 S01199
     C***********          SETOF                     19             S01199S01332
     C****                 READ EM0301FM               8282               S01128
     C***********          READ EM0301F1               8282         S01128S01332
     C**
     C*****IF*HELP*THEN*CALL*EMC999                                       S01199
     C***19****************CALL*'EMC999'                                  S01199
     C*********************PARM***********PROGNM                          S01199
     C*********************END                                            S01199
     C**
     C*****IF*CUSTOMER*BY*PARENT*DETAILS*REQUESTED                        S01332
     C************IN03     IFEQ '1'                                       S01332
     C****       *IN52     IFEQ '1'                                       S01128
0411 C***********          EXSR CHLDRQ                                    S01332
     C****                 ELSE                                           S01128
     C****                 MOVELMSG,13    ERMSG                           S01128
     C****                 SETOF                     89                   S01128
     C****                 END                                            S01128
     C***********          END                                            S01332
     C*                                                                   S01332
     C**   WRITE SUBFILE SCREEN                                           S01332
      *                                                                   075353
      * If customer changed end loop after error displayed                075353
     C     SNUMI         IFNE      SNUMO                                                       07535
     C                   MOVE      '0'           *IN87                                         07535
     C                   ENDIF                                                                 07535
      *                                                                   075353
     C                   EXFMT     EM0301C1                                                    S0133
     C**
     C     *IN87         IFEQ      '1'                                                         07535
     C                   MOVE      *BLANKS       ERMSG
     C                   SETON                                        89
     C*                                                                   S01332
     C**   SET OFF OPTION ERROR INDICATOR AND MODIFIED DATA INDICATORS    S01332
     C                   SETOFF                                       3565                     S0133
     C*
     C*
0409 C*    CHECK COMMAND KEY RESPONSE
0411 C                   EXSR      CMDSR1
     C*
0409 C*****IF*COMMAND*KEY*5*THEN*END*SR*LOOP                              S01332
0411 C************IN05     IFEQ '1'                                       S01332
0411 C***********          SETOF                     8687                 S01332
     C***********                                                   E81252S01332
     C***CLEAR*DISPLAY*VALUES*SO*THAT*NEW*CUSTOMER*VALUES*IS*CORRECTE81252S01332
     C***********                                                   E81252S01332
     C***********          EXSR ZERO                                E81252S01332
     C***********                                                   E81252S01332
     C***********          ELSE                                           S01332
     C***********                                                   S01129S01332
     C**CHECK*FOR*ROLLUP/DOWN*ERROR*IF*NOT*USED*AT*THIS*TIME        S01129S01332
     C***********                                                   S01129S01332
0281 C************IN73     IFEQ '1'                                 S01129S01332
0281 C************IN74     OREQ '1'                                 S01129S01332
0281 C***********                                                   S01129S01332
     C************IN44     IFEQ '0'                                 S01129S01332
     C************IN73     IFEQ '1'                                 S01129S01332
     C************IN75     IFEQ '0'                                 S01129S01332
     C***********Z3        ORLT 11                                  S01129S01332
     C***********          MOVE MSG,14    ERMSG                     S01129S01332
     C***********          SETOF                     89             S01129S01332
     C***********          GOTO ENDDET                              S01129S01332
     C***********          ELSE                                     S01129S01332
     C***********          MOVE *BLANKS   ERMSG                     S01129S01332
     C***********          SETON                     89             S01129S01332
     C***********          EXSR FILL2                               S01129S01332
     C***********          GOTO ENDDET                              S01129S01332
     C***********          END                                      S01129S01332
     C***********          END                                      S01129S01332
     C***********                                                   S01129S01332
     C************IN74     IFEQ '1'                                 S01129S01332
     C************IN75     IFEQ '1'                                 S01129S01332
     C***********          MOVE MSG,14    ERMSG                     S01129S01332
     C***********          SETOF                     89             S01129S01332
     C***********          GOTO ENDDET                              S01129S01332
     C***********          ELSE                                     S01129S01332
     C***********          MOVE *BLANKS   ERMSG                     S01129S01332
     C***********          SETON                     89             S01129S01332
     C***********          EXSR FILL1                               S01129S01332
     C***********          GOTO ENDDET                              S01129S01332
     C***********          END                                      S01129S01332
     C***********          END                                      S01129S01332
     C***********          END                                      S01129S01332
     C***********                                                   S01129S01332
     C**CLEAR*IND*TO*SHOW*NO*DETAILS*AT*THIS*TIME                   S01129S01332
     C***********                                                   S01129S01332
     C***********          SETOF                     75             S01129S01332
     C***********                                                   S01129S01332
     C***********          ELSE                                     S01129S01332
0370 C***********          Z-ADD0         X       20                      S01332
     C**MOVE*OPTIONS*INPUT*TO*ARRAY                                 S01129S01332
     C************IN75     IFEQ '1'                                 S01129S01332
     C***********          DO   10        Z1                        S01129S01332
     C***********          MOVE OPI,Z1    OPS,Z1                    S01129S01332
     C***********          END                                      S01129S01332
     C***********          ELSE                                     S01129S01332
     C***********          Z-ADD11        Z2                        S01129S01332
     C***********          DO   6         Z1                        S01129S01332
     C***********          MOVE OPI,Z1    OPS,Z2                    S01129S01332
     C***********          ADD  1         Z2                        S01129S01332
     C***********          END                                      S01129S01332
     C***********          END                                      S01129S01332
     C***********          END                                      S01129S01332
0361 C***********                                                         S01332
0362 C*****CHECK*IF*DETAILS*REQUESTED                                     S01332
0369 C***********LEALL     IFNE *BLANKS                             S01129S01332
     C***********OPTALL    IFNE *BLANKS                             S01129S01332
0369 C***********          EXSR DTRQS1                                    S01332
0369 C***********          ELSE                                           S01332
0361 C***********                                                         S01332
0362 C*****VALIDATE*CUSTOMER/SHORTNAME*ENTERED                            S01332
0369 C***********          EXSR CUSTS1                                    S01332
0361 C***********                                                         S01332
0362 C*****VALIDATE*CURRENCY*IF*ENTERED                                   S01332
     C***********SCCYI     IFNE *BLANKS                                   S01332
0369 C***********          EXSR CURRS1                                    S01332
     C***********          ELSE                                           S01332
     C***********          MOVE EMCCNM    CCNMWF                          S01332
     C***********          END                                            S01332
0361 C***********                                                         S01332
0362 C*****IF*VALID*THEN*ACCESS*INFORMATION                               S01332
0320 C***********          MOVE CCNMWF    CCNM                            S01332
0369 C***********          EXSR MAINSR                                    S01332
     C***41N44***          EXSR FILL1                               S01129S01332
0369 C***********          END                                            S01332
     C*                                                                   S01332
     C                   SETOFF                                       3565                     S0133
     C*                                                                   S01332
     C*****CHECK*FOR*INPUT*OF*SCREEN*FIELDS************************S01332 067378
     C***********SNUMI     IFNE SSNUMI                             S01332 067378
     C***********SCCYI     ORNE SSCCYI                             S01332 067378
     C                   SETOFF                                       87                       S0133
     C***********          ELSE                                    S01332 067378
     C*                                                                   S01332
     C**   CHECK FOR INPUT OF SCREEN FIELDS                               072775
     C     SNUMI         IFEQ      *BLANKS                                                     07277
     C     SSNUMI        ANDNE     *BLANKS                                                     07277
     C                   END                                                                   07277
     C     SCCYI         IFEQ      *BLANKS                                                     07277
     C     SSCCYI        ANDNE     *BLANKS                                                     07277
     C                   MOVE      SSCCYI        SCCYI                                         07277
     C                   END                                                                   07277
     C*                                                                   072775
     C**   IF RECORDS HAVE BEEN DISPLAYED ON SUBFILE, CHECK IF ANY        S01332
     C**   OPTIONS HAVE BEEN ENTERED                                      S01332
     C     *IN23         IFEQ      '0'                                                         S0133
     C                   MOVE      *BLANK        RETND                                         S0133
     C                   Z-ADD     0             X                 1 0                         S0133
     C*                                                                   S01332
     C**   DO UNTIL NO MORE CHANGED RECORDS FOUND                         S01332
     C**   OR F1 OR F12 TAKEN FROM LOWER LEVEL PROGRAMS                   S01332
     C**   OR AN INVALID OPTION TAKEN                                     S01332
     C                   MOVE      '0'           *IN25                                         07335
     C     *IN61         DOUEQ     '1'                                                         S0133
     C     RETND         OREQ      'U'                                                         S0133
     C     RETND         OREQ      'S'                                                         S0133
     C     *IN89         OREQ      '0'                                                         S0133
     C*                                                                   S01332
     C**   DO UNTIL A SUBFILE RECORD IS FOUND AGAINST WHICH AN OPTION     S01332
     C**      HAS BEEN ENTERED                                            S01332
     C**   OR ALL SUBFILE RECORDS HAVE BEEN READ                          S01332
     C     OPTN          DOUNE     *BLANK                                                      S0133
     C     *IN61         OREQ      '1'                                                         S0133
     C                   READC     EM0301S1                               61                   S0133
     C*                                                                   S01332
     C**   IF A CHANGED RECORD IS FOUND WITH THE OPTION BLANK, SET OFF    S01332
     C**   INDICATOR TO HIGHLIGHT OPTION IN ERROR AND MODIFIED DATA       S01332
     C**   FLAG                                                           S01332
     C     *IN61         IFEQ      '0'                                                         S0133
     C     OPTN          ANDEQ     *BLANK                                                      S0133
     C                   SETOFF                                       3565                     S0133
     C                   UPDATE    EM0301S1                                                    S0133
     C                   END                                                                   S0133
     C                   END                                                                   S0133
     C*                                                                   S01332
     C**   IF A CHANGED RECORD IS FOUND WITH THE OPTION NOT BLANK,        S01332
     C**   PROCESS OPTION ENTERED                                         S01332
     C     *IN61         IFEQ      '0'                                                         S0133
     C     OPTN          ANDNE     *BLANK                                                      S0133
     C                   MOVE      '1'           *IN25                                         07335
     C                   EXSR      DTRQS1                                                      S0133
     C                   Z-ADD     RRN           DSPREC                                        S0133
     C                   UPDATE    EM0301S1                                                    S0133
     C                   END                                                                   S0133
     C                   END                                                                   S0133
     C                   END                                                                   S0133
     C***********          END                                     S01332 067378
     C*                                                                   S01332
     C     *IN61         IFEQ      '0'                                          NOT EO SUBFILE 07335
     C     *IN25         ANDEQ     '1'                                          OPTION ENTERED 07335
     C     RETND         ANDEQ     'S'                                          F1 AT LOWER LVL07335
     C*** Reinstate Screen values from initial enquiry                    073353
     C     SCCYI         IFNE      SSCCYI                                                      07335
     C                   MOVE      SSCCYI        SCCYI                                         07335
     C                   END                                                                   07335
     C                   END                                                                   07335
     C                   END                                                                   07535
     C*                                                                   073353
     C**   SET OPTION FIELD TO BLANK                                      S01332
     C                   MOVE      *BLANK        OPTN                                          S0133
0479 C**
0482 C**   STORE INPUT NUM/SNAME FOR COMP. ON NEXT CYCLE
0483 C***********          MOVE SNUMI     SNUMO  10                       075353
     C***********          END                                            S01332
     C*
      * If customer changed but no error end loop.                        075353
     C     *IN87         IFEQ      '1'                                                         07535
     C     *IN35         ANDEQ     '0'                                                         07535
     C     *IN65         ANDEQ     '0'                                                         07535
     C     SNUMI         ANDNE     SNUMO                                                       07535
     C                   MOVE      '0'           *IN87                                         07535
     C                   ENDIF                                                                 07535
      *                                                                   075353
     C     ENDDET        TAG                                                                   S0112
     C                   END
     C*
     C                   END
0727 C*
0728 C                   ENDSR
     C**
0431 C********************************************************************
0433 C**  MAINSR   MAIN SCREEN PROCESSING                 ** MAINSR SR*
0434 C**    CALLED DETSR
0289 C*****CALLS*SR**EXPDAT,CLDLON,PARENT,                                S01332
0289 C**   CALLS SR  EXPDAT,CLDLON,PARENT,EXCTOT                          S01332
0730 C********************************************************************
0435 C**                                                               ***
0436 C     MAINSR        BEGSR
0436 C**
     C                   MOVE      '0'           *IN65                                         07535
0436 C   41
0437 COR 49
0438 COR LR              GOTO      ENDMNS
0439 C   31              MOVEL     MSG(3)        ERMSG
     C*                                                                   E10633
     C*  SETOF 89 TO DISPLAY MESSAGE 3                                    E10633
     C*                                                                   E10633
     C   31              SETOFF                                       89                       E1063
     C*                                                                   E10633
0440 C**  VALID INPUT PROCESSING
0441 C**  SET LIMKEY TO ACCESS LIMITS FILE
0442 C                   MOVE      '1'           RECJ
0443 C                   MOVE      CNUM          MLC
0445 C                   SETOFF                                       06
0444 C     LIMKEY        CHAIN     EMLIM                              47
0444 C   06RECI          COMP      'D'                                0606
0445 C   06              SETON                                            47    ON - DELETED
     C*                                                                   E21191
     C**  IF RECORD IS DELETED OR EXPIRED, (RECI = *), ZEROISE LIMITS     E21191
     C************IN06     IFEQ '1'                                 E21191E22940
     C***********          Z-ADD0         MOAL   110                E21191E22940
     C***********          Z-ADD0         MFXL   110                E21191E22940
     C***********          Z-ADD0         MMML   110                E21191E22940
     C***********          Z-ADD0         MLEL   110                E21191E22940
     C***********          Z-ADD0         MREL   110                E21191E22940
     C**********           Z-ADD0         MBCL   110                E21191S01314
     C***********          Z-ADD0         MIFL   110                S01314E22940
     C***********          Z-ADD0         MSCL   110                E21191E22940
     C***********          Z-ADD0         MSTL   110                E21191E22940
     C***********          Z-ADD0         MFFL   110                E21191E22634
     C***********          Z-ADD0         MFFL   110          E22634S01314E22940
     C***********          END                                      E21191E22940
     C   47              Z-ADD     0             LIM                                           E2294
     C   47              Z-ADD     0             MOAL                                          E2294
     C*                                                                   E21191
0446 C**  OUTPUT MSG IF NO LIVE LIMIT FOUND OTHERWISE CALC EXPIRY DATE
0447 C  N47              EXSR      EXPDAT
0448 C**
0449 C**   TEST IF PARENT, CHILD OR LONER
0450 C**
0451 C***********          TESTB'2'       CMIN       51  5252 = PARENT    S01332
0452 C***51******0         COMP CPRN                     5353 ON = LONER  S01332
0451 C     BBPAIN        COMP      'P'                                515152    52 = PARENT    S0133
     C     *IN51         IFEQ      '1'                                          51 = CHILD     S0133
     C     BBPCNB        IFEQ      *BLANKS                                                     S0133
     C                   SETON                                        53        53 ON = LONER  S0133
     C                   ELSE                                                                  S0133
     C                   SETOFF                                       53                       S0133
     C                   END                                                                   S0133
     C                   END                                                                   S0133
0453 C**
0454 C**   CALCULATE EXPOSURE
0455 C**
0456 C                   EXSR      LIMCH                                                       E2121
0456 C   51              EXSR      CLDLON
     C   51
0457 CANN53              SETOFF                                       43
0458 C   52              EXSR      PARENT
     C**
     C**   IF A VALID CURRENCY HAS BEEN ENTERED, CONVERT THE AMOUNTS
     C**   TO BE OUTPUT ACCORDINGLY
     C**
     C     SCCYI         IFNE      *BLANKS
     C***********SPOT      ANDNEEMSPOT                              S01129S01332
     C     A6SPRT        ANDNE     EMSPOT                                                      S0133
     C                   EXSR      CONVAM
0462 C     XPO           DIV(H)    1000          XPO
0463 C     OBO           DIV(H)    1000          OBO
     C                   ELSE
0459 C**
0460 C**   DIVIDE EXPOSURE & OFF-SETTING BALANCE BY 1000 FOR OUTPUT
0461 C**
0462 C     XPA           DIV(H)    1000          XPO
0463 C     OBA           DIV(H)    1000          OBO
     C**
     C                   END
0464 C***********                                                         S01332
0465 C****TOTAL*ALL*EXPOSURE*AND*OFF-SETTING*BALANCE,*THEN*SUBTRACT       S01332
0466 C*****FX*EXPOSURE.**FX*IS*NEVER*INCLUDED*IN*TOTALS                   S01332
     C*****ST*COUNTERPARTY*ALSO*NO*INCLUDED                         S01129S01332
0467 C***********          XFOOTXPO       XPTOT                           S01332
0468 C***********          SUB  XPO,1     XPTOT                           S01332
     C***********          SUB  XPO,7     XPTOT                     S01129S01332
0469 C***********          XFOOTOBO       OBTOT                           S01332
     C***********          SUB  OBO,1     OBTOT                     S01128S01332
     C***********          SUB  OBO,7     OBTOT                     S01129S01332
     C*                                                                   S01332
     C**  TOTAL ALL EXPOSURE AND OFF-SETTING BALANCES                     S01332
     C                   XFOOT     XPO           XPTOT                                         S0133
     C                   XFOOT     OBO           OBTOT                                         S0133
0470 C**
0471 C**  CALCULATE AVAILABILITIES (LIMIT - EXPOSURE)
0472 C**
0473 C***        LM        SUB  XPO       AV                              S01129
     C     LIM           SUB       XPO           AV                                            S0112
     C     LMG           SUB       XPO           AVG                                           S0112
     C*                                                                   S01332
     C**  TOTAL ALL GRANTED LIMITS                                        S01332
     C                   XFOOT     LMG           LMGTOT                                        S0112
     C***********LMGTOT    SUB  LMG,1     LMGTOT                    S01128S01332
     C***********LMGTOT    SUB  LMG,7     LMGTOT                    S01129S01332
     C*                                                                   S01332
     C**  DETERMINE WHICH MODULES TO BE EXCLUDED FROM TOTALS              S01332
     C                   Z-ADD     0             EXALMG           11 0
     C                   EXSR      EXCTOT                                                      S0133
     C     LMGTOT        SUB       XPTOT         AVGTOT                                        S0112
     C                   ADD       EXALMG        AVGTOT
0474 C     MOAL          SUB       XPTOT         AVTOT
0475 C**
     C* STORE DETAILS FOR OUTPUT                                          S01129
     C**                                                                  S01129
     C                   EXSR      ARFILL                                                      S0112
     C/COPY WNCPYSRC,EM0301C010
     C**                                                                  S01129
     C* FILL FIRST SCREEN OF DETAILS                                      S01129
     C**                                                                  S01129
     C                   WRITE     EM0301F1                                                    S0133
     C                   Z-ADD     1             Z                 2 0                         S0133
     C                   Z-ADD     1             RRN                                           S0133
     C                   Z-ADD     RRN           DSPREC                                        S0133
     C/COPY WNCPYSRC,EM0301C019
     C     RRN           DOWLE     Z3                                                          S0133
     C                   EXSR      FILL1                                                       S0112
     C                   ADD       1             Z                                             S0133
     C                   WRITE     EM0301S1                                                    S0133
     C                   ADD       1             RRN                      23                   S0133
     C                   END                                                                   S0133
     C/COPY WNCPYSRC,EM0301C020
     C*                                                                   S01474
     C     S01474        IFEQ      'Y'                                                         S0147
     C                   EXSR      LEODTL                                                      S0147
     C                   END                                                                   S0147
     C*                                                                   S01474
     C/COPY WNCPYSRC,EM0301C018
     C                   WRITE     EM0301F2                                                    S0133
0475 C**
0477 C     ENDMNS        ENDSR                                                  ** ENDSR ** C
0491 C********************************************************************
0345 C**
0345 C**
0738 C********************************************************************
     C*
0739 C*    CHLDRQ SR TO CALL CHILD ENQUIRY FOR A PARENT
     C*
     C*****CALLED*FROM***DETSR,                                           S01332
     C**   CALLED FROM   CMDSR1                                           S01332
     C**   CALLS SR      RETSR
     C**   CALLS PROG.   EMC1600
0391 C**
0740 C     CHLDRQ        BEGSR                                                  ** CHLDRQ   ***
0392 C**      FIRST UPDATE DATA AREA
0405 C     *LOCK         IN        EMSDS
0402 C                   MOVEL     EMCONT        EMSDS
0402 C***********          MOVE '0'       RETND                           S01311
     C                   MOVE      ' '           RETND                                         S0131
0402 C                   MOVEL     *BLANKS       RQDTD
     C                   MOVE      *BLANKS       PARM             12                           E2869
     C****                 MOVELCNUM      RQDTD                           S01128
     C     *IN52         IFEQ      '1'                                                         S0112
     C                   MOVEL     CNUM          RQDTD                                         S0112
     C                   ELSE                                                                  S0112
     C***********          MOVELCPRNWF    RQDTD                     S01128E28696
     C                   MOVEL     CPRNWF        PARM                                          E2869
     C                   MOVE      CNUM          PARM                                          E2869
     C                   MOVEL     PARM          RQDTD                                         E2869
     C                   END                                                                   S0112
0405 C                   OUT       EMSDS
0391 C**
0392 C**      CALL PROGRAM
0405 C                   OUT       LDA
0406 C                   CALL      'EMC1600'
0405 C     *LOCK         IN        LDA
0391 C**
0392 C**      CHECK RETURN CODE
0409 C**
0405 C     *LOCK         IN        EMSDS
     C*                                                                   S01332
     C** IF F3 TAKEN IN LOWER LEVEL PROGRAM                               S01332
     C** OR DATABASE ERROR HAS OCCURRED IN LOWER LEVEL PROGRAM,           S01332
     C** EXIT PROGRAM                                                     S01332
0407 C     RETND         IFEQ      '7'
     C     RETND         OREQ      'E'                                                         S0133
0392 C*************IF*CMD/3*THEN*END*PROGRAM                        S01179S01332
0407 C                   MOVEL     RETND         RETNWF
0383 C                   EXSR      RETSR                                                    D
0405 C                   ELSE
     C*                                                                   S01128
     C*  REDISPLAY CHILD INFORMATION; DEPENDS IF IT'S CMD 2 OR SELECTED   S01128
     C*  CHILD DISPLAY                                                    S01128
     C                   MOVEL     '0'           RETNWF                                        S0112
0405 C                   MOVEL     RQDTD         CNUM                                          S0112
0405 C                   MOVEL     RQDTD         SNUMI                                         S0112
0405 C                   MOVEL     RQDTD         SNUMO                                         S0112
0405 C                   END                                                                   S0112
0405 C                   OUT       EMSDS
0475 C**
0477 C                   ENDSR                                                  ** ENDSR ** C
0491 C********************************************************************
     C********************************************************************S01332
     C*                                                                   S01332
     C*    MDLMRQ SR TO CALL MODULAR LIMIT ENQUIRY                        S01332
     C*                                                                   S01332
     C**   CALLED FROM   CMDSR1                                           S01332
     C**   CALLS SR      RETSR                                            S01332
     C**   CALLS PROG.   DL0130                                           S01332
     C**                                                                  S01332
     C     MDLMRQ        BEGSR                                                  ** MDLMRQ   ***S0133
     C**      FIRST UPDATE DATA AREA                                      S01332
     C     *LOCK         IN        EMSDS                                                       S0133
     C                   MOVE      ' '           RETND                                         S0133
     C                   MOVEL     *BLANKS       RQDTD                                         S0133
     C                   MOVEL     CNUM          RQDTD                                         S0133
     C                   MOVE      'DL'          RQDTD                                         S0133
     C                   OUT       EMSDS                                                       S0133
     C**                                                                  S01332
     C**      CALL PROGRAM                                                S01332
     C                   OUT       LDA                                                         S0133
     C*                                                                   S01408
     C/COPY WNCPYSRC,EM0301CCP4                                           S01408
     C     S01433        IFEQ      'Y'                                                         14737
     C                   CALL      'DL0130A'                                                   14737
     C                   ELSE                                                                  14737
     C*                                                                   S01408
     C                   CALL      'DL0130'                                                    S0133
     C                   END                                                                   14737
     C*                                                                   S01408
     C/COPY WNCPYSRC,EM0301CCP5                                           S01408
     C*                                                                   S01408
     C     *LOCK         IN        LDA                                                         S0133
     C**                                                                  S01332
     C**      CHECK RETURN CODE                                           S01332
     C**                                                                  S01332
     C     *LOCK         IN        EMSDS                                                       S0133
     C*                                                                   S01332
     C** IF F3 TAKEN IN LOWER LEVEL PROGRAM                               S01332
     C** OR DATABASE ERROR HAS OCCURRED IN LOWER LEVEL PROGRAM,           S01332
     C** EXIT PROGRAM                                                     S01332
     C     RETND         IFEQ      'Q'                                                         S0133
     C     RETND         OREQ      'E'                                                         S0133
     C                   MOVEL     RETND         RETNWF                                        S0133
     C                   EXSR      RETSR                                                       S0133
     C                   END                                                                   S0133
     C                   OUT       EMSDS                                                       S0133
     C**                                                                  S01332
     C                   ENDSR                                                  ** ENDSR **    S0133
     C********************************************************************S01332
     C********************************************************************S01332
     C*                                                                   S01332
     C*    DDRKRQ SR TO CALL DAILY DELIVERY RISK ENQUIRY                  S01332
     C*                                                                   S01332
     C**   CALLED FROM   CMDSR1                                           S01332
     C**   CALLS SR      ZDATE2,RETSR                                     S01332
     C**   CALLS PROG.   EM1500                                           S01332
     C**                                                                  S01332
     C     DDRKRQ        BEGSR                                                  ** DDRKRQ   ***S0133
     C                   MOVEL     CNUM          PCUST                                         S0133
     C                   Z-ADD     RUND          ZDAYNO                                        S0133
     C                   EXSR      ZDATE2                                                      S0133
     C                   MOVEL     ZDATE         PDATE                                         S0133
     C**                                                                  S01332
     C**      CALL PROGRAM                                                S01332
     C                   OUT       LDA                                                         S0133
     C                   CALL      'EM1500'                                                    S0133
     C                   PARM      *BLANKS       PRTCD             7                           S0133
     C                   PARM                    PCUST            10                           S0133
     C                   PARM      'ALL'         PBRCA             3                           S0133
     C                   PARM                    PDATE             6                           S0133
     C                   PARM      'ALL'         PCCY              3                           S0133
     C                   PARM      'Y'           PFX               1                           S0133
     C                   PARM      'Y'           PMM               1                           S0133
     C                   PARM      'Y'           PLE               1                           S0133
     C                   PARM      'Y'           PCP               1                           S0133
     C     *LOCK         IN        LDA                                                         S0133
     C**                                                                  S01332
     C**      CHECK RETURN CODE                                           S01332
     C**                                                                  S01332
     C     PRTCD         IFEQ      '*ERROR'                                                    S0133
     C                   MOVE      'E'           RETNWF                                        S0133
     C                   EXSR      RETSR                                                       S0133
     C                   END                                                                   S0133
     C     PRTCD         IFEQ      '*EXIT'                                                     S0133
     C                   EXSR      RETSR                                                       S0133
     C                   END                                                                   S0133
     C**                                                                  S01332
     C                   ENDSR                                                  ** ENDSR **    S0133
     C********************************************************************S01332
     C********************************************************************S01332
     C*                                                                   S01332
     C*    EXCTOT SR TO DETERMINE WHICH MODULES TO EXCLUDE                S01332
     C*                                                                   S01332
     C**   CALLED FROM   MAINSR                                           S01332
     C**   CALLS SR                                                       S01332
     C**   CALLS PROG.                                                    S01332
     C**                                                                  S01332
     C     EXCTOT        BEGSR                                                  ** EXCTOT   ***S0133
     C*                                                                   S01332
     C                   Z-ADD     1             XX                2 0                         S0133
     C                   MOVEA     *BLANKS       XCN(XX)                                       S0133
     C*                                                                   S01332
     C**  ACCESS EM EXPOSURE SCALING FILE TO DETERMINE WHICH MODULES      S01332
     C**  ARE TO BE EXCLUDED FROM TOTALS                                  S01332
     C**  IF A RECORD FOUND AND INCLUDE IN TOTALS IS NOT 'Y',             S01332
     C**     SUBTRACT APPROPRIATE EXPOSURE AND OFF-SETTING BALANCE FROM   S01332
     C**     TOTALS AND MOVE APPROPRIATE TEXT TO EXCLUSION NARRATIVE      S01332
     C**  (IF RECORD NOT FOUND, MEANS MODULE TO BE INCLUDED)              S01332
     C*                                                                   S01332
     C**  FX                                                              S01332
     C     BUMSFX        IFNE      0                                                           S0133
     C     'FX'          CHAIN     EMEXSCL1                           20                       S0133
     C     *IN20         IFEQ      '0'                                                         S0133
     C     EKINTO        ANDNE     'Y'                                                         S0133
     C                   SUB       XPO(1)        XPTOT                                         S0133
     C                   SUB       OBO(1)        OBTOT                                         S0133
     C                   SUB       LMG(1)        LMGTOT                                        S0133
     C                   MOVEA     LEG(1)        XCN(XX)                                       S0133
     C                   ADD       2             XX                                            S0133
     C                   END                                                                   S0133
     C                   END                                                                   S0133
     C*                                                                   S01332
     C**  MM                                                              S01332
     C     BUMSMM        IFNE      0                                                           S0133
     C     'MM'          CHAIN     EMEXSCL1                           20                       S0133
     C     *IN20         IFEQ      '0'                                                         S0133
     C     EKINTO        ANDNE     'Y'                                                         S0133
     C                   SUB       XPO(2)        XPTOT                                         S0133
     C                   SUB       OBO(2)        OBTOT                                         S0133
     C                   SUB       LMG(2)        LMGTOT                                        S0133
     C     XX            IFNE      1                                                           S0133
     C                   MOVEA     ','           XCN(XX)                                       S0133
     C                   ADD       1             XX                                            S0133
     C                   END                                                                   S0133
     C                   MOVEA     LEG(2)        XCN(XX)                                       S0133
     C                   ADD       2             XX                                            S0133
     C                   END                                                                   S0133
     C                   END                                                                   S0133
     C*                                                                   S01332
     C**  FRA                                                             S01332
     C     BUMSFR        IFNE      0                                                           S0133
     C     'FR'          CHAIN     EMEXSCL1                           20                       S0133
     C     *IN20         IFEQ      '0'                                                         S0133
     C     EKINTO        ANDNE     'Y'                                                         S0133
     C                   SUB       XPO(3)        XPTOT                                         S0133
     C                   SUB       OBO(3)        OBTOT                                         S0133
     C                   SUB       LMG(3)        LMGTOT                                        S0133
     C     XX            IFNE      1                                                           S0133
     C                   MOVEA     ','           XCN(XX)                                       S0133
     C                   ADD       1             XX                                            S0133
     C                   END                                                                   S0133
     C                   MOVEA     LEG(3)        XCN(XX)                                       S0133
     C                   ADD       3             XX                                            S0133
     C                   END                                                                   S0133
     C                   END                                                                   S0133
     C*                                                                   S01332
     C**  LOANS                                                           S01332
     C     BUMSLN        IFNE      0                                                           S0133
     C     'LE'          CHAIN     EMEXSCL1                           20                       S0133
     C     *IN20         IFEQ      '0'                                                         S0133
     C     EKINTO        ANDNE     'Y'                                                         S0133
     C                   SUB       XPO(4)        XPTOT                                         S0133
     C                   SUB       OBO(4)        OBTOT                                         S0133
     C                   SUB       LMG(4)        LMGTOT                                        S0133
     C     XX            IFNE      1                                                           S0133
     C                   MOVEA     ','           XCN(XX)                                       S0133
     C                   ADD       1             XX                                            S0133
     C                   END                                                                   S0133
     C                   MOVEA     LEG(4)        XCN(XX)                                       S0133
     C                   ADD       5             XX                                            S0133
     C                   END                                                                   S0133
     C                   END                                                                   S0133
     C*                                                                   S01332
     C**  RETAIL                                                          S01332
     C     BUMSRT        IFNE      0                                                           S0133
     C     'RE'          CHAIN     EMEXSCL1                           20                       S0133
     C     *IN20         IFEQ      '0'                                                         S0133
     C     EKINTO        ANDNE     'Y'                                                         S0133
     C                   SUB       XPO(5)        XPTOT                                         S0133
     C                   SUB       OBO(5)        OBTOT                                         S0133
     C                   SUB       LMG(5)        LMGTOT                                        S0133
     C     XX            IFNE      1                                                           S0133
     C                   MOVEA     ','           XCN(XX)                                       S0133
     C                   ADD       1             XX                                            S0133
     C                   END                                                                   S0133
     C                   MOVEA     LEG(5)        XCN(XX)                                       S0133
     C                   ADD       6             XX                                            S0133
     C                   END                                                                   S0133
     C                   END                                                                   S0133
     C*                                                                   S01332
     C**  IRS                                                             S01332
     C     BUMSIR        IFNE      0                                                           S0133
     C     'IR'          CHAIN     EMEXSCL1                           20                       S0133
     C     *IN20         IFEQ      '0'                                                         S0133
     C     EKINTO        ANDNE     'Y'                                                         S0133
     C                   SUB       XPO(6)        XPTOT                                         S0133
     C                   SUB       OBO(6)        OBTOT                                         S0133
     C                   SUB       LMG(6)        LMGTOT                                        S0133
     C     XX            IFNE      1                                                           S0133
     C                   MOVEA     ','           XCN(XX)                                       S0133
     C                   ADD       1             XX                                            S0133
     C                   END                                                                   S0133
     C                   MOVEA     LEG(6)        XCN(XX)                                       S0133
     C                   ADD       3             XX                                            S0133
     C                   END                                                                   S0133
     C                   END                                                                   S0133
     C*                                                                   S01332
     C**  SE-COUNTERPARTY                                                 S01332
     C     BUMSSC        IFNE      0                                                           S0133
     C     'CP'          CHAIN     EMEXSCL1                           20                       S0133
     C     *IN20         IFEQ      '0'                                                         S0133
     C     EKINTO        ANDNE     'Y'                                                         S0133
     C                   SUB       XPO(7)        XPTOT                                         S0133
     C                   SUB       OBO(7)        OBTOT                                         S0133
     C                   SUB       LMG(7)        LMGTOT                                        S0133
     C     XX            IFNE      1                                                           S0133
     C                   MOVEA     ','           XCN(XX)                                       S0133
     C                   ADD       1             XX                                            S0133
     C                   END                                                                   S0133
     C                   MOVEA     LEG(7)        XCN(XX)                                       S0133
     C                   ADD       6             XX                                            S0133
     C                   END                                                                   S0133
     C                   END                                                                   S0133
     C*                                                                   S01332
     C**  SE-ISSUER                                                       S01332
     C     BUMSSI        IFNE      0                                                           S0133
     C     'IS'          CHAIN     EMEXSCL1                           20                       S0133
     C     *IN20         IFEQ      '0'                                                         S0133
     C     EKINTO        ANDNE     'Y'                                                         S0133
     C                   SUB       XPO(8)        XPTOT                                         S0133
     C                   SUB       OBO(8)        OBTOT                                         S0133
     C                   SUB       LMG(8)        LMGTOT                                        S0133
     C     XX            IFNE      1                                                           S0133
     C                   MOVEA     ','           XCN(XX)                                       S0133
     C                   ADD       1             XX                                            S0133
     C                   END                                                                   S0133
     C                   MOVEA     LEG(8)        XCN(XX)                                       S0133
     C                   ADD       6             XX                                            S0133
     C                   END                                                                   S0133
     C                   END                                                                   S0133
     C*                                                                   S01332
     C**  FUTURES                                                         S01332
     C     BUMSFU        IFNE      0                                                           S0133
     C     'FU'          CHAIN     EMEXSCL1                           20                       S0133
     C     *IN20         IFEQ      '0'                                                         S0133
     C     EKINTO        ANDNE     'Y'                                                         S0133
     C                   SUB       XPO(10)       XPTOT                                         S0133
     C                   SUB       OBO(10)       OBTOT                                         S0133
     C     XX            IFNE      1                                                           S0133
     C                   MOVEA     ','           XCN(XX)                                       S0133
     C                   ADD       1             XX                                            S0133
     C                   END                                                                   S0133
     C                   MOVEA     LEG(10)       XCN(XX)                                       S0133
     C                   ADD       7             XX                                            S0133
     C                   END                                                                   S0133
     C     *IN20         IFEQ      '0'
     C     EKINTO        ANDEQ     'Y'
     C                   ADD       XPO(10)       EXALMG
     C                   ENDIF
     C                   END                                                                   S0133
     C*                                                                   S01332
     C**  OPTIONS                                                         S01332
     C     BUMSOP        IFNE      0                                                           S0133
     C     'OP'          CHAIN     EMEXSCL1                           20                       S0133
     C     *IN20         IFEQ      '0'                                                         S0133
     C     EKINTO        ANDNE     'Y'                                                         S0133
     C                   SUB       XPO(11)       XPTOT                                         S0133
     C                   SUB       OBO(11)       OBTOT                                         S0133
     C     XX            IFNE      1                                                           S0133
     C                   MOVEA     ','           XCN(XX)                                       S0133
     C                   ADD       1             XX                                            S0133
     C                   END                                                                   S0133
     C                   MOVEA     LEG(11)       XCN(XX)                                       S0133
     C                   ADD       7             XX                                            S0133
     C                   END                                                                   S0133
     C     *IN20         IFEQ      '0'
     C     EKINTO        ANDEQ     'Y'
     C                   ADD       XPO(11)       EXALMG
     C                   ENDIF
     C                   END                                                                   S0133
     C*                                                                   S01332
     C**  TRADE FINANCE                                                   CTI002
     C     BUMSTF        IFNE      0                                                           CTI00
     C     'TF'          CHAIN     EMEXSCL1                           20                       CTI00
     C     *IN20         IFEQ      '0'                                                         CTI00
     C     EKINTO        ANDNE     'Y'                                                         CTI00
     C*                    SUB  XPO,12    XPTOT                           CTI002
     C                   SUB       OBO(12)       OBTOT                                         CTI00
     C     XX            IFNE      1                                                           CTI00
     C                   MOVEA     ','           XCN(XX)                                       CTI00
     C                   ADD       1             XX                                            CTI00
     C                   END                                                                   CTI00
     C                   MOVEA     LEG(12)       XCN(XX)                                       CTI00
     C                   ADD       7             XX                                            CTI00
     C                   END                                                                   CTI00
     C**NEVER*INCLUDE*TF*INTO*GRANTED*LIMITS                                         S01332 MD029260
     C**********           SUB  XPO,12    XPTOT                                      CTI002 MD029260
     C     *IN20         IFEQ      '0'
     C     EKINTO        ANDEQ     'Y'
     C                   ADD       XPO(12)       EXALMG
     C                   ENDIF
     C                   END                                                                   CTI00
     C*                                                                   S01332
     C**  IF NO MODULES EXCLUDED, SET ON INDICATOR TO NON-DISPLAY         S01332
     C**  'EXCLUDES:-' NARRATIVE                                          S01332
     C     XX            IFEQ      1                                                           S0133
     C                   SETON                                        45                       S0133
     C*                                                                   S01332
     C**  OTHERWISE, MOVE EXCLUSION NARRATIVE TO SCREEN FIELD             S01332
     C                   ELSE                                                                  S0133
     C                   SETOFF                                       45                       S0133
     C*                                                                   S01332
     C**  IF EXCLUSION NARRATIVE NOT FULL, MOVE BLANKS TO REST OF         S01332
     C**  NARRATIVE                                                       S01332
     C     XX            IFLT      57                                                          S0133
     C                   MOVEA     *BLANKS       XCN(XX)                                       S0133
     C                   END                                                                   S0133
     C*                                                                   S01332
     C                   MOVEA     XCN           EXCNAR                                        S0133
     C                   END                                                                   S0133
     C*                                                                   S01332
     C/COPY WNCPYSRC,EM0301C011
     C                   ENDSR                                                  ** ENDSR **    S0133
     C********************************************************************S01332
0345 C**
0738 C********************************************************************
     C***********                                                         S01332
0739 C*****LEOPS2*SR*VALIDATE*AND*PROCESS*UPPER*LINK*ENQ.*REQUEST         S01332
     C***********                                                         S01332
     C*****CALLED*FROM***DETSR,                                           S01332
     C*****CALLS*SR******EMUPS2,RETSR                                     S01332
     C*****CALLS*PROG.***PGN1                                             S01332
0418 C*****This*is*a*standard*link*enquiry*subroutine*for*processing      S01332
0418 C*****request*to*upper*link*enquiries.                               S01332
0418 C*****Indicators*used                                                S01332
0418 C*****16**on**=*non*display*error*message*field                      S01332
0740 C***********LEOPS2    BEGSR                           ** LEOPS2   ***S01332
0496 C***********                                                         S01332
0375 C****ACCESS*RELEVANT*EMCONPF*RECORD                                  S01332
0376 C***********          EXSR EMUPS2                                    S01332
0744 C***********                                                         S01332
0496 C***********                                                         S01332
0375 C****CLEAR*ERROR*MESSAGE*FIELD,                                      S01332
0376 C***********          MOVE *BLANKS   ERMSG                           S01332
0391 C***********                                                         S01332
0392 C********CALL*REQESTED*PROGRAM                                       S01332
0392 C********FIRST*UPDATE*DATA*AREA                                      S01332
0391 C***********                                                         S01332
0405 C************LOCK     IN   EMSDS                                     S01332
0402 C***********          MOVELEMCONT    EMSDS                           S01332
0402 C***********          MOVE '0'       RETND                           S01311
     C***********          MOVE ' '       RETND                     S01311S01332
0402 C***********          MOVEL*BLANKS   RQDTD                           S01332
0407 C***********CNUM      IFGT 0                                         S01332
0402 C***********          MOVELCNUM      RQDTD                           S01332
0386 C***********          END                                            S01332
0405 C***********          OUT  EMSDS                                     S01332
0391 C***********                                                         S01332
0392 C********CALL PROGRAM                                                S01332
0405 C***********          OUT  LDA                                       S01332
0406 C***********          CALL PGN1                                      S01332
0405 C************LOCK     IN   LDA                                       S01332
0391 C***********                                                         S01332
0392 C********CHECK*RETURN*CODE                                           S01332
0409 C***********                                                         S01332
0405 C************LOCK     IN   EMSDS                                     S01332
0407 C***********RETND     IFEQ '7'                                       S01332
0392 C*************IF*CMD/3*THEN*END*PROGRAM                              S01332
0407 C***********          MOVELRETND     RETNWF                          S01332
0383 C***********          EXSR RETSR                                  D  S01332
0405 C***********          ELSE                                           S01332
0392 C*************CHECK*IF*CUSTOMER*CHANGED                              S01332
0407 C***********          MOVEL'0'       RETNWF                          S01332
0407 C***********RETND     IFEQ '9'                                       S01332
0407 C***********          MOVELRQDTD     CNUMDS  60                      S01332
0405 C***********          END                                            S01332
0405 C***********          END                                            S01332
0405 C***********          OUT  EMSDS                                     S01332
0426 C****INVALID*INPUT*DISPLAY*ERROR*CODES                               S01332
0428 C***********ERMSG     COMP *BLANKS                  16               S01332
0429 C***********                                                      ***S01332
0744 C***********                                                         S01332
0745 C***********          ENDSR                                          S01332
0746 C********************************************************************
0846 C**
0846 C**
0492 C********************************************************************
0493 C***********                                                         S01332
     C***********                                                         S01332
0739 C*****SHNSR**SR**PROMPT*FOR*CUSTOMER/SHORTNAME*AND*VALIDATE          S01332
     C***********                                                         S01332
     C*****CALLED*FROM***MAIN*PROCESSING                                  S01332
     C*****CALLS*SR******RETSR                                            S01332
     C*****CALLS*PROG****EMC1900*CUSTOMER*SHORTNAMES*ENQUIRY              S01332
0418 C*****This*is*a*standard*link*enquiry*subroutine*for*processing      S01332
0418 C*****shortname*enquiry*requests.                                    S01332
0418 C***********                                                         S01332
0740 C***********SHNSR     BEGSR                           ** SHNSR ** ***S01332
0391 C***********                                                         S01332
0392 C********FIRST*UPDATE*DATA*AREA                                      S01332
0405 C************LOCK     IN   EMSDS                                     S01332
0402 C***********          MOVELEMCONT    EMSDS                           S01332
0402 C***********          MOVE '0'       RETND                           S01311
     C***********          MOVE ' '       RETND                     S01311S01332
0402 C***********          MOVEL*BLANKS   RQDTD                           S01332
0405 C***********          OUT  EMSDS                                     S01332
0391 C***********                                                         S01332
0392 C********CALL*PROGRAM                                                S01332
0405 C***********          OUT  LDA                                       S01332
0406 C***********          CALL 'EMC1900'                                 S01332
0405 C************LOCK     IN   LDA                                       S01332
0391 C***********                                                         S01332
0392 C********CHECK*RETURN*CODE                                           S01332
0405 C************LOCK     IN   EMSDS                                     S01332
0407 C***********RETND     IFEQ '7'                                       S01332
0392 C*************IF*CMD/3*THEN*END*PROGRAM                              S01332
0407 C***********          MOVELRETND     RETNWF                          S01332
0383 C***********          EXSR RETSR                                  D  S01332
0405 C***********          END                                            S01332
0391 C***********                                                         S01332
0392 C********LOAD*REQUEST*DATA*INTO*CUSTOMER*FIELDS                      S01332
0405 C***********          MOVELRQDTD     CNUM                            S01332
0405 C***********          MOVELRQDTD     SNUMI                           S01332
0405 C***********          MOVELRQDTD     SNUMO                           S01332
     C***********          SETON                     89                   S01332
0744 C***********                                                         S01332
0745 C***********          ENDSR                                          S01332
0412 C***********                                                         S01332
0413 C********************************************************************
0347 C**
0492 C********************************************************************
0493 C**
0494 C**   DTRQS1 SR. - DETAILS REQUESTED SUBROUTINE      ** DTRQS1 SR*
0495 C**   CALLED FROM - DETSR
0495 C**   CALLS  SR   - RETSR
0495 C*    CALLS  PGM  - LOWER LINK ENQUIRY
0496 C**
0497 C     DTRQS1        BEGSR
0496 C**
0375 C**  CLEAR ERROR MESSAGE FIELD,
0376 C                   MOVE      *BLANKS       ERMSG            79
0383 C                   SETON                                        89                    D
0387 C**                                                                **
0387 C****CHECK*THAT*CUSTOMER/SHORTNAME*IS*BLANK*OR*NOT*CHANGED         **S01332
0377 C***********SNUMI     IFNE *BLANKS                                   S01332
0377 C***********SNUMI     IFNE SNUMO                                     S01332
0382 C***********          MOVELMSG,5     ERMSG                           S01332
0383 C***********          GOTO DTERR                      ** GOTO DTERR  S01332
0378 C***********          END                                            S01332
0378 C***********          END                                            S01332
0384 C***********                                                       **S01332
0385 C****CHECK*THAT*ONLY*ONE*OPTION*REQUESTED                            S01332
0387 C***                  MOVEALEALL     LAR                           **S01129
0370 C***********          Z-ADD1         W       20                      S01332
0387 C***        LAR,W     DOWEQ*BLANKS                                 **S01129
0387 C***********OPS,W     DOWEQ*BLANKS                             S01129S01332
0386 C***********          ADD  1         W                               S01332
0386 C***********          END                                            S01332
0387 C***        W         IFLT 7                                         S01129
0387 C***********W         IFLT 16                                  S01129S01332
0386 C***********          ADD  1         W                               S01332
0386 C***                  MOVE *BLANKS   TEST7   7                       S01129
0386 C***                  MOVEALAR,W     TEST7                           S01129
0387 C***        TEST7     IFNE *BLANKS                                   S01129
0386 C***********          MOVE *BLANKS   TEST16 16                 S01129S01332
0386 C***********          MOVEAOPS,W     TEST16                    S01129S01332
0387 C***********TEST16    IFNE *BLANKS                             S01129S01332
0382 C***********          MOVELMSG,5     ERMSG                           S01332
0383 C***********          GOTO DTERR                      ** GOTO DTERR  S01332
0386 C***********          END                                            S01332
0386 C***********          END                                            S01332
0391 C***********                                                         S01332
0391 C***CHECK*THAT*OPTION*IS*VALID                                       S01332
0391 C***********                                                         S01332
0386 C***********          SUB  1         W                               S01332
     C***********          Z-ADDW         WW      20                E16059S01332
     C***********Z4        IFEQ 9                                   E16059S01332
     C***********W         IFGT 10                                  E16059S01332
     C***********W         SUB  1         WW                        E16059S01332
     C***********          END                                      E16059S01332
     C***********          END                                      E16059S01332
     C*                                                                   S01332
      **  CHECK THAT CUSTOMER/SHORTNAME IS BLANK OR NOT CHANGED         **075353
     C     SNUMI         IFEQ      *BLANKS                                                     07535
     C                   MOVE      SNUMO         SNUMI                                         07535
     C                   ENDIF                                                                 07535
      *                                                                   075353
     C     SNUMI         IFNE      *BLANKS                                                     07535
     C     SNUMI         IFNE      SNUMO                                                       07535
     C                   MOVEL     MSG(15)       ERMSG                                         07535
     C                   GOTO      DTERR                                        ** GOTO DTERR  07535
     C                   END                                                                   07535
     C                   END                                                                   07535
     C*                                                                   075353
     C**  CHECK OPTION IS VALID                                           S01332
     C                   Z-ADD     RRN           WW                2 0                         S0133
     C/COPY WNCPYSRC,EM0301C021
0393 C                   MOVEL     'EMC0301 '    PGN1
0394 C  N52              MOVEL     '00'          PGO1                           NON PARENT
0394 C   52              MOVEL     '10'          PGO1                           PARENT
0394 C***                  MOVE LAR,W     PGO1                            S01129
0394 C***                  MOVELW         PGO1                            S01129
0394 C***********          MOVE OPS,W     PGO1                      S01129S01332
0394 C***********          MOVELOPL,W     PGO1                      S01129E16059
     C                   MOVE      OPTN          PGO1                                          S0133
0394 C                   MOVEL     OPL(WW)       PGO1                                          E1605
     C/COPY WNCPYSRC,EM0301C022
0395 C     EMCKY         KLIST
0396 C                   KFLD                    PGN1
0396 C                   KFLD                    PGO1
0398 C**
0397 C** ACCESS CONTROL FILE - IF RECORD NOT FOUND THEN OPTION NOT AVAIL.
     C     SLEGND        IFNE      'LEO    '                                                   S0147
0399 C*****EMCKY         CHAIN     EMCON                              49                    MD058079
     C/EXEC SQL                                                                             MD058079
     C+ SELECT *                                                                            MD058079
     C+ into :EMCONF                                                                        MD058079
     C+ from EMCOFJW0                                                                       MD058079
     C+ where PGN1 = :PGN1 and PGO1 = :PGO1                                                 MD058079
     C/END-EXEC                                                                             MD058079
     C                   SETOFF                                       49                    MD058079
     C                   IF        SQLCODE <> 0                                             MD058079
     C                   SETON                                        49                    MD058079
     C                   ELSE                                                               MD058079
     C                   Eval      RECI = XRECI                                             MD058079
     C                   Eval      PGN1 = XPGN1                                             MD058079
     C                   Eval      PGT1 = XPGT1                                             MD058079
     C                   Eval      PGL1 = XPGL1                                             MD058079
     C                   Eval      PGO1 = XPGO1                                             MD058079
     C                   Eval      PGN2 = XPGN2                                             MD058079
     C                   Eval      PGT2 = XPGT2                                             MD058079
     C                   ENDIF                                                              MD058079
0399 C  N49RECI          COMP      'D'                                4949
0405 C     *IN49         IFEQ      '1'
     C*                                                                   CTI002
     C* IF TRADE FINANCE, CALL EM0340                                     CTI002
     C     SLEGND        IFEQ      LEG(12)                                                     CTI00
     C     OPTN          ANDEQ     '1'                                                         CTI00
     C     CTI002        IFEQ      'Y'                                                         CTI00
     C     BGN3ST        ANDEQ     'Y'                                                         CTI00
     C     CTI007        OREQ      'Y'
     C                   MOVEL     CNUMWF        TMP#CS            6                           CTI00
     C                   CALL      'EM0340'                                                    CTI00
     C                   PARM                    TMP#CS                                        CTI00
     C                   ELSE                                                                  CTI00
     C                   GOTO      DTERR                                        ** GOTO DTERR  CTI00
     C                   ENDIF                                                                 CTI00
     C                   ENDIF                                                                 CTI00
     C*                                                                   CTI002
     C*                                                                   CTI002
0382 C  N52              MOVEL     MSG(7)        ERMSG                          NON PARENT
0382 C   52              MOVEL     MSG(6)        ERMSG                          PARENT
0383 C                   SETOFF                                       49
0383 C                   GOTO      DTERR                                        ** GOTO DTERR
0398 C                   END
     C                   END                                                                   S0147
     C*                                                                   S01332
     C** CHECK IF CAPS/COLLARS/FLOORS TO BE INCLUDED IN OPTIONS           S01332
     C     SLEGND        IFEQ      'Options'                                                   S0133
     C     OPTN          ANDEQ     '2'                                                         S0133
     C     BUCCSO        IFNE      'O'                                                         S0133
0382 C  N52              MOVEL     MSG(7)        ERMSG                          NON PARENT     S0133
0382 C   52              MOVEL     MSG(6)        ERMSG                          PARENT         S0133
     C                   GOTO      DTERR                                                       S0133
     C                   END                                                                   S0133
     C                   END                                                                   S0133
0398 C***********                                                         S01332
0392 C***CHECK*IF*OPTION*IS*THE*SAME*AS*THE*CALLING*OPTION                S01332
0400 C***********PGN2      IFEQ PGN2DX                                    S01332
0391 C***********                                                         S01332
0392 C*********THEN*RETURN*TO*CALLING*PROGRAM                             S01332
0402 C***********          MOVE '9'       RETNWF  1                       S01332
0402 C***********          MOVEL*BLANKS   RQDTWF 20                       S01332
0402 C***********          MOVELCNUMWF    RQDTWF                          S01332
0401 C***********          EXSR RETSR                                     S01332
0404 C***********          ELSE                                           S01332
0391 C**
0392 C** ELSE CALL REQESTED PROGRAM
0391 C**
0392 C**      FIRST UPDATE DATA AREA
0405 C     *LOCK         IN        EMSDS
0402 C                   MOVEL     EMCONT        EMSDS
0402 C***********          MOVE '0'       RETND                           S01311
     C                   MOVE      ' '           RETND                                         S0131
0402 C                   MOVEL     *BLANKS       RQDTD
0402 C                   MOVEL     CNUMWF        RQDTD
      *                                                                   S01311
      * Update data area with appropriate prefix                          S01311
      *                                                                   S01311
     C                   MOVEL     PGN2          MODI                                          S0131
     C     MODI          IFEQ      'GL'                                                        S0131
     C                   MOVE      'GL'          RQDTD                                         S0131
     C                   ELSE                                                                  S0131
     C     MODI          IFEQ      'LE'                                                        S0131
     C                   MOVE      'LE'          RQDTD                                         S0131
     C                   ELSE                                                                  S0133
     C     MODI          IFEQ      'FF'                                                        S0133
     C                   MOVE      'FF'          RQDTD                                         S0133
     C                   MOVEL     CNUMWF        PARMS             9                           S0133
     C                   MOVE      DFTBR         PARMS                                         S0133
     C                   MOVEL     PARMS         RQDTD                                         S0133
     C                   END                                                                   S0133
     C                   END                                                                   S0131
     C                   END                                                                   S0131
0405 C                   OUT       EMSDS
     C**                                                                  E16158
     C**  MOVE CUSTOMER NUMBER INTO LINK ENQUIRY DATA AREA.               E16158
     C**                                                                  E16158
     C     *LOCK         IN        SESDS                                                       E1615
     C**********           Z-ADDCNUMWF    RQCUST                          E16158              CSD027
     C                   MOVE      CNUMWF        RQCUST
     C                   OUT       SESDS                                                       E1615
     C                   MOVEL     PGN2          MODI              2                           E1615
0391 C**
0392 C**      CALL PROGRAM
0405 C                   OUT       LDA
     C***********MODI      IFEQ 'SE'                                E16158E23127
     C*********************CALL 'SEC04'                             E16158E23127
     C*********************PARM           PGN2                      E16158E23127
     C*********************ELSE                                     E16158E23127
     C     SLEGND        IFNE      'LEO    '                                                   S0147
0406 C                   CALL      PGN2
     C*********************END                                      E16158E23127
0405 C     *LOCK         IN        LDA
0391 C**
0382 C****                 MOVE *BLANKS   LEALL                           S01129
0281 C***********          MOVE *BLANKS   OPTALL                    S01129S01332
0281 C***********          MOVE *BLANKS   OPTINP                    S01129S01332
0392 C**      CHECK RETURN CODE
0405 C     *LOCK         IN        EMSDS
0407 C     RETND         IFEQ      '7'
     C     RETND         OREQ      'Q'                                                         S0131
0392 C**           IF CMD/3 THEN END PROGRAM                              S01179
0428 C                   MOVEL     RETND         RETNWF
0383 C                   EXSR      RETSR                                                    D
0405 C                   ELSE
      *                                                                   S01311
      * Check for Error in lower program                                  S01311
      *                                                                   S01311
     C     RETND         IFEQ      'E'                                                         S0131
     C                   SETON                                        U7U8LR                   S0131
     C                   RETURN                                                                S0131
     C                   END                                                                   S0131
     C*                                                                   E10633
0407 C******           RETND     IFEQ '2'                                 E10633
0392 C******           IF CMD/2 THEN REDISPLAY MAIN SCREEN                E10633
0383 C******                     GOTO DTEND                               E10633
0405 C******                     ELSE                                     E10633
0407 C******           RETND     IFEQ '1'                                 E10633
0392 C******           IF CMD/1 - THEN REDISPLAY THE MAIN SCREEN          E10633
0383 C******                     GOTO DTEND                               E10633
     C*                                                                   E10633
     C*  IF RETND IS '1' OR '2' THEN CHECK FOR DUBIOUS INDICATOR          E10633
     C*                                                                   E10633
     C     RETND         IFEQ      '1'                                                         E1063
     C     RETND         OREQ      '2'                                                         E1063
0333 C**                                                                  E10633
0334 C**   ACCESS EMCEXX1 - HEADER & CHECK DUBIOUS INDICATOR              E10633
0335 C**                                                                  E10633
0336 C                   MOVE      *BLANKS       MCUN                                          E1063
0337 C     MCUN          CHAIN     EMCEX                              99                       E1063
0298 C     *IN99         IFEQ      '1'                                                         E1063
0338 C                   MOVE      'EMCEXX1'     DBFILE                                        E1063
0339 C                   MOVE      *BLANKS       DBKEY                                         E1063
0340 C                   MOVE      'EM0301'      DBPGM                                         E1063
0341 C                   Z-ADD     07            DBASE                          DATABASE07     E1063
0342 C                   SETON                                        LRU7U8                   E1063
0318 C                   EXSR      RETSR                                                       E1063
0318 C                   END                                                                   E1063
     C*                                                                   E10633
0344 C     MDI           COMP      'Y'                                    31       *EQ*        E1063
0349 C   31              SETOFF                                       89                       E1063
0350 C   31              MOVE      MSG(3)        ERMSG                                         E1063
0383 C                   GOTO      DTEND                                          ==>>         E1063
     C*                                                                   E10633
0405 C*****                     END                                       E10633
0405 C                   END
0405 C                   END
0405 C                   OUT       EMSDS
     C                   ELSE                                                                  S0147
     C*                                                                   S01474
     C     S01474        IFEQ      'Y'                                                         S0147
     C*                                                                   S01474
     C** Setup call to Leo Customer Lines Display Program                 S01474
     C*                                                                   S01474
     C                   MOVE      *BLANKS       @WRK                                          S0147
     C                   MOVE      *BLANKS       LIBNM                                         S0147
     C                   MOVE      *BLANKS       VARI                                          S0147
     C                   MOVE      '/CSTD10'     WVAR              7                           S0147
     C                   MOVEL     LIB1          LIBNM            10                           S0147
     C                   MOVEA     LIBNM         @WRK                                          S0147
     C                   Z-ADD     1             H                 2 0                         S0147
     C*                                                                   S01474
     C     *BLANK        LOOKUP    @WRK(H)                                14                   S0147
     C                   MOVEA     WVAR          @WRK(H)                                       S0147
     C*                                                                   S01474
     C                   MOVEA     @WRK          VARI             17                           S0147
     C                   MOVE      LILTYP        LEOGRP            1                           S0147
     C                   CALL      VARI                                                        S0147
     C                   PARM                    LEOCSA                                        S0147
     C                   PARM                    LEOGRP                                        S0147
     C     *LOCK         IN        LDA                                                         S0147
     C                   END                                                                   S0147
     C                   END                                                                   S0147
0409 C**
0405 C***********          END                                            S01332
0423 C     DTERR         TAG                                                    ** TAG DTERR
0426 C**  INVALID INPUT DISPLAY ERROR CODES
0428 C     ERMSG         COMP      *BLANKS                                89
     C  N89              SETON                                        3565                     S0133
     C     *IN89         IFEQ      '0'                                                         07277
     C                   MOVE      SSCCYI        SCCYI                                         07277
     C                   END                                                                   07277
     C   89              MOVE      *BLANK        OPTN                                          S0133
0428 C**N89**              MOVE *BLANKS   LEALL                           S01129
0281 C**N89******          MOVE *BLANKS   OPTINP                    S01129S01332
0281 C**N89******          MOVE *BLANKS   OPTALL                    S01129S01332
0429 C**                                                               ***
0513 C     DTEND         ENDSR
0514 C********************************************************************
0429 C**                                                               ***
0721 C********************************************************************
     C***********                                                         S01332
0722 C***EMUPS2**SR.*TO*CHAIN*TO*EMCUP*FILE                               S01332
     C*****CALLED*FROM***LEOPS2                                           S01332
     C***********                                                         S01332
0418 C*****This*is*a*standard*link*enquiry*subroutine*for*accessing*the   S01332
0418 C*****EMCONPF*record*for*the*upper*link*enquiry.                     S01332
0418 C*****Indicators*used                                                S01332
0418 C*****80**on*-*chain*fail/invalid*record                             S01332
0723 C***********EMUPS2    BEGSR                           *** EMUPS2 *** S01332
0724 C***********                                                         S01332
0725 C***********          MOVELPGN2DX    PGN2                            S01332
0725 C***********          MOVEL'1'       PGL1                            S01332
0726 C***********EMUPKY    CHAINEMCUP                80                   S01332
0725 C**N80******RECI      COMP 'D'                  8080                 S01332
0727 C***********                                                         S01332
0728 C***********          ENDSR                                          S01332
0347 C***********                                                         S01332
0492 C********************************************************************
0493 C**
0494 C**   CUSTS1 SR. - TO VALIDATE CUSN ENTERED          ** CUSTS1 SR*
0495 C****************-*CALLED*FROM*MAIN*PROCESSING                       S01332
0495 C**              - CALLED FROM DETSR                                 S01332
0496 C**    CALLS SR - ZERO,RETSR
0347 C**
0730 C********************************************************************
0497 C     CUSTS1        BEGSR
0347 C**
0371 C**  COMPARE CUSTOMER NUM/SNM TO BLANKS AND TO THE LAST NUM/SNM ENTRD
      *                                                                   075353
     C     SNUMI         IFEQ      *BLANKS                                                     07535
     C     SNUMO         ANDNE     *BLANKS                                                     07535
     C                   MOVE      SNUMO         SNUMI                                         07535
     C                   ENDIF                                                                 07535
      *                                                                   075353
0372 C     SNUMI         COMP      *BLANKS                                41
0375 C**  CLEAR ERROR MESSAGE FIELD, CLEAR DETAILS AND SET TIME
0376 C                   MOVE      *BLANKS       ERMSG            79
0378 C                   SETON                                        89
0378 C***31*****           SETOF                     89                                       253255
0379 C                   SETOFF                                       30
0380 C*****                EXSR ZERO                                      S01129
0381 C**  BLANK INPUT ERROR
0382 C***41N44***          MOVELMSG,1     ERMSG                           S01332
0382 C***41*44***          MOVELMSG,8     ERMSG                           S01332
     C   41              MOVEL     MSG(8)        ERMSG                                         S0133
0383 C***41**              GOTO NOCHN                      ** GOTO NOCHN
     C   41              SETOFF                                       89                       S0112
     C   41              GOTO      ENDCUS                                                      S0112
0380 C                   EXSR      ZERO                                                        S0112
0384 C**                                                                **
0385 C**   CUSTVAL RTN.  TO EVALUATE WHETHER NUMBER/SHORTNAME ENTERED   **
0386 C*******************29 ON IF SHORTNAME, 30 ON IF CUSTNUM           **S01129
0386 C**                 32 ON IF SHORTNAME, 30 ON IF CUSTNUM           **S01129
0387 C**                                                                **
0388 C**
0389 C** CHECK TO SEE IF MORE THAN 6 CHARS ENTERED
0390 C****       SCSNMB    COMP *BLANK               2929  ON IF NOT BLANKS01129
0390 C     SCSNMB        COMP      *BLANK                             3232      ON IF NOT BLANKS0112
0391 C**
0392 C** IF BLANK, CHECK FIRST 6 CHARS NUMERIC
0390 C****       *IN29     IFEQ '0'                                    ANKS01129
0390 C     *IN32         IFEQ      '0'                                                      ANKS0112
0393 C                   MOVE      SCSNMA        WORK3             6 0
0394 C                   MOVE      WORK3         WORK4             6
0395 C****       WORK4     COMP SCSNMA               292930               S01129
0395 C     WORK4         COMP      SCSNMA                             323230                   S0112
0390 C                   END                                                                ANK
0396 C***********                                                         S01332
0397 C*****IF*S/NAME*GET*CLINT*REC.                                       S01332
0398 C***********                                                         S01332
0390 C****       *IN29     IFEQ '1'                                    ANKS01129
0390 C************IN32     IFEQ '1'                                 S01129S01332
0399 C***********SNUMI     CHAINSNAME                49                   S01332
0390 C************IN49     IFEQ '0'                                    ANKS01332
0400 C***********          MOVELCNMB      CNUM                            S01332
0422 C***********          MOVELCRNMS     CRNM                            S01332
     C***********                                                   S01128S01332
     C***ADD*SHORT*NAME                                             S01128S01332
     C***********                                                   S01128S01332
     C***********          MOVELCSNM      SHRTNM 10                 S01128S01332
     C***********          MOVELCNMB      CUSNO                     S01128S01332
     C***********                                                   E10855S01332
     C****CORRECT*TOWN*NAME*AND*PARENT*FOR*S/NAME*REQUEST           E10855S01332
     C***********                                                   E10855S01332
0401 C****                     MOVELCTWN      CTWN                        E10855
     C***********          MOVELCTWNS     CTWN                      E10855S01332
     C***********          MOVELCPRNS     CPRN                      E81176S01332
     C***********                                                   E10855S01332
0390 C***********          END                                         ANKS01332
0422 C***49******          MOVELMSG,11    ERMSG                           S01332
0390 C***********          END                                         ANKS01332
0409 C***********                                                         S01332
0410 C*****IF*CUST*NO.*-*CHECK*IT*EXISTS*ON*CLINT                         S01332
0411 C***********                                                         S01332
0390 C************IN30     IFEQ '1'                                    ANKS01332
0412 C***********          MOVE 'A'       RCDT                            S01332
0413 C***********          MOVE WORK3     CNUM                            S01332
0414 C***********CLKEY     CHAINCLINT                49                   S01332
     C***********                                                   S01311S01332
     C***CUSTOMER*INVALID*IF*HAS*BEEN*DELETED                       S01311S01332
     C************IN49     IFEQ '0'                                 S01311S01332
     C***********CHTP      ANDEQ'D'                                 S01311S01332
     C***********          SETON                     49             S01311S01332
     C***********          END                                      S01311S01332
0422 C***49******          MOVELMSG,10    ERMSG                           S01332
0390 C***********          END                                         ANKS01332
     C                   MOVEL     SNUMI         CKEY                                          S0133
     C***********          CALL 'AOCUSTR0'PLIST1                   S01332 CSD007
     C                   CALL      'AOCUSTR2'    PLIST1                                        CSD00
      *                                                                   CSD007
      ** If CSD007 is on, allow processing of a closed record (return     CSD007
      ** code '*NRF' and date deleted equal to zero).                     CSD007
      *                                                                   CSD007
     C                   MOVE      *OFF          *IN49
     C     CSD007        IFEQ      'Y'                                                         CSD00
     C     @RTCD         ANDEQ     '*NRF'                                                      CSD00
     C     BBDTDL        ANDEQ     *ZERO                                                       CSD00
     C     KEYSTS        ANDEQ     '*CNUM  '
     C     CSD007        OREQ      'Y'
     C     @RTCD         ANDEQ     '*NRF'
     C     BBDTDL        ANDEQ     *ZERO
     C     KEYSTS        ANDEQ     '*CSHT  '
      *                                                                   CSD007
     C                   ELSE                                                                  CSD00
      *                                                                   CSD007
     C     @RTCD         IFNE      *BLANKS                                                     S0133
     C                   SETON                                        49                       S0133
     C     KEYSTS        IFEQ      '*CNUM'                                                     S0133
     C                   MOVEL     MSG(10)       ERMSG                                         S0133
     C                   ELSE                                                                  S0133
     C                   MOVEL     MSG(11)       ERMSG                                         S0133
     C                   END                                                                   S0133
     C                   ELSE                                                                  S0133
     C                   SETOFF                                       49                       S0133
     C                   END                                                                   S0133
      *                                                                   CSD007
     C                   ENDIF                                                                 CSD00
0415 C**
0416 C**   STORE CUSTOMER NAME & TOWN
0417 C**
0390 C     *IN49         IFEQ      '0'                                                      ANK
     C*                                                                   S01128
     C*  ADD SHORT NAME                                                   S01128
     C*                                                                   S01128
     C***********          MOVELCSNM      SHRTNM                    S01128S01332
     C***********          MOVELCNUM      CUSNO                     S01128S01332
     C                   MOVEL     BBCSSN        SHRTNM           10                           S0133
     C                   MOVEL     BBCUST        CUSNO                                         S0133
     C                   MOVE      BBCUST        CNUM                                          S0133
     C                   MOVE      *BLANKS       SNUMI                                         S0133
     C                   MOVEL     BBCUST        SNUMI                                         S0133
     C*                                                                   S01128
0418 C***********          MOVE CRNM      CHLNM  20                       S01332
0419 C***********          MOVE CTWN      CHLTW  10                       S01332
0418 C***********          MOVE CNUM      CNUMWF  60                      S01332
0418 C***********          MOVE CPRN      CPRNWF  60                      S01332
0418 C                   MOVE      BBCRNM        CHLNM            20                           S0133
0419 C                   MOVE      BBCRTN        CHLTW            10                           S0133
0418 C**********           MOVE BBCUST    CNUMWF  60                      S01332              CSD027
0418 C                   MOVE      BBCUST        CNUMWF            6
0418 C**********           MOVE BBPCNB    CPRNWF  60                      S01332              CSD027
0418 C                   MOVE      BBPCNB        CPRNWF            6
     C*                                                                   E81176
     C*  IF PARENTS NUMBER IS ZERO - DO NOT DISPLAY                       E81176
     C*                                                                   E81176
     C********** CPRNWF    IFEQ 0                                         E81176              CSD027
     C     CPRNWF        IFEQ      *BLANKS
     C                   SETON                                        43                       E8117
     C                   ELSE                                                                  E8117
     C                   SETOFF                                       43                       E8117
     C                   END                                                                   E8117
     C*                                                                   E81176
     C/COPY WNCPYSRC,EM0301C007
0408 C                   END
     C*
0423 C     NOCHN         TAG                                                    ** TAG NOCHN
0424 C**  VALID INPUT DETAIL DISPLAY
     C  N49
0425 CANN41              SETOFF                                       44
0426 C**  INVALID INPUT DISPLAY ERRROR CODES
0427 C******   41                                                         E10855
0428 C******OR 49                SETOF                     89             E10855
     C*                                                                   E10855
     C*   ALSO ONLY DISPLAY LAST 4 LINES ON SCREEN                        E10855
     C*                                                                   E10855
     C   41                                                                                    E1085
     COR 49              DO                                                                    E1085
     C                   SETOFF                                         89                     E1085
     C***********          SETON                       4443         E10855S01332
     C                   END                                                                   E1085
0429 C**                                                               ***
0513 C     ENDCUS        ENDSR
0514 C********************************************************************
0429 C**                                                               ***
0492 C********************************************************************
0493 C**
0494 C**   CURRS1 SR. - TO VALIDATE CURRENCY ENTERED      ** CURRS1 SR*
0495 C****************-*CALLED*FROM*MAIN*PROCESSING                       S01332
0495 C**              - CALLED FROM DETSR                                 S01332
0496 C**
0497 C     CURRS1        BEGSR
0429 C**                                                               ***
     C*****VALIDATE*THE*CURRENCY*IF*ENTERED                               S01332
     C***********          MOVE SCCYI     CCY                             S01332
     C***********          MOVEL'20      'CURKEY                          S01332
     C***********          MOVE '1'       CURKEY                          S01332
     C***        CURKEY    CHAINTABLE                82    ON NOT THERE
     C***********CURKEY    CHAINTABEM                82    ON NOT THS01129S01332
     C***********          MOVE CCNM      CCNMWF                          S01332
     C**N12N82***          SETON                     82    ON - DELETED   S01332
     C***********                                                         S01332
     C*****INVALID*INPUT*DISPLAY*ERROR*CODE                               S01332
     C***********                                                         S01332
     C************IN82     IFEQ '1'                                       S01332
     C**N49******          MOVELMSG,12    ERMSG                     S01129S01332
     C***********          SETOF                     8982                 S01332
     C***********          ELSE                                           S01332
     C***********                                                         S01332
     C*****VALID*INPUT*DETAIL*DISPLAY                                     S01332
     C**N49N41***          SETOF                     44             S01129S01332
     C***********                                                         S01332
     C***********          END                                            S01332
     C***********                                                         S01332
     C***********          MOVE *BLANKS   CURKEY                          S01332
     C*                                                                   S01332
     C                   SETON                                        89                       S0133
     C*                                                                   S01332
     C**   VALIDATE CURRENCY                                              S01332
     C                   MOVE      SCCYI         @CYCD                                         S0133
     C                   CALL      'AOCURRR0'    PLIST2                                        S0133
     C     @RTCD         IFNE      *BLANKS                                                     S0133
     C                   MOVEL     MSG(12)       ERMSG                                         S0133
     C                   SETOFF                                       89                       S0133
     C                   ELSE                                                                  S0133
     C                   MOVE      A6CYNM        CCNMWF                                        S0133
     C                   MOVE      A6CYCD        SCCYI                                         S0133
     C                   END                                                                   S0133
     C**
     C**
     C     ENDCUR        ENDSR
     C********************************************************************
     C**                                                               ***
     C********************************************************************
     C**
     C**   PARENT SR. - TO PROCESS ALL PACUS RECORDS
     C**                FOR A PARENT
     C**    CALLED FROM MAINSR
     C**    CALLS SR -  CHILD
     C**
     C     PARENT        BEGSR
     C                   MOVEL     'Parent  '    CUSPAR            8
     C***********RECIL     IFEQ 'D'                                 E21212S01314
     C                   MOVE      CNUM          CHILDN            6                           S0131
     C     CHILDN        CHAIN     EMCEJ                              57                       S0131
     C***********CNUM      CHAINEMCEJ                57             S01128S01314
      *                                                                   083490
      ** Record found    *IN57 = *OFF                                     083490
      **  =  No LIMITS specified for this Customer, or                    083490
      **  =  LIMITS specified for this Customer at System Level           083490
      *                                                                   083490
      ** If record NOT found    *IN57 = *ON                               083490
      ** =====================                                            083490
      **  =  Limits specified for this Customer at the level of           083490
      **     COMPANY  or BRANCH.                                          083490
      ** A) Try again using the same access path but select COMPANY       083490
      **      LIMITS  xxLEVL  using EMCEJ2 *LF.                           083490
     C     *IN57         IFEQ      *ON                                                         08349
     C     CHILDN        CHAIN     EMCEJ2                             57                       08349
     C                   ENDIF                                                                 08349
      ** B) If no System, or Company limits, access BRANCH LIMITs         083490
      **       xxLEVL  using EMCEJ3 *LF.                                  083490
     C     *IN57         IFEQ      *ON                                                         08349
     C     CHILDN        CHAIN     EMCEJ3                             57                       08349
     C                   ENDIF                                                                 08349
      *                                                                   083490
     C     *IN57         IFEQ      '0'                                                         S0112
     C***********MSFX      IFNE 0                                   S01129S01332
     C     BUMSFX        IFNE      0                                                           S0133
     C     FLED          IFGT      RUND                                                        S0112
     C     FLED          OREQ      0                                                           S0112
     C***********FLAM      DIV  100       LMG,1     H              S01128 E16005
     C***********          MULT FPER      LMG,1                    S01128 E16005
     C     FPER          DIV(H)    100           FPERCT            3 2                         E1600
     C     FLAM          MULT(H)   FPERCT        LMG(1)                                        E1600
     C*                                                                   E21293
     C* STORE PARENT GRANTED LIMIT                                        E21293
     C                   Z-ADD     LMG(1)        PLMG1            11 0                         E2129
     C*                                                                   E18716
     C* GRANTED LIMITS HELD IN BASE CCY - CONVERT TO EM CCY.              E18716
     C*                                                                   E18716
     C***********LCCY      IFNE BCYL                                E18716S01332
     C     BUCYCD        IFNE      BCYL                                                        S0133
     C*                                                                   E18716
     C     LMG(1)        IFNE      0                                                           E1871
     C***********BSMDIN    IFEQ 0                                   E18716S01332
     C     BSMDIN        IFEQ      'D'                                                         S0133
     C     LMG(1)        DIV       BSSPOT        LMG(1)                                        E1871
     C                   ELSE                                                                  E1871
     C     LMG(1)        MULT      BSSPOT        LMG(1)                                        E1871
     C                   END                                                                   E1871
     C***********EMMDIN    IFEQ 0                                   E18716S01332
     C     EMMDIN        IFEQ      'D'                                                         S0133
     C     LMG(1)        MULT      EMSPOT        LMG(1)                                        E1871
     C                   ELSE                                                                  E1871
     C     LMG(1)        DIV       EMSPOT        LMG(1)                                        E1871
     C                   END                                                                   E1871
     C                   END                                                                   E1871
     C                   END                                                                   E1871
     C*                                                                   E18716
     C                   END                                                                   S0112
     C                   END                                                                   S0112
     C***********MSMM      IFNE 0                                   S01129S01332
     C     BUMSMM        IFNE      0                                                           S0133
     C********** LLED      IFGT RUND                               S01128 109454
     C********** LLED      OREQ 0                                  S01128 109454
     C***********DZMMED    IFGT RUND                                109454133355
     C***********DZMMED    OREQ 0                                   109454133355
     C     LLED          IFGT      RUND                                                        13335
     C     LLED          OREQ      0                                                           13335
     C***********LLAM      DIV  100       LMG,2     H              S01128 E16005
     C***********          MULT MPER      LMG,2                    S01128 E16005
     C     MPER          DIV(H)    100           MPERCT            3 2                         E1600
     C********** LLAM      MULT MPERCT    LMG,2     H              E16005 109454
     C***********DZMMAM    MULT MPERCT    LMG,2     H               109454133355
     C     LLAM          MULT(H)   MPERCT        LMG(2)                                        13335
     C*                                                                   E21293
     C* STORE PARENT GRANTED LIMIT                                        E21293
     C                   Z-ADD     LMG(2)        PLMG2            11 0                         E2129
     C*                                                                   E18716
     C* GRANTED LIMITS HELD IN BASE CCY - CONVERT TO EM CCY.              E18716
     C*                                                                   E18716
     C***********LCCY      IFNE BCYL                                E18716S01332
     C     BUCYCD        IFNE      BCYL                                                        S0133
     C*                                                                   E18716
     C     LMG(2)        IFNE      0                                                           E1871
     C***********BSMDIN    IFEQ 0                                   E18716S01332
     C     BSMDIN        IFEQ      'D'                                                         S0133
     C     LMG(2)        DIV       BSSPOT        LMG(2)                                        E1871
     C                   ELSE                                                                  E1871
     C     LMG(2)        MULT      BSSPOT        LMG(2)                                        E1871
     C                   END                                                                   E1871
     C***********EMMDIN    IFEQ 0                                   E18716S01332
     C     EMMDIN        IFEQ      'D'                                                         S0133
     C     LMG(2)        MULT      EMSPOT        LMG(2)                                        E1871
     C                   ELSE                                                                  E1871
     C     LMG(2)        DIV       EMSPOT        LMG(2)                                        E1871
     C                   END                                                                   E1871
     C                   END                                                                   E1871
     C                   END                                                                   E1871
     C*                                                                   E18716
     C                   END                                                                   S0112
     C                   END                                                                   S0112
     C                   END                                                                   S0112
     C**********           END                                      E21212S01314
     C     BUMSFR        IFNE      0                                                           S0133
     C                   Z-ADD     DZFRLA        LMG(3)                                        S0133
     C                   Z-ADD     DZFRLA        PLMG3            11 0                         S0133
     C     BUCYCD        IFNE      BCYL                                                        09427
     C*                                                                   094276
     C     LMG(3)        IFNE      0                                                           09427
     C     BSMDIN        IFEQ      'D'                                                         09427
     C     LMG(3)        DIV       BSSPOT        LMG(3)                                        09427
     C                   ELSE                                                                  09427
     C     LMG(3)        MULT      BSSPOT        LMG(3)                                        09427
     C                   END                                                                   09427
     C     EMMDIN        IFEQ      'D'                                                         09427
     C     LMG(3)        MULT      EMSPOT        LMG(3)                                        09427
     C                   ELSE                                                                  09427
     C     LMG(3)        DIV       EMSPOT        LMG(3)                                        09427
     C                   END                                                                   09427
     C                   END                                                                   09427
     C                   END                                                                   09427
     C                   END                                                                   S0133
     C***********MSLN      IFNE 0                                   S01129S01332
     C     BUMSLN        IFNE      0                                                           S0133
     C                   DIV(H)    1000          MLEG                                          S0112
     C***                  Z-ADDMLEG      LMG,3                           S01129
     C                   Z-ADD     MLEG          LMG(4)                                        S0112
     C                   END                                                                   S0112
     C***********MSRE      IFNE 0                                   S01129S01332
     C     BUMSRT        IFNE      0                                                           S0133
     C                   DIV(H)    1000          MREG                                          S0112
     C***                  Z-ADDMREG      LMG,4                           S01129
     C                   Z-ADD     MREG          LMG(5)                                        S0112
     C                   END                                                                   S0112
     C     BUMSIR        IFNE      0                                                           S0133
     C                   Z-ADD     DZIRLM        LMG(6)                                        S0133
     C                   Z-ADD     DZIRLM        PLMG6            11 0                         S0133
     C     BUCYCD        IFNE      BCYL                                                        09427
     C*                                                                   094276
     C     LMG(6)        IFNE      0                                                           09427
     C     BSMDIN        IFEQ      'D'                                                         09427
     C     LMG(6)        DIV       BSSPOT        LMG(6)                                        09427
     C                   ELSE                                                                  09427
     C     LMG(6)        MULT      BSSPOT        LMG(6)                                        09427
     C                   END                                                                   09427
     C     EMMDIN        IFEQ      'D'                                                         09427
     C     LMG(6)        MULT      EMSPOT        LMG(6)                                        09427
     C                   ELSE                                                                  09427
     C     LMG(6)        DIV       EMSPOT        LMG(6)                                        09427
     C                   END                                                                   09427
     C                   END                                                                   09427
     C                   END                                                                   09427
     C                   END                                                                   S0133
     C     CNUM          SETLL     PACUS
0501 C                   READ      PACUS                                  72
0511 C     CNUM          COMP      CPAR                                   71
0508 C     TAG1          TAG
0509 C   71              EXSR      CHILD
0510 C   71              READ      PACUS                                  72
0511 C   71CNUM          COMP      CPAR                                   71
     C   71
0512 CANN72              GOTO      TAG1                                         ** TAG1 TAG
0281 C                   EXSR      STLIMS                                                      S0112
0513 C     ENDPAR        ENDSR
0514 C********************************************************************
0429 C**                                                               ***
0492 C********************************************************************
0493 C**
0494 C**   CONVAM SR. - TO CONVERT THE OUTPUT AMOUNTS INTO REQUESTED
0495 C**                CURRENCY
0496 C**    CALLED FROM MAINSR
0496 C**
0497 C     CONVAM        BEGSR
     C**
     C**   CONVERT THE AMOUNT FROM EM CCY TO BASE CCY, THEN TO REQUESTED
     C**   CCY
     C**   WHEN CONVERTING FROM GIVEN CURRENCY (I.E EM LIMIT CURRENCY)    E15671
     C**   TO BASE CURRENCY , IF 'MDIN' INDICATOR IS 'M' MULTIPLY BY      E15671
     C**   EMSPOT , ELSE DIVIDE BY EMSPOT.                                E15671
     C**
     C***********XPA       DIV  EMSPOT    XPO                             E15671
     C***********XPO       MULT SPOT      XPO       H                     E12080
     C**
     C***********OBA       DIV  EMSPOT    OBO                             E15671
     C***********OBO       MULT SPOT      OBO       H                     E12080
     C**
     C***        LM        DIV  EMSPOT    LM                              S01129
     C***        LM        MULT SPOT      LM        H                     S01129
     C***********LIM       DIV  EMSPOT    LIM                      S01129 E15671
     C***********LIM       MULT SPOT      LIM       H              S01129 E15671
     C**                                                                  S01128
     C***        LMG       DIV  EMSPOT    LMG                             S01129
     C***        LMG       MULT SPOT      LMG       H                     S01129
     C***********          DO   5         Z2                       S01129 E15671
     C***********LMG,Z2    IFNE 0                                  S01129 E15671
     C***********LMG,Z2    DIV  EMSPOT    LMG,Z2                   S01129 E15671
     C***********LMG,Z2    MULT SPOT      LMG,Z2    H              S01129 E15671
     C***********          END                                     S01129 E15671
     C***********          END                                     S01129 E15671
     C**                                                                  S01129
     C***        MBCL      DIV  EMSPOT    MBCL                            S01129
     C***        MBCL      MULT SPOT      MBCL      H                     S01129
     C**                                                                  S01129
     C***        MSTL      DIV  EMSPOT    MSTL                            S01129
     C***        MSTL      MULT SPOT      MSTL      H                     S01129
     C**                                                                  S01129
     C***        MFFL      DIV  EMSPOT    MFFL                            S01129
     C***        MFFL      MULT SPOT      MFFL      H                     S01129
     C**
     C***********MOAL      DIV  EMSPOT    MOAL                            E15671
     C***********MOAL      MULT SPOT      MOAL      H                     E12080
     C**
     C***********EMMDIN    IFEQ 1                                   E15671S01332
     C     EMMDIN        IFEQ      'M'                                                         S0133
     C     XPA           MULT(H)   EMSPOT        XPO                                           E1567
     C     OBA           MULT(H)   EMSPOT        OBO                                           E1567
     C     LIM           MULT(H)   EMSPOT        LIM                                           E1567
     C                   DO        5             Z2                                            E1576
     C     LMG(Z2)       IFNE      0                                                           E1567
     C     LMG(Z2)       MULT(H)   EMSPOT        LMG(Z2)                                       E1567
     C                   END                                                                   E1567
     C                   END                                                                   E1567
     C     MOAL          MULT(H)   EMSPOT        MOAL                                          E1567
     C**                                                                  E15671
     C                   ELSE                                                                  E1567
     C     XPA           DIV(H)    EMSPOT        XPO                                           E1567
     C     OBA           DIV(H)    EMSPOT        OBO                                           E1567
     C     LIM           DIV(H)    EMSPOT        LIM                                           E1567
     C                   DO        5             Z2                                            E1567
     C     LMG(Z2)       IFNE      0                                                           E1567
     C     LMG(Z2)       DIV(H)    EMSPOT        LMG(Z2)                                       E1567
     C                   END                                                                   E1567
     C                   END                                                                   E1567
     C     MOAL          DIV(H)    EMSPOT        MOAL                                          E1567
     C                   END                                                                   E1567
     C**                                                                  E15671
     C**INDICATOR*=*0*-->*DIVIDE*;*INDICATOR*=*1*-->*MULTIPLY*     E12080 E15671
     C**   WHEN CONVERTING FROM BASE CURRENCY TO REQUESTED CURRENCY       E15671
     C**   IF 'MDIN' INDICATOR IS 'M' DIVIDE BY SPOT , ELSE MULTIPLY      E15671
     C**   BY SPOT.                                                       E15671
     C***********MDIN      IFEQ 1                                  E12080 E15671
     C***********MDIN      IFEQ 0                                   E15671S01332
     C***********XPO       MULT SPOT      XPO       H               E12080S01332
     C***********OBO       MULT SPOT      OBO       H               E12080S01332
     C***********LMG       MULT SPOT      LMG       H               E12080S01332
     C***********MBCL      MULT SPOT      MBCL      H              E12080 E15671
     C***********MSTL      MULT SPOT      MSTL      H               E12080S01332
     C***********MFFL      MULT SPOT      MFFL      H              E12080 E15671
     C***********LIM       MULT SPOT      LIM       H               E15671S01332
     C***********MOAL      MULT SPOT      MOAL      H               E12080S01332
     C     A6MDIN        IFEQ      'D'                                                         S0133
     C     XPO           MULT(H)   A6SPRT        XPO                                           S0133
     C     OBO           MULT(H)   A6SPRT        OBO                                           S0133
     C     LMG           MULT(H)   A6SPRT        LMG                                           S0133
     C     MSTL          MULT(H)   A6SPRT        MSTL                                          S0133
     C     LIM           MULT(H)   A6SPRT        LIM                                           S0133
     C     MOAL          MULT(H)   A6SPRT        MOAL                                          S0133
     C**                                                                  E12080
     C                   ELSE                                                                  E1208
     C***********XPO       DIV  SPOT      XPO       H               E12080S01332
     C***********OBO       DIV  SPOT      OBO       H               E12080S01332
     C***********LMG       DIV  SPOT      LMG       H               E12080S01332
     C***********MBCL      DIV  SPOT      MBCL      H              E12080 E15671
     C***********MSTL      DIV  SPOT      MSTL      H               E12080S01332
     C***********MFFL      DIV  SPOT      MFFL      H              E12080 E15671
     C***********LIM       DIV  SPOT      LIM       H               E15671S01332
     C***********MOAL      DIV  SPOT      MOAL      H               E12080S01332
     C     XPO           DIV(H)    A6SPRT        XPO                                           S0133
     C     OBO           DIV(H)    A6SPRT        OBO                                           S0133
     C     LMG           DIV(H)    A6SPRT        LMG                                           S0133
     C     MSTL          DIV(H)    A6SPRT        MSTL                                          S0133
     C     LIM           DIV(H)    A6SPRT        LIM                                           S0133
     C     MOAL          DIV(H)    A6SPRT        MOAL                                          S0133
     C                   END                                                                   E1208
0513 C                   ENDSR
0514 C********************************************************************
0429 C**                                                               ***
0515 C********************************************************************
0516 C**
0517 C**   CLDLON SR. - TO PROCESS A CHILD OR
0518 C**                LONER ENQUIRY
0496 C**    CALLED FROM MAINSR
0496 C**    CALLS SR -  RETSR,EXPRD,NEGEXP
0519 C**
0520 C     CLDLON        BEGSR
0521 C**
0522 C**   IF CUSTOMER IS A CHILD, GET PARENT
0523 C**
0524 C**
0525 C**   STORE CHILD NUMBER FOR EMCEJ CHAIN                             S01128
0526 C**
0527 C**********           MOVE CNUM      CUSNUM  60                                          CSD027
0527 C                   MOVE      CNUM          CUSNUM            6
0528 C**N53******          MOVE 'A'       RCDT                            S01332
0529 C**N53******          MOVE CPRN      CNUM                            S01332
0530 C**N53******CLKEY     CHAINCLINT                99                   S01332
0530 C************IN99     IFEQ '1'                                       S01332
0531 C***********          MOVE 'CLINT'   DBFILE                          S01332
0532 C***********          MOVE CLKEYA    DBKEY                           S01332
     C     *IN53         IFEQ      '0'                                                         S0133
     C                   MOVE      *BLANKS       CKEY                                          05642
     C                   MOVEL     BBPCNB        CKEY                                          S0133
     C***********          CALL 'AOCUSTR0'PLIST1                   S01332 CSD007
     C                   CALL      'AOCUSTR2'    PLIST1                                        CSD00
      *                                                                   CSD007
      ** If CSD007 is on, allow processing of a closed record (return     CSD007
      ** code '*NRF' and date deleted equal to zero).                     CSD007
      *                                                                   CSD007
     C     CSD007        IFEQ      'Y'                                                         CSD00
     C     @RTCD         ANDEQ     '*NRF'                                                      CSD00
     C     BBDTDL        ANDEQ     *ZERO                                                       CSD00
     C     KEYSTS        ANDEQ     '*CNUM  '
     C     CSD007        OREQ      'Y'
     C     @RTCD         ANDEQ     '*NRF'
     C     BBDTDL        ANDEQ     *ZERO
     C     KEYSTS        ANDEQ     '*CSHT  '
      *                                                                   CSD007
     C                   ELSE                                                                  CSD00
      *                                                                   CSD007
     C     @RTCD         IFNE      *BLANKS                                                     S0133
     C                   MOVE      'SDCUSTPD'    DBFILE                                        S0133
     C                   MOVE      CKEY          DBKEY                                         S0133
0533 C                   MOVE      'EM0301'      DBPGM
0534 C                   Z-ADD     03            DBASE                          DATABASE 03
0535 C                   SETON                                        LRU7U8
0536 C                   EXSR      RETSR
0536 C                   END
      *                                                                   CSD007
     C                   ENDIF                                                                 CSD00
      *                                                                   CSD007
     C                   END                                                                   S0133
0537 C                   MOVE      'Customer'    CUSPAR
0540 C                   EXSR      EXPRD
0541 C                   EXSR      NEGEXP
0281 C                   EXSR      STLIMS                                                      S0112
0542 C     ENDCON        ENDSR
0543 C********************************************************************
0544 C********************************************************************
0545 C**
0546 C**    CHILD SR. - TO PROCESS ALL CHILD NUMBERS ON A PACUS REC.
0496 C**    CALLED FROM PARENT SR
0496 C**    CALLS SR -  EXPRD,NEGEXP
0547 C**
0548 C**
0549 C     CHILD         BEGSR
  XX C                   MOVE      CNUMP         CUSNUM
0554 C                   EXSR      EXPRD
0557 C                   EXSR      NEGEXP
0558 C                   ENDSR
0559 C********************************************************************
0560 C/EJECT
0561 C********************************************************************
0562 C**
0563 C**   EXPRD SR. - READS EMCEJ RECS                                   S01128
0564 C**               ACCESS EMCEJ FOR A CUSTOMER                     .  S01128
0565 C**                    (CALLED PARENT & CLDLON RTN'S)
0566 C**
0567 C     EXPRD         BEGSR
0568 C*********************MOVE CUSNUM    CHILDN  60       SET LOWER LIMITS01314
0568 C                   MOVE      CUSNUM        CHILDN            6            SET LOWER LIMITS0131
0569 C     CHILDN        CHAIN     EMCEJ                              57        ON EMDEX       S0112
      *                                                                   083490
      ** Record found    *IN57 = *OFF                                     083490
      **  =  No LIMITS specified for this Customer, or                    083490
      **  =  LIMITS specified for this Customer at System Level           083490
      *                                                                   083490
      ** If record NOT found    *IN57 = *ON                               083490
      ** =====================                                            083490
      **  =  Limits specified for this Customer at the level of           083490
      **     COMPANY  or BRANCH.                                          083490
      ** A) Try again using the same access path but select COMPANY       083490
      **      LIMITS  xxLEVL  using EMCEJ2 *LF.                           083490
     C     *IN57         IFEQ      *ON                                                         08349
     C     CHILDN        CHAIN     EMCEJ2                             57                       08349
     C                   ENDIF                                                                 08349
      ** B) If no System, or Company limits, access BRANCH LIMITs         083490
      **       xxLEVL  using EMCEJ3 *LF.                                  083490
     C     *IN57         IFEQ      *ON                                                         08349
     C     CHILDN        CHAIN     EMCEJ3                             57                       08349
     C                   ENDIF                                                                 08349
      *                                                                   083490
0570 C  N57              EXSR      ACCARR
0571 C                   ENDSR
0572 C********************************************************************
0574 C**                                                                  E21212
0575 C**   LIMCH  SR. - CHAINS TO THE LIMITS FILE.                        E21212
0578 C**                                                                  E21212
0567 C     LIMCH         BEGSR                                                                 E2121
     C***********CNUM      CHAINLIMIT                70             E21212S01314
      *                                                                   083490
     C                   MOVEL     CNUM          @KEY1                                         S0131
      *                                                                   083490
     C                   CALL      'AOCLLMR0'                                                  S0131
     C                   PARM      *BLANK        @RTCD             7                           S0131
     C                   PARM      '*KEY    '    @OPTN             7                           S0131
     C                   PARM                    @KEY1             6                           08349
     C                   PARM      'S'           @KEY2             1                           10945
     C                   PARM      'SYS'         @KEY3             3                           10945
     C     SDCLLM        PARM      SDCLLM        DSFDY                          = 200A         08349
      *                                                                   083490
     C******************** PARM           @KEY1  10                S01314 083490
     C**********           PARM 'S'       @KEY2   3                S01314 109454
     C**********           PARM 'SYS'     @KEY3   1                S01314 109454
     C***********SDCLLM*** PARM SDCLLM    DSSDY                    S01314 083490
0571 C                   ENDSR                                                                 E2121
0578 C**                                                                  E21212
0573 C********************************************************************
0574 C**
0575 C**   ACCARR SR. - ACCUMULATES ARRAYS OF EXPOSURE AND
0576 C**                OFF-SETTING BALANCE FROM EMCEJ                    S01128
0577 C**               (CALLED FROM EXPRD)
0578 C**
0579 C     ACCARR        BEGSR
     C/COPY WNCPYSRC,EM0301C001
     C*
     C* CHANGE ACCUMULATION FIELDS TO ZERO IF MODULE NOT IN SYSTEM
     C*
     C***********MSFX      IFEQ 0                                   S01129S01332
     C     BUMSFX        IFEQ      0                                                           S0133
     C                   Z-ADD     0             MFXL
     C                   Z-ADD     0             MFXE                                          S0112
     C                   Z-ADD     0             MFXB                                          S0112
     C                   END                                                                   S0112
     C***********MSMM      IFEQ 0                                   S01129S01332
     C     BUMSMM        IFEQ      0                                                           S0133
     C                   Z-ADD     0             MMME                                          S0112
     C                   Z-ADD     0             MMMB                                          S0112
     C                   Z-ADD     0             MMML                                          S0112
     C                   END                                                                   S0112
     C     BUMSFR        IFEQ      0                                                           S0133
     C                   Z-ADD     0             MFRL                                          S0133
     C                   Z-ADD     0             MFRE                                          S0133
     C                   Z-ADD     0             MFRO                                          S0133
     C                   END                                                                   S0133
     C***********MSLN      IFEQ 0                                   S01129S01332
     C     BUMSLN        IFEQ      0                                                           S0133
     C                   Z-ADD     0             MLAE                                          S0112
     C                   Z-ADD     0             MLAB                                          S0112
     C                   Z-ADD     0             MLEE                                          S0112
     C                   Z-ADD     0             MLEB                                          S0112
     C                   Z-ADD     0             MLEL                                          S0112
     C                   Z-ADD     0             MLEG                                          S0112
     C                   END                                                                   S0112
     C***********MSRE      IFEQ 0                                   S01129S01332
     C     BUMSRT        IFEQ      0                                                           S0133
     C                   Z-ADD     0             MREE                                          S0112
     C                   Z-ADD     0             MREB                                          S0112
     C                   Z-ADD     0             MREL                                          S0112
     C                   Z-ADD     0             MREG                                          S0112
     C                   END                                                                   S0112
     C     BUMSIR        IFEQ      0                                                           S0133
     C                   Z-ADD     0             MIRL                                          S0133
     C                   Z-ADD     0             MIRE                                          S0133
     C                   Z-ADD     0             MIRO                                          S0133
     C                   END                                                                   S0133
     C***********MSSC      IFEQ 0                                   S01129S01332
     C     BUMSSC        IFEQ      0                                                           S0133
     C                   Z-ADD     0             MSCE                                          S0112
     C                   Z-ADD     0             MSCL                                          S0112
     C                   END                                                                   S0112
     C***********MSSI      IFEQ 0                                   S01129S01332
     C     BUMSSI        IFEQ      0                                                           S0133
     C                   Z-ADD     0             MSIE                                          S0112
     C                   Z-ADD     0             MSLI                                          S0112
     C                   END                                                                   S0112
     C***********MSSP      IFEQ 0                                   S01129S01332
     C     BUMSSP        IFEQ      0                                                           S0133
     C                   Z-ADD     0             MSPO                                          S0112
     C                   END                                                                   S0112
     C***********MSFI      IFEQ 0                                   S01129E22634
     C***********          Z-ADD0         MFFL                      S01129E22634
     C***********          END                                      S01129E22634
     C***********MSLC      IFEQ 0                                  S01129 S01196
     C***********          Z-ADD0         MBCL                     S01129 S01196
     C***********          END                                     S01129 S01196
     C***********MSFI      IFEQ 0                                   S01314S01332
     C***********          Z-ADD0         MFFL                      S01314S01332
     C***********          END                                      S01314S01332
     C***********MSIF      IFEQ 0                                   S01314S01332
     C***********          Z-ADD0         MIFL                      S01314S01332
     C***********          END                                      S01314S01332
     C     BUMSFU        IFEQ      0                                                           S0133
     C                   Z-ADD     0             MFUL                                          S0133
     C                   Z-ADD     0             MFUE                                          S0133
     C                   Z-ADD     0             MFUO                                          S0133
     C                   END                                                                   S0133
     C     BUMSOP        IFEQ      0                                                           S0133
     C                   Z-ADD     0             MOPL                                          S0133
     C                   Z-ADD     0             MOPE                                          S0133
     C                   Z-ADD     0             MOPO                                          S0133
     C                   END                                                                   S0133
     C     BUMSTF        IFEQ      0                                                           CTI00
     C                   Z-ADD     0             TFEX                                          CTI00
     C                   Z-ADD     0             TFGR                                          CTI00
     C                   Z-ADD     0             TFOF                                          CTI00
     C                   END                                                                   CTI00
     C*                                                                   CTI002
0584 C***                  ADD  MLEE      XPA,3
     C***                  ADD  MLAE      XPA,3                           S01129
0585 C***                  ADD  MLEB      OBA,3                           S01129
     C***                  ADD  MLAB      OBA,3                           S01129
0586 C***                  ADD  MREE      XPA,4                           S01129
0587 C***                  ADD  MREB      OBA,4                           S01129
     C*                                                                   E28697
     C**  IF PROCESSING A PARENT, CHECK FOR NEGATIVE EXPOSURES BEFORE     E28697
     C**  ADDING INTO TOTALS FOR PARENT                                   E28697
     C**  IE. IF EXPOSURE IS POSITIVE, ADD IT TO EXPOSURE TOTAL           E28697
     C**      IF EXPOSURE IS NEGATIVE, SUBTRACT IT FROM OFF-SETTING       E28697
     C**      BALANCE TOTAL                                               E28697
     C     *IN52         IFEQ      '1'                                                         E2869
     C     MFXE          IFGT      0                                                           E2869
     C                   ADD       MFXE          XPA(1)                                        E2869
     C                   ELSE                                                                  E2869
     C                   SUB       MFXE          OBA(1)                                        E2869
     C                   END                                                                   E2869
     C                   ADD       MFXB          OBA(1)                                        E2869
     C     MMME          IFGT      0                                                           E2869
     C                   ADD       MMME          XPA(2)                                        E2869
     C                   ELSE                                                                  E2869
     C                   SUB       MMME          OBA(2)                                        E2869
     C                   END                                                                   E2869
     C                   ADD       MMMB          OBA(2)                                        E2869
     C     MFRE          IFGT      0                                                           E2869
     C                   ADD       MFRE          XPA(3)                                        E2869
     C                   ELSE                                                                  E2869
     C                   SUB       MFRE          OBA(3)                                        E2869
     C                   END                                                                   E2869
     C                   ADD       MFRO          OBA(3)                                        E2869
     C     MLEE          IFGT      0                                                           E2869
     C                   ADD       MLEE          XPA(4)                                        E2869
     C                   ELSE                                                                  E2869
     C                   SUB       MLEE          OBA(4)                                        E2869
     C                   END                                                                   E2869
     C                   ADD       MLEB          OBA(4)                                        E2869
     C     MLAE          IFGT      0                                                           E2869
     C                   ADD       MLAE          XPA(4)                                        E2869
     C                   ELSE                                                                  E2869
     C                   SUB       MLAE          OBA(4)                                        E2869
     C                   END                                                                   E2869
     C                   ADD       MLAB          OBA(4)                                        E2869
     C/COPY WNCPYSRC,EM0301C002
     C     MREE          IFGT      0                                                           E2869
     C                   ADD       MREE          XPA(5)                                        E2869
     C                   ELSE                                                                  E2869
     C                   SUB       MREE          OBA(5)                                        E2869
     C                   END                                                                   E2869
     C                   ADD       MREB          OBA(5)                                        E2869
     C/COPY WNCPYSRC,EM0301C003
     C     MIRE          IFGT      0                                                           E2869
     C                   ADD       MIRE          XPA(6)                                        E2869
     C                   ELSE                                                                  E2869
     C                   SUB       MIRE          OBA(6)                                        E2869
     C                   END                                                                   E2869
     C                   ADD       MIRO          OBA(6)                                        E2869
     C                   ADD       MSCE          XPA(7)                                        E2869
     C                   ADD       MSIE          XPA(8)                                        E2869
     C                   ADD       MSPO          OBA(9)                                        E2869
     C     MFUE          IFGT      0                                                           E2869
     C                   ADD       MFUE          XPA(10)                                       E2869
     C                   ELSE                                                                  E2869
     C                   SUB       MFUE          OBA(10)                                       E2869
     C                   END                                                                   E2869
     C                   ADD       MFUO          OBA(10)                                       E2869
     C     MOPE          IFGT      0                                                           E2869
     C                   ADD       MOPE          XPA(11)                                       E2869
     C                   ELSE                                                                  E2869
     C                   SUB       MOPE          OBA(11)                                       E2869
     C                   END                                                                   E2869
     C                   ADD       MOPO          OBA(11)                                       E2869
      *                                                                   CTI002
     C     TFEX          IFGT      0                                                           CTI00
     C                   ADD       TFEX          XPA(12)                                       CTI00
     C                   ELSE                                                                  CTI00
     C*                    SUB  TFEX      OBA,12                          CTI002
     C                   END                                                                   CTI00
     C                   ADD       TFOF          OBA(12)                                       CTI00
      *                                                                   CTI002
     C                   ELSE                                                                  E2869
0580 C                   ADD       MFXE          XPA(1)
0581 C                   ADD       MFXB          OBA(1)
0582 C                   ADD       MMME          XPA(2)
0583 C                   ADD       MMMB          OBA(2)
     C***********          ADD  MLEE      XPA,4                     S01129E22634
     C***********          ADD  MLAE      XPA,4                     S01129E22634
     C***********          ADD  MLEB      OBA,4                     S01129E22634
     C***********          ADD  MLAB      OBA,4                     S01129E22634
     C***********          ADD  MREE      XPA,5                     S01129E22634
     C***********          ADD  MREB      OBA,5                     S01129E22634
     C***********          ADD  MSCE      XPA,7                     S01129E22634
     C***********          ADD  MSIE      XPA,8                     S01129E22634
     C***********          ADD  MSPO      OBA,9                     S01129E22634
     C***********          ADD  MLEE      XPA,3                     E22634S01332
     C***********          ADD  MLAE      XPA,3                     E22634S01332
     C***********          ADD  MLEB      OBA,3                     E22634S01332
     C***********          ADD  MLAB      OBA,3                     E22634S01332
     C***********          ADD  MREE      XPA,4                     E22634S01332
     C***********          ADD  MREB      OBA,4                     E22634S01332
     C***********          ADD  MSCE      XPA,6                     E22634S01332
     C***********          ADD  MSIE      XPA,7                     E22634S01332
     C***********          ADD  MSPO      OBA,8                     E22634S01332
     C***********          ADD  MIFL      XPA,5               E22634S01314RT0152
     C***********          ADD  MFFL      XPA,9               E22634S01314RT0152
     C                   ADD       MFRE          XPA(3)                                        S0133
     C                   ADD       MFRO          OBA(3)                                        S0133
     C                   ADD       MLEE          XPA(4)                                        S0133
     C                   ADD       MLAE          XPA(4)                                        S0133
     C                   ADD       MLEB          OBA(4)                                        S0133
     C                   ADD       MLAB          OBA(4)                                        S0133
     C/COPY WNCPYSRC,EM0301C004
     C                   ADD       MREE          XPA(5)                                        S0133
     C                   ADD       MREB          OBA(5)                                        S0133
     C/COPY WNCPYSRC,EM0301C005
     C                   ADD       MIRE          XPA(6)                                        S0133
     C                   ADD       MIRO          OBA(6)                                        S0133
     C                   ADD       MSCE          XPA(7)                                        S0133
     C                   ADD       MSIE          XPA(8)                                        S0133
     C                   ADD       MSPO          OBA(9)                                        S0133
     C                   ADD       MFUE          XPA(10)                                       S0133
     C                   ADD       MFUO          OBA(10)                                       S0133
     C                   ADD       MOPE          XPA(11)                                       S0133
     C                   ADD       MOPO          OBA(11)                                       S0133
     C                   ADD       TFEX          XPA(12)                                       CTI00
     C                   ADD       TFOF          OBA(12)                                       CTI00
     C                   END                                                                   E2869
     C     *IN52         IFEQ      '0'                                                         S0133
     C     *IN52         OREQ      '1'                                                         S0133
     C     PLMG3         ANDEQ     0                                                           S0133
     C     BUMSFR        IFNE      0                                                           S0133
     C                   ADD       DZFRLA        LMG(3)                                        S0133
     C     BUCYCD        IFNE      BCYL                                                        09427
     C*                                                                   094276
     C     LMG(3)        IFNE      0                                                           09427
     C     BSMDIN        IFEQ      'D'                                                         09427
     C     LMG(3)        DIV       BSSPOT        LMG(3)                                        09427
     C                   ELSE                                                                  09427
     C     LMG(3)        MULT      BSSPOT        LMG(3)                                        09427
     C                   END                                                                   09427
     C     EMMDIN        IFEQ      'D'                                                         09427
     C     LMG(3)        MULT      EMSPOT        LMG(3)                                        09427
     C                   ELSE                                                                  09427
     C     LMG(3)        DIV       EMSPOT        LMG(3)                                        09427
     C                   END                                                                   09427
     C                   END                                                                   09427
     C                   END                                                                   09427
     C                   END                                                                   S0133
     C                   END                                                                   S0133
     C***********MSLN      IFNE 0                                   S01129S01332
     C     BUMSLN        IFNE      0                                                           S0133
     C                   DIV(H)    1000          MLEG                                          S0112
     C***                  ADD  MLEG      LMG,3                           S01129
     C***********          ADD  MLEG      LMG,4                     S01129E22634
     C***********          ADD  MLEG      LMG,3                     E22634S01332
     C                   ADD       MLEG          LMG(4)                                        S0133
     C                   END                                                                   S0112
     C***********MSRE      IFNE 0                                   S01129S01332
     C     BUMSRT        IFNE      0                                                           S0133
     C                   DIV(H)    1000          MREG                                          S0112
     C***                  ADD  MREG      LMG,4                           S01129
     C***********          ADD  MREG      LMG,5                     S01129E22634
     C***********          ADD  MREG      LMG,4                     E22634S01332
     C                   ADD       MREG          LMG(5)                                        S0133
     C                   END                                                                   S0112
     C     *IN52         IFEQ      '0'                                                         S0133
     C     *IN52         OREQ      '1'                                                         S0133
     C     PLMG6         ANDEQ     0                                                           S0133
     C     BUMSIR        IFNE      0                                                           S0133
     C                   ADD       DZIRLM        LMG(6)                                        S0133
     C     BUCYCD        IFNE      BCYL                                                        09427
     C*                                                                   094276
     C     LMG(6)        IFNE      0                                                           09427
     C     BSMDIN        IFEQ      'D'                                                         09427
     C     LMG(6)        DIV       BSSPOT        LMG(6)                                        09427
     C                   ELSE                                                                  09427
     C     LMG(6)        MULT      BSSPOT        LMG(6)                                        09427
     C                   END                                                                   09427
     C     EMMDIN        IFEQ      'D'                                                         09427
     C     LMG(6)        MULT      EMSPOT        LMG(6)                                        09427
     C                   ELSE                                                                  09427
     C     LMG(6)        DIV       EMSPOT        LMG(6)                                        09427
     C                   END                                                                   09427
     C                   END                                                                   09427
     C                   END                                                                   09427
     C                   END                                                                   S0133
     C                   END                                                                   S0133
     C********** RECIL     IFEQ 'D'                                 E21212S01314
     C     *IN52         IFEQ      '0'                                                         S0112
     C     *IN52         OREQ      '1'                                                         E2129
     C     PLMG1         ANDEQ     0                                                           E2129
     C***********MSFX      IFNE 0                                   S01129S01332
     C     BUMSFX        IFNE      0                                                           S0133
     C     FLED          IFGT      RUND                                                        S0112
     C     FLED          OREQ      0                                                           S0112
     C***********FLAM      DIV  100       LMG,1     H              S01128 E16005
     C***********          MULT FPER      LMG,1                    S01128 E16005
     C     FPER          DIV(H)    100           FPERCT            3 2                         E1600
     C***********FLAM      MULT FPERCT    LMG,1     H               E16005E21293
     C     FLAM          MULT(H)   FPERCT        WLMG1            11 0                         E2129
     C*                                                                   E18716
     C* GRANTED LIMITS HELD IN BASE CCY - CONVERT TO EM CCY.              E18716
     C*                                                                   E18716
     C***********LCCY      IFNE BCYL                                E18716S01332
     C     BUCYCD        IFNE      BCYL                                                        S0133
     C*                                                                   E18716
     C***********LMG,1     IFNE 0                                   E18716E21293
     C     WLMG1         IFNE      0                                                           E2129
     C***********BSMDIN    IFEQ 0                                   E18716S01332
     C     BSMDIN        IFEQ      'D'                                                         S0133
     C***********LMG,1     DIV  BSSPOT    LMG,1                     E18716E21293
     C     WLMG1         DIV       BSSPOT        WLMG1                                         E2129
     C                   ELSE                                                                  E1871
     C***********LMG,1     MULT BSSPOT    LMG,1                     E18716E21293
     C     WLMG1         MULT      BSSPOT        WLMG1                                         E2129
     C                   END                                                                   E1871
     C***********EMMDIN    IFEQ 0                                   E18716S01332
     C     EMMDIN        IFEQ      'D'                                                         S0133
     C***********LMG,1     MULT EMSPOT    LMG,1                     E18716E21293
     C     WLMG1         MULT      EMSPOT        WLMG1                                         E2129
     C                   ELSE                                                                  E1871
     C***********LMG,1     DIV  EMSPOT    LMG,1                     E18716E21293
     C     WLMG1         DIV       EMSPOT        WLMG1                                         E2129
     C                   END                                                                   E1871
     C                   END                                                                   E1871
     C                   END                                                                   E1871
     C*                                                                   E18716
     C                   ADD       WLMG1         LMG(1)                                        E2129
     C                   END                                                                   S0112
     C                   END                                                                   S0112
     C                   END                                                                   E2129
     C*                                                                   E21293
     C     *IN52         IFEQ      '0'                                                         S0112
     C     *IN52         OREQ      '1'                                                         E2129
     C     PLMG2         ANDEQ     0                                                           E2129
     C***********MSMM      IFNE 0                                   S01129S01332
     C     BUMSMM        IFNE      0                                                           S0133
     C********** LLED      IFGT RUND                               S01128 109454
     C********** LLED      OREQ 0                                  S01128 109454
     C***********DZMMED    IFGT RUND                                109454133355
     C***********DZMMED    OREQ 0                                   109454133355
     C     LLED          IFGT      RUND                                                        13335
     C     LLED          OREQ      0                                                           13335
     C***********LLAM      DIV  100       LMG,2     H              S01128 E16005
     C***********          MULT MPER      LMG,2                    S01128 E16005
     C     MPER          DIV(H)    100           MPERCT            3 2                         E1600
     C***********LLAM      MULT MPERCT    LMG,2     H               E16005E21293
     C********** LLAM      MULT MPERCT    WLMG2  110H              E21293 109454
     C***********DZMMAM    MULT MPERCT    WLMG2  110H               109454133355
     C     LLAM          MULT(H)   MPERCT        WLMG2            11 0                         13335
     C*                                                                   E18716
     C* GRANTED LIMITS HELD IN BASE CCY - CONVERT TO EM CCY.              E18716
     C*                                                                   E18716
     C***********LCCY      IFNE BCYL                                E18716S01332
     C     BUCYCD        IFNE      BCYL                                                        S0133
     C*                                                                   E18716
     C***********LMG,2     IFNE 0                                   E18716E21293
     C     WLMG2         IFNE      0                                                           E2129
     C***********BSMDIN    IFEQ 0                                   E18716S01332
     C     BSMDIN        IFEQ      'D'                                                         S0133
     C***********LMG,2     DIV  BSSPOT    LMG,2                     E18716E21293
     C     WLMG2         DIV       BSSPOT        WLMG2                                         E2129
     C                   ELSE                                                                  E1871
     C***********LMG,2     MULT BSSPOT    LMG,2                     E18716E21293
     C     WLMG2         MULT      BSSPOT        WLMG2                                         E2129
     C                   END                                                                   E1871
     C***********EMMDIN    IFEQ 0                                   E18716S01332
     C     EMMDIN        IFEQ      'D'                                                         S0133
     C***********LMG,2     MULT EMSPOT    LMG,2                     E18716E21293
     C     WLMG2         MULT      EMSPOT        WLMG2                                         E2129
     C                   ELSE                                                                  E1871
     C***********LMG,2     DIV  EMSPOT    LMG,2                     E18716E21293
     C     WLMG2         DIV       EMSPOT        WLMG2                                         E2129
     C                   END                                                                   E1871
     C                   END                                                                   E1871
     C                   END                                                                   E1871
     C*                                                                   E18716
     C                   ADD       WLMG2         LMG(2)                                        E2129
     C                   END                                                                   S0112
     C                   END                                                                   S0112
  XX C                   END                                                                   S0112
     C**********           END                                      E21212S01314
0588 C                   ENDSR
0589 C********************************************************************
0590 C/EJECT
0591 C********************************************************************
0592 C**
0593 C**   NEGEXP SR. - IF EXPOSURE IS NEGATIVE, ADD INTO OFF-SETTING
0594 C**                BALANCE.
0496 C**    CALLED FROM CHILD,CLDLON
0496 C**    CALLS SR -
0595 C     NEGEXP        BEGSR
0596 C***********          Z-ADD1         Y       10                      S01332
0596 C                   Z-ADD     1             Y                 2 0                         S0133
0597 C     CHKLP         TAG
     C     Y             IFEQ      1                                                           S0112
     C     Y             OREQ      2                                                           S0112
     C     Y             OREQ      3                                                           S0133
     C     Y             OREQ      4                                                           S0112
     C     Y             OREQ      5                                                           S0112
     C     Y             OREQ      6                                                           S0133
     C     Y             OREQ      10                                                          S0133
     C     Y             OREQ      11                                                          S0133
     C     Y             OREQ      12                                                          CTI00
0598 C     XPA(Y)        COMP      0                                    80
0599 C   80              SUB       XPA(Y)        OBA(Y)
0600 C   80              Z-ADD     0             XPA(Y)
     C                   END                                                                   S0112
0601 C                   ADD       1             Y
0602 C***********Y         COMP 6                    81             S01129S01332
0602 C*          Y         COMP 12                   81             S01332CTI002
     C     Y             COMP      13                                 81                       CTI00
0603 C  N81              GOTO      CHKLP                                        ** GOTO CHKLP
0604 C     CHKEND        ENDSR
0605 C********************************************************************
0606 C********************************************************************
0607 C**
0608 C**   EXPDAT SR. - CHECKS THE EXPIRY DATE AGAINST THE RUN DATE AND
0609 C**                SETS INDICATORS ACCORDINGLY.
0610 C**
0496 C**    CALLED FROM CHILD,CLDLON
0496 C**    CALLS SR -
0611 C**
0612 C     EXPDAT        BEGSR
0613 C     MXPD          COMP      RUND                               545556
0614 C  N56              MOVE      MXPD          ZDAYNO
0615 C  N56              EXSR      ZDATE2
0616 C                   ENDSR
0617 C********************************************************************
     C*    STLIMS SR  ACCESSES AND ACCUMULATES GRANTED LIMITS FOR         S01129
     C*                SECURITIES TRADING MODULES                         S01129
     C*                                                                   S01129
     C** CALLED FROM PARENT AND CLDLON                                    S01129
     C**                                                                  S01129
     C*                                                                   S01129
     C     STLIMS        BEGSR                                                                 S0112
     C*                                                                   S01129
     C* CHECK SECURITES TRADING MODULE IS IN SYSTEM                       S01129
     C*                                                                   S01129
     C***********MSSC      IFNE 0                                   S01129S01332
     C***********MSSI      ORNE 0                                   S01129S01332
     C     BUMSSC        IFNE      0                                                           S0133
     C     BUMSSI        ORNE      0                                                           S0133
     C*                                                                   S01129
     C* CHAIN TO CLINTSE FOR DISCRETIONARY INDICATOR                      S01129
     C*                                                                   S01129
     C     CNUM          CHAIN     CLINTSEF                           46                       S0112
     C*                                                                   S01129
     C* SET KEY FOR CHAINING TO LIMITS FILE                               S01129
     C*                                                                   S01129
     C                   MOVE      *BLANKS       BOKH                                          E1460
     C                   MOVE      'S'           LVLH                                          E1460
     C                   MOVE      *BLANKS       ETYH                                          E1460
     C     SLMKEY        CHAIN     SLIMHF                             48                       E1460
     C  N48RECI          COMP      '*'                                    48                   E1460
     C*                                                                   E14606
     C     *IN48         IFEQ      '1'                                                         E1460
     C*                                                                   E14606
     C     *IN46         IFEQ      '1'
     C     C1DI          OREQ      'M'                                                         S0112
     C                   MOVE      DMKB          BOKH                                          S0112
     C                   ELSE                                                                  S0112
     C                   MOVE      DPFB          BOKH                                          S0112
     C                   END                                                                   S0112
     C***********          MOVE 'S'       LVLH                      S01129E14606
     C***********          MOVE *BLANKS   ETYH                      S01129E14606
     C*                                                                   S01129
     C     SLMKEY        CHAIN     SLIMHF                             48                       S0112
     C  N48RECI          COMP      '*'                                    48                   S0112
     C                   END                                                                   E1460
     C*                                                                   E14606
     C     *IN48         IFEQ      '0'                                                         S0112
     C*                                                                   S01129
     C***********LSNG      IFEQ 'N'                                 S01129S01332
     C     BULSHN        IFEQ      'N'                                                         S0133
     C     MSIE          IFGE      0                                                           S0112
     C                   ADD       LLMH          LMG(8)                                        S0112
     C                   ELSE                                                                  S0112
     C                   ADD       SLMH          LMG(8)                                        S0112
     C                   END                                                                   S0112
     C*                                                                   S01129
     C                   ELSE                                                                  S0112
     C*                                                                   S01129
     C                   ADD       LLMH          LMG(8)                                        S0112
     C*                                                                   S01129
     C                   END                                                                   S0112
     C*                                                                   S01129
     C***********CPTG      IFEQ 'N'                                 S01129E14606
     C***********MSCE      IFGE 0                                   S01129E14606
     C***********          ADD  CLMP      LMG,7                     S01129E14606
     C***********          ELSE                                     S01129E14606
     C***********          ADD  CLMS      LMG,7                     S01129E14606
     C***********          END                                      S01129E14606
     C*                                                                   S01129
     C***********CPTG      IFEQ 'Y'                                 E14606S01332
     C     BUCPTG        IFEQ      'Y'                                                         S0133
     C     MSCE          ORGE      0                                                           E1460
     C                   ADD       CLMS          LMG(7)                                        E1460
     C*                                                                   E14606
     C                   ELSE                                                                  S0112
     C*                                                                   S01129
     C                   ADD       CLMP          LMG(7)                                        S0112
     C*                                                                   S01129
     C                   END                                                                   S0112
     C*                                                                   S01129
     C                   END                                                                   S0112
     C*                                                                   S01129
     C* GRANTED LIMITS HELD IN BASE CCY - CONVERT TO EM CCY               S01129
     C*                                                                   S01129
     C***********LCCY      IFNE BCYL                                S01129S01332
     C     BUCYCD        IFNE      BCYL                                                        S0133
     C*                                                                   S01129
     C     LMG(7)        IFNE      0                                                           S0112
     C     LMG(7)        DIV       BSSPOT        LMG(7)                                        S0112
     C     LMG(7)        MULT      EMSPOT        LMG(7)                                        S0112
     C                   END                                                                   S0112
     C     LMG(8)        IFNE      0                                                           S0112
     C     LMG(8)        DIV       BSSPOT        LMG(8)                                        S0112
     C     LMG(8)        MULT      EMSPOT        LMG(8)                                        S0112
     C                   END                                                                   S0112
     C*                                                                   S01129
     C                   END                                                                   S0112
     C                   END                                                                   S0112
     C*                                                                   S01129
     C                   ENDSR                                                                 S0112
0738 C********************************************************************
0739 C*    CMDSR1 SR  COMMAND KEY VALIDATION AND RESPONSE
0418 C*
     C**   CALLED FROM   DETSR
     C**   CALLS SR      RETSR
0418 C*
0418 C*    This is a standard link enquiry subroutine for processing
0418 C*    the command keys.
0418 C*
0418 C*    Indicators used
0418 C*****07**terminate*without*predjudice                               S01332
0418 C*
0740 C     CMDSR1        BEGSR                                                  *** CMDSR   ***
0741 C*
0419 C*    IF COMMAND 3 THEN END PROGRAM                                  S01179
0420 C************IN07     IFEQ '1'                                 S01179S01332
0420 C     *INKC         IFEQ      '1'                                                         S0133
0421 C                   SETON                                        LR
0421 C                   MOVE      '7'           RETNWF            1
0421 C                   EXSR      RETSR
0421 C***********          ELSE                                           S01332
0741 C*
     C**
0421 C                   END
     C*                                                                   S01332
     C**   IF CF4 TAKEN, PROCESS REQUEST TO DISPLAY CHILDREN              S01332
     C     *INKD         IFEQ      '1'                                                         S0133
     C                   EXSR      CHLDRQ                                                      S0133
     C                   END                                                                   S0133
     C*                                                                   S01332
     C**   IF CF5 TAKEN, PROCESS REQUEST FOR MODULAR LIMIT ENQUIRY        S01332
     C     *INKE         IFEQ      '1'                                                         S0133
     C                   EXSR      MDLMRQ                                                      S0133
     C                   END                                                                   S0133
     C/COPY WNCPYSRC,EM0301C008
     C*                                                                   S01332
     C**   IF CF6 TAKEN, PROCESS REQUEST FOR DAILY DELIVERY RISK          S01332
     C**   ENQUIRY                                                        S01332
     C     *INKF         IFEQ      '1'                                                         S0133
     C                   EXSR      DDRKRQ                                                      S0133
     C                   END                                                                   S0133
     C*                                                                   S01332
     C/COPY WNCPYSRC,EM0301C012
     C**   IF CF24 TAKEN, DISPLAY TEXT FOR OTHER COMMAND KEYS             S01332
     C     *INKY         IFEQ      '1'                                                         S0133
     C     *IN33         IFEQ      '0'                                                         S0133
     C                   SETON                                        33                       S0133
     C                   ELSE                                                                  S0133
     C                   SETOFF                                       33                       S0133
     C                   END                                                                   S0133
     C                   END                                                                   S0133
     C**
     C/COPY WNCPYSRC,EM0301C013
0744 C*
0745 C                   ENDSR
0746 C********************************************************************
0738 C********************************************************************
0739 C*    RETSR SR END OF PROGRAM PROCESSING
     C*****CALLED*FROM***CMDSR1,DTRQS1,FICYC,                             S01332
     C**   CALLED FROM   MDLMRQ,DDRKRQ,CMDSR1,DTRQS1,FICYC,               S01332
     C**                 CHDLON,CUSTS1,SHNSR,MAINSR
     C**   CALLS SR
0740 C     RETSR         BEGSR                                                  *** RETSR   ***
0741 C*
0742 C                   SETON                                        LR
     C*                                                                   S01332
     C**  IF DATABASE ERROR HAS OCCURRED IN LOWER LEVEL PROGRAM,          S01332
     C**  SET ON U7, U8                                                   S01332
     C     RETNWF        IFEQ      'E'                                                         S0133
     C                   SETON                                        U7U8                     S0133
     C                   END                                                                   S0133
0391 C**
0392 C**  ACCESS EM DATA AREA
0405 C     *LOCK         IN        EMSDS
0402 C                   MOVE      RETNWF        RETND
0402 C***********          MOVELRQDTWF    RQDTD                           S01332
0405 C                   OUT       EMSDS
0743 C                   RETURN
0744 C*
0745 C                   ENDSR
0746 C********************************************************************
0846 C**
0618 C********************************************************************
0619 C**
0620 C**   ZERO SR. TO CONVERT ALL OUTPUT FIELDS TO ZERO.
0621 C**   CALLED BY INITIAL SCREEN PROCESSING
0622 C     ZERO          BEGSR
0623 C** SET FIELDS TO ZERO
0624 C***                  Z-ADD0         LM                              S01129
     C                   Z-ADD     0             LIM                                           S0112
     C                   Z-ADD     0             LMG                                           S0112
0625 C***                  Z-ADD0         XP                              S01129
0626 C                   Z-ADD     0             XPA
0627 C                   Z-ADD     0             XPO
0628 C                   Z-ADD     0             AV
     C                   Z-ADD     0             AVG                                           S0112
0629 C***                  Z-ADD0         OB                              S01129
0630 C                   Z-ADD     0             OBA
0631 C                   Z-ADD     0             OBO
     C                   MOVE      *BLANKS       LES                                           S0112
     C                   MOVE      *BLANKS       LMS                                           S0112
     C                   MOVE      *BLANKS       XPS                                           S0112
     C                   MOVE      *BLANKS       AVS                                           S0112
     C                   MOVE      *BLANKS       OBS                                           S0112
     C                   MOVE      *BLANKS       LGS                                           S0112
     C                   MOVE      *BLANKS       AGS                                           S0112
     C***********          MOVE *BLANKS   LGG                       S01129S01332
     C***********          MOVE *BLANKS   LMO                       S01129S01332
     C***********          MOVE *BLANKS   XPAO                      S01129S01332
     C***********          MOVE *BLANKS   AVO                       S01129S01332
     C***********          MOVE *BLANKS   OBAO                      S01129S01332
     C***********          MOVE *BLANKS   LGO                       S01129S01332
     C***********          MOVE *BLANKS   AGO                       S01129S01332
0632 C                   Z-ADD     0             MOAL             11 0
     C                   Z-ADD     0             LMGTOT           11 0                         S0112
0633 C***                  Z-ADD0         MBCL   110                      S01129
0634 C***                  Z-ADD0         MSTL   110                      S01129
0635 C***                  Z-ADD0         MFFL   110                      S01129
0636 C                   Z-ADD     0             XPTOT            12 0
0637 C                   Z-ADD     0             AVTOT            12 0
     C                   Z-ADD     0             AVGTOT           12 0                         S0112
0638 C                   Z-ADD     0             OBTOT            12 0
     C/COPY WNCPYSRC,EM0301C023
 639 C                   ENDSR
0640 C********************************************************************
0641 C/EJECT
0418 C********************************************************************S01129
0419 C**                                                                  S01129
0420 C**   ARFILL SR. FILL STORAGE ARRAYS DEPENDING ON TABTB95            S01129
0421 C**   CALLED BY MAIN SCREEN PROCESSING                               S01129
0419 C**                                                                  S01129
0420 C**  MB contains orig posn in TABTB95 , MS contains req'd posn       S01129
0421 C**    eg if MM(2nd in TABTB95) had req'd seq 01 (ie MSMM=01)        S01129
0419 C**       then 1st MSQ element would be 01(MS) 02(MB)                S01129
0419 C**                                                                  S01129
0422 C     ARFILL        BEGSR                                                                 S0112
     C                   Z-ADD     0             Z3                2 0                         S0112
     C***********          DO   10        Z1      20                S01129E22634
     C**********           DO   08        Z1      20                E22634S01314
     C***********          DO   09        Z1      20                S01314S01332
     C*                    DO   11        Z1      20                S01332CTI002
     C                   DO        12            Z1                2 0                         CTI00
     C                   MOVE      MSQ(Z1)       MSEQ                                          S0112
      *                                                                   S01129
      * Only fill line if module sequence is non-zero                     S01129
     C     MS            IFNE      0                                                           S0122
      *                                                                   S01129
     C/COPY WNCPYSRC,EM0301C014
      * Always fill legend                                                S01129
     C                   ADD       1             Z3                                            S0112
     C                   MOVE      LEG(MB)       LES(Z3)                                       S0112
      *                                                                   S01129
     C/COPY WNCPYSRC,EM0301C015
      * Fill limit except for SE portfolio                                S01129
     C***********MB        IFNE 9                                   S01129E22634
     C***********MB        IFNE 8                                   E22634S01332
     C     MB            IFNE      9                                                           S0133
     C                   MOVE      LIM(MB)       LMS(Z3)                                       S0112
     C                   END                                                                   S0112
     C/COPY WNCPYSRC,EM0301C009
     C*                                                                   S01129
     C* SET MODULE NOS FOR OPTIONS                                        S01129
     C*                                                                   S01129
     C                   MOVE      AEM(MB)       OPL(Z3)                                       S0112
     C*                                                                   S01129
      *                                                                   S01129
     C**Fill*exp,avail,offset*bal*for*FX,MM,LE,RE                   S01129S01332
      * Fill exp,avail,offset bal for FX,MM,FRA,LE,RE,IRS,Futures,        S01332
      * Options                                                           S01332
     C     MB            IFEQ      1                                                           S0112
     C     MB            OREQ      2                                                           S0112
     C***********MB        OREQ 4                                   S01129E22634
     C***********MB        OREQ 5                                   S01129E22634
     C     MB            OREQ      3                                                           E2263
     C     MB            OREQ      4                                                           E2263
     C     MB            OREQ      5                                                           S0131
     C     MB            OREQ      6                                                           S0133
     C***********MB        OREQ 9                                   S01314S01332
     C     MB            OREQ      10                                                          S0133
     C     MB            OREQ      11                                                          S0133
     C     MB            OREQ      12                                                          CTI00
     C                   MOVE      XPO(MB)       XPS(Z3)                                       S0112
     C                   MOVE      AV(MB)        AVS(Z3)                                       S0112
     C                   MOVE      OBO(MB)       OBS(Z3)                                       S0112
     C***********          ADD  1         Z3                        S01129S01332
     C***********          MOVE '9999999' LES,Z3                    S01129S01332
      *                                                                   S01332
      * Fill granted limit and available for FX,MM,FRA,LE,RE,IRS          S01332
     C     MB            IFNE      10                                                          S0133
     C     MB            ANDNE     11                                                          S0133
     C     MB            ANDNE     12                                                          CTI00
     C                   MOVE      LMG(MB)       LGS(Z3)                                       S0112
     C                   MOVE      AVG(MB)       AGS(Z3)                                       S0112
     C                   END                                                                   S0133
     C                   END                                                                   S0112
      *                                                                   S01129
      * Fill exp,avail for SE c/party,SE iss                              S01129
     C***********MB        IFEQ 7                                   S01129E22634
     C***********MB        OREQ 8                                   S01129E22634
     C***********MB        IFEQ 6                                   E22634S01332
     C***********MB        OREQ 7                                   E22634S01332
     C     MB            IFEQ      7                                                           S0133
     C     MB            OREQ      8                                                           S0133
     C                   MOVE      XPO(MB)       XPS(Z3)                                       S0112
     C                   MOVE      AV(MB)        AVS(Z3)                                       S0112
     C***********          ADD  1         Z3                        S01129S01332
     C***********          MOVE '9999999' LES,Z3                    S01129S01332
     C                   MOVE      LMG(MB)       LGS(Z3)                                       S0112
     C                   MOVE      AVG(MB)       AGS(Z3)                                       S0112
     C                   END                                                                   S0112
      *
      * Fill offset bal for SE portfolio
     C***********MB        IFEQ 9                                   S01129E22634
     C***********MB        IFEQ 8                                   E22634S01332
     C     MB            IFEQ      9                                                           S0133
     C                   MOVE      OBO(MB)       OBS(Z3)                                       S0112
     C                   END                                                                   S0112
     C                   END                                                                   S0112
     C/COPY WNCPYSRC,EM0301C016
     C                   END                                                                   S0112
0426 C                   ENDSR                                                                 S0112
0427 C********************************************************************S01129
0418 C********************************************************************S01129
0419 C**                                                                  S01129
0420 C**   FILL1  SR. FILL 1ST DETAIL SCREEN                              S01129
0421 C**   CALLED BY MAIN SCREEN PROCESSING                               S01129
0422 C     FILL1         BEGSR                                                                 S0112
     C                   Z-ADD     0             ZDECS                                         S0112
     C                   MOVE      'J'           ZECODE                                        S0112
     C***********          MOVE *BLANKS   LMO                       S01129S01332
     C***********          MOVE *BLANKS   XPAO                      S01129S01332
     C***********          MOVE *BLANKS   AVO                       S01129S01332
     C***********          MOVE *BLANKS   OBAO                      S01129S01332
     C***********          MOVE *BLANKS   LGO                       S01129S01332
     C***********          MOVE *BLANKS   AGO                       S01129S01332
     C                   MOVE      *BLANKS       SMGTLM                                        S0133
     C                   MOVE      *BLANKS       SXPOSR                                        S0133
     C                   MOVE      *BLANKS       SAVMGT                                        S0133
     C                   MOVE      *BLANKS       SOFSBL                                        S0133
     C                   MOVE      *BLANKS       SGRTLM                                        S0133
     C                   MOVE      *BLANKS       SAVGRT                                        S0133
     C                   MOVE      *BLANKS       SLEGND                                        S0133
     C                   SETON                                        75                       S0112
     C***********          Z-ADD60        Z8      20                S01129S01332
     C***********          Z-ADD20        Z6      20                S01129S01332
0281 C***********          Z-ADD10        Z4      20                S01129S01332
     C***********          DO   10        Z       20                S01129S01332
     C***********          MOVE OPS,Z     OPI,Z                     S01129S01332
     C***********Z         ADD  1         Z5      20                S01129S01332
     C***********LES,Z     IFNE *BLANKS                             S01229S01332
     C***********Z         ANDGT9                                   S01129S01332
     C***********LES,Z5    ANDEQ'9999999'                           S01129S01332
0281 C***********          Z-ADD9         Z4                        S01129S01332
     C***********          MOVE '1'       *IN,Z8                    S01129S01332
     C***********          ELSE                                     S01129S01332
     C***********LES,Z     IFEQ '9999999'                           S01129S01332
     C***********          MOVE '0'       *IN,Z8                    S01129S01332
     C***********          MOVE '0'       *IN,Z6                    S01129S01332
     C***********          MOVE *BLANKS   LGG,Z                     S01129S01332
     C     LGS(Z)        IFNE      *BLANKS                                                     S0112
     C                   MOVE      *BLANKS       ZFLD15                                        S0112
     C                   MOVE      LGS(Z)        ZFLD15                                        S0112
     C                   EXSR      ZSEDIT                                                      S0112
     C***********          MOVE ZOUT21    LGO,Z                     S01129S01332
     C                   MOVE      ZOUT21        SGRTLM                                        S0133
     C                   END                                                                   S0112
     C     AGS(Z)        IFNE      *BLANKS                                                     S0112
     C                   MOVE      *BLANKS       ZFLD15                                        S0112
     C                   MOVE      AGS(Z)        ZFLD15                                        S0112
     C                   EXSR      ZSEDIT                                                      S0112
     C***********          MOVE ZOUT21    AGO,Z                     S01129S01332
     C                   MOVE      ZOUT21        SAVGRT                                        S0133
     C                   END                                                                   S0112
     C***********          ELSE                                     S01129S01332
     C     LES(Z)        IFNE      *BLANKS                                                     S0112
     C***********          MOVE '0'       *IN,Z8                    S01129S01332
     C***********          MOVE '1'       *IN,Z6                    S01129S01332
     C***********          MOVE LES,Z     LGG,Z                     S01129S01332
     C                   MOVE      LES(Z)        SLEGND                                        S0133
     C                   END                                                                   S0133
     C     LMS(Z)        IFNE      *BLANKS                                                     S0112
     C                   MOVE      *BLANKS       ZFLD15                                        S0112
     C                   MOVE      LMS(Z)        ZFLD15                                        S0112
     C                   EXSR      ZSEDIT                                                      S0112
     C***********          MOVE ZOUT21    LMO,Z                     S01129S01332
     C                   MOVE      ZOUT21        SMGTLM                                        S0133
     C                   END                                                                   S0112
     C     XPS(Z)        IFNE      *BLANKS                                                     S0112
     C                   MOVE      *BLANKS       ZFLD15                                        S0112
     C                   MOVE      XPS(Z)        ZFLD15                                        S0112
     C                   EXSR      ZSEDIT                                                      S0112
     C***********          MOVE ZOUT21    XPAO,Z                    S01129S01332
     C                   MOVE      ZOUT21        SXPOSR                                        S0133
     C                   END                                                                   S0112
     C     AVS(Z)        IFNE      *BLANKS                                                     S0112
     C                   MOVE      *BLANKS       ZFLD15                                        S0112
     C                   MOVE      AVS(Z)        ZFLD15                                        S0112
     C                   EXSR      ZSEDIT                                                      S0112
     C***********          MOVE ZOUT21    AVO,Z                     S01129S01332
     C                   MOVE      ZOUT21        SAVMGT                                        S0133
     C                   END                                                                   S0112
     C     OBS(Z)        IFNE      *BLANKS                                                     S0112
     C                   MOVE      *BLANKS       ZFLD15                                        S0112
     C                   MOVE      OBS(Z)        ZFLD15                                        S0112
     C                   EXSR      ZSEDIT                                                      S0112
     C***********          MOVE ZOUT21    OBAO,Z                    S01129S01332
     C                   MOVE      ZOUT21        SOFSBL                                        S0133
     C                   END                                                                   S0112
     C***********          ELSE                                     S01129S01332
     C***********          MOVE '1'       *IN,Z8                    S01129S01332
     C***********          END                                      S01129S01332
     C***********          END                                      S01129S01332
     C***********          END                                      S01129S01332
     C***********          ADD  1         Z8                        S01129S01332
     C***********          ADD  1         Z6                        S01129S01332
     C***********          END                                      S01129S01332
0426 C                   ENDSR                                                                 S0112
0427 C********************************************************************S01129
     C/COPY WNCPYSRC,EM0301C024
0418 C********************************************************************S01129
0419 C***********                                                   S01129S01332
0420 C*****FILL2**SR.*FILL*2ND*DETAIL*SCREEN                        S01129S01332
0421 C*****CALLED*BY*MAIN*SCREEN*PROCESSING                         S01129S01332
0422 C***********FILL2     BEGSR                                    S01129S01332
     C***********          MOVE *BLANKS   LMO                       S01129S01332
     C***********          MOVE *BLANKS   XPAO                      S01129S01332
     C***********          MOVE *BLANKS   AVO                       S01129S01332
     C***********          MOVE *BLANKS   OBAO                      S01129S01332
     C***********          MOVE *BLANKS   LGO                       S01129S01332
     C***********          MOVE *BLANKS   AGO                       S01129S01332
     C***********          SETOF                     75             S01129S01332
     C***********          Z-ADD60        Z8      20                S01129S01332
     C***********          Z-ADD20        Z6      20                S01129S01332
     C***********          Z-ADD11        Z5                        S01129S01332
     C***********Z4        ADD  1         Z3      20                S01129S01332
     C***********          DO   6         Z       20                S01129S01332
     C***********          MOVE OPS,Z5    OPI,Z                     S01129S01332
     C***********LES,Z3    IFEQ '9999999'                           S01229S01332
     C***********          MOVE '0'       *IN,Z8                    S01129S01332
     C***********          MOVE '0'       *IN,Z6                    S01129S01332
     C***********LGS,Z3    IFNE *BLANKS                             S01129S01332
     C***********          MOVE *BLANKS   ZFLD15                    S01129S01332
     C***********          MOVE LGS,Z3    ZFLD15                    S01129S01332
     C***********          EXSR ZSEDIT                              S01129S01332
     C***********          MOVE ZOUT21    LGO,Z                     S01129S01332
     C***********          END                                      S01129S01332
     C***********AGS,Z3    IFNE *BLANKS                             S01129S01332
     C***********          MOVE *BLANKS   ZFLD15                    S01129S01332
     C***********          MOVE AGS,Z3    ZFLD15                    S01129S01332
     C***********          EXSR ZSEDIT                              S01129S01332
     C***********          MOVE ZOUT21    AGO,Z                     S01129S01332
     C***********          END                                      S01129S01332
     C***********          ELSE                                     S01129S01332
     C***********LES,Z3    IFNE *BLANKS                             S01129S01332
     C***********          MOVE '0'       *IN,Z8                    S01129S01332
     C***********          MOVE '1'       *IN,Z6                    S01129S01332
     C***********          MOVE LES,Z3    LGG,Z                     S01129S01332
     C***********LMS,Z3    IFNE *BLANKS                             S01129S01332
     C***********          MOVE *BLANKS   ZFLD15                    S01129S01332
     C***********          MOVE LMS,Z3    ZFLD15                    S01129S01332
     C***********          EXSR ZSEDIT                              S01129S01332
     C***********          MOVE ZOUT21    LMO,Z                     S01129S01332
     C***********          END                                      S01129S01332
     C***********XPS,Z3    IFNE *BLANKS                             S01129S01332
     C***********          MOVE *BLANKS   ZFLD15                    S01129S01332
     C***********          MOVE XPS,Z3    ZFLD15                    S01129S01332
     C***********          EXSR ZSEDIT                              S01129S01332
     C***********          MOVE ZOUT21    XPAO,Z                    S01129S01332
     C***********          END                                      S01129S01332
     C***********AVS,Z3    IFNE *BLANKS                             S01129S01332
     C***********          MOVE *BLANKS   ZFLD15                    S01129S01332
     C***********          MOVE AVS,Z3    ZFLD15                    S01129S01332
     C***********          EXSR ZSEDIT                              S01129S01332
     C***********          MOVE ZOUT21    AVO,Z                     S01129S01332
     C***********          END                                      S01129S01332
     C***********OBS,Z3    IFNE *BLANKS                             S01129S01332
     C***********          MOVE *BLANKS   ZFLD15                    S01129S01332
     C***********          MOVE OBS,Z3    ZFLD15                    S01129S01332
     C***********          EXSR ZSEDIT                              S01129S01332
     C***********          MOVE ZOUT21    OBAO,Z                    S01129S01332
     C***********          END                                      S01129S01332
     C***********          ELSE                                     S01129S01332
     C***********          MOVE '1'       *IN,Z8                    S01129S01332
     C***********          END                                      S01129S01332
     C***********          END                                      S01129S01332
     C***********          ADD  1         Z8                        S01129S01332
     C***********          ADD  1         Z3                        S01129S01332
     C***********          ADD  1         Z6                        S01129S01332
     C***********          ADD  1         Z5                        S01129S01332
     C***********          END                                      S01129S01332
     C***********          MOVEA'1111'    *IN,66                    S01129S01332
0426 C***********          ENDSR                                    S01129S01332
0427 C********************************************************************S01129
0284 C********************************************************************
0285 C**
0286 C**   FICYC  FIRST CYCLE PROCESSING  SUBROUTINE      ** FICYC SR *
0287 C**   CALLED IN MAIN PROCESSING
0289 C*****CALLS*SR**FICEM1,RETSR,ZSYSTM,ZERO,                            S01332
0289 C**   CALLS SR  RETSR,ZSYSTM,ZERO,                                   S01332
0288 C**                                                               ***
0289 C**      START OF MAIN PROGRAM
0290 C**
0297 C     FICYC         BEGSR                                                  ** FICYC SR TM
0296 C*    ACCESS ICR1
0297 C                   EXSR      ZSYSTM                                       ** EXSR ZSYSTM
0298 C     *IN99         IFEQ      '1'
0298 C                   MOVE      'TABLE'       DBFILE
0299 C                   MOVE      ZTABKY        DBKEY
0300 C                   MOVE      'EM0301'      DBPGM
0301 C                   Z-ADD     04            DBASE                          DATABASE 04
0302 C                   SETON                                        LRU7U8
0302 C                   EXSR      RETSR
0303 C                   END
0304 C*    ACCESS EM CURRENCY ON ICR2
0305 C**
0306 C**   SET UP KEY FOR INSTALLATION CONTROL RECORD 2.
0307 C                   MOVEL     '01      '    CURKEY
0308 C                   MOVE      '  11'        CURKEY
0309 C**
0310 C***        CURKEY    CHAINTABLE                99    ON NOT THERE   S01129
     C     CURKEY        CHAIN     TABEM                              99        ON NOT THERE   S0112
0311 C**
     C  N99RECI          COMP      '*'                                    99    ON-DELETED     S0112
0312 C**N10N99**           SETON                         99ON - DELETED   S01129
0298 C     *IN99         IFEQ      '1'
0313 C                   MOVE      'TABLE'       DBFILE
0314 C                   MOVE      CURKEY        DBKEY
0315 C                   MOVE      'EM0301'      DBPGM
0316 C                   Z-ADD     05            DBASE                          DATABASE 05
0317 C                   SETON                                        LRU7U8
0318 C                   EXSR      RETSR
0318 C                   END
0333 C**                                                                  S01129
0319 C*****SET*UP*KEY*TO*OBTAIN*CURRENCY*RECORD*FOR*BASE*CCY        S01129S01332
0320 C***********          MOVE BCYL      CCY                       S01129S01332
0321 C***********          MOVEL'20      'CURKEY                    S01129S01332
0322 C***********          MOVE '1'       CURKEY                    S01129S01332
0324 C***********CURKEY    CHAINTABEM                99    ON NOT THS01129S01332
0325 C**N99******RECI      COMP '*'                      99ON - DELES01129S01332
0298 C************IN99     IFEQ '1'                                 S01129S01332
0326 C***********          MOVE 'TABLE'   DBFILE                    S01129S01332
0327 C***********          MOVE CURKEY    DBKEY                     S01129S01332
     C*                                                                   S01332
     C**   OBTAIN CURRENCY RECORD FOR BASE CURRENCY                       S01332
     C                   MOVE      BCYL          @CYCD                                         S0133
     C                   CALL      'AOCURRR0'    PLIST2                                        S0133
     C     @RTCD         IFNE      *BLANKS                                                     S0133
     C                   MOVE      'SDCURRPD'    DBFILE                                        S0133
     C                   MOVE      @CYCD         DBKEY                                         S0133
0328 C                   MOVE      'EM0301'      DBPGM                                         S0112
0329 C                   Z-ADD     06            DBASE                          DATABASE 06    S0112
0330 C                   SETON                                        LRU7U8                   S0112
0318 C                   EXSR      RETSR                                                       S0112
0318 C                   END                                                                   S0112
0332 C***********          MOVE *BLANKS   CURKEY                    S01129S01332
0333 C**                                                                  S01129
     C**   STORE BASE CURRENCY SPOT RATE                                  S01129
     C***********          Z-ADDSPOT      BSSPOT 138                S01129S01332
     C***********          MOVE MDIN      BSMDIN  10                E18716S01332
     C                   Z-ADD     A6SPRT        BSSPOT           13 8                         S0133
     C                   MOVE      A6MDIN        BSMDIN            1                           S0133
0307 C**   IF 'SE' IS NOT INSTALLED DO NOT CHAIN TO 'SE' ICD RECORD.      E15481
0308 C                   TESTB     '4'           MODI3                    13                   E1548
0308 C  N13              GOTO      NOTSE                                                       E1548
0304 C**                                                                  S01129
0305 C**ACCESS*TABTB36*ICD*EM*RECORD*                              S01129 E15481
0305 C* ACCESS TABTB36 ICD SE RECORD                                      E15481
0306 C**                                                                  S01129
0307 C                   MOVEL     '01      '    CURKEY                                        S0112
0308 C                   MOVE      '  36'        CURKEY                                        S0112
0309 C**                                                                  S01129
0310 C     CURKEY        CHAIN     TABEM                              99        ON NOT THERE   S0112
0311 C**                                                                  S01129
0312 C  N99RECI          COMP      '*'                                    99    ON - DELETED   S0112
0298 C     *IN99         IFEQ      '1'                                                         S0112
0313 C                   MOVE      'TABLE'       DBFILE                                        S0112
0314 C                   MOVE      CURKEY        DBKEY                                         S0112
0315 C                   MOVE      'EM0301'      DBPGM                                         S0112
0316 C                   Z-ADD     8             DBASE                          DATABASE 08    S0112
0317 C                   SETON                                        LRU7U8                   S0112
0318 C                   EXSR      RETSR                                                       S0112
0318 C                   END                                                                   S0112
0318 C     NOTSE         TAG                                                                   E1548
0304 C**                                                                  S01129
0305 C**ACCESS*TABTB95*ICD*EM*RECORD                                S01129S01332
0306 C***********                                                   S01129S01332
0307 C***********          MOVEL'01      'CURKEY                    S01129S01332
0308 C***********          MOVE '  95'    CURKEY                    S01129S01332
0309 C***********                                                   S01129S01332
0310 C***********CURKEY    CHAINTABEM                99    ON NOT THS01129S01332
0311 C***********                                                   S01129S01332
0312 C**N99******RECI      COMP '*'                      99ON - DELES01129S01332
0298 C************IN99     IFEQ '1'                                 S01129S01332
0313 C***********          MOVE 'TABLE'   DBFILE                    S01129S01332
0314 C***********          MOVE CURKEY    DBKEY                     S01129S01332
0315 C***********          MOVE 'EM0301'  DBPGM                     S01129S01332
0316 C***********          Z-ADD09        DBASE            DATABASE S01129S01332
0317 C***********          SETON                     LRU7U8         S01129S01332
0318 C***********          EXSR RETSR                               S01129S01332
0318 C***********          END                                      S01129S01332
     C*                                                                   S01332
     C**   ACCESS EXPOSURE MANAGEMENT ICD                                 S01332
     C*                                                                   S01332
     C                   CALL      'AOEXPMR0'                                                  S0133
     C                   PARM      '*DBERR '     @RTCD             7                           S0133
     C                   PARM      '*FIRST '     @OPTN             7                           S0133
     C     SDEXPM        PARM      SDEXPM        DSFDY                                         S0133
     C*                                                                   S01332
     C     @RTCD         IFNE      *BLANKS                                                     S0133
     C                   MOVEL     'SDEXPMPD'    DBFILE                                        S0133
     C                   MOVE      *BLANKS       DBKEY                                         S0133
     C                   MOVE      'EM0301'      DBPGM                                         S0133
     C                   Z-ADD     09            DBASE                                         S0133
     C                   SETON                                        LRU7U8                   S0133
     C                   EXSR      RETSR                                                       S0133
     C                   END                                                                   S0133
     C*                                                                   S01332
0319 C*****SET*UP*KEY*FOR*CURRENCY*RECORD*1.                              S01332
0320 C***********          MOVE LCCY      CCY                             S01332
0321 C***********          MOVEL'20      'CURKEY                          S01332
0322 C***********          MOVE '1'       CURKEY                          S01332
0323 C***********                                                         S01332
0324 C***        CURKEY    CHAINTABLE                99    ON NOT THERE   S01129
0324 C***********CURKEY    CHAINTABEM                99    ON NOT THS01129S01332
     C***********RECI      COMP '*'                      99ON-DELETES01129S01332
0325 C**N12N99**           SETON                         99ON - DELETED   S0
0298 C************IN99     IFEQ '1'                                 S01129S01332
0326 C***********          MOVE 'TABLE'   DBFILE                          S01332
0327 C***********          MOVE CURKEY    DBKEY                           S01332
     C*                                                                   S01332
     C**   OBTAIN CURRENCY RECORD FOR LIMIT CURRENCY                      S01332
     C                   MOVE      BUCYCD        @CYCD                                         S0133
     C                   CALL      'AOCURRR0'    PLIST2                                        S0133
     C     @RTCD         IFNE      *BLANKS                                                     S0133
     C                   MOVE      'SDCURRPD'    DBFILE                                        S0133
     C                   MOVE      @CYCD         DBKEY                                         S0133
0328 C                   MOVE      'EM0301'      DBPGM
0329 C                   Z-ADD     06            DBASE                          DATABASE 06
0330 C                   SETON                                        LRU7U8
0318 C                   EXSR      RETSR
0318 C                   END
0320 C***********          MOVE CCNM      CCNMWF 14                 S01129S01332
0332 C***********          MOVE *BLANKS   CURKEY                          S01332
0320 C                   MOVE      A6CYNM        CCNMWF           14                           S0133
0333 C**
     C**   STORE EM CURRENCY SPOT RATE AND NARRATIVE
     C***********          Z-ADDSPOT      EMSPOT 138                      S01332
     C***********          MOVE CCNM      EMCCNM 14                       S01332
     C***********          MOVE MDIN      EMMDIN  10                E15671S01332
     C                   Z-ADD     A6SPRT        EMSPOT           13 8                         S0133
     C                   MOVE      A6CYNM        EMCCNM           14                           S0133
     C                   MOVE      A6MDIN        EMMDIN            1                           S0133
0333 C**
0334 C**   ACCESS EMCEXX1 - HEADER & CHECK DUBIOUS INDICATOR
0335 C**
0336 C                   MOVE      *BLANKS       MCUN                                          E1063
0337 C     MCUN          CHAIN     EMCEX                              99
0298 C     *IN99         IFEQ      '1'
0338 C                   MOVE      'EMCEXX1'     DBFILE
0339 C                   MOVE      *BLANKS       DBKEY
0340 C                   MOVE      'EM0301'      DBPGM
0341 C                   Z-ADD     07            DBASE                          DATABASE 07
0342 C                   SETON                                        LRU7U8
0318 C                   EXSR      RETSR
0318 C                   END
0344 C     MDI           COMP      'Y'                                    31
0345 C**
0346 C**   SET ON INDICATORS TO CONTROL INITIAL SCREEN OUTPUT
0347 C**
0348 C                   SETON                                        448943
0349 C***31*****           SETOF                     89                                       253255
0350 C***31*****           MOVE MSG,3     ERMSG                                               253255
0345 C**
0346 C**   SET AMOUNT FIELDS TO ZERO
0347 C                   EXSR      ZERO
0391 C**
0392 C**  ACCESS MMOD DATA AREA AND SET MODULE INDICATORS                 S01129
0405 C****       *LOCK     IN   MMOD                                      S01129
0402 C****       DLMODL    COMP 'Y'                      21               S01129
0402 C***        DLMODL    COMP 'Y'                      22               S01129
0402 C**N22      CLMODL    COMP 'Y'                      22               S01129
0402 C**N22      LEMODL    COMP 'Y'                      22               S01129
0402 C****       RTMODL    COMP 'Y'                      23               S01129
0402 C**N23      REMODL    COMP 'Y'                      23               S01129
0402 C****       BCMODL    COMP 'Y'                      24               S01129
0402 C****       STMODL    COMP 'Y'                      25               S01129
0402 C****                 SETOF                         26               S01129
0405 C****                 OUT  MMOD                                      S01129
0345 C**
0346 C*****PROCESSING*FOR*LINK*ENQUIRY                                    S01332
0347 C***********          EXSR FICEM1                                    S01332
0351 C**
     C* SORT MODULE SEQUENCE ARRAY                                        S01129
     C                   Z-ADD     1             MS01                                          S0112
     C                   Z-ADD     2             MS02                                          S0112
     C                   Z-ADD     3             MS03                                          S0112
     C                   Z-ADD     4             MS04                                          S0112
     C                   Z-ADD     5             MS05                                          S0112
     C                   Z-ADD     6             MS06                                          S0112
     C                   Z-ADD     7             MS07                                          S0112
     C                   Z-ADD     8             MS08                                          S0112
     C***********          Z-ADD9         MS09                      S01129E22634
     C***********          Z-ADD10        MS10                      S01129E22634
     C                   Z-ADD     9             MS09                                          S0131
     C                   Z-ADD     10            MS10                                          S0133
     C                   Z-ADD     11            MS11                                    S01332CTI00
     C                   Z-ADD     12            MS12                                          CTI00
     C***********          MOVE MSFX      MSFXS                     S01129S01332
     C***********          MOVE MSMM      MSMMS                     S01129S01332
     C***********          MOVE MSIF      MSIFS                     S01129E22634
     C***********          MOVE MSIF      MSIFS                     S01314S01332
     C***********          MOVE MSLN      MSLNS                     S01129S01332
     C***********          MOVE MSRE      MSRES                     S01129S01332
     C***********          MOVE MSLC      MSLCS                     S01129S01196
     C***********          MOVE MSSC      MSSCS                     S01129S01332
     C***********          MOVE MSSI      MSSIS                     S01129S01332
     C***********          MOVE MSSP      MSSPS                     S01129S01332
     C***********          MOVE MSFI      MSFIS                     S01129E22634
     C***********          MOVE MSFI      MSFIS                     S01314S01332
     C                   MOVE      BUMSFX        BMSFX                                         S0133
     C                   MOVE      BUMSMM        BMSMM                                         S0133
     C                   MOVE      BUMSFR        BMSFR                                         S0133
     C                   MOVE      BUMSLN        BMSLN                                         S0133
     C                   MOVE      BUMSRT        BMSRT                                         S0133
     C                   MOVE      BUMSIR        BMSIR                                         S0133
     C                   MOVE      BUMSSC        BMSSC                                         S0133
     C                   MOVE      BUMSSI        BMSSI                                         S0133
     C                   MOVE      BUMSSP        BMSSP                                         S0133
     C                   MOVE      BUMSFU        BMSFU                                         S0133
     C                   MOVE      BUMSOP        BMSOP                                         S0133
     C                   MOVE      BUMSTF        BMSTF                                         CTI00
     C/COPY WNCPYSRC,EM0301C017
     C                   SORTA     MSQ                                                         S0112
     C*                                                                   S01332
     C**   SET OFF INDICATOR FOR DISPLAYING COMMAND KEYS TEXT             S01332
     C                   SETOFF                                       33                       S0133
     C*                                                                   S01332
     C**   SET ON SUBFILE END INDICATOR                                   S01332
     C                   SETON                                        60                       S0133
     C     *LIKE         DEFINE    SNUMI         SNUMO                                         07535
     C*                                                                   S01332
     C* ACCESS THE DATA AREA ZMUSER                                       S01332
     C*                                                                   S01332
     C     *DTAARA       DEFINE                  ZMUSER                                        S0133
     C                   IN        ZMUSER                                                      S0133
      *                                                                   S01474
     C                   Z-ADD     0             CUSZER                                        S0147
      *                                                                   S01474
      ** Access the switchable features file, to see if the feature       S01474
      ** S01474 is on. This features will display a line of Leo           S01474
      ** exposure, taken from the Leo Credit Lines.                       S01474
      *                                                                   S01474
     C                   CALL      'AOSARDR0'                                                  S0147
     C                   PARM      *BLANKS       @RTCD             7                           S0147
     C                   PARM      '*VERIFY'     @OPTN             7                           S0147
     C                   PARM      'S01474'      @KEY6             6                           S0147
     C     SCSARD        PARM      SCSARD        DSFDY                                         S0147
      *                                                                   S01474
     C     @RTCD         IFEQ      *BLANKS                                                     S0147
     C                   MOVE      'Y'           S01474            1                           S0147
     C                   END                                                                   S0147
     C*                                                                   S01332
     C**Get*EM*credit*line*code*(WULNC)*by*calling*CAOUSC***********083857091220
     C* If the Leo interface is on, get EM credit line code (WULNC) by    091220
     C* calling CAOUSC                                                    091220
     C     S01474        IFEQ      'Y'                                                         09122
     C                   MOVE      *BLANK        WUFMT                                         08385
     C                   MOVE      *BLANK        WURTN             7                           08385
     C                   MOVEL(P)  '14'          WUKEY1           12                           08385
     C     LIB4          CAT(P)    '/':0         VARI                                          08385
     C                   CAT       'CAOUSC':0    VARI                                          08385
     C                   CALL      VARI                                                        08385
     C     WURTN         PARM      *BLANK        WQ0001            7                           08385
     C                   PARM      '*KEY'        WQ0002            7                           08385
     C                   PARM      WUKEY1        WQ0003           12                           08385
     C                   PARM      *BLANK        WQ0004            7                           08385
     C     WUFMT         PARM      *BLANK        WQ0005          256                           08385
     C     WURTN         IFNE      '*NRF'                                                      08385
     C                   CALL      VARI                                                        08385
     C                   PARM      *BLANK        WQ0001                                        08385
     C                   PARM      '*FREE'       WQ0002                                        08385
     C                   PARM      WUKEY1        WQ0003                                        08385
     C                   PARM      *BLANK        WQ0004                                        08385
     C                   PARM      *BLANK        WQ0005                                        08385
     C                   ENDIF                                                                 08385
     C                   MOVE      *BLANK        VARI                                          08385
     C                   ENDIF                                                                 09122
      *                                                                   CTI002
      ** Access the switchable features file, to see if the feature       CTI002
      ** CTI002 is on.                                                    CTI002
      *                                                                   CTI002
     C                   CALL      'AOSARDR0'                                                  CTI00
     C                   PARM      *BLANKS       @RTCD             7                           CTI00
     C                   PARM      '*VERIFY'     @OPTN             7                           CTI00
     C                   PARM      'CTI002'      @KEY6             6                           CTI00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CTI00
      *                                                                   CTI002
     C     @RTCD         IFEQ      *BLANKS                                                     CTI00
     C                   MOVE      'Y'           CTI002            1                           CTI00
     C                   END                                                                   CTI00
     C*                                                                   CTI002
     C** Access MIDAS Modules details via access program                  CTI002
      *  (database error handling done in access program)                 CTI002
     C                   CALL      'AOMMODR0'                                                  CTI00
     C                   PARM      '*BLANKS'     @RTCD             7                           CTI00
     C                   PARM      '*FIRST '     @OPTN             7                           CTI00
     C     SDMMOD        PARM      SDMMOD        DSFDY                                         CTI00
      *                                                                   CTI002
     C**  Check for data base error.                                      CTI002
     C     @RTCD         IFNE      *BLANK                                                      CTI00
     C                   MOVEL     'SDMMODPD'    DBFILE                         * DBERROR 001 *CTI00
     C                   MOVEL     '*FIRST '     DBKEY            29                           CTI00
     C                   Z-ADD     1             DBASE                                         CTI00
     C                   SETON                                        99                       CTI00
     C                   END                                                                   CTI00
     C*                                                                   CTI002
      ** Access the Switchable Feature files, to see if the feature       147370
      ** S01433 is ON. This feature will use program DL0130A instead      147370
      ** of DL0130.                                                       147370
     C                   CALL      'AOSARDR0'                                                  14737
     C                   PARM      *BLANKS       @RTCD             7                           14737
     C                   PARM      '*VERIFY'     @OPTN             7                           14737
     C                   PARM      'S01433'      @KEY6             6                           14737
     C     SCSARD        PARM      SCSARD        DSFDY                                         14737
     C     @RTCD         IFEQ      *BLANKS                                                     14737
     C                   MOVE      'Y'           S01433            1                           14737
     C                   END                                                                   14737
      *                                                                   CSD007
      ** Access Switchable Features file and check if CSD007              CSD007
      ** is switched on or not.                                           CSD007
      *                                                                   CSD007
     C                   CALL      'AOSARDR0'                                                  CSD00
     C                   PARM      *BLANKS       @RTCD             7                           CSD00
     C                   PARM      '*VERIFY'     @OPTN             7                           CSD00
     C                   PARM      'CSD007'      @SARD             6                           CSD00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CSD00
      *                                                                   CSD007
     C     @RTCD         IFEQ      *BLANKS                                                     CSD00
     C                   MOVE      'Y'           CSD007            1                           CSD00
     C                   ELSE                                                                  CSD00
     C                   MOVE      'N'           CSD007                                        CSD00
      *                                                                   CSD007
      ** Database Error, if Return Code is not blanks or *NRF             CSD007
      *                                                                   CSD007
     C     @RTCD         IFNE      '*NRF   '                                                   CSD00
     C                   MOVEL     'SCSARDPD'    DBFILE                                        CSD00
     C                   Z-ADD     10            DBASE                                         CSD00
     C                   MOVEL     'CSD007  '    DBKEY                                         CSD00
0300 C                   MOVE      'EM0301'      DBPGM                                         CSD00
     C                   MOVE      *ON           *INU7                                         CSD00
     C                   MOVE      *ON           *INU8                                         CSD00
     C                   MOVE      *ON           *INLR                                         CSD00
     C                   EXSR      RETSR                                                       CSD00
     C                   ENDIF                                                                 CSD00
     C                   ENDIF                                                                 CSD00
     C*                                                                   CTI002
      ** Check if CTI007 BFM-TI Exposure Management is enabled                              MD030956
      *                                                                                     MD030956
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CTI007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                     MD030956
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CTI007            1
     C                   ELSE
     C                   MOVE      'N'           CTI007
      *                                                                                     MD030956
     C     @RTCD         IFNE      '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     11            DBASE
     C                   MOVEL     'CTI007  '    DBKEY
     C                   MOVE      'EM0301'      DBPGM
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      RETSR
     C                   ENDIF
     C                   ENDIF
      *                                                                                     MD030956
     C/COPY WNCPYSRC,EM0301C025
0352 C**   END OF FIRST CYCLE PROCESSING
0353 C     ENDFIC        ENDSR
0354 C********************************************************************
0738 C********************************************************************
0739 C*****FICEM1*SR**FIRST*CYCLE*CALCULATIONS                            S01332
0741 C***********                                                         S01332
     C*****CALLED*FROM***FICYC                                            S01332
     C*****CALLS*SR                                                       S01332
0391 C*******This*program*is*at*level*1,so*we*access*the*information      S01332
0391 C*****on*emsds*to*find*out*who*called*this*program.                  S01332
0391 C***********                                                         S01332
0391 C***********                                                         S01332
0740 C***********FICEM1    BEGSR                           *** FICEM1  ***S01332
0345 C***********                                                         S01332
0402 C***********          MOVEL'EM0301  'PROGNM  8                       S01332
0391 C***********                                                         S01332
0392 C****ACCESS*EM*DATA*AREA                                             S01332
0405 C************LOCK     IN   EMSDS                                     S01332
0402 C***********          MOVELPGN1D     PGN1DX  8                       S01332
0402 C***********          MOVELPGN2D     PGN2DX  8                       S01332
0402 C***********          MOVELRQDTD     RQDTWF 20                       S01332
0405 C***********          OUT  EMSDS                                     S01332
0391 C***********                                                         S01332
0392 C****CHECK*IF*CALLED*FROM*LEVEL*3*OR*LEVEL*1                         S01332
0402 C***********PGL1D     IFEQ '2'                                       S01332
0402 C***********          MOVELPGN1D     PGTXT   8                       S01332
0402 C***********          SETOF                     17                   S01332
0725 C***********          MOVELPGN1D     PGN2DX                          S01332
0725 C***********          MOVELPGN2D     PGN1DX                          S01332
0402 C***********          EXSR EMUPS2                                    S01332
0402 C***********          ELSE                                           S01332
0402 C***********          MOVELPGN2D     PGTXT                           S01332
0402 C***********PGL1D     IFEQ '1'                                       S01332
0402 C***********          SETON                     17                   S01332
0402 C***********          ELSE                                           S01332
0402 C***********          SETOF                     17                   S01332
0402 C***********          EXSR EMUPS2                                    S01332
0402 C***********          END                                            S01332
0402 C***********          END                                            S01332
0744 C***********                                                         S01332
0744 C***********                                                         S01332
0745 C***********          ENDSR                                          S01332
0746 C********************************************************************S01474
      /TITLE SR/LEODTL                                                    S01474
      *****************************************************************   S01474
      *                                                               *   S01474
      *  LEODTL - SUBROUTINE TO CALCULATE AND OUTPUT LEO DETAILS      *   S01474
      *                                                               *   S01474
      *  Called By: MAIN PROCESSING                                   *   S01474
      *                                                               *   S01474
      *  Calls:     CAOUCU, CAOULI                                    *   S01474
      *                                                               *   S01474
      *****************************************************************   S01474
     C*                                                                   S01474
     C     LEODTL        BEGSR                                                                 S0147
     C*                                                                   S01474
     C** Setup variable containing library and program for call to        S01474
     C** Access Program CAOUCU                                            S01474
     C*                                                                   S01474
     C                   MOVE      *BLANKS       @WRK                                          S0147
     C                   MOVE      *BLANKS       LIBNM                                         S0147
     C                   MOVE      *BLANKS       VARI                                          S0147
     C                   MOVE      '/CAOUCU'     WVAR              7                           S0147
     C                   MOVEL     LIB2          LIBNM            10                           S0147
     C                   MOVEA     LIBNM         @WRK                                          S0147
     C                   Z-ADD     1             H                 2 0                         S0147
     C*                                                                   S01474
     C     *BLANK        LOOKUP    @WRK(H)                                14                   S0147
     C                   MOVEA     WVAR          @WRK(H)                                       S0147
     C*                                                                   S01474
     C                   MOVEA     @WRK          VARI             17                           S0147
     C*                                                                   S01474
     C** Setup key for chain                                              S01474
     C*                                                                   S01474
     C** Call access program CAOUCU to read CUSPRO                        S01474
     C*                                                                   S01474
     C                   CALL      VARI                                                        S0147
     C                   PARM      '*MSG   '     @RTCD             7                           S0147
     C                   PARM      '*KEY   '     @OPTN             7                           S0147
     C                   PARM      LEOCUS        @KEY              8 0                         S0147
     C                   PARM                    @KYST             7                           S0147
     C     CPPARM        PARM                    P@FMT                                         S0147
     C*                                                                   S01474
     C                   MOVE      *BLANKS       VARI                                          S0147
     C*                                                                   S01474
     C** If record found, process.                                        S01474
     C*                                                                   S01474
     C     @RTCD         IFNE      '*ERROR '                                                   S0147
     C     @RTCD         ANDNE     '*NRF   '                                                   S0147
     C     WULNC         ANDNE     *BLANK                                                      08385
     C*                                                                   S01474
     C** Setup variable containing library and program for call to        S01474
     C** Access Program CAOULI                                            S01474
     C*                                                                   S01474
     C                   MOVE      *BLANKS       @WRK                                          S0147
     C                   MOVE      *BLANKS       LIBNM                                         S0147
     C                   MOVE      *BLANKS       VARI                                          S0147
     C                   MOVE      '/CAOULI'     WVAR              7                           S0147
     C                   MOVEL     LIB3          LIBNM            10                           S0147
     C                   MOVEA     LIBNM         @WRK                                          S0147
     C                   Z-ADD     1             H                 2 0                         S0147
     C*                                                                   S01474
     C     *BLANK        LOOKUP    @WRK(H)                                14                   S0147
     C                   MOVEA     WVAR          @WRK(H)                                       S0147
     C*                                                                   S01474
     C                   MOVEA     @WRK          VARI             17                           S0147
     C*                                                                   S01474
     C** Call access program CAOULI to read LIACRN                        S01474
     C*                                                                   S01474
     C                   CALL      VARI                                                        S0147
     C                   PARM      '*MSG   '     @RTCD             7                           S0147
     C                   PARM      '*KEY   '     @OPTN             7                           S0147
     C                   PARM      CPACR         @KEYA             8                           S0147
     C***********          PARM 'EML'     @KEYB   3                 S01474083857
     C                   PARM      WULNC         @KEYB             3                           08385
     C                   PARM      BUCYCD        @KEYC             3                           S0147
     C                   PARM      'I'           @KEYD             1                           S0147
     C                   PARM                    @KYST             7                           S0147
     C     LIPARM        PARM                    P@FMT                                         S0147
     C*                                                                   S01474
     C** If record not found, call CAOULI with Line Type 'G'              S01474
     C*                                                                   S01474
     C     @RTCD         IFEQ      '*NRF   '                                                   S0147
     C*                                                                   S01474
     C                   CALL      VARI                                                        S0147
     C                   PARM      '*MSG   '     @RTCD             7                           S0147
     C                   PARM      '*KEY   '     @OPTN             7                           S0147
     C                   PARM      CPACR         @KEYA             8                           S0147
     C***********          PARM 'EML'     @KEYB   3                 S01474083857
     C                   PARM      WULNC         @KEYB             3                           08385
     C                   PARM      BUCYCD        @KEYC             3                           S0147
     C                   PARM      'G'           @KEYD             1                           S0147
     C                   PARM                    @KYST             7                           S0147
     C     LIPARM        PARM                    P@FMT                                         S0147
     C                   END                                                                   S0147
     C*                                                                   S01474
     C** Calculate exposure amounts for Leo if record found Type          S01474
     C** 'I' or 'G'                                                       S01474
     C*                                                                   S01474
     C     @RTCD         IFNE      '*ERROR '                                                   S0147
     C     @RTCD         ANDNE     '*NRF   '                                                   S0147
     C*                                                                   S01474
     C     LIAMTS        ADD       LIUNAP        TOTDED                                        S0147
     C     LIAMTL        SUB       TOTDED        TOTLEO                                        S0147
     C     SCCYI         IFNE      BUCYCD                                                      08526
     C     SCCYI         ANDNE     *BLANK                                                      08526
     C     A6MDIN        IFEQ      'D'                                                         S0147
     C     LIAMTL        MULT      A6SPRT        LIAMTL                                        S0147
     C     TOTDED        MULT      A6SPRT        TOTDED                                        S0147
     C     TOTLEO        MULT      A6SPRT        TOTLEO                                        S0147
     C                   ELSE                                                                  S0147
     C     LIAMTL        DIV       A6SPRT        LIAMTL                                        S0147
     C     TOTDED        DIV       A6SPRT        TOTDED                                        S0147
     C     TOTLEO        DIV       A6SPRT        TOTLEO                                        S0147
     C                   END                                                                   S0147
     C                   END                                                                   08526
     C     LIAMTL        DIV       1000          LEOAVL                                        S0147
     C                   ADD       LEOAVL        MOAL                                          S0147
     C                   MOVE      *BLANKS       ZFLD15                                        S0147
     C                   MOVE      LEOAVA        ZFLD15                                        S0147
     C                   EXSR      ZSEDIT                                                      S0147
     C                   MOVE      ZOUT21        SMGTLM                                        S0147
     C                   MOVE      *BLANKS       ZFLD15                                        S0147
     C     TOTDED        DIV       1000          TOTDED                                        S0147
     C                   ADD       TOTDED        XPTOT                                         S0147
     C                   MOVE      TTDEDA        ZFLD15                                        S0147
     C                   EXSR      ZSEDIT                                                      S0147
     C                   MOVE      ZOUT21        SXPOSR                                        S0147
     C                   MOVE      *BLANKS       ZFLD15                                        S0147
     C     TOTLEO        DIV       1000          TOTLEO                                        S0147
     C                   ADD       TOTLEO        AVTOT                                         S0147
     C                   MOVE      TOTLEA        ZFLD15                                        S0147
     C                   EXSR      ZSEDIT                                                      S0147
     C                   MOVE      ZOUT21        SAVMGT                                        S0147
     C                   Z-ADD     0             ZFLD15                                        S0147
     C                   EXSR      ZSEDIT                                                      S0147
     C                   MOVE      ZOUT21        SOFSBL                                        S0147
     C                   MOVE      ZOUT21        SGRTLM                                        S0147
     C                   MOVE      ZOUT21        SAVGRT                                        S0147
     C                   MOVE      *BLANKS       SLEGND                                        S0147
     C                   MOVE      'LEO    '     SLEGND                                        S0147
     C                   WRITE     EM0301S1                                                    S0147
     C                   ADD       1             RRN                                           S0147
     C*                                                                   S01474
     C                   END                                                                   S0147
     C                   END                                                                   S0147
     C*                                                                   S01474
     C                   MOVE      *BLANKS       VARI                                          S0147
     C*                                                                   S01474
     C                   ENDSR                                                                 S0147
0746 C********************************************************************
0408 C**
0642 C********************************************************************
0643 C**
0644 C**   STANDARD SUBROUTINES
0645 C**
0646 C********************************************************************
0647 C**
0648 C**   ZSYSTM SR. TO CHAIN TO THE INSTALLATION CONTROL DATA RECORD.
0649 C**   CALLED BY FIRST RECORD PROCESSING.
0650 C**
0651 C     ZSYSTM        BEGSR                                                  *** ZSYSTM ***
0652 C**
0653 C**   SET UP KEY FOR INSTALLATION CONTROL RECORD.
0654 C                   MOVEL     '01      '    ZTABKY           12
0655 C                   MOVE      '  10'        ZTABKY
0656 C**
0657 C***        ZTABKY    CHAINTABLE                99    ON NOT THERE   S01129
0657 C     ZTABKY        CHAIN     TABEM                              99        ON NOT THERE   S0112
0658 C  N99RECI          COMP      'D'                                9999      ON, IS DELETED
0659 C**
0660 C**   CHECK SYSTEM DATE FORMAT, DDMMYY OR MMDDYY.
0661 C     DATF          COMP      'M'                                    98    MMDDYY, 98 ON
0662 C**
0663 C                   ENDSR
0664 C**
0665 C**
0666 C********************************************************************
0667 C********************************************************************
0668 C**
0669 C**   ZDATE2 SR. TO CONVERT A DAY NUMBER TO DATE FORMATS.
0670 C**   .ALLED BY FIRST RECORD PROCESSING.
0671 C**
0672 C**   THE YEAR 2000, BEING DIVISIBLE BY 400, IS A LEAP YEAR.
0673 C**
0674 C     ZDATE2        BEGSR                                                  *** ZDATE2 ***
0675 C**
0676 C**   CLEAR DATE FIELDS.
0677 C                   Z-ADD     0             ZDATE             6 0
0678 C                   MOVEL     '       '     ZADATE            7
0679 C**
0680 C**   CALCULATION TO DEFINE INPUT DAY NUMBER.
0681 C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
0682 C**
0683 C**   DETERMINE YEAR NUMBER.
0684 C**
0685 C**   ADJUST DAY NUMBER IN CASE LAST DAY OF YEAR.
0686 C     ZDAYNO        SUB       1             ZDAYN1            5 0  99
0687 C   99              GOTO      ZDEND2
0688 C**
0689 C**   CALCULATE NUMBER OF 4 YEAR SPANS SINCE 31/12/1971.
0690 C     ZDAYN1        DIV       1461          ZLYR              2 0
0691 C                   MVR                     ZDAYN1                         SAVE REMAINING
0692 C**                                                   DAYS
0693 C**   CALCULATE NUMBER OF REMAINING YEARS.
0694 C                   Z-ADD     1             ZWRK2             2 0
0695 C     ZDTAG1        TAG                                                    ** ZDTAG1 TAG *
0696 C     ZDAYN1        COMP      ZYDY(ZWRK2)                          90
0697 C  N90ZWRK2         ADD       1             ZWRK2
0698 C  N90              GOTO      ZDTAG1
0699 C     ZWRK2         SUB       1             ZWRK2                    91    LEAP YR, 91 ON
0700 C**
0701 C**   DECREMENT DAY NO. BY DAYS IN REMAINING YEARS.
0702 C  N91ZDAYN1        SUB       ZYDY(ZWRK2)   ZDAYN1
0703 C**
0704 C**   CALCULATE ACTUAL YEAR NUMBER.
0705 C     ZLYR          MULT      4             ZWRK3             3 0
0706 C     ZWRK3         ADD       72            ZWRK3                          BASE IS 1972
0707 C                   Z-ADD     ZWRK3         ZYEAR             2 0
0708 C     ZYEAR         ADD       ZWRK2         ZYEAR                          YEAR
0709 C**
0710 C**   DETERMINE MONTH NUMBER.
0711 C**
0712 C**   ADJUST DAY NO. IN CASE LAST DAY OF LEAP YEAR FEBRUARY.
0713 C                   SETOFF                                       9293
0714 C   91ZDAYN1        COMP      59                                   9293
     C   91
0715 CANN92ZDAYN1        SUB       1             ZDAYN1
0716 C**
0717 C**   CALCULATE MONTH NUMBER.
0718 C                   Z-ADD     2             ZWRK2
0719 C     ZDTAG2        TAG                                                    ** ZDTAG2 TAG *
0720 C     ZDAYN1        COMP      ZMDY(ZWRK2)                          94
0721 C  N94ZWRK2         ADD       1             ZWRK2
0722 C  N94              GOTO      ZDTAG2
0723 C     ZWRK2         SUB       1             ZWRK2
0724 C**
0725 C                   Z-ADD     ZWRK2         ZMTH              2 0          MONTH
0726 C**
0727 C**   DETERMINE DAY OF MONTH.
0728 C**
0729 C**   ADD BACK LAST DAY OF YEAR ADJUSTMENT.
0730 C     ZDAYN1        ADD       1             ZDAYN1
0731 C**
0732 C**   CALCULATE DAY OF MONTH.
0733 C     ZDAYN1        SUB       ZMDY(ZWRK2)   ZDAY              2 0          DAY
0734 C**
0735 C**   ADD BACK LEAP YEAR 29TH FEBUARY ADJUSTMENT, IF REQUIRED.
0736 C   93ZDAY          ADD       1             ZDAY
0737 C**
0738 C**   FORMAT DATE, DDMMYY OR MMDDYY.
0739 C  N98              MOVEL     ZDAY          ZWRK4             4 0
0740 C   98              MOVE      ZDAY          ZWRK4
0741 C  N98              MOVE      ZMTH          ZWRK4
0742 C   98              MOVEL     ZMTH          ZWRK4
0743 C                   MOVEL     ZWRK4         ZDATE
0744 C                   MOVE      ZYEAR         ZDATE
0745 C**
0746 C**   FORMAT ALPHA DATE, DDMMMYY.
0747 C     ZDAY          COMP      10                                   95
0748 C                   MOVEL     ZDAY          ZWRK5             5
0749 C   95              MOVEL     ' '           ZWRK5
0750 C                   MOVE      ZMNM(ZMTH)    ZWRK5
0751 C                   MOVEL     ZWRK5         ZADATE
0752 C                   MOVE      ZYEAR         ZADATE
0753 C**
0754 C     ZDEND2        ENDSR                                                  * ZDEND2 ENDSR*
0755 C**
      *COPY*ZSRSRC,ZSEDITZ3                                                                 MD058079
      /COPY ZSRSRC,ZSEDITZ3LE                                                               MD058079
     C/COPY WNCPYSRC,EM0301C026
0756 C**
0757 C********************************************************************
0758 C/EJECT
0759 O********************************************************************
0760 O*
0761 O*
     O**** EM0301FME          NLR
0763 O**                                 K8 'EM0301F1'
0764 O**                                  2 'SF'
0765 O**                       STIME     10 '  .  .  '
0766 O**                       WSID      13
0767 O**                       CUSPAR    21
0770 O**                       CHLNM     41
0769 O*  ALL FIELD POSITONS FOLLOWING ARE EXTENDED 10 BYTES BECAUSE
     O*  FIELD SHRTNM ADDED
     O**                       SHRTNM    51                               S01128
0771 O**                       CHLTW     61                               S01128
0772 O**                       CPRNWF    67                               S01128
0773 O**                       CCNM      81                               S01128
0774 O**                       CSNM      91                               S01128
0775 O**              N47 54            105 'LIMIT EXPIRES '              S01128
0776 O**              N47 54   ZADATE   112                               S01128
0777 O**              N47 55            105 'LIMIT EXPIRED '              S01128
0778 O**              N47 55   ZADATE   112                               S01128
0779 O**              N47 56            110 'LIMIT EXPIRES TODAY'         S01128
0780 O**               47               112 'NO LIMIT INFORMATION '       S01128
0781 O**               47               117 'FOUND'                       S01128
0782 O**                       LEO1     118                               S01128
0782 O**                       LM,1     132 '  ,   ,   , 0 '              S01128
0783 O**                       XPO,1    147 '   ,   ,   , 0 '             S01128
0784 O**                       AV,1     163 '   ,   ,   , 0 -'            S01128
0782 O**                       LEO2     164                               S01128
0785 O**                       LM,2     178 '  ,   ,   , 0 '              S01128
0786 O**                       XPO,2    193 '   ,   ,   , 0 '             S01128
0787 O**                       AV,2     209 '   ,   ,   , 0 -'            S01128
0788 O**                       OBO,2    224 '   ,   ,   , 0 '             S01128
0782 O**                       LEO3     225                               S01128
0789 O**                       LM,3     239 '  ,   ,   , 0 '              S01128
0790 O**                       XPO,3    254 '   ,   ,   , 0 '             S01128
0791 O**                       AV,3     270 '   ,   ,   , 0 -'            S01128
0792 O**                       OBO,3    285 '   ,   ,   , 0 '             S01128
0782 O**                       LEO4     286                               S01128
0793 O**                       LM,4     300 '  ,   ,   , 0 '              S01128
0794 O**                       XPO,4    315 '   ,   ,   , 0 '             S01128
0795 O**                       AV,4     331 '   ,   ,   , 0 -'            S01128
0796 O**                       OBO,4    346 '   ,   ,   , 0 '             S01128
0782 O**                       LEO5     347                               S01128
0797 O**                       MBCL     361 '  ,   ,   , 0 '              S01128
0782 O**                       LEO6     362                               S01128
0798 O**                       MSTL     376 '  ,   ,   , 0 '              S01128
0782 O**                       LEO7     377                               S01128
0799 O**                       MFFL     391 '  ,   ,   , 0 '              S01128
0800 O**                       MOAL     405 '  ,   ,   , 0 '              S01128
0801 O**                       XPTOT    420 '   ,   ,   , 0 '             S01128
0802 O**                       AVTOT    436 '   ,   ,   , 0 -'            S01128
0803 O**                       OBTOT    451 '   ,   ,   , 0 '             S01128
0804 O**                       ERMSG    530                               S01128
0805 O**                       SNUMI    540                               S01128
0805 O**                       SCCYI    543                               S01128
0808 O********************************************************************
**CTDATA LEG
FX
MM
FRA
LOANS
RETAIL
IRS
SE-C/P
SE-ISS
SE-P/F
FUTURES
OPTIONS
T.FNCE
**CTDATA ZYDY
0366073110961461
**CTDATA ZMDY
000031059090120151181212243273304334365
**CTDATA ZMNM
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**CTDATA MSG
 ENTER A CUSTOMER/PARENT NUMBER OR SHORTNAME,OR SELECT AN OPTION
 ENTER A VALID CUSTOMER/PARENT NUMBER OR SHORTNAME
WARNING - THESE FIGURES MAY NOT BE UP TO DATE.
INVALID ENTRY - ENTER "1"
INVALID ENTRY - ONLY ONE OPTION MAYBE SELECTED
EXPOSURE INFORMATION NOT AVAILABLE FOR THIS BUSINESS LINE
OPTION NOT VALID,PRESS 'HELP' FOR AVAILABLE OPTIONS
ENTER A CUSTOMER/PARENT NUMBER OR SHORTNAME
 ENTER A VALID CUSTOMER/PARENT NUMBER OR SHORTNAME,OR SELECT AN OPTION
INVALID CUSTOMER NUMBER
INVALID CUSTOMER NO./SHORTNAME
INVALID CURRENCY
FUNCTION KEY NOT VALID
ROLLUP/ROLLDOWN IS NOT ALLOWED AT THIS TIME
CUSTOMER CANNOT BE CHANGED IF AN OPTION HAS BEEN REQUESTED.
**CTDATA AEM
123456789AB                                                         E17282S01332
**CTDATA CPY@
(c) Finastra International Limited 2001
