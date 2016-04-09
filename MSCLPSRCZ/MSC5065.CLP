/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MS Logical acknowledgements report')            */
/*********************************************************************/
/*                                                                   */
/*     Midas - SWIFT DIRECT LINK                                     */
/*                                                                   */
/*     MSC5065 - LOGICAL ACKNOWLEDGEMENTS REPORT                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*        LAST AMEND.NO S01310             DATE 06DEC90              */
/*        PREV AMEND.NO 00                 DATE 00XXX00              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*     S01310 - SWIFT RATIONALISATION                                */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM******  PARM(&PARAM)                                  /*S01310*/
             PGM        PARM(&RSEQ &RLEV &RENT &PARAM)                /*S01310*/
 
/* Declare Perameters.                                               */
/************DCL******  VAR(&PARAM) TYPE(*CHAR) LEN(99)               /*S01310*/
             DCL        VAR(&PARAM) TYPE(*CHAR) LEN(22)               /*S01310*/
 
/* Declare Message Detail Field.                                     */
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01310*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01310*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01310*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*/COPY WNCPYSRC,MSC5065001                                          */
 
/* Global monitor message                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
/* Audit message to MRUNQ                                            */
             SNDPGMMSG  MSG('SWIFT Logical Acknowledgements Report - +
                          I/C') TOMSGQ(MRUNQ)
 
/* Set-off Data Base Error Switches.                                 */
             CHGJOB     SWS(XXXXXX00)
 
/* Create Local Data Area in QBATCH for Submitted Job.               */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*ALL)
             MONMSG     MSGID(CPF0000)                                /*S01310*/
 
/*/COPY WNCPYSRC,MSC5065002                                          */
/* Call Input Cycle Report Program With Required Perameters.         */
/************CALL*****  PGM(MS5065) PARM(&PARAM)                      /*S01310*/
             CALL       PGM(MS5065) PARM(&RSEQ &RLEV &RENT &PARAM)    /*S01310*/
/*/COPY WNCPYSRC,MSC5065003                                          */
 
/* For Database Errors Recover Data From Local Data Area, Send       */
/* Message to MOPERQ.                                                */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:      SNDPGMMSG  MSG('Logical Acknowledgements Report Program +
                          ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 END:        RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
