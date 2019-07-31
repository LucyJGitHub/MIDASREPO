/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MX Monthly Events Acc. - DEALING Module')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MXC0555 - Monthly Events Accumulation - DEALING Module      */
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
/*       Prev Amend No. CMX001  *CREATE    Data 01Jan00              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CMX001 - Meridian Export                                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,MXC0555INT                                          */
 
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
 
/*/COPY WNCPYSRC,MXC0555MPS                                          */
 
/* FXDL */
 
             CHGVAR     VAR(&DTAG) VALUE(FXDL)
 
             OVRDBF     FILE(MXDEDLL0) TOFILE(MXDEDLL0) MBR(&DTAG)
             OVRDBF     FILE(MXMEDLL0) TOFILE(MXMEDLL0) MBR(&DTAG)
 
             CALL       PGM(MXMEACDL) PARM(&RTCD &ERMS &DTAG)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0555 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/* LDNI */
 
             CHGVAR     VAR(&DTAG) VALUE(LDNI)
 
             OVRDBF     FILE(MXDEDLL0) TOFILE(MXDEDLL0) MBR(&DTAG)
             OVRDBF     FILE(MXMEDLL0) TOFILE(MXMEDLL0) MBR(&DTAG)
 
             CALL       PGM(MXMEACDL) PARM(&RTCD &ERMS &DTAG)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0555 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/* NASP */
 
             CHGVAR     VAR(&DTAG) VALUE(NASP)
 
             OVRDBF     FILE(MXDEDLL0) TOFILE(MXDEDLL0) MBR(&DTAG)
             OVRDBF     FILE(MXMEDLL0) TOFILE(MXMEDLL0) MBR(&DTAG)
 
             CALL       PGM(MXMEACDL) PARM(&RTCD &ERMS &DTAG)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0555 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/* NASS */
 
             CHGVAR     VAR(&DTAG) VALUE(NASS)
 
             OVRDBF     FILE(MXDEDLL0) TOFILE(MXDEDLL0) MBR(&DTAG)
             OVRDBF     FILE(MXMEDLL0) TOFILE(MXMEDLL0) MBR(&DTAG)
 
             CALL       PGM(MXMEACDL) PARM(&RTCD &ERMS &DTAG)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0555 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/* FRAS */
 
             CHGVAR     VAR(&DTAG) VALUE(FRAS)
 
             OVRDBF     FILE(MXDEDLL0) TOFILE(MXDEDLL0) MBR(&DTAG)
             OVRDBF     FILE(MXMEDLL0) TOFILE(MXMEDLL0) MBR(&DTAG)
 
             CALL       PGM(MXMEACDL) PARM(&RTCD &ERMS &DTAG)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0555 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/* SIRS */
 
             CHGVAR     VAR(&DTAG) VALUE(SIRS)
 
             OVRDBF     FILE(MXDEDLL0) TOFILE(MXDEDLL0) MBR(&DTAG)
             OVRDBF     FILE(MXMEDLL0) TOFILE(MXMEDLL0) MBR(&DTAG)
 
             CALL       PGM(MXMEACDL) PARM(&RTCD &ERMS &DTAG)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0555 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/* CIRS */
 
             CHGVAR     VAR(&DTAG) VALUE(CIRS)
 
             OVRDBF     FILE(MXDEDLL0) TOFILE(MXDEDLL0) MBR(&DTAG)
             OVRDBF     FILE(MXMEDLL0) TOFILE(MXMEDLL0) MBR(&DTAG)
 
             CALL       PGM(MXMEACDL) PARM(&RTCD &ERMS &DTAG)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0555 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/* CFCO */
 
             CHGVAR     VAR(&DTAG) VALUE(CFCO)
 
             OVRDBF     FILE(MXDEDLL0) TOFILE(MXDEDLL0) MBR(&DTAG)
             OVRDBF     FILE(MXMEDLL0) TOFILE(MXMEDLL0) MBR(&DTAG)
 
             CALL       PGM(MXMEACDL) PARM(&RTCD &ERMS &DTAG)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0555 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
 
 
/*/COPY WNCPYSRC,MXC0555MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,MXC0555ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0555 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,MXC0555END                                          */
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
