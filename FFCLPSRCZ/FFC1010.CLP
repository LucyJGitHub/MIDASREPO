/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Position Revaluation (EOC)')                 */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC1010  -  POSITION REVALUATION (EOC)                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*   Last Amend No. CPB001                 Date 15Jun99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   Prev Amend No. CPM003                 DATE 02MAY96              */
/*                  S71062                 DATE 18DEC95              */
/*                  S01408                 DATE 09JAN96              */
/*                  E23409                 DATE 31AUG90              */
/*                  S01117                 DATE 21JUN90              */
/*                  S01240                 DATE 14/04/89             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   CPB001 - Private Banking Module                                 */
/*   CPM003 - FF/PM Interface upgrade to Release 10                  */
/*   S71062 - FF/PM Interface                                        */
/*   S01408 - Addition of core hooks FFC1010001                      */
/*                                   FFC1010002                      */
/*   E23409 - SETTLEMENT ACROSS RETAIL ACCOUNTS ALLOWED IF RETAIL II */
/*            OR INTEREST ON ACCOUNTS INSTALLED - SETON U2 IF RE OR  */
/*            IA = 'Y'.   NOTE - RETAIL I NOT SUPPORTED ON AS/400    */
/*   S01117 - MULTIBRANCHING                                         */
/*   S01240 - ADDITION OF REAL-TIME STATEMENTS                       */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CREATION REQUIREMENTS                                         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MKT)
/**/
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(70)
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S71062*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S71062*/
             DCL       VAR(&FMT) TYPE(*CHAR) LEN(800)                 /*S71062*/
             DCL        VAR(&FMT2) TYPE(*CHAR) LEN(800)               /*CPM003*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
             CHGJOB     SWS(XXXXX100)
/**/
/*   TEST FOR RETAIL II OR INTEREST ON ACCOUNTS       */           /*E23409*/
/*     ( SET ON U2 IF PRESENT)                        */           /*E23409*/
/**/                                                               /*E23409*/
             RTVDTAARA  DTAARA(MMOD *ALL) RTNVAR(&MMOD)            /*E23409*/
             IF         COND((%SST(&MMOD 16 1) *EQ 'Y') *OR +
                          (%SST(&MMOD 23 1) *EQ 'Y')) +
                          THEN(CHGJOB SWS(X1XXXXXX))               /*E23409*/
/**/                                                               /*E23409*/
/****TEST*FOR*RETAIL*II*MODULE*-*SET*ON*U2*IF*IT*IS*PRESENT**********E23409*/
/************RTVDTAARA  DTAARA(MMOD *ALL) RTNVAR(&MMOD)**************E23409*/
/************IF*********COND((%SST(&MMOD 3 1) *EQ 'Y') *AND +********E23409*/
/*************************(%SST(&MMOD 16 1) *EQ 'Y')) THEN(DO)*******E23409*/
/****************CHGJOB*****SWS(X1XXXXXX)****************************E23409*/
/************ENDDO***************************************************E23409*/
/**/
/*  OVERRIDE TO CORRECT MARKET                                      */
/**/
             OVRDBF     FILE(POSTNC) MBR(&MKT)
             OVRDBF     FILE(POSTNK) MBR(&MKT)
             OVRDBF     FILE(WUNRLC) MBR(&MKT)
             OVRDBF     FILE(WUNRLK) MBR(&MKT)
             OVRDBF     FILE(POCHGRC) MBR(&MKT) SEQONLY(*YES 100)
             OVRDBF     FILE(POCHGRK) MBR(&MKT) SEQONLY(*YES 100)
             OVRDBF     FILE(MEMOSM) MBR(&MKT)
             OVRDBF     FILE(PRONOM) MBR(&MKT)
                                                                     /*S01240*/
             OVRDBF     FILE(FFACMVD) MBR(&MKT)                      /*S01240*/
                                                                     /*S01240*/
             OVRDBF     FILE(FOKEYA) MBR(&MKT)
             OVRDBF     FILE(FOKEYD) MBR(&MKT) SEQONLY(*YES 100)
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FFC1010001                                          */
/**/                                                                  /*S01408*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S71062*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*S71062*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*S71062*/
                                                                      /*S71062*/
/*********** IF         COND(%SST(&FMT 65 1) *EQ 'Y') THEN(DO) S71062 /*CPB001*/
             IF         COND((%SST(&FMT 65 1) *EQ 'Y') *OR +
                          (%SST(&FMT 104 1) *EQ 'Y')) THEN(DO)        /*CPB001*/
/* If Bank Portfolios are supported, treat as if FF off               /*CPM003*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CPM003*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*CPM003*/
             IF         COND(%SST(&FMT 65 1) *EQ 'Y') THEN(DO)        /*CPB001*/
             CALL       PGM(AOPORTR0) PARM(&RTCD &OPTN &FMT2)         /*CPM003*/
             ENDDO                                                    /*CPB001*/
/*********** IF         COND(%SST(&FMT2 112 1) *NE 'B') THEN(DO)CPM003/*CPB001*/
             IF         COND((%SST(&FMT2 112 1) *NE 'B') *OR +
                          (%SST(&FMT 104 1) *EQ 'Y')) THEN(DO)        /*CPB001*/
             OVRDBF     FILE(TRANS7) MBR(&MKT)                        /*S71062*/
             ENDDO                                                    /*CPM003*/
             ENDDO                                                    /*S71062*/
/**/
/*     CALL FF0400 - POSITION REVALUATION                            */
/**/
             CALL       PGM(FF0400) PARM(&MKT)
/**/
/*     DATABASE ERROR?  IF SO SEND MESSAGE TO MOPERQ AND CALL FF0473 */
/*     - THE ERROR MONITORING PROGRAM                                */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*********** RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)          */ /*S01117*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                         TOMSGQ(MOPERQ)
             CHGVAR     VAR(&ACT) VALUE('I')
             CHGVAR     VAR(&MSG) VALUE('Database Error - FFC1010')
             CALL       FF0473 PARM(&MKT &ACT &MSG)
             ENDDO
/*                                                                    /*S71062*/
/*********** IF         COND(%SST(&FMT 65 1) *EQ 'Y') THEN(DO) *S71062**CPM003*/
/*********** IF         COND((%SST(&FMT 65 1) *EQ 'Y') *AND +
                          (%SST(&FMT2 112 1) *NE 'B')) THEN(DO) CPM003/*CPB001*/
             IF         COND((%SST(&FMT 65 1) *EQ 'Y') *AND +
                          (%SST(&FMT2 112 1) *NE 'B') *OR +
                          (%SST(&FMT 104 1) *EQ 'Y')) THEN(DO)        /*CPB001*/
             CALL       PGM(FF0401) PARM(&MKT)                        /*S71062*/
/**/                                                                  /*S71062*/
/*     DATABASE ERROR?  IF SO SEND MESSAGE TO MOPERQ AND CALL FF0473  /*S71062*/
/*     - THE ERROR MONITORING PROGRAM                                 /*S71062*/
/**/                                                                  /*S71062*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S71062*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S71062*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                         TOMSGQ(MOPERQ)                               /*S71062*/
             CHGVAR     VAR(&ACT) VALUE('I')                          /*S71062*/
             CHGVAR     VAR(&MSG) VALUE('Database Error - FFC1010')   /*S71062*/
             CALL       FF0473 PARM(&MKT &ACT &MSG)                   /*S71062*/
             ENDDO                                                    /*S71062*/
             ENDDO                                                    /*S71062*/
/*                                                                   */
             GOTO       CMDLBL(END)
/**/
/*   ERROR PROCESSING IF PROGRAM FAILS                             */
/**/
ABNOR:
             CHGJOB     SWS(XXXXXX1X)
/**/
/*      DELETE ALL OVERRIDES                                        */
/**/
END:         DLTOVR     FILE(POSTNC)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(POSTNK)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(WUNRLC)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(WUNRLK)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(MEMOSM)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(PRONOM)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                                                                     /*S01240*/
             DLTOVR     FILE(FFACMVD)                                /*S01240*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)               /*S01240*/
                                                                     /*S01240*/
             DLTOVR     FILE(FOKEYA)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(FOKEYD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(POCHGRC)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(POCHGRK)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FFC1010002                                          */
/**/                                                                  /*S01408*/
             DLTOVR     FILE(TRANS7)                                  /*S71062*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S71062*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
