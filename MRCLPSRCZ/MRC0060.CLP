/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MR Copy GL Data to 1st Member')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - MidasPlus Reporting Module                          */
/*                                                                   */
/*       MRC0060 - Copy GL Data to 1st Member                        */
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
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('MRC0060 - Copy GL Data to 1st Member') +
                          TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(00000000)
 
             CLRPFM     FILE(MRAVBAPD)
             CLRPFM     FILE(MRAVBLPD)
             CLRPFM     FILE(MRHIBLPD)
 
             CPYF       FROMFILE(MRAVBAPD) TOFILE(MRAVBAPD) +
                          FROMMBR(CAL) MBROPT(*ADD)
             CPYF       FROMFILE(MRAVBAPD) TOFILE(MRAVBAPD) +
                          FROMMBR(FIN) MBROPT(*ADD)
 
             CPYF       FROMFILE(MRAVBLPD) TOFILE(MRAVBLPD) +
                          FROMMBR(CAL) MBROPT(*ADD)
             CPYF       FROMFILE(MRAVBLPD) TOFILE(MRAVBLPD) +
                          FROMMBR(FIN) MBROPT(*ADD)
 
             CPYF       FROMFILE(MRHIBLPD) TOFILE(MRHIBLPD) +
                          FROMMBR(CAL) MBROPT(*ADD)
             CPYF       FROMFILE(MRHIBLPD) TOFILE(MRHIBLPD) +
                          FROMMBR(FIN) MBROPT(*ADD)
 
             GOTO       CMDLBL(ENDP)
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MRC0060 ended abnormally - see job log') +
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
