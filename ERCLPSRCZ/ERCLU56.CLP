/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ER LU Investment Company Codes Report')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module                           */
/*                                                                   */
/*       ERCLU56 - Investment Company Codes Report                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. ULX008  *CREATE    Date 22Feb00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX008 - CSSF Statutory Reporting : Commisariat aux Bourses */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
 
/* Declare variables */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000 MCH0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
/* Check if feature ULX008 is installed */
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE(*VERIFY)
             CHGVAR     VAR(&SARD) VALUE(ULX008)
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)
             IF         COND(&RTCD *NE '       ') THEN(GOTO +
                          CMDLBL(ENDPGM))
 
/* Call program */
             CHGJOB     SWS(00000000)
             CALL       PGM(ERLU56) PARM(&RSEQ)
 
/* Database error */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
/* Send Message to User alerting failure */
 ABNOR:      SNDPGMMSG  MSG('ERCLU56 ENDED ABNORMALLY') TOMSGQ(MRUNQ +
                          MOPERQ)
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX11)
             DMPCLPGM
 
 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd. 2005')
             ENDPGM
