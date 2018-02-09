/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Trading summary updates (COB)')              */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC0660  -  TRADING SUMMARY UPDATES (COB)                       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. 193321             Date 19Jul01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                  CPB001             Date 15Jun99                  */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                  157661             Date 22Mar99                  */
/*                  108510             DATE 25APR96                  */
/*                  S01408             DATE 14MAY96                  */
/*                  CPM003             DATE 02MAY96                  */
/*                  S71062             DATE 08DEC95                  */
/*                  082461             DATE 08MAR95                  */
/*                  S01117             DATE 03MAY90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   193321 - Call of FF0521 should be done even PB or PM not on     */
/*   CCB009 - Journal files throughout close of business             */
/*   CPB001 - Private Banking Module                                 */
/*   157661 - U2 should be on if RE or IOA are present.              */
/*   108510 - FF0520 PROCESSING HAS BEEN COMPLETELY REVIEWED         */
/*            THE OVRDBF ON TSCCYD IS NO MORE USED                   */
/*   S01048 - Core hook FFC0660005 added                             */
/*            Core hook FFC0660004 added                             */
/*            Core hook FFC0660003 added                             */
/*            Core hook FFC0660002 added                             */
/*            Core hook FFC0660001 added                             */
/*   CPM003 - FF/PM Interface upgrade to Release 10                  */
/*   S71062 - FF/PM Initial margin                                   */
/*   082461 - If journalling fails because pgm cannot allocate file, */
/*            retry before failing.                                  */
/*   S01117 - MULTIBRANCHING                                         */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/*   DECLARE VARIABLES                                              */
/**/
/*********** DCL        &MEM          TYPE(*CHAR)  LEN(44)         */ /*S01117*/
             DCL        &MEM          TYPE(*CHAR)  LEN(50)            /*S01117*/
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1)                 /*082461*/
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)                  /*S71062*/
             DCL        VAR(&A) TYPE(*DEC) LEN(2 0) VALUE(1)          /*S71062*/
             DCL        VAR(&FFEOC) TYPE(*CHAR) LEN(62)               /*S71062*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S71062*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S71062*/
             DCL       VAR(&FMT) TYPE(*CHAR) LEN(800)                 /*S71062*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*157661*/
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*082461*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
                                                                      /*082461*/
/*   SEND MESSAGE TO MSGQ/MRUNQ                                    */
/**/
             SNDPGMMSG  MSG('FFC0660 - Trading +
                          Summary Updates') TOMSGQ(MRUNQ)
/**/
/* START JOURNALLING UPDATE AND OUTPUT FILES                        */
/**/
RETRY:                                                                /*082461*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
STRJRNPF   FILE(*LIBL/FOKEYD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/FOKEYA) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/WCOLTD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/TSCCYD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/TSMKTD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/WCOLTDM) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)                                         /*S71062*/
             MONMSG     MSGID(CPF7030)                                /*S71062*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*S71062*/
STRJRNPF   FILE(*LIBL/TRANSD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)                                         /*S71062*/
             MONMSG     MSGID(CPF7030)                                /*S71062*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*S71062*/
                                                                      /*082461*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FFC0660001                                           /*S01408*/
/**/                                                                  /*S01408*/
             GOTO       CMDLBL(BYPASS)                                /*082461*/
                                                                      /*082461*/
JRNFAIL:                                                              /*082461*/
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)                 /*082461*/
             IF         COND(&COUNT *LE 3) THEN(DO)                   /*082461*/
             DLYJOB     DLY(60)                                       /*082461*/
             GOTO       CMDLBL(RETRY)                                 /*082461*/
             ENDDO                                                    /*082461*/
             ELSE       CMD(DO)                                       /*082461*/
             GOTO       CMDLBL(ABNOR)                                 /*082461*/
             ENDDO                                                    /*082461*/
             ENDDO                                                    /*CCB009*/
