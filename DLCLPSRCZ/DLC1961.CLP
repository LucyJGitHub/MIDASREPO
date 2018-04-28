/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL MM Discount Factors Report Control')         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - FRA/IRS Module                              */
/*                                                                   */
/*       DLC1961 - MM RATES AND DISCOUNT FACTORS REPORT CONTROL      */
/*                                                                   */
/*       Function: This Program will be submitted to Batch by RCF    */
/*         (I/C)   via MITEMDD. It is available On Request during    */
/*         (COB)   Input Cycle and Close of Business.                */
/*                                                                   */
/*       Calls: DL1961 - MM Rates and Discount Factor Report         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01328             DATE 07FEB91              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01328 - FRA/IRS Revaluations - New Program.                */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&SEQ &LVL &ENT &RPARM)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&CCY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/**/
/* Monitor for any errors and send appropriate message to MOPERQ */
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
/**/
/*  Extract the selected Currency from &RPARM (set up by RCF). */
/*  If 'ALL' Currencies were selected then &RPARM will have a value  */
/*  of asterisks to avoid &RPARM being blank. Convert this to blanks */
/*  before calling RPG program.                                      */
 
             CHGVAR     VAR(&CCY) VALUE(%SST(&RPARM 1 3))
             IF         COND(&CCY = '***') THEN(CHGVAR VAR(&CCY) +
                        VALUE('   '))
/**/
/*  Call MM Rates and Discount Factors Report program. */
             SNDMSG     MSG('DLC1961 - MM Rates and Discount Factors +
                          Report') TOMSGQ(MRUNQ)
             CALL       PGM(DL1961) PARM(&SEQ &CCY)
/**/
/* Monitor for database error and send appropriate message to MOPERQ */
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOMSGQ(MOPERQ MRUNQ)
                 GOTO       CMDLBL(ERROR)
               ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
 ERROR:      SNDMSG     MSG('MM Rates and Discount Factors Report +
                          has terminated abnormally.') +
                          TOMSGQ(MOPERQ MRUNQ)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
 END:        ENDPGM
