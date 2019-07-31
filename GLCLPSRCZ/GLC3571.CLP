/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Account Details Audit report')               */
/*********************************************************************/
/*                                                                   */
/*       Midas       General Ledger Module                       */
/*                                                                   */
/*       GLC3571 - ACCOUNT DETAILS REPORT  - AUDIT MODE              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD039072           Date 25Jul16              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01413 *C *CREATE  Date 13Apr93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD039072 - GL3572AU is empty and no GL03572P1 report when   */
/*                  called from GLC3571. Change overrides to ACCBA   */
/*                  because SADETA is always empty. Filter in GL3572.*/
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&RSEQ)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3) VALUE('ALL')
/*/COPY WNCPYSRC,GLC3571001                                          */
/**/
             SNDPGMMSG  MSG('GLC3571 - Account Details Audit List') +
                        TOMSGQ(MRUNQ)
             CHGJOB     SWS(10000000)
/**********  OVRDBF     FILE(SADET) TOFILE(SADETA) SEQONLY(*YES 100)                 */ /*MD039072*/
             OVRDBF     FILE(SADET) TOFILE(ACCBA) SEQONLY(*YES 100)                     /*MD039072*/
/*/COPY WNCPYSRC,GLC3571002                                          */
/**/
/*  Run report */
/**/
             CALL       PGM(GL3572) PARM(&RSEQ &RENT)
/**/
             DLTOVR     FILE(SADET)
/*/COPY WNCPYSRC,GLC3571003                                          */
/**/
/*  If no errors, exit */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(END))
/**/
/*  Database error */
/**/
             SNDPGMMSG  MSG('JOB TERMINATED - DATABASE IN ERROR -+
                        GL3572') TOMSGQ(MRUNQ)
             SNDPGMMSG  MSG('JOB TERMINATED - DATABASE IN ERROR -+
                        GL3572') TOMSGQ(MOPERQ)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
END:         ENDPGM
