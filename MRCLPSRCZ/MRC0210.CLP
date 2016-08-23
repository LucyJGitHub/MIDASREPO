/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MR Transaction, Account & Position Extracts')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - MidasPlus Reporting module                          */
/*                                                                   */
/*       MRC0210 - Transaction, Account and Position Extracts        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CMR001  *CREATE    Date 07Sep04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CMR001 - MidasPlus Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&EXT)
 
             DCL        VAR(&EXT) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TDINCSV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('MRC0210 - Transaction, Account and +
                          Position Extracts') TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
/*clear extract file*/
 
             CLRPFM     FILE(MRTRAPPD) MBR(&EXT)
 
/*overrides*/
             OVRDBF     FILE(MRTRAPPD) MBR(&EXT) SHARE(*NO) SEQONLY(*YES 1000)
             OVRDBF     FILE(ACCNTAB ) SHARE(*NO) SEQONLY(*YES 1000)
             OVRDBF     FILE(DEALSDG ) SHARE(*NO) SEQONLY(*YES 1000)
             OVRDBF     FILE(DEALSDB ) SHARE(*NO) SEQONLY(*YES 1000)
             OVRDBF     FILE(DEALSDC ) SHARE(*NO) SEQONLY(*YES 1000)
             OVRDBF     FILE(DEALSDD ) SHARE(*NO) SEQONLY(*YES 1000)
             OVRDBF     FILE(CLOANCL ) SHARE(*NO) SEQONLY(*YES 1000)
 
             IF         COND(&EXT = 'TDIN') THEN(DO)
             CLRPFM     FILE(MRTDINPD)
             CHGVAR     VAR(&TDINCSV) VALUE('Y')
             CHKOBJ     OBJ(FINTXN) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR VAR(&TDINCSV) +
                          VALUE('N'))
             IF         COND(&TDINCSV = 'Y') THEN(CALL PGM(MRTDINCSV))
             ENDDO
 
/*call pgm*/
             CHGVAR     VAR(&PGM) VALUE('MR' *CAT &EXT *CAT 'EXT')
             CALL       PGM(&PGM)
 
             DLTOVR     FILE(*ALL)
 
/*error*/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                IF         COND(&JOBTYPE = '0') THEN(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MRC0210 ended abnormally - see job log') +
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
                             MRC0210 ended abnormally - see job log') +
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
/*           RCLRSC                                 */
/*           MONMSG     MSGID(CPF0000 MCH0000)      */
/*           RCLRSC     LVL(*CALLER)                */
/*           MONMSG     MSGID(CPF0000 MCH0000)      */
/*           RCLACTGRP  ACTGRP(*ELIGIBLE)           */
/*           MONMSG     MSGID(CPF0000 MCH0000)      */
             ENDPGM
