000100200603/*********************************************************************/
000200200603/*STD    CLPBASE                                                     */
000300200603/*EXI *  TEXT('Midas SE Input cycle processing')                     */
000400200603/********************************************************************/
000500200603/*                                                                  */
000600200603/*         Midas   Securities Trading Module                        */
000700200603/*                                                                  */
000800200603/*         SEC02 - INPUT CYCLE PROCESSING                           */
000900200603/*                                                                  */
001000200603/*       (c) Finastra International Limited 2001                     */
001100200603/*                                                                  */
001200200604/*       Last Amend No. AR586601           Date 22May20              */
001300200604/*       Prev Amend No. 259607             Date 22MAY20              */
001400200604/*                      MD046248           Date 27Oct17              */
001500200603/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
001600200603/* Midas Plus 1.4 Base 04 -------------------------------------------*/
001700200603/* Midas Plus 1.4 Base ----------------------------------------------*/
001800200603/* Midas Plus 1.3 ---------------- Base -----------------------------*/
001900200603/*                      CSD031             Date 10Apr06              */
002000200603/*                      CRE020             Date 20Jan04              */
002100200603/*                      CSC023             Date 02Feb04              */
002200200603/*                      CGP001             Date 23May03              */
002300200603/*                      213041             Date 09Dec02              */
002400200603/* Midas Release 4.01.02 --------------------------------------------*/
002500200603/*                      208189             Date 12Aug02              */
002600200603/* Midas Release 4.01 -----------------------------------------------*/
002700200603/*                      204747             Date 02May02              */
002800200603/*                      201230             Date 21Jan02              */
002900200603/* Midas Release 4 --------------- Base -----------------------------*/
003000200603/*                      CSE028             Date 06Jun01              */
003100200603/* Midas DBA 3.05 ---------------------------------------------------*/
003200200603/* Midas DBA 3.04 ---------------------------------------------------*/
003300200603/*                      186055             Date 06Nov00              */
003400200603/* Midas DBA 3.03 ---------------------------------------------------*/
003500200603/* Midas DBA 3.02 ---------------------------------------------------*/
003600200603/*                      CSE017             Date 20Oct99              */
003700200603/*                      CSE006             Date 25Jun99              */
003800200603/*                      CPB001             Date 02Jul99              */
003900200603/*                      CSE010           Date 21Jun99                */
004000200603/* Midas DBA 3.00 ---------------- Base -----------------------------*/
004100200603/*                        138957           Date 16Jul98             */
004200200603/*                        CEU017           Date 03Avr98             */
004300200603/*                        CSE007           Date 19Jan97             */
004400200603/*                        125378           DATE 11Feb98             */
004500200603/*                        S01408           DATE 10Feb98             */
004600200603/*                        103747           DATE 10APR97             */
004700200603/*                      . CSE003           DATE 11OCT96             */
004800200603/*                        S01408           DATE 30SEP96             */
004900200603/*                        S01408           DATE 26SEP96             */
005000200603/*                        S01408           DATE 21FEB96             */
005100200603/*                        084923           DATE 13APR95             */
005200200603/*                        080065           DATE 12DEC94             */
005300200603/*                        S01496           DATE 24OCT94             */
005400200603/*                        S01486           DATE 18OCT94             */
005500200603/*                        S01502           DATE 12DEC94             */
005600200603/*                        S01464           DATE 04APR94             */
005700200603/*                        S01446           DATE 07OCT93             */
005800200603/*                        S01401           DATE 16JUN93             */
005900200603/*                        S01220           DATE 21FEB91             */
006000200603/*                        E24417           DATE 14FEB91             */
006100200603/*                        S01322             DATE  31JAN91          */
006200200603/*                        S01117             DATE  10DEC90          */
006300200603/*                        S01269             DATE  10JUL90          */
006400200603/*                        E23408             DATE  06SEP90          */
006500200603/*                        E21717             DATE  25APR90          */
006600200603/*                        E17618             DATE  06/04/89         */
006700200603/*                        E16096             DATE  23/03/89         */
006800200603/*                        E16870             DATE  08/03/89         */
006900200603/*                        S01176             DATE  24/08/88         */
007000200603/*                        E13952             DATE  09/08/88         */
007100200603/*                        S01169             DATE  10/06/88         */
007200200603/*                        S01129             DATE  11/05/88         */
007300200603/*-------------------------------------------------------------------*/
007400200603/*                                                                   */
007500200603/*       MD032160 - upgrade selected fixes from UBS-TPE MP1.2.1 to   */
007600200603/*                 UBS-TPE 2.1 SP22.                                 */
007700200603/*                 Apply fix AR586601                                */
007800200603/*       AR586601 - Corrected the position of CHGJOB command         */
007900200603/*                  introduced by CPB001. Applied fix AR575736.      */
008000200604/*       259607 - Add override to file SECNTRL0 if calling           */
008100200604/*                SE1910.                                            */
008200200603/*       MD046248 - Finastra Rebranding                              */
008300200603/*       CSD031 - Enhanced Centralised Static Data                   */
008400200603/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
008500200603/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
008600200603/*                OUTQ must always be *JOBD.                         */
008700200603/*       CGP001 - Global Processing                                  */
008800200603/*       213041 - DB error on SE0180 due to missing file TRADSDZ2.   */
008900200603/*       208189 - CPF5123 received on POSET1 if CSE023 is *ON        */
009000200603/*       204747 - Check on CSE028                                    */
009100200603/*       201230 - Add override to file DPTMVDZ3 to file DPTMVDY2,    */
009200200603/*                if calling SE0070 as this also calls SE1807.       */
009300200603/*       CSE028 - Standing Settlement Instructions Enhancement       */
009400200603/*       186055 - All sort of errors are being encountered in        */
009500200603/*                Position Settlement Maintenace                     */
009600200603/*                (For CSE023 - Treaty Withholding Tax)              */
009700200603/*       CSE017 - Cum/Ex Indicator on Depot Movements (Recompiled)   */
009800200603/*       CSE006 - Repo Enhancement                                   */
009900200603/*       CPB001 - 'Private Banking' Module                           */
010000200603/*       CSE010 - SE Transaction Enhancement                         */
010100200603/*       138957 - Corporate Actions: Review information passed to  */
010200200603/*                RPG/SE0040 (Security Details Maintenance) for a  */
010300200603/*                Name Change event where the Security Shortname   */
010400200603/*                is being changed (when F15 is pressed).          */
010500200603/*       CEU017 - Securities Redenomination Euro Changes           */
010600200603/*       CSE007 - Corporate Actions                                */
010700200603/*       125378 - Add OVRDBF CPOSN SHARE(*NO) if calling SE0190    */
010800200603/*                as this also calls SE0050 (for S01496)           */
010900200603/*       S01408 - Addition of core hook SEC02024 (manually)        */
011000200603/*              - Addition of core hook SEC02023 (manually)        */
011100200603/*              - Addition of core hook SEC02MP2 (manually)        */
011200200603/*              - Addition of core hook SEC02MP1 (manually)        */
011300200603/*       103747 - Check whether PF/SEACKD is allocated to another  */
011400200603/*                job.                                             */
011500200603/*       CSE003 - '?' processing for Security Shortname in SE0050, */
011600200603/*                SE0070 and SE0170.                               */
011700200603/*       S01408 - Addition of core hook SEC02004                   */
011800200603/*       S01408 - Addition of core hook SEC02003                   */
011900200603/*       S01408 - Addition of core hook SEC02001                   */
012000200603/*                Addition of core hook SEC02002                   */
012100200603/*       084923 - Send 'MIDAS' message to MSTATUS to balance with  */
012200200603/*                MIDASRMV CALL, which otherwise removes a message */
012300200603/*                sent by another job.                             */
012400200603/*       080065 - PM & LB wrongly conditionned in SEC02            */
012500200603/*       S01496 - Incorp. of Private Bank. SE Enhancements (S10978)*/
012600200603/*       S01486 - Portfolio Management Enhancement                 */
012700200603/*       S01502 - BLI Telekurs Processing.                         */
012800200603/*                SESTAT increased in length from 128 to 133 bytes */
012900200603/*       S01464 - Safe Custody Fees.                               */
013000200603/*       S01446 - Customer Commissions (Courtage)                  */
013100200603/*       S01401 - SWIFT Messages MT5xxs : override files for       */
013200200603/*                retrieval in :-                                  */
013300200603/*                         (1) SE1805/SE1806 (called by SE0050).   */
013400200603/*                              (which may be called by SE0190).   */
013500200603/*                         (2) SE1817        (called by SE0170).   */
013600200603/*                         (3) SE1807/SE1808 (called by SE0070).   */
013700200603/*              - To submit confirmations to batch if Trades       */
013800200603/*                or Depot Movements just maintained.              */
013900200603/*       S01220 - Amendment for linked enquiry from Risk Management*/
014000200603/*                Data area creation parameters changed.           */
014100200603/*       E24417  - SE0140 NOW REDUNDANT                             */
014200200603/*       S01322 - REMOVAL OF RT BOND                               */
014300200603/*       S01117 - MULTIBRANCHING                                   */
014400200603/*       S01269 - NEW PROGRAMS ADDED AND NEW PARAMETERS PASSED     */ /*S01269*/
014500200603/*                TO SE0050 FOR TRADES AUTHORISATION               */ /*S01269*/
014600200603/*       E23408 - SETTLEMENT ACROSS RETAIL ACCOUNTS ALLOWED IF     */
014700200603/*                RETAIL II OR INTEREST ON ACCOUNTS INSTALLED -    */
014800200603/*                SETON U1 IF RE OR IA = 'Y'.                      */
014900200603/*       E21717 - ADD OVERRIDE FOR SEDEV IN SE0040                 */
015000200603/*       E17618 - ONLY CHECK FOR COMPLETION OF EXTEL PROCESSING    */
015100200603/*                IF EXTEL INTERFACE IS PRESENT.                   */
015200200603/*       E16096 - REMOVE OVERRIDE TO TRADS FOR SE0050              */
015300200603/*       E16870 - SESTAT REDEFINED AS 128 BYTES.                   */
015400200603/*       S01176 - SECURITIES TRADING 3.1 (AUSTRALIA)               */
015500200603/*       E13952 - OVERRIDE FOR CALL OF POSITION SETTLEMENTS        */
015600200603/*       S01169 - SECURITIES TRADING 3.1                           */
015700200603/*                  (BAER INCORPORATION)                           */
015800200603/*       S01129 - SE INCORPORATION                                 */
015900200603/*                                                                 */
016000200603/********************************************************************/
016100200603             PGM        PARM(&PARM)
016200200603/**/
016300200603             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
016400200603                          Finastra International Limited +
016500200603                          2001')
016600200603/**/                                                                  /*S01117*/
016700200603             DCL        VAR(&PARM) TYPE(*CHAR) LEN(8)
016800200603/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
016900200603             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
017000200603             DCL        VAR(&DL) TYPE(*LGL)
017100200603             DCL        VAR(&RE) TYPE(*LGL)
017200200603             DCL        VAR(&IA) TYPE(*LGL)                           /*E23408*/
017300200603             DCL        VAR(&EX) TYPE(*LGL)                           /*S01169*/
017400200603             DCL        VAR(&PM) TYPE(*LGL)                           /*S01486*/
017500200603             DCL        &EXST  *CHAR   1          /* Extel status        */
017600200603/**/
017700200603             DCL       VAR(&LDA)   TYPE(*CHAR)  LEN(256)
017800200603             DCL       VAR(&MMOD)  TYPE(*CHAR)  LEN(256)
017900200603/*           DCL       VAR(&SESTAT) TYPE(*CHAR)  LEN(256)       /*S01169E16870*/
018000200603/************DCL       VAR(&SESTAT) TYPE(*CHAR)  LEN(128)         E16870S01502*/
018100200603             DCL       VAR(&SESTAT) TYPE(*CHAR)  LEN(133)             /*S01502*/
018200200603/**/                                                                  /*S01496*/
018300200603             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01496*/
018400200603             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S01496*/
018500200603             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*S01496*/
018600200603             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*S01496*/
018700200603             DCL        VAR(&S01496) TYPE(*CHAR) LEN(1)               /*S01496*/
018800200603             DCL       VAR(&FMT) TYPE(*CHAR) LEN(800)                 /*080065*/
018900200603             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)             /*103747*/
019000200603             DCL        VAR(&CSE007) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSE007*/
019100200603             DCL        VAR(&CEU017) TYPE(*CHAR) LEN(1) VALUE('N')    /*CEU017*/
019200200603             DCL        VAR(&CSE010) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSE010*/
019300200603             DCL        VAR(&CSE006) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSE007*/
019400200603             DCL        VAR(&CSE023) TYPE(*CHAR) LEN(1) VALUE('N')    /*186055*/
019500200603             DCL        VAR(&CSE028) TYPE(*CHAR) LEN(1) VALUE('N')    /*204747*/
019600200603             DCL        VAR(&CGP001) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CGP001*/
019700200603             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1)                                   /*CRE020*/
019800200603             DCL        VAR(&PMOD) TYPE(*CHAR) LEN(10)                                    /*CRE020*/
019900200603             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(50)                                    /*CRE020*/
020000200603/*/COPY WNCPYSRC,SEC02005                                            */
020100200603/**/                                                                  /*S01496*/
020200200603             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01496*/
020300200603             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*S01496*/
020400200603             CHGVAR     VAR(&SAR) VALUE('S01496')                     /*S01496*/
020500200603             CHGVAR     VAR(&S01496) VALUE('N')                       /*S01496*/
020600200603/**/                                                                  /*S01496*/
020700200603/**  Check if Jyske Enhancements is installed */                      /*S01496*/
020800200603/**/                                                                  /*S01496*/
020900200603             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*S01496*/
021000200603             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*S01496*/
021100200603                CHGVAR     VAR(&S01496) VALUE('Y')                    /*S01496*/
021200200603             ENDDO                                                    /*S01496*/
021300200603/* Check if 'Corporate Actions' is *ON */                             /*CSE007*/
021400200603             CHGVAR     VAR(&SAR) VALUE('CSE007')                     /*CSE007*/
021500200603             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSE007*/
021600200603             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CSE007*/
021700200603                                                                      /*CSE007*/
021800200603             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CSE007*/
021900200603                  CHGVAR     VAR(&CSE007) VALUE('Y')                  /*CSE007*/
022000200603             ENDDO                                                    /*CSE007*/
022100200603                                                                      /*CSE006*/
022200200603/* Check if 'Repo Enhancement' is *ON */                              /*CSE006*/
022300200603             CHGVAR     VAR(&SAR) VALUE('CSE006')                     /*CSE006*/
022400200603             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSE006*/
022500200603             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CSE006*/
022600200603                                                                      /*CSE006*/
022700200603             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CSE006*/
022800200603                  CHGVAR     VAR(&CSE006) VALUE('Y')                  /*CSE006*/
022900200603             ENDDO                                                    /*CSE006*/
023000200603                                                                      /*CEU017*/
023100200603/* Check if 'Securities Redenomination is *ON */                      /*CEU017*/
023200200603             CHGVAR     VAR(&SAR) VALUE('CEU017')                     /*CEU017*/
023300200603             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CEU017*/
023400200603             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CEU017*/
023500200603                                                                      /*CEU017*/
023600200603             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CEU017*/
023700200603                  CHGVAR     VAR(&CEU017) VALUE('Y')                  /*CEU017*/
023800200603             ENDDO                                                    /*CEU017*/
023900200603                                                                      /*CEU017*/
024000200603             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CEU017*/
024100200603                                                                      /*CEU017*/
024200200603/*/COPY WNCPYSRC,SEC02006                                            */
024300200603/**/                                                                  /*CSE010*/
024400200603/**  Check if Transaction Enhancements is installed */                /*CSE010*/
024500200603/**/                                                                  /*CSE010*/
024600200603             CHGVAR     VAR(&SAR) VALUE('CSE010')                     /*CSE010*/
024700200603             CHGVAR     VAR(&CSE010) VALUE('N')                       /*CSE010*/
024800200603/**/                                                                  /*CSE010*/
024900200603             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CSE010*/
025000200603             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CSE010*/
025100200603                CHGVAR     VAR(&CSE010) VALUE('Y')                    /*CSE010*/
025200200603             ENDDO                                                    /*CSE010*/
025300200603/**/                                                                  /*CSE010*/
025400200603             IF         COND(&CSE010 *EQ 'Y') THEN(DO)                /*CSE010*/
025500200603                OVRDBF     FILE(SECTYZ1) TOFILE(SECTY) SHARE(*NO)     /*CSE010*/
025600200603                OVRDBF     FILE(SECTYZ2) TOFILE(SECTY) SHARE(*NO)     /*CSE010*/
025700200603                OVRDBF     FILE(SECTYZ3) TOFILE(SECTY) SHARE(*NO)     /*CSE010*/
025800200603                OVRDBF     FILE(TRADSX1) TOFILE(TRADS) SHARE(*NO)     /*CSE010*/
025900200603                OVRDBF     FILE(DPMVX)   TOFILE(DPMV)  SHARE(*NO)     /*CSE010*/
026000200603                OVRDBF     FILE(SECTYX)  TOFILE(SECTY) SHARE(*NO)     /*CSE010*/
026100200603             ENDDO                                                    /*CSE010*/
026200200603/**/                                                                  /*186055*/
026300200603/* Check if CSE023 is installed */                                    /*186055*/
026400200603/**/                                                                  /*186055*/
026500200603             CHGVAR     VAR(&SAR) VALUE('CSE023')                     /*186055*/
026600200603             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*186055*/
026700200603             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*186055*/
026800200603             CHGVAR     VAR(&CSE023) VALUE('N')                       /*186055*/
026900200603             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*186055*/
027000200603             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*186055*/
027100200603                CHGVAR     VAR(&CSE023) VALUE('Y')                    /*186055*/
027200200603             ENDDO                                                    /*186055*/
027300200603/**/                                                                  /*204747*/
027400200603/* Check if CSE028 is installed */                                    /*204747*/
027500200603/**/                                                                  /*204747*/
027600200603             CHGVAR     VAR(&SAR) VALUE('CSE028')                     /*204747*/
027700200603             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*204747*/
027800200603             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*204747*/
027900200603/**********  CHGVAR     VAR(&CSE023) VALUE('N')                                /*204747*/ /*208189*/
028000200603             CHGVAR     VAR(&CSE028) VALUE('N')                                           /*208189*/
028100200603             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*204747*/
028200200603             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*204747*/
028300200603                CHGVAR     VAR(&CSE028) VALUE('Y')                    /*204747*/
028400200603             ENDDO                                                    /*204747*/
028500200603                                                                                          /*CRE020*/
028600200603/* Check if CRE020 is enabled. */                                                         /*CRE020*/
028700200603                                                                                          /*CRE020*/
028800200603             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CRE020*/
028900200603             CHGVAR     VAR(&SAR)  VALUE('CRE020')                                        /*CRE020*/
029000200603             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CRE020*/
029100200603             CHGVAR     VAR(&CRE020) VALUE('N')                                           /*CRE020*/
029200200603             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CRE020*/
029300200603                                                                                          /*CRE020*/
029400200603             IF         COND(&RTCD  *NE '       ' *AND &RTCD  *NE +
029500200603                          '*NRF   ') THEN(DO)                                             /*CRE020*/
029600200603               GOTO   CMDLBL(ERR)                                                         /*CRE020*/
029700200603             ENDDO                                                                        /*CRE020*/
029800200603                                                                                          /*CRE020*/
029900200603             IF COND(&RTCD *EQ '       ') THEN(DO)                                        /*CRE020*/
030000200603             CHGVAR     VAR(&CRE020) VALUE('Y')                                           /*CRE020*/
030100200603             ENDDO                                                                        /*CRE020*/
030200200603/**/                                                                                      /*CGP001*/
030300200603/* Check if CGP001 is enabled */                                                          /*CGP001*/
030400200603/**/                                                                                      /*CGP001*/
030500200603             CHGVAR     VAR(&SAR) VALUE('CGP001')                                         /*CGP001*/
030600200603             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CGP001*/
030700200603             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CGP001*/
030800200603             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CGP001*/
030900200603             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CGP001*/
031000200603                CHGVAR     VAR(&CGP001) VALUE('Y')                                        /*CGP001*/
031100200603             ENDDO                                                                        /*CGP001*/
031200200603/**/                                                                  /*S01486*/
031300200603             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*080052*/
031400200603             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*S01486*/
031500200603/**/                                                                  /*S01486*/
031600200603/**/
031700200603             CHGJOB SWS(00000000)
031800200603/**/
031900200603             RTVDTAARA MMOD RTNVAR(&MMOD)
032000200603             CHGVAR &DL VALUE(%SST(&MMOD 2 1) *EQ 'Y')
032100200603             CHGVAR &RE VALUE(%SST(&MMOD 16 1) *EQ 'Y')
032200200603             CHGVAR &IA VALUE(%SST(&MMOD 23 1) *EQ 'Y')               /*E23408*/
032300200603/*********** CHGVAR &PM VALUE(%SST(&MMOD 75 1) *EQ 'Y')       /*S01486  080065*/
032400200603             IF &DL CHGJOB SWS(X1000000)
032500200603             IF COND(&RE *OR &IA) THEN(CHGJOB SWS(1X000000))          /*E23408*/
032600200603/************IF*&RE*CHGJOB*SWS(1X000000)                          **/ /*E23408*/
032700200603/*********** IF &PM CHGJOB SWS(XXX1XXXX)                     /*S01486   080065*/
032800200603/*********** IF         COND(%SST(&FMT 65 1) *NE 'Y') THEN(CHGJOB +
032900200603                          SWS(XXX1XXXX))                ***********/  /*080065*/
033000200603             IF         COND(%SST(&FMT 65 1) *EQ 'Y') THEN(CHGJOB +
033100200603                          SWS(XXX1XXXX))                              /*080065*/
033200200603/**/                                                                  /*S01169*/
033300200603             RTVDTAARA SESTAT RTNVAR(&SESTAT)                         /*S01169*/
033400200603             CHGVAR &EX VALUE(%SST(&SESTAT 63 1) *EQ 'Y')             /*S01169*/
033500200603             IF &EX CHGJOB SWS(XX100000)                              /*S01169*/
033600200603/*/COPY WNCPYSRC,SEC02022                                            */
033700200603/**/
033800200603/* PERFORM FILE OVERIDE DEPENDING ON PROGRAM TO BE CALLED           */
033900200603             IF COND(&PARM = 'SE6020') THEN(DO)                       /*S01464*/
034000200603                OVRDBF     FILE(SECFGRXX) TOFILE(SECFGRPD) SHARE(*NO) /*S01464*/
034100200603                GOTO CALLP                                            /*S01464*/
034200200603             ENDDO                                                    /*S01464*/
034300200603             IF COND(&PARM = 'SE6030') THEN(DO)                       /*S01464*/
034400200603                OVRDBF     FILE(SECICFXX) TOFILE(SECICFPD) SHARE(*NO) /*S01464*/
034500200603                GOTO CALLP                                            /*S01464*/
034600200603             ENDDO                                                    /*S01464*/
034700200603             IF COND(&PARM = 'SE6040') THEN(DO)                       /*S01464*/
034800200603                OVRDBF     FILE(SESCFAXX) TOFILE(SESCFAPD) SHARE(*NO) /*S01464*/
034900200603                GOTO CALLP                                            /*S01464*/
035000200603             ENDDO                                                    /*S01464*/
035100200603             IF COND(&PARM = 'SE6050') THEN(DO)                       /*S01464*/
035200200603                OVRDBF     FILE(SESCFAXX) TOFILE(SESCFAPD) SHARE(*NO) /*S01464*/
035300200603                OVRDBF     FILE(SEOCFSXX) TOFILE(SEOCFSPD) SHARE(*NO) /*S01464*/
035400200603                GOTO CALLP                                            /*S01464*/
035500200603             ENDDO                                                    /*S01464*/
035600200603             IF COND(&PARM = 'SE6070') THEN(DO)                       /*S01464*/
035700200603                OVRDBF     FILE(SECGCDXX) TOFILE(SECGCDPD) SHARE(*NO) /*S01464*/
035800200603                GOTO CALLP                                            /*S01464*/
035900200603             ENDDO                                                    /*S01464*/
036000200603             IF COND(&PARM = 'SE5010') THEN(DO)                       /*S01176*/
036100200603                OVRDBF     FILE(CPPRIX) TOFILE(CPPRID) SHARE(*NO)     /*S01176*/
036200200603                GOTO CALLP                                            /*S01176*/
036300200603             ENDDO                                                    /*S01176*/
036400200603             IF COND(&PARM = 'SE0010') THEN(DO)
036500200603                OVRDBF     FILE(SEMKCX) TOFILE(SEMKC) SHARE(*NO)
036600200603                GOTO CALLP
036700200603             ENDDO
036800200603             IF COND(&PARM = 'SE0020') THEN(DO)
036900200603                OVRDBF     FILE(INVTPX) TOFILE(INVTP) SHARE(*NO)
037000200603             IF COND(&CGP001 *EQ 'Y') THEN(DO)                                            /*CGP001*/
037100200603                OVRDBF     FILE(GPPRDXL0) TOFILE(GPPRODXL0)                               /*CGP001*/
037200200603                OVRDBF     FILE(GPINSXL0) TOFILE(GPINSTXL0)                               /*CGP001*/
037300200603             ENDDO                                                                        /*CGP001*/
037400200603                GOTO CALLP
037500200603             ENDDO
037600200603             IF COND(&PARM = 'SE0030') THEN(DO)
037700200603             IF COND(&CSE028 = 'N') THEN(DO)                          /*204747*/
037800200603                OVRDBF     FILE(STDSEX) TOFILE(STDSED) SHARE(*NO)
037900200603             ENDDO                                                    /*204747*/
038000200603             IF COND(&CSE028 = 'Y') THEN(OVRDBF FILE(STDSEX) +
038100200603                          TOFILE(STDSEL1) SHARE(*NO))                 /*204747*/
038200200603                OVRDBF FILE(STDSED) SHARE(*NO)                        /*CSE028*/
038300200603                OVRDBF FILE(STDADSL2) SHARE(*NO)                      /*CSE028*/
038400200603                GOTO CALLP
038500200603             ENDDO
038600200603/*/COPY WNCPYSRC,SEC02014                                            */
038700200603/************IF COND(&PARM = 'SE0040') THEN(DO)***/                   /*CSE010*/
038800200603             IF COND((&PARM = 'SE0040') *OR (&PARM = 'SE0043')) +
038900200603                THEN(DO)                                              /*CSE010*/
039000200603/*/COPY WNCPYSRC,SEC02015                                            */
039100200603             IF &EX THEN(DO)                                          /*E17618*/
039200200603        RTVDTAARA  DTAARA(EXSTAT (76 1)) RTNVAR(&EXST)                /*S01169*/
039300200603        IF    COND((&EXST *NE 'A') *AND (&EXST *NE 'T') *AND (&EXST +
039400200603                  *NE 'C') *AND (&EXST *NE 'F'))      THEN(DO)        /*S01169*/
039500200603              SNDPGMMSG  MSG('Option unavailable - EXTEL processing +
039600200603                  not complete') TOPGMQ(*EXT) TOMSGQ(MOPERQ)          /*S01169*/
039700200603              GOTO  ENDPGM                                            /*S01169*/
039800200603              ENDDO                                                   /*S01169*/
039900200603              ENDDO                                                   /*E17618*/
040000200603/************IF         COND(&CSE007 *EQ 'Y') THEN(DO)         /*CSE007 CEU017*/
040100200603             IF         COND((&CSE007 *EQ 'Y') *OR +
040200200603                            (&CEU017 *EQ 'Y')) THEN(DO)               /*CEU017*/
040300200603             OVRDBF     FILE(SECED) SHARE(*NO)                        /*CSE007*/
040400200603             ENDDO                                                    /*CSE007*/
040500200603/**/                                                                  /*S01408*/
040600200603/*/COPY WNCPYSRC,SEC02003                                            */
040700200603/**/                                                                  /*S01408*/
040800200603             IF COND(&CSE010 *EQ 'N') THEN(DO)                        /*CSE010*/
040900200603                OVRDBF     FILE(SECTYX) TOFILE(SECTY) SHARE(*NO)
041000200603                OVRDBF     FILE(SEDEVX) TOFILE(SEDEV) SHARE(*NO)      /*E21717*/
041100200603/*/COPY WNCPYSRC,SEC02016                                            */
041200200603             ENDDO                                                    /*CSE010*/
041300200603                GOTO CALLP
041400200603             ENDDO
041500200603                                                                      /*CSE003*/
041600200603/* Data area SESDS used in SE0050, SE0070 and SE0170.                 **CSE003*/
041700200603/* It holds parameters returned from SE0240.                          **CSE003*/
041800200603/*/COPY WNCPYSRC,SEC02027                                            */
041900200603             IF         COND((&PARM *EQ 'SE0050') *OR (&PARM *EQ +
042000200603                          'SE0070') *OR (&PARM *EQ 'SE0170')) +
042100200603                          THEN(DO)                                    /*CSE003*/
042200200603/*/COPY WNCPYSRC,SEC02028                                            */
042300200603                CHKOBJ     OBJ(SESDS) OBJTYPE(*DTAARA)                /*CSE003*/
042400200603                MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
042500200603                             DTAARA(QTEMP/SESDS) TYPE(*CHAR) LEN(37)) /*CSE003*/
042600200603/*/COPY WNCPYSRC,SEC02MP1                                            */
042700200603                CHGDTAARA  DTAARA(SESDS) VALUE(' ')                   /*CSE003*/
042800200603                CHGDTAARA  DTAARA(SESDS (1 8)) VALUE(&PARM)           /*CSE003*/
042900200603                CHGDTAARA  DTAARA(SESDS (13 6)) VALUE('000000')       /*CSE003*/
043000200603/*/COPY WNCPYSRC,SEC02MP2                                            */
043100200603              ENDDO                                                   /*CSE003*/
043200200603                                                                      /*CSE003*/
043300200603             IF         COND(&PARM = 'SE0180') THEN(DO)                                  /*213041*/
043400200603                  OVRDBF     FILE(TRADSDZ2) TOFILE(TRADSDY2) SHARE(*NO)                  /*213041*/
043500200603                  GOTO       CMDLBL(CALLP)                                               /*213041*/
043600200603             ENDDO                                                                       /*213041*/
043700200603                                                                                         /*213041*/
043800200603/*/COPY WNCPYSRC,SEC02017                                            */
043900200603             IF COND(&PARM = 'SE0050') THEN(DO)
044000200603/*/COPY WNCPYSRC,SEC02018                                            */
044100200603/***************OVRDBF     FILE(TRADSX) TOFILE(TRADS) SHARE(*NO)****** E16096 */
044200200603/***************OVRDBF     FILE(CLINTX) TOFILE(CLINT) SHARE(*NO)     * *S01117*/
044300200603                OVRDBF FILE(TRADSDZ1) TOFILE(TRADSDY1) SHARE(*NO)     /*S01401*/
044400200603                OVRDBF FILE(TRADSDZ2) TOFILE(TRADSDY2) SHARE(*NO)     /*S01401*/
044500200603/*/COPY WNCPYSRC,SEC02033                                            */
044600200603                IF         COND(&S01496 *EQ 'Y') THEN(DO)             /*S01496*/
044700200603                   OVRDBF     FILE(CPOSN) SHARE(*NO)                  /*S01496*/
044800200603                ENDDO                                                 /*S01496*/
044900200603                                                                      /*CSE003*/
045000200603/* Data area SESDS used in SE0050, SE0070 and SE0170.                 **CSE003*/
045100200603/* It holds parameters returned from SE0240.                          **CSE003*/
045200200603                CHKOBJ     OBJ(SESDS) OBJTYPE(*DTAARA)                /*CSE003*/
045300200603                MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
045400200603                             DTAARA(QTEMP/SESDS) TYPE(*CHAR) LEN(37)) /*CSE003*/
045500200603/*/COPY WNCPYSRC,SEC02023                                            */
045600200603                CHGDTAARA  DTAARA(SESDS) VALUE(' ')                   /*CSE003*/
045700200603                CHGDTAARA  DTAARA(SESDS (1 8)) VALUE('SE0050')        /*CSE003*/
045800200603                CHGDTAARA  DTAARA(SESDS (13 6)) VALUE('000000')       /*CSE003*/
045900200603                                                                      /*CSE003*/
046000200603/*/COPY WNCPYSRC,SEC02024                                            */
046100200603                GOTO CALLP
046200200603             ENDDO
046300200603             IF COND(&PARM = 'SE0060') THEN(DO)
046400200603                OVRDBF     FILE(TRADSX) TOFILE(TRADS) SHARE(*NO)
046500200603                GOTO CALLP
046600200603             ENDDO
046700200603/*/COPY WNCPYSRC,SEC02029                                            */
046800200603             IF COND(&PARM = 'SE0070') THEN(DO)
046900200603/*/COPY WNCPYSRC,SEC02021                                            */
047000200603                OVRDBF     FILE(DPTMVX) TOFILE(DPTMV) SHARE(*NO)
047100200603                OVRDBF FILE(DPTMVDY1) SHARE(*NO)                      /*CSE028*/
047200200603                OVRDBF FILE(DPTMVDZ1) TOFILE(DPTMVDY1) SHARE(*NO)     /*S01401*/
047300200603                OVRDBF FILE(DPTMVDZ2) TOFILE(DPTMVDY2) SHARE(*NO)     /*S01401*/
047400200603                OVRDBF FILE(DPTMVDZ3) TOFILE(DPTMVDY2) SHARE(*NO)                         /*201230*/
047500200603/*/COPY WNCPYSRC,SEC02034                                            */
047600200603                IF         COND(&S01496 *EQ 'Y') THEN(DO)             /*S01496*/
047700200603                   OVRDBF     FILE(CPOSN) SHARE(*NO)                  /*S01496*/
047800200603                ENDDO                                                 /*S01496*/
047900200603                IF         COND(&CSE006 *EQ 'Y') THEN(DO)             /*CSE006*/
048000200603             OVRDBF     FILE(SEDPMVL1) TOFILE(SEDPMVL2) SHARE(*NO)    /*CSE006*/
048100200603                ENDDO                                                 /*CSE006*/
048200200603                GOTO CALLP
048300200603             ENDDO
048400200603             IF COND(&PARM = 'SE0080') THEN(DO)
048500200603             IF &EX THEN(DO)                                          /*E17618*/
048600200603        RTVDTAARA  DTAARA(EXSTAT (76 1)) RTNVAR(&EXST)                /*S01169*/
048700200603        IF    COND((&EXST *NE 'A') *AND (&EXST *NE 'T') *AND (&EXST +
048800200603                  *NE 'C') *AND (&EXST *NE 'F'))      THEN(DO)        /*S01169*/
048900200603              SNDPGMMSG  MSG('Option unavailable - EXTEL processing +
049000200603                  not complete') TOPGMQ(*EXT) TOMSGQ(MOPERQ)          /*S01169*/
049100200603              GOTO  ENDPGM                                            /*S01169*/
049200200603              ENDDO                                                   /*S01169*/
049300200603              ENDDO                                                   /*E17618*/
049400200603                OVRDBF     FILE(PRICEX) TOFILE(PRICE) SHARE(*NO)
049500200603                OVRDBF     FILE(EXVALDX) TOFILE(EXVALD) SHARE(*NO)    /*S01169*/
049600200603                GOTO CALLP
049700200603             ENDDO
049800200603             IF COND(&PARM = 'SE0090') THEN(DO)
049900200603                OVRDBF     FILE(TRADSX) TOFILE(TRADS) SHARE(*NO)
050000200603/***************OVRDBF     FILE(CLINTX) TOFILE(CLINT) SHARE(*NO)     * *S01117*/
050100200603                GOTO CALLP
050200200603             ENDDO
050300200603/**/                                                                  /*103747*/
050400200603/** Check if file is being used by another workstation             */ /*103747*/
050500200603/**/                                                                  /*103747*/
050600200603             IF         COND(&PARM *EQ 'SE0110') THEN(DO)             /*103747*/
050700200603             ALCOBJ     OBJ((SEACKD *FILE *SHRRD)) WAIT(0)            /*103747*/
050800200603             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(MSG))         /*103747*/
050900200603             DLCOBJ     OBJ((SEACKD *FILE *SHRRD))                    /*103747*/
051000200603             ALCOBJ     OBJ((XSEACKD *FILE *SHRRD)) WAIT(0)           /*103747*/
051100200603             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(MSG))         /*103747*/
051200200603             DLCOBJ     OBJ((XSEACKD *FILE *SHRRD))                   /*103747*/
051300200603             GOTO       CMDLBL(CONTINUE)                              /*103747*/
051400200603 MSG:                                                                 /*103747*/
051500200603             RTVMSG     MSGID(SCM0113) MSGF(MIDASMSG) MSG(&MESSAGE)   /*103747*/
051600200603             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)     /*103747*/
051700200603             RTVMSG     MSGID(SCM0087) MSGF(MIDASMSG) MSG(&MESSAGE)   /*103747*/
051800200603             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)     /*103747*/
051900200603             CHGDTAARA  DTAARA(MIDASMSG (10 1)) VALUE('1')            /*103747*/
052000200603             CALL       PGM(SCC0010) PARM('SEC02  ' 'ENTER' ' ')      /*103747*/
052100200603             GOTO       CMDLBL(ENDPGM)                                /*103747*/
052200200603 CONTINUE:                                                            /*103747*/
052300200603             GOTO       CMDLBL(CALLP)                                 /*103747*/
052400200603             ENDDO                                                    /*103747*/
052500200603    /*       IF COND(&PARM = 'SE0120') THEN(DO)                  */  /*S01169*/
052600200603             IF COND(&PARM = 'SE0121') THEN(DO)                      /*S01169*/
052700200603    /*          OVRDBF     FILE(SECHGX) TOFILE(SECHG) SHARE(*NO) */  /*S01169*/
052800200603                OVRDBF     FILE(SECGTX) TOFILE(SECGT) SHARE(*NO)     /*S01169*/
052900200603                OVRDBF     FILE(SECGTX2) TOFILE(SECGT) SHARE(*NO)    /*S01446*/
053000200603/*/COPY WNCPYSRC,SEC02007                                            */
053100200603                GOTO CALLP
053200200603             ENDDO
053300200603             IF COND(&PARM = 'SE0130') THEN(DO)
053400200603/*/COPY WNCPYSRC,SEC02008                                            */
053500200603                OVRDBF     FILE(SEDEVX) TOFILE(SEDEV) SHARE(*NO)
053600200603                GOTO CALLP
053700200603             ENDDO
053800200603 /***********IF COND(&PARM = 'SE0140') THEN(DO)                    */ /*E24417*/
053900200603 /***********   OVRDBF     FILE(SLIMDX) TOFILE(SLIMD) SHARE(*NO)   */ /*E24417*/
054000200603 /***********   GOTO CALLP                                         */ /*E24417*/
054100200603 /***********ENDDO                                                 */ /*E24417*/
054200200603             IF COND(&PARM = 'SE0141') THEN(DO)
054300200603                OVRDBF     FILE(SLIMEX) TOFILE(SLIME) SHARE(*NO)
054400200603                GOTO CALLP
054500200603             ENDDO
054600200603             IF COND(&PARM = 'SE0142') THEN(DO)
054700200603                OVRDBF     FILE(SLIMFX) TOFILE(SLIMF) SHARE(*NO)
054800200603                GOTO CALLP
054900200603             ENDDO
055000200603             IF COND(&PARM = 'SE0143') THEN(DO)
055100200603                OVRDBF     FILE(SLIMGX) TOFILE(SLIMG) SHARE(*NO)
055200200603                GOTO CALLP
055300200603             ENDDO
055400200603             IF COND(&PARM = 'SE0144') THEN(DO)
055500200603                OVRDBF     FILE(SLIMHX) TOFILE(SLIMH) SHARE(*NO)
055600200603                GOTO CALLP
055700200603             ENDDO
055800200603             IF COND(&PARM = 'SE0145') THEN(DO)
055900200603                OVRDBF     FILE(SLIMIX) TOFILE(SLIMI) SHARE(*NO)
056000200603                GOTO CALLP
056100200603             ENDDO
056200200603             IF COND(&PARM = 'SE0150') THEN(DO)
056300200603                OVRDBF     FILE(FUND1) TOFILE(FUNDS) SHARE(*NO)
056400200603                GOTO CALLP
056500200603             ENDDO
056600200603             IF COND(&PARM = 'SE0160') THEN(DO)
056700200603                OVRDBF     FILE(LMTPDX) TOFILE(LMTPD) SHARE(*NO)
056800200603                GOTO CALLP
056900200603             ENDDO
057000200603/*/COPY WNCPYSRC,SEC02032                                            */
057100200603             IF COND(&PARM = 'SE0170') THEN(DO)
057200200603/*              OVRDBF     FILE(POSETX) TOFILE(POSET) SHARE(*NO) */   /*E13952*/
057300200603/***************OVRDBF     FILE(POSET) TOFILE(POSET1) SHARE(*NO) E13952 S01117*/
057400200603/*/COPY WNCPYSRC,SEC02009                                            */
057500200603             IF         COND(&CSE023 *EQ 'Y') THEN(DO)                /*186055*/
057600200603                OVRDBF     FILE(POSETX) TOFILE(POSET7) SHARE(*NO)     /*186055*/
057700200603             ENDDO                                                    /*186055*/
057800200603             ELSE       CMD(DO)                                       /*186055*/
057900200603                OVRDBF     FILE(POSETX) TOFILE(POSET1) SHARE(*NO)     /*E13952*/
058000200603             ENDDO                                                    /*186055*/
058100200603                OVRDBF     FILE(POSETDZ1) TOFILE(POSETDY1) SHARE(*NO) /*S01401*/
058200200603                OVRDBF     FILE(POSETDZ2) TOFILE(POSETDY2) SHARE(*NO) /*S01401*/
058300200603/*/COPY WNCPYSRC,SEC02013                                            */
058400200603             ENDDO
058500200603         IF COND(&PARM = 'SE0190') THEN(DO)                           /*S01269*/
058600200603/*/COPY WNCPYSRC,SEC02025                                            */
058700200603/*  CHECK IF DTAARA/SESDS EXISTS. IF NOT, CREATE IT.                    S01269*/
058800200603             CHKOBJ     OBJ(SESDS) OBJTYPE(*DTAARA)                   /*S01269*/
058900200603             MONMSG     MSGID(CPF9800) EXEC(DO)                       /*S01269*/
059000200603                                                                      /*S01220*/
059100200603/************CRTDTAARA  DTAARA(QTEMP/SESDS) TYPE(*CHAR) LEN(36)*S01269**S01220*/
059200200603             CRTDTAARA  DTAARA(QTEMP/SESDS) TYPE(*CHAR) LEN(37)       /*S01220*/
059300200603                                                                      /*S01220*/
059400200603/************CHGDTAARA  DTAARA(SESDS (10 9)) VALUE('000000000')*S01269**S01117*/
059500200603             CHGDTAARA  DTAARA(SESDS (13 6)) VALUE('000000')          /*S01117*/
059600200603             ENDDO                                                    /*S01269*/
059700200603                                                                      /*S01269*/
059800200603/*  CLEAR DTAARA/SESDS AND SET ORIGINAL PGM. TO ENQUIRY PGM.            S01269*/
059900200603/*                     AND SET ZONED FIELDS                             S01269*/
060000200603             CHGDTAARA  DTAARA(SESDS (1 8)) VALUE(&PARM)              /*S01269*/
060100200603              OVRDBF     FILE(TRAUT) SHARE(*NO)                       /*S01269*/
060200200603              OVRDBF FILE(TRADSDZ1) TOFILE(TRADSDY1) SHARE(*NO)       /*S01401*/
060300200603              OVRDBF FILE(TRADSDZ2) TOFILE(TRADSDY2) SHARE(*NO)       /*S01401*/
060400200603              OVRDBF FILE(TRADSDY1) SHARE(*NO)                        /*CSE028*/
060500200603              OVRDBF FILE(SEPCBD) SHARE(*NO)                          /*CSE028*/
060600200603              OVRDBF FILE(SEPCCD) SHARE(*NO)                          /*CSE028*/
060700200603/*/COPY WNCPYSRC,SEC02035                                            */
060800200603                IF         COND(&S01496 *EQ 'Y') THEN(DO)             /*125378*/
060900200603                   OVRDBF     FILE(CPOSN) SHARE(*NO)                  /*125378*/
061000200603                ENDDO                                                 /*125378*/
061100200603/*************OVRDBF     FILE(CLINTX) TOFILE(CLINT) SHARE(*NO)*S01269* *S01117*/
061200200603             ENDDO                                                    /*S01269*/
061300200603/*           IF COND(&PARM = 'SE2010') THEN(DO)             S01129*/  /*S01322*/
061400200603/*              OVRDBF     FILE(SECTPX) TOFILE(SECTP) SHARE(*NO)      /*S01322*/
061500200603/*              GOTO CALLP                                  S01129*/  /*S01322*/
061600200603/*           ENDDO                                          S01129*/  /*S01322*/
061700200603/*           IF COND(&PARM = 'SE2011') THEN(DO)             S01129*/  /*S01322*/
061800200603/*              OVRDBF     FILE(TRADAX) TOFILE(TRADA) SHARE(*NO)      /*S01322*/
061900200603/*************OVRDBF     FILE(CLINTX) TOFILE(CLINT) SHARE(*NO)*S01129* *S01117*/
062000200603/*           ENDDO                                          S01129*/  /*S01322*/
062100200603/**/
062200200603CALLP:
062300200603             CHGDTAARA  DTAARA(LDA) VALUE(' ')
062400200603/**/
062500200603/*/COPY WNCPYSRC,SEC02019                                            */
062600200603/*****IF COND((&PARM='SE0050') *OR (&PARM='SE0180')) THEN(DO)*S01269****CSE010*/
062700200603/*/COPY WNCPYSRC,SEC02010                                            */
062800200603          IF COND((&PARM = 'SE0050') *OR (&PARM = 'SE0180') *OR +
062900200603             (&PARM = 'SE0043')) THEN(DO)                             /*CSE010*/
063000200603             CALL       PGM(&PARM) PARM(' ' '      ')                 /*S01269*/
063100200603             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)       /*S01269*/
063200200603                ROLLBACK                                              /*S01269*/
063300200603                SNDPGMMSG MSG('Transaction failed. Re-input +
063400200603                      necessary. Enter to continue.') TOPGMQ(*EXT)    /*S01269*/
063500200603                GOTO ENDPGM                                           /*S01269*/
063600200603               ENDDO                                                  /*S01269*/
063700200603/*/COPY WNCPYSRC,SEC02011                                            */
063800200603      ENDDO                                                           /*S01269*/
063900200603      ELSE       CMD(DO)                                              /*S01269*/
064000200603             IF COND(&PARM = 'SE0040') THEN(DO)                       /*CSE007*/
064100200603/******         CALL    PGM(&PARM) PARM(' ' ' ' ' ' ' ')  /*CSE007*/  /*138957*/
064200200603                CALL    PGM(&PARM) PARM(' ' ' ' ' ' ' ' ' ')          /*138957*/
064300200603                MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)    /*CSE007*/
064400200603                ROLLBACK                                              /*CSE007*/
064500200603                SNDPGMMSG MSG('Transaction failed. Re-input +
064600200603                      necessary. Enter to continue.') TOPGMQ(*EXT)    /*CSE007*/
064700200603                GOTO ENDPGM                                           /*CSE007*/
064800200603                ENDDO                                                 /*CSE007*/
064900200603/*/COPY WNCPYSRC,SEC02026                                            */
065000200603             ENDDO                                                    /*CSE007*/
065100200603             ELSE       CMD(DO)                                       /*CSE007*/
065200200603/*/COPY WNCPYSRC,SEC02012                                            */
065300200603             IF COND((%SST(&FMT 104 1) *EQ 'Y')) THEN(DO)             /*CPB001*/
065400200603                CHGJOB SWS(XXX1XXXX)                                  /*CPB001*/
065500200603             ENDDO      /*CPB001*/
065600200603             IF         COND(&PARM = 'SE1910') THEN(DO) /*259607*/
065700200603                OVRDBF     FILE(SECNTRLX) TOFILE(SECNTRL0) SHARE(*NO) /*259607*/
065800200603             ENDDO      /*259607*/
065900200603             CALL       PGM(&PARM)
066000200603/**********  CHGJOB SWS(XXX0XXXX) */                                             /*CPB001 AR586601*/
066100200603             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
066200200603                CHGJOB     SWS(XXX0XXXX) /*AR586601*/
066300200603                ROLLBACK
066400200603                SNDPGMMSG MSG('Transaction failed. Re-input +
066500200603                      necessary. Enter to continue.') TOPGMQ(*EXT)
066600200603                GOTO ENDPGM
066700200603             ENDDO      /*CSE007*/
066800200603             CHGJOB     SWS(XXX0XXXX) /*AR586601*/
066900200603/*/COPY WNCPYSRC,SEC02020                                            */
067000200603      ENDDO                                                           /*S01269*/
067100200603/**/                                                                  /*S01408*/
067200200603/*/COPY WNCPYSRC,SEC02004                                            */
067300200603/**/                                                                  /*S01408*/
067400200603             ENDDO
067500200603/**/
067600200603/*   FOR DATABASE ERRORS RECOVER DATA FROM LDA                      */
067700200603/**/
067800200603             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
067900200603                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
068000200603/***************CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))      */ /*S01117*/
068100200603                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))         /*S01117*/
068200200603                ROLLBACK
068300200603/*/COPY WNCPYSRC,SEC02030                                            */
068400200603                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
068500200603                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
068600200603/*/COPY WNCPYSRC,SEC02031                                            */
068700200603             ENDDO
068800200603/* */                                                                 /*S01401*/
068900200603/** else, if no errors and if Trades or Depot Movements just          /*S01401*/
069000200603/** maintained, then submit confirmations to batch.                   /*S01401*/
069100200603/* */                                                                 /*S01401*/
069200200603             ELSE (DO)                                                /*S01401*/
069300200603               IF ((&PARM *EQ 'SE0050') *OR (&PARM *EQ 'SE0070') +
069400200603                  *OR (&PARM *EQ 'SE0180') *OR (&PARM *EQ +
069500200603                  'SE0190')) THEN(DO)                                 /*S01401*/
069600200603/**/                                                                  /*S01408*/
069700200603/*/COPY WNCPYSRC,SEC02001                                            */
069800200603/**/                                                                  /*S01408*/
069900200603/**/                                                                  /*084923*/
070000200603                 SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)              /*084923*/
070100200603/**/                                                                  /*084923*/
070200200603/************    SBMJOB (SEC0304) JOBD(MBATCH) USER(*JOBD) +                              /*CSC023*/
070300200603/************           RTGDTA(*JOBD) RQSDTA('CALL SEC0304') +                            /*CSC023*/
070400200603/************           INLLIBL(*JOBD) MSGQ(MOPERQ)                   /*S01401*/          /*CSC023*/
070500200603/************    SBMJOB (MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                             /*CSC023*/
070600200603/************           RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                           /*CSC023*/
070700200603/************           INLLIBL(*JOBD) MSGQ(MOPERQ)                   /*S01401*/          /*CSC023*/
070800200603                 SBMJOB (SEC0304) JOBD(MBATCH) USER(*JOBD) +
070900200603                        RTGDTA(*JOBD) RQSDTA('CALL SEC0304') +
071000200603                        INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                           /*CSC023*/
071100200603                 SBMJOB (MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
071200200603                        RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
071300200603                        INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                           /*CSC023*/
071400200603/**/                                                                  /*S01408*/
071500200603/*/COPY WNCPYSRC,SEC02002                                            */
071600200603/**/                                                                  /*S01408*/
071700200603               ENDDO                                                  /*S01401*/
071800200603             ENDDO                                                    /*S01401*/
071900200603/**/
072000200603                                                                                          /*CRE020*/
072100200603/* Print Retail Advices if CRE020 is enabled. */                                          /*CRE020*/
072200200603                                                                                          /*CRE020*/
072300200603             IF         COND(%SWITCH(XXXXXX00) *AND +
072400200603                              &CRE020 *EQ 'Y') THEN(DO)                                   /*CRE020*/
072500200603                                                                                          /*CRE020*/
072600200603             CHGVAR     VAR(&PMOD) VALUE('          ')                                    /*CRE020*/
072700200603                                                                                          /*CRE020*/
072800200603             IF         COND(&PARM *EQ 'SE0070') THEN(DO)                                 /*CRE020*/
072900200603             CHGVAR     VAR(&PMOD) VALUE('SE0070')                                        /*CRE020*/
073000200603             ENDDO                                                                        /*CRE020*/
073100200603                                                                                          /*CRE020*/
073200200603             IF         COND(&PARM *EQ 'SE0170') THEN(DO)                                 /*CRE020*/
073300200603             CHGVAR     VAR(&PMOD) VALUE('SE0170')                                        /*CRE020*/
073400200603             ENDDO                                                                        /*CRE020*/
073500200603                                                                                          /*CRE020*/
073600200603             IF         COND((&PARM *EQ 'SE0180') *OR +
073700200603                             (&PARM *EQ 'SE0190')) THEN(DO)                               /*CRE020*/
073800200603             CHGVAR     VAR(&PMOD) VALUE('SETRADUPD')                                     /*CRE020*/
073900200603             ENDDO                                                                        /*CRE020*/
074000200603                                                                                          /*CRE020*/
074100200603             IF         COND(&PMOD *NE '          ') THEN(DO)                             /*CRE020*/
074200200603             CHGVAR     VAR(&PCMD) VALUE('CALL PGM(REC000881) PARM(''' +
074300200603                        *CAT &PMOD *CAT ''' ''SE'')')                                     /*CRE020*/
074400200603             SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
074500200603                        RTGDTA(*JOBD) RQSDTA(&PCMD) +
074600200603                        INLLIBL(*JOBD) MSGQ(MOPERQ)                                       /*CRE020*/
074700200603             ENDDO                                                                        /*CRE020*/
074800200603                                                                                          /*CRE020*/
074900200603             ENDDO                                                                        /*CRE020*/
075000200603             GOTO       CMDLBL(ENDPGM)                                                    /*CRE020*/
075100200603ERR:                                                                                      /*CRE020*/
075200200603             RCLACTGRP  ACTGRP(*ELIGIBLE)                                                 /*CRE020*/
075300200603             RCLRSC                                                                       /*CRE020*/
075400200603                                                                                          /*CRE020*/
075500200603             RETURN                                                                       /*CRE020*/
075600200603/**/
075700200603ENDPGM:      DLTOVR     *ALL
075800200603             CHGJOB     SWS(0XXXXXXX)                                                     /*CSD031*/
075900200603             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
076000200603                          Finastra International Limited')
076100200603             ENDPGM
