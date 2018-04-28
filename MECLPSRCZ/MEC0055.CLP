/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME MT941/MT942 Production Monitor')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Messages Management Module                          */
/*                                                                   */
/*       MEC0055 - Midas ME MT941/MT942 Production Monitor           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CGL013  *CREATE   Date 07May02               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CGL013 - MT94x Messages Generation                          */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RTCD)
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
             CHGJOB SWS(XXXXXX00)
 
/** Call program & monitor for untrapped errors **/
             CALL       PGM(ME000055)
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
 
 END:        RCLRSC
             RCLACTGRP  ACTGRP(QILE)
             MONMSG     MSGID(CPF1653)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             RETURN
 ENDPGM
