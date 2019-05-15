/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL FRA Revaluation Rep - Ccy/Bk Prompt')        */
/*********************************************************************/
/*                                                                   */
/*       Midas     - FRA/IRS Module                              */
/*                                                                   */
/*       DLC1953F - FRA REVALUATION REPORT - Currency/Book Prompt    */
/*                                                                   */
/*       Function: This Program controls the Input Parameter to the  */
/*         (I/C)   Prompt Program DL1953. If this program has been   */
/*                 called, it means that the menu option for the FRA */
/*                 Revaluation Report has been requested, so DL1953  */
/*                 is called with parameter, PMODE = 'F'.            */
/*                                                                   */
/*       This program is very similar to DLC1953S and DLC1953X.      */
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
/*       Prev Amend No. S01328             Date 20Jun91              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01328 - FRA/IRS Revaluations - New Program.                */
/*                                                                  */
/********************************************************************/
/**/
             PGM        PARM(&SEQ &LVL &ENT &RPARM &RACT &RCMD)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)
/**/
/* Monitor for any errors and send appropriate message to MOPERQ */
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
/**/
/* Call the FRA Revaluation Report Currency/Book Prompt in Mode F */
/* (&RPARM receives back the selection made) */
             CALL       PGM(DL1953) PARM('F' &RPARM &RCMD)
/**/
/* Monitor for database error and send appropriate message to MOPERQ */
/* (no LDA set up for DL1953 since all errors handled by Access */
/* Programs - therefore do not check here) */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               GOTO       CMDLBL(ERROR)
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
 ERROR:      SNDMSG     MSG('FRA Revaluation Report Currency/Book +
                          Prompt has terminated abnormally.') +
                          TOMSGQ(MOPERQ)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 END:        ENDPGM
