/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas PM Performance by Account Officer')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                         */
/*                                                                   */
/*       PMC1700 - Portfolio Performance By Account Officer Report   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 109437             Date 15OCT96              */
/*                      CPM005             Date 17Jul96              */
/*                      101266             Date 07Feb96              */
/*                      094891             Date 23Oct95              */
/*                      S01408             DATE 05MAY95              */
/*                      085868             DATE 16MAR95              */
/*                      085853             DATE 14MAR95              */
/*                      082220             DATE 25JAN95              */
/*                      080732             DATE 22DEC94              */
/*                      73300              DATE 28NOV94              */
/*                      53103              DATE 28NOV94              */
/*                      S01486             DATE 11AUG94              */
/*                      049421             DATE 18JAN93              */
/*                      S01313             DATE 07APR92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       109437 - PMPFMRPD SHOULD BE COPIED TO PMPFMRQ0              */
/*       CPM005 - Private Banking Phase II                           */
/*                Focus Group Changes Upgraded to DBA                */
/*                PBFG/2 - CALCULATE & REPORT PERF. FOR ALL CUST PORT*/
/*       101266 - Bank Portfolios                                    */
/*       094891 - Change names of QTEMP files to make them unique    */
/*                and allow QTEMP to appear anywhere in the job's    */
/*                library list                                       */
/*       S01408 - Addition of core hook PMC1700MP1                   */
/*       085868 - ALTERNATE KEY FILES TO BE CREATED IN LIB/QTEMP     */
/*       085853 - Missing parameters                                 */
/*       082220 - SEQUENCE OVERWRITTEN                               */
/*       080732 - Missing parameter on CALL PMC1160                  */
/*              - Remove field QRPRRE on OPNQRY                      */
/*              - Wrong files used                                   */
/*       073300 - Pass additional parameter 'Performance Required'   */
/*       053103 - Performance Reconciliation Enhancements            */
/*       S01486 - Portfolio Management Upgrade to Release 10         */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       S01313 - WRITTEN FOR PORTFOLIO PERFORMANCE                  */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*********** PGM        PARM(&WWDPCD &WWACOC &WWPMNG)              */ /*S01486*/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)                /*S01486*/
/* DECLARE VARIABLES */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01486*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01486*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01486*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01486*/
             DCL        VAR(&WWDPCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WWACOC) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WWPMNG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
             DCL        VAR(&WWPARM) TYPE(*CHAR) LEN(24)
             DCL        VAR(&WWMODE) TYPE(*CHAR) LEN(1) VALUE('R')
             DCL        VAR(&WWTNLA) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&FMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WWCNUM) TYPE(*DEC) LEN(6 0)              /* 53103*/
             DCL        VAR(&WWPTFR) TYPE(*CHAR) LEN(4)               /* 53103*/
             DCL        VAR(&WWRRRQ) TYPE(*CHAR) LEN(1)               /* 53103*/
             DCL        VAR(&WWPFMR) TYPE(*CHAR) LEN(1)               /* 73300*/
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                         */ /* S01486 CCB020*/
             DCL        VAR(&COBST) TYPE(*CHAR) LEN(4)                                    /*CCB020*/
             DCL        VAR(&SSEQ) TYPE(*CHAR) LEN(5)                 /*082220*/
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
/**/                                                                  /*S01486*/
/**********  RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&MPHAS)                      */ /*S01486 CCB020*/
/**/                                                                                      /*CCB020*/
/** CBFLAGQT PHASE CHECK  **/                                                             /*CCB020*/
/**/                                                                                      /*CCB020*/
             CALL       PGM(CBC001001) PARM(&COBST)                                       /*CCB020*/
/**/                                                                                      /*CCB020*/
             IF         COND(&RLEV *EQ 'A') THEN(DO)                  /*S01486*/
               CHGVAR     VAR(&WWDPCD) VALUE('    ')                  /*S01486*/
               IF         COND(&RENT *EQ 'ALL') THEN(CHGVAR +
                            VAR(&WWACOC) VALUE('*ALL'))               /*S01486*/
               ELSE       CMD(CHGVAR VAR(&WWACOC) VALUE(&RENT))       /*S01486*/
             ENDDO                                                    /*S01486*/
