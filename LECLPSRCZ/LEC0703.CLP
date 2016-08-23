/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE CUSTOMER BILLS AND TELEXES')                 */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*     LEC0703 - CUSTOMER BILLS AND TELEXES                         */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. CLE134           Date 01Aug12               */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 235743           Date 26Aug05               */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      202582           DATE 05Feb02               */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      120000           DATE 23Apr99               */
/*                      CLE004           DATE 02DEC96               */
/*                      S01408           DATE 10APR96               */
/*                      S01194           DATE 08FEB90               */
/*                      S01179           DATE 14/09/88              */
/*                      S01125           DATE 23/10/86              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*     CLE134 - Past Due Call Loan Processing                       */
/*     235743 - Override SCUTXL1 to SCUTXL2.                        */
/*            - Don't clear the CUTX* files.  Applied fix 225103.   */
/*     202582 - LE0541 should be called instead of LE0540 in COB    */
/*              if CLE004 is installed.                             */
/*     120000 - New functionality: It is now possible to call       */
/*              LE0541 in Input Cycle so that the Bills & Telexes   */
/*              from the previous COB can be reprinted.             */
/*     CLE004 - Customer Lending Enhancements - Syndications        */
/*     S01408 - Addition of core hook LEC0703001                    */
/*              Addition of core hook LEC0703INT                    */
/*     S01194 - NEW STANDING DATA                                   */
/*     S01179 - AS400 INCORPORATION                                 */
/*     S01125 - LENDING TELEX NOW REDUNDENT                         */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**********  PGM   */                                                                     /*CLE134*/
             PGM        PARM(&RERUN)                                                      /*CLE134*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) VALUE('CUSTOM+
                          ER BILLS AND TELEXES')
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CLE004*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CLE004*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CLE004*/
             DCL        VAR(&SCSARD)  TYPE(*CHAR) LEN(200)            /*CLE004*/
             DCL        VAR(&CLE004) TYPE(*CHAR) LEN(1)               /*CLE004*/
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(10)                                   /*CLE134*/
             DCL        VAR(&LEPDCL) TYPE(*CHAR) LEN(256)                                 /*CLE134*/
             DCL        VAR(&WCRUN) TYPE(*CHAR) LEN(1)                                    /*CLE134*/
                                                                                          /*CLE134*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                                /*CLE134*/
             RTVDTAARA  DTAARA(LEPDCL) RTNVAR(&LEPDCL)                                    /*CLE134*/
                 IF         COND(%SUBSTRING(&LEPDCL 1 1) *EQ 'N') +
                               THEN(GOTO CMDLBL(ENDPGM))                                  /*CLE134*/
             ENDDO                                                                        /*CLE134*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,LEC0703INT                                   */      /*S01408*/
/**/                                                                  /*S01408*/
/*           DCLDTAARA  DTAARA(MMOD)                                *  *S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/                                                                  /*CLE004*/
/** Access SAR file to determine if switchable feature CLE004     */  /*CLE004*/
/** is switched ON                                                */  /*CLE004*/
/**/                                                                  /*CLE004*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CLE004*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CLE004*/
             CHGVAR     VAR(&SAR) VALUE('CLE004')                     /*CLE004*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CLE004*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CLE004*/
             CHGVAR     VAR(&CLE004) VALUE('Y')                       /*CLE004*/
                ENDDO                                                 /*CLE004*/
/**/
/*PRINT CONFRMATIONS                                                */
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)                  * *S01194*/
             IF         COND(%SST(&MMOD 36 1) *EQ Y) THEN(DO)
                CHGJOB     SWS(X1XXXXXX)
             ENDDO
/*/COPY WNCPYSRC,LEC0703002                                          */
/**********  CALL       PGM(LE0540)                                   /*202582*/
/**********  IF         COND((%SWITCH(XXXXXX00)) *AND                 +
/**********             (&CLE004 *EQ 'Y')) THEN(DO)            /*CLE004 202582*/
/**********  CALL       PGM(LE0541)                            /*CLE004 202582*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*202582*/
                 IF         (&CLE004 *EQ 'Y') THEN(DO)                /*202582*/
                 OVRDBF     FILE(SCUTXL1) TOFILE(SCUTXL2)                                 /*235743*/
                 CALL       PGM(LE0541)                               /*202582*/
                 DLTOVR     FILE(SCUTXL1)                                                 /*235743*/
                 ENDDO                                                /*202582*/
                 ELSE (DO)                                            /*202582*/
                       CALL       PGM(LE0540)                         /*202582*/
                       ENDDO                                          /*202582*/
             ENDDO                                                    /*CLE004*/
             IF         COND((%SWITCH(XXXXXX00)) *AND                 +
                        ((%SUBSTRING(&MMOD 36 1)) *EQ Y)) THEN(DO)
/***************CALL*******PGM(TXC0602)*************/      /*S01125*/
             ENDDO
/*********** DLTOVR     FILE(TABLE)                                  * *S01194*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,LEC0703001                                   */      /*S01408*/
/**/                                                                  /*S01408*/
/**/
/* CLEAR FILES NO LONGER NEEDED                                      */
/**********  IF         COND(%SWITCH(XXXXXXX0)) THEN(DO) */                        /*120000 235743*/
/**/
/**********     CLRPFM     FILE(CUTX1HH) */                                        /*120000 235743*/
/**********     CLRPFM     FILE(CUTX1HN) */                                        /*120000 235743*/
/**********     CLRPFM     FILE(CUTX1HP) */                                        /*120000 235743*/
/**********     CLRPFM     FILE(CUTX1HQ) */                                        /*120000 235743*/
/**********     CLRPFM     FILE(CUTX1ZX) */                                        /*120000 235743*/
/**/
/**********     CLRPFM     FILE(CUTX2HH) */                                        /*120000 235743*/
/**********     CLRPFM     FILE(CUTX2HP) */                                        /*120000 235743*/
/**********     CLRPFM     FILE(CUTX2ZX) */                                        /*120000 235743*/
/**/
/**********     DO                       */                                        /*120000 235743*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**********  ENDPGM       */                                                              /*CLE134*/
ENDPGM:      ENDPGM                                                                       /*CLE134*/
