/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MR Drop Redundant TRAP Data')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - MidasPlus Reporting module                          */
/*                                                                   */
/*       MRC0226 - Drop Redundant TRAP Data                          */
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
             PGM
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('MRC0226 - Drop Redundant TRAP Data') +
             TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
             DLTF       FILE(QTEMP/MRTRAPX)
             MONMSG     MSGID(CPF0000)
 
             CPYF       FROMFILE(MRTRAPXPD) TOFILE(QTEMP/MRTRAPX) +
                          FROMMBR(CURR) TOMBR(*FROMMBR) +
                          CRTFILE(*YES) INCREL((*IF EXPAMT *NE 0) +
                          (*OR EXAAMT *NE 0) (*OR EXEAMT *NE 0) +
                          (*OR EXUAMT *NE 0) (*OR EXNIMT *NE 0) +
                          (*OR EXNPMT *NE 0))
 
             CLRPFM     FILE(MRTRAPPD) MBR(*FIRST)
 
             CPYF       FROMFILE(QTEMP/MRTRAPX) TOFILE(MRTRAPPD) +
                          FROMMBR(CURR) TOMBR(*FIRST) MBROPT(*ADD) +
                          INCREL((*IF EXSTAT *NE 'M'))
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
                SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                             MRC0226 ended abnormally - see job log') +
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
