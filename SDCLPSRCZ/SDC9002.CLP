/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SD ICD maintenance control program')            */
/*********************************************************************/
/*                                                                   */
/*       Midas Standing Data Module                                  */
/*                                                                   */
/*       SDC9002 - I.C.D. MAINTENANCE CONTROL PROGRAM.               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. AR1062470          Date 29Nov12              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*                      245656             Date 12Feb07              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CDL013             Date 10Jul06              */
/*                      CGL032             Date 05Jul04              */
/*                      BUG2955            Date 28May04              */
/*                      CFX001             Date 20Oct03              */
/*                      CGL014             Date 20Oct03              */
/*                      CLE025             Date 20Oct03              */
/*                      CPK017             Date 13Oct03              */
/*                      CRE008             Date 19Feb02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CAS002             Date 14Jan02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CPB001             Date 03Jun99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAP006             Date 12FEB97              */
/*                      CTI001             Date 13AUG97              */
/*                      CGL004             DATE 04NOV97              */
/*                      CRT003             Date 22JUL96              */
/*                      CRT002             Date 13APR96              */
/*                      CAC001             Date 07MAR96              */
/*                      S01408             DATE 06FEB96              */
/*                      S01408             DATE 08SEP95              */
/*                      CRT001             DATE 06MAR95              */
/*                      S01505             DATE 20JUL94              */
/*                      S01486             DATE 19JUL94              */
/*                      S01493             DATE 23MAY94              */
/*                      S01413             DATE 31AUG93              */
/*                      S01421             DATE 06AUG93              */
/*                      S01393             DATE 09NOV92              */
/*                      S01379             DATE 16SEP92              */
/*                      S01339             DATE 21JUL92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR1062470 - System does not display ICD screens             */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       245656 - Submit job GLC000011 failed with authorisation     */
/*                issues                                             */
/*       CDL013 - Tiered Withholding Tax                             */
/*       CGL032 - Automatic Exchange of Information                  */
/*       BUG2955 - Perform lock on dataarea SDICDR.                  */
/*       CFX001 - FX Margin Trading                                  */
/*       CGL014 - Collaterals Processing                             */
/*       CLE025 - Credit Lines                                       */
/*       CPK017 - Midas Plus packaging.                              */
/*                Remove sending of 'ICDR' and checking of MSGQ      */
/*                MSTATUS for any active users.                      */
/*       CAS002 - Hedge Strategy/Linkage                             */
/*  CPB001 - Private Banking Module                                  */
/*  CAP006 - Application Program Interface                           */
/*  CTI001 - Midas / Trade Innovation Interface Phase 1              */
/*  CGL004 - Midas-Fontis Interface:                                 */
/*           Call SD9421R - Electronic Banking.                      */
/*  CRT003 - Cashier Interface.                                      */
/*  CRT002 - Retail Branch Access                                    */
/*  CAC001 - Profit Centre Accounting :                              */
/*           Call SD9401R - Profit Centre Accounting.                */
/*           Remove Call SD9411R - Management Accounting.            */
/*  S01408 - Addition of core hook SDC9002INT                        */
/*         - Addition of core hook SDC9002002                        */
/*         - Addition of core hook SDC9002003                        */
/*         - Addition of core hook SDC9002004                        */
/*  S01408 - Addition of core hook SDC9002001                        */
/*  CRT001 - Retail Teller System Development:                       */
/*           Call SD9591R - Default Charges Transaction Type         */
/*  S01505 - Profit Centre Accounting Development:                   */
/*           Call SD9401R - Analytical Accounting.                   */
/*           Call SD9411R - Management Accounting.                   */
/*  S01486 - Private Banking:                                        */
/*           Call SD9381R - Portfolio Management.                    */
/*           Call SD9391R - Portfolio Lending.                       */
/*  S01493 - Allow Midas-Eureka Interface ICD maintenance to be      */
/*           accessed from the Input Cycle menu.                     */
/*  S01413 - Retail 3 Incorporation.                                 */
/*  S01421 - Allow Customer Service Fees ICD maintenance to be       */
/*           accessed from the Input Cycle menu.                     */
/*  S01393 - Add the call to SD9321R (SRM module).                   */
/*  S01379 - Add the call to SD9311R (History & Audit Facility)      */
/*  S01339 - Created to allow the ICD maintenance functions          */
/*           to be selected directly from an MITEM menu option.      */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODULE)
 
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTNCODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WRTNCODE) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SSF) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
/************DCL        VAR(&MIDAS) TYPE(*CHAR) LEN(05)                                */ /*CPK017*/
/************DCL        VAR(&RMV) TYPE(*LGL) LEN(1) VALUE('0')                         */ /*CPK017*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/************DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +                               */ /*CPK017*/
/************             VALUE('SDC90002 - Job cannot be run at +                     */ /*CPK017*/
/************             this time.Other job(s) are active')                          */ /*CPK017*/
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)             */                     /*CCB020*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST ')
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)               /*S01421*/
             DCL        VAR(&S01423) TYPE(*CHAR) LEN(7)               /*S01421*/
             DCL        VAR(&CRT001) TYPE(*CHAR) LEN(7)               /*CRT001*/
             DCL        VAR(&CRT002) TYPE(*CHAR) LEN(7)               /*CRT002*/
             DCL        VAR(&CRT003) TYPE(*CHAR) LEN(7)               /*CRT003*/
             DCL        VAR(&CRE008) TYPE(*CHAR) LEN(7)                                   /*CRE008*/
             DCL        VAR(&CAS002) TYPE(*CHAR) LEN(7)                                   /*CAS002*/
             DCL        VAR(&CLE025) TYPE(*CHAR) LEN(7)                                   /*CLE025*/
             DCL        VAR(&CGL014) TYPE(*CHAR) LEN(7)                                   /*CGL014*/
             DCL        VAR(&CFX001) TYPE(*CHAR) LEN(7)                                   /*CFX001*/
             DCL        VAR(&CGL032) TYPE(*CHAR) LEN(7)                                   /*CGL032*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&CDL013) TYPE(*CHAR) LEN(7)                                   /*CDL013*/
             DCL        VAR(&RTNCD) TYPE(*CHAR) LEN(5)                                    /*CDL013*/
             DCL        VAR(&COBST) TYPE(*CHAR) LEN(4)                                    /*CCB020*/
 
