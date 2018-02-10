/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PL End Midas-Plato real-time interface job')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Midas-Plato Interface                               */
/*                                                                   */
/*       PLC0400 - End Midas-Plato Real-time Interface Job           */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014  *CREATE    Date 09Jan02              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK014 - Remove shutdown jobs from SCC0400 and replace with */
/*                individual CoB components.                         */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,PLC0400INT                                          */
 
             DCL        VAR(&MQMSGQ) TYPE(*CHAR) LEN(48)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,PLC0400MPS                                          */
 
             RTVDTAARA  DTAARA(RPTRGMPI (1 48)) RTNVAR(&MQMSGQ)
             SNDMSGMQQ  QUEUE(&MQMSGQ) MSG('SHUTDOWN')
 
/*/COPY WNCPYSRC,PLC0400MPE                                          */
 
             GOTO       CMDLBL(END)
 
ABNOR:
/*/COPY WNCPYSRC,PLC0400ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          PLC0400 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,PLC0400END                                          */
 
             ENDPGM
