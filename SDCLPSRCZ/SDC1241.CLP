/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Cashier Commission Code/Transaction Type Rpt Contl')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC1241 - Cashier Commission Code/Transaction Types         */
/*                 Report Control                                    */
/*                                                                   */
/*                 This report component calls program SD1241        */
/*                 during either Input Cycle or COB                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CRT012   *CREATE   Date 21Nov02              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRT012 - Midas/Cashier Interface - Multiple Charges         */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&MODE &RSEQ &RLVL &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
 
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/* Main Processing                                                   */
/**/
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/**/
/* Call program to produce report SD1241P1                           */
/**/
             CALL       PGM(*LIBL/SD1241) PARM(&RSEQ &MODE)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                             SD4710  ended abnormally - see job log') +
                             TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