/*/COPY WNCPYSRC,SDC9002INT                                          */
                                                                      /*S01408*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO (ERROR))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             CHGJOB     SWS(00000000)
 
/* Main processing */
 
/* Retrieve string of Midas modules present in the system */
 
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)
 
/* A check is made to see if Switchable feature S01423 is present. */ /*S01421*/
                                                                      /*S01421*/
             CALL       PGM(AOSARDR0) PARM(&S01423 '*VERIFY' +
                          'S01423' &SFMT)                             /*S01421*/
                                                                      /*S01421*/
 
/* A check is made to see if Switchable feature CRT001 is present. */ /*CRT001*/
                                                                      /*CRT001*/
             CALL       PGM(AOSARDR0) PARM(&CRT001 '*VERIFY' +
                          'CRT001' &SFMT)                             /*CRT001*/
                                                                      /*CRT001*/
/* A check is made to see if Switchable feature CRT002 is present. */ /*CRT002*/
                                                                      /*CRT002*/
             CALL       PGM(AOSARDR0) PARM(&CRT002 '*VERIFY' +
                          'CRT002' &SFMT)                             /*CRT002*/
                                                                      /*CRT003*/
/* A check is made to see if Switchable feature CRT003 is present. */ /*CRT003*/
                                                                      /*CRT003*/
             CALL       PGM(AOSARDR0) PARM(&CRT003 '*VERIFY' +
                          'CRT003' &SFMT)                             /*CRT003*/
                                                                      /*CRT003*/
                                                                                          /*CAS002*/
/** Check if Switchable Feature CAS002 is installed */                                    /*CAS002*/
                                                                                          /*CAS002*/
             CALL       PGM(AOSARDR0) PARM(&CAS002 '*VERIFY' +
                          'CAS002' &SFMT)                                                 /*CAS002*/
                                                                                          /*CAS002*/
/** Check if Switchable Feature CRE008 is installed */                                    /*CRE008*/
                                                                                          /*CRE008*/
             CALL       PGM(AOSARDR0) PARM(&CRE008 '*VERIFY' +
                          'CRE008' &SFMT)                                                 /*CRE008*/
                                                                                          /*CRE008*/
/** Check if Switchable Feature CLE025 is installed */                                    /*CLE025*/
                                                                                          /*CLE025*/
             CALL       PGM(AOSARDR0) PARM(&CLE025 '*VERIFY' +
                          'CLE025' &SFMT)                                                 /*CLE025*/
                                                                                          /*CLE025*/
/** Check if Switchable Feature CGL014 is installed */                                    /*CGL014*/
                                                                                          /*CGL014*/
             CALL       PGM(AOSARDR0) PARM(&CGL014 '*VERIFY' +
                          'CGL014' &SFMT)                                                 /*CGL014*/
                                                                                          /*CGL014*/
/** Check if Switchable Feature CFX001 is installed */                                    /*CFX001*/
                                                                                          /*CFX001*/
             CALL       PGM(AOSARDR0) PARM(&CFX001 '*VERIFY' +
                          'CFX001' &SFMT)                                                 /*CFX001*/
                                                                                          /*CFX001*/
/** Check if Switchable Feature CGL032 is installed */                                    /*CGL032*/
                                                                                          /*CGL032*/
             CALL       PGM(AOSARDR0) PARM(&CGL032 '*VERIFY' +
                          'CGL032' &SFMT)                                                 /*CGL032*/
                                                                                          /*CGL032*/
             CALL       PGM(AOSARDR0) PARM(&CDL013 '*VERIFY' 'CDL013' +
                          &SFMT)                                                          /*CDL013*/
/*/COPY WNCPYSRC,SDC9002002                                          */
                                                                      /*S01408*/
/**Job*can*run*only*if*system*is*in*input*cycle*or*next*day*set-up**/                     /*CCB020*/
 
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)               */                     /*CCB020*/
             CALL       PGM(CBC001001) PARM(&COBST)                                       /*CCB020*/
 
/* If this program is being called in next day set-up then */
/* the only valid parameter is '**'                        */
 
/**********  IF         COND(&MPHAS *EQ 'D') THEN(DO)              */                     /*CCB020*/
             IF         COND(&COBST *EQ '*YES') THEN(DO)                               /*AR1062470*/
               IF         COND(&MODULE *EQ '**') +
                            THEN(GOTO CMDLBL(MAINT))
               GOTO       CMDLBL(ERROR)
             ENDDO                                                                     /*AR1062470*/
