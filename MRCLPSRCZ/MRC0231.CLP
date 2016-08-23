/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MR Transaction, Account & Position Reconciln')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - MidasPlus Reporting module                          */
/*                                                                   */
/*       MRC0231 - Transaction, Account and Position Reconciliation  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CMR001  *CREATE    Date 07Sep04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CMR001 - MidasPlus Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&EXT &IC)
 
             DCL        VAR(&EXT) TYPE(*CHAR) LEN(4)
             DCL        VAR(&IC ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('MRC0231 - Transaction, Account and +
                          Position Reconciliation') TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
             IF         COND(&IC = 'Y') THEN(CHGJOB SWS(10000000))
 
/*overrides*/
             OVRDBF     FILE(MRTRAPL1) SHARE(*NO) SEQONLY(*YES 1000)
             OVRDBF     FILE(MRTRAPL2) SHARE(*NO) SEQONLY(*YES 1000)
             OVRDBF     FILE(MRTRAPL3) SHARE(*NO) SEQONLY(*YES 1000)
             OVRDBF     FILE(MRTRAPL4) SHARE(*NO) SEQONLY(*YES 1000)
             OVRDBF     FILE(MRTRAPL5) SHARE(*NO) SEQONLY(*YES 1000)
             OVRDBF     FILE(MRTRAPL6) SHARE(*NO) SEQONLY(*YES 1000)
             OVRDBF     FILE(MRTRAPL7) SHARE(*NO) SEQONLY(*YES 1000)
             OVRDBF     FILE(MRTRAPL8) SHARE(*NO) SEQONLY(*YES 1000)
 
             OVRDBF     FILE(MRSLACPD) MBR(&EXT)
             CLRPFM     FILE(MRSLACPD) MBR(&EXT)
 
             OVRDBF     FILE(MRSLTRPD) MBR(&EXT)
             CLRPFM     FILE(MRSLTRPD) MBR(&EXT)
 
/*call pgms*/
             CALL       PGM(MRRECPB) PARM(&EXT 'N')
             CALL       PGM(MRRECPC) PARM(&EXT 'N')
 
             CALL       PGM(MRRECPB) PARM(&EXT 'Y')
             CALL       PGM(MRRECPC) PARM(&EXT 'Y')
 
             DLTOVR     FILE(*ALL)
 
/*error*/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                IF         COND(&JOBTYPE = '0') THEN(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MRC0231 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(END)
                ENDDO
 
                IF         COND(&JOBTYPE = '1') THEN(DO)
                   SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(END)
                ENDDO
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
                SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                             MRC0231 ended abnormally - see job log') +
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
