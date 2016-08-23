/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Request production of S352 statement')       */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                               */
/*                                                                   */
/*       REC2193  REQUEST PRODUCTION OF S352 STATEMENT               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 061966             DATE 23NOV93              */
/*       PREV AMEND NO. S01383             DATE 27APR92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       061966 - Chain to DEALS file fails when applying for S352   */
/*                for a historic deal. Override DEALS to DEALALL.    */
/*       S01383 - BASIC RATE TAX INCORPORATION                       */
/*                NEW PROGRAM                                        */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL VAR(&LDA) TYPE(*CHAR) LEN(256)
/**/
             CHGJOB     SWS(00000000)
             OVRDBF     FILE(DEALS) TOFILE(DEALALL)                  /*061966*/
/**/
             CALL PGM(RE2193)
/**/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                ROLLBACK
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)
                GOTO ENDPGM
             ENDDO
/**/
             IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
                RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT)
             ENDDO
/**/
             IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
                   CHGVAR VAR(&MSG) VALUE('JOB TERMINATED - DATABASE IN ERROR')
                   ROLLBACK
                   SNDPGMMSG MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                   SNDPGMMSG MSG(&MSG) TOPGMQ(*EXT) MSGTYPE(*INFO)
             ENDDO
/**/
 ENDPGM:     RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
