/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MR Write Average Balances')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - MidasPlus Reporting Module                          */
/*                                                                   */
/*       MRC0030 - Write Average Balances                            */
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
             PGM        PARM(&CAFI &AUDIT)
             DCL        VAR(&CAFI)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&AUDIT)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('MRC0030 - Write Average Balances') +
                          TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(00000000)
 
             OVRDBF     FILE(MRPOSTXL1)  SEQONLY(*YES 1000)
             OVRDBF     FILE(MRPOSTXL2)  SEQONLY(*YES 1000)
 
             IF         COND(&CAFI = 'C') THEN(DO)
             OVRDBF     FILE(MRHIBLL1) MBR(CAL) SEQONLY(*YES 1000)
             OVRDBF     FILE(MRHIBLL2) MBR(CAL) SEQONLY(*YES 1000)
             OVRDBF     FILE(MRHIBLL3) MBR(CAL) SEQONLY(*YES 1000)
             OVRDBF     FILE(MRHIBLL4) MBR(CAL) SEQONLY(*YES 1000)
             OVRDBF     FILE(MRAVBLPD) MBR(CAL) SEQONLY(*YES 1000)
             OVRDBF     FILE(MRAVBAPD) MBR(CAL) SEQONLY(*YES 1000)
             CLRPFM     FILE(MRAVBLPD) MBR(CAL)
             CLRPFM     FILE(MRAVBAPD) MBR(CAL)
             ENDDO
 
             IF         COND(&CAFI = 'F') THEN(DO)
             OVRDBF     FILE(MRHIBLL1) MBR(FIN) SEQONLY(*YES 1000)
             OVRDBF     FILE(MRHIBLL2) MBR(FIN) SEQONLY(*YES 1000)
             OVRDBF     FILE(MRHIBLL3) MBR(FIN) SEQONLY(*YES 1000)
             OVRDBF     FILE(MRHIBLL4) MBR(FIN) SEQONLY(*YES 1000)
             OVRDBF     FILE(MRAVBLPD) MBR(FIN) SEQONLY(*YES 1000)
             OVRDBF     FILE(MRAVBAPD) MBR(FIN) SEQONLY(*YES 1000)
             CLRPFM     FILE(MRAVBLPD) MBR(FIN)
             CLRPFM     FILE(MRAVBAPD) MBR(FIN)
             ENDDO
 
/**********  IF         COND(&CAFI**= 'C' *AND &CAFI**= 'F') THEN(DO)                 */ /*BG18886*/
             IF         COND(&CAFI *NE 'C' *AND &CAFI *NE 'F') THEN(DO)                  /*BG18886*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             IF         COND(&CAFI = 'C') THEN(DO)
             CALL       PGM(MR000030) PARM(&CAFI &AUDIT)
             CALL       PGM(MR000031) PARM(&CAFI &AUDIT)
             CALL       PGM(MR000032) PARM(&CAFI &AUDIT)
             CALL       PGM(MR000033) PARM(&CAFI &AUDIT)
             ENDDO
 
             IF         COND(&CAFI = 'F') THEN(DO)
             CALL       PGM(MR000035) PARM(&CAFI &AUDIT)
             CALL       PGM(MR000036) PARM(&CAFI &AUDIT)
             CALL       PGM(MR000037) PARM(&CAFI &AUDIT)
             CALL       PGM(MR000038) PARM(&CAFI &AUDIT)
             ENDDO
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(ENDP)
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MRC0030 ended abnormally - see job log') +
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
