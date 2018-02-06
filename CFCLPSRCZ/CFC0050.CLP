/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CF Dealing confs. status report req.')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - CONFIRMATION MATCHING                       */
/*                                                                   */
/*       CFC0050 - DEALING CONFIRMATIONS STATUS REPORT CONTROL       */
/*                 (CALLED FROM MITEMDD, CALLS CF0050)               */
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
/*       Prev Amend No. S01310             Date 06Dec90              */
/*                      S01184             Date 15Dec89              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01310 - SWIFT RATIONALISATION                              */
/*       S01184 - CREATED FOR CONFIRMATION MATCHING                  */
/*                                                                   */
/*********************************************************************/
/****PGM*******************                                           /*S01310*/
             PGM PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)           /*S01310*/
 
             DCL        VAR(&ERRDTA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01310*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01310*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01310*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01310*/
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)                 /*S01310*/
             DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)                 /*S01310*/
             DCL        VAR(&PARAM) TYPE(*CHAR) LEN(23)               /*S01310*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             MONMSG MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
             CHGJOB     SWS(00000000)
 
/*  Call main DEALING CONFIRMATIONS STATUS REPORT program            */
 
/************CALL*******PGM(CF0050)                                   /*S01310*/
    CALL PGM(CF0050) PARM(&RSEQ &RLEV &RENT &PARAM &RACT &RCMD)       /*S01310*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&ERRDTA)
                SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&ERRDTA) +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                SNDPGMMSG  MSG('Job Terminated - Database in Error') +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                GOTO (ABNOR)
             ENDDO
 
             CHGVAR VAR(&RPARM) VALUE(&PARAM)                         /*S01310*/
 
             GOTO (END)
 
 ABNOR:      SNDPGMMSG  MSG('CFC0050 ENDED ABNORMALLY') TOPGMQ(*EXT) +
                        TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 END:        ENDPGM
