/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Delete Savf and Temporary Extract Files')    */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC2100  - Delete Save File and Temporary Files             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01522             DATE 21NOV94              */
/*       PREV AMEND NO. Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&COMP_NAME &COMP_SEQ)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&COMP_NAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMP_SEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&STATUS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CGDTA) TYPE(*CHAR) LEN(512)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Send Message to MRUNQ and standard processing parameters */
/* */
             SNDPGMMSG  MSG('CGC2100 - Delete Save File and +
                          Temporary Files') TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXX000)
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/* */
/* Create data LDA in QTEMP  */
/* */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
/* */
/* Format DPLIB name */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
             CHGVAR     VAR(&DPLIB) VALUE(&DBPREFIX *CAT 'DPLIB')
/* */
/* Format DILIB name */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
             CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')
/* */
/* Get run status */
/* */
             CHGVAR     VAR(&STATUS) VALUE(' ')
             CALL       PGM(CB0160) PARM(&COMP_NAME &COMP_SEQ &STATUS)
/* */
/* Update status to Active */
/* */
             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&COMP_NAME &COMP_SEQ &STATUS)
/* */
/* Delete Temporary Extract Files if files not to be kept */
/* */
             RTVDTAARA  DTAARA(CGDTA (1 512)) RTNVAR(&CGDTA)
             IF         COND(%SST(&CGDTA 18 1) *NE 'Y') THEN(DO)
/* */
             DLTF       FILE(&DPLIB/EXCGUDCRPD)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DPLIB/EXCGUDCLPD)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DPLIB/EXCGUDTAPD)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DPLIB/EXCGUDT1PD)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DPLIB/EXCGUDT2PD)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DPLIB/EXCGUDT3PD)
             MONMSG     MSGID(CPF2105)
/* */
             ENDDO
/* */
/* Delete Save File CGSAVF if files not to be kept */
/* */
             IF         COND(%SST(&CGDTA 17 1) *NE 'Y') THEN(DO)
/* */
             DLTF       FILE(&DILIB/CGSAVF)
             MONMSG     MSGID(CPF2105)
/* */
             ENDDO
/* */
/* Update status to Not Active - component finished */
/* */
             CHGVAR     VAR(&STATUS) VALUE('N')
             CALL       PGM(CB0150) PARM(&COMP_NAME &COMP_SEQ &STATUS)
/**/
             GOTO       CMDLBL(ENDCLPGM)
/* */
/* Report Database errors trapped by program */
/* */
 DBERR:
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
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
             SNDPGMMSG  MSG('Program CGC2100 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC2100 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
