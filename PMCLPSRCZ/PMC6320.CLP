/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Cons.Port.changed today audit report')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                         */
/*                                                                   */
/*       PMC6320 - Consolidated Portfolio Changed Today              */
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
/*       Prev Amend No. CPM005             Date 20Jun96              */
/*                      S01124             Date 11May94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*       S01124 - PBFG/2 - CALCULATE & REPORT PERF. FOR ALL CUST.    */
/*                         PORTFOLIO                                 */
/*                                                                   */
/*********************************************************************/
/*********** PGM ***/                                                 /*CPM005*/
             PGM        PARM(&RSEQ &RLVL &RENT)                       /*CPM005*/
/**/                                                                  /*CPM005*/
/* Copyright statement defination  */                                 /*CPM005*/
/**/                                                                  /*CPM005*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*CPM005*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*CPM005*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*CPM005*/
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(52) ***/            /*CPM005*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*CPM005*/
/**/
/* GLOBAL MONITOR MESSAGE                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ENDTAG))
/**/
/*  SET OFF SWITCHES:                                                         */
             CHGJOB     SWS(00000000)
/**/
/*  OPEN QUERY FILE TO SELECT RECORD CHANGED TODAY                            */
             OVRDBF     FILE(PMCNSDLL) SHARE(*YES)
             OPNQRYF    FILE((*LIBL/PMCNSDLL) (SDBANKPD)) +
                          FORMAT(*LIBL/PMCNSDLL PMCNSDD0) +
                          QRYSLT('PNLCD *EQ BJRDNB') KEYFLD((PNCNUM +
                          *ASCEND) (PNPTFR))
/*********** CALL       PGM(PM6320) ***/                              /*CPM005*/
             CALL       PGM(PM6320) PARM(&RSEQ)                       /*CPM005*/
             DLTOVR     FILE(PMCNSDLL)
             CLOF       OPNID(PMCNSDLL)
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*************** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM) ***/    /*CPM005*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*CPM005*/
/*************** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) + ***/      /*CPM005*/
/************************ MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ) ***/      /*CPM005*/
                 SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) +
                          MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)           /*CPM005*/
/**/
             ENDDO
             GOTO       CMDLBL(ENDPGM)
/**/
ENDTAG:      DMPCLPGM
/**/                                                                  /*CPM005*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM:      ENDPGM
