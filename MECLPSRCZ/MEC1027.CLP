/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Display message information')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Message Management Module                   */
/*                                                                   */
/*       MEC1027  - Display Message Information                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01435             DATE 19AUG93              */
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
             PGM        PARM(&RTN_CODE &MSGID &MSGF &MSGDTA &OPTION +
                          &REPLY &PROGRAM &SECLVL)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(132)
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TXT1) TYPE(*CHAR) LEN(132)
             DCL        VAR(&TXT2) TYPE(*CHAR) LEN(512)
             DCL        VAR(&PROGRAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SECLVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Set switches off */
/* */
             CHGJOB     SWS(XXXXX000)
/* */
/* Run MEC1150 - to obtain message detail  */
/* */
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
             CALL       PGM(MEC1150) PARM(&MSGID &MSGF &MSGDTA &TXT1 +
                          &TXT2)
/* */
/* Update MIDASMSG data area and call prompt screen program */
/* */
             IF         COND(&SECLVL *EQ 'Y') THEN(DO)
             CHGDTAARA  DTAARA(MIDASMSG (101 500)) VALUE(%SST(&TXT2 +
                          1 500))
             ENDDO
             ELSE       CMD(DO)
             CHGDTAARA  DTAARA(MIDASMSG (101 500)) VALUE(%SST(&TXT1 +
                          1 132))
             ENDDO
/* */
             CALL       PGM(SCC0010) PARM(&PROGRAM &OPTION &REPLY)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
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
             SNDPGMMSG  MSG('Program MEC1027 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MEC1027 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
