/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Change of Cust/Portf Ccy Audit Report')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                         */
/*                                                                   */
/*       PMC6300 - PM Change Customer/Portfolio CCY Report           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CPM005             Date 21Jun96              */
/*       Prev Amend No. S01124             Date 26May94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPM005 - Private Banking Phase II                           */
/*                Focus Group Changes Upgraded to DBA                */
/*       S01124 - PBFG/1 - Change Customer/Portfolio Base Currency   */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                   */ /*CPM005*/
             PGM        PARM(&RSEQ &RLVL &RENT)                       /*CPM005*/
/**/
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)              */ /*CPM005*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*CPM005*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*CPM005*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*CPM005*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*CPM005*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* GLOBAL MONITOR MESSAGE                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ENDTAG))
/**/
/*  SET OFF SWITCHES:                                                         */
             CHGJOB     SWS(00000000)
/**/
/*  OPEN QUERY FILE TO SELECT RECORD CHANGED TODAY                            */
             OVRDBF     FILE(PMPCBCL2) SHARE(*YES)
             OPNQRYF    FILE((*LIBL/PMPCBCL2) (SDBANKPD)) +
                          FORMAT(*LIBL/PMPCBCL2) QRYSLT('FMLCD *EQ +
                          BJRDNB') KEYFLD((FMCUST *ASCEND) (FMPTFR +
                          *ASCEND) (FMCDAT *ASCEND))
/*********** CALL       PGM(PM6300)                                */ /*CPM005*/
             CALL       PGM(PM6300) PARM(&RSEQ)                       /*CPM005*/
             DLTOVR     FILE(PMPCBCL2)
             CLOF       OPNID(PMPCBCL2)
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)      */ /*CPM005*/
/***********     SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) +        */ /*CPM005*/
/***********              MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)        */ /*CPM005*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*CPM005*/
                 SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
/**/
             ENDDO
             GOTO       CMDLBL(ENDPGM)
/**/
ENDTAG:      DMPCLPGM
/*ENDPGM:*** ENDPGM                                                */ /*CPM005*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*CPM005*/
