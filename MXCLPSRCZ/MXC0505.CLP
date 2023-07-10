/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MX Daily Events Extract - DEALING Module')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MXC0505 - Daily Events Extract - DEALING Module             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD049139           Date 16Jun23              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CMX001  *CREATE    Data 01Jan00              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD049139 - Lending Fee are posting 1 day late for           */
/*                  auto settle fee on a calculated facility.        */
/*                - MD061267 - Credit Lines (CLE025) fixes           */
/*       MD046248 - Finastra Rebranding                              */
/*       CMX001 - Meridian Export                                    */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                     */                 /*MD049139*/
             PGM        PARM(&RUNCOND)                                                  /*MD049139*/

/*/COPY WNCPYSRC,MXC0505INT                                          */

             DCL        VAR(&RUNCOND) TYPE(*CHAR) LEN(6)                                /*MD049139*/
             DCL        VAR(&CLE025) TYPE(*CHAR) LEN(1) VALUE('N')                      /*MD049139*/
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

/** Determine if switchable feature CLE025 is switched ON then     */                   /*MD049139*/
/** check if program should run based on feature and parameter     */                   /*MD049139*/
                                                                                        /*MD049139*/
             RTVDTAARA  DTAARA(CLE025DTA) RTNVAR(&CLE025)                               /*MD049139*/
             IF         COND(((&CLE025 *EQ 'Y') *AND +
                              (&RUNCOND *EQ 'CLE025')) *OR +
                             ((&CLE025 *NE 'Y') *AND +
                              (&RUNCOND *NE 'CLE025'))) THEN(GOTO +
                        CMDLBL(END))                                                    /*MD049139*/
                                                                                        /*MD049139*/
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
                          Finastra International Limited')

/*/COPY WNCPYSRC,MXC0505END                                          */

             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)

             ENDPGM
