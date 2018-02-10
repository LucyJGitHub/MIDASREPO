/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MR Copy Historic Postings')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - MidasPlus Reporting Module                          */
/*                                                                   */
/*       MRC0012 - Copy Historic Postings                            */
/*                                                                   */
/*       (c) Finastra International Limited 2004                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CMR001             Date 01Sep04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CMR001 - MidasPlus Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CALY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CALM) TYPE(*CHAR) LEN(2)
             DCLF       FILE(MRPCMXPD)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2004')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('MRC0012 - Copy Historic Postings') +
                          TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(00000000)
 
             OVRDBF     FILE(MRPCMXPD) MBR(CURR) SHARE(*NO)
             OVRDBF     FILE(MRPCMXL1H) TOFILE(MRPCMXL1) MBR(HIST) SHARE(*NO)
 
LOOP:        RCVF
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDP))
 
             CHGVAR     VAR(&CALY) VALUE(&CY)
             CHGVAR     VAR(&CALM) VALUE(&CM)
 
             IF         COND(&HISTMN = 'Y') THEN(DO)
             CPYF       FROMFILE(MRPOSTPD) TOFILE(MRPOSTXPD) +
                          FROMMBR(*ALL) TOMBR(HIST) MBROPT(*ADD) +
                          INCREL((*IF CY *EQ &CALY) (*AND CM *EQ &CALM))
 
             CALL       PGM(MR000012) PARM(&CALY &CALM &CSMDAT)
 
             ENDDO
 
             GOTO       CMDLBL(LOOP)
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MRC0012 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 
ENDP:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
