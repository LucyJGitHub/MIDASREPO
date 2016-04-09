/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL IRS Date Schedule Extract/Reporting')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC4110 - IRS Date Schedule Extract/Reporting               */
/*                                                                   */
/*       Calls: DL4110    - IRS Date Schedule Exception Extract      */
/*              DL4111    - IRS Date Schedule Exception Report       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. CIR001  *CREATE    DATE 13JUN95              */
/*       PREV AMEND NO. Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CIR001 - Interest Rate Calendars.                           */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             SNDPGMMSG  MSG('DLC4110 - IRS Date Schedule Extract and +
                          Report') TOMSGQ(MOPERQ)
 
             CLRPFM     FILE(DLSDEEPD)
             CALL       PGM(DL4110)
/**/
/*   Report any errors and exit program                             */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)
               GOTO       CMDLBL(END)
             ENDDO
 
             CALL       PGM(DL4111)
/**/
/*   Report any errors and exit program                             */
/**/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)
               GOTO       CMDLBL(END)
             ENDDO
/**/
/*   Remove any work members that were left over from Input Cycle.  */
/**/
             RMVM       FILE(DLDTSCL0) MBR(DD*)
             MONMSG     MSGID(CPF7303 CPF7301)
             RMVM       FILE(DLDTSCPD) MBR(DD*)
             MONMSG     MSGID(CPF7303 CPF7301)
             RMVM       FILE(DLCFSCL0) MBR(DC*)
             MONMSG     MSGID(CPF7303 CPF7301)
             RMVM       FILE(DLCFSCPD) MBR(DC*)
             MONMSG     MSGID(CPF7303 CPF7301)
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          DLC4110 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
