/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME Block release of outgoing messages')         */
/*********************************************************************/
/*                                                                   */
/*   Midas    MESSAGE MANAGEMENT                             */
/*                                                                   */
/*   MEC0620 - Outgoing messages block release                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   LAST AMEND NO.  00000            DATE 00XXX00                   */
/*   PREV AMEND NO.  00000            DATE 00XXX00                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &LVL &ENT &PRM)
 
             DCL VAR(&RSEQ)   TYPE(*CHAR) LEN(5)
             DCL VAR(&LVL)    TYPE(*CHAR) LEN(1)
             DCL VAR(&ENT)    TYPE(*CHAR) LEN(3)
             DCL VAR(&PRM)    TYPE(*CHAR) LEN(100)
             DCL VAR(&FILE)   TYPE(*CHAR) LEN(10)
             DCL VAR(&MEM)    TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERR)
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('Outgoing message block release - I/C') +
                          TOMSGQ(MRUNQ)
 
/* Set-off Data Base Error Switches. */
             CHGJOB     SWS(XXXXXX00)
 
/* Set up files for RPG program */
             CHGVAR     VAR(&FILE) VALUE(%SST(&PRM 1 10))
             OVRDBF     FILE(MGOREFLI) TOFILE(&FILE) SHARE(*NO)
             OVRDBF     FILE(MGOREFLU) TOFILE(&FILE) SHARE(*NO)
/*/COPY WNCPYSRC,MEC0620001                                          */
 
/* Call ME0620 (Outgoing message block release */
             CALL PGM(ME0620) PARM(&RSEQ &LVL &ENT &PRM)
/*/COPY WNCPYSRC,MEC0620002                                          */
 
/* If database error detected recover data from LDA and send message */
/* to MOPERQ.                                                        */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(+
             DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
/*/COPY WNCPYSRC,MEC0620003                                          */
             ENDDO
 
             GOTO END
 
 ERR:        SNDPGMMSG  MSG('Outgoing message block release ENDED +
                        ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)
/*/COPY WNCPYSRC,MEC0620004                                          */
 
 END:        RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