/**********  ENDDO                                                 */                     /*CCB020*/
 
/* Otherwise this program can only be called in input cycle */
 
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)              */                     /*CCB020*/
             IF         COND(&COBST *EQ '*YES') THEN(DO)                                  /*CCB020*/
               SNDPGMMSG  MSG('SDC9002 - Job cannot be run at this +
                            time. Phase of Day must be A.') +
                            TOMSGQ(MOPERQ)
               CALL       PGM(SDC0700) PARM('SDC9002' 'CANTRUNA' ' ')
               GOTO       CMDLBL(ERROR)
             ENDDO
 
/**********  IF         COND(&MPHAS *EQ 'A') THEN(DO)              */                     /*CCB020*/
             IF         COND(&COBST *EQ '*NO') THEN(DO)                                   /*CCB020*/
 
/**If*Module*code*is*OD*or*MF*then*call*the*maintenance*programs.**/ /*                */ /*CPK017*/
/**No*further*checking*is*required*********************************/ /*                */ /*CPK017*/
/************                                                                          */ /*CPK017*/
/************  IF         COND((&MODULE *EQ 'OD') +                                    */ /*CPK017*/
/************               *OR (&MODULE *EQ 'MF')) +                                  */ /*CPK017*/
/************               THEN(GOTO CMDLBL(MAINT))                                   */ /*CPK017*/
/************                                                                          */ /*CPK017*/
/**Send*message*'ICDR'*to*MSGQ/MSPECIAL*to*prevent*other*jobs*******/ /*               */ /*CPK017*/
/**initiating*whilst*I.C.D.*maintenance*is*active.******************/ /*               */ /*CPK017*/
/**Check*if*other*job(s)*are*currently*active*by*receiving*messages*/ /*               */ /*CPK017*/
/**from*MSGQ/MSTATUS.***********************************************/ /*               */ /*CPK017*/
/************                                                                          */ /*CPK017*/
/************  SNDPGMMSG  MSG('ICDR') TOMSGQ(MSPECIAL)                                 */ /*CPK017*/
/************  CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)                                    */ /*CPK017*/
/************  RCVMSG     MSGQ(MSTATUS) RMV(*YES)                                      */ /*CPK017*/
/************  CHGVAR     VAR(&RMV) VALUE('1')                                         */ /*CPK017*/
/************                                                                          */ /*CPK017*/
/************  RCVMSG     MSGQ(MSTATUS) RMV(*NO) MSG(&MIDAS)                           */ /*CPK017*/
/************                                                                          */ /*CPK017*/
/************  IF         COND(&MIDAS *NE '     ') THEN(DO)                            */ /*CPK017*/
/************    SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ)                                   */ /*CPK017*/
/************    CALL       PGM(SDC0700) PARM('SDC9002' 'CANTRUNNOW' +                 */ /*CPK017*/
/************                 ' ')                                                     */ /*CPK017*/
/************    GOTO       CMDLBL(ERROR)                                              */ /*CPK017*/
/************  ENDDO                                                                   */ /*CPK017*/
/************                                                                          */ /*CPK017*/
/************  ELSE       CMD(DO)                                                      */ /*CPK017*/
 
/** If Module code is OD or MF then call the maintenance programs. */                    /*BUG2955*/
/** No further checking is required                                */                    /*BUG2955*/
                                                                                         /*BUG2955*/
             IF         COND((&MODULE *EQ 'OD') +
                            *OR (&MODULE *EQ 'MF')) +
                            THEN(GOTO CMDLBL(MAINT))                                     /*BUG2955*/
                                                                                         /*BUG2955*/
/** Check if other jobs are accessing the ICD menu  */                                   /*BUG2955*/
                                                                                         /*BUG2955*/
             CALL       PGM(SDC009000) PARM(&RTNCODE)                                    /*BUG2955*/
             IF         COND(&RTNCODE *EQ '*NO_ALC') THEN(DO)                            /*BUG2955*/
                 SNDPGMMSG  MSG('SDC9002 - Job cannot be run at this +
                              time.  Another workstation is using the +
                              ICD menu.') TOMSGQ(MOPERQ)                                 /*BUG2955*/
                 CALL       PGM(SDC0700) PARM('SDC9002' 'CANTRUNWRK' ' ')                /*BUG2955*/
                 GOTO       CMDLBL(ERROR)                                                /*BUG2955*/
             ENDDO                                                                       /*BUG2955*/
                                                                                         /*BUG2955*/
MAINT:
 
/* If system set-up is complete, send message to user */
 
                 RTVDTAARA  DTAARA(RUNDAT (11 1)) RTNVAR(&SSF)
                 IF         COND(&SSF *EQ 'Y') THEN(DO)
                   SNDPGMMSG  MSG('SDC9002 - Job cannot be +
                                run at this time. The System Set-up +
                                flag is on.') TOMSGQ(MOPERQ)
                   CALL       PGM(SDC0700) PARM('SDC9002' +
                                'CANTRUNSSF' ' ')
                   GOTO       CMDLBL(ERROR)
                 ENDDO
 
/************  ENDDO                                                                   */ /*CPK017*/
 
/* Otherwise call maintenance programs */
 
/* If module code is SD (Standing Data) */
 
               IF         COND((&MODULE *EQ 'SD') *OR (&MODULE *EQ +
                            '**')) THEN(DO)
                 CALL       PGM(SD9100R) PARM(&RTNCODE 'BANK' +
                              &WRTNCODE ' ')
                 IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                              CMDLBL(END))
               ENDDO
 
/* If module code is GL (General Ledger) */
 
               IF         COND((&MODULE *EQ 'GL') *OR (&MODULE *EQ +
                            '**')) THEN(DO)
/*/COPY WNCPYSRC,SDC9002005                                          */
                 CALL       PGM(SD9171R) PARM(&RTNCODE 'GELR' +
                              &WRTNCODE ' ')
/*/COPY WNCPYSRC,SDC9002006                                          */
                 IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                              CMDLBL(END))
               ENDDO
 
/* If module code is TR (Trading Data) */
 
               IF         COND((&MODULE *EQ 'TR') *OR (&MODULE *EQ +
                            '**')) THEN(DO)
                IF         COND((%SST(&FMT 23 1) *EQ 'Y') *OR +
                             (%SST(&FMT 48 1) *EQ 'Y') *OR (%SST(&FMT +
                             31 1) *EQ 'Y')) THEN(DO)
                  CALL       PGM(SD9231R) PARM(&RTNCODE 'TRAD' +
                               &WRTNCODE ' ')
                  IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                               CMDLBL(END))
                ENDDO
               ENDDO
 
