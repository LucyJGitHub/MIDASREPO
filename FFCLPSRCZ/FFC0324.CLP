/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF I/C Outstanding T/Bills by Broker')          */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC0324  -  OUTSTANDING TREASURY BILLS BY BROKER REPORT         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   LAST AMEND NO. FO0073             DATE 15APR91                  */
/*   PREV AMEND NO. FO0066             DATE 09APR91                  */
/*                  S01117             DATE 23MAR90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   FO0073  -  U7 + U8 SHOULD BE SET ON IN ABNOR PROCESSING, AND    */
/*              DB ERROR MESSAGES SHOULD BE SENT TO MRUNQ + MOPERQ.  */
/*   FO0066  -  SUBMITTED REPORT NEEDS TO CREATE AN LDA              */
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
             DCL        &RSEQ         TYPE(*CHAR)  LEN(5)             /*S01117*/
             DCL        &RLEV         TYPE(*CHAR)  LEN(1)             /*S01117*/
             DCL        &RENT         TYPE(*CHAR)  LEN(3)             /*S01117*/
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
             CHGJOB     SWS(00000000)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)        /*FO0066*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*FO0066*/
/**/
/*   CALL PROGRAM                                                  */
/**/
             IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                        THEN(DO)                                      /*S01117*/
                        OVRDBF FILE(DLSDD1) POSITION(*KEY 1 +
                        DEALSDDF &RENT)                               /*S01117*/
                        OPNDBF FILE(DLSDD1) OPTION(*ALL)              /*S01117*/
                        MONMSG MSGID(CPF0000) EXEC(DO)                /*S01117*/
                        DLTOVR FILE(DLSDD1)                           /*S01117*/
                        ENDDO                                         /*S01117*/
                        ENDDO                                         /*S01117*/
/*********** CALL       PGM(FF1030)                                */ /*S01117*/
             CALL       PGM(FF1030) PARM(&RSEQ &RENT)                 /*S01117*/
             IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                        THEN(DO)                                      /*S01117*/
                        DLTOVR FILE(DLSDD1)                           /*S01117*/
                        MONMSG MSGID(CPF9841)                         /*S01117*/
                        ENDDO                                         /*S01117*/
             RCLRSC                                                   /*S01117*/
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MRUNQ AND MOPERQ.                                    */ /*FO0073*/
/**MESSAGE*TO*MOPERQ*.****                                         */ /*FO0073*/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************    RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MRUNQ MOPERQ)                        /*FO0073*/
/************    SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) + /*FO0073*/
/************             TOMSGQ(MOPERQ)                           */ /*FO0073*/
             GOTO       CMDLBL(ABNOR)                                 /*FO0073*/
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
/*   ERROR PROCESSING IF PROGRAM FAILS                             */
/**/
/*BNOR:******SNDPGMMSG  MSG('FFC0324 OUTSTANDING TRADING BILLS BY +*/ /*FO0073*/
/************             BROKER LIST ENDED ABNORMALLY') TOPGMQ(*EXT) +*FO0073*/
/************             TOMSGQ(MOPERQ)                           */ /*FO0073*/
 ABNOR:      SNDPGMMSG  MSG('FFC0324 - OUTSTANDING TREASURY BILLS BY +
                          BROKER LIST ENDED ABNORMALLY') +
                          TOMSGQ(MRUNQ MOPERQ) /*FO0073*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)                                 /*FO0073*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
END:         ENDPGM
