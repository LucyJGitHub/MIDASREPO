/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Setup "PM" enquiry')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC0610  - ENQUIRY DETAILS "PM"                             */
/*                  OLD PROGRAM PMC0610 IS RENAMED TO PMC0611 FOR    */
/*                  CHANGE ALL SETATNPGM IN RPG PGM.                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. CPM005             DATE 02JUL96              */
/*       PREV AMEND NO. S01486             DATE 07JUL94              */
/*                      063197             DATE 11NOV93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPM005 - Private Banking Phase II                           */
/*                Focus Group Changes Upgraded to DBA                */
/*                PBFG/5 - INSTRUMENT ASSET/LIABILITY SPLIT          */
/*       S01486 - Portfolio Management Incorporation                 */
/*       063197 - PMC0610 RENAMED TO PMC0611  AND PMC0611 RENAMED TO */
/*                PMC0611                                            */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/************CHGJOB     SWS(1XXXXXXX)                                   063197*/
/************CALL       SDC2330                                         063197*/
/************CHGJOB     SWS(0XXXXXXX)                                   063197*/
 
/**/
/*********** DCL        VAR(&GRPJ) TYPE(*CHAR) LEN(1056)      /*063197  CPM005*/
             DCL        VAR(&DSPG) TYPE(*CHAR) LEN(10)                /*063197*/
             DCL        VAR(&DSPGA) TYPE(*CHAR) LEN(10)               /*063197*/
             DCL        VAR(&F12) TYPE(*CHAR) LEN(1)                  /*063197*/
             DCL        VAR(&ENQT) TYPE(*CHAR) LEN(1)                 /*063197*/
             DCL        VAR(&ACTP) TYPE(*CHAR) LEN(10)                /*CPM005*/
/**/
/*********** DCL        VAR(&NDSP) TYPE(*CHAR) LEN(10)        /*063197  CPM005*/
/**/
/**/
/***RETRIEVE*LIST*OF*ACTIVE*GROUP*JOBS**/                             /*S01486*/
/*********** RTVGRPA    GRPJOBL(&GRPJ)                        /*063197  S01486*/
/**/
/***CALL*PM0610*TO*ALLOW*USER*TO*CHOOSE*ANOTHER*GROUP*JOB               S01486*/
/** CALL PM0610 TO ALLOW USER TO CHOOSE ANOTHER GROUP JOB               S01486*/
/************CALL       PGM(PM0610) PARM(&GRPJ &DSPG &F12 &NDSP)063197  S01486*/
/************CALL       PGM(PM0610) PARM(&DSPG &F12 &NDSP)      S01486  CPM005*/
RESTART:     CALL       PGM(PM0610) PARM(&DSPG &F12)                  /*CPM005*/
 /**RETRIEVE*DATA*AREA**GDA*********************************************S01486*/
/*********** RTVDTAARA  DTAARA(*GDA (1 1)) RTNVAR(&ENQT)       /*063197 S01486*/
/*********** IF         COND(&ENQT *EQ 'Y' *OR &ENQT *EQ 'P' *OR +
                          &ENQT *EQ 'C') THEN(DO)              /*063197 S01486*/
/*********** CALL       PGM(PMC1020)                           /*063197 S01486*/
/*********** ENDDO                                             /*063197 S01486*/
             RTVDTAARA  DTAARA(*LDA (540 1)) RTNVAR(&ENQT)            /*S01486*/
             IF         COND(&ENQT *EQ 'C') THEN(DO)                  /*S01486*/
             RETURN                                                   /*S01486*/
             GOTO END                                                 /*S01486*/
             ENDDO                                                    /*S01486*/
             IF         COND(&ENQT *EQ 'P') THEN(DO)                  /*S01486*/
             RETURN                                                   /*S01486*/
             GOTO END                                                 /*S01486*/
             ENDDO                                                    /*S01486*/
             IF         COND(&ENQT *EQ 'Y') THEN(DO)                  /*CPM005*/
             RETURN                                                   /*CPM005*/
             GOTO END                                                 /*CPM005*/
             ENDDO                                                    /*CPM005*/
             RTVDTAARA  DTAARA(*LDA (654 10)) RTNVAR(&ACTP)           /*CPM005*/
 /*                         */
/**/
/** TRANSFER TO REQUESTED GROUP JOB */
             IF         COND(&F12 *NE 'Y') THEN(DO)                   /*063197*/
/*********** IF         COND(&DSPG *NE 'SCROLL    ') THEN(DO)  /*063197 CPM005*/
 /********** CHGVAR     VAR(&DSPGA) VALUE(X *TCAT &DSPG)       /*063197 S01486*/
 /********** TFRGRPJOB  GRPJOB(&DSPGA) INLGRPPGM(PMC0690)      /*063197 S01486*/
 /********** MONMSG     MSGID(CPF1310) EXEC(RETURN)            /*063197 S01486*/
 /********** CALL       PGM(PM0690)                                   /*S01486*/
