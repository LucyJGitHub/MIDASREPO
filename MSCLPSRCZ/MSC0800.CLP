/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Outgoing Messages Awaiting Trans'n Rpt')        */
/********************************************************************/
/*                                                                  */
/*     Midas Midas/S.W.I.F.T. DIRECT LINK                       */
/*                                                                  */
/*     MSC0800 - OUTGOING MESSAGES AWAITING TRANSMISSION REPORT     */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     LAST AMEND NO.  S01117           DATE  22JAN90               */
/*     PREV AMEND NO.  00               DATE  00/00/00              */
/*                                                                  */
/********************************************************************/
             PGM
/*                                                                   */
/* Declare Message Detail Field.                                    */
/*                                                                  */
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)   */   /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)        /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                   */
/* Global monitor message                                            */
/*                                                                   */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/*                                                                   */
/* Audit message to MRUNQ                                            */
/*                                                                   */
             SNDPGMMSG  MSG('Outgoing SWIFT Messages Awaiting +
                          Transmission Report') TOMSGQ(MRUNQ)
/*                                                                   */
/* Call Close of Business Report Program.                           */
/*                                                                  */
             CALL       PGM(MS0800)
/*                                                                  */
/* For Database Errors Recover Data From Local Data Area, Send      */
/* Message to MOPERQ.                                              */
/*                                                                  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/****************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM) */      /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/*                                                                   */
             GOTO       CMDLBL(END)
/*                                                                   */
 ABNOR:      SNDPGMMSG  MSG('Outgoing S.W.I.F.T Messages Awaiting +
                          Transmission Report ENDED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     INQMSGRPY(*RQD) SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*                                                                   */
 END:        RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