/* If module code is FC (Report Control Facility) */
 
               IF         COND((&MODULE *EQ 'FC') *OR (&MODULE *EQ +
                            '**')) THEN(DO)
                 CALL       PGM(SD9241R) PARM(&RTNCODE 'RCF' +
                              &WRTNCODE ' ')
                 IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                              CMDLBL(END))
               ENDDO
 
/* If module code is CB (Close of Business) */
 
               IF         COND((&MODULE *EQ 'CB') *OR (&MODULE *EQ +
                            '**')) THEN(DO)
                 CALL       PGM(SD9261R) PARM(&RTNCODE 'COBP' +
                              &WRTNCODE ' ')
                 IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                              CMDLBL(END))
               ENDDO
 
/* If module code is DL (Dealing) */
 
               IF         COND((&MODULE *EQ 'DL') *OR (&MODULE *EQ +
                            '**')) THEN(DO)
                 IF         COND((%SST(&FMT 23 1) *EQ 'Y') *OR +
                              (%SST(&FMT 48 1) *EQ 'Y')) THEN(DO)
                   CALL       PGM(SD9121R) PARM(&RTNCODE 'DEAL' +
                                &WRTNCODE ' ')
                   IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                                CMDLBL(END))
                 ENDDO
               ENDDO
 
/* If module code is TM (Treasury Management) */
 
               IF         COND((&MODULE *EQ 'TM') *OR (&MODULE *EQ +
                            '**')) THEN(DO)
                 IF         COND(%SST(&FMT 50 1) *EQ 'Y') THEN(DO)
                   CALL       PGM(SD9291R) PARM(&RTNCODE 'TRMA' +
                                &WRTNCODE ' ')
                   IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                                CMDLBL(END))
                 ENDDO
               ENDDO
 
/* If module code is RK (Risk Management) */                          /*S01393*/
                                                                      /*S01393*/
               IF         COND((&MODULE *EQ 'RK') *OR (&MODULE *EQ +
                            '**')) THEN(DO)                           /*S01393*/
                 IF         COND(%SST(&FMT 51 1) *EQ 'Y') THEN(DO)    /*S01393*/
                   CALL       PGM(SD9321R) PARM(&RTNCODE 'RISK' +
                                &WRTNCODE ' ')                        /*S01393*/
                   IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                                CMDLBL(END))                          /*S01393*/
                 ENDDO                                                /*S01393*/
               ENDDO                                                  /*S01393*/
                                                                      /*S01393*/
/* If module code is IR (FRA/IRS) */
 
               IF         COND((&MODULE *EQ 'IR') *OR (&MODULE *EQ +
                            '**')) THEN(DO)
                 IF         COND(%SST(&FMT 47 1) *EQ 'Y') THEN(DO)
                   CALL       PGM(SD9161R) PARM(&RTNCODE 'FAIS' +
                                &WRTNCODE ' ')
                   IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                                CMDLBL(END))
                 ENDDO
               ENDDO
 
/* If module code is SE (Securities Trading) */
 
               IF         COND((&MODULE *EQ 'SE') *OR (&MODULE *EQ +
                            '**')) THEN(DO)
                 IF         COND(%SST(&FMT 31 1) *EQ 'Y') THEN(DO)
                   CALL       PGM(SD9211R) PARM(&RTNCODE 'STRD' +
                                &WRTNCODE ' ')
                   IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                                CMDLBL(END))
                 ENDDO
               ENDDO
 
/* If module code is FF (Futures and Options) */
 
               IF         COND((&MODULE *EQ 'FF') *OR (&MODULE *EQ +
                            '**')) THEN(DO)
                 IF         COND(%SST(&FMT 41 1) *EQ 'Y') THEN(DO)
                   CALL       PGM(SD9151R) PARM(&RTNCODE 'FODA' +
                                &WRTNCODE ' ')
                   IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                                CMDLBL(END))
                 ENDDO
               ENDDO
 
