/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MX Balance accumulation - LE module')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MXC0590 - Balance Accumulation - LENDING module             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD024477           Data 07May14              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. 185351             Data 23Oct00              */
/*                      CMX001  *CREATE    Data 01Jan00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD024477 - Reached limit for spooled records in QSYSPRT     */
/*       185351 - Mismatch between events and balances sent to CS4++ */
/*       CMX001 - Meridian Export                                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,MXC0590INT                                          */
 
             DCL        VAR(&DTAG) TYPE(*CHAR) LEN( 4)
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
 
/*/COPY WNCPYSRC,MXC0590MPS                                          */
 
/* CLLN */
 
             CHGVAR     VAR(&DTAG) VALUE(CLLN)
 
             OVRDBF     FILE(MXMELELL2) TOFILE(MXMELELL2) MBR(&DTAG)
             OVRDBF     FILE(MXMELELPL2) TOFILE(MXMELELPL2) MBR(&DTAG)
             OVRDBF     FILE(MXBLLELPD) TOFILE(MXBLLELPD) MBR(&DTAG)
             CLRPFM     FILE(MXBLLELPD) MBR(&DTAG)
 
             CALL       PGM(MXBLACLEL) PARM(&RTCD &ERMS &DTAG)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0590 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/* CLPS */
 
             CHGVAR     VAR(&DTAG) VALUE(CLPS)
 
             OVRDBF     FILE(MXMELELL2) TOFILE(MXMELELL2) MBR(&DTAG)
             OVRDBF     FILE(MXMELELPL2) TOFILE(MXMELELPL2) MBR(&DTAG)
             OVRDBF     FILE(MXBLLELPD) TOFILE(MXBLLELPD) MBR(&DTAG)
             CLRPFM     FILE(MXBLLELPD) MBR(&DTAG)
 
             CALL       PGM(MXBLACLEL) PARM(&RTCD &ERMS &DTAG)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0590 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/* CLGU */
 
             CHGVAR     VAR(&DTAG) VALUE(CLGU)
 
             OVRDBF     FILE(MXMELELL2) TOFILE(MXMELELL2) MBR(&DTAG)
             OVRDBF     FILE(MXMELELPL2) TOFILE(MXMELELPL2) MBR(&DTAG)
             OVRDBF     FILE(MXBLLELPD) TOFILE(MXBLLELPD) MBR(&DTAG)
             CLRPFM     FILE(MXBLLELPD) MBR(&DTAG)
 
             CALL       PGM(MXBLACLEL) PARM(&RTCD &ERMS &DTAG)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0590 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
             CPYF       FROMFILE(MXBLLELPD) TOFILE(QTEMP/MXBLLELPDA) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          CRTFILE(*YES) INCREL((*IF CCY *EQ '???'))                       /*185351*/
             CPYF       FROMFILE(MXMELELPD) TOFILE(QTEMP/MXMELELPDA) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          CRTFILE(*YES) INCREL((*IF BCCY *EQ '???'))                      /*185351*/
 
/* CLLN */                                                                                /*185351*/
 
             CHGVAR     VAR(&DTAG) VALUE(CLLN)                                            /*185351*/
 
             OVRDBF     FILE(MXBLLELL0) MBR(&DTAG)                                        /*185351*/
             OVRDBF     FILE(MXMELELL0) MBR(&DTAG)                                        /*185351*/
             OVRDBF     FILE(MXBLLELPDA) TOFILE(QTEMP/MXBLLELPDA) +
                          MBR(&DTAG)                                                      /*185351*/
             OVRDBF     FILE(MXMELELPDA) TOFILE(QTEMP/MXMELELPDA) +
                          MBR(&DTAG)                                                      /*185351*/
             OVRPRTF    FILE(QSYSPRT) MAXRCDS(*NOMAX)                                   /*MD024477*/
 
             CALL       PGM(MXMATEBLE) PARM(&DTAG)                                        /*185351*/
 
             DLTOVR     FILE(*ALL)                                                        /*185351*/
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)                                          /*185351*/
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0590 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)                                          /*185351*/
               GOTO       CMDLBL(END)                                                     /*185351*/
             ENDDO                                                                        /*185351*/
 
             CPYF       FROMFILE(QTEMP/MXBLLELPDA) TOFILE(MXBLLELPD) +
                          FROMMBR(&DTAG) TOMBR(&DTAG) MBROPT(*ADD)                        /*185351*/
             MONMSG     MSGID(CPF0000)                                                    /*185351*/
             CPYF       FROMFILE(QTEMP/MXMELELPDA) TOFILE(MXMELELPD) +
                          FROMMBR(&DTAG) TOMBR(&DTAG) MBROPT(*ADD)                        /*185351*/
             MONMSG     MSGID(CPF0000)                                                    /*185351*/
 
