/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Network description - caller')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       CLP/SDC2001 - Midas SD Network Description - Caller         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CGL013  *CREATE    Date 27Mar02              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CGL013 - MT94x Messages Generation                          */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RTCD &MODE)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
             CHGJOB SWS(XXXXXX00)
             CHGVAR VAR(&Pgm) VALUE(' ')
 
             IF         COND(&MODE = 'M') THEN(CHGVAR VAR(&PGM) +
                          VALUE('SD200100'))
 
             IF         COND(&MODE = 'E') THEN(CHGVAR VAR(&PGM) +
                          VALUE('SD200101'))
 
/** Call program & monitor for untrapped errors **/
 
             CALL       PGM(&PGM) PARM(' ')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
                SNDPGMMSG  MSG('Transaction Failed. Re-input necessary. +
                             Press Enter to Continue.') TOPGMQ(*EXT)
                GOTO       CMDLBL(END)
             ENDDO
 
/** Database error handling   **/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ROLLBACK
             MONMSG     MSGID(CPF0000)
             RCLRSC
             MONMSG     MSGID(CPF0000)
             RCLACTGRP  ACTGRP(QILE)
             MONMSG     MSGID(CPF1653)
             RETURN
             ENDPGM
