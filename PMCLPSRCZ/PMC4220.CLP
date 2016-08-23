/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Performance Events Details Mnt Audit Rpt')      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC4220 - PERFORMANCE EVENT DETAILS MAINTENANCE             */
/*                 AUDIT REPORT                                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01486             DATE 09NOV94              */
/*       PREV AMEND NO. 53103              DATE 11NOV93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*     S01486 - Portfolio Management Enhancement                     */
/*     53103  - CREATED FOR PERFORMANCE RECONCILIATION               */
/*                                                                   */
/*********************************************************************/
/************PGM                                                     * *S01486*/
             PGM        PARM(&RSEQ &RLVL &RENT)                       /*S01486*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01486*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01486*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01486*/
/**/
/* GLOBAL MONITOR MESSAGE                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ENDTAG))
             CHGJOB     SWS(00000000)
/**/
/* CALL AUDIT REPORT PROGRAM                                         */
/************CALL       PGM(PM4220)                                  * *S01486*/
             CALL       PGM(PM4220) PARM(&RSEQ)                       /*S01486*/
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/*               SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                     */ /*S01486*/
                 SNDPGMMSG  MSGID(PEM0001) MSGF(GBPMUSRMSG) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*S01486*/
                 ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
/*  ERROR IN CL PROGRAM  */
 ENDTAG:     DMPCLPGM
/*                                                                   */
/* END:         ENDPGM                                             */ /*S01486*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01486*/
