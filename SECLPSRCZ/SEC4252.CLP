/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Request of Statement - Calling function')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading                                  */
/*                                                                   */
/*       SEC4252 - Midas SE Request of Statement - Calling function  */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSE040  *CREATE    Date 21Feb03              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE040 - Securities Statement Processing                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(10) VALUE('*MAINT')
             DCL        VAR(&CALLER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CUSTNB) TYPE(*CHAR) LEN(06)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/*  Check if DTAARA/SESDS exists. If not, create it.                 */
 
             CHKOBJ     OBJ(SESDS) OBJTYPE(*DTAARA)
 
             MONMSG     MSGID(CPF9800) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/SESDS) TYPE(*CHAR) LEN(37)
             CHGDTAARA  DTAARA(SESDS (1 8)) VALUE('SEC4250 ')
             CHGDTAARA  DTAARA(SESDS (13 6)) VALUE('000000')
             ENDDO
 
/*  Retrieve the calling program                                     */
 
             RTVDTAARA  DTAARA(SESDS (1 8)) RTNVAR(&CALLER)
             IF         COND(&CALLER *EQ '        ') THEN(CHGVAR +
                          VAR(&CALLER) VALUE('SEC4250'))
 
/*  Retrieve the custodian number                                    */
 
             RTVDTAARA  DTAARA(SESDS (13 6)) RTNVAR(&CUSTNB)
             IF         COND(&CUSTNB *EQ '000000') THEN(CHGVAR +
                          VAR(&CUSTNB) VALUE('      '))
 
             CALL       PGM(SEC4250) PARM(&RTNCDE &OPTION &CALLER +
                          &CUSTNB)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             IF         COND(&RTNCDE *EQ '*EXIT') THEN(CHGDTAARA +
                          DTAARA(SESDS (9 1)) VALUE('1'))
 
             IF         COND(&RTNCDE *EQ '*ERROR') THEN(CHGDTAARA +
                          DTAARA(SESDS (9 1)) VALUE('0'))
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SEC4252 ended abnormally - see job log') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
