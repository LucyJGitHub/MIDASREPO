/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Control prod'n of reconciliation rpts')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                     */
/*                                                                   */
/*       PMC4125 - CONTROL PRODUCTION OF RECONCILIATION REPORTS      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CPM005             DATE 19JUL96              */
/*       Prev Amend No. 101266             DATE 07FEB96              */
/*                      094891             DATE 23OCT95              */
/*                      086666             DATE 20MAR95              */
/*                      085868             DATE 16MAR95              */
/*                      S01486             DATE 02DEC94              */
/*                      73300              DATE 26JUL94              */
/*                      53103              DATE 15NOV93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*       101266 - Bank Portfolios                                    */
/*       094891 - Change names of QTEMP files to make them unique    */
/*                and allow QTEMP to appear anywhere in the job's    */
/*                library list                                       */
/*       086666 - Alternate key files to be created in QTEMP         */
/*       085868 - ALTERNATE KEY FILES TO BE CREATED IN LIB/QTEMP     */
/*       S01486 - Portfolio Management Upgrade to Release 10         */
/*       73300  - ADDITIONAL PARAMETERE 'PERFORMANCE REQUIRED'       */
/*       53103  - CREATED FOR PERFORMANCE RECONCILIATION             */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM        PARM(&WWACOF &WWCNUM &WWPTFR &WWPODF)      */ /*S01486*/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)                /*S01486*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01486*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01486*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01486*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01486*/
             DCL        VAR(&WWACOF) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WWCNUM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WWPTFR) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WWPODF) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWRRRQ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWDPCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WWPMNG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWRFNB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
             DCL        VAR(&WWPFMR) TYPE(*CHAR) LEN(1)               /* 73300*/
/**/
/* GLOBAL MONITOR MESSAGE                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ENDTAG))
             CHGJOB     SWS(00000000)
/**/                                                                  /*S01486*/
/**  Get customer number, portfolio reference, and print only */      /*S01486*/
/**  differences indicator fields from &RPARM */                      /*S01486*/
/**/                                                                  /*S01486*/
             CHGVAR     VAR(&WWCNUM) VALUE(%SST(&RPARM 1 6))          /*S01486*/
             CHGVAR     VAR(&WWPTFR) VALUE(%SST(&RPARM 7 4))          /*S01486*/
             CHGVAR     VAR(&WWPODF) VALUE(%SST(&RPARM 11 1))         /*S01486*/
/**/
/* SET PARAMETERS WWDPCD, WWPMNG, WWMODE, WWRFNB                     */
             CHGVAR     VAR(&WWDPCD) VALUE('    ')
             CHGVAR     VAR(&WWACOF) VALUE('    ')                    /*S01486*/
             CHGVAR     VAR(&WWPMNG) VALUE('G')
             CHGVAR     VAR(&WWMODE) VALUE('D')
             CHGVAR     VAR(&WWRFNB) VALUE(' ')
/**/                                                                  /*S01486*/
/**  Setup account officer or dept code based on report level */      /*S01486*/
/**/                                                                  /*S01486*/
             IF         COND(&RLEV *EQ 'D') THEN(DO)                  /*S01486*/
                IF         COND(&RENT *EQ 'ALL') THEN(CHGVAR +
                             VAR(&WWDPCD) VALUE('*ALL'))              /*S01486*/
                ELSE       CMD(CHGVAR VAR(&WWDPCD) VALUE(&RENT))      /*S01486*/
             ENDDO
/**/                                                                  /*S01486*/
             IF         COND(&RLEV *EQ 'A') THEN(DO)                  /*S01486*/
                IF         COND(&RENT *EQ 'ALL') THEN(CHGVAR +
                          VAR(&WWACOF) VALUE('*ALL'))                 /*S01486*/
                ELSE       CMD(CHGVAR VAR(&WWACOF) VALUE(&RENT))      /*S01486*/
             ENDDO
/**/                                                                  /*S01486*/
/* CALL PMC1160 TO CALCULATE FIGURES REQUIRED ON STATEMENTS          */
/*              DUE TO DAY */
/*           CALL       PGM(PMC1160) PARM(&WWDPCD &WWACOF &WWPMNG +
                          &WWMODE &WWRFNB &WWCNUM &WWPTFR)               73300*/
