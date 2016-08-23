/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Instrument Holdings Enquiry')                */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC0302  -  INSTRUMENT HOLDINGS ENQUIRY CL CONTROL PGM          */
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
/*   Last Amend No. 163444             DATE 07OCT99                  */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   Prev Amend No. S01117             DATE 03MAY90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   163444 - Add Century field                                      */
/*   S01117  -  MULTIBRANCHING                                       */
/*                                                                   */
/*********************************************************************/
             PGM
/*                                                                  */
/* DECLARE VARIABLES                                                */
/*                                                                  */
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                  */
/* Global monitor message                                           */
/*                                                                  */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/*                                                                  */
/* Set all switches to off                                          */
/*                                                                  */
             CHGJOB SWS(00000000)
/*                                                                  */
/* Call INSTRUMENT HOLDING ENQUIRY PROGRAM FF0730                   */
/*                                                                  */
             OVRDBF     FILE(POSTNC3) TOFILE(POSTNL3)                  /*163444*/
             OVRDBF     FILE(POSTNK2) TOFILE(POSTNL4)                  /*163444*/
/**/
             CALL       PGM(FF0730)
/*                                                                  */
/* Check that no database error occured on previous program         */
/*                                                                  */
             IF  (%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/*                                                                  */
             GOTO END
/*                                                                  */
/*     Database error processing. Send message to MOPERQ & WORKSTN  */
/*                                                                  */
 DBERR:
/*********** RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)          */ /*S01117*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO END
/*                                                                  */
/*     Abnormal error processing. Message to MOPERQ & WORKSTN       */
/*                                                                  */
 ABNOR:      SNDPGMMSG  MSG('FFC0302 - INSTRUMENT HOLDINGS ENQUIRY +
                        ENDED ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     INQMSGRPY(*RQD) SWS(XXXXXXX1)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*                                                                  */
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
/*                                                                  */
