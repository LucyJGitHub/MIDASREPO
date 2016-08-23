/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Control Print Messages')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Message Management Module                   */
/*                                                                   */
/*       MEC1350  - Control Print of IMM Messages NWRK¦SNDR          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01435             DATE 13OCT93              */
/*       PREV AMEND NO. Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01435 - Incoming Message Management                        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PGM &SEQ &LEVEL &ENTITY &DATA)
/* */
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
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&P1PARM) TYPE(*CHAR) LEN(256)
             DCL        VAR(&P2PARM) TYPE(*CHAR) LEN(128)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('MEC1350 - Print Messages General +
                          Selection') TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXX000)
/* */
/* Run ME1250 - Imm Print Message Control  */
/* */
/* */
/* Create SPF environment for I/C Report */
/* */
             CALL       PGM(MEC1320)
/* */
/* Set up *LDA */
/* */
             RTVDTAARA  DTAARA(*LDA (1 256)) RTNVAR(&P1PARM)
             RTVDTAARA  DTAARA(*LDA (257 128)) RTNVAR(&P2PARM)
/* */
/* Call report control */
/* */
             CALL       PGM(ME1250) PARM(&RTN_CODE &SEQ &LEVEL +
                          &ENTITY ' ' ' ' &DATA &P1PARM &P2PARM)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(&RTN_CODE *NE '       ') THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**/
             GOTO       CMDLBL(ENDCLPGM)
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
             SNDPGMMSG  MSG('Program MEC1350 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MEC1350 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
