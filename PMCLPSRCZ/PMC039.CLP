/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Daily transaction Extracts')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas     PORTFOLIO MANAGEMENT MODULE                       */
/*                                                                   */
/*       PMC039     PM DAILY TRANSACTION EXTRACT                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. CPM003             DATE 02MAY96              */
/*       PREV AMEND NO. S71062             DATE 25JAN96              */
/*                      S01408             DATE 05MAY95              */
/*                      S01486             DATE 20OCT94              */
/*                      R10041             DATE 16/09/90             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPM003 - FF/PM Interface upgrade to Release 10              */
/*       S71062 - FF/PM interface                                    */
/*                Re-apply FF coding                                 */
/*       S01408 - Addition of core hook PMC039001                    */
/*       S01486 - Portfolio Management Upgrade to R10                */
/*       R10041 - REMOVE POSTINGS EXTRACT AND DAILY TRANSACTION      */
/*                THESE WILL BE RUN AFTER POSTINGS GENERATED         */
/*                                                                   */
/*********************************************************************/
PGM
/* DECLARE VARIABLES */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/************DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)                /*S01486*/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)                /*S01486*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MDID) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(800)                /*CPM003*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CPM003*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CPM003*/
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC039 - PM Daily Transactions +
                          Extract') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* RETRIEVE DTAARA MMOD TO CHECK MODULES PRESENT */
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/* CLEAR FILES */
/************CLRPFM     FILE(PMTRCNPP)                                /*S01486*/
/************CLRPFM     FILE(PMTRCNZZ)                                /*S01486*/
             CLRPFM     FILE(PMTRCNPD)                                /*S01486*/
             CLRPFM     FILE(PMTRCNPA)                                /*S01486*/
 
/**CALL*FIDUCIARY*TRANSACTIONS*EXTRACT**/                             /*S01486*/
/************CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 81 1))            /*S01486*/
/************IF         COND(&MDID = 'Y') THEN(DO)                    /*S01486*/
/************CALL       PGM(PMC0388)                                  /*S01486*/
/**PROCESS*ANY*DATA*BASE*ERROR */                                     /*S01486*/
/************IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +           /*S01486*/
/*************            CMDLBL(ABNOR))                              /*S01486*/
/**CHECK*FOR*FILE*CONTROL*ERRORS*TRAPPED*BY*THE*PROGRAM */            /*S01486*/
/************IF         COND(%SWITCH(XXXXXX01)) THEN(GOTO +           /*S01486*/
/************             CMDLBL(ABNOR))                              /*S01486*/
/************ENDDO                                                    /*S01486*/
 
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC039001                                           */
                                                                      /*S01408*/
/* CALL SECURITIES TRANSACTION EXTRACT */
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 21 1))
             IF         COND(&MDID = 'Y') THEN(DO)
             CALL       PGM(PMC0390)
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(GOTO +
                          CMDLBL(ABNOR))
             ENDDO
 
/**CALL*FUTURES*AND*OPTIONS*TRANSACTION*EXTRACT**/                    /*S01486*/
/************CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 50 1))            /*S01486*/
/************IF         COND(&MDID = 'Y') THEN(DO)                    /*S01486*/
/************CALL       PGM(PMC0392)                                  /*S01486*/
/**PROCESS*ANY*DATA*BASE*ERROR**/                                     /*S01486*/
/************IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +           /*S01486*/
/************             CMDLBL(ABNOR))                              /*S01486*/
/**CHECK*FOR*FILE*CONTROL*ERRORS*TRAPPED*BY*THE*PROGRAM**/            /*S01486*/
/************IF         COND(%SWITCH(XXXXXX01)) THEN(GOTO +           /*S01486*/
/************             CMDLBL(ABNOR))                              /*S01486*/
/************ENDDO                                                    /*S01486*/
                                                                      /*S71062*/
/* CALL FUTURES AND OPTIONS TRANSACTION EXTRACT */                    /*S71062*/
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 50 1))            /*S71062*/
             IF         COND(&MDID = 'Y') THEN(DO)                    /*S71062*/
/* If Bank Portfolios are supported, treat as if FF off               /*CPM003*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CPM003*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*CPM003*/
             CALL       PGM(AOPORTR0) PARM(&RTCD &OPTN &FMT)          /*CPM003*/
             IF         COND(%SST(&FMT 112 1) *NE 'B') THEN(DO)       /*CPM003*/
             CALL       PGM(PMC0392)                                  /*S71062*/
/* PROCESS ANY DATA BASE ERROR */                                     /*S71062*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                              /*S71062*/
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */            /*S71062*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(GOTO +
                          CMDLBL(ABNOR))                              /*S71062*/
             ENDDO                                                    /*CPM003*/
             ENDDO                                                    /*S71062*/
 
/* CALL DEALING TRANSACTION EXTRACT */
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 2 1))
             IF         COND(&MDID = 'Y') THEN(DO)
             CALL       PGM(PMC0394)
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(GOTO +
                          CMDLBL(ABNOR))
             ENDDO
 
/* CALL LENDING TRANSACTION EXTRACT */
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 10 1))
             IF         COND(&MDID = 'Y') THEN(DO)
             CALL       PGM(PMC0396)
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(GOTO +
                          CMDLBL(ABNOR))
             ENDDO
 
/* CALL RETAIL TRANSACTION EXTRACT */
/*           CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 16 1))     R10041*/
/*           IF         COND(&MDID = 'Y') THEN(DO)             R10041*/
/*           CALL       PGM(PMC0398)                           R10041*/
/* PROCESS ANY DATA BASE ERROR                                 R10041*/
/*           IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +    R10041*/
/*                        CMDLBL(ABNOR))                       R10041*/
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM        R10041*/
/*           IF         COND(%SWITCH(XXXXXX01)) THEN(GOTO +    R10041*/
/*                        CMDLBL(ABNOR))                       R10041*/
/*           ENDDO                                             R10041*/
/*                                                             R10041*/
/* CALL DAILY TRANSACTIONS REPORT                              R10041*/
/*           CALL       PGM(PMC0400) PARM(C)                   R10041*/
/*                                                             R10041*/
/* PROCESS ANY DATA BASE ERROR                                 R10041*/
/*           IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +    R10041*/
/*                        CMDLBL(ABNOR))                       R10041*/
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM        R10041*/
/*           IF         COND(%SWITCH(XXXXXX01)) THEN(GOTO +    R10041*/
/*                        CMDLBL(ABNOR))                       R10041*/
ABNOR:
/*ENDPGM:***  ENDPGM                                               */ /*S01486*/
 ENDPGM:                                                              /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01486*/
