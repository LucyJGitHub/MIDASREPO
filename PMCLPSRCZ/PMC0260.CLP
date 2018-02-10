/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Country Policy Groups List')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC0260  - CL COMPONENT TO CONTROL PM0260                   */
/*                  COUNTRY POLICY GROUPS LIST I/C & ON REQUEST      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. S01486             DATE 29AUG94              */
/*                      R00300             DATE 28AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01486  -  Portfolio Management Upgrade to R10              */
/*       R00300  -  Message file changes.                            */
/*                                                                   */
/*********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                      /*S01486*/
             PGM        PARM(&MODE &RSEQ &RLVL &RENT)                 /*S01486*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)                /*S01486*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01486*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01486*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01486*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01486*/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
/************DCL        VAR(&MPHAS) TYPE(*CHAR)   LEN(1)              /*S01486*/
/************CHGVAR     VAR(&MODE) VALUE('2')                         /*S01486*/
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
/** retreive data area MPHAS **/
/**/
/************RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                  /*S01486*/
/**/
/**/
/** call program **/
/**/
/*******CALL       PGM(PM0260) PARM(&MODE)             ****/          /*S01486*/
        CALL       PGM(PM0260) PARM(&MODE &RSEQ)                      /*S01486*/
/**/
/** check for database errors trapped by program if called in I/C**/
/**/
/************IF         COND(&MPHAS = 'A') THEN(DO)                   /*S01486*/
        IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
/************RTVDTAARA   DTAARA(LDA (132 52))   RTNVAR(&MEM)          /*S01486*/
             RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&MEM)          /*S01486*/
/*                                                                    /*R00300*/
/****************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&MEM) +
*******************TOMSGQ(MRUNQ MOPERQ)                              */
/***********     SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)/*S01486*/
/***********       TOMSGQ(MRUNQ MOPERQ)                            */ /*S01486*/
                 SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                   TOMSGQ(MRUNQ MOPERQ)                               /*S01486*/
/*                                                                    /*R00300*/
        ENDDO
 
/**/
/** check for FOOB errors trapped by program **/
/**/
        IF   COND(%SWITCH(XXXXXX01))   THEN(DO)
/************RTVDTAARA   DTAARA(LDA (132 52))   RTNVAR(&MEM)          /*S01486*/
             RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&MEM)          /*S01486*/
/*                                                                    /*R00300*/
/*****************NDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) MSGDTA(&MEM) +
************************TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)            */
/***********     SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&MEM)/*S01486*/
/***********            TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)          */ /*S01486*/
                 SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)             /*S01486*/
/*                                                                    /*R00300*/
        ENDDO
/*******ENDDO                                                         /*S01486*/
 
/*ENDPGM:***  ENDPGM                                               */ /*S01486*/
 ENDPGM:                                                              /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01486*/
