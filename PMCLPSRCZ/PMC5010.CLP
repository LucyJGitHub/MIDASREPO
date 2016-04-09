/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Pool Portfolio Definition Maintenance')      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC5010 - POOL PORTFOLIO DEFINITION MAINTENANCE             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01486             DATE 23AUG94              */
/*       PREV AMEND NO. 063365             DATE 16NOV93              */
/*                      SA9108             DATE 20OCT93              */
/*                      049421             DATE 18JAN93              */
/*                      SA9108             DATE 18JAN93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01486  -  Private Banking Upgrade to Release 10            */
/*       063365  -  ERROR ON POOL PORTFOLIO POSITION                 */
/*       SA9108  -  POOL TRANSACTIONS SAR                            */
/*       049421  -  HEADER BOX STANDARDISATION                       */
/*       SA9108  -  WRITTEN FOR POOL SECURITIES TRANSACTIONS         */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(2)         /*SA9108*/
             DCL        VAR(&PPT) TYPE(*CHAR) LEN(1)         /*SA9108*/
 
/* GLOBAL ERROR MONITOR TRAP                                */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ENDTAG))
 
/*********** RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIB)     *SA9108* *S01486*/
 /*>>> 063365 >>>*/
/*********** RTVDTAARA  DTAARA((&LIB *CAT 'DMLIB')/LZSTAT (33 1)) +
                          RTNVAR(&PPT)                       /*SA9108  063365 */
/************RTVDTAARA  DTAARA((&LIB *CAT 'DMLIB')/LZSTAT (35 1)) +    *S01486*/
/************             RTNVAR(&PPT)                        *063365* *S01486*/
 /*<<< 063365 <<<*/
 
/************IF         COND(&PPT *NE 'Y') THEN(DO)           *SA9108* *S01486*/
/************SNDPGMMSG  MSG('Pool Portfolios not installed - Option +  *S01486*/
/************             not allowed') TOPGMQ(*EXT)          *SA9108* *S01486*/
/************GOTO       CMDLBL(END)                           *SA9108* *S01486*/
/************ENDDO                                            *SA9108* *S01486*/
 
             CHGJOB     SWS(00000000)
 
/* PERFORM FILE OVERRIDES                                            */
             OVRDBF     FILE(PMPPTDXX) TOFILE(PMPPTDPD) SHARE(*NO)
             OVRDBF     FILE(PMPPTMXX) TOFILE(PMPPTMPD) SHARE(*NO)
 
             CALL       PGM(PM5010)
 
             DLTOVR     FILE(*ALL)
 
/*  DATABASE ERRORS, IF U7 & U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +   *S01486*/
/************             TOMSGQ(MOPERQ MRUNQ)                         *S01486*/
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01486*/
             ENDDO
             GOTO       CMDLBL(END)
 
/*  ERROR IN CL PROGRAM  */
 ENDTAG:     DMPCLPGM
 
/***********END:        ENDPGM                                         *S01486*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01486*/
