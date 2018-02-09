/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Rollover Rate Fixing in COB Control')        */
/*********************************************************************/
/*                                                                   */
/*       Midas    - Customer Lending Module                          */
/*                                                                   */
/*       LEC2460 - Rollover Rate Fixing in COB Control               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 239076             Date 12May06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CLE011  *CREATE    Date 07Nov00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       239076 - Fix initial rate on forward valued loans.          */
/*       CLE011 - Rate Fixing Days for Lending Rollover Processing   */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('Lending Rollover Rate Fixing') +
                          TOMSGQ(MRUNQ)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ')
             MONMSG     MSGID(CPF1023)
             CHGJOB     SWS(XXXXXX00)
 
             CALL       PGM(LE2460)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGDTA('Rollover Rate Fixing failure') +
                          TOMSGQ(MRUNQ MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
                GOTO       CMDLBL(END)
             ENDDO
                                                                       /*239076*/
             CALL       PGM(LE2461)                                    /*239076*/
                                                                       /*239076*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)               /*239076*/
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGDTA('Start Rate Fixing failure') +
                          TOMSGQ(MRUNQ MOPERQ)                         /*239076*/
                MONMSG     MSGID(CPF0000 MCH0000)                      /*239076*/
                GOTO       CMDLBL(END)                                 /*239076*/
             ENDDO                                                     /*239076*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('LEC2460 +
                          - Rollover Rate Fixing failed +
                          abnormally') TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
