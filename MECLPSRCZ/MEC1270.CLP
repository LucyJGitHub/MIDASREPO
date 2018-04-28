/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas I.M.M. Reorganisation Control')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Message Management Module                   */
/*                                                                   */
/*       MEC1270  - I.M.M. Reorganisation Control                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK009             Date 09Aug99              */
/*       Prev Amend No. S01435             DATE 19AUG93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       S01435 - Incoming Message Management                        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
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
             DCL        VAR(&NBR_RCD) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBR_DLT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBR_TOT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&DLT_PCT) TYPE(*DEC) LEN(4 2)
             DCL        VAR(&DAYS) TYPE(*DEC) LEN(5 0)
/* */
/* Declare file SDBANKPD  */
/* */
             DCLF       FILE(SDBANKPD)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Send Message to MRUNQ and standard processing parameters */
/* */
             SNDPGMMSG  MSG('MEC1270 - I.M.M. Reorganisation +
                          Control') TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXX000)
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/* */
/* Get Bank Information and see if non-working days exist */
/* */
             OVRDBF     FILE(SDBANKPD) SHARE(*NO)
             RCVF
             CHGVAR     VAR(&DAYS) VALUE(&BJDNWD - &BJRDNB)
             IF         COND(&DAYS *LE 1) THEN(DO)
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/* */
/* Start Commitment Control */
/* */
/**********  STRCMTCTL  LCKLVL(*ALL)                                  /*CPK009*/
             STRCMTCTL  LCKLVL(*ALL) CMTSCOPE(*JOB)                   /*CPK009*/
/* */
/* Create data LDA in QTEMP  */
/* */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
/* */
/* Get run status */
/* */
             CHGVAR     VAR(&STATUS) VALUE(' ')
             CALL       PGM(CB0160) PARM(&COMP_NAME &COMP_SEQ &STATUS)
/* */
/* If status is active delay job 2 minutes for recovery on ECS     */
/* */
             IF         COND(&STATUS *NE 'N') THEN(DO)
             DLYJOB     DLY(120)
             ENDDO
/* */
/* Update status to Active */
/* */
             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&COMP_NAME &COMP_SEQ &STATUS)
/* */
/* Check to see Control needs reorganising */
/* */
             CALL       PGM(MEC1290) PARM('MEINCRPD  ' '*FIRST    ')
/* */
/* Check to see Parts needs reorganising */
/* */
             CALL       PGM(MEC1290) PARM('MEINMPPD  ' '*FIRST    ')
/* */
/* Check to see Detail needs reorganising */
/* */
             CALL       PGM(MEC1290) PARM('MEINDTPD  ' '*FIRST    ')
             CALL       PGM(MEC1290) PARM('MEIN35PD  ' '*FIRST    ')
/* */
/* Check to see Log File needs reorganising */
/* */
             CALL       PGM(MEC1290) PARM('MEINLFPD  ' '*FIRST    ')
/* */
/* Check to see FT File needs reorganising */
/* */
             CALL       PGM(MEC1290) PARM('MEINFTPD  ' '*FIRST    ')
/* */
/* Check to see Purge File needs reorganising */
/* */
             CALL       PGM(MEC1290) PARM('MEINRMPD  ' '*FIRST    ')
/* */
/* Check to see Reservation File needs reorganising */
/* */
             CALL       PGM(MEC1290) PARM('MEINMRPD  ' '*FIRST    ')
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
             SNDPGMMSG  MSG('Program MEC1260 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MEC1260 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
