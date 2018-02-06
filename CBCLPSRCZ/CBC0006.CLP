/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas COB Automatic Scheduling of next COB')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       CBC0006 - COB Automatic Scheduling of next COB              */
/*                                                                   */
/*       Function: This program submits next COB if required +       */
/*                 updates the control dtaara DLYCOB                 */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CCB014 *Create     Date 25Apr05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB014 - Pre-Scheduled Batch Close Of Business              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
             PGM
/* */
/* Declare variables */
/* */
             DCL        VAR(&AUTSCH) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RUND) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&CCB014) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(06)
             DCL        VAR(&DLYCOB) TYPE(*CHAR) LEN(256)
/* */
/* Declare file SDBANKPD  */
/* */
             DCLF       FILE(SDBANKPD)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* Check to see if the delay COB Feature is set ON (CCB014)       */
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('CCB014')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR +
                          &SCSARD)
             IF         COND(&RTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&CCB014) VALUE('Y'))
             IF         COND(&CCB014 *NE 'Y') THEN(GOTO ENDPGM)
/* */
/* Inititalise DLYCOB data area for next I/C */
/* */
             OVRDBF     FILE(SDBANKPD) SHARE(*NO)
             RCVF
 
             RTVDTAARA  DTAARA(DLYCOB) RTNVAR(&DLYCOB)
 
/* Endjob of Previous COB JOB if exists                              */
             CHGVAR     VAR(&JOB) VALUE(%SST(&DLYCOB 16 10))
             CHGVAR     VAR(&USER) VALUE(%SST(&DLYCOB 26 10))
             CHGVAR     VAR(&NBR) VALUE(%SST(&DLYCOB 36 06))
             CHGMSGQ    MSGQ(*USRPRF) DLVRY(*HOLD)
             MONMSG     MSGID(CPF0000)
             CHGMSGQ    MSGQ(*WRKSTN) DLVRY(*HOLD)
             MONMSG     MSGID(CPF0000)
             ENDJOB     JOB(&NBR/&USER/&JOB)
             MONMSG     MSGID(CPF0000)
 
             RTVDTAARA  DTAARA(DLYCOB (1 1)) RTNVAR(&AUTSCH)
/* */
             CHGDTAARA  DTAARA(DLYCOB (2 1)) VALUE('N')
             CHGVAR     VAR(&RUND) VALUE(&BJRDNB)
             CHGDTAARA  DTAARA(DLYCOB (3 5)) VALUE(&RUND)
             CHGDTAARA  DTAARA(DLYCOB (16 26)) VALUE(' ')
             CHGDTAARA  DTAARA(DLYCOB (42 26)) VALUE(' ')
/* */
/* Schedule next COB if required */
/* */
             IF         COND(&AUTSCH *EQ 'Y') THEN(DO)
             CALL       PGM(CBC0005) PARM('S')
             ENDDO
             GOTO       CMDLBL(ENDPGM)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CBC0006 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 ENDPGM:     ENDPGM
