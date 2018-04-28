/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME Network Account Description Report')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Messages Management Module                          */
/*                                                                   */
/*       MEC0022P - Midas ME Network Account Description Report      */
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
 
             PGM        PARM(&LISTMODE &SEQUENCE &LEVEL &ENTITY)
 
             DCL        VAR(&LISTMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SEQUENCE) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LEVEL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENTITY) TYPE(*CHAR) LEN(3)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
/** Global monitor for untrapped errors **/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
/** Initialisations **/
             CHGJOB     SWS(XXXXXX00)
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
               MONMSG     MSGID(CPF1023)
 
/** Call the reporting program **/
 
             CALL       PGM(ME002203) PARM(&ListMode &Sequence &Level &Entity)
 
/** Database error handling   **/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/** Abnormal termination **/
 
 ABNOR:      SNDPGMMSG  MSG('MEC0022P - Network Accounts Decription +
                          Report: ** terminated abnormally **') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/** Normal termination **/
 
 END:        RCLRSC
             RCLACTGRP  ACTGRP(QILE)
             MONMSG     MSGID(CPF1653)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             RETURN
             ENDPGM
