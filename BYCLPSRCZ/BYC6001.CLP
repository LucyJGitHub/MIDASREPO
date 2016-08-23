/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MX Daily Events Extract - FUTS/OPS module')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       BYC6001 - Daily Events Extract - FUTURES and OPTIONS module */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Last Amend No. E15903             Data 09Dec03              */
/*       Prev Amend No. LLN021   *CREATE   Data 01Dec03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       E15903 - Program clearing and copying wrong files           */
/*       LLN021 - BoE PL Reports                                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(30)
             DCL        VAR(&MNTRAC) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FFEOC) TYPE(*CHAR) LEN(62)                                   /*LLN021*/
             DCL        &A            TYPE(*DEC)   LEN(2 0) VALUE(1)                      /*LLN021*/
             DCL        &MKT          TYPE(*CHAR)  LEN(2)                                 /*LLN021*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
/*Start LLN021*/
 
 
             CPYF       FROMFILE(FOKEYD) TOFILE(BYFOKYPP) +
                          FROMMBR(OTC) MBROPT(*ADD)
             MONMSG     MSGID(CPF2817 CPF2869)
 
/* LOOP TO PROCESS ALL MARKET CENTRES CONTAINED IN DTAARA/FFEOC     */
/**/
             RTVDTAARA  DTAARA(FFEOC) RTNVAR(&FFEOC)
/**/
 LOOP:                                                                                    /*E15903*/
             IF         COND((%SST(&FFEOC &A 2) *EQ '  ')  +
                        *OR (&A *GT 61)) THEN(GOTO CMDLBL(NEXT))                          /*E15903*/
             CHGVAR     VAR(&MKT) VALUE(%SST(&FFEOC &A 2))                                /*E15903*/
/**/
 
             CPYF       FROMFILE(FOKEYD) TOFILE(BYFOKYPP) +
                          FROMMBR(&MKT) MBROPT(*ADD)
             MONMSG     MSGID(CPF2817 CPF2869)
 
             CHGVAR     VAR(&A) VALUE(&A + 2)                                             /*E15903*/
             GOTO       CMDLBL(LOOP)                                                      /*E15903*/
 
NEXT:
 
/*End LLN021*/
 
/* Get F/O's module generated entries for reconciliation */
 
/*           CPYF       FROMFILE(GEFFPD) TOFILE(MXGERCPD) +
                          MBROPT(*REPLACE) INCREL((*IF ACSC *EQ +
                          'IN') (*OR ACSC *EQ 'EX'))           */
/*           MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MXGERCPD))                  */
 
/*           CPYF       FROMFILE(GEFF2PD) TOFILE(MXGERCPD) +
                          MBROPT(*ADD) INCREL((*IF ACSC *EQ 'IN') +
                          (*OR ACSC *EQ 'EX'))           */
/*           MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)   */                               /*LLN021*/
 
/**Clear*generated*entries*for*events */                                                  /*LLN021*/
 
/****        CLRPFM     FILE(MXGEEVPD)  **/                                               /*LLN021*/
 
             CLRPFM     FILE(MXDEFFTPD)          /*LLN021*/
             CLRPFM     FILE(MXDEFFBPD)          /*LLN021*/
 
 
/**Generated*Entries*Extract*- FUTURES/OPTIONS Module**/                                /* LLN021 */
/* Daily events extract FUTURES and OPTIONS */                                          /* LLN021 */
 
             CALL       PGM(BY6001) PARM(&RTCD &ERMS)
/* Error */
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            BYC0001 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
 
/**Generated*Entries*Reconciliation*Report */                                           /* LLN021 */
 
 /*          CALL       PGM(MXGENTREC) PARM(&RTCD &ERMS 'FF') */
/* Error */
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            BYC0001 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0800 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
