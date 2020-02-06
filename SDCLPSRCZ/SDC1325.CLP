/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Call Reporting Structures Report')           */
/*********************************************************************/
/*                                                                   */
/*  Midas - Standing Data Module                             */
/*                                                                   */
/*  SDC1325  - Call to Reporting Structures Report Program.          */
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
/*       Prev Amend No. RT0159             Date 25Jun91              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*  RT0159 - Messages should be sent via new Midas Info Screen.      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**/
     PGM     PARM(&SEQ &LVL &ENT &SET)
/**/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&SEQ)  TYPE(*CHAR)  LEN(5)
             DCL        VAR(&LVL)  TYPE(*CHAR)  LEN(1)
             DCL        VAR(&ENT)  TYPE(*CHAR)  LEN(3)
             DCL        VAR(&SET)  TYPE(*CHAR)  LEN(1)
             DCL        VAR(&LDA)  TYPE(*CHAR)  LEN(256)
             DCL        VAR(&MEM)  TYPE(*CHAR)  LEN(50)
             DCL        VAR(&JOB)  TYPE(*CHAR)  LEN(10)
             DCL        VAR(&SWS)  TYPE(*CHAR)  LEN(8)
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
/* Create LDA if it does not already exist */
/**/
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT'))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
             CALL       PGM(SD1325)  PARM(&SEQ &LVL &ENT &SET)
/**/
/*  Send Database Error Messages */
/**/
             RTVJOBA    JOB(&JOB) SWS(&SWS)
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**/
                        RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                        CHGVAR &MEM VALUE(%SUBSTRING(&LDA 134 50))
                        SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) +
                        MSGDTA(&MEM) TOMSGQ(MOPERQ) TOPGMQ(*EXT)
             ENDDO
/**/
             GOTO       CMDLBL(ENDPGM)
/**/
/* Abnormal Termination Processing */
/**/
/****ABNOR:**SNDPGMMSG  MSG('Reporting Structures Report ENDED +      /*RT0159*/
/***********              ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ)    /*RT0159*/
     ABNOR:                                                           /*RT0159*/
             SNDPGMMSG  MSG('Reporting Structures Report ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ)                 /*RT0159*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*RT0159*/
             CALL       PGM(SDC0700) PARM('SDC1325' 'RPSTRPTABN' ' +
                          ')                                          /*RT0159*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
     ENDPGM: ENDPGM
