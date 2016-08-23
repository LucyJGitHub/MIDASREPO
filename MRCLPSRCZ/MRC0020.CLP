/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MR Write Historic Balances')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - MidasPlus Reporting Module                          */
/*                                                                   */
/*       MRC0020 - Write Historic Balances                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG18886            Date 28May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CMR001             Date 01Sep04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BG18886 - Amend non-standard codes.                         */
/*       CMR001 - MidasPlus Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CAFI)
             DCL        VAR(&CAFI) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('MRC0020 - Write Historic Balances') +
                          TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(00000000)
 
             OVRDBF     FILE(MRPOSTXL1) SEQONLY(*YES 2000)
             OVRDBF     FILE(MRPOSTXL2) SEQONLY(*YES 2000)
             OVRDBF     FILE(ACCBR)     SEQONLY(*YES 1000)
             OVRDBF     FILE(MRPCMXL1H) TOFILE(MRPCMXL1) MBR(HIST)
 
             IF         COND(&CAFI = 'C') THEN(DO)
             CLRPFM     FILE(MRHIBLPD) MBR(CAL)
             OVRDBF     FILE(MRHIBLPD) MBR(CAL) SEQONLY(*YES 2000)
             ENDDO
 
             IF         COND(&CAFI = 'F') THEN(DO)
             CLRPFM     FILE(MRHIBLPD) MBR(FIN)
             OVRDBF     FILE(MRHIBLPD) MBR(FIN) SEQONLY(*YES 2000)
             ENDDO
 
/**********  IF         COND(&CAFI *= 'C' *AND &CAFI *= 'F') THEN(DO)                 */ /*BG18886*/
             IF         COND(&CAFI *NE 'C' *AND &CAFI *NE 'F') THEN(DO)                  /*BG18886*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CALL       PGM(MR000020) PARM(&CAFI)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(ENDP)
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MRC0020 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 
ENDP:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
