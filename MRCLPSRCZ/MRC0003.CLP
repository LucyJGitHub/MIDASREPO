/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MR MidasPlus Extracts - After Post 1')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - MidasPlus Reporting Module                          */
/*                                                                   */
/*       MRC0003 - MidasPlus Extracts - After Post 1                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG9790            Date 05Jan06              */
/*       Prev Amend No. CMR001             Date 01Sep04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG9790 - Allow for Caps, Collars and Floors member.        */
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
 
             SNDPGMMSG  MSG('MRC0003 - MidasPlus Extracts - After Post 1') +
                          TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(00000000)
 
             CLRPFM     FILE(MRTRAPPD) MBR(ACCT)
             CLRPFM     FILE(MRTRAPPD) MBR(FRAS)
             CLRPFM     FILE(MRTRAPPD) MBR(FXDL)
             CLRPFM     FILE(MRTRAPPD) MBR(LDNI)
             CLRPFM     FILE(MRTRAPPD) MBR(LOAN)
             CLRPFM     FILE(MRTRAPPD) MBR(NASP)
             CLRPFM     FILE(MRTRAPPD) MBR(SWAP)
             CLRPFM     FILE(MRTRAPPD) MBR(CFCO)                                         /*BUG9790*/
             CLRPFM     FILE(MRTRAPPD) MBR(FCLT)
             CLRPFM     FILE(MRTRAPPD) MBR(TDIN)
             CLRPFM     FILE(MRTRAPPD) MBR(TMAD)
 
             CLRPFM     FILE(MRSLACPD) MBR(ACCT)
             CLRPFM     FILE(MRSLACPD) MBR(FRAS)
             CLRPFM     FILE(MRSLACPD) MBR(FXDL)
             CLRPFM     FILE(MRSLACPD) MBR(LDNI)
             CLRPFM     FILE(MRSLACPD) MBR(LOAN)
             CLRPFM     FILE(MRSLACPD) MBR(NASP)
             CLRPFM     FILE(MRSLACPD) MBR(SWAP)
             CLRPFM     FILE(MRSLACPD) MBR(FCLT)
             CLRPFM     FILE(MRSLACPD) MBR(TDIN)
             CLRPFM     FILE(MRSLACPD) MBR(TMAD)
 
             CLRPFM     FILE(MRSLTRPD) MBR(ACCT)
             CLRPFM     FILE(MRSLTRPD) MBR(FRAS)
             CLRPFM     FILE(MRSLTRPD) MBR(FXDL)
             CLRPFM     FILE(MRSLTRPD) MBR(LDNI)
             CLRPFM     FILE(MRSLTRPD) MBR(LOAN)
             CLRPFM     FILE(MRSLTRPD) MBR(NASP)
             CLRPFM     FILE(MRSLTRPD) MBR(SWAP)
             CLRPFM     FILE(MRSLTRPD) MBR(FCLT)
             CLRPFM     FILE(MRSLTRPD) MBR(TDIN)
             CLRPFM     FILE(MRSLTRPD) MBR(TMAD)
 
             CLRPFM     FILE(MRTREVPD) MBR(DL)
             CLRPFM     FILE(MRTREVPD) MBR(LE)
/*********   CLRPFM     FILE(MRTREVPD) MBR(TI)  ***********************/                 /*NADTEMP*/
 
             GOTO       CMDLBL(ENDP)
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MRC0003 ended abnormally - see job log') +
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
