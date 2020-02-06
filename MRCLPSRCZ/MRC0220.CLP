/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MR Copy TRAP Data to 1st Member')               */
/*OVR  : OVRDBF FILE(FDMBR) TOFILE(QAFDMBRL)                        :*/
/*********************************************************************/
/*                                                                   */
/*       Midas - MidasPlus Reporting module                          */
/*                                                                   */
/*       MRC0220 - Copy TRAP Data to 1st Member                      */
/*                                                                   */
/*       (c) Finastra International Limited 2004                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CMR001  *CREATE    Date 07Sep04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CMR001 - MidasPlus Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2004')
             DCLF       FILE(QTEMP/FDMBR)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('MRC0220 -  Copy TRAP Data to 1st Member') TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
/*Copy*/
             CLRPFM     FILE(MRTRAPPD) MBR(MRTRAPPD)
             DSPFD      FILE(MRTRAPPD) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/FDMBR)
 
LOOP:        RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
 
             IF         COND(&MLNAME *NE 'MRTRAPPD') THEN(DO)
 
             CPYF       FROMFILE(MRTRAPPD) TOFILE(MRTRAPPD) +
                          FROMMBR(&MLNAME) TOMBR(MRTRAPPD) MBROPT(*ADD)
 
             ENDDO
 
             GOTO       CMDLBL(LOOP)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
                SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                             MRC0220 ended abnormally - see job log') +
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
