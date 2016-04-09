/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME Fontis nostro default listing')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management Module                           */
/*                                                                   */
/*       MEC2007 -  Fontis Nostro Default Listing                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*       Last Amend No. CGL009  *CREATE    Date 07Sep99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CGL009 - FONTIS IAT/TPP Interface                           */
/*                                                                   */
/*********************************************************************/
/*                                                                            */
             PGM        PARM(&DATA &SEQ &LEVEL &ENTITY)
/*                                                                            */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(8)
             DCL        VAR(&LEVEL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENTITY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(100)
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(5)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/**/
             SNDPGMMSG  MSG('ME Fontis Nostro Default listing') +
                          TOMSGQ(MRUNQ)
             CHGJOB     SWS(00000000)
/*                                                                            */
/** Call the report program */
/*                                                                            */
             CALL       PGM(ME2007) PARM(&SEQ)
/*                                                                            */
/** Database error occurred */
/*                                                                            */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/*                                                                            */
             GOTO       CMDLBL(ENDPGM)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program MEC2007 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MEC2007 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
