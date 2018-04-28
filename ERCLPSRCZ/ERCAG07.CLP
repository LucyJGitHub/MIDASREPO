/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AGDL Customers list')                           */
/*********************************************************************/
/*                                                                   */
/*       Midas - AGDL reporting Module                               */
/*                                                                   */
/*       ERCAG07 - AGDL Customers  list                              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. ULX010  *CREATE    Date 09Apr98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX010 - AGDL reporting statistiques sur les d{pôts garantis*/
/*                                                                   */
/*********************************************************************/
             PGM PARM(&RSEQ &RLEV &RENT)
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
 
/*  Declare variables  */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(75) VALUE('ERAG07 +
                          - AGDL customers list')
 
/*  Global monitor message  */
 
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000 MCH0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
/*  Create Local Data Area  */
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/***  Reset external switches  ***/
 
             CHGJOB     SWS(XXXXXX00)
 
/***  Send message to program message queue  ***/
 
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
 
/***  Call program  ***/
             STRCMTCTL  LCKLVL(*CHG)
             MONMSG     MSGID(CPF8351)
 
             CALL       PGM(ERAG07) PARM(&RSEQ)
 
/***  Monitor for Database Errors (U7 and U8 on)  ***/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
/***  Retrieve Error information and set Message data  ***/
 
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
 
/***  Send Midas Error Message.  ***/
 
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
 
             GOTO       CMDLBL(ABNOR)
 
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
/***  Program ended abnormally  ***/
 
 ABNOR:      SNDPGMMSG  MSG('ERCAG07 - AGDL customers list +
                          abnormally terminated.') TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
             DMPCLPGM
 
/***  End Program  ***/
 
 ENDPGM:
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