BYPASS:                                                               /*082461*/
/**/
/*  CALL START JOURNAL PROCESSING FOR SUB-COMPONENT                 */
/**/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FFC0660002                                           /*S01408*/
/**/                                                                  /*S01408*/
/************FFCJRN2    FILES(FOKEYD FOKEYA WCOLTD TSCCYD TSMKTD)*/   /*S71062*/
             FFCJRN2    FILES(FOKEYD FOKEYA WCOLTD TSCCYD TSMKTD +
                          WCOLTDM TRANSD)                             /*S71062*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FFC0660003                                           /*S01408*/
/**/                                                                  /*S01408*/
/**/
/***OVERRIDE*PF/FOKEYD*AND*PF/TSCCYD                         108510 */
/*  OVERRIDE PF/FOKEYD                                       108510 */
/**/
             OVRDBF     FILE(FOKEYD) SEQONLY(*YES 100)
/*           OVRDBF     FILE(TSCCYD) SEQONLY(*YES 100)       108510 */
/**/
/*  TRADING SUMMARY UPDATES NEED U6 ON (FOR FFSETL)                 */
/**/
             CHGJOB     SWS(XXXXX100)
/**/                                                               /*157661*/
/*   TEST FOR RETAIL II OR INTEREST ON ACCOUNTS       */           /*157661*/
/*     ( SET ON U2 IF PRESENT)                        */           /*157661*/
/**/                                                               /*157661*/
             RTVDTAARA  DTAARA(MMOD *ALL) RTNVAR(&MMOD)            /*157661*/
             IF         COND((%SST(&MMOD 16 1) *EQ 'Y') *OR +
                          (%SST(&MMOD 23 1) *EQ 'Y')) +
                          THEN(CHGJOB SWS(X1XXXXXX))               /*157661*/
/**/
/*   CALL FF0520 - TRADING SUMMARY UPDATES                          */
/**/
             CALL       PGM(FF0520)
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ AND MRUNQ.                                     */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO END                                             /*S71062*/
             ENDDO
/**/                                                                  /*S71062*/
/*   CALL FF0521 - INITIAL MARGIN ACCOUNT KEYS, IF FF0520 IS           *S71062*/
/*                 COMPLETED SUCCESSFULLY                              *S71062*/
                                                                      /*S71062*/
/**********  CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S71062 193321*/
/**********  CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*S71062 193321*/
/**********  CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*S71062 193321*/
/*********** IF         COND(%SST(&FMT 65 1) *EQ 'Y') THEN(DO) S71062 /*CPB001*/
/**********  IF         COND((%SST(&FMT 65 1) *EQ 'Y') *OR +
                          (%SST(&FMT 104 1) *EQ 'Y')) THEN(DO)        /*CPB001 193321*/
                                                                      /*S71062*/
/**If*Bank*Portfolios are supported, treat as if FF off               /*CPM003 193321*/
/**********  CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CPM003 193321*/
/**********  CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*CPM003 193321*/
/**********  IF         COND(%SST(&FMT 65 1) *EQ 'Y') THEN(DO)        /*CPB001 193321*/
/**********  CALL       PGM(AOPORTR0) PARM(&RTCD &OPTN &FMT)          /*CPM003 193321*/
/**********  ENDDO                                                    /*CPB001 193321*/
/*********** IF         COND(%SST(&FMT 112 1) *NE 'B') THEN(DO)CPM003 /*CPB001*/
/**********  IF         COND((%SST(&FMT 112 1) *NE 'B') *OR +
/**********               (%SST(&FMT 104 1) *EQ 'Y')) THEN(DO)        /*CPB001 193321*/
             DLTOVR     FILE(*ALL)                                    /*S71062*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S71062*/
                                                                      /*S71062*/
             OVRDBF     FILE(FOKEYD) MBR(OTC) SEQONLY(*YES 100)       /*S71062*/
             OVRDBF     FILE(FOKEYA) MBR(OTC)                         /*S71062*/
             OVRDBF     FILE(TRANS)  MBR(OTC)                         /*S71062*/
             OVRDBF     FILE(TRSET)  MBR(OTC)                         /*S71062*/
                                                                      /*S71062*/
             CALL       PGM(FF0521) PARM('  ')                        /*S71062*/
                                                                      /*S71062*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S71062*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S71062*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                               TOMSGQ(MOPERQ MRUNQ)                   /*S71062*/
                 GOTO END                                             /*S71062*/
             ENDDO                                                    /*S71062*/
                                                                      /*S71062*/
             DLTOVR     FILE(*ALL)                                    /*S71062*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S71062*/
