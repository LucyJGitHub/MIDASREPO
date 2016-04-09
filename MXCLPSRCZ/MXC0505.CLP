/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MX Daily Events Extract - DEALING Module')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MXC0505 - Daily Events Extract - DEALING Module             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Last Amend No. CMX001  *CREATE    Data 01Jan00              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CMX001 - Meridian Export                                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,MXC0505INT                                          */
 
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
 
/*/COPY WNCPYSRC,MXC0505MPS                                          */
 
             OVRDBF     FILE(DEFXDL) TOFILE(MXDEDLPD) MBR(FXDL) +
                          SEQONLY(*YES 100)
             OVRDBF     FILE(DELDNI) TOFILE(MXDEDLPD) MBR(LDNI) +
                          SEQONLY(*YES 100)
             OVRDBF     FILE(DENASP) TOFILE(MXDEDLPD) MBR(NASP) +
                          SEQONLY(*YES 100)
             OVRDBF     FILE(DENASS) TOFILE(MXDEDLPD) MBR(NASS) +
                          SEQONLY(*YES 100)
             OVRDBF     FILE(DEFRAS) TOFILE(MXDEDLPD) MBR(FRAS) +
                          SEQONLY(*YES 100)
             OVRDBF     FILE(DESIRS) TOFILE(MXDEDLPD) MBR(SIRS) +
                          SEQONLY(*YES 100)
             OVRDBF     FILE(DECIRS) TOFILE(MXDEDLPD) MBR(CIRS) +
                          SEQONLY(*YES 100)
             OVRDBF     FILE(DECFCO) TOFILE(MXDEDLPD) MBR(CFCO) +
                          SEQONLY(*YES 100)
 
             CLRPFM     FILE(MXDEDLPD) MBR(FXDL)
             CLRPFM     FILE(MXDEDLPD) MBR(LDNI)
             CLRPFM     FILE(MXDEDLPD) MBR(NASP)
             CLRPFM     FILE(MXDEDLPD) MBR(NASS)
             CLRPFM     FILE(MXDEDLPD) MBR(FRAS)
             CLRPFM     FILE(MXDEDLPD) MBR(SIRS)
             CLRPFM     FILE(MXDEDLPD) MBR(CIRS)
             CLRPFM     FILE(MXDEDLPD) MBR(CFCO)
 
             CALL       PGM(MXDEEXDL) PARM(&RTCD &ERMS)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0505 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY WNCPYSRC,MXC0505MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,MXC0505ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0505 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,MXC0505END                                          */
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
