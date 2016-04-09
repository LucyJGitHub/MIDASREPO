/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Batch Postings to Comp Sus. A/C report')     */
/*********************************************************************/
/*                                                                   */
/*  Midas   General Ledger Module                                    */
/*                                                                   */
/*  GLC0280 - BATCH POSTINGS DIVERTED TO COMPUTER SUSPENSE ACCOUNT   */
/*            REPORT.                                                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CEU013  *CREATE    Date 29APR98              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*  CEU013 - EMU Account Postings Narrative                          */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RTCD)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&RSEQ)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CNAME) TYPE(*CHAR) LEN(10) +
                          VALUE('GLC0280')
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0) +
                          VALUE(X'00001F')
             DCL        VAR(&CSEQC) TYPE(*CHAR) LEN(5)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
             SNDPGMMSG  MSG('GLC0280 - Batch Postings diverted to +
                          Computer Suspense Account Report') +
                          TOMSGQ(MRUNQ)
/**/
/*   Create Local Data Area                                          */
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local Data Area')
             MONMSG     MSGID(CPF0000)
/**/
/* Set-off Database Error Switches */
/**/
             CHGJOB     SWS(00000000)
 
/* Read COB components file to check the restart status */
 
             CALL       PGM(CB0160) PARM(&CNAME &CSEQ &STAT)
 
/* Check if any problems with COB components file */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Set restart status to 'Y' */
 
             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STAT)
/**/
/*  Run report */
/**/
             CHGVAR     VAR(&RTCD) VALUE(' ')
             CALL       PGM(GL0280) PARM(&RTCD &RSEQ &RLEV &RENT)
/**/
/*  If no errors, exit */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(END))
/**/
/*  Database error */
/**/
 ABNOR:      SNDPGMMSG  MSG('JOB TERMINATED - DATABASE IN ERROR +
                          -GL0280') TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
END:         ENDPGM
