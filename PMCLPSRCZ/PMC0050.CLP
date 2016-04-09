/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Instrument Groups Maintenance')              */
/*********************************************************************/
/*                                                                   */
/*     Midas PORTFOLIO MANAGEMENT MODULE                         */
/*                                                                   */
/*     PMC0050 - INSTRUMENT GROUPS MAINTENANCE                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     LAST AMEND NO. S01486            DATE  26JUL94                */
/*     PREV AMEND NO. R00300            DATE  27AUG90                */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*     S01486 - Portfolio Management Upgrade to R10                  */
/*     R00300 - Message file changes.                                */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)******/          /*S01486*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01486*/
/**/
/* GLOBAL MONITOR MESSAGE                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ENDTAG))
             CHGJOB     SWS(00000000)
/**/
/* PERFORM FILE OVERRIDES                                            */
/*********** OVRDBF     FILE(PMPGDIXX) TOFILE(PMPGDIPP) SHARE(*NO)**/ /*S01486*/
/*********** OVRDBF     FILE(PMPGHIXX) TOFILE(PMPGHIPP) SHARE(*NO)**/ /*S01486*/
             OVRDBF     FILE(PMPGDIXX) TOFILE(PMPGDIPD) SHARE(*NO)    /*S01486*/
             OVRDBF     FILE(PMPGHIXX) TOFILE(PMPGHIPD) SHARE(*NO)    /*S01486*/
/**/
/* CALL MAINTENANCE PROGRAM                                          */
             CALL       PGM(PM0050)
/**/
             DLTOVR     FILE(*ALL)
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**************  RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)*******/ /*S01486*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01486*/
/*                                                                    /*R00300*/
/****************SNDPGMMSG  MSGID(PEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
**************************TOMSGQ(MOPERQ MRUNQ)                       */
/*************** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                *****/  /*S01486*/
/*                                                                    /*R00300*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01486*/
             ENDDO
             GOTO       CMDLBL(END)
/**/
/*  ERROR IN CL PROGRAM  */
 ENDTAG:     DMPCLPGM
/*                                                                   */
/*END:***  ENDPGM                                                  */ /*S01486*/
 END:                                                                 /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01486*/
