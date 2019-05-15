/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas Produce Portfolio Reconciliation Reports')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                     */
/*                                                                   */
/*       PMC4200 - PRODUCE PORTFOLIO RECONCILIATION REPORTS          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      097389             Date 02Jul96              */
/*                      101266             DATE 07FEB96              */
/*                      094891             DATE 23OCT95              */
/*                      085871             DATE 16MAR95              */
/*                      085861             DATE 15MAR95              */
/*                      S01486             DATE 30NOV94              */
/*                      53103              DATE 12NOV93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       097389 - Matching is not done between transactions (reports)*/
/*       101266 - Bank Portfolios                                    */
/*       094891 - Change names of QTEMP files to make them unique    */
/*                and allow QTEMP to appear anywhere in the job's    */
/*                library list                                       */
/*       085871 - COPY FILE PMPCFEQ0 TO ALTERNATE INDEX FILE         */
/*       085861 - Missing override on PMPCFEP2                       */
/*       S01486 - Portfolio Management Upgrade to Release 10         */
/*       53103 - CREATED FOR PERFORMANCE RECONCILIATION              */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM   PARM(&WWPODF)                                   */ /*S01486*/
             PGM   PARM(&WWPODF &RSEQ &RLEV &RENT)                    /*S01486*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01486*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01486*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01486*/
             DCL        VAR(&WWPODF) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                          */ /*S01486 CCB020*/
             DCL        VAR(&COBST) TYPE(*CHAR) LEN(4)                                    /*CCB020*/
/**/
/* GLOBAL MONITOR MESSAGE                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ENDTAG))
             CHGJOB     SWS(00000000)
/**********  RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&MPHAS)                      */ /*S01486 CCB020*/
             CALL       PGM(CBC001001) PARM(&COBST)                                       /*CCB020*/
/**/
/* CALL PM4200  TO PRODUCE POSITION RECONCILIATION REPORT            */
/*********** CALL       PGM(PM4200) PARM(&WWPODF)                  */ /*S01486*/
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                                  */ /*CCB020*/
             IF         COND(&COBST *EQ '*YES') THEN(DO)                                  /*CCB020*/
             CALL       PGM(PM4201) PARM(&WWPODF &RSEQ &RLEV &RENT)   /*S01486*/
             GOTO       CMDLBL(PM4200)                                /*S01486*/
             ENDDO                                                    /*S01486*/
/**********  IF         COND(&MPHAS *EQ 'A') THEN(DO)                           */ /*085871 CCB020*/
             IF         COND(&COBST *EQ '*NO') THEN(DO)                                   /*CCB020*/
             CALL       PGM(PM4200) PARM(&WWPODF &RSEQ &RLEV &RENT)   /*S01486*/
             ENDDO                                                    /*085871*/
PM4200:                                                               /*S01486*/
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********     SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                     */ /*S01486*/
                 SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01486*/
             GOTO       CMDLBL(END)
             ENDDO
