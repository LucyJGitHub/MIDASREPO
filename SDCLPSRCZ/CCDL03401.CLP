/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Initialisation program for CDL034')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       CCDL03401- Initialisation program for CDL034                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CDL034  *CREATE    Date 15Apr05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CDL034 - Back-value base rate changes                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)
 
             DCLF       FILE(SDBANKPD)
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7) VALUE('  DMLIB')
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&VALUE) TYPE(*CHAR) LEN(5)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
  /* Get system date from SDBANKPD */
             RCVF       RCDFMT(SDBANKD0)
             CHGVAR     VAR(&VALUE) VALUE(&BJRDNB)
 
  /* Get system prefix */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(%SUBSTRING(&DMLIB 1 2)) VALUE(&SYSID)
 
/* Mode 1 - First call */
 
             IF         COND(&PMODE *EQ '1') THEN(DO)
             CHGDTAARA  DTAARA(&DMLIB/CDL034 (1 5)) VALUE(&BJRDNB)
             MONMSG     CPF0000
             CALL       PGM(INZDLDIRH)
             ENDDO
 
/* Mode 2 - Second call */
 
             IF         COND(&PMODE *EQ '2') THEN(DO)
             ENDDO
 
/* Mode 3 - Deletion */
 
             IF         COND(&PMODE *EQ '3') THEN(DO)
             ENDDO
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination */
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             CHGVAR     VAR(&RTCDE) VALUE('*ERROR')
 
/* Send the error message */
 
             SNDPGMMSG  MSG('Program CCDL03401 ended abnormally') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/* End program */
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
