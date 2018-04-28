/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ER Decision Table - Transaction Types')         */
/*********************************************************************/
/*                                                                   */
/*       Midas¦ABS - European Reporting                              */
/*                                                                   */
/*       CLP/ERCLU45 - Decision Table - Transaction Types            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. 132893             Date 15Apr98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       132893 - SPF/RCF for IBLC/BNB on DBA2.3                     */
/*                                                                   */
/*********************************************************************/
 
/***  Start Program.  ***/
 
 START:      PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
/***  Declare parameter.  ***/
 
             DCL        VAR(&CTRY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
/***  Monitor for Error Messages from System.  ***/
 
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000 MCH0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
/***  Reset Error values - switches  ***/
 
             CHGJOB     SWS(XXXXXX00)
 
             CHGVAR     VAR(&CTRY) VALUE(%SST(&RPARM 1 2))
 
/***  Call program.  ***/
 
             CALL       PGM(ERLU45) PARM(&CTRY &RSEQ &RLEV)
 
/***  Monitor for Database Errors (U7 and U8 on).  ***/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
/***  Retrieve Error information and set Message data.  ***/
 
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
 
/***  Send Midas Error Message.  ***/
 
             SNDPGMMSG  MSGID(DBE0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)
 
             GOTO       CMDLBL(ENDPGM)
             ENDDO
 
 
             GOTO       CMDLBL(ENDPGM)
 
/***  Send Message to User alerting failure.  ***/
 
 ABNOR:      SNDPGMMSG  MSG('ERCLU45 - Decision Table - Transaction +
                          Types ended abnormally') TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000)
 
/***  Execute Dump CL program.  ***/
 
             DMPCLPGM
 
/***  End Program.  ***/
 
 ENDPGM:     MONMSG     MSGID(RPG0000 CPF0000 MCH0000)
 
             ENDPGM
