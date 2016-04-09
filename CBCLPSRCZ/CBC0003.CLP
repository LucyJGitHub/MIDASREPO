/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas COB Input Cycle termination Delay EOD')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Module                            */
/*                                                                   */
/*       CBC0003 - Delay Input Cycle Termeintation                   */
/*                                                                   */
/*       Function: This program run the first step of ICT in batch   */
/*                 mode if scheduling requested                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CCB014  *Create    Date 25Apr05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCB014 - Prev-Scheduled Batch Close Of Business             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/* INPUT :                                                           */
/*                                                                   */
/* OUTPUT :                                                          */
/*********************************************************************/
             PGM
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CCB014) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&DLYCOB) TYPE(*CHAR) LEN(256)
             DCL        VAR(&AUTSCH) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
 
/* Create the Midas Information Screen data area */
 
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ') TEXT('Midas SC Midas +
                          information screen data')
             MONMSG     MSGID(CPF1023)
 
/* Create local data area */
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local data area')
             MONMSG     MSGID(CPF1023)
 
             RTVJOBA    TYPE(&TYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/* Check to see if Automatic Scheduling is ON                     */
 
             RTVDTAARA  DTAARA(DLYCOB (2 1)) RTNVAR(&AUTSCH)
 
/* Check to see if the delay COB Feature is set ON (CCB014)       */
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('CCB014')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR +
                          &SCSARD)
             IF         COND(&RTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&CCB014) VALUE('Y'))
             ELSE       CMD(GOTO CMDLBL(ENDPGM))
             IF         COND(&CCB014 *EQ 'Y' *AND &AUTSCH *EQ 'Y') +
                          THEN(DO)
             CALL       PGM(CBC0001) PARM('I' 'M')
             DLYJOB     DLY(60)
             CALL       PGM(CBC0001) PARM('I' 'E')
             CALL       PGM(SFC4464) PARM('DLYTERM')
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGDTAARA  DTAARA(DLYCOB (2 1)) VALUE('N')
             CLRMSGQ    MSGQ(MSPECIAL)
             CHGDTAARA  DTAARA(MPHAS (1 1)) VALUE('A')
             CHGDTAARA  DTAARA(SDSTAT (110 5)) VALUE('BEGIN')
             CHGVAR     VAR(&MSG) VALUE('Job SFC4464 in error.')
             SNDMSG     MSG(&MSG) TOMSGQ(MOPERQ MRUNQ)
                        GOTO       CMDLBL(ENDPGM)
             ENDDO
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             CHGDTAARA  DTAARA(DLYCOB (2 1)) VALUE('N')
             CLRMSGQ    MSGQ(MSPECIAL)
             CHGDTAARA  DTAARA(MPHAS (1 1)) VALUE('A')
             CHGDTAARA  DTAARA(SDSTAT (110 5)) VALUE('BEGIN')
             CHGVAR     VAR(&MSG) VALUE('Job SFC4464 in error.')
             SNDMSG     MSG(&MSG) TOMSGQ(MOPERQ MRUNQ)
                        GOTO       CMDLBL(ENDPGM)
             ENDDO
             CALL       PGM(SCRRTTERM)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGDTAARA  DTAARA(DLYCOB (2 1)) VALUE('N')
             CLRMSGQ    MSGQ(MSPECIAL)
             CHGDTAARA  DTAARA(MPHAS (1 1)) VALUE('A')
             CHGDTAARA  DTAARA(SDSTAT (110 5)) VALUE('BEGIN')
             CHGVAR     VAR(&MSG) VALUE('Job SCRRTTERM in error.')
             SNDMSG     MSG(&MSG) TOMSGQ(MOPERQ MRUNQ)
                        GOTO       CMDLBL(ENDPGM)
             ENDDO
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             CHGDTAARA  DTAARA(DLYCOB (2 1)) VALUE('N')
             CLRMSGQ    MSGQ(MSPECIAL)
             CHGDTAARA  DTAARA(MPHAS (1 1)) VALUE('A')
             CHGDTAARA  DTAARA(SDSTAT (110 5)) VALUE('BEGIN')
             CHGVAR     VAR(&MSG) VALUE('Job SCRRTTERM in error.')
             SNDMSG     MSG(&MSG) TOMSGQ(MOPERQ MRUNQ)
                        GOTO       CMDLBL(ENDPGM)
             ENDDO
             GOTO       CMDLBL(ENDPGM)
             ENDDO
 
ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&TYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            CBC0003 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
 ENDPGM:     ENDPGM
