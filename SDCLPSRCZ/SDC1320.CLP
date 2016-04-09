/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Call Reporting Structures Enquiry')          */
/*********************************************************************/
/*                                                                   */
/*  Midas - Standing Data Module                             */
/*                                                                   */
/*  SDC1320  - Call to Reporting Structures Enquiry Program.         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*  LAST AMEND NO. RT0159            DATE 25JUN91                    */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*  RT0159 - Messages should be sent via new Midas Info Screen.      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**/
     PGM
/**/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
             CALL       PGM(SD1320)
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
/****ABNOR:**SNDPGMMSG  MSG('Reporting Structures Enquiry ENDED +     /*RT0159*/
/***********              ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ)    /*RT0159*/
     ABNOR:                                                           /*RT0159*/
             SNDPGMMSG  MSG('Reporting Structures Enquiry ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ)                 /*RT0159*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*RT0159*/
             CALL       PGM(SDC0700) PARM('SDC1320' 'RPSTENQABN' ' +
                          ')                                          /*RT0159*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
     ENDPGM: ENDPGM
