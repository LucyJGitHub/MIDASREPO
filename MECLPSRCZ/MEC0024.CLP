/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME MT941/942 Generation Schedules - Caller')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Messages Management Module                          */
/*                                                                   */
/*       MEC0024 - Midas ME MT941/942 Generation Schedules - Caller  */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGL013  *CREATE    Date 07May02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL013 - MT94x Messages Generation                          */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RTCD &MODE)
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
             CHGJOB SWS(XXXXXX00)
             CHGVAR     VAR(&PGM) VALUE(' ')
 
             IF         COND(&MODE = 'M') THEN(CHGVAR VAR(&PGM) +
                          VALUE('ME002400'))
 
             IF         COND(&MODE = 'E') THEN(CHGVAR VAR(&PGM) +
                          VALUE('ME002401'))
 
/** Call program & monitor for untrapped errors **/
 
             CALL       PGM(&PGM) PARM(' ')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
                SNDPGMMSG  MSG('Transaction Failed. Re-input necessary. +
                             Press Enter to Continue.') TOPGMQ(*EXT)
                ROLLBACK
                GOTO       CMDLBL(END)
             ENDDO
 
/** Database error handling   **/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                ROLLBACK
             ENDDO
 
 END:        RCLRSC
             RCLACTGRP  ACTGRP(QILE)
             MONMSG     MSGID(CPF1653)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             RETURN
             ENDPGM