/**/
/**CHECK/CREATE*FILE*PMPCFEPP*IN*LIB/QTEMP**************************/ /*S01486*/
/*********** CHKOBJ     OBJ(QTEMP/PMPCFEPP) OBJTYPE(*FILE)         */ /*S01486*/
/*********** MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(PMPCFEPP) + /*S01486*/
/***********              TOFILE(QTEMP/PMPCFEPP) MBROPT(*ADD) +       /*S01486*/
/***********              CRTFILE(*YES) NBRRCDS(1))                */ /*S01486*/
/**/                                                                  /*S01486*/
/****Check/create*file*PMPCFEQ0*in*lib/QTEMP** ***********    *S01486* *094891*/
/************CHKOBJ     OBJ(QTEMP/PMPCFEQ0) OBJTYPE(*FILE)    *S01486* *094891*/
/************MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(PMPCFEQ0) +  *094891*/
/************             TOFILE(QTEMP/PMPCFEQ0) MBROPT(*ADD) +        *094891*/
/************             CRTFILE(*YES) NBRRCDS(1))           *S01486* *094891*/
/****Check*create file PMPCFET0 in lib/QTEMP                 *094891* /*101266*/
/************CHKOBJ     OBJ(QTEMP/PMPCFET0) OBJTYPE(*FILE)   *094891* /*101266*/
/************MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(PMPCFEQ0) + /*101266*/
/************             TOFILE(QTEMP/PMPCFET0) MBROPT(*ADD) +       /*101266*/
/************             CRTFILE(*YES) NBRRCDS(1))          *094891* /*101266*/
/**/
/**CLEAR*FILE*PMPCFEPP*IN*LIB/QTEMP*********************************/ /*S01486*/
/*********** CLRPFM     FILE(QTEMP/PMPCFEPP)                       */ /*S01486*/
/**/                                                                  /*S01486*/
/****Clear*file*PMPCFEQ0*in*lib/QTEMP** ********************* *S01486* *094891*/
/************CLRPFM     FILE(QTEMP/PMPCFEQ0)                  *S01486* *094891*/
/****Clear*file PMPCFET0 in lib/QTEMP                        *094891* /*101266*/
/************CLRPFM     FILE(QTEMP/PMPCFET0)                 *094891* /*101266*/
/**/
/**CHECK/CREATE*FILE*PMPCWKPP*IN*LIB/QTEMP**************************/ /*S01486*/
/*********** CHKOBJ     OBJ(QTEMP/PMPCWKPP) OBJTYPE(*FILE)         */ /*S01486*/
/*********** MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(PMPCWKPP) + /*S01486*/
/***********              TOFILE(QTEMP/PMPCWKPP) MBROPT(*ADD) +       /*S01486*/
/***********              CRTFILE(*YES) NBRRCDS(1))                */ /*S01486*/
/**/                                                                  /*S01486*/
/****Check/create*file PMPCWKQ0*in*lib/QTEMP*** ************* *S01486* *094891*/
/************CHKOBJ     OBJ(QTEMP/PMPCWKQ0) OBJTYPE(*FILE)    *S01486* *094891*/
/************MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(PMPCWKQ0) +
/************             TOFILE(QTEMP/PMPCWKQ0) MBROPT(*ADD) +
/************             CRTFILE(*YES) NBRRCDS(1))           *S01486* *094891*/
/****Check/create file PMPCWKT0 in lib/QTEMP                 *094891* /*101266*/
/************CHKOBJ     OBJ(QTEMP/PMPCWKQ0) OBJTYPE(*FILE)   *094891* /*101266*/
/************MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(PMPCWKQ0) + /*101266*/
/************             TOFILE(QTEMP/PMPCWKT0) MBROPT(*ADD) +       /*101266*/
/************             CRTFILE(*YES) NBRRCDS(1))          *094891* /*101266*/
/**/
/**CLEAR*FILE*PMPCWKPP*IN*LIB/QTEMP*********************************/ /*S01486*/
/*********** CLRPFM     FILE(QTEMP/PMPCWKPP)                       */ /*S01486*/
/**/                                                                  /*S01486*/
/****Clear*file*PMPCWKQ0*in*lib/QTEMP*** ******************** *S01486* *094891*/
/************CLRPFM     FILE(QTEMP/PMPCWKQ0)                  *S01486* *094891*/
/****Clear*file PMPCWKT0 in lib/QTEMP                        *094891* /*101266*/
/************CLRPFM     FILE(QTEMP/PMPCWKT0)                 *094891* /*101266*/
/**/
/**CHECK/CREATE*FILE*PMPTWKPP*IN*LIB/QTEMP**************************/ /*S01486*/
/*********** CHKOBJ     OBJ(QTEMP/PMPTWKPP) OBJTYPE(*FILE)         */ /*S01486*/
/*********** MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(PMPTWKPP) + /*S01486*/
/***********              TOFILE(QTEMP/PMPTWKPP) MBROPT(*ADD) +       /*S01486*/
/***********              CRTFILE(*YES) NBRRCDS(1))                */ /*S01486*/
/**/                                                                  /*S01486*/
/****Check/create*file*PMPTWKQ0*in*lib/QTEMP** ************** *S01486* *094891*/
/************CHKOBJ     OBJ(QTEMP/PMPTWKQ0) OBJTYPE(*FILE)    *S01486* *094891*/
/************MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(PMPTWKQ0) +
/************             TOFILE(QTEMP/PMPTWKQ0) MBROPT(*ADD) +
/************             CRTFILE(*YES) NBRRCDS(1))           *S01486* *094891*/
/****Check*create file PMPTWKT0 in lib/QTEMP                 *094891* /*101266*/
/************CHKOBJ     OBJ(QTEMP/PMPTWKT0) OBJTYPE(*FILE)   *094891* /*101266*/
/************MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(PMPTWKQ0) + /*101266*/
/************             TOFILE(QTEMP/PMPTWKT0) MBROPT(*ADD) +       /*101266*/
/************             CRTFILE(*YES) NBRRCDS(1))          *094891* /*101266*/
/**/
/**CLEAR*FILE*PMPTWKPP*IN*LIB/QTEMP*********************************/ /*S01486*/
/*********** CLRPFM     FILE(QTEMP/PMPTWKPP)                       */ /*S01486*/
/**/                                                                  /*S01486*/
/****Clear*file*PMPTWKQ0*in*lib/QTEMP*** ******************** *S01486* *094891*/
/************CLRPFM     FILE(QTEMP/PMPTWKQ0)                  *S01486* *094891*/
/****Clear file PMPTWKT0 in lib/QTEMP                        *094891* /*101266*/
/************CLRPFM     FILE(QTEMP/PMPTWKT0)                 *094891* /*101266*/
/* */                                                                 /*101266*/
/* CLEAR WORKFILES */                                                 /*101266*/
/* */                                                                 /*101266*/
             CLRPFM     FILE(PMPCFEQ0)                                /*101266*/
             CLRPFM     FILE(PMPCWKQ0)                                /*101266*/
             CLRPFM     FILE(PMPTWKQ0)                                /*101266*/
