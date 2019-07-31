/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL FRA/IRS Rates File List Control')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - FRA/IRS Module                              */
/*                                                                   */
/*       DLC1932 - FRA/IRS RATES FILE LIST                           */
/*                                                                   */
/*       Function: This Report is available On Request. It can be    */
/*         (I/C)   selected by a particular Currency or by ALL       */
/*         (COB)   Currencies.                                       */
/*                                                                   */
/*       Calls: DL1932 - FRA/IRS Rates File List.                    */
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
/*       Prev Amend No. S01328             Date 08Mar91              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01328 - FRA/IRS Revaluations - New Program.                */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&MODE &TYPE &SEQ &LVL &ENT &RPARM)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(2)
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
/* Extract the Currency selected for this report */
             CHGVAR     VAR(&CCY) VALUE(%SST(&RPARM 1 3))
/**/
/* If 'ALL' Currencies selected then RPARM will have value set to */
/* asterisks to avoid RPARM being blank.  Convert to blanks before */
/* calling RPG program */
             CHGVAR     VAR(&CCY) VALUE(%SST(&RPARM 1 3))
             IF         COND(&CCY = '***') THEN(CHGVAR VAR(&CCY) +
                          VALUE('   '))
/**/
/***  If FRA Rates List required then override to DLFRARL4 */
             IF         COND(&MODE *EQ 'F') THEN(DO)
                  OVRDBF FILE(DLFIRSLL) TOFILE(DLFRARL4)
                  SNDMSG     MSG('DLC1932 - FRA Rates File List') +
                          TOMSGQ(MRUNQ)
             ENDDO
/**/
/***  Else IRS Rates List required, so override to DLIRSRL4 */
             ELSE       CMD(DO)
                  OVRDBF     FILE(DLFIRSLL) TOFILE(DLIRSRL4)
                  SNDMSG     MSG('DLC1932 - IRS Rates File List') +
                          TOMSGQ(MRUNQ)
             ENDDO
/**/
/* Call the FRA/IRS Rates File List program */
             CALL       PGM(DL1932) PARM(&SEQ &MODE &TYPE &CCY)
/**/
/* Monitor for File Controls out of Balance and send appropriate */
/* message to MOPERQ */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
               SNDMSG     MSG('DLC1932 - File Controls out of +
                          Balance') TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
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
 ERROR:      IF (&MODE *EQ 'F') +
             THEN(SNDMSG ('FRA Rates File List has terminated +
                           abnormally.') TOMSGQ(MOPERQ MRUNQ))
/**/
             ELSE (SNDMSG ('IRS Rates File List has terminated +
                            abnormally.') TOMSGQ(MOPERQ MRUNQ))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
 END:        ENDPGM
