/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MX Month-End Data Setup')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MXC0810 - Month-End Data Setup                              */
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
/*       Prev Amend No. 189208  *CREATE    Data 25Jan01              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       189208 - Consolidation of Loans & participations into 1 fmt */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,MXC0810INT                                          */
 
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
 
/*/COPY WNCPYSRC,MXC0810MPS                                          */
 
 
/* Set up Loans, Parts Purchased and Sold Consolidated Events & Bals */
 
             CLRPFM     FILE(MXDELELPD) MBR(CLZZ)
             CLRPFM     FILE(MXMELELPD) MBR(CLZZ)
             CLRPFM     FILE(MXBLLELPD) MBR(CLZZ)
 
             CPYF       FROMFILE(MXDELELPD) TOFILE(MXDELELPD) +
                          FROMMBR(CLLN) TOMBR(CLZZ) MBROPT(*ADD)
             CPYF       FROMFILE(MXDELELPD) TOFILE(MXDELELPD) +
                          FROMMBR(CLPS) TOMBR(CLZZ) MBROPT(*ADD)
 
             CPYF       FROMFILE(MXMELELPD) TOFILE(MXMELELPD) +
                          FROMMBR(CLLN) TOMBR(CLZZ) MBROPT(*ADD)
             CPYF       FROMFILE(MXMELELPD) TOFILE(MXMELELPD) +
                          FROMMBR(CLPS) TOMBR(CLZZ) MBROPT(*ADD)
 
             CPYF       FROMFILE(MXBLLELPD) TOFILE(MXBLLELPD) +
                          FROMMBR(CLLN) TOMBR(CLZZ) MBROPT(*ADD)
             CPYF       FROMFILE(MXBLLELPD) TOFILE(MXBLLELPD) +
                          FROMMBR(CLPS) TOMBR(CLZZ) MBROPT(*ADD)
 
 
/*/COPY WNCPYSRC,MXC0810MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,MXC0810ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0810 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,MXC0810END                                          */
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