/*********** CALL       PGM(PMC1160) PARM(&WWDPCD &WWACOF &WWPMNG +
                          &WWMODE &WWRFNB &WWCNUM &WWPTFR &WWPFMR) */ /*S01486*/
             CALL       PGM(PMC1160) PARM(&WWDPCD &WWACOF &WWPMNG +
                          &WWMODE &WWRFNB &WWCNUM &WWPTFR &WWPFMR +
                          &RSEQ)                                      /*S01486*/
/**/                                                                  /*CPM005*/
             OVRDBF     FILE(PMPORTPD) TOFILE(PMMERGPD)               /*CPM005*/
             OVRDBF     FILE(PMPORTLL) TOFILE(PMMERGLL)               /*CPM005*/
/**/
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(END)
             ENDDO
/**/
/**CHECK/CREATE*FILE*PMPTRRPP*IN*LIB/QTEMP**************************/ /*S01486*/
/*********** CHKOBJ     OBJ(QTEMP/PMPTRRPP) OBJTYPE(*FILE)         */ /*S01486*/
/*********** MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(PMPTRRPP) +
/***********              TOFILE(QTEMP/PMPTRRPP) MBROPT(*ADD) +
/***********              CRTFILE(*YES) NBRRCDS(1))                */ /*S01486*/
/**/
/**CLEAR*FILE*PMPTRRPP*IN*LIB/QTEMP*********************************/ /*S01486*/
/*********** CLRPFM     FILE(QTEMP/PMPTRRPP)                       */ /*S01486*/
/**/
/**OPEN*QRYF*PMPFMRPP***********************************************/ /*S01486*/
/*********** OVRDBF     FILE(PMPFMRPP) SHARE(*YES)                 */ /*S01486*/
/*********** OPNQRYF    FILE((PMPFMRPP)) KEYFLD((QRPRRE) (QRPRTL) +
/***********              (QRACOC) (QRCNUM) (QRPTFR) (QRPFMP))     */ /*S01486*/
/**/                                                                  /*S01486*/
/****Check/create*file*PMPTRRQ0*in*lib/QTEMP***************** *S01486* *094891*/
/************CHKOBJ     OBJ(QTEMP/PMPTRRQ0) OBJTYPE(*FILE)    *S01486* *094891*/
/************MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(PMPTRRQ0) +  *094891*/
/************             TOFILE(QTEMP/PMPTRRQ0) MBROPT(*ADD) +        *094891*/
/************             CRTFILE(*YES) NBRRCDS(1))           *S01486* *094891*/
/**CHECK*CREATE FILE PMPTRRT0 IN LIB/QTEMP                   *094891* /*101266*/
/************CHKOBJ     OBJ(QTEMP/PMPTRRT0) OBJTYPE(*FILE)   *094891* /*101266*/
/************MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(PMPTRRQ0) + /*101266*/
/************             TOFILE(QTEMP/PMPTRRT0) MBROPT(*ADD) +       /*101266*/
/************             CRTFILE(*YES) NBRRCDS(1))          *094891* /*101266*/
/**/                                                                  /*S01486*/
/****Clear*file*PMPTRRQ0*in*lib/QTEMP** ********************* *S01486  *094891*/
/************CLRPFM     FILE(QTEMP/PMPTRRQ0)                  *S01486* *094891*/
/**CLEAR*FILE*PMPTRRT0 IN LIB/QTEMP                          *094891* /*101266*/
/************CLRPFM     FILE(QTEMP/PMPTRRT0)                 *094891* /*101266*/
/**/                                                                  /*S01486*/
/****Open*QRYF*PMPFMRQ0****************************************S01486* *085868*/
/*********** OVRDBF     FILE(PMPFMRQ0) SHARE(*YES)            *S01486* *085868*/
/*********** OPNQRYF    FILE((PMPFMRQ0)) KEYFLD((QRPRRE) (QRPRTL) +    *085868*/
/***********              (QRACOC) (QRCNUM) (QRPTFR) (QRPFMP))*S01486* *085868*/
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
/* */                                                                 /*101266*/
/**/
/* SET PARAMETERS WWMODE, WWRRRQ                                  */
             IF         COND(&WWPODF *EQ 'Y') THEN(CHGVAR +
                          VAR(&WWMODE) VALUE('1'))
             ELSE       CMD(CHGVAR VAR(&WWMODE) VALUE('2'))
 
             CHGVAR     VAR(&WWRRRQ) VALUE(' ')