/**/                                                                  /*S01486*/
             IF         COND(&RLEV *EQ 'D') THEN(DO)                  /*S01486*/
               CHGVAR     VAR(&WWACOC) VALUE('    ')                  /*S01486*/
               IF         COND(&RENT *EQ 'ALL') THEN(CHGVAR +
                            VAR(&WWDPCD) VALUE('*ALL'))               /*S01486*/
               ELSE       CMD(CHGVAR VAR(&WWDPCD) VALUE(&RENT))       /*S01486*/
             ENDDO                                                    /*S01486*/
/**/                                                                  /*S01486*/
             CHGVAR     VAR(&WWPMNG) VALUE(%SUBSTRING(&RPARM 1 1))    /*S01486*/
 
/* CALL PMC1160 WITH PARAMETERS */
/*********** CALL       PGM(PMC1160) PARM(&WWDPCD &WWACOC &WWPMNG +*/ /*S01486*/
/***********              &WWMODE &WWTNLA)                         */ /*S01486*/
/*********** CALL       PGM(PMC1160) PARM(&WWDPCD &WWACOC &WWPMNG +
                          &WWMODE &WWTNLA &RSEQ)               /*S01486 080732*/
             CHGVAR     VAR(&SSEQ) VALUE(&RSEQ)                       /*082220*/
             CHGVAR     VAR(&RSEQ) VALUE('     ')                     /*082220*/
             CALL       PGM(PMC1160) PARM(&WWDPCD &WWACOC &WWPMNG +
                      &WWMODE &WWTNLA &WWCNUM &WWPTFR &WWPFMR &RSEQ)  /*73300*/
             CHGVAR     VAR(&RSEQ) VALUE(&SSEQ)                       /*082220*/
/**/                                                                  /*CPM005*/
             OVRDBF     FILE(PMPORTPD) TOFILE(PMMERGPD)               /*CPM005*/
             OVRDBF     FILE(PMPORTLL) TOFILE(PMMERGLL)               /*CPM005*/
/**/                                                                  /*CPM005*/
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/*********** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)+*/ /*S01486*/
/***********             TOMSGQ(MOPERQ MRUNQ)                      */
                 SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(END)
             ENDDO
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC1700 - Account Officer Portfolio +
                          Performance Report') TOMSGQ(MRUNQ) +
 
