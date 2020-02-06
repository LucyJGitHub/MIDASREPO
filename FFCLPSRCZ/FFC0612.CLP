/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF F & O Client List (COB)')                    */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC0612  -  FO CLIENT LIST (COB)                                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   PREV AMEND NO. FO0075             DATE 17APR91                  */
/*                  FO0074             DATE 16APR91                  */
/*                  S01117             DATE 19FEB90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   MD046248 - Finastra Rebranding                                  */
/*   FO0075  -  MOVE COPYRIGHT STATEMENT                            */
/*   FO0074  -  ADD ABNOR PROCESSING                                 */
/*   S01117  -  MULTIBRANCHING                                       */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                   */ /*S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01117*/
/**/
/*   DECLARE VARIABLES                                              */
/**/
/*********** DCL        &MEM          TYPE(*CHAR)  LEN(44)         */ /*S01117*/
             DCL        &MEM          TYPE(*CHAR)  LEN(50)            /*S01117*/
             DCL        &RSEQ         TYPE(*CHAR)  LEN(5)             /*S01117*/
             DCL        &RLEV         TYPE(*CHAR)  LEN(1)             /*S01117*/
             DCL        &RENT         TYPE(*CHAR)  LEN(3)             /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*FO0074*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                        EXEC(GOTO ABNOR)                              /*FO0074*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
/*   SEND MESSAGE TO MSGQ/MRUNQ                                    */
/**/
             SNDPGMMSG  MSG('FFC0612 - Clients List') TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(00000000)
/**/
/*   CALL FF1120 - FO CLIENTS LIST                                  */
/**/
/*********** CALL       PGM(FF1120)   PARM('00000000')             */ /*S01117*/
             CALL       PGM(FF1120)   PARM('00000000' &RSEQ)          /*S01117*/
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ AND MRUNQ.                                     */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(ABNOR)                                 /*FO0074*/
             ENDDO
/**/
             GOTO       CMDLBL(END)                                   /*FO0074*/
/**/
 ABNOR:      SNDPGMMSG  MSG('FFC0612 - FO CLIENTS LIST (INTERIM) +
                          ENDED ABNORMALLY') TOMSGQ(MRUNQ MOPERQ) +
                                                                      /*FO0074*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*FO0074*/
             CHGJOB     SWS(XXXXXX11)                                 /*FO0074*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*FO0074*/
/*********** CHGVAR     VAR(&BISCPY) VALUE('COPYRIGHT MKI')        */ /*FO0075*/
/**/
 END:        ENDPGM                                                   /*FO0074*/
/*********** ENDPGM                                                */ /*FO0074*/
