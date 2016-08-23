/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AGDL Extract details')                          */
/*********************************************************************/
/*                                                                   */
/*       Midas - AGDL reporting Module                               */
/*                                                                   */
/*       ERCAG08 - AGDL Extract details                              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. CC0001             Date 20Jul99              */
/*                      155076             Date 11Feb99              */
/*                      ULX010  *CREATE    Date 21apr98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       CC0001 - Change Control for DL                              */
/*       155076 - New fonctionalities of ULX010                      */
/*       ULX010 - AGDL reporting statistiques sur les dépôts garantis*/
/*                                                                   */
/*********************************************************************/
             PGM
 
/*  Declare variables  */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(75) VALUE('ERAG08 +
                          - AGDL Extract details')
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                 /*CC0001*/
 
/*  Global monitor message  */
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000 MCH0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ABNOR))
             RTVJOBA    USER(&USR)
 
/*  Create Local Data Area  */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/***  Reset external switches  ***/
             CHGJOB     SWS(XXXXXX00)
 
/***  Send message to program message queue  ***/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
 
/***  Clear AGDL details Extracts File                                /*155076*/
                                                                      /*155076*/
             CLRPFM     FILE(AGDLEXPP)                                /*155076*/
                                                                      /*155076*/
/***  Call program  ***/
             CALL       PGM(ERAG08)
 
/***  Monitor for Database Errors (U7 and U8 on)  ***/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
/*******     SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                         *CC0001*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(GBMIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CC0001*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
             SNDPGMMSG  MSG('ERCAG08 - AGDL Extract details +
                          normally terminated.') TOUSR(&USR)          /*CC0001*/
 
             GOTO       CMDLBL(ENDPGM)
 
/***  Program ended abnormally  ***/
 ABNOR:      SNDPGMMSG  MSG('ERCAG08 - AGDL Extract details +
                          abnormally terminated.') TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
             SNDPGMMSG  MSG('ERCAG08 - AGDL Extract details +
                          abnormally terminated.') TOUSR(&USR)        /*CC0001*/
             MONMSG     MSGID(CPF0000)                                /*CC0001*/
             DMPCLPGM
 
/***  End Program  ***/
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
