/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Trans Update Phase 2 (EOC)')                 */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC1009  -  TRANSACTIONS UPDATE PHASE 2 (EOC)                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CFF007             Date 13Feb01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 09Jan96              */
/*                      S01408             Date 10Oct95              */
/*                                     DATE 19APR90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CFF007 - Futures and Options Enhancement for Private        */
/*                Banking.                                           */
/*   S01408 - Apply Core Hooks FFC1009003                            */
/*                             FFC1009004                            */
/*   S01408 - Apply Core Hooks FFC1009INT                            */
/*                             FFC1009MPS                            */
/*                             FFC1009001                            */
/*                             FFC1009002                            */
/*                             FFC1009MPE                            */
/*   S01117 - MULTIBRANCHING                                         */
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
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CFF007*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CFF007*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CFF007*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*CFF007*/
             DCL        VAR(&CFF007) TYPE(*CHAR) LEN(1)                                   /*CFF007*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*/COPY WNCPYSRC,FFC1009INT                                        */ /*S01408*/
 
/**/
/* GLOBAL MONITOR MESSAGE                                           */
/**/
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
/*/COPY WNCPYSRC,FFC1009MPS                                        */ /*S01408*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CFF007*/
             CHGVAR     VAR(&SARD) VALUE('CFF007')                                       /* CFF007*/
             CHGVAR     VAR(&CFF007) VALUE('N')                                           /*CFF007*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                        /*CFF007*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CFF007) VALUE('Y'))                                        /*CFF007*/
 
             CHGJOB     SWS(XXXXXX00)
/**/
/* OVERRIDE MULTIMEMBER FILES TO MEMBER FOR MARKET CENTRE FOR WHICH */
/* EOC IS RUNNING (&MKT)                                            */
/**/
 
/*/COPY WNCPYSRC,FFC1009001                                        */ /*S01408*/
 
             OVRDBF     FILE(TRANS4) MBR(&MKT)
             OVRDBF     FILE(TRSET) MBR(&MKT)
             OVRDBF     FILE(PRICS) MBR(&MKT)
             OVRDBF     FILE(WUNRLC) MBR(&MKT)
             OVRDBF     FILE(WUNRLK) MBR(&MKT)
             OVRDBF     FILE(FOKEYA) MBR(&MKT)
             OVRDBF     FILE(FOKEYD) MBR(&MKT) SEQONLY(*YES 100)
             OVRDBF     FILE(POCHGCC) MBR(&MKT) SEQONLY(*YES 100)
             OVRDBF     FILE(POCHGCK) MBR(&MKT) SEQONLY(*YES 100)
             OVRDBF     FILE(POCHGTC) MBR(&MKT) SEQONLY(*YES 100)
             OVRDBF     FILE(POCHGTK) MBR(&MKT) SEQONLY(*YES 100)
             IF         COND(&CFF007 *EQ 'Y') THEN(OVRDBF +
                          FILE(TRANS14) MBR(&MKT))                                        /*CFF007*/
/**/
/*     CLEAR WORK FILES                                              */
/**/
             CLRPFM     FILE(WUNRLCD) MBR(&MKT)
             CLRPFM     FILE(WUNRLKD) MBR(&MKT)
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FFC1009003                                          */
/**/                                                                  /*S01408*/
/**/
/*     CALL TRANSACTIONS UPDATE PHASE 1                              */
/**/
             CALL       PGM(FF0390) PARM(&MKT)
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
             CHGVAR     VAR(&MSG) VALUE('Database Error - FFC1009')
             CALL       FF0473 PARM(&MKT &ACT &MSG)
         ENDDO
 
/*/COPY WNCPYSRC,FFC1009MPE                                        */ /*S01408*/
             IF         COND(&CFF007 *EQ 'Y') THEN(DO)                                    /*CFF007*/
               CALL       PGM(FF000391) PARM(&MKT)                                        /*CFF007*/
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                /*CFF007*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM1)                            /*CFF007*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM1) +
                          TOMSGQ(MOPERQ MRUNQ)                                            /*CFF007*/
                 CHGVAR     VAR(&ACT) VALUE('I')                                          /*CFF007*/
                 CHGVAR     VAR(&MSG) VALUE('Database Error- FFC1009')                    /*CFF007*/
                 CALL       PGM(FF0473) PARM(&MKT &ACT &MSG)                              /*CFF007*/
                 GOTO END                                                                 /*CFF007*/
               ENDDO                                                                      /*CFF007*/
             ENDDO                                                                        /*CFF007*/
 
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
        DLTOVR     FILE(POCHGCC)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(POCHGCK)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(POCHGTC)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(POCHGTK)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(TRANS4)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/*/COPY WNCPYSRC,FFC1009002                                        */ /*S01408*/
 
        DLTOVR     FILE(TRSET)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(PRICS)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(WUNRLC)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(WUNRLK)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             IF         COND(&CFF007 *EQ 'Y') THEN(DO)                                    /*CFF007*/
               DLTOVR     FILE(TRANS14)                                                   /*CFF007*/
               MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                  /*CFF007*/
             ENDDO                                                                        /*CFF007*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FFC1009004                                          */
/**/                                                                  /*S01408*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
        ENDPGM