/* */                                                                 /*101266*/
             RMVLIBLE   LIB(QTEMP)                                    /*097389*/
             MONMSG     MSGID(CPF0000)                                /*097389*/
             ADDLIBLE   LIB(QTEMP)                                    /*097389*/
             MONMSG     MSGID(CPF0000)                                /*097389*/
/**/                                                                  /*097389*/
/* CHECK/CREATE FILE PMPCFUPD IN LIB/QTEMP                              097389*/
             CHKOBJ     OBJ(QTEMP/PMPCFUPD) OBJTYPE(*FILE)            /*097389*/
             MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(PMPCFUPD) +
                          TOFILE(QTEMP/PMPCFUPD) MBROPT(*ADD) +
                          CRTFILE(*YES) NBRRCDS(1))                   /*097389*/
/**/                                                                  /*097389*/
/* CLEAR FILE PMPCFUPD IN LIB/QTEMP                                     097389*/
             CLRPFM     FILE(QTEMP/PMPCFUPD)                          /*097389*/
/**/
/* CALL PM4300  TO COPY PERFORMANCE EVENTS TO WORKFILES              */
             CALL       PGM(PM4300) PARM('2')
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********     SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                     */ /*S01486*/
                 SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01486*/
             GOTO       CMDLBL(END)
             ENDDO
/**/
/* CALL PM4310  TO PREPARE CAPITALFLOW DETAILS FOR RECONCILIATION    */
             CALL       PGM(PM4310)
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********     SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                     */ /*S01486*/
                 SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01486*/
             GOTO       CMDLBL(END)
             ENDDO
