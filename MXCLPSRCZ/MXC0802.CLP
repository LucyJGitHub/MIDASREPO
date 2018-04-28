/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MX Daily Reconciliation - LENDING module')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MXC0802 - Daily Reconciliation - LENDING module             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 221787             Data 06Jun06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CMX001  *CREATE    Data 01Jan00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       221787 - Prevent DBASE Error during COB.  Ignore records    */
/*                from GELEPD and GELE2PD with RECI = '*'.           */
/*       CMX001 - Meridian Export                                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,MXC0802INT                                          */
 
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
 
/*/COPY WNCPYSRC,MXC0802MPS                                          */
 
 
/* Get LENDING module generated entries for reconciliation */
 
/**********  CPYF       FROMFILE(GELEPD) TOFILE(MXGERCPD) +        ***/                   /*221787*/
/**********               MBROPT(*REPLACE) INCREL((*IF ACSC *EQ +  ***/                   /*221787*/
/**********               'IN') (*OR ACSC *EQ 'EX'))               ***/                   /*221787*/
             CPYF       FROMFILE(GELEPD) TOFILE(MXGERCPD) +
                          MBROPT(*REPLACE) INCREL((*IF ACSC *EQ +
                          'IN') (*AND RECI *EQ 'P') (*OR ACSC *EQ +
                          'EX') (*AND RECI *EQ 'P'))                                      /*221787*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MXGERCPD))
/**********  CPYF       FROMFILE(GELE2PD) TOFILE(MXGERCPD) +       ***/                   /*221787*/
/**********               MBROPT(*ADD) INCREL((*IF ACSC *EQ 'IN')++***/                   /*221787*/
/**********               (*OR ACSC *EQ 'EX'))                     ***/                   /*221787*/
             CPYF       FROMFILE(GELE2PD) TOFILE(MXGERCPD) +
                          MBROPT(*ADD) INCREL((*IF ACSC *EQ 'IN') +
                          (*AND RECI *EQ 'P') (*OR ACSC *EQ 'EX') +
                          (*AND RECI *EQ 'P'))                                            /*221787*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
 
/* Clear generated entries for events */
 
             CLRPFM     FILE(MXGEEVPD)
 
 
/* Generated Entries Extract - LENDING Facilities */
 
             CALL       PGM(MXGEEXLEF) PARM(&RTCD &ERMS)
/* Error */
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0002 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
 
/* Generated Entries Extract - LENDING Loans */
 
             CALL       PGM(MXGEEXLEL) PARM(&RTCD &ERMS)
/* Error */
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0002 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
 
/* Generated Entries Reconciliation Report */
 
             CALL       PGM(MXGENTREC) PARM(&RTCD &ERMS 'LE ')
/* Error */
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0002 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
 
/*/COPY WNCPYSRC,MXC0802MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,MXC0802ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0802 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,MXC0802END                                          */
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
