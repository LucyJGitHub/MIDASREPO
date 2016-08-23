/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME Msg Content & Translation Tbl')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management Module                           */
/*                                                                   */
/*       MEC1550 -  Message Content Translation Report               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CFT002  *CREATE    Date 07May98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CFT002 - Straight Through Processing Phase 1                */
/*                Based on MEC1550 original references S01489/HUB001 */
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
             SNDPGMMSG  MSG('Message Content and Translation +
                          Report') TOMSGQ(MRUNQ)
             CHGJOB     SWS(00000000)
/*                                                                            */
/** Call the report program */
/*                                                                            */
             CALL       PGM(ME1550) PARM(&SEQ &DATA)
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
             SNDPGMMSG  MSG('Program MEC1550 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MEC1550 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
