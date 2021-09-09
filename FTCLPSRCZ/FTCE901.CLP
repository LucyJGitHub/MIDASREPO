/*********************************************************************/
/*STD    CLPBASE                                                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Funds Transfer Module                               */
/*                                                                   */
/*       FTCE901 - Reset Failed STP Messages                         */
/*                                                                   */
/*       (C) COPYRIGHT Misys ibs Ltd 2001                            */
/*                                                                   */
/*       Last Amend No. MD31937            Date 13Jan15              */
/*       Last Amend No. AR856737           Date 13Sep11              */
/*       Last Amend No. PL0001 *Create     Date 11Oct2001            */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD31937  - Upgrade STP enhancements to BF Midas 2.1         */
/*       AR856737 - Upgrade STP enhancements to Midas Plus level     */
/*       PL0001 - Incoming Messages from PC File                     */
/*                                                                   */
/*********************************************************************/
             PGM
/* */
             DCL        VAR(&MISYS) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          COPYRIGHT Misys ibs Ltd 2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10) +
                          VALUE('XXUSRMSG')
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
             CHGJOB     SWS(XXXXX000)
/* */
/* Start commitment control */
/* */
             STRCMTCTL  LCKLVL(*CHG)
             MONMSG     MSGID(CPF8351)
/* */
/* Run FTP901 - Reset messages */
/* */
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/* */
             CALL       PGM(FTP901) PARM(&RTN_CODE)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGVAR     VAR(&MSGID) VALUE('PLN0014')
             CHGVAR     VAR(&MSGDTA) VALUE('FTE901')
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**/
/* Prompt aut generation job                             */
/**/
             CALL       PGM(MEC1304) PARM(' ' ' ' ' ')
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             IF         COND(&MSGID *NE ' ') THEN(DO)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGF) MSGDTA(&MSGDTA) +
                          TOPGMQ(*PRV)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
/**/
             SNDPGMMSG  MSG('Program FTCE901 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          FTCE901 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
/* */
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&MISYS) VALUE('COPYRIGHT Misys ibs Ltd. +
                          2001.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
