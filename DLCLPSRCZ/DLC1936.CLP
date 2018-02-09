/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL IR Swap Rates List')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - FRA/IRS Module                                      */
/*                                                                   */
/*       DLC1936 - SWAP RATES LIST                                   */
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
/*       Prev Amend No. CIR001             Date 13Jun95              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*    CIR001 - Interest Rate Calendars                               */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&SEQ &LVL &ENT)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/**/
/* Monitor for any errors and send appropriate message to MOPERQ */
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
             SNDMSG     MSG('DLC1936 - Swap Rates List') +
                        TOMSGQ(MRUNQ)
/**/
/* Call the Swap Rates List program */
             CALL       PGM(DL1936) PARM(&SEQ)
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
 ERROR:
             SNDMSG     MSG('Swap Rates List has terminated +
                          abnormally.') TOMSGQ(MOPERQ MRUNQ)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
 END:        ENDPGM