/* If module code is LE (Customer Lending) */
 
               IF         COND((&MODULE *EQ 'LE') *OR (&MODULE *EQ +
                            '**')) THEN(DO)
                 IF         COND(%SST(&FMT 28 1) *EQ 'Y') THEN(DO)
                   CALL       PGM(SD9111R) PARM(&RTNCODE 'CLND' +
                                &WRTNCODE ' ')
                   IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                                CMDLBL(END))
                 ENDDO
               ENDDO
 
/* If module code is RE (Retail) */
 
               IF         COND((&MODULE *EQ 'RE') *OR (&MODULE *EQ +
                            '**')) THEN(DO)
                 IF         COND(%SST(&FMT 29 1) *EQ 'Y') THEN(DO)
                   CALL       PGM(SD9201R) PARM(&RTNCODE 'RETL' +
                                &WRTNCODE ' ')
                   IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                                CMDLBL(END))
                 ENDDO
               ENDDO
 
/* If module code is WT (Withholding Tax) */                          /*S01413*/
 
               IF         COND((&MODULE *EQ 'WT') *OR (&MODULE *EQ +
                            '**')) THEN(DO)
/**********      IF         COND(%SST(&FMT 93 1) *EQ 'Y') THEN(DO)   */                   /*CGL032*/
                 IF         COND((%SST(&FMT 93 1) *EQ 'Y') *OR +
                            (&CGL032 *EQ ' ')) THEN(DO)                                   /*CGL032*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC9002003                                          */
/*                                                                   */                   /*CDL013*/
/*  CDL013 - Call SD0017 if CDL013 is switched on, else call         */                   /*CDL013*/
/*           SD9331R.                                                */                   /*CDL013*/
/*                                                                   */                   /*CDL013*/
             IF         COND(&CDL013 *EQ ' ') THEN(DO)                                    /*CDL013*/
             CALL       PGM(SD0017) PARM('RETAIL    ' 'M' &RTNCD)                         /*CDL013*/
                   ENDDO                                                                  /*CDL013*/
                   ELSE       CMD(DO)                                                     /*CDL013*/
                                                                      /*S01408*/
                   CALL       PGM(SD9331R) PARM(&RTNCODE 'RETAIL' +
                                &WRTNCODE ' ')
                                                                      /*S01408*/
/*  CDL013 enddo to call to SD0017 or SE9331R.                     */                     /*CDL013*/
                                                                                          /*CDL013*/
             ENDDO                                                                        /*CDL013*/
                                                                                          /*CDL013*/
/*/COPY WNCPYSRC,SDC9002004                                          */
                                                                      /*S01408*/
                   IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                                CMDLBL(END))
                 ENDDO
               ENDDO
                                                                      /*S01413*/
/* If module code is ME (Message Management) */
 
               IF         COND((&MODULE *EQ 'ME') *OR (&MODULE *EQ +
                            '**')) THEN(DO)
                 IF         COND(%SST(&FMT 46 1) *EQ 'Y') THEN(DO)
                   CALL       PGM(SD9281R) PARM(&RTNCODE 'MGME' +
                                &WRTNCODE ' ')
                   IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                                CMDLBL(END))
                 ENDDO
               ENDDO
 
/* If module code is CF (Confirmation Matching) */
 
               IF         COND((&MODULE *EQ 'CF') *OR (&MODULE *EQ +
                            '**')) THEN(DO)
                 IF         COND(%SST(&FMT 70 1) *EQ 'Y') THEN(DO)
                   CALL       PGM(SD9300R) PARM(&RTNCODE 'CONF' +
                                &WRTNCODE ' ')
                   IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                                CMDLBL(END))
                 ENDDO
               ENDDO
 
/* If module code is FT (Funds Transfer) */
 
               IF         COND((&MODULE *EQ 'FT') *OR (&MODULE *EQ +
                            '**')) THEN(DO)
                 IF         COND(%SST(&FMT 39 1) *EQ 'Y') THEN(DO)
                   CALL       PGM(SD9141R) PARM(&RTNCODE 'FTFR' +
                                &WRTNCODE ' ')
                   IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                                CMDLBL(END))
                 ENDDO
               ENDDO
 
/* If module code is EM (Exposure Management) */
 
               IF         COND((&MODULE *EQ 'EM') *OR (&MODULE *EQ +
                            '**')) THEN(DO)
                 IF         COND(%SST(&FMT 25 1) *EQ 'Y') THEN(DO)
                   CALL       PGM(SD9131R) PARM(&RTNCODE 'EXPM' +
                                &WRTNCODE ' ')
                   IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                                CMDLBL(END))
                 ENDDO
               ENDDO
 
/* If module code is MF (Microfiche Archiving) */
 
               IF         COND((&MODULE *EQ 'MF') *OR (&MODULE *EQ +
                            '**')) THEN(DO)
                 IF         COND(%SST(&FMT 54 1) *EQ 'Y') THEN(DO)
                   CALL       PGM(SD9251R) PARM(&RTNCODE 'MCFC' +
                                &WRTNCODE ' ')
                   IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                                CMDLBL(END))
                 ENDDO
               ENDDO
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC9002001                                          */
                                                                      /*S01408*/
 
