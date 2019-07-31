/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Instrument types maintenance')               */
/*********************************************************************/
/*                                                                   */
/*     Midas PORTFOLIO MANAGEMENT MODULE                         */
/*                                                                   */
/*     PMC0030 - INSTRUMENT TYPES MAINTAINANCE                       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01486             Date 29Jun94              */
/*                      32914              Date 05Dec91              */
/*                    R00300            DATE  27AUG90                */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*     S01486 - Portfolio Management Upgrade to R10                  */
/*     32914  - ICD maintenance amendments                           */
/*     R00300 - Message file changes.                                */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CREATION REQUIREMENTS                                         */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM*********************************************************32914*/
             PGM        PARM(&ICD &RTC)                                /*32914*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)***/             /*S01486*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&ICD) TYPE(*CHAR) LEN(3)                   /*32914*/
             DCL        VAR(&RTC) TYPE(*CHAR) LEN(3)                   /*32914*/
/**/
/* GLOBAL MONITOR MESSAGE                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ENDTAG))
             CHGJOB     SWS(00000000)
/**/
/* PERFORM FILE OVERRIDES                                            */
             OVRDBF     FILE(SDPLINXX) TOFILE(SDPLINPD) SHARE(*NO)
/*********** OVRDBF     FILE(PMDSPGXX) TOFILE(PMDSPGPP) SHARE(*NO)3291/*S01486*/
/*********** OVRDBF     FILE(PMVLGHXX) TOFILE(PMVLGHPP) SHARE(*NO)3291/*S01486*/
             OVRDBF     FILE(PMDSPGXX) TOFILE(PMDSPGPD) SHARE(*NO)    /*S01486*/
             OVRDBF     FILE(PMVLGHXX) TOFILE(PMVLGHPD) SHARE(*NO)    /*S01486*/
             OVRDBF     FILE(LBGROUXX) TOFILE(LBGROUL1) SHARE(*NO)     /*32914*/
             OVRDBF     FILE(LBGROUL1) SHARE(*NO)                      /*32914*/
 
/**/
/* CALL MAINTENANCE PROGRAM                                          */
/************CALL*******PGM(PM0030)**************************************32914*/
             CALL       PGM(PM0030) PARM(&ICD &RTC)                    /*32914*/
/**/
             DLTOVR     FILE(*ALL)
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM) ***/    /*S01486*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01486*/
/*                                                                    /*R00300*/
/****************SNDPGMMSG  MSGID(PEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
**************************TOMSGQ(MOPERQ MRUNQ)                       */
/****************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)*******/                /*S01486*/
                 SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01486*/
/*                                                                    /*R00300*/
             ENDDO
             GOTO       CMDLBL(END)
/**/
/*  ERROR IN CL PROGRAM  */
 ENDTAG:     DMPCLPGM
/*                                                                   */
/*ENDPGM:***  ENDPGM                                               */ /*S01486*/
 END:                                                                 /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01486*/
