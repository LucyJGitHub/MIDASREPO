/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE DEMAND LOAN INTEREST STATEMENTS')            */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*     LEC0704 - DEMAND LOAN INTEREST STATEMENTS                    */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01194             Date 09Feb90              */
/*                    S01179             Date 14/09/88              */
/*                    S01125             DATE 23/10/86              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*     CLE134 - Past Due Call Loan Processing                       */
/*     S01194 - NEW STANDING DATA                                   */
/*     S01179 - AS400 INCORPORATION                                 */
/*     S01125 - LENDIND TELEX NOW REDUNDENT                         */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**********  PGM  */                                                                      /*CLE134*/
             PGM  PARM(&RERUN)                                                            /*CLE134*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                        VALUE('DEMAND LOAN INTEREST STATEMENTS')
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(10)                                   /*CLE134*/
             DCL        VAR(&LEPDCL) TYPE(*CHAR) LEN(256)                                 /*CLE134*/
                                                                                          /*CLE134*/
/*           DCLDTAARA  DTAARA(MMOD)                                *  *S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
                                                                                          /*CLE134*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                                /*CLE134*/
             RTVDTAARA  DTAARA(LEPDCL) RTNVAR(&LEPDCL)                                    /*CLE134*/
                 IF         COND(%SUBSTRING(&LEPDCL 1 1) *EQ 'N') +
                               THEN(GOTO CMDLBL(ENDPGM))                                  /*CLE134*/
             ENDDO                                                                        /*CLE134*/
/*PRINT CONFRMATIONS                                                */
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)                  * *S01194*/
             IF         COND(%SST(&MMOD 36 1) *EQ Y) THEN(DO)
                CHGJOB     SWS(1XXXXXXX)
             ENDDO
/*/COPY WNCPYSRC,LEC0704001                                          */
             CALL       PGM(LE0630)
             IF         COND((%SWITCH(XXXXXX00)) *AND                 +
                        ((%SUBSTRING(&MMOD 36 1)) *EQ Y)) THEN(DO)
                OVRDBF     FILE(TELEXL) TOFILE(LEINTXL)
                OVRDBF     FILE(TELEX) TOFILE(LEINTX)
/***************CALL*******PGM(TXC0602)*************/      /*S01125*/
                CLRPFM     FILE(LEINTX)
             ENDDO
/*********** DLTOVR     FILE(TABLE)                                  * *S01194*/
/**/
/* CLEAR FILES NO LONGER NEEDED                                      */
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/**/
                CLRPFM     FILE(INTSTHH)
                CLRPFM     FILE(INTSTHN)
                CLRPFM     FILE(INTSTHP)
                CLRPFM     FILE(INTSTHQ)
                CLRPFM     FILE(INTSTZX)
/**/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**********  ENDPGM    */                                                                 /*CLE134*/
ENDPGM:      ENDPGM                                                                       /*CLE134*/
