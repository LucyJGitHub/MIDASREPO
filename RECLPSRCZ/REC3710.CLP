/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Retail overdraft line maturity report')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC3710 - Overdraft Line Maturity Report                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CRE001 *CREATE     Date 18Feb97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRE001 - Overdraft Interest Calculations.                   */
/*                                                                   */
/*********************************************************************/
             PGM     PARM(&SEQ &LEV &ENT)
 
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
/**/
 
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
 
/* Reset Switches */
             CHGJOB     SWS(XXXXXX00)
             SNDPGMMSG  MSG('REC3710 - Overdraft Line Maturity +
                          Report') TOMSGQ(MRUNQ)
 
/* Report */
             CALL       PGM(RE3710) PARM(&LEV &SEQ)
             IF COND(%SWITCH(XXXXXX00)) THEN(GOTO FINISH)
 
/* Error */
ABNOR:          RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(REUSRMSG) MSGDTA(&MEM)   +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
                SNDPGMMSG MSG('RE3710 - JOB TERMINATED - DATABASE +
                               IN ERROR') TOPGMQ(*EXT)
             CHGJOB     SWS(XXXXXX11)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
FINISH:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
