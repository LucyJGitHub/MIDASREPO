/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Transaction Income Splits Audit Report')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC0346 - Transaction Income Splits Audit Report            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CLE035  *CREATE    Date 22Sep03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CLE035 - Lending Enhancement for Nordea Phase 1 Priority 2  */
/*                Income Splits                                      */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Initialise job switches */
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             SNDPGMMSG  MSG('Midas Transaction Income Splits +
                          Report') TOPGMQ(*EXT) TOMSGQ(MRUNQ)
 
/* Call LE0345 */
 
             CALL       PGM(LE0345) PARM('     ' 'ALL' 'A' )
 
/* Database error processing */
 
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             IF         COND(%SWITCH(XXXXXX11)) THEN(SNDPGMMSG +
                           MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ))
 
             GOTO       CMDLBL(ENDPGM)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          LEC0346 ended abnormally - see job +
                          log') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 /* End program */
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
