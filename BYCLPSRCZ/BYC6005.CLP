/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MX Daily Reconciliation - SECURITIES module')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       BYC6005 - Daily Reconciliation - SECURITIES module          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Prev Amend No. LLN021             Data 26Nov03              */
/*                      CMX001  *CREATE    Data 18Nov03              */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       LLN021 - Should only report up until the end of the month   */
/*       CMX001 - Meridian Export                                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,BYC6005INT                                          */
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(30)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CUREOM) TYPE(*CHAR) LEN(5)                                   /*LLN021*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/* Retrieve begin and end month dates */                                                  /*LLN021*/
 
             RTVDTAARA  DTAARA(MXEXPCTL (01 5)) RTNVAR(&CUREOM)
                                                                                          /*LLN021*/
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
/*/COPY WNCPYSRC,BYC6005MPS                                          */
 
 
/* Get SECURITIES module generated entries for reconciliation */
 
/**********  CPYF       FROMFILE(GESTPD) TOFILE(MXGERCPD) +
                          MBROPT(*REPLACE) INCREL((*IF ACSC *EQ +
                          'IN') (*OR ACSC *EQ 'EX') (*AND VALD *LE +
                          &CUREOM))                                  */                   /*LLN021*/
/**********  CPYF       FROMFILE(GESTPD) TOFILE(MXGERCPD) +
                          MBROPT(*ADD) INCREL((*IF VALD *LE &CUREOM))*/                   /*LLN021*/
             CPYF       FROMFILE(MXDESEBPD) TOFILE(MXDESEBP1) +
                          MBROPT(*REPLACE) INCREL((*IF EVDT *LE +
                          &CUREOM))
             MONMSG     MSGID(CPF2817 CPF2869)                                            /*LLN021*/
             CPYF       FROMFILE(MXDESETPD) TOFILE(MXDESETP1) +
                          MBROPT(*REPLACE) INCREL((*IF EVDT *LE +
                          &CUREOM))                                                       /*LLN021*/
             MONMSG     MSGID(CPF2817 CPF2869)                                            /*LLN021*/
             CPYF       FROMFILE(GESTPD) TOFILE(MXGERCPD) +
                          MBROPT(*REPLACE) INCREL((*IF ACSC *EQ +
                          'IN') (*AND VALD *LE &CUREOM) (*OR ACSC +
                          *EQ 'EX') (*AND VALD *LE &CUREOM))                              /*LLN021*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MXGERCPD))                                                 /*LLN021*/
/**********  CPYF       FROMFILE(GEST1PD) TOFILE(MXGERCPD) +
                          MBROPT(*ADD) INCREL((*IF ACSC *EQ 'IN') +
                          (*OR ACSC *EQ 'EX')) */ /* LLN021 */
/*           MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)*/                                  /*LNN021*/
 
 
/* Clear generated entries for events */
 
             CLRPFM     FILE(MXGEEVPD)
 
             OVRDBF     FILE(MXDESEBPD) TOFILE(MXDESEBP1)
 
/* Generated Entries Extract - SECURITIES BOOK POSITIONS */
 
             CALL       PGM(BY6005) PARM(&RTCD &ERMS)
/* Error */
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0002 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/* Generated Entries Extract - SECURITIES TRADE POSITIONS */
 
             OVRDBF     FILE(MXDESETPD) TOFILE(MXDESETP1)
             CALL       PGM(BY6006) PARM(&RTCD &ERMS)
/* Error */
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0002 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
 
/* Generated Entries Reconciliation Report */
 
             CALL       PGM(MXGENTREC) PARM(&RTCD &ERMS 'SE ')
/* Error */
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0002 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
 
/*/COPY WNCPYSRC,BYC6005MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,BYC6005ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            BYC6005 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,BYC6005END                                          */
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
