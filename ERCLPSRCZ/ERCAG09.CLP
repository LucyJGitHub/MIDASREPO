/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AGDL Audit and Summary')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - AGDL reporting Module                               */
/*                                                                   */
/*       ERCAG09 - AGDL Audit and Summary Reports                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. 168723             Date 06Oct99              */
/*                      ULX010  *CREATE    Date 25Jun98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       168723 - Replace array by file to avoid more than 99999     */
/*                elements.                                          */
/*       ULX010 - AGDL reporting statistiques sur les dépôts garantis*/
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
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(75) +
                          VALUE('''ERAG09 - AGDL Audit and Summary')
 
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
 
             CLRPFM     FILE(AGREPTPP)                                    /*168723*/
/***  Call program  ***/
             STRCMTCTL  LCKLVL(*CHG)
             MONMSG     MSGID(CPF8351)
 
             CALL       PGM(ERAG09) PARM(&RSEQ)
             ENDCMTCTL
             CLRPFM     FILE(AGREPTPP)                                    /*168723*/
 
/***  Monitor for Database Errors (U7 and U8 on)  ***/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
/***  Program ended abnormally  ***/
 ABNOR:      SNDPGMMSG  MSG('ERCAG08 - AGDL Extract details +
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
