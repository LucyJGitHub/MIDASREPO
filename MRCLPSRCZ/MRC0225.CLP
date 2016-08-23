/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MR Copy TRAP Data to Extracted To Date TRAP')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - MidasPlus Reporting module                          */
/*                                                                   */
/*       MRC0225 - Copy TRAP Data to Extracted To Date TRAP          */
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
 
             SNDPGMMSG  MSG('MRC0223 -  Copy TRAP Data to Extracted To Date TRAP') +
             TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
             DLTF       FILE(QTEMP/MRTRAPX)
             MONMSG     MSGID(CPF0000)
 
             CPYF       FROMFILE(MRTRAPPD) TOFILE(QTEMP/MRTRAPX) +
                          FROMMBR(*FIRST) TOMBR(*FROMMBR) +
                          CRTFILE(*YES) INCREL((*IF EXPAMT *NE 0) +
                          (*OR EXAAMT *NE 0) (*OR EXEAMT *NE 0) +
                          (*OR EXUAMT *NE 0) (*OR EXNIMT *NE 0) +
                          (*OR EXNPMT *NE 0))
 
/* CURR MEMBER HAS MRTRAPPD DATA ADDED TODAY */
 
             CLRPFM     FILE(MRTRAPXPD) MBR(CURR)
             CPYF       FROMFILE(QTEMP/MRTRAPX) TOFILE(MRTRAPXPD) +
                          FROMMBR(*FIRST) TOMBR(CURR) MBROPT(*ADD) +
                          INCREL((*IF EXSTAT *NE 'M'))
 
/***FIRST*MEMBER*ACCUMULATES*MRTRAPPD*DATA*TO*DATE**/                                    /*BUG6543*/
 
/************CPYF*******FROMFILE(QTEMP/MRTRAPX)*TOFILE(MRTRAPXPD) +*************/        /*BUG6543*/
/*************************FROMMBR(*FIRST)*TOMBR(*FIRST)*MBROPT(*ADD) +**********/        /*BUG6543*/
/*************************INCREL((*IF EXSTAT *NE 'M'))**************************/        /*BUG6543*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
                SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                             MRC0223 ended abnormally - see job log') +
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