/* FORMAT 'TO LIBRARY NAME' FOR BACKUP COPIES  */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/**********  CHGVAR     VAR(&FMLIB) VALUE(&PRE *TCAT 'DLIB')       */ /*S01486*/
             CHGVAR     VAR(&FMLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01486*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC1700MP1                                          */
                                                                      /*S01408*/
/**/
/**CHECK/CREATE*FILE*PMPTRRPP*IN*LIB/QTEMP**************************** *094891*/
/************CHKOBJ     OBJ(QTEMP/PMPTRRQ0) OBJTYPE(*FILE)    *53103 * *094891*/
/************MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(PMPTRRQ0) +  *094891*/
/************             TOFILE(QTEMP/PMPTRRQ0) MBROPT(*ADD) +        *094891*/
/************             CRTFILE(*YES) NBRRCDS(1))           *53103 * *094891*/
/**CHECK*CREATE FILE PMPTRRT0 IN LIB/QTEMP                   *094891* /*101266*/
/************CHKOBJ     OBJ(QTEMP/PMPTRRT0) OBJTYPE(*FILE)   *094891* /*101266*/
/************MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(PMPTRRQ0) + /*101266*/
/************             TOFILE(QTEMP/PMPTRRT0) MBROPT(*ADD) +       /*101266*/
/************             CRTFILE(*YES) NBRRCDS(1))          *094891* /*101266*/
/**/
/**CLEAR*FILE*PMPTRRPP*IN*LIB/QTEMP*********************************** *094891*/
/************CLRPFM     FILE(QTEMP/PMPTRRQ0)                  *53103 * *094891*/
/**CLEAR*FILE PMPTRRT0 IN LIB/QTEMP                          *094891* /*101266*/
/************CLRPFM     FILE(QTEMP/PMPTRRT0)                 *094891* /*101266*/
/**/
/**OPEN*QRYF*PMPFMRPP***************************************************085868*/
/*********** OVRDBF     FILE(PMPFMRPD) SHARE(*YES)             *53103* *085868*/
/*********** OPNQRYF    FILE((PMPFMRPD)) KEYFLD((QRPRRE) (QRPRTL) +
                          (QRACOC) (QRCNUM) (QRPTFR) (QRPFMP)  )/*53103 080732*/
/*********** OPNQRYF    FILE((PMPFMRPD)) KEYFLD((QRPRTL) (QRACOC) +    *085868*/
/***********              (QRCNUM) (QRPTFR) (QRPFMP))         *080732* *085868*/
/**CREATE*FILE*WITH*ALTERNATE*INDEXES************************ *085868* *094891*/
/************CPYF       FROMFILE(PMPFMRQ2) TOFILE(QTEMP/PMPFMRQ2) +
/************             CRTFILE(*YES)                       *085868* *094891*/
/************MONMSG     MSGID(CPF2817)                        *085868* *094891*/
/************CPYF       FROMFILE(PMPFMRPD) TOFILE(QTEMP/PMPFMRQ2) +
/************             MBROPT(*REPLACE)                    *085868* *094891*/
/************MONMSG     MSGID(CPF2817)                        *085868* *094891*/
/************                                                 *085868* *094891*/
/************CPYF       FROMFILE(PMPFMRQ3) TOFILE(QTEMP/PMPFMRQ3) +
/************             CRTFILE(*YES)                       *085868* *094891*/
/************MONMSG     MSGID(CPF2817)                        *085868* *094891*/
/************CPYF       FROMFILE(PMPFMRPD) TOFILE(QTEMP/PMPFMRQ3) +
/************             MBROPT(*REPLACE)                    *085868* *094891*/
/************MONMSG     MSGID(CPF2817)                        *085868* *094891*/
/**CREATE*FILE WITH ALTERNATE INDEXES                        *094891* /*101266*/
/************CPYF       FROMFILE(PMPFMRQ2) TOFILE(QTEMP/PMPFMRT2) +   /*101266*/
/************             CRTFILE(*YES)                      *094891* /*101266*/
/************MONMSG     MSGID(CPF2817)                       *094891* /*101266*/
/************CPYF       FROMFILE(PMPFMRPD) TOFILE(QTEMP/PMPFMRT2) +   /*101266*/
/************             MBROPT(*REPLACE)                   *094891* /*101266*/
/************MONMSG     MSGID(CPF2817)                       *094891* /*101266*/
/************                                                *094891* /*101266*/
/************CPYF       FROMFILE(PMPFMRQ3) TOFILE(QTEMP/PMPFMRT3) +   /*101266*/
/************             CRTFILE(*YES)                      *094891* /*101266*/
/************MONMSG     MSGID(CPF2817)                       *094891* /*101266*/
/************CPYF       FROMFILE(PMPFMRPD) TOFILE(QTEMP/PMPFMRT3) +   /*101266*/
/************             MBROPT(*REPLACE)                   *094891* /*101266*/
/************MONMSG     MSGID(CPF2817)                       *094891* /*101266*/
/* */                                                                 /*101266*/
/* CLEAR/SET WORKFILES */                                             /*101266*/
/* */                                                                 /*101266*/
             CLRPFM     FILE(PMPTRRQ0)                                /*101266*/
             CPYF       FROMFILE(PMPFMRPD) TOFILE(PMPFMRQ2) +
                          MBROPT(*REPLACE)                            /*101266*/
             MONMSG     MSGID(CPF2817)                                /*101266*/
             CPYF       FROMFILE(PMPFMRPD) TOFILE(PMPFMRQ3) +
                          MBROPT(*REPLACE)                            /*101266*/
             MONMSG     MSGID(CPF2817)                                /*101266*/
             CPYF       FROMFILE(PMPFMRPD) TOFILE(PMPFMRQ0) +
                          MBROPT(*REPLACE)                            /*109437*/
             MONMSG     MSGID(CPF2817)                                /*109437*/
/**/
/* SET PARAMETERS WWMODE, WWRRRQ                                  */
             CHGVAR     VAR(&WWRRRQ) VALUE(' ')                      /*53103 */
/**/
/* CALL PM1660 TO REPORT PORTFOLIO PERFORMANCE RECONCILIATION    */
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                           */ /*S01486 CCB020*/
             IF         COND(&COBST *EQ '*YES') THEN(DO)                                  /*CCB020*/
             CALL       PGM(PM1661) PARM('1' &WWRRRQ)                 /*S01486*/
             GOTO       CMDLBL(PM1700)                                /*S01486*/
             ENDDO                                                    /*S01486*/
             CHGVAR     VAR(&SSEQ) VALUE(&RSEQ)                       /*082220*/
             CHGVAR     VAR(&RSEQ) VALUE('     ')                     /*082220*/
/*********** CALL       PGM(PM1660) PARM('1' &WWRRRQ &WWACOC) ***53103  S01486*/
             CALL       PGM(PM1660) PARM('1' &WWRRRQ &RSEQ &RLEV +
                                         &RENT)                       /*S01486*/
             CHGVAR     VAR(&RSEQ) VALUE(&SSEQ)                       /*082220*/
PM1700:
/**/
/**CLOSE*AND*DLTOVR*OF*FILE*PMPFMRPP************************************085868*/
/*********** CLOF       OPNID(PMPFMRPD)                        *53103* *085868*/
/*********** DLTOVR     FILE(PMPFMRPD)                         *53103* *085868*/
/**/
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)             /*53103 */
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)         /*53103 */
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)                    /*53103 */
             GOTO       CMDLBL(END)                                  /*53103 */
             ENDDO                                                   /*53103 */
 
