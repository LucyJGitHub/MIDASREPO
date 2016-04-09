/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Position Settlement Default Charges')        */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC8360 -  POSITION SETTLEMENT DEFAULT CHARGES              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01519 *CREATE     DATE 10AUG94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01519 - Position Settlement Automatic Charges              */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&PARM &RSEQ &RLEV &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
 
/* Global monitor message error trap                                 */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000 CPA0000) +
                          EXEC(GOTO CMDLBL(MONTAG))
 
             GOTO       CMDLBL(RUN)
 
 MONTAG:     DMPCLPGM
             RCLRSC
             RETURN
 
/* Reset external switches                                           */
 
 RUN:        CHGJOB     SWS(XXXXXX00)
             CALL       PGM(SE8360) PARM(&PARM &RSEQ)
 
/* Data base error processing                                        */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(DBM0001) MSGF(GBSEUSRMSG) MSGDTA(&MEM) +
                                       TOMSGQ(MOPERQ MRUNQ)
             ENDDO
 
 ENDPGM:     RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
