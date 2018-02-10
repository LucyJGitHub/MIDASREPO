/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MR Extract Transactions, Accnts & Posns Dats')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - MidasPlus Reporting module                          */
/*                                                                   */
/*       MRC0600 - Extract Transactions, Accounts & Positions Dates  */
/*                                                                   */
/*       (c) Finastra International Limited 2004                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG6543  *CREATE   Date 08Apr05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG6543 - MRTRAPXPD file is not purged.                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2004')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('MRC0600 - Extract Transactions, +
                          Accounts & Positions Dates') TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
/* Query MRTRAPXPD for the transactions, accounts & positions dates */
 
             DLTF       FILE(QTEMP/MRTRDTPDX)
             MONMSG     MSGID(CPF0000)
 
             CPYF       FROMFILE(MRTRDTPD) TOFILE(QTEMP/MRTRDTPDX) +
                          CRTFILE(*YES)
             CLRPFM     FILE(QTEMP/MRTRDTPDX)
 
             OVRDBF     FILE(MRTRDTPD) TOFILE(MRTRAPXPD) SHARE(*YES) +
                          SEQONLY(*YES 1000)
 
             OPNQRYF    FILE((MRTRAPXPD MRTRAPXPD)) FORMAT(MRTRDTPD) +
                          KEYFLD((EXTDAT)) GRPFLD(EXTDAT)  +
                          MAPFLD((RECTYP  '" "') )
 
/* Extract Transactions, Accounts & Positions Dates */
 
             CALL       PGM(MR000600)
 
/*error*/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
 
/* Update Transactions, Accounts & Positions Dates file */
 
             DLTOVR     FILE(MRTRDTPD)
             CLOF       OPNID(MRTRAPXPD)
 
             CPYF       FROMFILE(QTEMP/MRTRDTPDX) TOFILE(MRTRDTPD) +
                          MBROPT(*REPLACE)
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
                SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                             MRC0600 ended abnormally - see job log') +
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
                          Finastra International Limited')
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
