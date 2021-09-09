/*********************************************************************/
/*STD    CLPBASE                                                     */
/*********************************************************************/
/*                                                                   */
/*       Midas¦ABS - Message Management Module                       */
/*                                                                   */
/*     MEHC036 -  Auto Generation Criteria Table Listing             */
/*                                                                   */
/*       (C) COPYRIGHT Midas/Kapiti International 1996               */
/*                                                                   */
/*       Last Amend No. MD31937            Date 13Jan15              */
/*       Last Amend No. AR856737           Date 13Sep11              */
/*       LAST AMEND NO. S01482             DATE 01MAY96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD31937  - Upgrade STP enhancements to BF Midas 2.1         */
/*       AR856737 - Upgrade STP enhancements to Midas Plus level     */
/*       S01482 - Auto Generation                                    */
/*                                                                   */
/*********************************************************************/
/*                                                                            */
             PGM        PARM(&DATA &SEQ &LEVEL &ENTITY)
/*                                                                            */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          COPYRIGHT Midas/Kapiti International 1996')
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
             SNDPGMMSG  MSG('ME Generation Criteria Table listing') +
                          TOMSGQ(MRUNQ)
             CHGJOB     SWS(00000000)
/*                                                                            */
/** Call the report program */
/*                                                                            */
             CALL       PGM(MEH036) PARM(&SEQ)
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
             SNDPGMMSG  MSG('Program MEHC036 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MEHC036 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('Copyright Midas/Kapiti +
                          International 1996')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
