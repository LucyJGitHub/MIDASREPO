/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Check outgoing messages awaiting Tx')           */
/*********************************************************************/
/*                                                                   */
/*   Midas    MESSAGE MANAGEMENT                             */
/*                                                                   */
/*   MEC0400 -  Outgoing messages awaiting transmission              */
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
/*   PREV AMEND NO.  00000            DATE 00XXX00                   */
/*                   00000            DATE 00XXX00                   */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL VAR(&MEM)    TYPE(*CHAR) LEN(50)
             DCL VAR(&RUNDAT) TYPE(*CHAR) LEN(6)
             DCL VAR(&DATFMT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
/* Audit message to MRUNQ */
             SNDPGMMSG  MSG('Check Outgoing Messages awaiting +
                          Transmission') TOMSGQ(MRUNQ)
 
/* Convert rundat DDMMMYY to yymmdd */
             CALL PGM(ZM0080) PARM(&RUNDAT &DATFMT)
 
/* For Database Errors Recover Data From Local Data Area, Send */
/* Message to MOPERQ. */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(END)
             ENDDO
 
/* Check outgoing messages awaiting transmission */
             CALL PGM(ME0400) PARM(&RUNDAT)
 
/* For Database Errors Recover Data From Local Data Area, Send */
/* Message to MOPERQ. */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:      SNDPGMMSG  MSG('Check Outgoing Messages awaiting +
                          Transmission ENDED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     INQMSGRPY(*RQD) SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 END:        ENDPGM
