/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Prices list (cob)')                          */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC0620  -  PRICES LIST (COB)                                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 Patch D -------------------------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*   LAST AMEND NO. 163444             DATE 30SEP99                  */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   PREV AMEND NO. FO0075             DATE 17APR91                  */
/*                  FO0074             DATE 16APR91                  */
/*                  S01117             DATE 22FEB90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*   163444  -  Y2K SORT ORDER                                       */
/*   FO0075  -  MOVE COPYRIGHT STATEMENT                             */
/*   FO0074  -  ADD ABNOR PROCESSING                                 */
/*   S01117  -  MULTIBRANCHING                                       */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                   */ /*S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01117*/
/**/
/*   DECLARE VARIABLES                                              */
/**/
/*********** DCL        &MEM          TYPE(*CHAR)  LEN(44)         */ /*S01117*/
             DCL        &MEM          TYPE(*CHAR)  LEN(50)            /*S01117*/
             DCL        VAR(&SIX) TYPE(*DEC) LEN(1 0) VALUE(0)        /*163444*/
             DCL        VAR(&PMRKT)   TYPE(*CHAR)  LEN(2)
             DCL        &RSEQ         TYPE(*CHAR)  LEN(5)             /*S01117*/
             DCL        &RLEV         TYPE(*CHAR)  LEN(1)             /*S01117*/
             DCL        &RENT         TYPE(*CHAR)  LEN(3)             /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*FO0074*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                        EXEC(GOTO ABNOR)                              /*FO0074*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
/*   SEND MESSAGE TO MSGQ/MRUNQ                                    */
/**/
             SNDPGMMSG  MSG('FFC0620 - Prices List') TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(0X0XXX00)
/**/
/*   Create Y2K sort extract file                                  */ /*163444*/
/**/
 LOOP:       ALCOBJ     OBJ((FFPRICPD *FILE *EXCL))                   /*163444*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*163444*/
             RCVMSG     WAIT(60) RMV(*NO)                             /*163444*/
             CHGVAR     VAR(&SIX) VALUE(&SIX + 1)                     /*163444*/
             IF         COND(&SIX *LE 6) THEN(GOTO CMDLBL(LOOP))      /*163444*/
             ELSE       CMD(DO)                                       /*163444*/
             SNDPGMMSG  MSG('JOB CANNOT BE RUN AT THIS TIME') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*163444*/
             GOTO       CMDLBL(ENDLOOP)                               /*163444*/
             ENDDO                                                    /*163444*/
             ENDDO                                                    /*163444*/
             OPNQRYF    FILE((PRICS1         )) FORMAT(FFPRICPD) +
                          QRYSLT('YRNO *LE 72') MAPFLD((YRCC 'YRNO +
                          + 2000')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPRICPD) +
                          MBROPT(*REPLACE)                            /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
                                                                      /*163444*/
             OPNQRYF    FILE((PRICS1         )) FORMAT(FFPRICPD) +
                          QRYSLT('YRNO *GT 72') MAPFLD((YRCC 'YRNO +
                          + 1900')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPRICPD) +
                          MBROPT(*ADD)                                /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
/**/
/*   CALL FF1040 - PRICES LIST                                      */
/**/
             CHGVAR     VAR(&PMRKT) VALUE('  ')
/*********** CALL       PGM(FF1040) PARM(&PMRKT)                   */ /*S01117*/
             CALL       PGM(FF1040) PARM(&PMRKT &RSEQ)                /*S01117*/
             DLCOBJ     OBJ((FFPRICPD *FILE *EXCL))                   /*163444*/
ENDLOOP:                                                              /*163444*/
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
 ABNOR:      SNDPGMMSG  MSG('FFC0620 PRICES LIST ENDED ABNORMALLY') +
                          TOMSGQ(MRUNQ MOPERQ)                        /*FO0074*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*FO0074*/
             CHGJOB     SWS(XXXXXX11)                                 /*FO0074*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*FO0074*/
/*********** CHGVAR     VAR(&BISCPY) VALUE('COPYRIGHT MKI')        */ /*FO0075*/
/**/
 END:        ENDPGM                                                   /*FO0074*/
/*********** ENDPGM                                                */ /*FO0074*/
