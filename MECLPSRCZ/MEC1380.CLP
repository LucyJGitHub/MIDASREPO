/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Audit Report Prompt Rqt CCY¦TRNO')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Message Management Module                   */
/*                                                                   */
/*       MEC1380  - Prompt Request for Currency/Transaction Ref      */
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
/*       Prev Amend No. S01435             Date 13Oct93              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01435 - Incoming Message Management                        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SEQUENCE &LEVEL &ENTITY &PARAMETERS +
                          &ACTION &CMD)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SEQUENCE) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LEVEL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENTITY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PARAMETERS) TYPE(*CHAR) LEN(100)
             DCL        VAR(&SELECTION) TYPE(*CHAR) LEN(92)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&P1PARM) TYPE(*CHAR) LEN(256)
             DCL        VAR(&P2PARM) TYPE(*CHAR) LEN(128)
             DCL        VAR(&P3PARM) TYPE(*CHAR) LEN(10)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Set switches */
/* */
             CHGJOB     SWS(XXXXX000)
/* */
/* Run ME1240 - Imm Selection  */
/* */
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
             CHGVAR     VAR(&P1PARM) VALUE('B')
/* */
             CALL       PGM(ME1240) PARM(&RTN_CODE &P1PARM &P2PARM +
                          &P3PARM)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/* */
/* Set up *LDA */
/* */
             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(&P1PARM)
             CHGDTAARA  DTAARA(*LDA (257 128)) VALUE(&P2PARM)
/* */
/* Set CMD depending on return code  */
/* */
             IF         COND((&RTN_CODE *EQ 'Y2U9999') *OR +
                             (&RTN_CODE *EQ 'USR0563') *OR +
                             (&RTN_CODE *EQ 'USR0567')) THEN(DO)
             CHGVAR     VAR(&CMD) VALUE('E')
             ENDDO
/* */
             IF         COND(&RTN_CODE *EQ 'USR0790') THEN(DO)
             CHGVAR     VAR(&CMD) VALUE('F')
             ENDDO
/* */
/* Set up parameters for report */
/* */
             CHGVAR     VAR(&PARAMETERS) VALUE('*PRINT  ' *CAT +
                          &SELECTION)
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
             SNDPGMMSG  MSG('Program MEC1380 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MEC1380 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
