/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Accruals Using Net-Treasury-Rate Extract')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Money Market Dealing Module                         */
/*                                                                   */
/*       DLC5110 - Midas DL Accruals Using Net-Treasury-Rate Extract */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAS005  *CREATE    Date 16Dec02              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAS005 - Enhancements to CAS001, CAS002 and CAS004          */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('DLC5110 - Midas DL Accruals Using +
                          Net-Treasury-Rate Extract') TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(XXXXXX00)
 
/* Create data area LDA */
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
 
             RTVJOBA    TYPE(&JOBTYPE)
 
             CLRPFM     FILE(ACCEXNN)
             CLRPFM     FILE(ACCEXNO)
             CLRPFM     FILE(ACCEXNP)
             SNDMSG     MSG('DEALS FILE USING N-T-R EXTRACT')  TOMSGQ(MRUNQ)
 
/* Block Large Files */
 
             OVRDBF     FILE(ACCEXNO) SEQONLY(*YES 100)
             CALL       PGM(DL5110)
             DLTOVR     FILE(ACCEXNO)
 
/* File controls out of balance */
 
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSG('File Controls Out of Balance') +
                             TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination - batch job */
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             IF         COND(&JOBTYPE = '0') THEN(DO)
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                             DLC5110 ended abnormally - see job log') +
                             TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:
             DLTOVR      FILE(*ALL)
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
