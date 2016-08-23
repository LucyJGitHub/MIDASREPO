/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Portfolio Lending Collateral List.')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Lending Module                        */
/*                                                                   */
/*       LBC0920 - Lombard Credit Collateral List.                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01498 *CREATE     DATE 11AUG94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01498 - Portfolio Management Upgrade to Release 10.        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&RSEQ &RLVL &RENT)
 
/* DECLARE VARIABLES */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
 
/* GLOBAL ERROR TRAP                                                 */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('LBC0920 - Lombard Credit Collateral +
                          List') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* CREATE LDA IF NOT PRESENT */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/* CALL PROGRAM */
             CALL    PGM(LB0920) PARM(&RSEQ &RLVL &RENT)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
 
             SNDPGMMSG  MSGID(DBM0001) MSGF(LBUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)
 
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
 
             SNDPGMMSG  MSGID(PEM0002) MSGF(LBUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)
 
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             SNDMSG     MSG('LBC0920 ended abnormally') TOUSR(*SYSOPR)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
