/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FD MM Interest Rates File List Control')        */
/********************************************************************/
/*                                                                  */
/*  Midas - Standing Data Module                            */
/*                                                                  */
/*  FDC0560 - MM Rates File List Control                            */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01328             Date 20Mar91              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*  S01328 - FRA/IRS Revaluations - New Program written to replace  */
/*           the call to FD0560 in FDC0040 - this needed to allow   */
/*           for RCF parameters used in R10.                        */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&TYPE &SEQ &LVL &ENT)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/**/
/* Monitor for any errors and send appropriate message to MOPERQ */
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
/**/
/* Call the MM Interest Rates File List program */
             CALL       PGM(FD0560) PARM(&SEQ &TYPE)
/**/
/* Monitor for File Controls out of Balance and send appropriate */
/* message to MOPERQ */
             IF         COND(%SWITCH(XXXXXX01)) THEN(SNDMSG +
                          MSG('FDC0560 - File Controls out of +
                          Balance') TOMSGQ(MOPERQ))
/**/
/* Monitor for database error and send appropriate message to MOPERQ */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
 ERROR:      SNDMSG     MSG('MM Interest Rates File List has +
                          terminated abnormally.') TOMSGQ(MOPERQ)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 END:        ENDPGM
