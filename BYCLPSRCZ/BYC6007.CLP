/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MX Daily Reconciliation - Futures & Options')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       BYC6007 - Daily Reconciliation - FUTURES & OPTIONS          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*                                                                   */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Last Amend No. LLN021             Data 21Nov03              */
/*       Prev Amend No. CMX001  *CREATE    Data 21Nov03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*     LLN021 - BoE Profit and Loss return                           */
/*     CMX001 - Meridian Export                                      */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,BYC6007INT                                          */
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(30)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
/*/COPY WNCPYSRC,BYC6007MPS                                          */
 
 
/* Get Futures & Options module generated entries for reconciliation */
 
             CPYF       FROMFILE(GEFFPD) TOFILE(MXGERCPD) +
                          MBROPT(*REPLACE) INCREL((*IF ACSC *EQ +
                          'IN') (*OR ACSC *EQ 'EX'))
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MXGERCPD))
             CPYF       FROMFILE(GEFF2PD) TOFILE(MXGERCPD) +
                          MBROPT(*ADD) INCREL((*IF ACSC *EQ 'IN') +
                          (*OR ACSC *EQ 'EX'))
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
 
/* Clear generated entries for events */
 
             CLRPFM     FILE(MXGEEVPD)
 
 
/* Generated Entries Extract - Futures & Options BOOK POSITIONS */
 
             CALL       PGM(BY6007) PARM(&RTCD &ERMS)
/* Error */
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            BYC6007 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/* Generated Entries Extract - Futures & Options TRADE POSITIONS */
 
             CALL       PGM(BY6008) PARM(&RTCD &ERMS)
/* Error */
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            BYC6007 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
 
/* Generated Entries Reconciliation Report */
 
             CALL       PGM(MXGENTREC) PARM(&RTCD &ERMS 'FF ')
/* Error */
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            BYC6007 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
 
/*/COPY WNCPYSRC,BYC6007MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,BYC6007ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            BYC6007 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,BYC6007END                                          */
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
