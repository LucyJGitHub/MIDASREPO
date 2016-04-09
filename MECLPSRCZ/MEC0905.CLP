/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MG MT970 Last deal No')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - ME Module                                           */
/*                                                                   */
/*       CLP/MEC0905 - Midas ME MT970 Last Deal No.                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSW099  *CREATE    Date 28Feb05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSW099 - Creation of MT970 Netting Statements               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&LBRCA &LCNUM &LCCY &LACOD &LACSQ +
                          &WVDTE &W0DLNO)
 
/* Declare variables                                                 */
             DCL        VAR(&LBRCA)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&LCNUM)  TYPE(*DEC ) LEN(6)
             DCL        VAR(&LCCY )  TYPE(*CHAR) LEN(3)
             DCL        VAR(&LACOD)  TYPE(*DEC ) LEN(10)
             DCL        VAR(&LACSQ)  TYPE(*DEC ) LEN(2)
             DCL        VAR(&WVDTE)  TYPE(*DEC ) LEN(5)
             DCL        VAR(&W0DLNO) TYPE(*DEC ) LEN(6)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
/* Global monitor message                                            */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*********************************************************************/
/* Utility program                                                   */
/*********************************************************************/
 
             OVRDBF     FILE(RSACMTL1) SHARE(*NO)
             OVRDBF     FILE(DEALSALL) SHARE(*NO)
 
             CALL       PGM(ME0905) PARM(&LBRCA &LCNUM &LCCY &LACOD +
                          &LACSQ &WVDTE &W0DLNO)
 
             DLTOVR     FILE(RSACMTL1)
             DLTOVR     FILE(DEALSALL)
 
/*********************************************************************/
/* Database error processing                                         */
/*********************************************************************/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
/* Abnormal termination                                              */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          ME0905 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd.')
 
             ENDPGM