/* If module code is OD (Optical Disk) */
 
               IF         COND((&MODULE *EQ 'OD') *OR (&MODULE *EQ +
                            '**')) THEN(DO)
                 IF         COND(%SST(&FMT 85 1) *EQ 'Y') THEN(DO)
                 CALL       PGM(SD9271R) PARM(&RTNCODE 'OPTC' +
                              &WRTNCODE ' ')
                   IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                                CMDLBL(END))
                 ENDDO
               ENDDO
 
                                                                      /*S01379*/
/* If module code is HF (History and Audit Facility) */               /*S01379*/
                                                                      /*S01379*/
               IF         COND((&MODULE *EQ 'HF') *OR (&MODULE *EQ +
                            '**')) THEN(DO)                           /*S01379*/
                 IF         COND(%SST(&FMT 94 1) *EQ 'Y') THEN(DO)    /*S01379*/
                 CALL       PGM(SD9311R) PARM(&RTNCODE 'HAFD' +
                              &WRTNCODE ' ')                          /*S01379*/
                   IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                                CMDLBL(END))                          /*S01379*/
                 ENDDO                                                /*S01379*/
               ENDDO                                                  /*S01379*/
 
/* If the module code is CS (Customer service fees) */                /*S01421*/
                                                                      /*S01421*/
               IF         COND(((&MODULE *EQ 'CS') *OR (&MODULE *EQ +
                            '**')) *AND (&S01423 *EQ ' ')) THEN(DO)   /*S01421*/
                  CALL      PGM(SD9351R) PARM(&RTNCODE 'CSFD' +
                              &WRTNCODE ' ')                          /*S01421*/
                  IF      COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                            CMDLBL(END))                              /*S01421*/
               ENDDO                                                  /*S01421*/
             ENDDO
 
/* If the module code is ED (Midas-Eureka Interface)  */              /*S01493*/
                                                                      /*S01493*/
               IF         COND((&MODULE *EQ 'ED') *OR (&MODULE *EQ +
                            '**')) THEN(DO)                           /*S01493*/
                 IF         COND(%SST(&FMT 99 1) *EQ 'Y') THEN(DO)    /*S01493*/
                   CALL       PGM(SD9361R) PARM(&RTNCODE 'MEXP' +
                                &WRTNCODE ' ')                        /*S01493*/
                   IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                                CMDLBL(END))                          /*S01493*/
                 ENDDO                                                /*S01493*/
               ENDDO                                                  /*S01493*/
/**/                                                                  /*S01486*/
/* If the module code is PM (Portfolio Management)    */              /*S01486*/
                                                                      /*S01486*/
               IF         COND((&MODULE *EQ 'PM') *OR (&MODULE *EQ +
                            '**')) THEN(DO)                           /*S01486*/
                 IF         COND(%SST(&FMT 65 1) *EQ 'Y') THEN(DO)    /*S01486*/
                   CALL       PGM(SD9381R) PARM(&RTNCODE 'PORT' +
                                &WRTNCODE ' ')                        /*S01486*/
                   IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                                CMDLBL(END))                          /*S01486*/
                 ENDDO                                                /*S01486*/
               ENDDO                                                  /*S01486*/
/**/                                                                  /*S01486*/
/**/                                                                  /*S01486*/
/* If the module code is LB (Portfolio Lending)       */              /*S01486*/
                                                                      /*S01486*/
               IF         COND((&MODULE *EQ 'LB') *OR (&MODULE *EQ +
                            '**')) THEN(DO)                           /*S01486*/
                 IF         COND(%SST(&FMT 76 1) *EQ 'Y') THEN(DO)    /*S01486*/
                   CALL       PGM(SD9391R) PARM(&RTNCODE 'LOMB' +
                                &WRTNCODE ' ')                        /*S01486*/
                   IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                                CMDLBL(END))                          /*S01486*/
                 ENDDO                                                /*S01486*/
               ENDDO                                                  /*S01486*/
/**/                                                                  /*S01505*/
/* If the module code is AA (Analytical Accounting)   */              /*S01505*/
                                                                      /*S01505*/
               IF         COND((&MODULE *EQ 'AA') *OR (&MODULE *EQ +
                            '**')) THEN(DO)                           /*S01505*/
                 IF         COND(%SST(&FMT 100 1) *EQ 'Y') THEN(DO)   /*S01505*/
/******************CALL       PGM(SD9401R) PARM(&RTNCODE 'ANAC' +
/******************             &WRTNCODE ' ')             /*S01505*/ /*CAC001*/
                   CALL       PGM(SD9401R) PARM(&RTNCODE 'PCAC' +
                                &WRTNCODE ' ')                        /*CAC001*/
                   IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                                CMDLBL(END))                          /*S01505*/
                 ENDDO                                                /*S01505*/
               ENDDO                                                  /*S01505*/
/**/                                                                  /*S01505*/
/**If*the*module*code*is*MC*(Management*Accounting)****/       /*S01505 CAC001*/
                                                               /*S01505 CAC001*/
/*******IF*        COND((&MODULE *EQ 'MC') *OR (&MODULE *EQ +           CAC001*/
/**********          '**')) THEN(DO)                           /*S01505 CAC001*/
/*********IF         COND(%SST(&FMT 95 1) *EQ 'Y') THEN(DO)    /*S01505 CAC001*/
/*********  CALL       PGM(SD9411R) PARM(&RTNCODE 'MGAC' +              CAC001*/
/*********               &WRTNCODE ' ')                        /*S01505 CAC001*/
/*********  IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +          CAC001*/
/*********                      CMDLBL(END))                  /*S01505  CAC001*/
/*********       ENDDO                                        /*S01505  CAC001*/
/*********     ENDDO                                          /*S01505  CAC001*/
 