/* CLPS */                                                                                /*185351*/
 
             CHGVAR     VAR(&DTAG) VALUE(CLPS)                                            /*185351*/
 
             OVRDBF     FILE(MXBLLELL0) MBR(&DTAG)                                        /*185351*/
             OVRDBF     FILE(MXMELELL0) MBR(&DTAG)                                        /*185351*/
             OVRDBF     FILE(MXBLLELPDA) TOFILE(QTEMP/MXBLLELPDA) +
                          MBR(&DTAG)                                                      /*185351*/
             OVRDBF     FILE(MXMELELPDA) TOFILE(QTEMP/MXMELELPDA) +
                          MBR(&DTAG)                                                      /*185351*/
             OVRPRTF    FILE(QSYSPRT) MAXRCDS(*NOMAX)                                   /*MD024477*/
 
             CALL       PGM(MXMATEBLE) PARM(&DTAG)                                        /*185351*/
 
             DLTOVR     FILE(*ALL)                                                        /*185351*/
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)                                          /*185351*/
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0590 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)                                          /*185351*/
               GOTO       CMDLBL(END)                                                     /*185351*/
             ENDDO                                                                        /*185351*/
 
             CPYF       FROMFILE(QTEMP/MXBLLELPDA) TOFILE(MXBLLELPD) +
                          FROMMBR(&DTAG) TOMBR(&DTAG) MBROPT(*ADD)                        /*185351*/
             MONMSG     MSGID(CPF0000)                                                    /*185351*/
             CPYF       FROMFILE(QTEMP/MXMELELPDA) TOFILE(MXMELELPD) +
                          FROMMBR(&DTAG) TOMBR(&DTAG) MBROPT(*ADD)                        /*185351*/
             MONMSG     MSGID(CPF0000)                                                    /*185351*/
 
/* CLGU */                                                                                /*185351*/
 
             CHGVAR     VAR(&DTAG) VALUE(CLGU)                                            /*185351*/
 
             OVRDBF     FILE(MXBLLELL0) MBR(&DTAG)                                        /*185351*/
             OVRDBF     FILE(MXMELELL0) MBR(&DTAG)                                        /*185351*/
             OVRDBF     FILE(MXBLLELPDA) TOFILE(QTEMP/MXBLLELPDA) +
                          MBR(&DTAG)                                                      /*185351*/
             OVRDBF     FILE(MXMELELPDA) TOFILE(QTEMP/MXMELELPDA) +
                          MBR(&DTAG)                                                      /*185351*/
             OVRPRTF    FILE(QSYSPRT) MAXRCDS(*NOMAX)                                   /*MD024477*/
 
             CALL       PGM(MXMATEBLE) PARM(&DTAG)                                        /*185351*/
 
             DLTOVR     FILE(*ALL)                                                        /*185351*/
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)                                          /*185351*/
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0590 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)                                          /*185351*/
               GOTO       CMDLBL(END)                                                     /*185351*/
             ENDDO                                                                        /*185351*/
 
             CPYF       FROMFILE(QTEMP/MXBLLELPDA) TOFILE(MXBLLELPD) +
                          FROMMBR(&DTAG) TOMBR(&DTAG) MBROPT(*ADD)                        /*185351*/
             MONMSG     MSGID(CPF0000)                                                    /*185351*/
             CPYF       FROMFILE(QTEMP/MXMELELPDA) TOFILE(MXMELELPD) +
                          FROMMBR(&DTAG) TOMBR(&DTAG) MBROPT(*ADD)                        /*185351*/
             MONMSG     MSGID(CPF0000)                                                    /*185351*/
 
/*/COPY WNCPYSRC,MXC0590MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,MXC0590ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0590 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,MXC0590END                                          */
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