/**CREATE*WORKFILE*PF/PMPFMRQQ*IN*QTEMP*/
/*********** CPYF       FROMFILE(&FMLIB/PMPFMRQQ) +
/************             TOFILE(QTEMP/PMPFMRQQ) MBROPT(*REPLACE) +   /*101266*/
/************             CRTFILE(*YES)                      *080732* /*101266*/
/*********** MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMPFMRQQ))    /*080732*/
/************CPYF       FROMFILE(&FMLIB/PMPFMRQ0) +                   /*101266*/
/************             TOFILE(QTEMP/PMPFMRQ0) MBROPT(*REPLACE) +   /*101266*/
/************             CRTFILE(*YES)                      *080732* /*101266*/
/************MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMPFM*080732* /*101266*/
 
/**COPY*RECORDS*TO*PF/PMPFMRQQ */
/**COPY*RECORDS TO PF/PMPFMRQ0 */                                     /*101266*/
/**********  CPYF       FROMFILE(PMPFMRPP) TOFILE(PMPFMRQQ) +      */ /*S01486*/
/**********               MBROPT(*ADD)                             */ /*S01486*/
/*********** CPYF       FROMFILE(PMPFMRPD) TOFILE(PMPFMRQQ) +
/************             MBROPT(*ADD)                        080732* /*101266*/
/************CPYF       FROMFILE(PMPFMRPD) TOFILE(PMPFMRQ0) +         /*101266*/
/************             MBROPT(*ADD)                       *080732* /*101266*/
 
/* CALL PM1700 TO PRODUCE REPORT */
/**********  CALL       PGM(PM1700) PARM(&WWDPCD &WWACOC)          */ /*S01486*/
             CALL       PGM(PM1700) PARM(&RSEQ &RLEV &RENT)           /*S01486*/
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/*********** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)+*/ /*S01486*/
/***********              TOMSGQ(MOPERQ MRUNQ)                     */ /*S01486*/
                 SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(END)
             ENDDO
/**/
/* IF EXISTS DIFFERENCES CALL PMC4200                               */
             IF         COND(&WWRRRQ *EQ 'Y') THEN(DO)               /*53103 */
/***********   CALL       PGM(PMC4200) PARM('Y')               *53103* *085853*/
               CALL       PGM(PMC4200) PARM('Y' &RSEQ &RLEV +
                             &RENT)                                   /*085853*/
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)           /*53103 */
                 RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)        /*53103 */
                 SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) +
                             MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)       /*53103 */
               ENDDO                                                 /*53103 */
             ENDDO                                                   /*53103 */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/***END:**** ENDPGM                                                */ /*CPM005*/
 END:        DLTOVR     FILE(PMPORTPD)                                /*CPM005*/
             DLTOVR     FILE(PMPORTLL)                                /*CPM005*/
             CLRPFM     FILE(PMMERGPD)                                /*CPM005*/
             MONMSG     MSGID(CPF2817)                                /*CPM005*/
/**/                                                                  /*CPM005*/
             ENDPGM                                                   /*CPM005*/
