/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG U.D.C. Reorganisation Control')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC2030  - U.D.C. Reorganisation Control                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK009             Date 09Jul99              */
/*       Prev Amend No. 079860             DATE 07DEC94              */
/*                      079856             DATE 07DEC94              */
/*                      S01522             DATE 21NOV94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       079860 - STRCMTCTL should be *CHG                           */
/*       079856 - Call CGC2040 instead of CGC1240                    */
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
/************SNDPGMMSG  MSG('CGC2020 - U.D.C. Reorganisation +         *079856*/
/************             Control') TOMSGQ(MRUNQ)                      *79856*/
             SNDPGMMSG  MSG('CGC2030 - U.D.C. Reorganisation +
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
/************STRCMTCTL  LCKLVL(*ALL)                                    *79860*/
/************STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))       /*79860CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                               /*CPK009*/
             MONMSG     MSGID(CPF8351)                                 /*79860*/
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
/* Check to see files need reorganising */
/* */
/************CALL       PGM(CGC1240)                                   *079856*/
             CALL       PGM(CGC2040)                                  /*079856*/
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
             SNDPGMMSG  MSG('Program CGC2030 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC2030 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
