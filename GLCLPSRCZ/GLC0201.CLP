/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('WHT not in base ccy report - COB')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC0201 - Interest Tax not in Base Ccy Report (COB)         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2006           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CDL013  *CREATE    Date 08Jun06              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CDL013 - Tiered Withholding Tax                             */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5) VALUE(' ')
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1) VALUE('S')
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3) VALUE('ALL')
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2006')
/**/
             SNDMSG     MSG('GLC0201 - Interest not in Base Currency +
                          Report') TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(00000000)
/**/
             CALL       PGM(GL0201) PARM(&RSEQ &RLEV &RENT)
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                  RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
 
