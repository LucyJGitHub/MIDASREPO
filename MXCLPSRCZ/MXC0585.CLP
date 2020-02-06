/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MX Balance accumulation - DL module')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MXC0585 - Balance Accumulation - DEALING Module             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. 185351             Data 23Oct00              */
/*                      CMX001  *CREATE    Date 01Jan00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       185351 - Mismatch between events and balances sent to CS4++ */
/*       CMX001 - Meridian Export                                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,MXC0585INT                                          */
 
             DCL        VAR(&DTAG) TYPE(*CHAR) LEN( 4)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(30)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
/*/COPY WNCPYSRC,MXC0585MPS                                          */
 
/* FXDL */
 
             CHGVAR     VAR(&DTAG) VALUE(FXDL)
 
             OVRDBF     FILE(MXMEDLL2) TOFILE(MXMEDLL2) MBR(&DTAG)
             OVRDBF     FILE(MXMEDLPL2) TOFILE(MXMEDLPL2) MBR(&DTAG)
             OVRDBF     FILE(MXBLDLPD) TOFILE(MXBLDLPD) MBR(&DTAG)
             CLRPFM     FILE(MXBLDLPD) MBR(&DTAG)
 
             CALL       PGM(MXBLACDL) PARM(&RTCD &ERMS &DTAG)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0585 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/* LDNI */
 
             CHGVAR     VAR(&DTAG) VALUE(LDNI)
 
             OVRDBF     FILE(MXMEDLL2) TOFILE(MXMEDLL2) MBR(&DTAG)
             OVRDBF     FILE(MXMEDLPL2) TOFILE(MXMEDLPL2) MBR(&DTAG)
             OVRDBF     FILE(MXBLDLPD) TOFILE(MXBLDLPD) MBR(&DTAG)
             CLRPFM     FILE(MXBLDLPD) MBR(&DTAG)
 
             CALL       PGM(MXBLACDL) PARM(&RTCD &ERMS &DTAG)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0585 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/* NASP */
 
             CHGVAR     VAR(&DTAG) VALUE(NASP)
 
             OVRDBF     FILE(MXMEDLL2) TOFILE(MXMEDLL2) MBR(&DTAG)
             OVRDBF     FILE(MXMEDLPL2) TOFILE(MXMEDLPL2) MBR(&DTAG)
             OVRDBF     FILE(MXBLDLPD) TOFILE(MXBLDLPD) MBR(&DTAG)
             CLRPFM     FILE(MXBLDLPD) MBR(&DTAG)
 
             CALL       PGM(MXBLACDL) PARM(&RTCD &ERMS &DTAG)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0585 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/* NASS */
 
             CHGVAR     VAR(&DTAG) VALUE(NASS)
 
             OVRDBF     FILE(MXMEDLL2) TOFILE(MXMEDLL2) MBR(&DTAG)
             OVRDBF     FILE(MXMEDLPL2) TOFILE(MXMEDLPL2) MBR(&DTAG)
             OVRDBF     FILE(MXBLDLPD) TOFILE(MXBLDLPD) MBR(&DTAG)
             CLRPFM     FILE(MXBLDLPD) MBR(&DTAG)
 
             CALL       PGM(MXBLACDL) PARM(&RTCD &ERMS &DTAG)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0585 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/* FRAS */
 
             CHGVAR     VAR(&DTAG) VALUE(FRAS)
 
             OVRDBF     FILE(MXMEDLL2) TOFILE(MXMEDLL2) MBR(&DTAG)
             OVRDBF     FILE(MXMEDLPL2) TOFILE(MXMEDLPL2) MBR(&DTAG)
             OVRDBF     FILE(MXBLDLPD) TOFILE(MXBLDLPD) MBR(&DTAG)
             CLRPFM     FILE(MXBLDLPD) MBR(&DTAG)
 
             CALL       PGM(MXBLACDL) PARM(&RTCD &ERMS &DTAG)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0585 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/* SIRS */
 
             CHGVAR     VAR(&DTAG) VALUE(SIRS)
 
             OVRDBF     FILE(MXMEDLL2) TOFILE(MXMEDLL2) MBR(&DTAG)
             OVRDBF     FILE(MXMEDLPL2) TOFILE(MXMEDLPL2) MBR(&DTAG)
             OVRDBF     FILE(MXBLDLPD) TOFILE(MXBLDLPD) MBR(&DTAG)
             CLRPFM     FILE(MXBLDLPD) MBR(&DTAG)
 
             CALL       PGM(MXBLACDL) PARM(&RTCD &ERMS &DTAG)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0585 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/* CIRS */
 
             CHGVAR     VAR(&DTAG) VALUE(CIRS)
 
             OVRDBF     FILE(MXMEDLL2) TOFILE(MXMEDLL2) MBR(&DTAG)
             OVRDBF     FILE(MXMEDLPL2) TOFILE(MXMEDLPL2) MBR(&DTAG)
             OVRDBF     FILE(MXBLDLPD) TOFILE(MXBLDLPD) MBR(&DTAG)
             CLRPFM     FILE(MXBLDLPD) MBR(&DTAG)
 
             CALL       PGM(MXBLACDL) PARM(&RTCD &ERMS &DTAG)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0585 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/* CFCO */
 
             CHGVAR     VAR(&DTAG) VALUE(CFCO)
 
             OVRDBF     FILE(MXMEDLL2) TOFILE(MXMEDLL2) MBR(&DTAG)
             OVRDBF     FILE(MXMEDLPL2) TOFILE(MXMEDLPL2) MBR(&DTAG)
             OVRDBF     FILE(MXBLDLPD) TOFILE(MXBLDLPD) MBR(&DTAG)
             CLRPFM     FILE(MXBLDLPD) MBR(&DTAG)
 
             CALL       PGM(MXBLACDL) PARM(&RTCD &ERMS &DTAG)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0585 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
             CPYF       FROMFILE(MXBLDLPD) TOFILE(QTEMP/MXBLDLPDA) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          CRTFILE(*YES) INCREL((*IF CCY *EQ '???'))                       /*185351*/
             CPYF       FROMFILE(MXMEDLPD) TOFILE(QTEMP/MXMEDLPDA) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          CRTFILE(*YES) INCREL((*IF BCCY *EQ '???'))                      /*185351*/
 
             OVRDBF     FILE(MXBLDLL0) MBR(LDNI)                                          /*185351*/
             OVRDBF     FILE(MXMEDLL0) MBR(LDNI)                                          /*185351*/
             OVRDBF     FILE(MXBLDLPDA) TOFILE(QTEMP/MXBLDLPDA) +
                          MBR(LDNI)                                                       /*185351*/
             OVRDBF     FILE(MXMEDLPDA) TOFILE(QTEMP/MXMEDLPDA) +
                          MBR(LDNI)                                                       /*185351*/
 
             CALL       PGM(MXMATEBDC)                                                    /*185351*/
 
             DLTOVR     FILE(*ALL)                                                        /*185351*/
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)                                          /*185351*/
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0585 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)                                          /*185351*/
               GOTO       CMDLBL(END)                                                     /*185351*/
             ENDDO                                                                        /*185351*/
 
             CPYF       FROMFILE(QTEMP/MXBLDLPDA) TOFILE(MXBLDLPD) +
                          FROMMBR(LDNI) TOMBR(LDNI) MBROPT(*ADD)
             MONMSG     MSGID(CPF0000)                                                    /*185351*/
             CPYF       FROMFILE(QTEMP/MXMEDLPDA) TOFILE(MXMEDLPD) +
                          FROMMBR(LDNI) TOMBR(LDNI) MBROPT(*ADD)                          /*185351*/
             MONMSG     MSGID(CPF0000)                                                    /*185351*/
 
/*/COPY WNCPYSRC,MXC0585MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,MXC0585ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0585 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,MXC0585END                                          */
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