/* If the module code is R1 (RTS Default Charges Transaction Type */  /*CRT001*/
                                                                      /*CRT001*/
/*             IF         COND(((&MODULE *EQ 'R1') *OR (&MODULE *EQ +
                 '**')) *AND (&CRT001 *EQ ' ')) THEN(DO)*/ /*CRT001*/ /*CRT002*/
               IF         COND((&MODULE *EQ 'R1') *OR +
                              ((&MODULE *EQ '**') *AND (&CRT001 *EQ ' ')) +
                              *OR ((&MODULE *EQ '**') *AND (&CRT002 *EQ ' '))) +
                              THEN(DO)                                /*CRT002*/
                 IF         COND(%SST(&FMT 29 1) *EQ 'Y') THEN(DO)    /*CRT001*/
                  IF         COND(%SST(&FMT 97 1) *EQ 'Y') THEN(DO)   /*CRT001*/
                    CALL       PGM(SD9591R) PARM(&RTNCODE 'TCHG' +
                               &WRTNCODE ' ')                         /*CRT001*/
                    IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                               CMDLBL(END))                           /*CRT001*/
                  ENDDO                                               /*CRT001*/
                 ENDDO                                                /*CRT001*/
               ENDDO
 
/* If the module code is CI (Cashier Interface)                   */  /*CRT003*/
                                                                      /*CRT003*/
               IF         COND(((&MODULE *EQ 'CI') *OR (&MODULE *EQ +
                            '**')) *AND (&CRT003 *EQ ' ')) THEN(DO)   /*CRT003*/
                    CALL       PGM(SD9411R) PARM(&RTNCODE 'BAII' +
                               &WRTNCODE ' ')                         /*CRT003*/
                    IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                               CMDLBL(END))                           /*CRT003*/
               ENDDO                                                  /*CRT003*/
/* If module code is EB (Midas-Fontis Interface)   */                 /*CGL004*/
                                                                      /*CGL004*/
               IF         COND((&MODULE *EQ 'EB') *OR (&MODULE *EQ +
                            '**')) THEN(DO)                           /*CGL004*/
                 CALL       PGM(SD9421R) PARM(&RTNCODE 'FONT' +
                                &WRTNCODE ' ')                        /*CGL004*/
                 IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                              CMDLBL(END))                            /*CGL004*/
               ENDDO
 
/* If the module code is TI (Midas / Trade Innovation Interface)  */  /*CTI001*/
                                                                      /*CTI001*/
               IF         COND((&MODULE *EQ 'TI') *OR (&MODULE *EQ +
                            '**')) THEN(DO)                           /*CTI001*/
                    CALL       PGM(SD9441R) PARM(&RTNCODE 'TIIN' +
                               &WRTNCODE ' ')                         /*CTI001*/
                    IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                               CMDLBL(END))                           /*CTI001*/
               ENDDO                                                  /*CTI001*/
 
/* APIs 'AP'                                  */                      /*CAP006*/
                                                                      /*CAP006*/
               IF         COND((&MODULE *EQ 'AP') *OR (&MODULE *EQ +
                            '**')) THEN(DO)                           /*CAP006*/
                    CALL       PGM(SD9451R) PARM(&RTNCODE 'API' +
                               &WRTNCODE ' ')                         /*CAP006*/
                    IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                               CMDLBL(END))                           /*CAP006*/
             ENDDO                                                    /*CAP006*/
/**/                                                                  /*S01505*/
/* If the module code is PB (Private Banking) */                      /*CPB001*/
                                                                      /*CPB001*/
               IF         COND((&MODULE *EQ 'PB') *OR (&MODULE *EQ +
                            '**')) THEN(DO)                           /*CPB001*/
                 IF         COND(%SST(&FMT 104 1) *EQ 'Y') THEN(DO)   /*CPB001*/
                    CALL       PGM(SD9461R) PARM(&RTNCODE 'TOF ' +
                               &WRTNCODE ' ')                         /*CPB001*/
                    IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                               CMDLBL(END))                           /*CPB001*/
                 ENDDO                                                /*CPB001*/
               ENDDO                                                  /*CPB001*/
 
/** Hedging ICD Maintenance  */                                                           /*CAS002*/
 
               IF         COND(((&MODULE *EQ 'AS') *OR (&MODULE *EQ +
                            '**')) *AND (&CAS002 *EQ ' ')) THEN(DO)                       /*CAS002*/
                  CALL       PGM(SD000744) PARM(&RTNCODE 'HEDG' 'M')                      /*CAS002*/
                  IF         COND(&RTNCODE *EQ '**CMD') THEN(GOTO +
                               CMDLBL(END))                                               /*CAS002*/
               ENDDO                                                                      /*CAS002*/
                                                                                          /*CAS002*/
