/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UDC - format layout audit report')              */
/*********************************************************************  S37004*/
/*                                                                   */
/*     Midas - Standing Data Module                          */
/*                                                                   */
/*     SDC6813 -  U.D.C.  FORMATS UPDATE AUDIT REPORT.               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     LAST AMEND NO. S01405             DATE 30NOV92                */
/*     PREV AMEND NO. S01390             DATE 22JUN92                *  AUS009*/
/*                    AUS009             DATE 20DEC90                *  AUS009*/
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*     S01405  -  User defined confirmations file names changed.     */
/*     S01390  -  Release 10 Changes for Australianisation           */
/*     AUS009  -  AUSTRALIAN PRODUCT - USER DEFINED CONFIRMATIONS    *  AUS009*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/**/
/************PGM        PARM(&TITLE &DATE &FMTNAME)                  * *S01390*/
             PGM        PARM(&RSEQ &RLVL &RENT &RPARM)                /*S01390*/
/**/
/************DCL        VAR(&TITLE) TYPE(*CHAR) LEN(53)              * *S01390*/
/************DCL        VAR(&DATE) TYPE(*CHAR) LEN(7)                * *S01390*/
             DCL        VAR(&FMTNAME) TYPE(*CHAR) LEN(4)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01390*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01390*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01390*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01390*/
/**/                                                                  /*S01390*/
             CHGVAR     VAR(&FMTNAME) VALUE(%SST(&RPARM 1 4))         /*S01390*/
/**/
/************OVRDBF     FILE(CONFSRC) MBR(&FMTNAME)                     S01405*/
             OVRDBF     FILE(SDUDCSPD) MBR(&FMTNAME)                  /*S01405*/
/**/
/************CALL       PGM(SD6813) PARM(&TITLE &DATE &FMTNAME)      * *S01390*/
             CALL       PGM(SD6813) PARM(&RSEQ &FMTNAME)              /*S01390*/
                  MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC( +
                      SNDPGMMSG MSG('Transaction failed. re-input +
                          necessary. Enter to continue.') TOPGMQ(*EXT))
/**/
/************DLTOVR     FILE(CONFSRC)                                   S01405*/
             DLTOVR     FILE(SDUDCSPD)                                /*S01405*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
