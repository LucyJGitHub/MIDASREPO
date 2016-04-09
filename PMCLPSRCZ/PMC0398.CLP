/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM RE Daily transactions daily extract')        */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC0398 - RE DAILY TRANSACTION EXTRACT                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. CPM004             DATE 08FEB96              */
/*       PREV AMEND NO. S01486             DATE 04OCT94              */
/*                      049421             DATE 18JAN93              */
/*                      049467             DATE 18JAN93              */
/*                      R10041             DATE 16SEP90              */
/*                      R00300             DATE 28AUG90              */
/*                      PMC160             DATE 20MAY90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPM004  -  Bank Portfolios                                  */
/*       S01486  -  Portfolio Management Upgrade to R10              */
/*       049421  -  HEADER BOX STANDARDISATION                       */
/*       049467  -  RECOMPILED FOR RELEASE 3 PTF 02                  */
/*       R10041  -  FILE MANPOJF NO LONGER USED                      */
/*       R00300  -  Message file changes.                            */
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
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)                /*S01486*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01486*/
             DCL        VAR(&LDAWK) TYPE(*CHAR) LEN(256)
             DCLF       FILE(SDPORTPD)
             RCVF       RCDFMT(SDPORTD0)
             MONMSG     MSGID(CPF0000)
/* SET OFF SWITCHES                                              */
 
             CHGJOB     SWS(00000000)
 
/*           CALL       PGM(PM0398)                                     PMC160*/
/************CALL       PGM(PM0398) PARM(&P9DP97)         /*PMC160*/  /*S01486*/
/************CALL       PGM(PM0398) PARM(&FCDP97)          /*S01486*/ /*CPM004*/
             CALL       PGM(PM0398)                                   /*CPM004*/
/*           CLOF       OPNID(MANPOJF)                         R10041*/
/*           MONMSG     MSGID(CPF0000)                         R10041*/
/*           DLTOVR     FILE(MANPOJF)                          R10041*/
/*           MONMSG     MSGID(CPF0000)                         R10041*/
 
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDAWK)
/***************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 132 52)) /*S01486*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 134 50)) /*S01486*/
/*                                                                    /*R00300*/
/************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&MEM) +
**************************TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)          */
/************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +  /*S01486*/
/**************           TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*S01486*/
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*S01486*/
/*                                                                    /*R00300*/
             CHGVAR     VAR(&MEM) VALUE('PMC0398  - JOB TERMINATED, +
                          DATABASE IN ERROR')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
 
/*ENDPGM:***  ENDPGM                                               */ /*S01486*/
 ENDPGM:                                                              /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01486*/
