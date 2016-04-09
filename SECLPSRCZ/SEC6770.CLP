/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Gen. Actions for Ptfr Transfers')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC6770 - Generate Action for Portfolio Transfers           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 100243             DATE 11MAR96              */
/*       PREV AMEND NO. S01496             DATE 24OCT94              */
/*                      S10978             DATE 07APR93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       100243 - Customer depot positions being corrupted.          */
/*       S01496 - Incorporation of Jyske Enhancements (S10978)       */
/*       S10978 - JYSZRH: EARLY REDEMPTIONS                          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)
 
             CHGJOB SWS(00000000)
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
/*********** CLRPFM     FILE(TDPMVD)                               */ /*S01496*/
/*********** CLRPFM     FILE(TTDMVD)                               */ /*S01496*/
             CLRPFM     FILE(SETDPMPD)                                /*S01496*/
             CLRPFM     FILE(SETTDMPD)                                /*S01496*/
             CLRPFM     FILE(SETSTAPD)                                /*100243*/
 
             CALL       PGM(SE6770)
 
/*   FOR DATABASE ERRORS RECOVER DATA FROM LDA */
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********    SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)   +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)           */ /*S01496*/
                SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)              /*S01496*/
                CHGVAR VAR(&MEM) VALUE('SEC6770 - JOB TERMINATED, +
                                        DATABASE IN ERROR')
                SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM
