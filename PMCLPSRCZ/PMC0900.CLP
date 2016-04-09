/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Monthly FI/DL/LE/FF/SE Turnover Extracts')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                     */
/*                                                                   */
/*       PMC0900 - PM Turnover Extracts                              */
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
/*                      S01408             DATE 04APR96              */
/*                      S01408             DATE 05MAY95              */
/*                      S01486             DATE 06DEC94              */
/*                      049421             DATE 18JAN93              */
/*                      45867              DATE 27OCT92              */
/*                      R05779             DATE 03APR91              */
/*                      R00300             DATE 28AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPM003 - FF/PM Interface upgrade to Release 10              */
/*       S71062 - FF/PM interface                                    */
/*                Re-apply FF coding                                 */
/*       S01408 - Addition of core hook PMC0900INT                   */
/*                Addition of core hook PMC0900MPE                   */
/*                Addition of core hook PMC0900ERR                   */
/*                Addition of core hook PMC0900END                   */
/*                Addition of core hook PMC0900001                   */
/*       S01408 - Addition of core hook PMC0900MPS                   */
/*       S01486 - Portfolio Management Upgrade to Release 10         */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       45867  - INCLUDE COB PROCESSING                             */
/*       R05779 - CALL FIDUCIARY LOAN / DEPOSITS TURNOVER EXTRACT    */
/*       R00300 - Message file changes.                              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
PGM
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC0900INT                                          */
                                                                      /*S01408*/
/* DECLARE VARIABLES */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MDID) TYPE(*CHAR) LEN(1)
/* >>> 45867 >>> */
/*********   DCL        VAR(&PMSTAT) TYPE(*CHAR) LEN(256)                 ****/
/*********   DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)                 ****/
             DCL        VAR(&NBRREC2) TYPE(*DEC) LEN(10 0)
/*********** DCL        VAR(&DLIB) TYPE(*CHAR) LEN(6)                 /*S01486*/
             DCL        VAR(&DLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SBS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(800)                /*CPM003*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CPM003*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CPM003*/
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SBS)
 
/*********** CHGVAR     VAR(&DLIB) VALUE(&SBS *TCAT 'DLIB')        */ /*S01486*/
             CHGVAR     VAR(&DLIB) VALUE(&SBS *TCAT 'DPLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC0900MPS                                          */
                                                                      /*S01408*/
 
/*********** RTVMBRD    FILE(&DLIB/CBPM0460) NBRCURRCD(&NBRREC2)   */ /*S01486*/
/*********** MONMSG     MSGID(CPF3019)                             */ /*S01486*/
/*********** IF         COND(&NBRREC2 *GT 0) THEN(GOTO CMDLBL(OK)) */ /*S01486*/
 
/*********** RTVMBRD    FILE(&DLIB/CBPM0470) NBRCURRCD(&NBRREC2)   */ /*S01486*/
/*********** MONMSG     MSGID(CPF3019)                             */ /*S01486*/
/*********** IF         COND(&NBRREC2 *GT 0) THEN(GOTO CMDLBL(OK)) */ /*S01486*/
 
/*********** RTVMBRD    FILE(&DLIB/CBPM0480) NBRCURRCD(&NBRREC2)   */ /*S01486*/
/*********** MONMSG     MSGID(CPF3019)                             */ /*S01486*/
/*********** IF         COND(&NBRREC2 *GT 0) THEN(GOTO CMDLBL(OK)) */ /*S01486*/
 
/*********** RTVMBRD    FILE(&DLIB/CBPM0490) NBRCURRCD(&NBRREC2)   */ /*S01486*/
/*********** MONMSG     MSGID(CPF3019)                             */ /*S01486*/
/*********** IF         COND(&NBRREC2 *GT 0) THEN(GOTO CMDLBL(OK)) */ /*S01486*/
 
/*********** RTVMBRD    FILE(&DLIB/CBPM0500) NBRCURRCD(&NBRREC2)   */ /*S01486*/
/*********** MONMSG     MSGID(CPF3019)                             */ /*S01486*/
/*********** IF         COND(&NBRREC2 *GT 0) THEN(GOTO CMDLBL(OK)) */ /*S01486*/
 
/*********** RTVMBRD    FILE(&DLIB/CBPM0510) NBRCURRCD(&NBRREC2)   */ /*S01486*/
/*********** MONMSG     MSGID(CPF3019)                             */ /*S01486*/
/*********** IF         COND(&NBRREC2 *GT 0) THEN(GOTO CMDLBL(OK)) */ /*S01486*/
 
/*********** RTVMBRD    FILE(&DLIB/CBPM0520) NBRCURRCD(&NBRREC2)   */ /*S01486*/
/*********** MONMSG     MSGID(CPF3019)                             */ /*S01486*/
/*********** IF         COND(&NBRREC2 *GT 0) THEN(GOTO CMDLBL(OK)) */ /*S01486*/
 
/*********** RTVMBRD    FILE(&DLIB/CBPM0530) NBRCURRCD(&NBRREC2)   */ /*S01486*/
/*********** MONMSG     MSGID(CPF3019)                             */ /*S01486*/
/*********** IF         COND(&NBRREC2 *GT 0) THEN(GOTO CMDLBL(OK)) */ /*S01486*/
 
/*********** RTVMBRD    FILE(&DLIB/CBPM0540) NBRCURRCD(&NBRREC2)   */ /*S01486*/
/*********** MONMSG     MSGID(CPF3019)                             */ /*S01486*/
/*********** IF         COND(&NBRREC2 *GT 0) THEN(GOTO CMDLBL(OK)) */ /*S01486*/
 
/*********** RTVMBRD    FILE(&DLIB/CBPM0550) NBRCURRCD(&NBRREC2)   */ /*S01486*/
/*********** MONMSG     MSGID(CPF3019)                             */ /*S01486*/
/*********** IF         COND(&NBRREC2 *GT 0) THEN(GOTO CMDLBL(OK)) */ /*S01486*/
 
/*********** RTVMBRD    FILE(&DLIB/CBPM0560) NBRCURRCD(&NBRREC2)   */ /*S01486*/
/*********** MONMSG     MSGID(CPF3019)                             */ /*S01486*/
/*********** IF         COND(&NBRREC2 *EQ 0) THEN(GOTO CMDLBL(EOJ))*/ /*S01486*/
 
OK:
 
/* <<< 45867 <<< */
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC0900 - PM Current Turnover Extracts') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/*CLEAR OUT DETAILS OF CURRENT TURNOVER */
/*********** CLRPFM     FILE(PMCUTVPP)                      */ /*R05777 S01486*/
             CLRPFM     FILE(PMCUTVPD)                                /*S01486*/
 
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
                                                                      /*R05777*/
/**CALL*FI*TURNOVER*EXTRACT**********************************/ /*R05777 S01486*/
/*********** CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 81 1))  */ /*R05777 S01486*/
/*********** IF         COND(&MDID = 'Y') THEN(DO)          */ /*R05777 S01486*/
/*********** CALL       PGM(PMC0890)                        */ /*R05777 S01486*/
/**PROCESS*ANY*DATA*BASE*ERROR*******************************/ /*R05777 S01486*/
/*********** IF         COND(%SWITCH(XXXXXX11)) THEN(DO)    */ /*R05777 S01486*/
/***********    RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DAT */ /*R05777 S01486*/
/***********                                                */ /*R05777 S01486*/
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)           */ /*R05777 S01486*/
/***********                                                */ /*R05777 S01486*/
/*********** GOTO       CMDLBL(ABNOR)                       */ /*R05777 S01486*/
/*********** ENDDO                                          */ /*R05777 S01486*/
/**CHECK*FOR*FILE*CONTROL*ERRORS*TRAPPED*BY*THE*PROGRAM******/ /*R05777 S01486*/
/*********** IF         COND(%SWITCH(XXXXXX01)) THEN(DO)    */ /*R05777 S01486*/
/***********    RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DAT */ /*R05777 S01486*/
/***********                                                */ /*R05777 S01486*/
/***********    SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)           */ /*R05777 S01486*/
/***********                                                */ /*R05777 S01486*/
/*********** GOTO       CMDLBL(ABNOR)                       */ /*R05777 S01486*/
/*********** ENDDO                                          */ /*R05777 S01486*/
/*********ENDDO                                             */ /*R05777 S01486*/
 
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC0900001                                          */
                                                                      /*S01408*/
/* CALL DL TURNOVER EXTRACT */
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 2 1))
             IF         COND(&MDID = 'Y') THEN(DO)
             CALL       PGM(PM0900)
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
          ENDDO
 
/* CALL LE TURNOVER EXTRACT */
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 10 1))
             IF         COND(&MDID = 'Y') THEN(DO)
             CALL       PGM(PM0910)
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
          ENDDO
 