/**/
/* CALL PM1660 TO REPORT PORTFOLIO PERFORMANCE RECONCILIATION    */
/*********** CALL       PGM(PM1660) PARM(&WWMODE &WWRRRQ &WWACOF)  */ /*S01486*/
             CALL       PGM(PM1660) PARM(&WWMODE &WWRRRQ &RSEQ +
                           &RLEV &RENT)                               /*S01486*/
/**/
/**CLOSE*AND*DLTOVR*OF*FILE*PMPFMRPP********************************/ /*S01486*/
/*********** CLOF       OPNID(PMPFMRPP)                            */ /*S01486*/
/*********** DLTOVR     FILE(PMPFMRPP)                             */ /*S01486*/
/**/                                                                  /*S01486*/
/****Close*and*DLTOVR*of*file*PMPFMRQ0*************************S01486* *085868*/
/*********** CLOF       OPNID(PMPFMRQ0)                       *S01486* *085868*/
/*********** DLTOVR     FILE(PMPFMRQ0)                        *S01486* *085868*/
/**/
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(END)
             ENDDO
/**/
/**Create*file*with*alternate indexes************************ *086666* *094891*/
/************CHKOBJ     OBJ(QTEMP/PMPTRRQ1) OBJTYPE(*FILE)    *086666* *094891*/
/************MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(PMPTRRQ1) +  *094891*/
/************             TOFILE(QTEMP/PMPTRRQ1) MBROPT(*ADD) +        *094891*/
/************             CRTFILE(*YES) NBRRCDS(1))           *086666* *094891*/
/****Clear*file*PMPTRRQ1*in*lib/QTEMP************************ *086666* *094891*/
/************CLRPFM     FILE(QTEMP/PMPTRRQ1)                  *086666* *094891*/
/************CPYF       FROMFILE(PMPTRRQ0) +                  *086666* *094891*/
/************             TOFILE(QTEMP/PMPTRRQ1) MBROPT(*REPLACE) +    *094891*/
/************             CRTFILE(*YES)                       *086666* *094891*/
/************MONMSG     MSGID(CPF2817)                        *086666* *094891*/
/**Create*file with alternate indexes                        *086666* /*101266*/
/************CHKOBJ     OBJ(QTEMP/PMPTRRT1) OBJTYPE(*FILE)   *094891* /*101266*/
/************MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(PMPTRRQ1) + /*101266*/
/************             TOFILE(QTEMP/PMPTRRT1) MBROPT(*ADD) +       /*101266*/
/************             CRTFILE(*YES) NBRRCDS(1))          *094891* /*101266*/
/****Clear*file PMPTRRT1 in lib/QTEMP                        *094891* /*101266*/
/************CLRPFM     FILE(QTEMP/PMPTRRT1)                 *094891* /*101266*/
/************CPYF       FROMFILE(PMPTRRQ0) +                          /*101266*/
/************             TOFILE(QTEMP/PMPTRRT1) MBROPT(*REPL*094891* /*101266*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)       *094891* /*101266*/
/* */                                                                 /*101266*/
/* Create file with alternate indexes                                  *101266*/
/* */                                                                 /*101266*/
             CPYF       FROMFILE(PMPTRRQ0) +
                          TOFILE(PMPTRRQ1) MBROPT(*REPLACE)           /*101266*/
             MONMSG     MSGID(CPF2817)                                /*101266*/
/* */                                                                 /*101266*/
/* IF EXISTS DIFFERENCES CALL PMC4200                               */
             IF         COND(&WWRRRQ *EQ 'Y') THEN(DO)
/***********   CALL       PGM(PMC4200) PARM(&WWPODF)               */ /*S01486*/
               CALL       PGM(PMC4200) PARM(&WWPODF &RSEQ &RLEV +
                             &RENT)                                   /*S01486*/
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********     SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) +
                             MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)     */ /*S01486*/
                 SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) +
                             MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)        /*S01486*/
               ENDDO
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
/*  ERROR IN CL PROGRAM                                              */
 ENDTAG:     DMPCLPGM
/*                                                                   */
/***END:****    ENDPGM                                             */ /*S01486*/
END:                                                                  /*S01486*/
             DLTOVR     FILE(PMPORTPD)                                /*CPM005*/
             MONMSG     MSGID(CPF9841)                                /*CPM005*/
             DLTOVR     FILE(PMPORTLL)                                /*CPM005*/
             MONMSG     MSGID(CPF9841)                                /*CPM005*/
             CLRPFM     FILE(PMMERGPD)                                /*CPM005*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01486*/