/**/                                                                  /*S71062*/
/* LOOP TO PROCESS ALL MARKET CENTRES CONTAINED IN DTAARA/FFEOC */    /*S71062*/
/**/                                                                  /*S71062*/
             RTVDTAARA  DTAARA(FFEOC) RTNVAR(&FFEOC)                  /*S71062*/
/**/                                                                  /*S71062*/
 LOOP:       IF         COND((%SST(&FFEOC &A 2) *EQ '  ') *OR (&A *GT +
                          61)) THEN(GOTO CMDLBL(END))                 /*S71062*/
             CHGVAR     VAR(&MKT) VALUE(%SST(&FFEOC &A 2))            /*S71062*/
                                                                      /*S71062*/
/**/                                                                  /*S71062*/
/*  OVERRIDE MULTI-MEMBER FILES TO CORRECT MEMBER FOR MARKET */       /*S71062*/
/**/                                                                  /*S71062*/
             OVRDBF     FILE(FOKEYD) MBR(&MKT) SEQONLY(*YES 100)      /*S71062*/
             OVRDBF     FILE(FOKEYA) MBR(&MKT)                        /*S71062*/
             OVRDBF     FILE(TRANS)  MBR(&MKT)                        /*S71062*/
             OVRDBF     FILE(TRSET)  MBR(&MKT)                        /*S71062*/
                                                                      /*S71062*/
             CALL       PGM(FF0521) PARM(&MKT)                        /*S71062*/
                                                                      /*S71062*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S71062*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S71062*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                               TOMSGQ(MOPERQ MRUNQ)                   /*S71062*/
                 GOTO END                                             /*S71062*/
             ENDDO                                                    /*S71062*/
                                                                      /*S71062*/
             CHGVAR     VAR(&A) VALUE(&A + 2)                         /*S71062*/
             GOTO       CMDLBL(LOOP)                                  /*S71062*/
/**********  ENDDO                                                    /*S71062 193321*/
/**********  ENDDO                                                    /*CPM003 193321*/
                                                                      /*S71062*/
/**/
             GOTO       CMDLBL(END)                                   /*082461*/
ABNOR:                                                                /*082461*/
             SNDPGMMSG  MSG('FFC0660 - Trading Summary Updates +
                          TERMINATED ABNORMALLY') TOMSGQ(MOPERQ +
                          MRUNQ)                                      /*082461*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082461*/
             DMPCLPGM                                                 /*082461*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082461*/
             CHGJOB     SWS(XXXXXX11)                                 /*082461*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082461*/
                                                                      /*082461*/
END:                                                                  /*082461*/
/*      DELETE ALL OVERRIDES                                        */
/**/
/************DLTOVR     FILE(FOKEYD)                               */ /*S71062*/
/************MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */ /*S71062*/
/************DLTOVR     FILE(TSCCYD)                               */ /*S71062*/
/************MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */ /*S71062*/
                                                                      /*S71062*/
             DLTOVR     FILE(*ALL)                                    /*S71062*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S71062*/
/**/
/*  TRADING SUMMARY UPDATES NEED U6 ON (FOR FFSETL)                 */
/**/
             CHGJOB     SWS(XXXXX0XX)
/**/
/*  CALL FINAL JOURNAL PROCESSING FOR SUB-COMPONENT                 */
/**/
/************FFCJRN3    FILES(FOKEYD FOKEYA WCOLTD TSCCYD TSMKTD)*/   /*S71062*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FFC0660004                                           /*S01408*/
/**/                                                                  /*S01408*/
             FFCJRN3    FILES(FOKEYD FOKEYA WCOLTD TSCCYD TSMKTD +
                          WCOLTDM TRANSD)                             /*S71062*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FFC0660005                                           /*S01408*/
/**/                                                                  /*S01408*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082461*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