/*********** RETURN                                            /*S01486 CPM005*/
/*********** GOTO END                                          /*S01486 CPM005*/
 /**RETRIEVE*DATA*AREA**GDA*********************************************S01486*/
 /********** RTVDTAARA  DTAARA(*GDA (1 1)) RTNVAR(&ENQT)      /*063197  S01486*/
 /********** IF         COND(&ENQT *EQ 'Y' *OR &ENQT *EQ 'P' *OR +
                          &ENQT *EQ 'C') THEN(DO)             /*063197  S01486*/
 /********** CALL       PGM(PMC1020)                          /*063197  S01486*/
 /********** ENDDO                                                      S01486*/
 /*                         */
/*********** ENDDO                                            /*063197  CPM005*/
/**/
/** START /TRANSFER BACK TO SCROLL SCREEN               */
/*********** IF         COND(&DSPG *EQ 'SCROLL    ') THEN(DO) /*063197  CPM005*/
/*********** TFRGRPJOB  GRPJOB(SCROLL) INLGRPPGM(PMC0670)     /*063197  S01486*/
/*********** MONMSG     MSGID(CPF1310) EXEC(RETURN)           /*063197  S01486*/
             IF         COND(&DSPG *EQ 'POSINS    ') THEN(DO)         /*CPM005*/
             CHGDTAARA  DTAARA(*LDA (540 1)) VALUE(' ')               /*CPM005*/
             IF         COND(&ACTP *EQ 'PM0670') THEN(DO)
                CHGDTAARA  DTAARA(*LDA (654 10)) VALUE('          ')  /*CPM005*/
                RETURN                                                /*CPM005*/
             ENDDO                                                    /*CPM005*/
             CALL       PGM(PM0670)                                   /*S01486*/
 /* RETRIEVE DATA AREA *GDA */
/*********** RTVDTAARA  DTAARA(*GDA (1 1)) RTNVAR(&ENQT)      /*063197  S01486*/
/*********** IF         COND(&ENQT *EQ 'Y' *OR &ENQT *EQ 'P' *OR +
                          &ENQT *EQ 'C') THEN(DO)              /*063197 S01486*/
/*********** CALL       PGM(PMC1020)                           /*063197 S01486*/
/*********** ENDDO                                             /*063197 S01486*/
 /* RETRIEVE DATA AREA *LDA */                                        /*CPM005*/
             RTVDTAARA  DTAARA(*LDA (540 1)) RTNVAR(&ENQT)            /*CPM005*/
             IF         COND(&ENQT *EQ 'Y' *OR &ENQT *EQ 'P' *OR +
                          &ENQT *EQ 'C') THEN(DO)                     /*CPM005*/
             RETURN                                                   /*CPM005*/
             GOTO       CMDLBL(END)                                   /*CPM005*/
             ENDDO                                                    /*CPM005*/
 /*                         */
             ENDDO                                                    /*063197*/
/*  START /TRANSFER BACK TO "POSITIONS BY CURRENCY AND INSTRUMENT"    /*CPM005*/
             IF         COND(&DSPG *EQ 'POSCCY    ') THEN(DO)         /*CPM005*/
             CHGDTAARA  DTAARA(*LDA (540 1)) VALUE(' ')               /*CPM005*/
             IF         COND(&ACTP *EQ 'PM0671') THEN(DO)
                CHGDTAARA  DTAARA(*LDA (654 10)) VALUE('          ')  /*CPM005*/
                RETURN                                                /*CPM005*/
             ENDDO                                                    /*CPM005*/
             CALL       PGM(PM0671)                                   /*CPM005*/
 /* RETRIEVE DATA AREA *LDA */                                        /*CPM005*/
             RTVDTAARA  DTAARA(*LDA (540 1)) RTNVAR(&ENQT)            /*CPM005*/
             IF         COND(&ENQT *EQ 'Y' *OR &ENQT *EQ 'P' *OR +
                          &ENQT *EQ 'C') THEN(DO)                     /*CPM005*/
             RETURN                                                   /*CPM005*/
             GOTO       CMDLBL(END)                                   /*CPM005*/
             ENDDO                                                    /*CPM005*/
             ENDDO                                                    /*CPM005*/
