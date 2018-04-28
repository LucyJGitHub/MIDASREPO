/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Trans Update Phase 1 (EOC)')                 */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC1008  -  TRANSACTIONS UPDATE PHASE 1 (EOC)                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. CFF007             Date 13Feb01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             Date 10Oct95              */
/*                      E23409             Date 31Auq90              */
/*                  S01117             DATE 19APR90                  */
/*                  S01240             DATE 12/04/89                 */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CFF007 - Futures and Options Enhancement for Private Banking*/
/*   S01408 - Apply Core Hooks FFC1008INT                            */
/*                             FFC1008MPS                            */
/*                             FFC1008001                            */
/*                             FFC1008002                            */
/*                             FFC1008MPE                            */
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
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MKT)
/**/
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(70)
/*********** DCL        VAR(&MEM1) TYPE(*CHAR) LEN(44)             */ /*S01117*/
             DCL        VAR(&MEM1) TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ')                    /*CFF007*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CFF007*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CFF007*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*CFF007*/
             DCL        VAR(&CFF007) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CFF007*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*/COPY WNCPYSRC,FFC1008INT                                        */ /*S01408*/
 
/**/
/* GLOBAL MONITOR MESSAGE                                           */
/**/
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
/*/COPY WNCPYSRC,FFC1008MPS                                        */ /*S01408*/
/**/                                                                                      /*CFF007*/
/** Check for Switchable feature CFF007                                                   /*CFF007*/
/**/                                                                                      /*CFF007*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CFF007*/
             CHGVAR     VAR(&SARD) VALUE('CFF007')                                        /*CFF007*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD +
                                           &FMT)                                          /*CFF007*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CFF007) VALUE('Y'))                                        /*CFF007*/
 
/**/
/*   TEST FOR RETAIL II OR INTEREST ON ACCOUNTS       */           /*E23409*/
/*     ( SET ON U2 IF PRESENT)                        */           /*E23409*/
/**/                                                               /*E23409*/
             CHGJOB     SWS(XXXXX100)                              /*E23409*/
             RTVDTAARA  DTAARA(MMOD *ALL) RTNVAR(&MMOD)            /*E23409*/
             IF         COND((%SST(&MMOD 16 1) *EQ 'Y') *OR +
                          (%SST(&MMOD 23 1) *EQ 'Y')) +
                          THEN(CHGJOB SWS(X1XXXXXX))               /*E23409*/
/**/                                                               /*E23409*/
/****TEST*FOR*RETAIL*II*MODULE*-*SETON*U2*IF*PRESENT***//************E23409*/
/************CHGJOB*****SWS(XXXXX100)********************************E23409*/
/************RTVDTAARA**DTAARA(MMOD *ALL) RTNVAR(&MMOD)**************E23409*/
/************IF*********COND((%SST(&MMOD 3 1) *EQ 'Y') *AND +********E23409*/
/*************************(%SST(&MMOD 16 1) *EQ 'Y')) +**************E23409*/
/*************************THEN(CHGJOB SWS(X1XXXXXX))*****************E23409*/
/**/
/* OVERRIDE MULTIMEMBER FILES TO MEMBER FOR MARKET CENTRE           */
/* FOR WHICH EOC IS RUNNING (&MKT)                                   */
/**/
 
/*/COPY WNCPYSRC,FFC1008001                                        */ /*S01408*/
 
             IF         COND(&CFF007 *EQ 'Y') THEN(OVRDBF +
                          FILE(TRANS12) MBR(&MKT))                                        /*CFF007*/
             OVRDBF     FILE(TRANS3) MBR(&MKT)
             OVRDBF     FILE(TRSET) MBR(&MKT)
             OVRDBF     FILE(MEMOSM) MBR(&MKT)
             OVRDBF     FILE(PRONOM) MBR(&MKT)
                                                                     /*S01240*/
             OVRDBF     FILE(FFACMVD) MBR(&MKT)                      /*S01240*/
                                                                     /*S01240*/
             OVRDBF     FILE(FOKEYA) MBR(&MKT)
             OVRDBF     FILE(FOKEYD) MBR(&MKT) SEQONLY(*YES 100)
             OVRDBF     FILE(POCHGTC) MBR(&MKT) SEQONLY(*YES 100)
             OVRDBF     FILE(POCHGTK) MBR(&MKT) SEQONLY(*YES 100)
/**/
/*     CALL TRANSACTIONS UPDATE PHASE 1                              */
/**/
             CALL       PGM(FF0380) PARM(&MKT)
/*                                                                  */
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ                                                */
/*                                                                  */
         IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*********** RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM1)         */ /*S01117*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM1)            /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM1) +
                          TOMSGQ(MOPERQ)
             CHGVAR     VAR(&ACT) VALUE('I')
             CHGVAR     VAR(&MSG) VALUE('Database Error - FFC1008')
             CALL       FF0473 PARM(&MKT &ACT &MSG)
         ENDDO
 
             IF         COND(&CFF007 *EQ 'Y') THEN(DO)                                    /*CFF007*/
             CALL       PGM(FF000381) PARM(&MKT)                                          /*CFF007*/
/**/                                                                                      /*CFF007*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CFF007*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM1)                            /*CFF007*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM1) +
                          TOMSGQ(MOPERQ MRUNQ)                                            /*CFF007*/
             CHGVAR     VAR(&ACT) VALUE('I')                                              /*CFF007*/
             CHGVAR     VAR(&MSG) VALUE('Database Error - FFC1008')                       /*CFF007*/
             CALL       PGM(FF0473) PARM(&MKT &ACT &MSG)                                  /*CFF007*/
             GOTO       CMDLBL(END)                                                       /*CFF007*/
             ENDDO                                                                        /*CFF007*/
             ENDDO                                                                        /*CFF007*/
/*/COPY WNCPYSRC,FFC1008MPE                                        */ /*S01408*/
 
/**/
         GOTO       CMDLBL(END)
/**/
/*   ERROR PROCESSING IF PROGRAM FAILS                             */
/**/
 ABNOR: CHGJOB     SWS(XXXXXX1X)
/**/
/*  REMOVE ALL FILE OVERRIDES                                        */
/**/
END:    DLTOVR     FILE(FOKEYA)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(FOKEYD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(POCHGTC)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(POCHGTK)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(TRANS3)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(TRSET)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(MEMOSM)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(PRONOM)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                                                                     /*S01240*/
        DLTOVR     FILE(FFACMVD)                                     /*S01240*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)               /*S01240*/
                                                                     /*S01240*/
             IF         COND(&CFF007 *EQ 'Y') THEN(DO)                                    /*CFF007*/
             DLTOVR     FILE(TRANS12)                                                     /*CFF007*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                    /*CFF007*/
             ENDDO                                                                        /*CFF007*/
 
/*/COPY WNCPYSRC,FFC1008002                                        */ /*S01408*/
 
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
        ENDPGM
