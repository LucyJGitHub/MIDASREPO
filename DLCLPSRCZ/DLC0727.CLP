/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Fixed Deposits Register')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC0727 - Fixed Deposit Register                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG3871            Date 30Jul04              */
/*       Prev Amend No. CDL024 *CREATE     Date 31Mar04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG3871 - Fixed Deposit Register always reports an error.   */
/*       CDL024 - Fixed Deposit Register                             */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&RSEQ &RLEV &RENT &RPARM)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL       VAR(&LDA)   TYPE(*CHAR)  LEN(256) VALUE(' ')
/**/
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
/**/
/*  Global monitor message  */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/* SEND PGM MESSAGE */
/**/
             SNDPGMMSG  MSG('FIXED DEPOSIT REGISTER ') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/**/
/*  Submit batch job for printing the report */
/**/
             CALL       PGM(DL0727) PARM(&RSEQ &RLEV &RENT &RPARM)
/**/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)                          /*BUG3871*/
/**********     ROLLBACK                                                                 /*BUG3871*/
/**********     GOTO       CMDLBL(ENDPGM)                                                /*BUG3871*/
/**********  ENDDO                                                                       /*BUG3871*/
                                                                                         /*BUG3871*/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)                                 /*BUG3871*/
                GOTO       CMDLBL(ENDPGM)                                                /*BUG3871*/
             ENDDO                                                                       /*BUG3871*/
                                                                                         /*BUG3871*/
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
/**/
ERROR:       IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR    VAR(&MSGDTA) VALUE(%SUBSTRING(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MSGDTA) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          DLC0727 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
/**/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
