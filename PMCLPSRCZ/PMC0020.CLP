/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Valuation groups maintainance')              */
/*********************************************************************/
/*                                                                   */
/*     Midas PORTFOLIO MANAGEMENT MODULE                             */
/*                                                                   */
/*     PMC0020 - VALUATION GROUPS MAINTAINANCE                       */
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
/*       Prev Amend No. 090135             Date 06Jul95              */
/*                      S01486             Date 28Jun94              */
/*                    R00300            DATE  27AUG90                */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*     090135 - Multilanguage is always on                           */
/*     S01486 - Portfolio Management Upgrade to R10                  */
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
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&WWMTL) TYPE(*CHAR) LEN(1)
/********    DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)********/  /*S01486*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)           /*S01486*/
/**/
/* GLOBAL MONITOR MESSAGE                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ENDTAG))
/*********** CHGJOB     SWS(00000000)                                * *090135*/
/**/
/**CHECK*WHETHER*MULTI*LANGUAGE*PRESENT******************************* *090135*/
/*********** RTVDTAARA  DTAARA(MMOD (17 1)) RTNVAR(&WWMTL)           * *090135*/
/**/
/*********** IF         COND(&WWMTL *EQ 'Y') THEN(DO)                * *090135*/
             CHGJOB     SWS(XXX1XXXX)
/*********** ENDDO                                                   * *090135*/
/**/
/* PERFORM FILE OVERRIDES                                            */
/*********** OVRDBF     FILE(PMVLGHXX) TOFILE(PMVLGHPP) SHARE(*NO) */ /*S01486*/
/*********** OVRDBF     FILE(PMVLGDXX) TOFILE(PMVLGDPP) SHARE(*NO) */ /*S01486*/
             OVRDBF     FILE(PMVLGHXX) TOFILE(PMVLGHPD) SHARE(*NO)    /*S01486*/
             OVRDBF     FILE(PMVLGDXX) TOFILE(PMVLGDPD) SHARE(*NO)    /*S01486*/
/**/
/* CALL MAINTENANCE PROGRAM                                          */
             CALL       PGM(PM0020)
/**/
             DLTOVR     FILE(*ALL)
CHGJOB SWS(XXX0XXXX)
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
/**********      RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)******/  /*S01486*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01486*/
/*                                                                    /*R00300*/
/****************SNDPGMMSG  MSGID(PEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
**************************TOMSGQ(MOPERQ MRUNQ)                       */
/*************** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)*********************/  /*S01486*/
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
