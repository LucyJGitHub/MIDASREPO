/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Consolidated Portfolio Maintenance')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                         */
/*                                                                   */
/*       PMC6330 - Consolidated Portfolio Maintenance                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CPM005             DATE 18JUN96              */
/*       Prev Amend No. S01124             DATE 11MAY94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*       S01124 - PBFG/2 - CALCULATE & REPORT PERF. FOR ALL CUST.    */
/*                         PORTFOLIO                                 */
/*                                                                   */
/*********************************************************************/
             PGM
 
/**/                                                                  /*CPM005*/
/* Copyright statement defination  */                                 /*CPM005*/
/**/                                                                  /*CPM005*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
                                                                      /*CPM005*/
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(52) ***/            /*CPM005*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*CPM005*/
 
             CHGJOB     SWS(00000000)
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
             CALL       PGM(PM6330)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)
             ENDDO
 
/*  DATABASE ERRORS, IF U7 & U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*********** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM) ***/        /*CPM005*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*CPM005*/
/*********** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)+*/ /*CPM005*/
/************************ TOMSGQ(MOPERQ MRUNQ) ***/                   /*CPM005*/
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 END:        ENDPGM
