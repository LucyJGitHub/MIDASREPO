/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MR Transaction Manual Adjustments Extract')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - MidasPlus Reporting module                          */
/*                                                                   */
/*       MRC0234 - Transaction Manual Adjustments Extract            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG6543            Date 08Apr05              */
/*       Prev Amend No. CMR001  *CREATE    Date 07Sep04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG6543 - MRTRAPXPD file is not purged.                     */
/*       CMR001 - MidasPlus Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('MRC0234 - Transaction Manual +
                          Adjustments Extract') TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
/* clear extract file*/
 
             CLRPFM     FILE(MRTRAPPD) MBR(TMAD)
 
/*overrides*/
             OVRDBF     FILE(MRTRAPPD) MBR(TMAD) OVRSCOPE(*JOB) +
                          SHARE(*NO) SEQONLY(*YES 1000)
 
/*call transaction  manual adjustment extract pgm*/
 
             CALL       PGM(MRTMADEXT)
 
/*error*/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                IF         COND(&JOBTYPE = '0') THEN(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MRC0234 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(END)
                ENDDO
 
                IF         COND(&JOBTYPE = '1') THEN(DO)
                   SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(END)
                ENDDO
             ENDDO
 
/*delete override*/
 
             DLTOVR     FILE(MRTRAPPD) LVL(*JOB)
 
/*add manual transactions*/
 
/*********** CPYF       FROMFILE(MRTRAPPD) TOFILE(MRTRAPXPD) +        **********/        /*BUG6543*/
/***********              FROMMBR(TMAD) TOMBR(CURR) MBROPT(*ADD)      **********/        /*BUG6543*/
/*********** CPYF       FROMFILE(MRTRAPPD) TOFILE(MRTRAPXPD) +        **********/        /*BUG6543*/
/***********              FROMMBR(TMAD) TOMBR(MRTRAPXPD) MBROPT(*ADD) **********/        /*BUG6543*/
 
             CPYF       FROMFILE(MRTRAPPD) TOFILE(MRTRAPPD) +
                          FROMMBR(TMAD) TOMBR(*FIRST) MBROPT(*ADD)
 
             CLRPFM     FILE(MRTRAPPD) MBR(TMAD)
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
                SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                             MRC0234 ended abnormally - see job log') +
                             TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