/** Cash Management ICD Maintenance  */                                                   /*CRE008*/
 
               IF         COND(((&MODULE *EQ 'CM') *OR (&MODULE *EQ +
                            '**')) *AND (&CRE008 *EQ ' ')) THEN(DO)                       /*CRE008*/
                  CALL       PGM(SD9452) PARM(&RTNCODE 'SDCMANPD' 'M')                    /*CRE008*/
                  IF         COND(&RTNCODE *EQ '**CMD') THEN(GOTO +
                               CMDLBL(END))                                               /*CRE008*/
               ENDDO                                                                      /*CRE008*/
                                                                                          /*CRE008*/
/** Collateral and Credit Control ICD */                                                  /*CLE025*/
                                                                                          /*CLE025*/
/**********  IF         COND(((&MODULE *EQ 'CO') *OR (&MODULE *EQ +
/**********                 '**')) *AND (&CLE025 *EQ ' ')) THEN(DO)  */        /*CLE025*/ /*CGL014*/
/**********    IF         COND((&MODULE *EQ 'CO' *OR &MODULE *EQ '**') + */
/**********                 *AND (&CLE025 *EQ ' ' *OR &CGL014 *EQ ' +    */
/**********                 ')) THEN(DO)                                 */    /*CGL014*/ /*CFX001*/
               IF         COND((&MODULE *EQ 'CO' *OR &MODULE *EQ '**') +
                            *AND (&CLE025 *EQ ' ' *OR &CGL014 *EQ ' ' +
                            *OR &CFX001 *EQ ' ')) THEN(DO)                                /*CFX001*/
                  CALL       PGM(SD009113) PARM(&RTNCODE 'COCC' 'M')                      /*CLE025*/
                                                                                          /*CGL014*/
/** Update price type of all security collateral items                                    /*CGL014*/
                                                                                          /*CGL014*/
                  IF         COND(&CGL014 *EQ ' ' *AND &RTNCODE *EQ +
                               '*UPDATE') THEN(DO)                                        /*CGL014*/
/**********       SBMJOB     CMD(CALL PGM(GLC000011)) JOB(GLC000011) +
                               JOBD(MBATCH) JOBQ(MICJOBQ) RTGDTA(*JOBD) +
                               INLLIBL(*JOBD) */                                   /*CGL014 245656*/
                  SBMJOB     CMD(CALL PGM(GLC000011)) JOB(GLC000011) +
                               JOBD(MBATCH) JOBQ(MICJOBQ) USER(*JOBD) +
                               RTGDTA(*JOBD) INLLIBL(*JOBD)                               /*245656*/
                     GOTO       CMDLBL(END)                                               /*CGL014*/
                  ENDDO                                                                   /*CGL014*/
                                                                                          /*CGL014*/
                  IF         COND(&RTNCODE *EQ ' ') THEN(GOTO +
                               CMDLBL(END))                                               /*CLE025*/
               ENDDO                                                                      /*CLE025*/
                                                                                          /*CLE025*/
ERROR:
 
             RTVJOBA    JOB(&JOB)
             DLTOVR     FILE(*ALL)
 
/* If database error occurs information message is sent to user */
 
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
               ROLLBACK
               IF         COND((&MODULE *NE '**')) THEN(DO)
                 RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                 CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(&JOB)
               ENDDO
             ENDDO
 
/**Send*'MIDAS'*message*to*MSGQ/MSTATUS*that*was*removed*at*top*of**/ /*               */ /*CPK017*/
/**this*program.*Remove*message*'ICDR'*from*MSGQ/MSPECIAL*and*reset*/ /*               */ /*CPK017*/
/**MSGQ/MSTATUS.****************************************************/ /*               */ /*CPK017*/
/************                                                                          */ /*CPK017*/
/*END:*******      IF         COND(&RMV) THEN(SNDPGMMSG MSG('MIDAS') +                 */ /*CPK017*/
/************             TOMSGQ(MSTATUS))                                             */ /*CPK017*/
/************                                                                          */ /*CPK017*/
/************CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES)                                     */ /*CPK017*/
/************MONMSG     MSGID(CPF0000)                                                 */ /*CPK017*/
/************                                                                          */ /*CPK017*/
/**Remove*'ICDR'*message*sent*to*MSPECIAL*at*top*of*program*/ /*                       */ /*CPK017*/
/**for*modules*other*than*Microfiche*and*Optical*Disk.******/ /*                       */ /*CPK017*/
/************                                                                          */ /*CPK017*/
/************IF         COND((&MODULE *NE '**') +                                      */ /*CPK017*/
/************           *AND (&MODULE *NE 'MF') +                                      */ /*CPK017*/
/************           *AND (&MODULE *NE 'OD')) +                                     */ /*CPK017*/
/************           THEN(DO)                                                       */ /*CPK017*/
/************  RCVMSG     MSGQ(MSPECIAL) RMV(*YES)                                     */ /*CPK017*/
/************  MONMSG     MSGID(CPF0000)                                               */ /*CPK017*/
/************ENDDO                                                                     */ /*CPK017*/
/************                                                                          */ /*CPK017*/
/************CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)                                      */ /*CPK017*/
/************MONMSG     MSGID(CPF0000)                                                 */ /*CPK017*/
 
END:                                                                                      /*CPK017*/
             DLCOBJ     OBJ((SDICDR *DTAARA *EXCL))                                      /*BUG2955*/
             MONMSG     MSGID(CPF0000)                                                   /*BUG2955*/
                                                                                         /*BUG2955*/
             RETURN
 
             ENDPGM
