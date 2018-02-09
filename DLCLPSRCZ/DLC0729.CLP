/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL COB Fixed Deposits Register')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC0729 - Fixed Deposit Register                            */
/*                                                                   */
/*       (c) Finastra International Limited 2004                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CDL024 *CREATE     DATE 31Mar04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CDL024 - Fixed Deposit Register                             */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&RSEQ &RLEV &RENT)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LDA)   TYPE(*CHAR)  LEN(256) VALUE(' ')
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(50)
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
/* CREATE LDA IF IT DOES NOT ALREADY EXIST */
/**/
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('MIDAS SD AS400 LOCAL +
                          DATA AREA EQUIVALENT'))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(C) +
                          FINASTRA INTERNATIONAL LIMITED')
/**/
/* SET-OFF DATABASE ERROR SWITCHES */
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
/* CALL REPORT PROGRAM */
/**/
             CALL       PGM(DL0727) PARM(&RSEQ &RLEV &RENT &RPARM)
 
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
/**/
             GOTO       CMDLBL(END)
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
/**/
DBERR:          RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR    VAR(&MSGDTA) VALUE(%SUBSTRING(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MSGDTA) +
                          TOMSGQ(MOPERQ MRUNQ)
/**/
ABNOR:
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          DLC0729 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
/**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
