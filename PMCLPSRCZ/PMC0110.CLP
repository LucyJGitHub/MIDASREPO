/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Portfolio definition details maintenance')   */
/*********************************************************************/
/*                                                                   */
/*       Midas     PORTFOLIO MANAGEMENT MODULE                       */
/*                                                                   */
/*       PMC0110 - PORTFOLIO DEFINITION MAINTENANCE                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CPB002             Date 28Nov00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01486             Date 01Aug94              */
/*                      049421             DATE  18JAN93             */
/*                      049467             DATE  18JAN93             */
/*                      R00300             DATE  27AUG90             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*       S01486  -  Portfolio Management Upgrade to R10              */
/*       049421  -  HEADER BOX STANDARDISATION                       */
/*       049467  -  RECOMPILED FOR RELEASE 3 PTF 02                  */
/*       R00300  -  Message file changes.                            */
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
/**********  DCL        VAR(&MEM) TYPE(*CHAR) LEN(52) *****/          /*S01486*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01486*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(128)                       /*CPB002*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                         /*CPB002*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')        /*CPB002*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('CAP133')         /*CPB002*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                        /*CPB002*/
             DCL        VAR(&CAP133) TYPE(*CHAR) LEN(1)                       /*CPB002*/
/**/
/* GLOBAL MONITOR MESSAGE                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ENDTAG))
             CHGJOB     SWS(00000000)
                                                                              /*CPB002*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)            /*CPB002*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP133) VALUE('Y'))                            /*CPB002*/
             CALL       PGM(AOMMODR0) PARM('*DBERR ' '*FIRST ' +
                          &MMOD)                                              /*CPB002*/
             IF   COND((%SUBSTRING(&MMOD 104 1) *EQ 'Y') *AND +
                    (&CAP133 *EQ 'Y')) THEN(DO)                               /*CPB002*/
                    CALL PMC0011 ('PMPFDMSIN')                                /*CPB002*/
             ENDDO                                                            /*CPB002*/
             ELSE CMD(DO)                                                     /*CPB002*/
/**/
/* PERFORM FILE OVERRIDES                                            */
/**********  OVRDBF     FILE(PMPORTXX) TOFILE(PMPORTPP) SHARE(*NO)**/ /*S01486*/
/**********  OVRDBF     FILE(PMCHRGXX) TOFILE(PMCHRGPP) SHARE(*NO)**/ /*S01486*/
/**********  OVRDBF     FILE(SDBANKL1) SHARE(*NO)                 **/ /*S01486*/
             OVRDBF     FILE(PMPORTXX) TOFILE(PMPORTPD) SHARE(*NO)    /*S01486*/
             OVRDBF     FILE(PMCHRGXX) TOFILE(PMCHRGPD) SHARE(*NO)    /*S01486*/
/**/
/* CALL MAINTENANCE PROGRAM                                          */
             CALL       PGM(PM0110)
/**/
             DLTOVR     FILE(*ALL)
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)     **/ /*S01486*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01486*/
/*                                                                    /*R00300*/
/****************SNDPGMMSG  MSGID(PEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
**************************TOMSGQ(MOPERQ MRUNQ)                       */
/************    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                    **/ /*S01486*/
                 SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01486*/
/*                                                                    /*R00300*/
             ENDDO
             ENDDO                                                            /*CPB002*/
             GOTO       CMDLBL(END)
/**/
/*  ERROR IN CL PROGRAM  */
 ENDTAG:     DMPCLPGM
/*                                                                   */
/*END:***  ENDPGM                                                  */ /*S01486*/
 END:                                                                 /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01486*/
