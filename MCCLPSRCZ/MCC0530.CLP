/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC Drop Gap Accrual details')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Management Accounts Module                          */
/*                                                                   */
/*       MCC0530 - MC Drop GAP Accrual Details                       */
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
/*       Prev Amend No. CMC001 *CREATE     Date 18Mar96              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CMC001 - Management Accounts Enhancement for PCA:           */
/*                Created for Management Accounts.                   */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
/* Create data LDA in QTEMP  */
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('MIDAS SD AS400 LOCAL DATA AREA +
                          EQUIVALENT')
             MONMSG     MSGID(CPF0000)
/**/
             SNDPGMMSG  MSG('MCC0530 - MC Drop GAP Accrual details') +
                             TOMSGQ(MRUNQ)
/**/
/* Drop GAP Accrual Details prior to first record before  */
/* Back-value Date                                        */
/**/
             CALL       PGM(MC0530)
/**/
/* Database error processing */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
 ABNOR:
/**/
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/* Abnormal termination */
/**/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MCC0530 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
