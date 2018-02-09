/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Past due notcs,rpts & forn tax credits')     */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*     LEC0706 -PAST DUE NOTICES & REPORT & FOREIGN TAX CREDITS     */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1083921          Date 15Feb13              */
/*                      CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01194             Date 08Feb90              */
/*                    S01179             Date  08Feb90              */
/*                NO. S01125             DATE  23/10/86             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*     AR1083921 - Past Due Notices and Past Due Report not          */
/*                 generated even if Report component is M.          */
/*                 Correct the parameter values being passed to      */
/*                 AOSARDR0. The failure here cause the CL program   */
/*                 to end, hence producing no report.                */
/*     CLE134 - Past Due Call Loan Processing                       */
/*     S01194 - NEW STANDING DATA                                   */
/*     S01179 - AS400 INCORPORATION                                 */
/*     S01125 - LENDING TELEX NOW REDUNDENT                         */
/*                                                                  */
/*********************************************************************/
/**********  PGM                                                     */                   /*CLE134*/
             PGM        PARM(&RERUN)                                                      /*CLE134*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                        VALUE('PAST DUE NOTICES, REPORT AND +
                        FOREIGN TAX NOTICES')
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(10)                                   /*CLE134*/
             DCL        VAR(&LEPDCL) TYPE(*CHAR) LEN(256)                                 /*CLE134*/
             DCL        VAR(&SARD)   TYPE(*CHAR) LEN(6)                                   /*CLE134*/
             DCL        VAR(&RTCD)   TYPE(*CHAR) LEN(7)                                   /*CLE134*/
             DCL        VAR(&OPTN)   TYPE(*CHAR) LEN(7)                                   /*CLE134*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CLE134*/
             DCL        VAR(&CLE134) TYPE(*CHAR) LEN(1)                                   /*CLE134*/
                                                                                          /*CLE134*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                                /*CLE134*/
             RTVDTAARA  DTAARA(LEPDCL) RTNVAR(&LEPDCL)                                    /*CLE134*/
                 IF         COND(%SUBSTRING(&LEPDCL 1 1) *EQ 'N') +
                               THEN(GOTO CMDLBL(ENDPGM))                                  /*CLE134*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                    /*AR1083921*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                    /*AR1083921*/
             CHGVAR     VAR(&SARD)  VALUE('CLE134')                                       /*CLE134*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)                     /*CLE134*/
                                                                                          /*CLE134*/
             IF         COND(&RTCD = '       ') +
                           THEN(CHGVAR VAR(&CLE134) VALUE('Y'))                           /*CLE134*/
             IF         COND(&CLE134 *NE 'Y') THEN(GOTO +
                           CMDLBL(ENDPGM))                                                /*CLE134*/
             ENDDO                                                                        /*CLE134*/
/*/COPY WNCPYSRC,LEC0706002                                          */
/*           DCLDTAARA  DTAARA(MMOD)                                *  *S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
/*PRINT                                                             */
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)         */        /*S01194*/
             IF         COND(%SST(&MMOD 36 1) *EQ Y) THEN(DO)
                CHGJOB     SWS(1XXXXXXX)
             ENDDO
/**/
/*/COPY WNCPYSRC,LEC0706001                                          */
/**********  CALL       PGM(LE0600)                                  */                   /*CLE134*/
             CALL       PGM(LE0600) PARM(&RERUN)                                          /*CLE134*/
             IF         COND((%SWITCH(XXXXXX00)) *AND                 +
                        ((%SUBSTRING(&MMOD 36 1)) *EQ Y)) THEN(DO)
                OVRDBF     FILE(TELEXL) TOFILE(LENTTXL)
                OVRDBF     FILE(TELEX) TOFILE(LENTTX)
/***************CALL*******PGM(TXC0602)*************/       /*SO1125*/
                CLRPFM     FILE(LENTTX)
             ENDDO
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
                CALL       PGM(LE0610)
             ENDDO
/**/
/*********** DLTOVR     FILE(TABLE)                      */           /*S01194*/
/*/COPY WNCPYSRC,LEC0706003                                          */
/**/
/* CLEAR FILES NO LONGER NEEDED                                      */
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/**/
                CLRPFM     FILE(PDUEHH)
/*/COPY WNCPYSRC,LEH01370                                            */
                CLRPFM     FILE(PDUEDU)
/*/COPY WNCPYSRC,LEH01371                                            */
                CLRPFM     FILE(PDUEZX)
/*/COPY WNCPYSRC,LEC0706004                                          */
/**/
             ENDDO
ENDPGM:                                                                                   /*CLE134*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
