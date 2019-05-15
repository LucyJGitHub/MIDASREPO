/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Settlement allocations batch update')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC2240 - Settlement Allocations Batch Update               */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CLE038             Date 20May04              */
/*                      CLE034 *C *CREATE  Date 05May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE038 - Lending Enhancement for Nordea: Allocation by Amt  */
/*       CLE034 - Lending Enhancements.                              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE &PINPP &POUTP &TSTMP)
 
 
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
/**********  DCL        VAR(&PINPP) TYPE(*CHAR) LEN(877)             */                   /*CLE038*/
             DCL        VAR(&PINPP) TYPE(*CHAR) LEN(910)                                  /*CLE038*/
             DCL        VAR(&POUTP) TYPE(*CHAR) LEN(226)
             DCL        VAR(&TSTMP) TYPE(*CHAR) LEN(26)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
 
             CALL       PGM(LE2240) PARM(&MODE &PINPP &POUTP &TSTMP)
 
             GOTO       CMDLBL(ENDPGM)
 
 ABNOR:
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          LEC2240 ended abnormally - see job +
                          log') TOMSGQ(MOPERQ)
 
 /* End program */
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
 
             ENDPGM
