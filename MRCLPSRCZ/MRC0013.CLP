/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MR Copy Current Postings')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - MidasPlus Reporting Module                          */
/*                                                                   */
/*       MRC0013 - Copy Current Postings                             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CMR001             Date 01Sep04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CMR001 - MidasPlus Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CALY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CALM) TYPE(*CHAR) LEN(2)
             DCLF       FILE(MRPCMXPD)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('MRC0013 - Copy Current Postings') +
                          TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(00000000)
 
             OVRDBF     FILE(MRPCMXPD) MBR(CURR) SHARE(*NO)
             CLRPFM     FILE(MRPOSTXPD) MBR(CURR)
 
LOOP:        RCVF
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDP))
 
             CHGVAR     VAR(&CALY) VALUE(&CY)
             CHGVAR     VAR(&CALM) VALUE(&CM)
 
             IF         COND(&CURRMN = 'Y') THEN(DO)
             CPYF       FROMFILE(MRPOSTPD) TOFILE(MRPOSTXPD) +
                          FROMMBR(*ALL) TOMBR(CURR) MBROPT(*ADD) +
                          INCREL((*IF CY *EQ &CALY) (*AND CM *EQ +
                          &CALM))
             ENDDO
 
             GOTO       CMDLBL(LOOP)
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MRC0013 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 
ENDP:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