/**CALL*FF*TURNOVER*EXTRACT*****************************************/ /*S01486*/
/*********** CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 50 1))         */ /*S01486*/
/*********** IF         COND(&MDID = 'Y') THEN(DO)                 */ /*S01486*/
 
/*********** OPNQRYF    FILE((TRANS2)) QRYSLT('PTFR *NE "    " *AND +
                          RECI *EQ "D"') KEYFLD((ISTT) (YRNO) (MTHN) +
                          (PCAL) (STRP) (CUSC))                    */ /*S01486*/
/*********** CALL       PGM(PM0920)                                */ /*S01486*/
/*********** CLOF       OPNID(TRANS2)                              */ /*S01486*/
/**PROCESS*ANY*DATA*BASE*ERROR**************************************/ /*S01486*/
/*********** IF         COND(%SWITCH(XXXXXX11)) THEN(DO)           */ /*S01486*/
/***********    RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)      */ /*S01486*/
/***********                                                */ /*R00300 S01486*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
/***********                                                */ /*R00300 S01486*/
/*********** GOTO       CMDLBL(ABNOR)                              */ /*S01486*/
/*********** ENDDO                                                 */ /*S01486*/
/**CHECK*FOR*FILE*CONTROL*ERRORS*TRAPPED*BY*THE*PROGRAM*************/ /*S01486*/
/*********** IF         COND(%SWITCH(XXXXXX01)) THEN(DO)           */ /*S01486*/
/***********    RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)      */ /*S01486*/
/***********                                                */ /*R00300 S01486*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
/***********                                                */ /*R00300 S01486*/
/*********** GOTO       CMDLBL(ABNOR)                              */ /*S01486*/
/*********** ENDDO                                                 */ /*S01486*/
/*********ENDDO                                                    */ /*S01486*/
                                                                      /*S71062*/
/* CALL FF TURNOVER EXTRACT */                                        /*S71062*/
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 50 1))            /*S71062*/
             IF         COND(&MDID = 'Y') THEN(DO)                    /*S71062*/
/* If Bank Portfolios are supported, treat as if FF off               /*CPM003*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CPM003*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*CPM003*/
             CALL       PGM(AOPORTR0) PARM(&RTCD &OPTN &FMT)          /*CPM003*/
             IF         COND(%SST(&FMT 112 1) *NE 'B') THEN(DO)       /*CPM003*/
 
             OPNQRYF    FILE((TRANS2)) QRYSLT('PTFR *NE "    " *AND +
                          RECI *EQ "D"') KEYFLD((ISTT) (YRNO) (MTHN) +
                          (PCAL) (STRP) (CUSC))                       /*S71062*/
             CALL       PGM(PM0920)                                   /*S71062*/
             CLOF       OPNID(TRANS2)                                 /*S71062*/
/* PROCESS ANY DATA BASE ERROR */                                     /*S71062*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S71062*/
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*S71062*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*S71062*/
             GOTO       CMDLBL(ABNOR)                                 /*S71062*/
             ENDDO                                                    /*S71062*/
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */            /*S71062*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)              /*S71062*/
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*S71062*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*S71062*/
             GOTO       CMDLBL(ABNOR)                                 /*S71062*/
             ENDDO                                                    /*S71062*/
             ENDDO                                                    /*CPM003*/
          ENDDO                                                       /*S71062*/
 
/* CALL SE TURNOVER EXTRACT */
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 21 1))
             IF         COND(&MDID = 'Y') THEN(DO)
             CALL       PGM(PM0930)
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
          ENDDO
 
/* IF JOB ENDED NORMALLY */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             CHGDTAARA  DTAARA(PMSTAT (16 3)) VALUE('OLD')
/************DLTF       FILE(XPMCUTVPP)                                 R05777*/
/************MONMSG     MSGID(CPF2105)                                  R05777*/
/*********** CPYF       FROMFILE(PMHITVPP) TOFILE(PMCUTVPP) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)              */ /*S01486*/
             CPYF       FROMFILE(PMHITVPD) TOFILE(PMCUTVPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*S01486*/
          ENDDO
                                                                      /*S01408*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC0900MPE                                          */
                                                                      /*S01408*/
             GOTO       CMDLBL(END)                                   /*S01408*/
                                                                      /*S01408*/
ABNOR:
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC0900ERR                                          */
                                                                      /*S01408*/
END:                                                                  /*45867*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC0900END                                          */
                                                                      /*S01408*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM
