/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Valuation Statements in old Base Ccy')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                         */
/*                                                                   */
/*       PMC6410 - PRINT VALUATION STATEMENTS IN "OLD" BASE CCY      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. CPM005             DATE 24JUN96              */
/*       PREV AMEND NO. S01124     VT      DATE 20JUN94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*       S01124 - PBFG/1 - CHANGE CUSTOMER/PORTFOLIO BASE CCY        */
/*                  VERSION RELEASE III                              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
/**********  DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)                * *CPM005*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*CPM005*/
             DCL        VAR(&DAECD) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PMSTAT) TYPE(*CHAR) LEN(256)
/**/
/* GLOBAL MONITOR MESSAGE                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ENDTAG))
 
/* RUN ONLY PROCESSING IF CHANGE OF CURRENCY OCCUR TODAY */
/*                 AND IF PRINT VALUATION REQUIRED       */
             RTVDTAARA  DTAARA(PMSTAT) RTNVAR(&PMSTAT)
 
             IF         COND(%SST(&PMSTAT 70 1) *NE 'Y') THEN(DO)
                  GOTO  CMDLBL(ENDPGM)
             ENDDO
/**/
/*  SET OFF SWITCHES:                                                         */
             CHGJOB     SWS(00000000)
/**/
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC6410 - Print Valuation Statements in +
                          "old" Base Currency') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)
/**/
/* SAVE EVENT CONTROL DATE AS DATE EXTRACT LAST RUN */
             RTVDTAARA  DTAARA(PMSTAT (1 5)) RTNVAR(&DAECD)
/**/
/*  OPEN QUERY FILE TO SELECT RECORD CHANGED TODAY                            */
             OVRDBF     FILE(PMPCBCL1) SHARE(*YES)
             OPNQRYF    FILE((*LIBL/PMPCBCL1)) +
                          FORMAT(*LIBL/PMPCBCL1) QRYSLT('(FMCDAA +
                          *LE "' *CAT &DAECD *CAT '") & (FMSTFM +
                          *NE " ")') KEYFLD((FMCUST *ASCEND) +
                          (FMPTFR *ASCEND)) MAPFLD((FMCDA1 FMCDAT +
                          *ZONED 5 0) (FMCDAA FMCDA1 *CHAR 5))
             CALL       PGM(PM6410)
             DLTOVR     FILE(PMPCBCL1)
             CLOF       OPNID(PMPCBCL1)
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**********      RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)        * *CPM005*/
/**********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) + *CPM005*/
/**********               TOMSGQ(MOPERQ MRUNQ)                       * *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*CPM005*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM)  +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
             GOTO       CMDLBL(ENDTAG)
             ENDDO
/**/
/**********  CALL       PGM(PMC0950) PARM('99999')                   * *CPM005*/
             CALL       PGM(PMC0950) PARM('     ' 'A' 'ALL'  '99999') /*CPM005*/
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**********      RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)        * *CPM005*/
/**********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) + *CPM005*/
/**********               TOMSGQ(MOPERQ MRUNQ)                       * *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*CPM005*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM)  +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
             GOTO       CMDLBL(ENDTAG)
             ENDDO
/**/
             GOTO       CMDLBL(ENDPGM)
/**/
ENDTAG:      DMPCLPGM
/***ENDPGM:**    ENDPGM                                              * *CPM005*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*CPM005*/
