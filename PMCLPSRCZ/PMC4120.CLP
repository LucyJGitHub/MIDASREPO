/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Portfolio reconciliation reports prompt')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                         */
/*                                                                   */
/*       PMC4120 - PORTFOLIO RECONCILIATION REPORTS PROMPT           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. 094894 *CREATE     DATE 25OCT95              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       094894 - Deliver missing program                            */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
 
/* Global Monitor Message                                            */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             CHGJOB     SWS(00000000)
 
/* Call Portfolio Reconciliation Reoirts prompt program              */
 
             CALL       PGM(PM4120) PARM(&RSEQ &RLEV &RENT &RPARM +
                          &RACT &RCMD)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)    +
                              TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('PMC4120 +
                          - Portfolio Reconciliation Reports prompt +
                          program terminated abnormally - see job +
                          log') TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
