/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF I/c initial margin recon. report')           */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC1440  -  INITIAL MARGIN RECONCILIATION REPORT - INPUT CYCLE  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   LAST AMEND NO. FUJI-FF0021        DATE 28AUG92                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   FUJI-FF0021 - NEW INITIAL MARGIN RECONCILIATION REPORT          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
/**/
/*   DECLARE VARIABLES                                              */
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
/**/
/*  CALL REPORT PROGRAM                                              */
/**/
             IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                        THEN(DO)
/**/
 
               OVRDBF     FILE(POSTNC5) MBR(*FIRST) POSITION(*KEY 1 +
                          POSTNCDF &RENT)
/**/
               OPNDBF     FILE(POSTNC5) OPTION(*ALL)
               MONMSG     MSGID(CPF0000) EXEC(DO)
/**/
                 DLTOVR     FILE(POSTNC5)
/**/
               ENDDO
             ENDDO
/**/
             CALL       PGM(FF1440) PARM(&RSEQ &RENT)
             IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
             THEN(DO)
                         DLTOVR     FILE(POSTNC5)
                         MONMSG MSGID(CPF9841)
             ENDDO
             RCLRSC
/*                                                                 */
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND     */
/* MESSAGE TO MOPERQ AND MRUNQ.                                    */
/*                                                                 */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MRUNQ MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
/*                                                                 */
             GOTO       CMDLBL(END)
/**/
/*   ERROR PROCESSING IF PROGRAM FAILS                             */
/**/
 ABNOR:      SNDPGMMSG  MSG('FFC1440 - Initial Margin Reconciliation +
                          Report ended abnormally') TOMSGQ(MRUNQ +
                          MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
/**/
/* DELETE FILE OVERRIDES */
/**/
END:         DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
             ENDPGM
