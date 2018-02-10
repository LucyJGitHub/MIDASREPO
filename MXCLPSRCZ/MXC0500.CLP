/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MX Daily Events Extract - GEN.LED. Module')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MXC0500 - Daily Events Extract - GENERAL LEDGER Module      */
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
             PGM        PARM(&EVTT)
 
/*/COPY WNCPYSRC,MXC0500INT                                          */
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(30)
             DCL        VAR(&EVTT) TYPE(*CHAR) LEN( 4)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
/*/COPY WNCPYSRC,MXC0500MPS                                          */
 
 
             IF         COND(&EVTT *EQ 'OPCL') THEN(DO)
 
             OVRDBF     FILE(MXDEGLPD) MBR(OPCL) SEQONLY(*YES 100)
 
             CLRPFM     FILE(MXDEGLPD) MBR(OPCL)
 
             ENDDO
 
             IF         COND(&EVTT *EQ 'POST') THEN(DO)
 
             OVRDBF     FILE(MXDEGLPD) MBR(POST) SEQONLY(*YES 100)
 
             CLRPFM     FILE(MXDEGLPD) MBR(POST)
 
             ENDDO
 
             IF         COND(&EVTT *EQ 'ACRE') THEN(DO)
 
/* Accruals to Retail Accounts Update */
 
             CALL       PGM(MXACREUPD) PARM(&RTCD &ERMS)
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0500 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
             OVRDBF     FILE(MXDEGLPD) MBR(ACRE) SEQONLY(*YES 100)
 
             CLRPFM     FILE(MXDEGLPD) MBR(ACRE)
 
             ENDDO
 
             IF         COND(&EVTT *EQ 'SOM ') THEN(DO)
 
             OVRDBF     FILE(MXDEGLPD) MBR(SOM ) SEQONLY(*YES 100)
 
             CLRPFM     FILE(MXDEGLPD) MBR(SOM )
 
             ENDDO
 
             CALL       PGM(MXDEEXGL) PARM(&RTCD &ERMS &EVTT)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0500 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY WNCPYSRC,MXC0500MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,MXC0500ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0500 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,MXC0500END                                          */
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
