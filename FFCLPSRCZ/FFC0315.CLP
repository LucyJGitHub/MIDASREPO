/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF I/C Trade No. Gaps List (Interim)')          */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC0315  -  TRADE NUMBER GAPS REPORT ( INTERIM )                */
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
/*   PREV AMEND NO. RT0121             DATE 23MAY91                  */
/*                  FO0073             DATE 15APR91                  */
/*                  FO0066             DATE 09APR91                  */
/*                  S01117             DATE 22APR90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   MD046248 - Finastra Rebranding                                  */
/*   RT0121  -  Monitor the creation of LDA to trap error            */
/*           -  lda already exists.                                  */
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
/*********** DCL        &MEM          TYPE(*CHAR)  LEN(44)         */ /*S01117*/
             DCL        &MEM          TYPE(*CHAR)  LEN(50)            /*S01117*/
             DCL        &RSEQ         TYPE(*CHAR)  LEN(5)             /*S01117*/
             DCL        &RLEV         TYPE(*CHAR)  LEN(1)             /*S01117*/
             DCL        &RENT         TYPE(*CHAR)  LEN(3)             /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
             CHGJOB     SWS(10000000)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)        /*FO0066*/
             MONMSG     MSGID(CPF1023)                                /*RT0121*/
/**/
/*   CALL PROGRAM                                                  */
/**/
/*********** CALL       PGM(FF1175)                                */ /*S01117*/
             CALL       PGM(FF1175) PARM(&RSEQ)                       /*S01117*/
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND     */
/* MESSAGE TO MRUNQ AND MOPERQ.                                    */ /*FO0073*/
/**MESSAGE*TO*MOPERQ*.****                                         */ /*FO0073*/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************    RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MRUNQ MOPERQ)                        /*FO0073*/
/************    SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +  *FO0073*/
/************             TOPGMQ(*EXT) TOMSGQ(MOPERQ)                  *FO0073*/
             GOTO       CMDLBL(ABNOR)                                 /*FO0073*/
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
/*   ERROR PROCESSING IF PROGRAM FAILS                             */
/**/
/*BNOR:******SNDPGMMSG  MSG('TRADE NUMBER GAPS REPORT (INTERIM) ENDED +*FO0073*/
/************             ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ) */ /*FO0073*/
 ABNOR:      SNDPGMMSG  MSG('FFC0315 - TRADE NUMBER GAPS REPORT +
                          (INTERIM) ENDED ABNORMALLY') TOMSGQ(MRUNQ +
                          MOPERQ)                                     /*FO0073*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)                                 /*FO0073*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
 END:        ENDPGM