/**CREATE*FILE*WITH*ALTERNATE*INDEXES ***********************  085871* *094891*/
/************CPYF       FROMFILE(PMPCFEQ1) TOFILE(QTEMP/PMPCFEQ1) +
/************             MBROPT(*REPLACE) CRTFILE(*YES)      *085871* *094891*/
/************MONMSG     MSGID(CPF2817)                        *085871* *094891*/
/************CPYF       FROMFILE(PMPCFEQ0) +                  *085871* *094891*/
/************             TOFILE(QTEMP/PMPCFEQ1) MBROPT(*REPLACE)      *094891*/
/************MONMSG     MSGID(CPF2817)                        *085871* *094891*/
/**CREATE*FILE WITH ALTERNATE INDEXES                         094891* /*101266*/
/************CPYF       FROMFILE(PMPCFEQ1) TOFILE(QTEMP/PMPCFET1) +   /*101266*/
/************             MBROPT(*REPLACE) CRTFILE(*YES)     *094891* /*101266*/
/************MONMSG     MSGID(CPF2817)                       *094891* /*101266*/
/************CPYF       FROMFILE(PMPCFET0) +                          /*101266*/
/************             TOFILE(QTEMP/PMPCFET1) MBROPT(*REPL*094891* /*101266*/
/************MONMSG     MSGID(CPF2817)                       *094891* /*101266*/
/* */                                                                 /*101266*/
/* COPY TO ALTERNATE INDEX FILE */                                    /*101266*/
/* */                                                                 /*101266*/
             CPYF       FROMFILE(PMPCFEQ0) +
                          TOFILE(PMPCFEQ1) MBROPT(*REPLACE)           /*101266*/
             MONMSG     MSGID(CPF2817)                                /*101266*/
/**/
/**OVERRIDE*PMPCFEP1*TO*PMPCFEPP************************************/ /*S01486*/
/*********** OVRDBF     FILE(PMPCFEP1) TOFILE(PMPCFEPP)            */ /*S01486*/
/**/                                                                  /*S01486*/
/****Override*PMPCFEP1*to*PMPCFEQ0** ************************ *S01486* *094891*/
/************OVRDBF     FILE(PMPCFEP1) TOFILE(PMPCFEQ0)       *S01486* *094891*/
/****Override PMPCFEP1 to PMPCFET0, and PMPCFEP2 to PMPCFET1 *094891* /*101266*/
/************OVRDBF     FILE(PMPCFEP1) TOFILE(PMPCFET0)      *094891* /*101266*/
/*********** OVRDBF     FILE(PMPCFEP2) TOFILE(PMPCFEL0)       *085861* *085871*/
/************OVRDBF     FILE(PMPCFEP2) TOFILE(PMPCFEQ1)       *085871* *094891*/
/************OVRDBF     FILE(PMPCFEP2) TOFILE(PMPCFET1)      *094891* /*101266*/
             OVRDBF     FILE(PMPCFEP1) TOFILE(PMPCFEQ0) SHARE(*NO)    /*101266*/
             OVRDBF     FILE(PMPCFEP2) TOFILE(PMPCFEQ1) SHARE(*NO)    /*101266*/
             OVRDBF     FILE(PMPCFUPD) FRCRATIO(1)                    /*097389*/
             OVRDBF     FILE(PMPCFUP1) TOFILE(PMPCFUPD)               /*097389*/
             OVRDBF     FILE(PMPCFUP2) TOFILE(PMPCFUPD)               /*097389*/
/**/
/* CALL PM4210  TO REPORT MATCHED AND UNMATCHED CASHFLOWS            */
/*********** CALL       PGM(PM4210) PARM('2')                      */ /*S01486*/
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                           */ /*S01486 CCB020*/
             IF         COND(&COBST *EQ '*YES') THEN(DO)                                  /*CCB020*/
             CALL       PGM(PM4211) PARM('2')                         /*S01486*/
             GOTO       CMDLBL(PM4210)                                /*S01486*/
             ENDDO                                                    /*S01486*/
             CALL       PGM(PM4210) PARM('2' &RSEQ &RLEV &RENT)       /*S01486*/
PM4210:                                                               /*S01486*/
/**/
/* DELETE OVERRIDE                                                   */
             DLTOVR     FILE(PMPCFEP1)
             DLTOVR     FILE(PMPCFEP2)                                /*085861*/
             DLTOVR     FILE(PMPCFUP1)                                /*097389*/
             DLTOVR     FILE(PMPCFUP2)                                /*097389*/
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
/*  ERROR IN CL PROGRAM - DUMP                                       */
 ENDTAG:     DMPCLPGM
/*                                                                   */
/***END:****    ENDPGM                                             */ /*S01486*/
 END:                                                                 /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01486*/