/*                                                                    /*CPM005*/
/*  START /TRANSFER BACK TO "TOTALS BY INSTRUMENT ENQUIRY"            /*CPM005*/
             IF         COND(&DSPG *EQ 'TOTINS    ') THEN(DO)         /*CPM005*/
             CHGDTAARA  DTAARA(*LDA (540 1)) VALUE(' ')               /*CPM005*/
             IF         COND(&ACTP *EQ 'PM6050') THEN(DO)
                CHGDTAARA  DTAARA(*LDA (654 10)) VALUE('          ')  /*CPM005*/
                RETURN                                                /*CPM005*/
             ENDDO                                                    /*CPM005*/
             CALL       PGM(PM6050)                                   /*CPM005*/
 /* RETRIEVE DATA AREA *LDA */                                        /*CPM005*/
             RTVDTAARA  DTAARA(*LDA (540 1)) RTNVAR(&ENQT)            /*CPM005*/
             IF         COND(&ENQT *EQ 'Y' *OR &ENQT *EQ 'P' *OR +
                          &ENQT *EQ 'C') THEN(DO)                     /*CPM005*/
             RETURN                                                   /*CPM005*/
             GOTO       CMDLBL(END)                                   /*CPM005*/
             ENDDO                                                    /*CPM005*/
             ENDDO                                                    /*CPM005*/
/*                                                                    /*CPM005*/
/*  START /TRANSFER BACK TO "TOTALS BY CURRENCY AND INSTRUMENT"       /*CPM005*/
             IF         COND(&DSPG *EQ 'TOTCCY    ') THEN(DO)         /*CPM005*/
             CHGDTAARA  DTAARA(*LDA (540 1)) VALUE(' ')               /*CPM005*/
             IF         COND(&ACTP *EQ 'PM6070') THEN(DO)
                CHGDTAARA  DTAARA(*LDA (654 10)) VALUE('          ')  /*CPM005*/
                RETURN                                                /*CPM005*/
             ENDDO                                                    /*CPM005*/
             CALL       PGM(PM6070)                                   /*CPM005*/
 /* RETRIEVE DATA AREA *LDA */                                        /*CPM005*/
             RTVDTAARA  DTAARA(*LDA (540 1)) RTNVAR(&ENQT)            /*CPM005*/
             IF         COND(&ENQT *EQ 'Y' *OR &ENQT *EQ 'P' *OR +
                          &ENQT *EQ 'C') THEN(DO)                     /*CPM005*/
             RETURN                                                   /*CPM005*/
             GOTO       CMDLBL(END)                                   /*CPM005*/
             ENDDO                                                    /*CPM005*/
             ENDDO                                                    /*CPM005*/
/*                                                                    /*CPM005*/
/*  START /TRANSFER BACK TO "TOTALS BY INSTRUMENT AND CURRENCY"       /*CPM005*/
             IF         COND(&DSPG *EQ 'TOTICY    ') THEN(DO)         /*CPM005*/
             CHGDTAARA  DTAARA(*LDA (540 1)) VALUE(' ')               /*CPM005*/
             IF         COND(&ACTP *EQ 'PM6090') THEN(DO)
                CHGDTAARA  DTAARA(*LDA (654 10)) VALUE('          ')  /*CPM005*/
                RETURN                                                /*CPM005*/
             ENDDO                                                    /*CPM005*/
             CALL       PGM(PM6090)                                   /*CPM005*/
 /* RETRIEVE DATA AREA *LDA */                                        /*CPM005*/
             RTVDTAARA  DTAARA(*LDA (540 1)) RTNVAR(&ENQT)            /*CPM005*/
             IF         COND(&ENQT *EQ 'Y' *OR &ENQT *EQ 'P' *OR +
                          &ENQT *EQ 'C') THEN(DO)                     /*CPM005*/
             RETURN                                                   /*CPM005*/
             GOTO       CMDLBL(END)                                   /*CPM005*/
             ENDDO                                                    /*CPM005*/
             ENDDO                                                    /*CPM005*/
/*                                                                    /*CPM005*/
/*  START /TRANSFER BACK TO "NET COMMITMENT BY CURRENCY"              /*CPM005*/
             IF         COND(&DSPG *EQ 'NETCCY    ') THEN(DO)         /*CPM005*/
             CHGDTAARA  DTAARA(*LDA (540 1)) VALUE(' ')               /*CPM005*/
             IF         COND(&ACTP *EQ 'PM6020') THEN(DO)
                CHGDTAARA  DTAARA(*LDA (654 10)) VALUE('          ')  /*CPM005*/
                RETURN                                                /*CPM005*/
             ENDDO                                                    /*CPM005*/
             CALL       PGM(PM6020)                                   /*CPM005*/
 /* RETRIEVE DATA AREA *LDA */                                        /*CPM005*/
             RTVDTAARA  DTAARA(*LDA (540 1)) RTNVAR(&ENQT)            /*CPM005*/
             IF         COND(&ENQT *EQ 'Y' *OR &ENQT *EQ 'P' *OR +
                          &ENQT *EQ 'C') THEN(DO)                     /*CPM005*/
             RETURN                                                   /*CPM005*/
             GOTO       CMDLBL(END)                                   /*CPM005*/
             ENDDO                                                    /*CPM005*/
             ENDDO                                                    /*CPM005*/
/*                                                                    /*CPM005*/
             GOTO       CMDLBL(RESTART)                               /*CPM005*/
             ENDDO                                                    /*063197*/
 END:                                                                 /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
