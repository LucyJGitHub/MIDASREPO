/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE INTEREST RATE CHANGES NOTICE')               */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*     LEC0705 - INTEREST RATE CHANGE NOTICES                       */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     LAST AMEND NO. S01194             DATE  08FEB90              */
/*     PREV AMEND NO. S01179             DATE  08FEB90              */
/*                NO. S01125             DATE 23/10/86              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*     S01194 - NEW STANDING DATA                                   */
/*     S01179 - AS400 INCORPORATION                                 */
/*     S01125 - LENDING TELEX NOW REDUNDANT                         */
/*                                                                  */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                        VALUE('INTEREST RATE CHANGE NOTICES')
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
/*           DCLDTAARA  DTAARA(MMOD)                                *  *S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
/*PRINT CONFRMATIONS                                                */
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)          */       /*S01194*/
             IF         COND(%SST(&MMOD 36 1) *EQ Y) THEN(DO)
                CHGJOB     SWS(1XXXXXXX)
             ENDDO
/*/COPY WNCPYSRC,LEC0705001                                          */
             CALL       PGM(LE0590)
             IF         COND((%SWITCH(XXXXXX00)) *AND                 +
                        ((%SUBSTRING(&MMOD 36 1)) *EQ Y)) THEN(DO)
                OVRDBF     FILE(TELEXL) TOFILE(LEBRTXL)
                OVRDBF     FILE(TELEX) TOFILE(LEBRTX)
/***************CALL*******PGM(TXC0602)**************/      /*S01125*/
                CLRPFM     FILE(LEBRTX)
             ENDDO
/*********** DLTOVR     FILE(TABLE)                          */       /*S01194*/
/**/
/* CLEAR FILES NO LONGER NEEDED                                      */
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/**/
                CLRPFM     FILE(RATESHH)
                CLRPFM     FILE(RATESRT)
                CLRPFM     FILE(RATESZX)
/**/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
