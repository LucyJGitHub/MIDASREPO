/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Performance Event Details Maintenance')         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC4110 - PERFORMANCE EVENT DETAILS MAINTENANCE             */
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
/*       Prev Amend No. S01486             Date 30Nov94              */
/*                      73300              Date 08Sep94              */
/*                      53103              DATE  27OCT93             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01486 - Portfolio Management Upgrade to Release 10         */
/*       73300  - OVERRIDE TO INPUT FILE ADDED                       */
/*       53103  - PROGRAM CREATED FOR PERFORMANCE RECONCILIATION     */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
/**/
/* GLOBAL MONITOR MESSAGE                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ENDTAG))
             CHGJOB     SWS(00000000)
             OVRDBF     FILE(PMPEVTXX) TOFILE(PMPEVTLL)  SHARE(*NO)   /*73300 */
/**/
/* CALL MAINTENANCE PROGRAM                                          */
             CALL       PGM(PM4110)
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********     SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                     */ /*S01486*/
                 SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01486*/
                 ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
/*  ERROR IN CL PROGRAM  */
 ENDTAG:     DMPCLPGM
/*                                                                   */
/***END:****    ENDPGM                                             */ /*S01486*/
 END:                                                                 /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01486*/
